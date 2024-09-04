---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge
local LibDBIcon = LibStub("LibDBIcon-1.0")
local window = nil

function WK:ToggleMainWindow()
  if not window then return end
  if window:IsVisible() then
    window:Hide()
  else
    window:Show()
  end
  self:Render()
end

function WK:RenderMain()
  local dataColumns = self:GetMainColumns()
  local tableWidth = 0
  local tableHeight = 0
  local minWindowWidth = 300
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not window then
    local frameName = addonName .. "MainWindow"
    window = CreateFrame("Frame", frameName, UIParent)
    window:SetSize(500, 500)
    window:SetFrameStrata("HIGH")
    window:SetFrameLevel(8000)
    window:SetClampedToScreen(true)
    window:SetMovable(true)
    window:SetPoint("CENTER")
    window:SetUserPlaced(true)
    window:RegisterForDrag("LeftButton")
    window:EnableMouse(true)
    window:SetScript("OnDragStart", function() window:StartMoving() end)
    window:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
    window:Hide()
    self:SetBackgroundColor(window, self.db.global.main.windowBackgroundColor.r, self.db.global.main.windowBackgroundColor.g, self.db.global.main.windowBackgroundColor.b, self.db.global.main.windowBackgroundColor.a)

    window.border = CreateFrame("Frame", "$parentBorder", window, "BackdropTemplate")
    window.border:SetPoint("TOPLEFT", window, "TOPLEFT", -3, 3)
    window.border:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 3, -3)
    window.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    window.border:SetBackdropBorderColor(0, 0, 0, .5)
    window.border:Show()

    window.titlebar = CreateFrame("Frame", "$parentTitle", window)
    window.titlebar:SetPoint("TOPLEFT", window, "TOPLEFT")
    window.titlebar:SetPoint("TOPRIGHT", window, "TOPRIGHT")
    window.titlebar:SetHeight(self.Constants.TITLEBAR_HEIGHT)
    window.titlebar:RegisterForDrag("LeftButton")
    window.titlebar:EnableMouse(true)
    window.titlebar:SetScript("OnDragStart", function() window:StartMoving() end)
    window.titlebar:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
    self:SetBackgroundColor(window.titlebar, 0, 0, 0, 0.5)

    window.titlebar.icon = window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    window.titlebar.icon:SetPoint("LEFT", window.titlebar, "LEFT", 6, 0)
    window.titlebar.icon:SetSize(20, 20)
    window.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")

    window.titlebar.title = window.titlebar:CreateFontString("$parentText", "OVERLAY")
    window.titlebar.title:SetFontObject("SystemFont_Med2")
    window.titlebar.title:SetPoint("LEFT", window.titlebar, 28, 0)
    window.titlebar.title:SetJustifyH("LEFT")
    window.titlebar.title:SetJustifyV("MIDDLE")
    window.titlebar.title:SetText(addonName)

    do -- Close Button
      window.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", window.titlebar)
      window.titlebar.closeButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      window.titlebar.closeButton:SetPoint("RIGHT", window.titlebar, "RIGHT", 0, 0)
      window.titlebar.closeButton:SetScript("OnClick", function() self:ToggleMainWindow() end)
      window.titlebar.closeButton:SetScript("OnEnter", function()
        window.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        self:SetBackgroundColor(window.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(window.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
        GameTooltip:Show()
      end)
      window.titlebar.closeButton:SetScript("OnLeave", function()
        window.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(window.titlebar.closeButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      window.titlebar.closeButton.Icon = window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      window.titlebar.closeButton.Icon:SetPoint("CENTER", window.titlebar.closeButton, "CENTER")
      window.titlebar.closeButton.Icon:SetSize(10, 10)
      window.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
      window.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Settings Button
      window.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", window.titlebar)
      window.titlebar.SettingsButton:SetPoint("RIGHT", window.titlebar.closeButton, "LEFT", 0, 0)
      window.titlebar.SettingsButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      window.titlebar.SettingsButton:SetScript("OnEnter", function()
        window.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(window.titlebar.SettingsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(window.titlebar.SettingsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Settings", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Let's customize things a bit", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      window.titlebar.SettingsButton:SetScript("OnLeave", function()
        window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(window.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      window.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
        local showMinimapIcon = rootMenu:CreateCheckbox(
          "Show the minimap button",
          function() return not self.db.global.minimap.hide end,
          function()
            self.db.global.minimap.hide = not self.db.global.minimap.hide
            LibDBIcon:Refresh(addonName, self.db.global.minimap)
          end
        )
        showMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "It does get crowded around the minimap sometimes.");
        end)

        local lockMinimapIcon = rootMenu:CreateCheckbox(
          "Lock the minimap button",
          function() return self.db.global.minimap.lock end,
          function()
            self.db.global.minimap.lock = not self.db.global.minimap.lock
            LibDBIcon:Refresh(addonName, self.db.global.minimap)
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
            function() return self.db.global.main.windowScale == i end,
            function(data)
              self.db.global.main.windowScale = data
              self:Render()
            end,
            i
          )
        end

        local colorInfo = {
          r = self.db.global.main.windowBackgroundColor.r,
          g = self.db.global.main.windowBackgroundColor.g,
          b = self.db.global.main.windowBackgroundColor.b,
          opacity = self.db.global.main.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              self.db.global.main.windowBackgroundColor.r = r
              self.db.global.main.windowBackgroundColor.g = g
              self.db.global.main.windowBackgroundColor.b = b
              if a then
                self.db.global.main.windowBackgroundColor.a = a
              end
              self:SetBackgroundColor(window, self.db.global.main.windowBackgroundColor.r, self.db.global.main.windowBackgroundColor.g, self.db.global.main.windowBackgroundColor.b, self.db.global.main.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              self.db.global.main.windowBackgroundColor.r = color.r
              self.db.global.main.windowBackgroundColor.g = color.g
              self.db.global.main.windowBackgroundColor.b = color.b
              if color.a then
                self.db.global.main.windowBackgroundColor.a = color.a
              end
              self:SetBackgroundColor(window, self.db.global.main.windowBackgroundColor.r, self.db.global.main.windowBackgroundColor.g, self.db.global.main.windowBackgroundColor.b, self.db.global.main.windowBackgroundColor.a)
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
          function() return self.db.global.main.windowBorder end,
          function()
            self.db.global.main.windowBorder = not self.db.global.main.windowBorder
            self:Render()
          end
        )
      end)

      window.titlebar.SettingsButton.Icon = window.titlebar:CreateTexture(window.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      window.titlebar.SettingsButton.Icon:SetPoint("CENTER", window.titlebar.SettingsButton, "CENTER")
      window.titlebar.SettingsButton.Icon:SetSize(12, 12)
      window.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Characters Button
      window.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", window.titlebar)
      window.titlebar.CharactersButton:SetPoint("RIGHT", window.titlebar.SettingsButton, "LEFT", 0, 0)
      window.titlebar.CharactersButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      window.titlebar.CharactersButton:SetScript("OnEnter", function()
        window.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(window.titlebar.CharactersButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(window.titlebar.CharactersButton, "ANCHOR_TOP")
        GameTooltip:SetText("Characters", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable your characters.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      window.titlebar.CharactersButton:SetScript("OnLeave", function()
        window.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(window.titlebar.CharactersButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      window.titlebar.CharactersButton.Icon = window.titlebar:CreateTexture(window.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
      window.titlebar.CharactersButton.Icon:SetPoint("CENTER", window.titlebar.CharactersButton, "CENTER")
      window.titlebar.CharactersButton.Icon:SetSize(14, 14)
      window.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Characters.blp")
      window.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      window.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
        self:TableForEach(self:GetCharacters(true), function(character)
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
      window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", window.titlebar)
      window.titlebar.ColumnsButton:SetPoint("RIGHT", window.titlebar.CharactersButton, "LEFT", 0, 0)
      window.titlebar.ColumnsButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      window.titlebar.ColumnsButton:SetScript("OnEnter", function()
        window.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(window.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(window.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Columns", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable table columns.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      window.titlebar.ColumnsButton:SetScript("OnLeave", function()
        window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(window.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      window.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = self.db.global.main.hiddenColumns
        self:TableForEach(self:GetMainColumns(true), function(column)
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

      window.titlebar.ColumnsButton.Icon = window.titlebar:CreateTexture(window.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
      window.titlebar.ColumnsButton.Icon:SetPoint("CENTER", window.titlebar.ColumnsButton, "CENTER")
      window.titlebar.ColumnsButton.Icon:SetSize(12, 12)
      window.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Columns.blp")
      window.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Checklist Button
      window.titlebar.ChecklistButton = CreateFrame("Button", "$parentChecklistButton", window.titlebar)
      window.titlebar.ChecklistButton:SetPoint("RIGHT", window.titlebar.ColumnsButton, "LEFT", 0, 0)
      window.titlebar.ChecklistButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      window.titlebar.ChecklistButton:SetScript("OnEnter", function()
        window.titlebar.ChecklistButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(window.titlebar.ChecklistButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(window.titlebar.ChecklistButton, "ANCHOR_TOP")
        GameTooltip:SetText("Checklist", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Toggle the Checklist window", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      window.titlebar.ChecklistButton:SetScript("OnLeave", function()
        window.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(window.titlebar.ChecklistButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      window.titlebar.ChecklistButton:SetScript("OnClick", function()
        self.db.global.main.checklistHelpTipClosed = true
        self:ToggleChecklistWindow()
      end)

      window.titlebar.ChecklistButton.Icon = window.titlebar:CreateTexture(window.titlebar.ChecklistButton:GetName() .. "Icon", "ARTWORK")
      window.titlebar.ChecklistButton.Icon:SetPoint("CENTER", window.titlebar.ChecklistButton, "CENTER")
      window.titlebar.ChecklistButton.Icon:SetSize(16, 16)
      window.titlebar.ChecklistButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Checklist.blp")
      window.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    window.table = self:CreateTableFrame({
      header = {
        enabled = true,
        sticky = true,
        height = self.Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = self.Constants.TABLE_ROW_HEIGHT,
        highlight = true,
        striped = true
      }
    })
    window.table:SetParent(window)
    window.table:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -self.Constants.TITLEBAR_HEIGHT)
    window.table:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, 0)

    table.insert(UISpecialFrames, frameName)
  end

  do -- Show helptip for new checklist
    local checklistHelpTipText = "Check out the new checklist!"
    if self.db.global.main.checklistHelpTipClosed then
      HelpTip:Hide(window, checklistHelpTipText)
    else
      HelpTip:Show(
        window,
        {
          text = checklistHelpTipText,
          buttonStyle = HelpTip.ButtonStyle.Close,
          targetPoint = HelpTip.Point.TopEdgeCenter,
          onAcknowledgeCallback = function()
            self.db.global.main.checklistHelpTipClosed = true
          end,
        },
        window.titlebar.ChecklistButton
      )
    end
  end

  do -- Table Column config
    self:TableForEach(dataColumns, function(dataColumn)
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
    self:TableForEach(dataColumns, function(dataColumn)
      ---@type WK_TableDataCell
      local cell = {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(dataColumn.name),
        onEnter = dataColumn.onEnter,
        onLeave = dataColumn.onLeave,
      }
      table.insert(row.columns, cell)
    end)
    table.insert(tableData.rows, row)
    tableHeight = tableHeight + window.table.config.header.height
  end

  do -- Table data
    self:TableForEach(self:GetCharacters(), function(character)
      self:TableForEach(character.professions, function(characterProfession)
        local dataProfession = self:TableFind(self.Professions, function(dataProfession)
          return dataProfession.skillLineID == characterProfession.skillLineID
        end)
        if not dataProfession then return end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        self:TableForEach(dataColumns, function(dataColumn)
          ---@type WK_TableDataCell
          local cell = dataColumn.cell(character, characterProfession, dataProfession)
          table.insert(row.columns, cell)
        end)

        table.insert(tableData.rows, row)
        tableHeight = tableHeight + window.table.config.rows.height
      end)
    end)
  end

  window.titlebar.title:SetShown(tableWidth > minWindowWidth)
  window.border:SetShown(self.db.global.main.windowBorder)
  window.table:SetData(tableData)
  window:SetWidth(math.max(tableWidth, minWindowWidth))
  window:SetHeight(math.min(tableHeight + self.Constants.TITLEBAR_HEIGHT, self.Constants.MAX_WINDOW_HEIGHT))
  window:SetScale(self.db.global.main.windowScale / 100)
end

function WK:GetMainColumns(unfiltered)
  local hidden = self.db.global.main.hiddenColumns
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

  self:TableForEach(self.Objectives, function(dataObjective)
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
                if not self.cache.isDarkmoonOpen then
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
                if self:TableCount(itemList) > 0 then
                  GameTooltip:AddLine(" ")
                  for itemID, itemLooted in pairs(itemList) do
                    local item = self.cache.items[itemID]
                    GameTooltip:AddDoubleLine(
                      item and item:GetItemLink() or "Loading...",
                      CreateAtlasMarkup(itemLooted and "common-icon-checkmark" or "common-icon-redx", 12, 12)
                    )
                  end
                end
                GameTooltip:Show()
              end

              for itemID in pairs(itemList) do
                self.cache.items[itemID] = Item:CreateFromItemID(itemID)
                self.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
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

  local filteredColumns = self:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
