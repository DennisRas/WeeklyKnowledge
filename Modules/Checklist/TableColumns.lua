---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants
local L = addon.L

---@class WK_Checklist_TableColumns
local TableColumns = {}
addon.Checklist.TableColumns = TableColumns

local Data = addon.Data
local Helpers = addon.Helpers
local LiqUI = addon.libs.LiqUI
local TableCount = LiqUI.Utils.TableCount

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

---@param row WK_TableRowData
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
    local spellID = objective.spellID
    if not spellID then
      return "Error: RecipeID not found"
    end
    local recipeInfo = Data.cache.tradeSkillRecipes and Data.cache.tradeSkillRecipes[spellID]
    if not recipeInfo then
      recipeInfo = C_TradeSkillUI.GetRecipeInfo(spellID)
      if recipeInfo then
        if not Data.cache.tradeSkillRecipes then
          Data.cache.tradeSkillRecipes = {}
        end
        Data.cache.tradeSkillRecipes[spellID] = recipeInfo
      end
    end
    if recipeInfo and recipeInfo.name then
      return recipeInfo.name
    end
    return format("Error: RecipeID %d not found", spellID)
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

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareChecklistObjective(rowA, rowB)
  local skillLineVariantA = rowA.skillLineVariantID or 0
  local skillLineVariantB = rowB.skillLineVariantID or 0
  if skillLineVariantA ~= skillLineVariantB then return skillLineVariantA < skillLineVariantB end
  local labelCompare = strcmputf8i(checklistObjectiveRowSortText(rowA), checklistObjectiveRowSortText(rowB))
  if labelCompare ~= 0 then return labelCompare < 0 end
  local objectiveA, objectiveB = rowA.objective, rowB.objective
  if not objectiveA or not objectiveB then return false end
  return checklistObjectiveIdentityLess(objectiveA, objectiveB)
end

---@param rowData WK_TableRowData
---@return string
local function professionSortName(rowData)
  local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
  if not variant then
    return ""
  end
  local skillLine = Data:GetSkillLineByID(variant.skillLineID)
  if not skillLine then
    return ""
  end
  return Data:GetSkillLineDisplayName(skillLine):lower()
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareProfessionColumn(rowA, rowB)
  local nameA = professionSortName(rowA)
  local nameB = professionSortName(rowB)
  if nameA ~= nameB then return nameA < nameB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param rowData WK_TableRowData
---@return string
local function expansionSortName(rowData)
  local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
  if not variant then
    return ""
  end
  local expansion = LiqUI.Data:GetExpansionByID(variant.expansionID)
  if not expansion then
    return ""
  end
  return Data:GetExpansionDisplayName(expansion):lower()
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareExpansionColumn(rowA, rowB)
  local nameA = expansionSortName(rowA)
  local nameB = expansionSortName(rowB)
  if nameA ~= nameB then return nameA < nameB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param rowData WK_TableRowData
---@return string
local function categorySortName(rowData)
  local objective = rowData.objective
  if not objective then
    return ""
  end
  local objectiveCategory = Data:GetObjectiveCategoryByID(objective.categoryID)
  if not objectiveCategory then
    return ""
  end
  return objectiveCategory.name:lower()
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareCategoryColumn(rowA, rowB)
  local nameA = categorySortName(rowA)
  local nameB = categorySortName(rowB)
  if nameA ~= nameB then return nameA < nameB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param row WK_TableRowData
---@return number
local function locationMapID(row)
  local objective = row.objective
  if not objective then
    return 0
  end
  local loc = objective.loc
  if not loc then
    return 0
  end
  local mapID = loc.m
  if not mapID then
    return 0
  end
  return mapID
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareLocationColumn(rowA, rowB)
  local mapIdA = locationMapID(rowA)
  local mapIdB = locationMapID(rowB)
  if mapIdA ~= mapIdB then return mapIdA < mapIdB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param rowData WK_TableRowData
---@return string
local function repeatableLabel(rowData)
  local objective = rowData.objective
  if not objective then
    return ""
  end
  local objectiveCategory = Data:GetObjectiveCategoryByID(objective.categoryID)
  if not objectiveCategory then
    return ""
  end
  return Data:GetRepeatableDisplayName(objectiveCategory.repeatable)
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareRepeatableColumn(rowA, rowB)
  local labelA = repeatableLabel(rowA)
  local labelB = repeatableLabel(rowB)
  if labelA ~= labelB then return labelA < labelB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param row WK_TableRowData
---@return number
local function questsCompletedForSort(row)
  local progress = row.progress
  if not progress then
    return 0
  end
  return progress.questsCompleted or 0
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareProgressColumn(rowA, rowB)
  local questsCompletedA = questsCompletedForSort(rowA)
  local questsCompletedB = questsCompletedForSort(rowB)
  if questsCompletedA ~= questsCompletedB then return questsCompletedA < questsCompletedB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param row WK_TableRowData
---@return number
local function pointsEarnedForSort(row)
  local progress = row.progress
  if not progress then
    return 0
  end
  return progress.pointsEarned or 0
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function comparePointsColumn(rowA, rowB)
  local pointsEarnedA = pointsEarnedForSort(rowA)
  local pointsEarnedB = pointsEarnedForSort(rowB)
  if pointsEarnedA ~= pointsEarnedB then return pointsEarnedA < pointsEarnedB end
  if rowA.skillLineVariantID ~= rowB.skillLineVariantID then
    return rowA.skillLineVariantID < rowB.skillLineVariantID
  end
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@return LiqUI_TableOptionsColumn[]
function TableColumns.GetDefinitions()
  ---@type LiqUI_TableOptionsColumn[]
  local columns = {
    {
      id = "objective",
      headerText = L["TABLE_HEADER_OBJECTIVE"],
      width = 260,
      sorting = {
        enabled = true,
        compare = compareChecklistObjective,
      },
    },
    {
      id = "profession",
      headerText = L["TABLE_HEADER_PROFESSION"],
      width = Data.db.global.showFullProfessionName and 160 or 100,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareProfessionColumn,
      },
    },
    {
      id = "expansion",
      headerText = L["TABLE_HEADER_EXPANSION"],
      width = 120,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareExpansionColumn,
      },
    },
    {
      id = "category",
      headerText = L["TABLE_HEADER_CATEGORY"],
      width = 80,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareCategoryColumn,
      },
    },
    {
      id = "location",
      headerText = L["TABLE_HEADER_LOCATION"],
      width = 100,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareLocationColumn,
      },
    },
    {
      id = "repeatable",
      headerText = L["TABLE_HEADER_REPEATABLE"],
      width = 60,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareRepeatableColumn,
      },
    },
    {
      id = "progress",
      headerText = L["TABLE_HEADER_PROGRESS"],
      width = 70,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareProgressColumn,
      },
    },
    {
      id = "points",
      headerText = L["TABLE_HEADER_POINTS"],
      width = 70,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = comparePointsColumn,
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
