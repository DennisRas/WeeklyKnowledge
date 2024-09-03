---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge
local frame = nil

function WK:ToggleChecklistWindow()
  if not frame then return end
  if frame:IsVisible() then
    frame:Hide()
  else
    frame:Show()
  end
  self:RenderChecklist()
end

function WK:RenderChecklist()
  local character = self:GetCharacter()
  local dataColumns = self:GetChecklistColumns()
  local tableWidth = 0
  local tableHeight = 0
  ---@type WK_TableData
  local tableData = {
    columns = {
      {width = 260,},
      {width = 100,},
      {width = 80,},
      {
        width = 50,
        align = "CENTER",
      },
      {
        width = 40,
      },
    },
    rows = {}
  }

  if not frame then
    local frameName = addonName .. "ChecklistWindow"
    frame = CreateFrame("Frame", frameName, UIParent)
    frame:SetSize(500, 500)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(8100)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetPoint("CENTER")
    frame:SetUserPlaced(true)
    frame:RegisterForDrag("LeftButton")
    frame:EnableMouse(true)
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:Hide()
    self:SetBackgroundColor(frame, self.db.global.checklist.windowBackgroundColor.r, self.db.global.checklist.windowBackgroundColor.g, self.db.global.checklist.windowBackgroundColor.b, self.db.global.checklist.windowBackgroundColor.a)

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
    frame.titlebar.title:SetText("Checklist")

    do -- Close Button
      frame.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", frame.titlebar)
      frame.titlebar.closeButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      frame.titlebar.closeButton:SetPoint("RIGHT", frame.titlebar, "RIGHT", 0, 0)
      frame.titlebar.closeButton:SetScript("OnClick", function() self:ToggleChecklistWindow() end)
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
        rootMenu:CreateTitle("Window")
        local windowScale = rootMenu:CreateButton("Scaling")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return self.db.global.checklist.windowScale == i end,
            function(data)
              self.db.global.checklist.windowScale = data
              self:RenderChecklist()
            end,
            i
          )
        end

        local colorInfo = {
          r = self.db.global.checklist.windowBackgroundColor.r,
          g = self.db.global.checklist.windowBackgroundColor.g,
          b = self.db.global.checklist.windowBackgroundColor.b,
          opacity = self.db.global.checklist.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              self.db.global.checklist.windowBackgroundColor.r = r
              self.db.global.checklist.windowBackgroundColor.g = g
              self.db.global.checklist.windowBackgroundColor.b = b
              if a then
                self.db.global.checklist.windowBackgroundColor.a = a
              end
              self:SetBackgroundColor(frame, self.db.global.checklist.windowBackgroundColor.r, self.db.global.checklist.windowBackgroundColor.g, self.db.global.checklist.windowBackgroundColor.b, self.db.global.checklist.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              self.db.global.checklist.windowBackgroundColor.r = color.r
              self.db.global.checklist.windowBackgroundColor.g = color.g
              self.db.global.checklist.windowBackgroundColor.b = color.b
              if color.a then
                self.db.global.checklist.windowBackgroundColor.a = color.a
              end
              self:SetBackgroundColor(frame, self.db.global.checklist.windowBackgroundColor.r, self.db.global.checklist.windowBackgroundColor.g, self.db.global.checklist.windowBackgroundColor.b, self.db.global.checklist.windowBackgroundColor.a)
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
          function() return self.db.global.checklist.windowBorder end,
          function()
            self.db.global.checklist.windowBorder = not self.db.global.checklist.windowBorder
            self:RenderChecklist()
          end
        )
      end)

      frame.titlebar.SettingsButton.Icon = frame.titlebar:CreateTexture(frame.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      frame.titlebar.SettingsButton.Icon:SetPoint("CENTER", frame.titlebar.SettingsButton, "CENTER")
      frame.titlebar.SettingsButton.Icon:SetSize(12, 12)
      frame.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    frame.table = self:CreateTableFrame({
      header = {
        enabled = true,
        sticky = true,
        height = self.Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = self.Constants.TABLE_ROW_HEIGHT,
        highlight = false,
        striped = true
      },
      cells = {
        padding = 6,
        highlight = true
      },
    })
    frame.table:SetParent(frame)
    frame.table:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -self.Constants.TITLEBAR_HEIGHT)
    frame.table:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  end

  if not character then
    frame:Hide()
    return
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
    self:TableForEach(character.professions, function(characterProfession)
      local dataProfession = self:TableFind(self.Professions, function(dataProfession)
        return dataProfession.skillLineID == characterProfession.skillLineID
      end)
      if not dataProfession then return end

      self:TableForEach(dataProfession.objectives, function(professionObjective)
        if not professionObjective.itemID then return end
        local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(professionObjective.itemID)
        if not itemName then return end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        self:TableForEach(dataColumns, function(dataColumn)
          local cellData = {
            character = character,
            characterProfession = characterProfession,
            dataProfession = dataProfession,
            professionObjective = professionObjective,
            itemName = itemName,
            itemLink = itemLink,
            itemTexture = itemTexture,
          }
          ---@type WK_TableDataCell
          local cell = dataColumn.cell(cellData)
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
  frame:SetHeight(math.min(tableHeight + self.Constants.TITLEBAR_HEIGHT, self.Constants.MAX_WINDOW_HEIGHT - 200))
  frame:SetScale(self.db.global.checklist.windowScale / 100)
end

function WK:GetChecklistColumns(unfiltered)
  local hidden = self.db.global.checklist.hiddenColumns
  local columns = {
    {
      name = "Item",
      width = 260,
      cell = function(data)
        return {
          text = "|T" .. data.itemTexture .. ":0|t " .. data.itemLink,
          onEnter = function(columnFrame)
            GameTooltip:ClearAllPoints()
            GameTooltip:ClearLines()
            GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(data.itemLink)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if IsModifiedClick("CHATLINK") then
              if not ChatEdit_InsertLink(data.itemLink) then
                ChatFrame_OpenChat(data.itemLink);
              end
            end
          end,
        }
      end,
    },
    {
      name = "Profession",
      width = 100,
      cell = function(data)
        return {
          text = data.dataProfession.name,
        }
      end,
    },
    {
      name = "Category",
      width = 80,
      cell = function(data)
        return {
          text = data.professionObjective.category.name,
        }
      end,
    },
    {
      name = "Points",
      width = 50,
      align = "CENTER",
      cell = function(data)
        return {
          text = "+" .. tostring(data.professionObjective.points),
        }
      end,
    },
    {
      name = "",
      width = 40,
      cell = function()
        return {
          text = CreateAtlasMarkup("Waypoint-MapPin-Untracked", 20, 20),
          onEnter = function(columnFrame)
            GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText("Do you know de wey?")
            GameTooltip:AddDoubleLine("Location:", "-", 1, 1, 1, 1, 1, 1)
            GameTooltip:AddDoubleLine("Coordinates:", "00.00 / 00.00", 1, 1, 1, 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("<Click to Pin on Map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
    },
  }

  if unfiltered then
    return columns
  end

  local filteredColumns = self:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
