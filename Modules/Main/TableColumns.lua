---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants
local L = addon.L

---@class WK_Main_TableColumns
local TableColumns = {}
addon.Main.TableColumns = TableColumns

local Data = addon.Data
local Helpers = addon.Helpers
local TableData = addon.Main.TableData
local LiqUI = addon.libs.LiqUI
local TableForEach = LiqUI.Utils.TableForEach

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showNameColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_NAME"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_NAME"])
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showRealmColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_REALM"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_REALM"])
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showLastUpdateColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_LAST_UPDATE"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_LAST_UPDATE"], nil, nil, nil, true)
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showProfessionColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_PROFESSION"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_PROFESSION"])
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showExpansionColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_EXPANSION"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_EXPANSION"])
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showSkillColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_SKILL"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_SKILL"], nil, nil, nil, true)
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showConcentrationColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TABLE_HEADER_CONCENTRATION"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_CONCENTRATION"])
  GameTooltip:Show()
end

---@param cellFrame Button
---@param _columnIndex integer
---@param _columnId string|nil
---@param _column LiqUI_TableOptionsColumn
local function showKnowledgeColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
  GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
  GameTooltip:SetText(L["TOOLTIP_KNOWLEDGE_TITLE"], 1, 1, 1)
  GameTooltip:AddLine(L["TOOLTIP_KNOWLEDGE"])
  GameTooltip:Show()
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareNameColumn(rowA, rowB)
  return Helpers:CompareCharacterNameRealm(rowA.character, rowB.character) < 0
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareRealmColumn(rowA, rowB)
  return strcmputf8i(rowA.character.realmName or "", rowB.character.realmName or "") < 0
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareLastUpdateColumn(rowA, rowB)
  local lastUpdateA = rowA.character.lastUpdate or 0
  local lastUpdateB = rowB.character.lastUpdate or 0
  return lastUpdateA < lastUpdateB
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
  return rowA.skillLineVariantID < rowB.skillLineVariantID
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
  return rowA.skillLineVariantID < rowB.skillLineVariantID
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareSkillColumn(rowA, rowB)
  local skillLevelA = rowA.characterProfession.skillLevel
  local skillLevelB = rowB.characterProfession.skillLevel
  local sortKeyA = (skillLevelA and skillLevelA > 0) and skillLevelA or -1
  local sortKeyB = (skillLevelB and skillLevelB > 0) and skillLevelB or -1
  if sortKeyA ~= sortKeyB then return sortKeyA < sortKeyB end
  return rowA.skillLineVariantID < rowB.skillLineVariantID
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareMainConcentration(rowA, rowB)
  local estimatedA = TableData.ConcentrationEstimatedForSort(rowA)
  local estimatedB = TableData.ConcentrationEstimatedForSort(rowB)
  if estimatedA ~= estimatedB then return estimatedA < estimatedB end
  return rowA.skillLineVariantID < rowB.skillLineVariantID
end

---@param rowData WK_TableRowData
---@return number
local function totalKnowledgePoints(rowData)
  if not rowData.characterProfession then return 0 end
  return (rowData.characterProfession.knowledgeLevel or 0) + (rowData.characterProfession.knowledgeUnspent or 0)
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareKnowledgeColumn(rowA, rowB)
  local totalA = totalKnowledgePoints(rowA)
  local totalB = totalKnowledgePoints(rowB)
  if totalA ~= totalB then return totalA < totalB end
  return rowA.skillLineVariantID < rowB.skillLineVariantID
end

---@return LiqUI_TableOptionsColumn[]
function TableColumns.GetDefinitions()
  local objectiveCategories = Data:GetObjectiveCategories()

  ---@type LiqUI_TableOptionsColumn[]
  local columns = {
    {
      id = "name",
      headerText = L["TABLE_HEADER_NAME"],
      onEnter = showNameColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 90,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareNameColumn,
      },
    },
    {
      id = "realm",
      headerText = L["TABLE_HEADER_REALM"],
      onEnter = showRealmColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 90,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareRealmColumn,
      },
    },
    {
      id = "lastUpdate",
      headerText = L["TABLE_HEADER_LAST_UPDATE"],
      onEnter = showLastUpdateColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 110,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareLastUpdateColumn,
      },
    },
    {
      id = "profession",
      headerText = L["TABLE_HEADER_PROFESSION"],
      onEnter = showProfessionColumnTooltip,
      onLeave = GameTooltip_Hide,
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
      onEnter = showExpansionColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 120,
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareExpansionColumn,
      },
    },
    {
      id = "skill",
      headerText = L["TABLE_HEADER_SKILL"],
      onEnter = showSkillColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 80,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareSkillColumn,
      },
    },
    {
      id = "concentration",
      headerText = L["TABLE_HEADER_CONCENTRATION"],
      onEnter = showConcentrationColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 100,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareMainConcentration,
      },
    },
    {
      id = "knowledge",
      headerText = L["TABLE_HEADER_KNOWLEDGE"],
      onEnter = showKnowledgeColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 100,
      align = "CENTER",
      hideable = true,
      sorting = {
        enabled = true,
        compare = compareKnowledgeColumn,
      },
    },
  }

  TableForEach(objectiveCategories, function(objectiveCategory)
    if objectiveCategory.id == Constants.objectiveCategory.DarkmoonQuest and not Data.cache.isDarkmoonOpen then
      return
    end

    ---@param cellFrame Button
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _column LiqUI_TableOptionsColumn
    local function showCategoryColumnTooltip(cellFrame, _columnIndex, _columnId, _column)
      GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
      GameTooltip:SetText(objectiveCategory.name, 1, 1, 1)
      GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
      GameTooltip:Show()
    end

    ---@param rowA WK_TableRowData
    ---@param rowB WK_TableRowData
    ---@return boolean
    local function compareCategoryColumn(rowA, rowB)
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
    end

    ---@type LiqUI_TableOptionsColumn
    local dataColumn = {
      id = format("category_%s", tostring(objectiveCategory.id)),
      headerText = objectiveCategory.name,
      onEnter = showCategoryColumnTooltip,
      onLeave = GameTooltip_Hide,
      width = 90,
      hideable = true,
      align = "CENTER",
      sorting = {
        enabled = true,
        compare = compareCategoryColumn,
      },
    }
    table.insert(columns, dataColumn)
  end)

  return columns
end
