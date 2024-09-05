---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge
local window = nil

function WK:ToggleChecklistWindow()
  if not window then return end
  if window:IsVisible() then
    window:Hide()
  else
    window:Show()
  end
  self.db.global.checklist.open = window:IsVisible()
  self:Render()
end

function WK:RenderChecklist()
  local character = self:GetCharacter()
  local dataColumns = self:GetChecklistColumns()
  local tableWidth = 0
  local tableHeight = 0
  local minWindowWidth = 200
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not window then
    local frameName = addonName .. "ChecklistWindow"
    window = CreateFrame("Frame", frameName, UIParent)
    window:SetSize(500, 500)
    window:SetFrameStrata("HIGH")
    window:SetFrameLevel(8100)
    window:SetClampedToScreen(true)
    window:SetMovable(true)
    window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -8)
    window:SetUserPlaced(true)
    window:RegisterForDrag("LeftButton")
    window:EnableMouse(true)
    window:SetScript("OnDragStart", function() window:StartMoving() end)
    window:SetScript("OnDragStop", function() window:StopMovingOrSizing() end)
    window:SetShown(self.db.global.checklist.open)
    self:SetBackgroundColor(window, self.db.global.checklist.windowBackgroundColor.r, self.db.global.checklist.windowBackgroundColor.g, self.db.global.checklist.windowBackgroundColor.b, self.db.global.checklist.windowBackgroundColor.a)

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
    window.titlebar.title:SetText("Checklist")

    do -- Close Button
      window.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", window.titlebar)
      window.titlebar.closeButton:SetSize(self.Constants.TITLEBAR_HEIGHT, self.Constants.TITLEBAR_HEIGHT)
      window.titlebar.closeButton:SetPoint("RIGHT", window.titlebar, "RIGHT", 0, 0)
      window.titlebar.closeButton:SetScript("OnClick", function() self:ToggleChecklistWindow() end)
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
        rootMenu:CreateCheckbox(
          "Hide in combat",
          function() return self.db.global.checklist.hideInCombat end,
          function()
            self.db.global.checklist.hideInCombat = not self.db.global.checklist.hideInCombat
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide in dungeons",
          function() return self.db.global.checklist.hideInDungeons end,
          function()
            self.db.global.checklist.hideInDungeons = not self.db.global.checklist.hideInDungeons
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide completed objectives",
          function() return self.db.global.checklist.hideCompletedObjectives end,
          function()
            self.db.global.checklist.hideCompletedObjectives = not self.db.global.checklist.hideCompletedObjectives
            self:Render()
          end
        )
        rootMenu:CreateTitle("Window")
        local windowScale = rootMenu:CreateButton("Scaling")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return self.db.global.checklist.windowScale == i end,
            function(data)
              self.db.global.checklist.windowScale = data
              self:Render()
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
              self:SetBackgroundColor(window, self.db.global.checklist.windowBackgroundColor.r, self.db.global.checklist.windowBackgroundColor.g, self.db.global.checklist.windowBackgroundColor.b, self.db.global.checklist.windowBackgroundColor.a)
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
              self:SetBackgroundColor(window, self.db.global.checklist.windowBackgroundColor.r, self.db.global.checklist.windowBackgroundColor.g, self.db.global.checklist.windowBackgroundColor.b, self.db.global.checklist.windowBackgroundColor.a)
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
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Show the title bar",
          function() return self.db.global.checklist.windowTitlebar end,
          function()
            self.db.global.checklist.windowTitlebar = not self.db.global.checklist.windowTitlebar
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

    do -- Columns Button
      window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", window.titlebar)
      window.titlebar.ColumnsButton:SetPoint("RIGHT", window.titlebar.SettingsButton, "LEFT", 0, 0)
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
        local hidden = self.db.global.checklist.hiddenColumns
        self:TableForEach(self:GetChecklistColumns(true), function(column)
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

    window.table = self:CreateTableFrame({
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
        padding = self.Constants.TABLE_CELL_PADDING,
        highlight = true
      },
    })
    window.table:SetParent(window)
    window.table:SetPoint("TOPLEFT", window, "TOPLEFT", 0, -self.Constants.TITLEBAR_HEIGHT)
    window.table:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, 0)
  end

  if not character then
    window:Hide()
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
    tableHeight = tableHeight + window.table.config.header.height
  end

  do -- Table data
    self:TableForEach(character.professions, function(characterProfession)
      local dataProfession = self:TableFind(self.Professions, function(dataProfession)
        return dataProfession.skillLineID == characterProfession.skillLineID
      end)
      if not dataProfession then return end

      self:TableForEach(dataProfession.objectives, function(professionObjective)
        local item = {
          id = professionObjective.itemID,
          name = "",
          link = "",
          texture = "",
        }

        if professionObjective.itemID then
          local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(professionObjective.itemID)
          if itemName then
            item.name = itemName
            item.link = itemLink
            item.texture = itemTexture
          end
        end

        local progress = {
          completed = 0,
          total = 0,
          points = 0,
          pointsTotal = 0,
        }

        local objective = professionObjective
        if objective.quests then
          local limit = 0

          for _, questID in ipairs(objective.quests) do
            progress.total = progress.total + 1
            progress.pointsTotal = progress.pointsTotal + objective.points
            if objective.limit and progress.total > objective.limit then
              progress.pointsTotal = objective.limit * objective.points
              progress.total = objective.limit
            end
            if character.completed[questID] then
              progress.completed = progress.completed + 1
              progress.points = progress.points + objective.points
            end
          end

          if objective.objectiveID == Enum.WK_Objectives.DarkmoonQuest then
            if not self.cache.isDarkmoonOpen then
              progress.total = 0
            end
          end
        end

        if progress.total > 0 and progress.completed == progress.total and self.db.global.checklist.hideCompletedObjectives then
          return
        end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        self:TableForEach(dataColumns, function(dataColumn)
          local cellData = {
            character = character,
            characterProfession = characterProfession,
            dataProfession = dataProfession,
            professionObjective = professionObjective,
            -- itemName = itemName,
            -- itemLink = itemLink,
            -- itemTexture = itemTexture,
            progress = progress,
            item = item
          }
          ---@type WK_TableDataCell
          local cell = dataColumn.cell(cellData)
          table.insert(row.columns, cell)
        end)

        table.insert(tableData.rows, row)
        tableHeight = tableHeight + window.table.config.rows.height
      end)
    end)
  end

  window.titlebar.title:SetShown(tableWidth > minWindowWidth)
  window.border:SetShown(self.db.global.checklist.windowBorder)
  window.titlebar:SetShown(self.db.global.checklist.windowTitlebar)
  window.table:SetData(tableData)
  window:SetWidth(math.max(tableWidth, minWindowWidth))
  window:SetHeight(math.min(tableHeight + self.Constants.TITLEBAR_HEIGHT, self.Constants.MAX_WINDOW_HEIGHT - 200))
  window:SetScale(self.db.global.checklist.windowScale / 100)
