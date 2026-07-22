---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants

---@class WK_Checklist_TableColumns
local TableColumns = {}
addon.Checklist.TableColumns = TableColumns

local Data = addon.Data
local Helpers = addon.Helpers
local TableCount = addon.libs.LiqUI.Utils.TableCount

---@param objectiveA WK_Objective
---@param objectiveB WK_Objective
---@return boolean
local function checklistObjectiveIdentityLess(objectiveA, objectiveB)
  local categoryIdTextA = tostring(objectiveA.categoryID or "")
  local categoryIdTextB = tostring(objectiveB.categoryID or "")
  if categoryIdTextA ~= categoryIdTextB then return categoryIdTextA < categoryIdTextB end
  local questIdA = (objectiveA.quests and objectiveA.quests[1]) or 0
  local questIdB = (objectiveB.quests and objectiveB.quests[1]) or 0
  if questIdA ~= questIdB then return questIdA < questIdB end
  local spellIdA = objectiveA.spellID or 0
  local spellIdB = objectiveB.spellID or 0
  if spellIdA ~= spellIdB then return spellIdA < spellIdB end
  return (objectiveA.itemID or 0) < (objectiveB.itemID or 0)
end

---@param row LiqUI_TableDataRowExtended
---@return string
local function checklistObjectiveRowSortText(row)
  local objective = row.objective
  if not objective then
    return ""
  end
  if objective.itemID and objective.itemID > 0 then
    local itemName = C_Item.GetItemInfo(objective.itemID)
    if itemName then
      return itemName
    end
    return format("Error: ItemID %d not found", objective.itemID or "?")
  end
  if objective.categoryID == Constants.objectiveCategory.FirstCraft then
    local recipeInfo = Data.cache.tradeSkillRecipes and Data.cache.tradeSkillRecipes[objective.spellID]
    if not recipeInfo then
      recipeInfo = C_TradeSkillUI.GetRecipeInfo(objective.spellID)
      if recipeInfo then
        if not Data.cache.tradeSkillRecipes then
          Data.cache.tradeSkillRecipes = {}
        end
        Data.cache.tradeSkillRecipes[objective.spellID] = recipeInfo
      end
    end
    if recipeInfo and recipeInfo.name then
      return recipeInfo.name
    end
    return format("Error: RecipeID %d not found", objective.spellID or "?")
  end
  if objective.quests and TableCount(objective.quests) > 0 then
    local link = format("quest:%d:-1", objective.quests[1])
    local questTooltipData = C_TooltipInfo.GetHyperlink(link)
    if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
      return questTooltipData.lines[1].leftText
    end
    return format("Error: QuestID %d not found", objective.quests[1] or "?")
  end
  return "Unknown"
end

---@return LiqUI_TableOptionsColumn[]
function TableColumns.GetDefinitions()
  ---@type LiqUI_TableOptionsColumn[]
  local columns = {
    {
      id = "objective",
      headerText = "Objective",
      width = 260,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local skillLineVariantA = rowA.skillLineVariantID or 0
          local skillLineVariantB = rowB.skillLineVariantID or 0
          if skillLineVariantA ~= skillLineVariantB then return skillLineVariantA < skillLineVariantB end
          local labelCompare = strcmputf8i(checklistObjectiveRowSortText(rowA), checklistObjectiveRowSortText(rowB))
          if labelCompare ~= 0 then return labelCompare < 0 end
          local objectiveA, objectiveB = rowA.objective, rowB.objective
          if not objectiveA or not objectiveB then return false end
          return checklistObjectiveIdentityLess(objectiveA, objectiveB)
        end,
      },
    },
    {
      id = "profession",
      headerText = "Profession",
      width = Data.db.global.showFullProfessionName and 160 or 100,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local function skillLineNameLower(rowData)
            local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
            local skillLine = variant and Data:GetSkillLineByID(variant.skillLineID or 0)
            return skillLine and skillLine.name:lower() or ""
          end
          local nameA, nameB = skillLineNameLower(rowA), skillLineNameLower(rowB)
          if nameA ~= nameB then return nameA < nameB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "expansion",
      headerText = "Expansion",
      width = 120,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local function expansionNameLower(rowData)
            local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
            local expansion = variant and Data:GetExpansionByID(variant.expansionID)
            return expansion and expansion.name:lower() or ""
          end
          local nameA, nameB = expansionNameLower(rowA), expansionNameLower(rowB)
          if nameA ~= nameB then return nameA < nameB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "category",
      headerText = "Category",
      width = 80,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local function categoryNameLower(rowData)
            local objectiveCategory = Data:GetObjectiveCategoryByID(rowData.objective.categoryID)
            return objectiveCategory and objectiveCategory.name:lower() or ""
          end
          local nameA, nameB = categoryNameLower(rowA), categoryNameLower(rowB)
          if nameA ~= nameB then return nameA < nameB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "location",
      headerText = "Location",
      width = 100,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local mapIdA = rowA.objective.loc and rowA.objective.loc.m or 0
          local mapIdB = rowB.objective.loc and rowB.objective.loc.m or 0
          if mapIdA ~= mapIdB then return mapIdA < mapIdB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "repeatable",
      headerText = "Repeat?",
      width = 60,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local function repeatableLabel(rowData)
            local objectiveCategory = Data:GetObjectiveCategoryByID(rowData.objective.categoryID)
            return objectiveCategory and objectiveCategory.repeatable or ""
          end
          local labelA, labelB = repeatableLabel(rowA), repeatableLabel(rowB)
          if labelA ~= labelB then return labelA < labelB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "progress",
      headerText = "Progress",
      width = 70,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local questsCompletedA = rowA.progress and (rowA.progress.questsCompleted or 0) or 0
          local questsCompletedB = rowB.progress and (rowB.progress.questsCompleted or 0) or 0
          if questsCompletedA ~= questsCompletedB then return questsCompletedA < questsCompletedB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "points",
      headerText = "Points",
      width = 70,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local pointsEarnedA = rowA.progress and (rowA.progress.pointsEarned or 0) or 0
          local pointsEarnedB = rowB.progress and (rowB.progress.pointsEarned or 0) or 0
          if pointsEarnedA ~= pointsEarnedB then return pointsEarnedA < pointsEarnedB end
          if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
            return rowA.skillLineVariantID < rowB.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "waypoint",
      headerText = "",
      width = 50,
      align = "CENTER",
      sorting = {
        enabled = false,
      },
    },
  }

  return columns
end
