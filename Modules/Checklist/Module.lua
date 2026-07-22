---@class WK_Addon
local addon = select(2, ...)

---@class WK_Checklist
local Checklist = {}
addon.Checklist = Checklist

local Main = addon.Main
local Constants = addon.Constants
local Data = addon.Data
local LibLiqUI = addon.libs.LiqUI
local TableContains = LibLiqUI.Utils.TableContains
local TableCount = LibLiqUI.Utils.TableCount
local TableFilter = LibLiqUI.Utils.TableFilter
local TableForEach = LibLiqUI.Utils.TableForEach
local TableToggle = LibLiqUI.Utils.TableToggle

---@param objectiveA table
---@param objectiveB table
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

function Checklist:ToggleWindow()
  if not self.window then return end
  if self.window:IsVisible() then
    self.window:Hide()
  else
    if Data.cache.inCombat then return end
    self.window:Show()
  end
  Data.db.global.checklist.open = self.window:IsVisible()
  self:Render()
end

function Checklist:Render()
  local character = Data:GetCharacter()
  ---@type WK_TableRowData[]
  local rows = {}

  if not self.window then
    local mediaPath = "Interface/AddOns/WeeklyKnowledge/Media/"
    self.window = addon.LiqUI.Window:New({
      name = "Checklist",
      title = "Checklist",
      icon = mediaPath .. "Icon.blp",
      border = 4,
      overlayFontObject = "SystemFont_Med1",
      onClose = function()
        Data.db.global.checklist.open = false
      end,
      onSettingsMenu = function(window, rootMenu)
        local showFullProfessionName = rootMenu:CreateCheckbox(
          "Show full profession name",
          function() return Data.db.global.showFullProfessionName end,
          function()
            Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
            self:ApplyTableColumns()
            self:Render()
            Main:ApplyTableColumns()
            Main:Render()
          end
        )
        showFullProfessionName:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
          GameTooltip_AddNormalLine(tooltip, "Show the full profession name with the expansion variant.")
        end)

        rootMenu:CreateCheckbox(
          "Hide in combat",
          function() return Data.db.global.checklist.hideInCombat end,
          function()
            Data.db.global.checklist.hideInCombat = not Data.db.global.checklist.hideInCombat
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide in dungeons",
          function() return Data.db.global.checklist.hideInDungeons end,
          function()
            Data.db.global.checklist.hideInDungeons = not Data.db.global.checklist.hideInDungeons
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide completed objectives",
          function() return Data.db.global.checklist.hideCompletedObjectives end,
          function()
            Data.db.global.checklist.hideCompletedObjectives = not Data.db.global.checklist.hideCompletedObjectives
            self:Render()
          end
        )
      end,
      titlebarButtons = {
        {
          name = "Expansion",
          icon = mediaPath .. "Icon_House.blp",
          iconSize = 14,
          tooltipTitle = "Expansion",
          tooltipDescription = "Filter table by expansion.",
          onMenu = function(_, rootMenu)
            TableForEach(Data:GetExpansions(), function(expansion)
              rootMenu:CreateCheckbox(
                expansion.name,
                function() return TableContains(Data.db.global.checklist.selectedExpansions, expansion.id) end,
                function()
                  Data.db.global.checklist.selectedExpansions = TableToggle(Data.db.global.checklist.selectedExpansions, expansion.id)
                  self:Render()
                end,
                expansion.id
              )
            end)
          end,
        },
        {
          name = "Columns",
          icon = mediaPath .. "Icon_Columns.blp",
          tooltipTitle = "Columns",
          tooltipDescription = "Toggle columns.",
          onMenu = function(_, rootMenu)
            local hidden = self.window.table.db.hiddenColumns
            TableForEach(self:GetColumnDefinitions(), function(column)
              if not column.hideable then return end
              rootMenu:CreateCheckbox(
                column.headerText,
                function() return not hidden[column.id] end,
                function(id)
                  hidden[id] = not hidden[id]
                  self:Render()
                end,
                column.id
              )
            end)
          end,
        },
        {
          name = "Categories",
          icon = mediaPath .. "Icon_Category.blp",
          iconSize = 11,
          tooltipTitle = "Categories",
          tooltipDescription = "Toggle categories.",
          onMenu = function(_, rootMenu)
            local hidden = Data.db.global.checklist.hiddenCategories
            TableForEach(Data.ObjectiveCategories, function(category)
              rootMenu:CreateCheckbox(
                category.name,
                function() return not hidden[category.id] end,
                function(categoryID)
                  hidden[categoryID] = not hidden[categoryID]
                  self:Render()
                end,
                category.id
              )
            end)
          end,
        },
        {
          name = "Toggle",
          icon = mediaPath .. "Icon_Toggle.blp",
          iconSize = 16,
          tooltipTitle = "Toggle List",
          tooltipDescription = "Expand/Collapse the checklist.",
          onClick = function()
            Data.db.global.checklist.hideTable = not Data.db.global.checklist.hideTable
            self:Render()
          end,
        },
      },
    })
    self.window:SetFrameLevel(8100)

    ---@type LiqUI_TableOptions
    local tableConfig = {
      name = "Checklist",
      header = {
        enabled = true,
        sticky = true,
        height = Constants.TABLE_HEADER_HEIGHT,
      },
      rowStyle = {
        height = Constants.TABLE_ROW_HEIGHT,
        highlight = true,
        striped = true,
      },
      cellStyle = {
        padding = Constants.TABLE_CELL_PADDING,
      },
      sorting = {
        enabled = true,
        defaultOrder = "desc",
        defaultCompare = function(rowA, rowB)
          if not rowA or not rowB then return false end
          local progressA, progressB = rowA.progress, rowB.progress
          local questsCompletedA = progressA and (progressA.questsCompleted or 0) or 0
          local questsCompletedB = progressB and (progressB.questsCompleted or 0) or 0
          if questsCompletedA ~= questsCompletedB then
            return questsCompletedA > questsCompletedB
          end
          local pointsEarnedA = progressA and (progressA.pointsEarned or 0) or 0
          local pointsEarnedB = progressB and (progressB.pointsEarned or 0) or 0
          if pointsEarnedA ~= pointsEarnedB then
            return pointsEarnedA > pointsEarnedB
          end
          local labelCompare = strcmputf8i(checklistObjectiveRowSortText(rowA), checklistObjectiveRowSortText(rowB))
          if labelCompare ~= 0 then
            return labelCompare < 0
          end
          local objectiveA, objectiveB = rowA.objective, rowB.objective
          if not objectiveA or not objectiveB then return false end
          return checklistObjectiveIdentityLess(objectiveA, objectiveB)
        end,
      },
      columns = self:GetColumnDefinitions(),
    }
    self.window.table = addon.LiqUI.Table:New(tableConfig)
    self.window.table:SetParent(self.window.body)
    self.window.table:SetPoint("TOPLEFT", self.window.body, "TOPLEFT", 0, 0)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window.body, "BOTTOMRIGHT", 0, 0)
  end

  if not character then
    self.window:Hide()
    return
  end

  -- Quick hotfix to avoid excessive rendering
  if (not self.window:IsVisible() and not Data.db.global.checklist.open) or (Data.cache.inCombat and Data.db.global.checklist.hideInCombat) then
    self.window:Hide()
    return
  end

  local characterProfessions = character.professions

  local rowCount = 0
  local objectives = Data:GetObjectives()
  local selectedExpansions = Data.db.global.checklist.selectedExpansions or {}

  do -- Table data
    TableForEach(characterProfessions, function(characterProfession)
      local skillLineVariantID = characterProfession.skillLineVariantID
      local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
      if not skillLineVariant then return end

      if TableCount(selectedExpansions) > 0 and not TableContains(selectedExpansions, skillLineVariant.expansionID) then
        return
      end
      local filteredObjectives = TableFilter(objectives, function(objective)
        if objective.skillLineVariantID ~= skillLineVariantID then
          return false
        end

        if not Data.cache.isDarkmoonOpen and objective.categoryID == Constants.objectiveCategory.DarkmoonQuest then
          return false
        end

        local hiddenCategories = Data.db.global.checklist.hiddenCategories
        if hiddenCategories and hiddenCategories[objective.categoryID] then
          return false
        end

        if Data.db.global.checklist.hideUniqueObjectives and objective.categoryID == Constants.objectiveCategory.Unique then
          return false
        end

        if Data.db.global.checklist.hideUniqueVendorObjectives and objective.categoryID == Constants.objectiveCategory.Unique and objective.requires and TableCount(objective.requires) > 0 then
          return false
        end

        if Data.db.global.checklist.hideCatchUpObjectives and objective.categoryID == Constants.objectiveCategory.CatchUp then
          return false
        end

        return true
      end)
      TableForEach(filteredObjectives, function(objective)
        local progress = Data:GetObjectiveProgress(character, objective)

        if Data.db.global.checklist.hideCompletedObjectives and progress.questsCompleted == progress.questsTotal then
          return
        end

        table.insert(rows, addon.Checklist.TableData.BuildRow(character, characterProfession, objective, progress))
        rowCount = rowCount + 1
      end)
    end)
  end

  self.window.table:SetData(rows)

  local minWindowWidth = 200
  local maxBodyHeight = 300 - Constants.TITLEBAR_HEIGHT
  local emptyBodyHeight = 200 - Constants.TITLEBAR_HEIGHT

  if Data.db.global.checklist.hideTable then
    self.window.table:Hide()
    self.window:HideOverlay()
    self.window:SetBodySize(minWindowWidth, 0)
  elseif rowCount == 0 then
    self.window:ShowOverlay("It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or category above?\n\nIf this is your first time using this addon then make sure to open your professions at least once.")
    self.window.table:Hide()
    self.window:SetBodySize(minWindowWidth, emptyBodyHeight)
  else
    self.window:HideOverlay()
    self.window.table:Show()
    local bodyWidth, bodyHeight = self.window.table:GetSize()
    bodyWidth = math.max(bodyWidth, minWindowWidth)
    bodyHeight = math.min(bodyHeight, maxBodyHeight)
    self.window:SetBodySize(bodyWidth, bodyHeight)
  end

  self.window:SetShown(Data.db.global.checklist.open)
  if self.window.titlebar then
    self.window.titlebar:SetShown(Data.db.global.checklist.windowTitlebar)
  end
  if Data.cache.inCombat and Data.db.global.checklist.hideInCombat then
    self.window:Hide()
  end
end

function Checklist:ApplyTableColumns()
  if not self.window or not self.window.table then
    return
  end
  self.window.table:SetColumns(self:GetColumnDefinitions())
end

---@return LiqUI_TableOptionsColumn[]
function Checklist:GetColumnDefinitions()
  return addon.Checklist.TableColumns.GetDefinitions()
end
