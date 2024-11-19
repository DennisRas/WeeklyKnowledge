---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Main
local Main = {}
addon.Main = Main

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Constants = addon.Constants
local Utils = addon.Utils
local UI = addon.UI
local Data = addon.Data
local Checklist = addon.Checklist
local LibDBIcon = LibStub("LibDBIcon-1.0")

function Main:ToggleWindow()
  if not self.window then return end
  if self.window:IsVisible() then
    self.window:Hide()
  else
    self.window:Show()
  end
  self:Render()
end

function Main:Render()
  local dataColumns = self:GetMainColumns()
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

    do -- Close Button
      self.window.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.window.titlebar)
      self.window.titlebar.closeButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.closeButton:SetPoint("RIGHT", self.window.titlebar, "RIGHT", 0, 0)
      self.window.titlebar.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
      self.window.titlebar.closeButton:SetScript("OnEnter", function()
        self.window.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        Utils:SetBackgroundColor(self.window.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(self.window.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText(L["CloseTheWindow"], 1, 1, 1, 1, true);
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
        GameTooltip:SetText(L["Settings"], 1, 1, 1, 1, true);
        GameTooltip:AddLine(L["SettingsDesc"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.SettingsButton:SetScript("OnLeave", function()
        self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
        local showMinimapIcon = rootMenu:CreateCheckbox(
          L["ShowTheMinimapButton"],
          function() return not Data.db.global.minimap.hide end,
          function()
            Data.db.global.minimap.hide = not Data.db.global.minimap.hide
            LibDBIcon:Refresh(addonName, Data.db.global.minimap)
          end
        )
        showMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, L["ShowMinimapIconDesc"]);
        end)

        local lockMinimapIcon = rootMenu:CreateCheckbox(
          L["LockMinimapIcon"],
          function() return Data.db.global.minimap.lock end,
          function()
            Data.db.global.minimap.lock = not Data.db.global.minimap.lock
            LibDBIcon:Refresh(addonName, Data.db.global.minimap)
          end
        )
        lockMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, L["LockMinimapIconDesc"]);
        end)

        rootMenu:CreateTitle(L["Window"])
        local windowScale = rootMenu:CreateButton(L["Scaling"])
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
          L["BackgroundColor"],
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )

        rootMenu:CreateCheckbox(
          L["ShowTheBorder"],
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
        GameTooltip:SetText(L["Characters"], 1, 1, 1, 1, true);
        GameTooltip:AddLine(L["CharactersDesc"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
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
        Utils:TableForEach(Data:GetCharacters(true), function(character)
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

          local characterButton = rootMenu:CreateCheckbox(
            name,
            function() return character.enabled or false end,
            function()
              character.enabled = not character.enabled
              self:Render()
            end
          )

          if Utils:TableCount(character.professions) > 0 then
            Utils:TableForEach(character.professions, function(characterProfession)
              local profession = Utils:TableGet(Data.Professions, "skillLineID", characterProfession.skillLineID)
              local professionName = "?"
              if profession then
                professionName = profession.name
              end
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
        end)
      end)
    end

    do -- Columns Button
      self.window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.window.titlebar)
      self.window.titlebar.ColumnsButton:SetPoint("RIGHT", self.window.titlebar.CharactersButton, "LEFT", 0, 0)
      self.window.titlebar.ColumnsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.ColumnsButton:SetScript("OnEnter", function()
        self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.window.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText(L["Columns"], 1, 1, 1, 1, true);
        GameTooltip:AddLine(L["ColumnsDesc"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.ColumnsButton:SetScript("OnLeave", function()
        self.window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.window.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = Data.db.global.main.hiddenColumns
        Utils:TableForEach(self:GetMainColumns(true), function(column)
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
        GameTooltip:SetText(L["Checklist"], 1, 1, 1, 1, true);
        GameTooltip:AddLine(L["ChecklistDesc"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
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

    table.insert(UISpecialFrames, frameName)
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

  do -- Table Column config
    Utils:TableForEach(dataColumns, function(dataColumn)
      ---@type WK_TableDataColumn
      local column = {
        width = dataColumn.width,
        align = dataColumn.align or "LEFT",
      }
      table.insert(tableData.columns, column)
      tableWidth = tableWidth + dataColumn.width
    end)
  end

  do -- Table Header row
    ---@type WK_TableDataRow
    local row = {columns = {}}
    Utils:TableForEach(dataColumns, function(dataColumn)
      ---@type WK_TableDataCell
      local cell = {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(dataColumn.name),
        onEnter = dataColumn.onEnter,
        onLeave = dataColumn.onLeave,
      }
      table.insert(row.columns, cell)
    end)
    table.insert(tableData.rows, row)
    tableHeight = tableHeight + self.window.table.config.header.height
  end

  do -- Table data
    Utils:TableForEach(Data:GetCharacters(), function(character)
      Utils:TableForEach(character.professions, function(characterProfession)
        if not characterProfession.enabled then return end
        local profession = Utils:TableGet(Data.Professions, "skillLineID", characterProfession.skillLineID)
        if not profession then return end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        Utils:TableForEach(dataColumns, function(dataColumn)
          ---@type WK_TableDataCell
          local cell = dataColumn.cell(character, characterProfession, profession)
          table.insert(row.columns, cell)
        end)

        table.insert(tableData.rows, row)
        tableHeight = tableHeight + self.window.table.config.rows.height
      end)
    end)
  end

  self.window.titlebar.title:SetShown(tableWidth > minWindowWidth)
  self.window.border:SetShown(Data.db.global.main.windowBorder)
  self.window.table:SetData(tableData)
  self.window:SetWidth(math.max(tableWidth, minWindowWidth))
  self.window:SetHeight(math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT) + 2)
  self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
  self.window:SetScale(Data.db.global.main.windowScale / 100)
end

---Get columns for the table
---@param unfiltered boolean?
---@return WK_DataColumn[]
function Main:GetMainColumns(unfiltered)
  local hidden = Data.db.global.main.hiddenColumns
  ---@type WK_DataColumn[]
  local columns = {
    {
      name = L["Name"],
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Name"], 1, 1, 1);
        GameTooltip:AddLine(L["NameDesc"])
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
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
      name = L["Realm"],
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Realm"], 1, 1, 1);
        GameTooltip:AddLine(L["RealmDesc"])
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
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
      name = L["Profession"],
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Profession"], 1, 1, 1);
        GameTooltip:AddLine(L["ProfessionDesc"])
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 80,
      toggleHidden = true,
      cell = function(_, _, dataProfession)
        return {text = dataProfession.name}
      end,
    },
    {
      name = L["Skill"],
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["Skill"], 1, 1, 1);
        GameTooltip:AddLine(L["SkillDesc"])
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
      cell = function(_, characterProfession)
        return {text = characterProfession.level > 0 and characterProfession.level == characterProfession.maxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(characterProfession.level .. " / " .. characterProfession.maxLevel) or characterProfession.level .. " / " .. characterProfession.maxLevel}
      end,
    },
    {
      name = L["Knowledge"],
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(L["KnowledgePoints"], 1, 1, 1);
        GameTooltip:AddLine(L["KnowledgePointsDesc"])
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      toggleHidden = true,
      cell = function(_, characterProfession, dataProfession)
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
            GameTooltip:SetText(dataProfession.name, 1, 1, 1)
            GameTooltip:AddDoubleLine(L["PointsSpentAt"], pointsSpentValue, nil, nil, nil, pointsSpentColor.r, pointsSpentColor.g, pointsSpentColor.b)
            GameTooltip:AddDoubleLine(L["PointsUnspentAt"], pointsUnspentValue, nil, nil, nil, pointsUnspentColor.r, pointsUnspentColor.g, pointsUnspentColor.b)
            GameTooltip:AddDoubleLine(L["MaxAt"], pointsMaxValue, nil, nil, nil, pointsMaxColor.r, pointsMaxColor.g, pointsMaxColor.b)

            if characterProfession.specializations and Utils:TableCount(characterProfession.specializations) > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine(L["SpecializationsAt"])
              Utils:TableForEach(characterProfession.specializations, function(characterProfessionSpecialization)
                local name = characterProfessionSpecialization.name
                if strlenutf8(name) > 30 then
                  name = strsub(name, 1, 30) .. "..."
                end
                local value = format("%d / %d", characterProfessionSpecialization.knowledgeLevel or 0, characterProfessionSpecialization.knowledgeMaxLevel or 0)
                if characterProfessionSpecialization.rootIconID then
                  name = "|T" .. characterProfessionSpecialization.rootIconID .. ":12|t " .. name
                end
                if characterProfessionSpecialization.state and characterProfessionSpecialization.state == Enum.ProfessionsSpecTabState.Locked then
                  value = LIGHTGRAY_FONT_COLOR:WrapTextInColorCode(L["Locked"])
                end
                if characterProfessionSpecialization.state and characterProfessionSpecialization.state == Enum.ProfessionsSpecTabState.Unlockable then
                  value = DIM_GREEN_FONT_COLOR:WrapTextInColorCode(L["CanUnlock"])
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

  local weeklyProgress = Data:GetWeeklyProgress()

  Utils:TableForEach(Data.ObjectiveTypes, function(objectiveType)
    if objectiveType.id == Enum.WK_Objectives.DarkmoonQuest then
      if not Data.cache.isDarkmoonOpen then
        return
      end
    end

    ---@type WK_DataColumn
    local dataColumn = {
      name = objectiveType.name,
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(objectiveType.name, 1, 1, 1);
        GameTooltip:AddLine(objectiveType.description, nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      toggleHidden = true,
      align = "CENTER",
      cell = function(character, characterProfession, profession)
        if not characterProfession.knowledgeMaxLevel or characterProfession.knowledgeMaxLevel == 0 then
          return {text = ""}
        end

        local questsCompleted = 0
        local questsTotal = 0
        local pointsEarned = 0
        local pointsTotal = 0
        local items = {}

        local progress = Utils:TableFilter(weeklyProgress, function(progress)
          return progress.character == character and progress.profession == profession and progress.objective.typeID == objectiveType.id
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
            local label = L["Items"]
            if objectiveType.type == "quest" then
              label = L["Quests"]
            end

            local showTooltip = function()
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText(objectiveType.name, 1, 1, 1);
              GameTooltip:AddDoubleLine(label, format("%d / %d", questsCompleted, questsTotal), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine(L["KnowledgePointsAt"], format("%d / %d", pointsEarned, pointsTotal), nil, nil, nil, 1, 1, 1)
              if Utils:TableCount(items) > 0 then
                GameTooltip:AddLine(" ")
                for itemID, itemLooted in pairs(items) do
                  local item = Data.cache.items[itemID]
                  local itemCached = item and item:IsItemDataCached()
                  local icon = itemCached and item:GetItemIcon() or 134400
                  local name = itemCached and item:GetItemLink() or L["ItemLinkLoading"]
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

  table.insert(columns, {
    name = "Catch-Up",
    onEnter = function(cellFrame)
      GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
      GameTooltip:SetText(L["Catch-Up"], 1, 1, 1);
      GameTooltip:AddLine(L["Catch-UpDesc"], nil, nil, nil, true)
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
    cell = function(character, characterProfession, profession)
      if not characterProfession.catchUpCurrencyInfo then
        return {
          text = "-",
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(L["NoData"], 1, 1, 1);
            GameTooltip:AddLine(L["NoDataDesc"], nil, nil, nil, true);
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end

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
        return progress.character == character and progress.profession == profession and (
          progress.objective.typeID == Enum.WK_Objectives.ArtisanQuest
          or progress.objective.typeID == Enum.WK_Objectives.Treasure
          or progress.objective.typeID == Enum.WK_Objectives.Gathering
          or progress.objective.typeID == Enum.WK_Objectives.TrainerQuest
        )
      end)
      local hasGathering = Utils:TableFind(progress, function(prog)
        return prog.objective.typeID == Enum.WK_Objectives.Gathering
      end)
      Utils:TableForEach(progress, function(prog)
        local objectiveType = Utils:TableGet(Data.ObjectiveTypes, "id", prog.objective.typeID)
        if not objectiveType then return end
        if prog.questsTotal == 0 then return end
        sumPointsEarned = sumPointsEarned + prog.pointsEarned
        sumPointsTotal = sumPointsTotal + prog.pointsTotal

        -- Only gathering professions require completed gathering before catch-up unlocks
        if not hasGathering then return end
        if not requirements[objectiveType.name] then
          requirements[objectiveType.name] = {0, 0}
        end
        requirements[objectiveType.name][1] = requirements[objectiveType.name][1] + prog.pointsEarned
        requirements[objectiveType.name][2] = requirements[objectiveType.name][2] + prog.pointsTotal
      end)

      return {
        text = format(textColor:WrapTextInColorCode("%d / %d"), catchUpCurrent, catchUpTotal),
        onEnter = function(cellFrame)
          local showTooltip = function()
            local color = WHITE_FONT_COLOR

            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(L["Catch-Up"], 1, 1, 1)
            color = sumPointsEarned == sumPointsTotal and GREEN_FONT_COLOR or WHITE_FONT_COLOR
            GameTooltip:AddDoubleLine(L["WeeklyPointsAt"], format("%d / %d", sumPointsEarned, sumPointsTotal), nil, nil, nil, color.r, color.g, color.b)
            color = catchUpCurrent - sumPointsEarned == catchUpTotal - sumPointsTotal and GREEN_FONT_COLOR or WHITE_FONT_COLOR
            GameTooltip:AddDoubleLine(L["Catch-UpPointsAt"], format("%d / %d", catchUpCurrent - sumPointsEarned, catchUpTotal - sumPointsTotal), nil, nil, nil, color.r, color.g, color.b)
            color = catchUpCurrent == catchUpTotal and GREEN_FONT_COLOR or WHITE_FONT_COLOR
            GameTooltip:AddDoubleLine(L["TotalAt"], format("%d / %d", catchUpCurrent, catchUpTotal), nil, nil, nil, color.r, color.g, color.b)

            if Utils:TableCount(requirements) > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine(L["UnlockCatch-UpDesc"], nil, nil, nil, true)
              Utils:TableForEach(requirements, function(value, name)
                color = value[1] == value[2] and GREEN_FONT_COLOR or WHITE_FONT_COLOR
                GameTooltip:AddDoubleLine(format(L["fmtPoints"], name), format("%d / %d", value[1], value[2]), 1, 1, 1, color.r, color.g, color.b)
              end)
            end

            if profession.catchUpItemID and profession.catchUpItemID > 0 then
              local item = Data.cache.items[profession.catchUpItemID]
              local itemCached = item and item:IsItemDataCached()
              local icon = itemCached and item:GetItemIcon() or 134400
              local name = itemCached and item:GetItemLink() or "Loading..."
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine(L["Catch-UpSpc"] .. (hasGathering and L["Gathering"] or L["PatronOrders"]) .. ":")
              GameTooltip:AddLine(format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name))
            end

            GameTooltip:Show()
          end

          if profession.catchUpItemID and profession.catchUpItemID > 0 then
            Data.cache.items[profession.catchUpItemID] = Item:CreateFromItemID(profession.catchUpItemID)
            Data.cache.items[profession.catchUpItemID]:ContinueOnItemLoad(showTooltip)
          end

          showTooltip()
        end,
        onLeave = function()
          GameTooltip:Hide()
        end,
      }
    end,
  })

  if unfiltered then
    return columns
  end

  local filteredColumns = Utils:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
