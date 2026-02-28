---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Main
local Main = {}
addon.Main = Main

local Constants = addon.Constants
local Utils = addon.Utils
local UI = addon.UI
local Data = addon.Data
local Checklist = addon.Checklist
local LibDBIcon = LibStub("LibDBIcon-1.0")

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
  local selectedExpansion = Data.db.global.main.selectedExpansion
  local expansions = Data:GetExpansions()
  local characters = Data:GetCharacters()
  local columns = self:GetTableColumns()
  local objectiveCategories = Data:GetObjectiveCategories()
  local tableWidth = 0
  local tableHeight = 0
  local minWindowWidth = 300
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not self.window then
    local frameName = addonName .. "MainWindow"
    self.window = CreateFrame("Frame", frameName, UIParent)
    self.window:SetSize(500, 500)
    self.window:SetFrameStrata("MEDIUM")
    self.window:SetFrameLevel(8000)
    self.window:SetToplevel(true)
    self.window:SetClampedToScreen(true)
    self.window:SetMovable(true)
    self.window:SetPoint("CENTER")
    self.window:SetUserPlaced(true)
    self.window:RegisterForDrag("LeftButton")
    self.window:EnableMouse(true)
    self.window:SetScript("OnDragStart", function() self.window:StartMoving() end)
    self.window:SetScript("OnDragStop", function() self.window:StopMovingOrSizing() end)
    self.window:Hide()
    Utils:SetBackgroundColor(self.window, Data.db.global.main.windowBackgroundColor.r, Data.db.global.main.windowBackgroundColor.g, Data.db.global.main.windowBackgroundColor.b, Data.db.global.main.windowBackgroundColor.a)

    self.window.border = CreateFrame("Frame", "$parentBorder", self.window, "BackdropTemplate")
    self.window.border:SetPoint("TOPLEFT", self.window, "TOPLEFT", -3, 3)
    self.window.border:SetPoint("BOTTOMRIGHT", self.window, "BOTTOMRIGHT", 3, -3)
    self.window.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.window.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.window.border:Show()

    self.window.titlebar = CreateFrame("Frame", "$parentTitle", self.window)
    self.window.titlebar:SetPoint("TOPLEFT", self.window, "TOPLEFT")
    self.window.titlebar:SetPoint("TOPRIGHT", self.window, "TOPRIGHT")
    self.window.titlebar:SetHeight(Constants.TITLEBAR_HEIGHT)
    self.window.titlebar:RegisterForDrag("LeftButton")
    self.window.titlebar:EnableMouse(true)
    self.window.titlebar:SetScript("OnDragStart", function() self.window:StartMoving() end)
    self.window.titlebar:SetScript("OnDragStop", function() self.window:StopMovingOrSizing() end)
    Utils:SetBackgroundColor(self.window.titlebar, 0, 0, 0, 0.5)

    self.window.titlebar.icon = self.window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.window.titlebar.icon:SetPoint("LEFT", self.window.titlebar, "LEFT", 6, 0)
    self.window.titlebar.icon:SetSize(20, 20)
    self.window.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")

    self.window.titlebar.title = self.window.titlebar:CreateFontString("$parentText", "OVERLAY")
    self.window.titlebar.title:SetFontObject("SystemFont_Med2")
    self.window.titlebar.title:SetPoint("LEFT", self.window.titlebar, 28, 0)
    self.window.titlebar.title:SetJustifyH("LEFT")
    self.window.titlebar.title:SetJustifyV("MIDDLE")
    self.window.titlebar.title:SetText(addonName)

    self.window.titlebar.selectedExpansion = self.window.titlebar:CreateFontString("$parentSelectedExpansion", "OVERLAY")
    self.window.titlebar.selectedExpansion:SetFontObject("SystemFont_Med2")
    self.window.titlebar.selectedExpansion:SetPoint("CENTER", self.window.titlebar, "CENTER", 0, 0)
    self.window.titlebar.selectedExpansion:SetJustifyH("CENTER")
    self.window.titlebar.selectedExpansion:SetJustifyV("MIDDLE")
    self.window.titlebar.selectedExpansion:SetTextColor(1, 1, 1, 1)

    do -- Close Button
      self.window.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.window.titlebar)
      self.window.titlebar.closeButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.closeButton:SetPoint("RIGHT", self.window.titlebar, "RIGHT", 0, 0)
      self.window.titlebar.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
      self.window.titlebar.closeButton:SetScript("OnEnter", function()
        self.window.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        Utils:SetBackgroundColor(self.window.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(self.window.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
        GameTooltip:Show()
      end)
      self.window.titlebar.closeButton:SetScript("OnLeave", function()
        self.window.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.closeButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      self.window.titlebar.closeButton.Icon = self.window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      self.window.titlebar.closeButton.Icon:SetPoint("CENTER", self.window.titlebar.closeButton, "CENTER")
      self.window.titlebar.closeButton.Icon:SetSize(10, 10)
      self.window.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
      self.window.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Settings Button
      self.window.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.window.titlebar)
      self.window.titlebar.SettingsButton:SetPoint("RIGHT", self.window.titlebar.closeButton, "LEFT", 0, 0)
      self.window.titlebar.SettingsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.SettingsButton:SetScript("OnEnter", function()
        self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.SettingsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.window.titlebar.SettingsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Settings", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Let's customize things a bit", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.SettingsButton:SetScript("OnLeave", function()
        self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
        local showFullProfessionName = rootMenu:CreateCheckbox(
          "Show full profession name",
          function() return Data.db.global.showFullProfessionName end,
          function()
            Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
            self:Render()
            if addon.Checklist and addon.Checklist.Render then
              addon.Checklist:Render()
            end
          end
        )
        showFullProfessionName:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "Show the full profession name with the expansion variant.");
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
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "Hide professions with a skill level below 25.");
        end)

        local showMinimapIcon = rootMenu:CreateCheckbox(
          "Show the minimap button",
          function() return not Data.db.global.minimap.hide end,
          function()
            Data.db.global.minimap.hide = not Data.db.global.minimap.hide
            LibDBIcon:Refresh(addonName, Data.db.global.minimap)
          end
        )
        showMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "It does get crowded around the minimap sometimes.");
        end)

        local lockMinimapIcon = rootMenu:CreateCheckbox(
          "Lock the minimap button",
          function() return Data.db.global.minimap.lock end,
          function()
            Data.db.global.minimap.lock = not Data.db.global.minimap.lock
            LibDBIcon:Refresh(addonName, Data.db.global.minimap)
          end
        )
        lockMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "No more moving the button around accidentally!");
        end)

        rootMenu:CreateTitle("Window")
        local windowScale = rootMenu:CreateButton("Scaling")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return Data.db.global.main.windowScale == i end,
            function(data)
              Data.db.global.main.windowScale = data
              self:Render()
            end,
            i
          )
        end

        local colorInfo = {
          r = Data.db.global.main.windowBackgroundColor.r,
          g = Data.db.global.main.windowBackgroundColor.g,
          b = Data.db.global.main.windowBackgroundColor.b,
          opacity = Data.db.global.main.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              Data.db.global.main.windowBackgroundColor.r = r
              Data.db.global.main.windowBackgroundColor.g = g
              Data.db.global.main.windowBackgroundColor.b = b
              if a then
                Data.db.global.main.windowBackgroundColor.a = a
              end
              Utils:SetBackgroundColor(self.window, Data.db.global.main.windowBackgroundColor.r, Data.db.global.main.windowBackgroundColor.g, Data.db.global.main.windowBackgroundColor.b, Data.db.global.main.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              Data.db.global.main.windowBackgroundColor.r = color.r
              Data.db.global.main.windowBackgroundColor.g = color.g
              Data.db.global.main.windowBackgroundColor.b = color.b
              if color.a then
                Data.db.global.main.windowBackgroundColor.a = color.a
              end
              Utils:SetBackgroundColor(self.window, Data.db.global.main.windowBackgroundColor.r, Data.db.global.main.windowBackgroundColor.g, Data.db.global.main.windowBackgroundColor.b, Data.db.global.main.windowBackgroundColor.a)
            end
          end,
          hasOpacity = 1,
        }
        rootMenu:CreateColorSwatch(
          "Background color",
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )

        rootMenu:CreateCheckbox(
          "Show the border",
          function() return Data.db.global.main.windowBorder end,
          function()
            Data.db.global.main.windowBorder = not Data.db.global.main.windowBorder
            self:Render()
          end
        )
      end)

      self.window.titlebar.SettingsButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      self.window.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.window.titlebar.SettingsButton, "CENTER")
      self.window.titlebar.SettingsButton.Icon:SetSize(12, 12)
      self.window.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Characters Button
      self.window.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.window.titlebar)
      self.window.titlebar.CharactersButton:SetPoint("RIGHT", self.window.titlebar.SettingsButton, "LEFT", 0, 0)
      self.window.titlebar.CharactersButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.CharactersButton:SetScript("OnEnter", function()
        self.window.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.CharactersButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.window.titlebar.CharactersButton, "ANCHOR_TOP")
        GameTooltip:SetText("Characters", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable your characters.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.CharactersButton:SetScript("OnLeave", function()
        self.window.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.CharactersButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.CharactersButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
      self.window.titlebar.CharactersButton.Icon:SetPoint("CENTER", self.window.titlebar.CharactersButton, "CENTER")
      self.window.titlebar.CharactersButton.Icon:SetSize(14, 14)
      self.window.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Characters.blp")
      self.window.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.window.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
        Utils:TableForEach(characters, function(character)
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

          if Utils:TableCount(character.professions) > 0 then
            Utils:TableForEach(character.professions, function(characterProfession)
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
      end)
    end

    do -- Expansion Button
      self.window.titlebar.ExpansionButton = CreateFrame("DropdownButton", "$parentExpansionButton", self.window.titlebar)
      self.window.titlebar.ExpansionButton:SetPoint("RIGHT", self.window.titlebar.CharactersButton, "LEFT", 0, 0)
      self.window.titlebar.ExpansionButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.ExpansionButton:SetScript("OnEnter", function()
        self.window.titlebar.ExpansionButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ExpansionButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.window.titlebar.ExpansionButton, "ANCHOR_TOP")
        GameTooltip:SetText("Expansion", 1, 1, 1, 1, true)
        GameTooltip:AddLine("Filter table by expansion.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
        GameTooltip:Show()
      end)
      self.window.titlebar.ExpansionButton:SetScript("OnLeave", function()
        self.window.titlebar.ExpansionButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ExpansionButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.ExpansionButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.ExpansionButton:GetName() .. "Icon", "ARTWORK")
      self.window.titlebar.ExpansionButton.Icon:SetPoint("CENTER", self.window.titlebar.ExpansionButton, "CENTER")
      self.window.titlebar.ExpansionButton.Icon:SetSize(14, 14)
      self.window.titlebar.ExpansionButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_House.blp")
      self.window.titlebar.ExpansionButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.window.titlebar.ExpansionButton:SetupMenu(function(_, rootMenu)
        rootMenu:CreateRadio(
          "All expansions",
          function() return Data.db.global.main.selectedExpansion == nil end,
          function()
            Data.db.global.main.selectedExpansion = nil
            self:Render()
          end,
          nil
        )
        Utils:TableForEach(expansions, function(expansion)
          rootMenu:CreateRadio(
            expansion.name,
            function() return Data.db.global.main.selectedExpansion == expansion.id end,
            function()
              Data.db.global.main.selectedExpansion = expansion.id
              self:Render()
            end,
            expansion.id
          )
        end)
      end)
    end

    do -- Columns Button
      self.window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.window.titlebar)
      self.window.titlebar.ColumnsButton:SetPoint("RIGHT", self.window.titlebar.ExpansionButton, "LEFT", 0, 0)
      self.window.titlebar.ColumnsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.ColumnsButton:SetScript("OnEnter", function()
        self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.window.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Columns", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable table columns.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.ColumnsButton:SetScript("OnLeave", function()
        self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = Data.db.global.main.hiddenColumns
        Utils:TableForEach(self:GetTableColumns(true), function(column)
          if not column.toggleHidden then return end
          rootMenu:CreateCheckbox(
            column.name,
            function() return not hidden[column.name] end,
            function(columnName)
              hidden[columnName] = not hidden[columnName]
              self:Render()
            end,
            column.name
          )
        end)
      end)

      self.window.titlebar.ColumnsButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
      self.window.titlebar.ColumnsButton.Icon:SetPoint("CENTER", self.window.titlebar.ColumnsButton, "CENTER")
      self.window.titlebar.ColumnsButton.Icon:SetSize(12, 12)
      self.window.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Columns.blp")
      self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Checklist Button
      self.window.titlebar.ChecklistButton = CreateFrame("Button", "$parentChecklistButton", self.window.titlebar)
      self.window.titlebar.ChecklistButton:SetPoint("RIGHT", self.window.titlebar.ColumnsButton, "LEFT", 0, 0)
      self.window.titlebar.ChecklistButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.ChecklistButton:SetScript("OnEnter", function()
        self.window.titlebar.ChecklistButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ChecklistButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.window.titlebar.ChecklistButton, "ANCHOR_TOP")
        GameTooltip:SetText("Checklist", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Toggle the Checklist window", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.ChecklistButton:SetScript("OnLeave", function()
        self.window.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ChecklistButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.ChecklistButton:SetScript("OnClick", function()
        -- Data.db.global.main.checklistHelpTipClosed = true
        Checklist:ToggleWindow()
        self:Render()
      end)

      self.window.titlebar.ChecklistButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.ChecklistButton:GetName() .. "Icon", "ARTWORK")
      self.window.titlebar.ChecklistButton.Icon:SetPoint("CENTER", self.window.titlebar.ChecklistButton, "CENTER")
      self.window.titlebar.ChecklistButton.Icon:SetSize(16, 16)
      self.window.titlebar.ChecklistButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Checklist.blp")
      self.window.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    self.window.table = UI:CreateTableFrame({
      header = {
        enabled = true,
        sticky = true,
        height = Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = Constants.TABLE_ROW_HEIGHT,
        highlight = true,
        striped = true
      }
    })
    self.window.table:SetParent(self.window)
    self.window.table:SetPoint("TOPLEFT", self.window, "TOPLEFT", 0, -Constants.TITLEBAR_HEIGHT)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window, "BOTTOMRIGHT", 0, 0)

    table.insert(UISpecialFrames, self.window:GetName() or (addonName .. "MainWindow"))
  end

  -- Quick hotfix to avoid excessive rendering
  if not self.window:IsVisible() then
    return
  end

  -- do -- Show helptip for new checklist
  --   local checklistHelpTipText = "Check out the new checklist!"
  --   if Data.db.global.main.checklistHelpTipClosed then
  --     HelpTip:Hide(self.window, checklistHelpTipText)
  --   else
  --     HelpTip:Show(
  --       self.window,
  --       {
  --         text = checklistHelpTipText,
  --         buttonStyle = HelpTip.ButtonStyle.Close,
  --         targetPoint = HelpTip.Point.TopEdgeCenter,
  --         onAcknowledgeCallback = function()
  --           Data.db.global.main.checklistHelpTipClosed = true
  --         end,
  --       },
  --       self.window.titlebar.ChecklistButton
  --     )
  --   end
  -- end

  do -- Table columns config
    Utils:TableForEach(columns, function(column)
      ---@type WK_TableDataColumn
      local columnConfig = {
        width = column.width,
        align = column.align or "LEFT",
      }
      table.insert(tableData.columns, columnConfig)
      tableWidth = tableWidth + columnConfig.width
    end)
  end

  do -- Table Header row
    ---@type WK_TableDataRow
    local row = {columns = {}}
    Utils:TableForEach(columns, function(column)
      ---@type WK_TableDataCell
      local cell = {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(column.name),
        onEnter = column.onEnter,
        onLeave = column.onLeave,
      }
      table.insert(row.columns, cell)
    end)
    table.insert(tableData.rows, row)
    tableHeight = tableHeight + self.window.table.config.header.height
  end

  do -- Table data rows
    Utils:TableForEach(characters, function(character)
      local professions = Utils:TableFilter(character.professions or {}, function(characterProfession)
        local skillLineVariant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
        if not skillLineVariant then return false end
        if selectedExpansion and skillLineVariant.expansionID ~= selectedExpansion then return false end
        if not characterProfession.enabled then return false end
        if Data.db.global.main.hideLowLevelProfessions and (characterProfession.skillLevel and characterProfession.skillLevel > 0 and characterProfession.skillLevel < 25) then return false end
        return true
      end)

      Utils:TableForEach(professions, function(characterProfession)
        ---@type WK_TableDataRow
        local row = {columns = {}}
        Utils:TableForEach(columns, function(column)
          ---@type WK_TableDataCell
          local cell = column.cell(character, characterProfession, characterProfession.skillLineVariantID)
          table.insert(row.columns, cell)
        end)
        table.insert(tableData.rows, row)
        tableHeight = tableHeight + self.window.table.config.rows.height
      end)
    end)
  end

  self.window.titlebar.title:SetShown(tableWidth > minWindowWidth)
  self.window.titlebar.selectedExpansion:SetText(format("Expansion: %s", (Data.db.global.main.selectedExpansion and Data:GetExpansionByID(Data.db.global.main.selectedExpansion) or {}).name or "All Expansions"))
  self.window.border:SetShown(Data.db.global.main.windowBorder)
  self.window.table:SetData(tableData)
  self.window:SetWidth(math.max(tableWidth, minWindowWidth))
  self.window:SetHeight(math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT) + 2)
  self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
  self.window:SetScale(Data.db.global.main.windowScale / 100)
