---@class WK_Addon
local addon = select(2, ...)

---@class WK_Checklist
local Checklist = {}
addon.Checklist = Checklist

local Main = addon.Main
local Constants = addon.Constants
local L = addon.L
local Data = addon.Data
local LiqUI = addon.libs.LiqUI
local TableContains = LiqUI.Utils.TableContains
local TableCount = LiqUI.Utils.TableCount
local TableFilter = LiqUI.Utils.TableFilter
local TableForEach = LiqUI.Utils.TableForEach
local TableToggle = LiqUI.Utils.TableToggle

---@param tooltip GameTooltip
---@param elementDescription ElementMenuDescriptionProxy
local function showFullProfessionNameTooltip(tooltip, elementDescription)
  GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
  GameTooltip_AddNormalLine(tooltip, L["SETTING_SHOW_FULL_PROFESSION_NAME_TOOLTIP"])
end

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
local function compareChecklistDefault(rowA, rowB)
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
    local windows = Data.db.global.liqui.windows
    local tables = Data.db.global.liqui.tables

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onChecklistSettingsMenu(_window, rootMenu)
      ---@type ElementMenuDescriptionProxy
      local showFullProfessionName = rootMenu:CreateCheckbox(
        L["SETTING_SHOW_FULL_PROFESSION_NAME"],
        function() return Data.db.global.showFullProfessionName == true end,
        function()
          Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
          self:ApplyTableColumns()
          self:Render()
          Main:ApplyTableColumns()
          Main:Render()
        end
      )
      showFullProfessionName:SetTooltip(showFullProfessionNameTooltip)

      rootMenu:CreateCheckbox(
        L["SETTING_HIDE_IN_COMBAT"],
        function() return Data.db.global.checklist.hideInCombat end,
        function()
          Data.db.global.checklist.hideInCombat = not Data.db.global.checklist.hideInCombat
          self:Render()
        end
      )
      rootMenu:CreateCheckbox(
        L["SETTING_HIDE_IN_DUNGEONS"],
        function() return Data.db.global.checklist.hideInDungeons end,
        function()
          Data.db.global.checklist.hideInDungeons = not Data.db.global.checklist.hideInDungeons
          self:Render()
        end
      )
      rootMenu:CreateCheckbox(
        L["SETTING_HIDE_COMPLETED_OBJECTIVES"],
        function() return Data.db.global.checklist.hideCompletedObjectives end,
        function()
          Data.db.global.checklist.hideCompletedObjectives = not Data.db.global.checklist.hideCompletedObjectives
          self:Render()
        end
      )
    end

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onExpansionMenu(_window, rootMenu)
      TableForEach(Data:GetExpansions(), function(expansion)
        rootMenu:CreateCheckbox(
          Data:GetExpansionDisplayName(expansion),
          function() return TableContains(Data.db.global.checklist.selectedExpansions, expansion.id) end,
          function()
            Data.db.global.checklist.selectedExpansions = TableToggle(Data.db.global.checklist.selectedExpansions, expansion.id)
            self:Render()
          end,
          expansion.id
        )
      end)
    end

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onColumnsMenu(_window, rootMenu)
      local window = self.window
      if not window then
        return
      end
      local tableFrame = window.table
      if not tableFrame then
        return
      end
      local hidden = tableFrame.db.hiddenColumns
      ---@param columnID string
      local function toggleColumnHidden(columnID)
        hidden[columnID] = not hidden[columnID]
        self:Render()
      end
      TableForEach(self:GetColumnDefinitions(), function(column)
        if not column.hideable then return end
        local headerText = column.headerText
        if not headerText then return end
        rootMenu:CreateCheckbox(
          headerText,
          function() return not hidden[column.id] end,
          toggleColumnHidden,
          column.id
        )
      end)
    end

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onCategoriesMenu(_window, rootMenu)
      local hidden = Data.db.global.checklist.hiddenCategories
      ---@param categoryID WK_ObjectiveCategoryId
      local function toggleCategoryHidden(categoryID)
        hidden[categoryID] = not hidden[categoryID]
        self:Render()
      end
      TableForEach(Data.ObjectiveCategories, function(category)
        rootMenu:CreateCheckbox(
          category.name,
          function() return not hidden[category.id] end,
          toggleCategoryHidden,
          category.id
        )
      end)
    end

    local function closeChecklistWindow()
      Data.db.global.checklist.open = false
    end

    local function toggleChecklistTable()
      Data.db.global.checklist.hideTable = not Data.db.global.checklist.hideTable
      self:Render()
    end

    ---@type LiqUI_WindowOptions
    local windowOptions = {
      name = addon.name .. "Checklist",
      storage = windows.Checklist,
      title = L["TITLE_CHECKLIST"],
      icon = mediaPath .. "Icon.blp",
      border = 4,
      overlayFontObject = "SystemFont_Med1",
      onClose = closeChecklistWindow,
      onSettingsMenu = onChecklistSettingsMenu,
      titlebarButtons = {
        {
          name = "Expansion",
          icon = mediaPath .. "Icon_House.blp",
          iconSize = 14,
          tooltipTitle = L["TABLE_HEADER_EXPANSION"],
          tooltipDescription = L["TITLEBAR_EXPANSION_CHECKLIST_TOOLTIP"],
          onMenu = onExpansionMenu,
        },
        {
          name = "Columns",
          icon = mediaPath .. "Icon_Columns.blp",
          tooltipTitle = L["TITLEBAR_COLUMNS"],
          tooltipDescription = L["TITLEBAR_COLUMNS_CHECKLIST_TOOLTIP"],
          onMenu = onColumnsMenu,
        },
        {
          name = "Categories",
          icon = mediaPath .. "Icon_Category.blp",
          iconSize = 11,
          tooltipTitle = L["TITLEBAR_CATEGORIES"],
          tooltipDescription = L["TITLEBAR_CATEGORIES_TOOLTIP"],
          onMenu = onCategoriesMenu,
        },
        {
          name = "Toggle",
          icon = mediaPath .. "Icon_Toggle.blp",
          iconSize = 16,
          tooltipTitle = L["TITLEBAR_TOGGLE"],
          tooltipDescription = L["TITLEBAR_TOGGLE_TOOLTIP"],
          onClick = toggleChecklistTable,
        },
      },
    }
    ---@type WK_Window
    local checklistWindow = LiqUI:NewElement("Window", windowOptions)
    self.window = checklistWindow
    self.window:SetFrameLevel(8100)

    ---@type LiqUI_TableOptions
    local tableConfig = {
      name = addon.name .. "Checklist",
      storage = tables.Checklist,
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
        defaultCompare = compareChecklistDefault,
      },
      columns = self:GetColumnDefinitions(),
    }
    self.window.table = LiqUI:NewElement("Table", tableConfig)
    self.window.table:SetParent(self.window.body)
    self.window.table:SetPoint("TOPLEFT", self.window.body, "TOPLEFT", 0, 0)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window.body, "BOTTOMRIGHT", 0, 0)
  end

  local window = self.window
  if not window then
    return
  end
  local tableFrame = window.table
  if not tableFrame then
    return
  end

  if not character then
    window:Hide()
    return
  end

  -- Quick hotfix to avoid excessive rendering
  if (not window:IsVisible() and not Data.db.global.checklist.open) or (Data.cache.inCombat and Data.db.global.checklist.hideInCombat) then
    window:Hide()
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

  tableFrame:SetData(rows)

  local minWindowWidth = 200
  local maxBodyHeight = 300 - Constants.TITLEBAR_HEIGHT
  local emptyBodyHeight = 200 - Constants.TITLEBAR_HEIGHT

  if Data.db.global.checklist.hideTable then
    tableFrame:Hide()
    window:HideOverlay()
    window:SetBodySize(minWindowWidth, 0)
  elseif rowCount == 0 then
    window:ShowOverlay("It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or category above?\n\nIf this is your first time using this addon then make sure to open your professions at least once.")
    tableFrame:Hide()
    window:SetBodySize(minWindowWidth, emptyBodyHeight)
  else
    window:HideOverlay()
    tableFrame:Show()
    local bodyWidth, bodyHeight = tableFrame:GetSize()
    bodyWidth = math.max(bodyWidth, minWindowWidth)
    bodyHeight = math.min(bodyHeight, maxBodyHeight)
    window:SetBodySize(bodyWidth, bodyHeight)
  end

  window:SetShown(Data.db.global.checklist.open)
  window.titlebar:SetShown(Data.db.global.checklist.windowTitlebar)
  if Data.cache.inCombat and Data.db.global.checklist.hideInCombat then
    window:Hide()
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
