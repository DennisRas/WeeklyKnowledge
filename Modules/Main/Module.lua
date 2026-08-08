---@class WK_Addon
local addon = select(2, ...)

---@class WK_Main
local Main = {}
addon.Main = Main

local Constants = addon.Constants
local L = addon.L
local Data = addon.Data
local Checklist = addon.Checklist
local Helpers = addon.Helpers
local LiqUI = addon.libs.LiqUI
local LibDBIcon = addon.libs.LibDBIcon
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

---@param tooltip GameTooltip
---@param elementDescription ElementMenuDescriptionProxy
local function showHideLowLevelProfessionsTooltip(tooltip, elementDescription)
  GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
  GameTooltip_AddNormalLine(tooltip, L["SETTING_HIDE_LOW_LEVEL_PROFESSIONS_TOOLTIP"])
end

---@param tooltip GameTooltip
---@param elementDescription ElementMenuDescriptionProxy
local function showMinimapIconTooltip(tooltip, elementDescription)
  GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
  GameTooltip_AddNormalLine(tooltip, L["SETTING_SHOW_MINIMAP_BUTTON_TOOLTIP"])
end

---@param tooltip GameTooltip
---@param elementDescription ElementMenuDescriptionProxy
local function showLockMinimapIconTooltip(tooltip, elementDescription)
  GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
  GameTooltip_AddNormalLine(tooltip, L["SETTING_LOCK_MINIMAP_BUTTON_TOOLTIP"])
end

---@param rowA WK_TableRowData
---@param rowB WK_TableRowData
---@return boolean
local function compareMainDefault(rowA, rowB)
  if not rowA or not rowB then return false end
  local characterA, characterB = rowA.character, rowB.character
  local lastUpdateA, lastUpdateB = characterA.lastUpdate, characterB.lastUpdate
  if type(lastUpdateA) == "number" and type(lastUpdateB) == "number" then
    if lastUpdateA ~= lastUpdateB then
      return lastUpdateA > lastUpdateB
    end
  elseif type(lastUpdateA) == "number" then
    return true
  elseif type(lastUpdateB) == "number" then
    return false
  end
  local identityCompare = Helpers:CompareCharacterNameRealm(characterA, characterB)
  if identityCompare ~= 0 then return identityCompare < 0 end
  return (rowA.skillLineVariantID or 0) < (rowB.skillLineVariantID or 0)
end

do
  local dialogName = "WEEKLYKNOWLEDGE_DELETE_CHARACTER"
  ---@param _dialog Frame
  ---@param character WK_Character?
  local function onDeleteCharacterAccept(_dialog, character)
    if character then
      Data:DeleteCharacter(character)
      Main:Render()
    end
  end
  ---@type WK_DeleteCharacterDialog
  local dialog = {
    text = "Remove %s?\nThis cannot be undone.\nTo add this character again, log in on them.",
    button1 = YES,
    button2 = CANCEL,
    OnAccept = onDeleteCharacterAccept,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
  }
  StaticPopupDialogs[dialogName] = dialog
end

function Main:ToggleWindow()
  if not self.window then return end
  if self.window:IsVisible() then
    self.window:Hide()
  else
    if Data.cache.inCombat then return end
    self.window:Show()
  end
  self:Render()
end

