---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge
local LibDBIcon = LibStub("LibDBIcon-1.0")
local frame = nil

function WK:ToggleMainWindow()
  if not frame then return end
  if frame:IsVisible() then
    frame:Hide()
  else
    frame:Show()
  end
  self:RenderMain()
end

function WK:RenderMain()
  local dataColumns = self:GetMainColumns()
  local tableWidth = 0
  local tableHeight = 0
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not frame then
    local frameName = addonName .. "MainWindow"
    frame = CreateFrame("Frame", frameName, UIParent)
    frame:SetSize(500, 500)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(8000)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetPoint("CENTER")
    frame:SetUserPlaced(true)
    frame:RegisterForDrag("LeftButton")
    frame:EnableMouse(true)
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:Hide()
    self:SetBackgroundColor(frame, self.db.global.main.windowBackgroundColor.r, self.db.global.main.windowBackgroundColor.g, self.db.global.main.windowBackgroundColor.b, self.db.global.main.windowBackgroundColor.a)

    frame.border = CreateFrame("Frame", "$parentBorder", frame, "BackdropTemplate")
    frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -3, 3)
    frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 3, -3)
    frame.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    frame.border:SetBackdropBorderColor(0, 0, 0, .5)
    frame.border:Show()

    frame.titlebar = CreateFrame("Frame", "$parentTitle", frame)
    frame.titlebar:SetPoint("TOPLEFT", frame, "TOPLEFT")
    frame.titlebar:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    frame.titlebar:SetHeight(self.Constants.TITLEBAR_HEIGHT)
    frame.titlebar:RegisterForDrag("LeftButton")
    frame.titlebar:EnableMouse(true)
    frame.titlebar:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame.titlebar:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    self:SetBackgroundColor(frame.titlebar, 0, 0, 0, 0.5)

    frame.titlebar.icon = frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    frame.titlebar.icon:SetPoint("LEFT", frame.titlebar, "LEFT", 6, 0)
    frame.titlebar.icon:SetSize(20, 20)
    frame.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")

    frame.titlebar.title = frame.titlebar:CreateFontString("$parentText", "OVERLAY")
    frame.titlebar.title:SetFontObject("SystemFont_Med2")
    frame.titlebar.title:SetPoint("LEFT", frame.titlebar, 28, 0)
    frame.titlebar.title:SetJustifyH("LEFT")
    frame.titlebar.title:SetJustifyV("MIDDLE")
    frame.titlebar.title:SetText(addonName)

    do -- Close Button
      frame.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", frame.titlebar)
      frame.titlebar.closeButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      frame.titlebar.closeButton:SetPoint("RIGHT", frame.titlebar, "RIGHT", 0, 0)
      frame.titlebar.closeButton:SetScript("OnClick", function() self:ToggleMainWindow() end)
      frame.titlebar.closeButton:SetScript("OnEnter", function()
        frame.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        self:SetBackgroundColor(frame.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(frame.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
        GameTooltip:Show()
      end)
      frame.titlebar.closeButton:SetScript("OnLeave", function()
        frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(frame.titlebar.closeButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      frame.titlebar.closeButton.Icon = frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      frame.titlebar.closeButton.Icon:SetPoint("CENTER", frame.titlebar.closeButton, "CENTER")
      frame.titlebar.closeButton.Icon:SetSize(10, 10)
      frame.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
      frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Settings Button
      frame.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", frame.titlebar)
      frame.titlebar.SettingsButton:SetPoint("RIGHT", frame.titlebar.closeButton, "LEFT", 0, 0)
      frame.titlebar.SettingsButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      frame.titlebar.SettingsButton:SetScript("OnEnter", function()
        frame.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(frame.titlebar.SettingsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(frame.titlebar.SettingsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Settings", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Let's customize things a bit", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      frame.titlebar.SettingsButton:SetScript("OnLeave", function()
        frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(frame.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      frame.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
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
              self:RenderMain()
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
              self:SetBackgroundColor(frame, self.db.global.main.windowBackgroundColor.r, self.db.global.main.windowBackgroundColor.g, self.db.global.main.windowBackgroundColor.b, self.db.global.main.windowBackgroundColor.a)
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
              self:SetBackgroundColor(frame, self.db.global.main.windowBackgroundColor.r, self.db.global.main.windowBackgroundColor.g, self.db.global.main.windowBackgroundColor.b, self.db.global.main.windowBackgroundColor.a)
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
            self:RenderMain()
          end
        )
      end)

      frame.titlebar.SettingsButton.Icon = frame.titlebar:CreateTexture(frame.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      frame.titlebar.SettingsButton.Icon:SetPoint("CENTER", frame.titlebar.SettingsButton, "CENTER")
      frame.titlebar.SettingsButton.Icon:SetSize(12, 12)
      frame.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Characters Button
      frame.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", frame.titlebar)
      frame.titlebar.CharactersButton:SetPoint("RIGHT", frame.titlebar.SettingsButton, "LEFT", 0, 0)
      frame.titlebar.CharactersButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      frame.titlebar.CharactersButton:SetScript("OnEnter", function()
        frame.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(frame.titlebar.CharactersButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(frame.titlebar.CharactersButton, "ANCHOR_TOP")
        GameTooltip:SetText("Characters", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable your characters.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      frame.titlebar.CharactersButton:SetScript("OnLeave", function()
        frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(frame.titlebar.CharactersButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      frame.titlebar.CharactersButton.Icon = frame.titlebar:CreateTexture(frame.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
      frame.titlebar.CharactersButton.Icon:SetPoint("CENTER", frame.titlebar.CharactersButton, "CENTER")
      frame.titlebar.CharactersButton.Icon:SetSize(14, 14)
      frame.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Characters.blp")
      frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      frame.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
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
              self:RenderMain()
            end
          )
        end)
      end)
    end

    do -- Columns Button
      frame.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", frame.titlebar)
      frame.titlebar.ColumnsButton:SetPoint("RIGHT", frame.titlebar.CharactersButton, "LEFT", 0, 0)
      frame.titlebar.ColumnsButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      frame.titlebar.ColumnsButton:SetScript("OnEnter", function()
        frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(frame.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(frame.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Columns", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable table columns.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      frame.titlebar.ColumnsButton:SetScript("OnLeave", function()
        frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(frame.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      frame.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = self.db.global.main.hiddenColumns
        self:TableForEach(self:GetMainColumns(true), function(column)
          rootMenu:CreateCheckbox(
            column.name,
            function() return not hidden[column.name] end,
            function(columnName)
              hidden[columnName] = not hidden[columnName]
              self:RenderMain()
            end,
            column.name
          )
        end)
      end)

      frame.titlebar.ColumnsButton.Icon = frame.titlebar:CreateTexture(frame.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
      frame.titlebar.ColumnsButton.Icon:SetPoint("CENTER", frame.titlebar.ColumnsButton, "CENTER")
      frame.titlebar.ColumnsButton.Icon:SetSize(12, 12)
      frame.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Columns.blp")
      frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Checklist Button
      frame.titlebar.ChecklistButton = CreateFrame("Button", "$parentChecklistButton", frame.titlebar)
      frame.titlebar.ChecklistButton:SetPoint("RIGHT", frame.titlebar.ColumnsButton, "LEFT", 0, 0)
      frame.titlebar.ChecklistButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      frame.titlebar.ChecklistButton:SetScript("OnEnter", function()
        frame.titlebar.ChecklistButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(frame.titlebar.ChecklistButton, 1, 1, 1, 0.05)
        ---@diagnostic disable-next-line: param-type-mismatch
        GameTooltip:SetOwner(frame.titlebar.ChecklistButton, "ANCHOR_TOP")
        GameTooltip:SetText("Checklist", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Toggle the Checklist window", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      frame.titlebar.ChecklistButton:SetScript("OnLeave", function()
        frame.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(frame.titlebar.ChecklistButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      frame.titlebar.ChecklistButton:SetScript("OnClick", function()
        self.db.global.main.checklistHelpTipClosed = true
        self:ToggleChecklistWindow()
      end)

      frame.titlebar.ChecklistButton.Icon = frame.titlebar:CreateTexture(frame.titlebar.ChecklistButton:GetName() .. "Icon", "ARTWORK")
      frame.titlebar.ChecklistButton.Icon:SetPoint("CENTER", frame.titlebar.ChecklistButton, "CENTER")
      frame.titlebar.ChecklistButton.Icon:SetSize(16, 16)
      frame.titlebar.ChecklistButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Checklist.blp")
      frame.titlebar.ChecklistButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    frame.table = self:CreateTableFrame({
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
    frame.table:SetParent(frame)
    frame.table:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -self.Constants.TITLEBAR_HEIGHT)
    frame.table:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)

    table.insert(UISpecialFrames, frameName)
  end

  do -- Show helptip for new checklist
    local checklistHelpTipText = "Check out the new checklist!"
    if self.db.global.main.checklistHelpTipClosed then
      HelpTip:Hide(frame, checklistHelpTipText)
    else
      HelpTip:Show(
        frame,
        {
          text = checklistHelpTipText,
          buttonStyle = HelpTip.ButtonStyle.Close,
          targetPoint = HelpTip.Point.TopEdgeCenter,
          onAcknowledgeCallback = function()
            self.db.global.main.checklistHelpTipClosed = true
          end,
        },
        frame.titlebar.ChecklistButton
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
    tableHeight = tableHeight + frame.table.config.header.height
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
        tableHeight = tableHeight + frame.table.config.rows.height
      end)
    end)
  end

  frame.border:SetShown(self.db.global.main.windowBorder)
  frame.table:SetData(tableData)
  frame:SetWidth(tableWidth)
  frame:SetHeight(math.min(tableHeight + self.Constants.TITLEBAR_HEIGHT, self.Constants.MAX_WINDOW_HEIGHT))
  frame:SetScale(self.db.global.main.windowScale / 100)
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

              if objective.category == self.Objectives.DarkmoonQuest then
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
