---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants
local Utils = addon.Utils
local UI = addon.UI
local Data = addon.Data
local Checklist = addon.Checklist
local LibDBIcon = LibStub("LibDBIcon-1.0")

---@class WK_Main
local Main = {}
addon.Main = Main

function Main:ToggleWindow()
  if not self.frame then return end
  if self.frame:IsVisible() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
  self:Render()
end

function Main:Render()
  local dataColumns = self:GetColumns()
  local tableWidth = 0
  local tableHeight = 0
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not self.frame then
    local frameName = addonName .. "MainWindow"
    self.frame = CreateFrame("Frame", frameName, UIParent)
    self.frame:SetSize(500, 500)
    self.frame:SetFrameStrata("HIGH")
    self.frame:SetFrameLevel(8000)
    self.frame:SetClampedToScreen(true)
    self.frame:SetMovable(true)
    self.frame:SetPoint("CENTER")
    self.frame:SetUserPlaced(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:EnableMouse(true)
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame:Hide()
    Utils:SetBackgroundColor(self.frame, Data.db.global.main.windowBackgroundColor.r, Data.db.global.main.windowBackgroundColor.g, Data.db.global.main.windowBackgroundColor.b, Data.db.global.main.windowBackgroundColor.a)

    self.frame.border = CreateFrame("Frame", "$parentBorder", self.frame, "BackdropTemplate")
    self.frame.border:SetPoint("TOPLEFT", self.frame, "TOPLEFT", -3, 3)
    self.frame.border:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 3, -3)
    self.frame.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.frame.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.frame.border:Show()

    self.frame.titlebar = CreateFrame("Frame", "$parentTitle", self.frame)
    self.frame.titlebar:SetPoint("TOPLEFT", self.frame, "TOPLEFT")
    self.frame.titlebar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT")
    self.frame.titlebar:SetHeight(Constants.TITLEBAR_HEIGHT)
    self.frame.titlebar:RegisterForDrag("LeftButton")
    self.frame.titlebar:EnableMouse(true)
    self.frame.titlebar:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame.titlebar:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    Utils:SetBackgroundColor(self.frame.titlebar, 0, 0, 0, 0.5)

    self.frame.titlebar.icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frame.titlebar.icon:SetPoint("LEFT", self.frame.titlebar, "LEFT", 6, 0)
    self.frame.titlebar.icon:SetSize(20, 20)
    self.frame.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")

    self.frame.titlebar.title = self.frame.titlebar:CreateFontString("$parentText", "OVERLAY")
    self.frame.titlebar.title:SetFontObject("SystemFont_Med2")
    self.frame.titlebar.title:SetPoint("LEFT", self.frame.titlebar, 28, 0)
    self.frame.titlebar.title:SetJustifyH("LEFT")
    self.frame.titlebar.title:SetJustifyV("MIDDLE")
    self.frame.titlebar.title:SetText(addonName)

    do -- Close Button
      self.frame.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.frame.titlebar)
      self.frame.titlebar.closeButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.frame.titlebar.closeButton:SetPoint("RIGHT", self.frame.titlebar, "RIGHT", 0, 0)
      self.frame.titlebar.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
      self.frame.titlebar.closeButton:SetScript("OnEnter", function()
        self.frame.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(self.frame.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
        GameTooltip:Show()
      end)
      self.frame.titlebar.closeButton:SetScript("OnLeave", function()
        self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      self.frame.titlebar.closeButton.Icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      self.frame.titlebar.closeButton.Icon:SetPoint("CENTER", self.frame.titlebar.closeButton, "CENTER")
      self.frame.titlebar.closeButton.Icon:SetSize(10, 10)
      self.frame.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
      self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Settings Button
      self.frame.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.frame.titlebar)
      self.frame.titlebar.SettingsButton:SetPoint("RIGHT", self.frame.titlebar.closeButton, "LEFT", 0, 0)
      self.frame.titlebar.SettingsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.frame.titlebar.SettingsButton:SetScript("OnEnter", function()
        self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.SettingsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.frame.titlebar.SettingsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Settings", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Let's customize things a bit", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.SettingsButton:SetScript("OnLeave", function()
        self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
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

        local interfaceTitle = rootMenu:CreateTitle("Interface")
        local windowScale = rootMenu:CreateButton("Window scale")
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
              Utils:SetBackgroundColor(self.frame, Data.db.global.main.windowBackgroundColor.r, Data.db.global.main.windowBackgroundColor.g, Data.db.global.main.windowBackgroundColor.b, Data.db.global.main.windowBackgroundColor.a)
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
              Utils:SetBackgroundColor(self.frame, Data.db.global.main.windowBackgroundColor.r, Data.db.global.main.windowBackgroundColor.g, Data.db.global.main.windowBackgroundColor.b, Data.db.global.main.windowBackgroundColor.a)
            end
          end,
          hasOpacity = 1,
        }
        rootMenu:CreateColorSwatch(
          "Window color",
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )
      end)

      self.frame.titlebar.SettingsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.frame.titlebar.SettingsButton, "CENTER")
      self.frame.titlebar.SettingsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Characters Button
      self.frame.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.frame.titlebar)
      self.frame.titlebar.CharactersButton:SetPoint("RIGHT", self.frame.titlebar.SettingsButton, "LEFT", 0, 0)
      self.frame.titlebar.CharactersButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.frame.titlebar.CharactersButton:SetScript("OnEnter", function()
        self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.CharactersButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.frame.titlebar.CharactersButton, "ANCHOR_TOP")
        GameTooltip:SetText("Characters", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable your characters.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.CharactersButton:SetScript("OnLeave", function()
        self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.CharactersButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.CharactersButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.CharactersButton.Icon:SetPoint("CENTER", self.frame.titlebar.CharactersButton, "CENTER")
      self.frame.titlebar.CharactersButton.Icon:SetSize(14, 14)
      self.frame.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Characters.blp")
      self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
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
      self.frame.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.frame.titlebar)
      self.frame.titlebar.ColumnsButton:SetPoint("RIGHT", self.frame.titlebar.CharactersButton, "LEFT", 0, 0)
      self.frame.titlebar.ColumnsButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.frame.titlebar.ColumnsButton:SetScript("OnEnter", function()
        self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.frame.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Columns", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable table columns.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.ColumnsButton:SetScript("OnLeave", function()
        self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = Data.db.global.main.hiddenColumns
        Utils:TableForEach(self:GetColumns(true), function(column)
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

      self.frame.titlebar.ColumnsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.ColumnsButton.Icon:SetPoint("CENTER", self.frame.titlebar.ColumnsButton, "CENTER")
      self.frame.titlebar.ColumnsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Columns.blp")
      self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Checklist Button
      self.frame.titlebar.ChecklistButton = CreateFrame("Button", "$parentChecklistButton", self.frame.titlebar)
      self.frame.titlebar.ChecklistButton:SetPoint("RIGHT", self.frame.titlebar.ColumnsButton, "LEFT", 0, 0)
      self.frame.titlebar.ChecklistButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.frame.titlebar.ChecklistButton:SetScript("OnEnter", function()
        self.frame.titlebar.ChecklistButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.ChecklistButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(self.frame.titlebar.ChecklistButton, "ANCHOR_TOP")
        GameTooltip:SetText("Checklist", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Toggle the Checklist window", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.ChecklistButton:SetScript("OnLeave", function()
        self.frame.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.ChecklistButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.ChecklistButton:SetScript("OnClick", function()
        Data.db.global.main.checklistHelpTipClosed = true
        Checklist:ToggleWindow()
      end)

      self.frame.titlebar.ChecklistButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.ChecklistButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.ChecklistButton.Icon:SetPoint("CENTER", self.frame.titlebar.ChecklistButton, "CENTER")
      self.frame.titlebar.ChecklistButton.Icon:SetSize(16, 16)
      self.frame.titlebar.ChecklistButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Checklist.blp")
      self.frame.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    self.frame.table = UI:CreateTableFrame({
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
    self.frame.table:SetParent(self.frame)
    self.frame.table:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -Constants.TITLEBAR_HEIGHT)
    self.frame.table:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)

    table.insert(UISpecialFrames, frameName)
  end

  -- Show helptip for new checklist
  local checklistHelpTipText = "Check out the new checklist!"
  if Data.db.global.main.checklistHelpTipClosed then
    HelpTip:Hide(self.frame, checklistHelpTipText)
  else
    HelpTip:Show(
      self.frame,
      {
        text = checklistHelpTipText,
        buttonStyle = HelpTip.ButtonStyle.Close,
        targetPoint = HelpTip.Point.TopEdgeCenter,
        onAcknowledgeCallback = function()
          Data.db.global.main.checklistHelpTipClosed = true
        end,
      },
      self.frame.titlebar.ChecklistButton
    )
  end

  do -- Column config
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

  do -- Header row
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
    tableHeight = tableHeight + self.frame.table.config.header.height
  end

  Utils:TableForEach(Data:GetCharacters(), function(character)
    Utils:TableForEach(character.professions, function(characterProfession)
      ---@type WK_TableDataRow
      local row = {columns = {}}

      local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
        return dataProfession.skillLineID == characterProfession.skillLineID
      end)
      if not dataProfession then return end

      Utils:TableForEach(dataColumns, function(dataColumn)
        ---@type WK_TableDataCell
        local cell = dataColumn.cell(character, characterProfession, dataProfession)
        table.insert(row.columns, cell)
      end)

      table.insert(tableData.rows, row)
      tableHeight = tableHeight + self.frame.table.config.rows.height
    end)
  end)

  self.frame.table:SetData(tableData)
  self.frame:SetWidth(tableWidth)
  self.frame:SetHeight(math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT))
  self.frame:SetScale(Data.db.global.main.windowScale / 100)
end

function Main:GetColumns(unfiltered)
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
          if objective.category == dataObjective then
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

              if objective.category == Data.Objectives.DarkmoonQuest then
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