function Main:Render()
  local selectedExpansions = Data.db.global.main.selectedExpansions or {}
  local characters = Data:GetCharacters()
  ---@type WK_TableRowData[]
  local rows = {}

  if not self.window then
    local mediaPath = "Interface/AddOns/WeeklyKnowledge/Media/"
    local windows = Data.db.global.liqui.windows
    local tables = Data.db.global.liqui.tables

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onMainSettingsMenu(_window, rootMenu)
      ---@type ElementMenuDescriptionProxy
      local showFullProfessionName = rootMenu:CreateCheckbox(
        L["SETTING_SHOW_FULL_PROFESSION_NAME"],
        function() return Data.db.global.showFullProfessionName == true end,
        function()
          Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
          self:ApplyTableColumns()
          self:Render()
          Checklist:ApplyTableColumns()
          Checklist:Render()
        end
      )
      showFullProfessionName:SetTooltip(showFullProfessionNameTooltip)

      ---@type ElementMenuDescriptionProxy
      local hideLowLevelProfessions = rootMenu:CreateCheckbox(
        L["SETTING_HIDE_LOW_LEVEL_PROFESSIONS"],
        function() return Data.db.global.main.hideLowLevelProfessions == true end,
        function()
          Data.db.global.main.hideLowLevelProfessions = not Data.db.global.main.hideLowLevelProfessions
          self:Render()
        end
      )
      hideLowLevelProfessions:SetTooltip(showHideLowLevelProfessionsTooltip)

      ---@type ElementMenuDescriptionProxy
      local showMinimapIcon = rootMenu:CreateCheckbox(
        L["SETTING_SHOW_MINIMAP_BUTTON"],
        function() return not Data.db.global.minimap.hide end,
        function()
          Data.db.global.minimap.hide = not Data.db.global.minimap.hide
          LibDBIcon:Refresh(addon.name, Data.db.global.minimap)
        end
      )
      showMinimapIcon:SetTooltip(showMinimapIconTooltip)

      ---@type ElementMenuDescriptionProxy
      local lockMinimapIcon = rootMenu:CreateCheckbox(
        L["SETTING_LOCK_MINIMAP_BUTTON"],
        function() return Data.db.global.minimap.lock end,
        function()
          Data.db.global.minimap.lock = not Data.db.global.minimap.lock
          LibDBIcon:Refresh(addon.name, Data.db.global.minimap)
        end
      )
      lockMinimapIcon:SetTooltip(showLockMinimapIconTooltip)
    end

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onCharactersMenu(_window, rootMenu)
      rootMenu:SetScrollMode(GetScreenHeight() - 20)
      TableForEach(Data:GetCharacters(), function(character)
        local name = character.name
        if character.realmName then
          name = format("%s - %s", character.name, character.realmName)
        end
        if character.classID then
          local _, classFile = GetClassInfo(character.classID)
          if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
              name = color:WrapTextInColorCode(name)
            end
          end
        end

        ---@type ElementMenuDescriptionProxy
        local characterButton = rootMenu:CreateButton(name)

        if TableCount(character.professions) > 0 then
          TableForEach(character.professions, function(characterProfession)
            local variant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
            local professionName = Data:GetSkillLineVariantDisplayName(variant)
            if professionName == "" then professionName = "?" end
            characterButton:CreateCheckbox(
              professionName,
              function() return characterProfession.enabled or false end,
              function()
                characterProfession.enabled = not characterProfession.enabled
                self:Render()
              end
            )
          end)
        end
        if character.GUID ~= UnitGUID("player") then
          characterButton:CreateButton("Remove character", function()
            local characterName = character.name
            if character.realmName then
              characterName = format("%s - %s", character.name, character.realmName)
            end
            StaticPopup_Show("WEEKLYKNOWLEDGE_DELETE_CHARACTER", characterName, nil, character)
          end)
        end
      end)
    end

    ---@param _window LiqUI_WindowInstance
    ---@param rootMenu RootMenuDescriptionProxy
    local function onExpansionMenu(_window, rootMenu)
      TableForEach(Data:GetExpansions(), function(expansion)
        rootMenu:CreateCheckbox(
          Data:GetExpansionDisplayName(expansion),
          function() return TableContains(Data.db.global.main.selectedExpansions, expansion.id) end,
          function()
            Data.db.global.main.selectedExpansions = TableToggle(Data.db.global.main.selectedExpansions, expansion.id)
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

    local function renderMainWindow()
      Main:Render()
    end

    local function openChecklist()
      Checklist:ToggleWindow()
      self:Render()
    end

    ---@type LiqUI_WindowOptions
    local windowOptions = {
      name = addon.name .. "Main",
      storage = windows.Main,
      title = addon.name,
      icon = mediaPath .. "Icon.blp",
      border = 4,
      overlayFontObject = "SystemFont_Med1",
      onShow = renderMainWindow,
      onSettingsMenu = onMainSettingsMenu,
      titlebarButtons = {
        {
          name = "Characters",
          icon = mediaPath .. "Icon_Characters.blp",
          iconSize = 14,
          tooltipTitle = L["TITLEBAR_CHARACTERS"],
          tooltipDescription = L["TITLEBAR_CHARACTERS_TOOLTIP"],
          onMenu = onCharactersMenu,
        },
        {
          name = "Expansion",
          icon = mediaPath .. "Icon_House.blp",
          iconSize = 14,
          tooltipTitle = L["TABLE_HEADER_EXPANSION"],
          tooltipDescription = L["TITLEBAR_EXPANSION_MAIN_TOOLTIP"],
          onMenu = onExpansionMenu,
        },
        {
          name = "Columns",
          icon = mediaPath .. "Icon_Columns.blp",
          tooltipTitle = L["TITLEBAR_COLUMNS"],
          tooltipDescription = L["TITLEBAR_COLUMNS_MAIN_TOOLTIP"],
          onMenu = onColumnsMenu,
        },
        {
          name = "Checklist",
          icon = mediaPath .. "Icon_Checklist.blp",
          iconSize = 16,
          tooltipTitle = L["TITLE_CHECKLIST"],
          tooltipDescription = L["TITLEBAR_CHECKLIST_TOOLTIP"],
          onClick = openChecklist,
        },
      },
    }
    ---@type WK_Window
    local mainWindow = LiqUI:NewElement("Window", windowOptions)
    self.window = mainWindow
    self.window:SetFrameLevel(8000)

    ---@type LiqUI_TableOptions
    local tableConfig = {
      name = addon.name .. "Main",
      storage = tables.Main,
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
        defaultCompare = compareMainDefault,
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

  -- Quick hotfix to avoid excessive rendering
  if not window:IsVisible() then
    return
  end

  local rowCount = 0
  do -- Table data rows
    TableForEach(characters, function(character)
      local professions = TableFilter(character.professions or {}, function(characterProfession)
        local skillLineVariant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
        if not skillLineVariant then return false end
        if TableCount(selectedExpansions) > 0 and not TableContains(selectedExpansions, skillLineVariant.expansionID) then return false end
        if not characterProfession.enabled then return false end
        if Data.db.global.main.hideLowLevelProfessions and (characterProfession.skillLevel and characterProfession.skillLevel > 0 and characterProfession.skillLevel < 25) then return false end
        return true
      end)

      TableForEach(professions, function(characterProfession)
        table.insert(rows, addon.Main.TableData.BuildRow(character, characterProfession))
        rowCount = rowCount + 1
      end)
    end)
  end

  self:ApplyTableColumns()
  tableFrame:SetData(rows)

  local minWindowWidth = 500
  local maxBodyHeight = Constants.MAX_WINDOW_HEIGHT - Constants.TITLEBAR_HEIGHT
  local emptyBodyHeight = 250 - Constants.TITLEBAR_HEIGHT

  if rowCount == 0 then
    window:ShowOverlay("It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or character above?\n\nIf this is your first time using this addon then make sure to open your professions at least once.")
    tableFrame:Hide()
    window:SetBodySize(minWindowWidth, emptyBodyHeight)
    window.titlebar.title:SetShown(false)
  else
    window:HideOverlay()
    tableFrame:Show()
    local bodyWidth, bodyHeight = tableFrame:GetSize()
    bodyWidth = math.max(bodyWidth, minWindowWidth)
    bodyHeight = math.min(bodyHeight, maxBodyHeight)
    window:SetBodySize(bodyWidth, bodyHeight)
    window.titlebar.title:SetShown(bodyWidth > minWindowWidth)
  end
end

function Main:ApplyTableColumns()
  if not self.window or not self.window.table then
    return
  end
  self.window.table:SetColumns(self:GetColumnDefinitions())
end

---Column definitions for the main table.
---@return LiqUI_TableOptionsColumn[]
function Main:GetColumnDefinitions()
  return addon.Main.TableColumns.GetDefinitions()
end