end

---Get columns for the table
---@param unfiltered boolean? Show all columns, even if they are hidden
---@return WK_DataColumn[]
function Main:GetTableColumns(unfiltered)
  local hidden = Data.db.global.main.hiddenColumns
  local weeklyProgress = Data:GetWeeklyProgress()
  local objectives = Data:GetObjectives()
  local expansions = Data:GetExpansions()
  local objectiveCategories = Data:GetObjectiveCategories()
  local currentCharacter = Data:GetCharacter()

  ---@type WK_DataColumn[]
  local columns = {
    {
      name = "Name",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Name", 1, 1, 1);
        GameTooltip:AddLine("Your characters.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      toggleHidden = true,
      cell = function(character)
        local name = character.name
        if character.classID then
          local _, classFile = GetClassInfo(character.classID)
          if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
              name = color:WrapTextInColorCode(name)
            end
          end
        end
        return {text = name}
      end,
    },
    {
      name = "Realm",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Realm", 1, 1, 1);
        GameTooltip:AddLine("Realm names.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      toggleHidden = true,
      cell = function(character)
        return {text = character.realmName}
      end,
    },
    {
      name = "Profession",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Profession", 1, 1, 1);
        GameTooltip:AddLine("Your professions.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = Data.db.global.showFullProfessionName and 160 or 100,
      toggleHidden = true,
      cell = function(character, characterProfession, skillLineVariantID)
        local text = ""
        local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
        if not variant then return {text = ""} end
        local skillLine = Data:GetSkillLineByID(variant and variant.skillLineID or 0)
        if not skillLine then return {text = ""} end
        text = skillLine.name
        if Data.db.global.showFullProfessionName then
          text = variant.name
        end
        return {
          text = text,
          onEnter = function(cellFrame)
            if character == currentCharacter then
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText(text, 1, 1, 1);
              GameTooltip:AddLine(format("<Click to open profession>"), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:Show()
            end
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if character == currentCharacter then
              C_TradeSkillUI.OpenTradeSkill(skillLine.id)
            end
          end,
        }
      end,
    },
    {
      name = "Expansion",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Expansion", 1, 1, 1);
        GameTooltip:AddLine("Expansion for this profession row.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 120,
      toggleHidden = true,
      cell = function(_, _, skillLineVariantID)
        local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
        if not variant then return {text = ""} end
        local expansion = variant and Data:GetExpansionByID(variant.expansionID)
        if not expansion then return {text = ""} end
        return {text = expansion.name}
      end,
    },
    {
      name = "Skill",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Skill", 1, 1, 1);
        GameTooltip:AddLine("Current skill levels.\n\nNote: This is only updated when you open the profession window or craft a recipe.", nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 80,
      align = "CENTER",
      toggleHidden = true,
      cell = function(_, characterProfession)
        if not characterProfession.skillLevel or characterProfession.skillLevel == 0 then
          return {
            text = "-",
            onEnter = function(cellFrame)
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText("No data", 1, 1, 1);
              GameTooltip:AddLine("Log in on this character and open the profession window one time to fetch skill level data.", nil, nil, nil, true);
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
          }
        end
        return {text = characterProfession.skillLevel > 0 and characterProfession.skillLevel == characterProfession.skillMaxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(characterProfession.skillLevel .. " / " .. characterProfession.skillMaxLevel) or characterProfession.skillLevel .. " / " .. characterProfession.skillMaxLevel}
      end,
    },
    {
      name = "Concentration",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Concentration", 1, 1, 1);
        GameTooltip:AddLine("Current concentration.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      toggleHidden = true,
      cell = function(_, characterProfession)
        local concentration = characterProfession.concentration
        if not concentration then
          return {
            text = "-",
            onEnter = function(cellFrame)
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText("No data", 1, 1, 1);
              GameTooltip:AddLine("Log in on this character to fetch concentration data.", nil, nil, nil, true);
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
          }
        end

        local currentQuantity = concentration.quantity
        local maxQuantity = concentration.maxQuantity
        local timeDifference = GetServerTime() - concentration.lastUpdated
        local cyclesSinceLastUpdate = timeDifference / (concentration.rechargingCycleDurationMS / 1000)
        local estimatedQuantity = math.min(currentQuantity + cyclesSinceLastUpdate, maxQuantity)
        local quantityToMax = math.max(0, maxQuantity - estimatedQuantity)
        local timeToMax = quantityToMax * (concentration.rechargingCycleDurationMS / 1000)
        local color = WHITE_FONT_COLOR

        if estimatedQuantity >= concentration.maxQuantity then
          color = GREEN_FONT_COLOR
        end
        if estimatedQuantity == 0 then
          color = RED_FONT_COLOR
        end

        local text = maxQuantity > 0 and color:WrapTextInColorCode(format("%d / %d", estimatedQuantity, maxQuantity)) or "-"

        return {
          text = text,
          color = color,
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(concentration.name, 1, 1, 1);
            if timeToMax > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Estimated", 1, 1, 1, true)
              GameTooltip:AddDoubleLine("Concentration:", format("%d / %d", estimatedQuantity, concentration.maxQuantity), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine("Time to max:", SecondsToTime(timeToMax), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine("Maxed at:", date("%c", concentration.lastUpdated + timeToMax), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Last Saved", 1, 1, 1, true)
            end
            GameTooltip:AddDoubleLine("Concentration:", format("%d / %d", concentration.quantity, concentration.maxQuantity), nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine("Saved at:", date("%c", concentration.lastUpdated), nil, nil, nil, 1, 1, 1)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
    },
    {
      name = "Knowledge",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Knowledge Points", 1, 1, 1);
        GameTooltip:AddLine("Current knowledge gained.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      toggleHidden = true,
      cell = function(_, characterProfession, skillLineVariantID)
        local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
        local text = ""

        if characterProfession.knowledgeLevel then
          text = format("%d", characterProfession.knowledgeLevel)
          if characterProfession.knowledgeUnspent and characterProfession.knowledgeUnspent > 0 then
            text = format("%d %s", characterProfession.knowledgeLevel, LIGHTBLUE_FONT_COLOR:WrapTextInColorCode("(" .. characterProfession.knowledgeUnspent .. ")"))
          end
        end
        if characterProfession.knowledgeMaxLevel then
          text = format("%s / %d", text, characterProfession.knowledgeMaxLevel)
        end
        if characterProfession.knowledgeMaxLevel > 0 and characterProfession.knowledgeLevel == characterProfession.knowledgeMaxLevel then
          text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
        end

        return {
          text = text,
          onEnter = function(cellFrame)
            local pointsSpentColor = LIGHTGRAY_FONT_COLOR
            local pointsSpentValue = "?"
            local pointsUnspentColor = LIGHTGRAY_FONT_COLOR
            local pointsUnspentValue = "?"
            local pointsMaxColor = LIGHTGRAY_FONT_COLOR
            local pointsMaxValue = "?"

            if characterProfession.knowledgeLevel then
              pointsSpentColor = WHITE_FONT_COLOR
              pointsSpentValue = tostring(characterProfession.knowledgeLevel)
            end

            if characterProfession.knowledgeUnspent then
              pointsUnspentColor = WHITE_FONT_COLOR
              if characterProfession.knowledgeUnspent > 0 then
                pointsUnspentColor = LIGHTBLUE_FONT_COLOR
              end
              pointsUnspentValue = tostring(characterProfession.knowledgeUnspent)
            end

            if characterProfession.knowledgeMaxLevel then
              pointsMaxColor = WHITE_FONT_COLOR
              pointsMaxValue = tostring(characterProfession.knowledgeMaxLevel)
            end

            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(skillLineVariant and skillLineVariant.name or "", 1, 1, 1)
            GameTooltip:AddDoubleLine("Points Spent:", pointsSpentValue, nil, nil, nil, pointsSpentColor.r, pointsSpentColor.g, pointsSpentColor.b)
            GameTooltip:AddDoubleLine("Points Unspent:", pointsUnspentValue, nil, nil, nil, pointsUnspentColor.r, pointsUnspentColor.g, pointsUnspentColor.b)
            GameTooltip:AddDoubleLine("Max:", pointsMaxValue, nil, nil, nil, pointsMaxColor.r, pointsMaxColor.g, pointsMaxColor.b)

            if characterProfession.specializations and Utils:TableCount(characterProfession.specializations) > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Specializations:")
              Utils:TableForEach(characterProfession.specializations, function(characterProfessionSpecialization)
                local name = characterProfessionSpecialization.name
                if strlenutf8(name) > 20 then
                  name = strsub(name, 1, 20) .. "..."
                end
                local value = format("%d / %d", characterProfessionSpecialization.knowledgeLevel or 0, characterProfessionSpecialization.knowledgeMaxLevel or 0)
                if characterProfessionSpecialization.rootIconID then
                  name = "|T" .. characterProfessionSpecialization.rootIconID .. ":12|t " .. name
                end
                if characterProfessionSpecialization.state and characterProfessionSpecialization.state == Enum.ProfessionsSpecTabState.Locked then
                  value = LIGHTGRAY_FONT_COLOR:WrapTextInColorCode("Locked")
                end
                if characterProfessionSpecialization.state and characterProfessionSpecialization.state == Enum.ProfessionsSpecTabState.Unlockable then
                  value = DIM_GREEN_FONT_COLOR:WrapTextInColorCode("Can Unlock")
                end
                GameTooltip:AddDoubleLine(name, value, 1, 1, 1, 1, 1, 1)
              end)
            end

            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
    },
  }

  Utils:TableForEach(objectiveCategories, function(objectiveCategory)
    if objectiveCategory.id == Enum.WK_ObjectiveCategory.DarkmoonQuest then
      if not Data.cache.isDarkmoonOpen then
        return
      end
    elseif objectiveCategory.id == Enum.WK_ObjectiveCategory.CatchUp then
      -- There's a hard-coded column with more info
      return
    end

    ---@type WK_DataColumn
    local dataColumn = {
      name = objectiveCategory.name,
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(objectiveCategory.name, 1, 1, 1);
        GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      toggleHidden = true,
      align = "CENTER",
      cell = function(character, characterProfession, skillLineVariantID)
        if not characterProfession.knowledgeMaxLevel or characterProfession.knowledgeMaxLevel == 0 then
          return {text = ""}
        end

        local questsCompleted = 0
        local questsTotal = 0
        local pointsEarned = 0
        local pointsTotal = 0
        local items = {}

        local progress = Utils:TableFilter(weeklyProgress, function(progress)
          local pObj = progress.objective
          return progress.characterGUID == character.GUID and pObj and pObj.skillLineVariantID == skillLineVariantID and pObj.categoryID == objectiveCategory.id
        end)

        Utils:TableForEach(progress, function(prog)
          questsCompleted = questsCompleted + prog.questsCompleted
          questsTotal = questsTotal + prog.questsTotal
          pointsEarned = pointsEarned + prog.pointsEarned
          pointsTotal = pointsTotal + prog.pointsTotal
          Utils:TableForEach(prog.items, function(isCompleted, itemID)
            items[itemID] = isCompleted
          end)
        end)

        if questsTotal == 0 then
          return {text = ""}
        end

        local text = format("%d / %d", questsCompleted, questsTotal)
        if questsCompleted == questsTotal then
          text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
        end

        return {
          text = text,
          onEnter = function(cellFrame)
            local label = "Items:"
            if objectiveCategory.type == "quest" then
              label = "Quests:"
            elseif objectiveCategory.type == "recipe" then
              label = "Crafting Recipes:"
            end

            local showTooltip = function()
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText(objectiveCategory.name, 1, 1, 1);
              GameTooltip:AddDoubleLine(label, format("%d / %d", questsCompleted, questsTotal), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", pointsEarned, pointsTotal), nil, nil, nil, 1, 1, 1)
              if Utils:TableCount(items) > 0 then
                GameTooltip:AddLine(" ")
                for itemID, itemLooted in pairs(items) do
                  local item = Data.cache.items[itemID]
                  local itemCached = item and item:IsItemDataCached()
                  local icon = itemCached and item:GetItemIcon() or 134400
                  local name = itemCached and item:GetItemLink() or "Loading..."
                  GameTooltip:AddDoubleLine(
                    format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name),
                    CreateAtlasMarkup(itemLooted and "common-icon-checkmark" or "common-icon-redx", 12, 12)
                  )
                end
              end
              GameTooltip:Show()
            end

            for itemID in pairs(items) do
              Data.cache.items[itemID] = Item:CreateFromItemID(itemID)
              Data.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
            end

            showTooltip()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end
    }
    table.insert(columns, dataColumn)
  end)

  ---@type WK_DataColumn
  local dataColumn = {
    name = "Catch-Up",
    onEnter = function(cellFrame)
      GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
      GameTooltip:SetText("Catch-Up", 1, 1, 1);
      local objective = Data:GetObjectiveCategoryByID(Enum.WK_ObjectiveCategory.CatchUp)
      if objective then
        GameTooltip:AddLine(objective.description, nil, nil, nil, true)
      end
      -- GameTooltip:AddLine(" ")
      -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
      GameTooltip:Show()
    end,
    onLeave = function()
      GameTooltip:Hide()
    end,
    width = 80,
    align = "CENTER",
    toggleHidden = true,
    cell = function(character, characterProfession, skillLineVariantID)
      local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
      if not characterProfession.catchUpCurrencyInfo then
        return {
          text = "-",
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText("No data", 1, 1, 1);
            if skillLineVariant and skillLineVariant.expansionID == Enum.ExpansionLevel.Dragonflight then
              GameTooltip:AddLine("Addon has not been updated for the Dragonflight expansion yet.\n\nYou can still track your skill/knowledge level meanwhile.\n\nIt is not guaranteed that the Dragonflight data will be added if the system is too different from the other expansions.", nil, nil, nil, true);
            else
              GameTooltip:AddLine("Log in to fetch the data for this character.", nil, nil, nil, true);
            end
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end

      local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
      local catchUpCurrent = characterProfession.catchUpCurrencyInfo.quantity
      local catchUpTotal = characterProfession.catchUpCurrencyInfo.maxQuantity
      local textColor = WHITE_FONT_COLOR
      if catchUpCurrent == catchUpTotal then
        textColor = GREEN_FONT_COLOR
      end

      local sumPointsEarned = 0
      local sumPointsTotal = 0
      local requirements = {}

      local progress = Utils:TableFilter(weeklyProgress, function(progress)
        local pObj = progress.objective
        return progress.characterGUID == character.GUID and pObj and pObj.skillLineVariantID == skillLineVariantID and (
          pObj.categoryID == Enum.WK_ObjectiveCategory.ArtisanQuest
          or pObj.categoryID == Enum.WK_ObjectiveCategory.Treasure
          or pObj.categoryID == Enum.WK_ObjectiveCategory.Gathering
          or pObj.categoryID == Enum.WK_ObjectiveCategory.TrainerQuest
        )
      end)
      local hasGathering = Utils:TableFind(progress, function(prog)
        local obj = prog.objective
        return obj and obj.categoryID == Enum.WK_ObjectiveCategory.Gathering
      end)
      Utils:TableForEach(progress, function(prog)
        local obj = prog.objective
        local objectiveCategory = obj and Data:GetObjectiveCategoryByID(obj.categoryID)
        if not objectiveCategory then return end
        if prog.questsTotal == 0 then return end
        sumPointsEarned = sumPointsEarned + prog.pointsEarned
        sumPointsTotal = sumPointsTotal + prog.pointsTotal

        -- Only gathering professions require completed gathering before catch-up unlocks
        if not hasGathering then return end
        if not requirements[objectiveCategory.name] then
          requirements[objectiveCategory.name] = {0, 0}
        end
        requirements[objectiveCategory.name][1] = requirements[objectiveCategory.name][1] + prog.pointsEarned
        requirements[objectiveCategory.name][2] = requirements[objectiveCategory.name][2] + prog.pointsTotal
      end)

      return {
        text = format(textColor:WrapTextInColorCode("%d / %d"), catchUpCurrent, catchUpTotal),
        onEnter = function(cellFrame)
          local showTooltip = function()
            local color = WHITE_FONT_COLOR

            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText("Catch-Up Progress", 1, 1, 1)
            color = sumPointsEarned == sumPointsTotal and GREEN_FONT_COLOR or WHITE_FONT_COLOR
            GameTooltip:AddDoubleLine("Points This Week:", format("%d / %d", sumPointsEarned, sumPointsTotal), nil, nil, nil, color.r, color.g, color.b)
            color = catchUpCurrent - sumPointsEarned == catchUpTotal - sumPointsTotal and GREEN_FONT_COLOR or WHITE_FONT_COLOR
            GameTooltip:AddDoubleLine("Catch-Up Points:", format("%d / %d", catchUpCurrent - sumPointsEarned, catchUpTotal - sumPointsTotal), nil, nil, nil, color.r, color.g, color.b)
            color = catchUpCurrent == catchUpTotal and GREEN_FONT_COLOR or WHITE_FONT_COLOR
            GameTooltip:AddDoubleLine("Total:", format("%d / %d", catchUpCurrent, catchUpTotal), nil, nil, nil, color.r, color.g, color.b)

            if Utils:TableCount(requirements) > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Unlock Catch-Up this week:", nil, nil, nil, true)
              Utils:TableForEach(requirements, function(value, name)
                color = value[1] == value[2] and GREEN_FONT_COLOR or WHITE_FONT_COLOR
                GameTooltip:AddDoubleLine(format("%s Points", name), format("%d / %d", value[1], value[2]), 1, 1, 1, color.r, color.g, color.b)
              end)
            end

            if variant and variant.catchUpItemID and variant.catchUpItemID > 0 then
              local item = Data.cache.items[variant.catchUpItemID]
              local itemCached = item and item:IsItemDataCached()
              local icon = itemCached and item:GetItemIcon() or 134400
              local name = itemCached and item:GetItemLink() or "Loading..."
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Catch-Up " .. (hasGathering and "Gathering" or "Patron Orders") .. ":")
              GameTooltip:AddLine(format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name))
            end

            GameTooltip:Show()
          end

          if variant and variant.catchUpItemID and variant.catchUpItemID > 0 then
            Data.cache.items[variant.catchUpItemID] = Item:CreateFromItemID(variant.catchUpItemID)
            Data.cache.items[variant.catchUpItemID]:ContinueOnItemLoad(showTooltip)
          end

          showTooltip()
        end,
        onLeave = function()
          GameTooltip:Hide()
        end,
      }
    end,
  }
  table.insert(columns, dataColumn)

  if unfiltered then
    return columns
  end

  local filteredColumns = Utils:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
