---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants

---@class WK_Main_TableColumns
local TableColumns = {}
addon.Main.TableColumns = TableColumns

local Data = addon.Data
local Helpers = addon.Helpers
local TableData = addon.Main.TableData
local TableForEach = addon.libs.LiqUI.Utils.TableForEach

---@return LiqUI_TableOptionsColumn[]
function TableColumns.GetDefinitions()
  local objectiveCategories = Data:GetObjectiveCategories()

  ---@type LiqUI_TableOptionsColumn[]
  local columns = {
    {
      id = "name",
      headerText = "Name",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Name", 1, 1, 1)
        GameTooltip:AddLine("Your characters.")
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 90,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
        end,
      },
    },
    {
      id = "realm",
      headerText = "Realm",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Realm", 1, 1, 1)
        GameTooltip:AddLine("Realm names.")
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 90,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          return strcmputf8i(rowA.character.realmName or "", rowB.character.realmName or "") < 0
        end,
      },
    },
    {
      id = "lastUpdate",
      headerText = "Last Update",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Last Update", 1, 1, 1)
        GameTooltip:AddLine("The last time data was saved for this character.", nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 110,
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local lastUpdateA = rowA.character.lastUpdate or 0
          local lastUpdateB = rowB.character.lastUpdate or 0
          return lastUpdateA < lastUpdateB
        end,
      },
    },
    {
      id = "profession",
      headerText = "Profession",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Profession", 1, 1, 1)
        GameTooltip:AddLine("Your professions.")
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
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
          return rowA.skillLineVariantID < rowB.skillLineVariantID
        end,
      },
    },
    {
      id = "expansion",
      headerText = "Expansion",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Expansion", 1, 1, 1)
        GameTooltip:AddLine("Expansion for this profession row.")
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
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
          return rowA.skillLineVariantID < rowB.skillLineVariantID
        end,
      },
    },
    {
      id = "skill",
      headerText = "Skill",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Skill", 1, 1, 1)
        GameTooltip:AddLine("Current skill levels.\n\nNote: This is only updated when you open the profession window or craft a recipe.", nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 80,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local skillLevelA = rowA.characterProfession.skillLevel
          local skillLevelB = rowB.characterProfession.skillLevel
          local sortKeyA = (skillLevelA and skillLevelA > 0) and skillLevelA or -1
          local sortKeyB = (skillLevelB and skillLevelB > 0) and skillLevelB or -1
          if sortKeyA ~= sortKeyB then return sortKeyA < sortKeyB end
          return rowA.skillLineVariantID < rowB.skillLineVariantID
        end,
      },
    },
    {
      id = "concentration",
      headerText = "Concentration",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Concentration", 1, 1, 1)
        GameTooltip:AddLine("Current concentration.")
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local estimatedA = TableData.ConcentrationEstimatedForSort(rowA)
          local estimatedB = TableData.ConcentrationEstimatedForSort(rowB)
          if estimatedA ~= estimatedB then return estimatedA < estimatedB end
          return rowA.skillLineVariantID < rowB.skillLineVariantID
        end,
      },
    },
    {
      id = "knowledge",
      headerText = "Knowledge",
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Knowledge Points", 1, 1, 1)
        GameTooltip:AddLine("Current knowledge gained.")
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local function totalKnowledgePoints(rowData)
            if not rowData.characterProfession then return 0 end
            return (rowData.characterProfession.knowledgeLevel or 0) + (rowData.characterProfession.knowledgeUnspent or 0)
          end
          local totalA, totalB = totalKnowledgePoints(rowA), totalKnowledgePoints(rowB)
          if totalA ~= totalB then return totalA < totalB end
          return rowA.skillLineVariantID < rowB.skillLineVariantID
        end,
      },
    },
  }

  TableForEach(objectiveCategories, function(objectiveCategory)
    if objectiveCategory.id == Constants.objectiveCategory.DarkmoonQuest and not Data.cache.isDarkmoonOpen then
      return
    end

    ---@type LiqUI_TableOptionsColumn
    local dataColumn = {
      id = format("category_%s", tostring(objectiveCategory.id)),
      headerText = objectiveCategory.name,
      onEnter = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(objectiveCategory.name, 1, 1, 1)
        GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, columnIndex, columnId, column)
        GameTooltip:Hide()
      end,
      width = 90,
      hideable = true,
      align = "CENTER",
      sorting = {
        enabled = true,
        compare = function(rowA, rowB)
          local progressA = Data:GetCategoryProfessionProgress(rowA.character, objectiveCategory, rowA.characterProfession)
          local progressB = Data:GetCategoryProfessionProgress(rowB.character, objectiveCategory, rowB.characterProfession)
          if not progressA and not progressB then return false end
          if not progressA then return true end
          if not progressB then return false end
          if objectiveCategory.id == Constants.objectiveCategory.CatchUp then
            local pointsEarnedA = progressA.pointsEarned or 0
            local pointsEarnedB = progressB.pointsEarned or 0
            if pointsEarnedA ~= pointsEarnedB then return pointsEarnedA < pointsEarnedB end
          else
            local objectivesCompletedA = progressA.objectivesCompleted or 0
            local objectivesCompletedB = progressB.objectivesCompleted or 0
            if objectivesCompletedA ~= objectivesCompletedB then return objectivesCompletedA < objectivesCompletedB end
          end
          return rowA.skillLineVariantID < rowB.skillLineVariantID
        end,
      },
    }
    table.insert(columns, dataColumn)
  end)

  return columns
end
