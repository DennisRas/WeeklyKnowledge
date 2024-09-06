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

function Main:ToggleMainWindow()
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
    self.window:SetFrameStrata("HIGH")
    self.window:SetFrameLevel(8000)
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
      self.window.titlebar.closeButton:SetScript("OnClick", function() self:ToggleMainWindow() end)
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
        Utils:TableForEach(Data:GetCharacters(true), function(character)
          local text = format("%s - %s", character.name, character.realmName)
          local _, classFile = GetClassInfo(character.classID)
          if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
              text = color:WrapTextInColorCode(text)
            end
          end

          rootMenu:CreateCheckbox(
            text,
            function() return character.enabled or false end,
            function()
              character.enabled = not character.enabled
              self:Render()
            end
          )
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
        Data.db.global.main.checklistHelpTipClosed = true
        Checklist:ToggleWindow()
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

  do -- Show helptip for new checklist
    local checklistHelpTipText = "Check out the new checklist!"
    if Data.db.global.main.checklistHelpTipClosed then
      HelpTip:Hide(self.window, checklistHelpTipText)
    else
      HelpTip:Show(
        self.window,
        {
          text = checklistHelpTipText,
          buttonStyle = HelpTip.ButtonStyle.Close,
          targetPoint = HelpTip.Point.TopEdgeCenter,
          onAcknowledgeCallback = function()
            Data.db.global.main.checklistHelpTipClosed = true
          end,
        },
        self.window.titlebar.ChecklistButton
      )
    end
  end

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
        local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
          return dataProfession.skillLineID == characterProfession.skillLineID
        end)
        if not dataProfession then return end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        Utils:TableForEach(dataColumns, function(dataColumn)
          ---@type WK_TableDataCell
          local cell = dataColumn.cell(character, characterProfession, dataProfession)
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
  self.window:SetHeight(math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT))
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
      name = "Name",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Name", 1, 1, 1);
        GameTooltip:AddLine("Your characters.")
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
        local characterName = character.name
        local _, classFile = GetClassInfo(character.classID)
        if classFile then
          local color = C_ClassColor.GetClassColor(classFile)
          if color then
            characterName = color:WrapTextInColorCode(characterName)
          end
        end
        return {text = characterName}
      end,
    },
    {
      name = "Realm",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Realm", 1, 1, 1);
        GameTooltip:AddLine("Realm names.")
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
      name = "Profession",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Profession", 1, 1, 1);
        GameTooltip:AddLine("Your professions.")
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
      name = "Skill",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Skill", 1, 1, 1);
        GameTooltip:AddLine("Current skill levels.")
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
      name = "Knowledge",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Knowledge", 1, 1, 1);
        GameTooltip:AddLine("Current knowledge gained.")
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
        if characterProfession.knowledgeMaxLevel > 0 then
          return {text = characterProfession.knowledgeLevel > 0 and characterProfession.knowledgeLevel == characterProfession.knowledgeMaxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(characterProfession.knowledgeLevel .. " / " .. characterProfession.knowledgeMaxLevel) or characterProfession.knowledgeLevel .. " / " .. characterProfession.knowledgeMaxLevel}
        end
        return {text = ""}
      end,
    },
  }

  Utils:TableForEach(Data.Objectives, function(dataObjective)
    ---@type WK_DataColumn
    local dataColumn = {
      name = dataObjective.name,
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(dataObjective.name, 1, 1, 1);
        GameTooltip:AddLine(dataObjective.description, nil, nil, nil, true)
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      toggleHidden = true,
      align = "CENTER",
      cell = function(character, characterProfession, dataProfession)
        if not characterProfession.knowledgeMaxLevel or characterProfession.knowledgeMaxLevel == 0 then
          return {text = ""}
        end

        local completed = 0
        local total = 0
        local points = 0
        local pointsTotal = 0
        local itemList = {}

        for _, objective in ipairs(dataProfession.objectives) do
          if objective.objectiveID == dataObjective.id then
            if objective.quests then
              local limit = 0

              if objective.itemID and objective.itemID > 0 then
                itemList[objective.itemID] = false
              end
              for _, questID in ipairs(objective.quests) do
                total = total + 1
                pointsTotal = pointsTotal + objective.points
                if objective.limit and total > objective.limit then
                  pointsTotal = objective.limit * objective.points
                  total = objective.limit
                end
                if character.completed[questID] then
                  if objective.itemID and objective.itemID > 0 then
                    itemList[objective.itemID] = true
                  end
                  completed = completed + 1
                  points = points + objective.points
                end
              end

              if objective.objectiveID == Enum.WK_Objectives.DarkmoonQuest then
                if not Data.cache.isDarkmoonOpen then
                  total = 0
                end
              end
            end
          end
        end

        local result = completed .. " / " .. total
        if total == 0 then
          result = ""
        elseif completed == total then
          result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
        end

        if total == 0 then
          return {text = ""}
        else
          return {
            text = result,
            onEnter = function(cellFrame)
              local label = "Items:"
              if dataObjective.type == "quest" then
                label = "Quests:"
              end

              local showTooltip = function()
                GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
                GameTooltip:SetText(dataObjective.name, 1, 1, 1);
                GameTooltip:AddDoubleLine(label, format("%d / %d", completed, total), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", points, pointsTotal), nil, nil, nil, 1, 1, 1)
                if Utils:TableCount(itemList) > 0 then
                  GameTooltip:AddLine(" ")
                  for itemID, itemLooted in pairs(itemList) do
                    local item = Data.cache.items[itemID]
                    GameTooltip:AddDoubleLine(
                      item and item:GetItemLink() or "Loading...",
                      CreateAtlasMarkup(itemLooted and "common-icon-checkmark" or "common-icon-redx", 12, 12)
                    )
                  end
                end
                GameTooltip:Show()
              end

              for itemID in pairs(itemList) do
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
      end
    }
    table.insert(columns, dataColumn)
  end)

  if unfiltered then
    return columns
  end

  local filteredColumns = Utils:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