end

function WK:GetChecklistColumns(unfiltered)
  local hidden = self.db.global.checklist.hiddenColumns
  local columns = {
    {
      name = "Objective",
      width = 260,
      cell = function(data)
        local text = ""
        if data.item.link then
          text = data.item.link
          if data.item.texture then
            text = "|T" .. data.item.texture .. ":0|t " .. data.item.link
          end
        else
          text = "Quest"
        end
        return {
          text = text,
          onEnter = function(columnFrame)
            GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
            if data.item.link then
              GameTooltip:SetHyperlink(data.item.link)
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            end
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if data.item.link then
              if IsModifiedClick("CHATLINK") then
                if not ChatEdit_InsertLink(data.item.link) then
                  ChatFrame_OpenChat(data.item.link);
                end
              end
            end
          end,
        }
      end,
    },
    {
      name = "Profession",
      width = 100,
      toggleHidden = true,
      cell = function(data)
        return {
          text = data.dataProfession.name,
        }
      end,
    },
    {
      name = "Category",
      width = 80,
      toggleHidden = true,
      cell = function(data)
        local objective = self:GetObjective(data.professionObjective.objectiveID)
        return {
          text = objective.name,
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(objective.name, 1, 1, 1);
            GameTooltip:AddLine(objective.description, nil, nil, nil, true)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
    },
    -- {
    --   name = "Repeat",
    --   width = 60,
    --   toggleHidden = true,
    --   cell = function(data)
    --     local objective = self:GetObjective(data.professionObjective.objectiveID)
    --     return {
    --       text = objective.repeatable,
    --     }
    --   end,
    -- },
    {
      name = "Progress",
      width = 70,
      align = "CENTER",
      toggleHidden = true,
      cell = function(data)
        local result = format("%d / %d", data.progress.completed, data.progress.total)
        if data.progress.total == 0 then
          result = ""
        elseif data.progress.completed == data.progress.total then
          result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
        end

        return {
          text = result,
        }
      end,
    },
    {
      name = "Points",
      width = 70,
      align = "CENTER",
      toggleHidden = true,
      cell = function(data)
        local result = format("%d / %d", data.progress.points, data.progress.pointsTotal)
        if data.progress.total == 0 then
          result = ""
        elseif data.progress.points == data.progress.pointsTotal then
          result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
        end

        return {
          text = result,
        }
      end,
    },
    {
      name = "",
      width = 40,
      cell = function(data)
        local loc = data.professionObjective.loc
        local requires = data.professionObjective.requires
        if data.professionObjective and loc and loc.m and loc.m > 0 then
          local mapInfo = C_Map.GetMapInfo(loc.m)
          if mapInfo then
            local point = UiMapPoint.CreateFromCoordinates(loc.m, loc.x / 100, loc.y / 100)
            return {
              text = CreateAtlasMarkup("Waypoint-MapPin-Tracked", 20, 20),
              onEnter = function(columnFrame)
                GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
                GameTooltip:SetText("Do you know de wey?", 1, 1, 1)
                if loc.hint then
                  GameTooltip:AddLine(loc.hint, nil, nil, nil, true)
                  GameTooltip:AddLine(" ")
                end
                GameTooltip:AddDoubleLine("Location:", mapInfo.name, nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Coordinates:", format("%.1f / %.1f", loc.x, loc.y), nil, nil, nil, 1, 1, 1)
                if requires and self:TableCount(requires) > 0 then
                  GameTooltip:AddLine(" ")
                  GameTooltip:AddLine("Requirements:")
                  self:TableForEach(requires, function(req)
                    local text = ""
                    if req.type == "item" then
                      local itemName, itemLink = C_Item.GetItemInfo(req.id)
                      text = itemLink
                    end
                    GameTooltip:AddDoubleLine(text, format("x%d", req.amount), 1, 1, 1, 1, 1, 1)
                  end)
                end
                if point and C_Map.CanSetUserWaypointOnMap(loc.m) then
                  GameTooltip:AddLine(" ")
                  GameTooltip:AddLine("<Shift click to share pin in chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                  GameTooltip:AddLine("<Click to place a pin on the map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                end
                GameTooltip:Show()
              end,
              onLeave = function()
                GameTooltip:Hide()
              end,
              onClick = function()
                if point and C_Map.CanSetUserWaypointOnMap(loc.m) then
                  if IsModifiedClick("CHATLINK") then
                    local hyperlink = format("|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r", loc.m, loc.x * 100, loc.y * 100, MAP_PIN_HYPERLINK)
                    if not ChatEdit_InsertLink(hyperlink) then
                      ChatFrame_OpenChat(hyperlink);
                    end
                  else
                    C_Map.SetUserWaypoint(point)
                    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                  end
                end
              end,
            }
          end
        end
        return {
          text = "",
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
