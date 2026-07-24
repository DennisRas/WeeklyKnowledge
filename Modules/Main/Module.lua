---@class WK_Addon
local addon = select(2, ...)

---@class WK_Main
local Main = {}
addon.Main = Main

local Constants = addon.Constants
local Data = addon.Data
local Checklist = addon.Checklist
local Helpers = addon.Helpers
local LibLiqUI = addon.libs.LiqUI
local LibDBIcon = addon.libs.LibDBIcon
local TableContains = LibLiqUI.Utils.TableContains
local TableCount = LibLiqUI.Utils.TableCount
local TableFilter = LibLiqUI.Utils.TableFilter
local TableForEach = LibLiqUI.Utils.TableForEach
local TableToggle = LibLiqUI.Utils.TableToggle

do
  local dialogName = "WEEKLYKNOWLEDGE_DELETE_CHARACTER"
  StaticPopupDialogs[dialogName] = {
    text = "Remove %s?\nThis cannot be undone.\nTo add this character again, log in on them.",
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(_, character)
      if character then
        Data:DeleteCharacter(character)
        Main:Render()
      end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
  }
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
    self.window = LibLiqUI:NewElement("Window", {
      name = addon.name .. "Main",
      storage = windows.Main,
      title = addon.name,
      icon = mediaPath .. "Icon.blp",
      border = 4,
      overlayFontObject = "SystemFont_Med1",
      onShow = function()
        Main:Render()
      end,
      onSettingsMenu = function(window, rootMenu)
        local showFullProfessionName = rootMenu:CreateCheckbox(
          "Show full profession name",
          function() return Data.db.global.showFullProfessionName end,
          function()
            Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
            self:ApplyTableColumns()
            self:Render()
            Checklist:ApplyTableColumns()
            Checklist:Render()
          end
        )
        showFullProfessionName:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
          GameTooltip_AddNormalLine(tooltip, "Show the full profession name with the expansion variant.")
        end)

        local hideLowLevelProfessions = rootMenu:CreateCheckbox(
          "Hide low level professions",
          function() return Data.db.global.main.hideLowLevelProfessions end,
          function()
            Data.db.global.main.hideLowLevelProfessions = not Data.db.global.main.hideLowLevelProfessions
            self:Render()
          end
        )
        hideLowLevelProfessions:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
          GameTooltip_AddNormalLine(tooltip, "Hide professions with a skill level below 25.")
        end)

        local showMinimapIcon = rootMenu:CreateCheckbox(
          "Show the minimap button",
          function() return not Data.db.global.minimap.hide end,
          function()
            Data.db.global.minimap.hide = not Data.db.global.minimap.hide
            LibDBIcon:Refresh(addon.name, Data.db.global.minimap)
          end
        )
        showMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
          GameTooltip_AddNormalLine(tooltip, "It does get crowded around the minimap sometimes.")
        end)

        local lockMinimapIcon = rootMenu:CreateCheckbox(
          "Lock the minimap button",
          function() return Data.db.global.minimap.lock end,
          function()
            Data.db.global.minimap.lock = not Data.db.global.minimap.lock
            LibDBIcon:Refresh(addon.name, Data.db.global.minimap)
          end
        )
        lockMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription))
          GameTooltip_AddNormalLine(tooltip, "No more moving the button around accidentally!")
        end)
      end,
      titlebarButtons = {
        {
          name = "Characters",
          icon = mediaPath .. "Icon_Characters.blp",
          iconSize = 14,
          tooltipTitle = "Characters",
          tooltipDescription = "Enable/Disable your characters.",
          onMenu = function(_, rootMenu)
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

              local characterButton = rootMenu:CreateButton(name)

              if TableCount(character.professions) > 0 then
                TableForEach(character.professions, function(characterProfession)
                  local variant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
                  local professionName = (variant and variant.name) or "?"
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
          end,
        },
        {
          name = "Expansion",
          icon = mediaPath .. "Icon_House.blp",
          iconSize = 14,
          tooltipTitle = "Expansion",
          tooltipDescription = "Filter rows by selected expansions.",
          onMenu = function(_, rootMenu)
            TableForEach(Data:GetExpansions(), function(expansion)
              rootMenu:CreateCheckbox(
                expansion.name,
                function() return TableContains(Data.db.global.main.selectedExpansions, expansion.id) end,
                function()
                  Data.db.global.main.selectedExpansions = TableToggle(Data.db.global.main.selectedExpansions, expansion.id)
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
          tooltipDescription = "Enable/Disable table columns.",
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
          name = "Checklist",
          icon = mediaPath .. "Icon_Checklist.blp",
          iconSize = 16,
          tooltipTitle = "Checklist",
          tooltipDescription = "Toggle the Checklist window",
          onClick = function()
            Checklist:ToggleWindow()
            self:Render()
          end,
        },
      },
    })
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
        defaultCompare = function(rowA, rowB)
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
        end,
      },
      columns = self:GetColumnDefinitions(),
    }
    self.window.table = LibLiqUI:NewElement("Table", tableConfig)
    self.window.table:SetParent(self.window.body)
    self.window.table:SetPoint("TOPLEFT", self.window.body, "TOPLEFT", 0, 0)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window.body, "BOTTOMRIGHT", 0, 0)
  end

  -- Quick hotfix to avoid excessive rendering
  if not self.window:IsVisible() then
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

  self.window.table:SetData(rows)

  local minWindowWidth = 500
  local maxBodyHeight = Constants.MAX_WINDOW_HEIGHT - Constants.TITLEBAR_HEIGHT
  local emptyBodyHeight = 250 - Constants.TITLEBAR_HEIGHT

  if rowCount == 0 then
    self.window:ShowOverlay("It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or character above?\n\nIf this is your first time using this addon then make sure to open your professions at least once.")
    self.window.table:Hide()
    self.window:SetBodySize(minWindowWidth, emptyBodyHeight)
    if self.window.titlebar then
      self.window.titlebar.title:SetShown(false)
    end
  else
    self.window:HideOverlay()
    self.window.table:Show()
    local bodyWidth, bodyHeight = self.window.table:GetSize()
    bodyWidth = math.max(bodyWidth, minWindowWidth)
    bodyHeight = math.min(bodyHeight, maxBodyHeight)
    self.window:SetBodySize(bodyWidth, bodyHeight)
    if self.window.titlebar then
      self.window.titlebar.title:SetShown(bodyWidth > minWindowWidth)
    end
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
