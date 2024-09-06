---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Checklist
local Checklist = {}
addon.Checklist = Checklist

local Constants = addon.Constants
local Utils = addon.Utils
local UI = addon.UI
local Data = addon.Data

function Checklist:ToggleWindow()
  if not self.window then return end
  if self.window:IsVisible() then
    self.window:Hide()
  else
    self.window:Show()
  end
  Data.db.global.checklist.open = self.window:IsVisible()
  self:Render()
end

function Checklist:Render()
  local character = Data:GetCharacter()
  local dataColumns = self:GetColumns()
  local tableWidth = 0
  local tableHeight = 0
  local minWindowWidth = 200
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not self.window then
    local frameName = addonName .. "ChecklistWindow"
    self.window = CreateFrame("Frame", frameName, UIParent)
    self.window:SetSize(500, 500)
    self.window:SetFrameStrata("HIGH")
    self.window:SetFrameLevel(8100)
    self.window:SetClampedToScreen(true)
    self.window:SetMovable(true)
    self.window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -8)
    self.window:SetUserPlaced(true)
    self.window:RegisterForDrag("LeftButton")
    self.window:EnableMouse(true)
    self.window:SetScript("OnDragStart", function() self.window:StartMoving() end)
    self.window:SetScript("OnDragStop", function() self.window:StopMovingOrSizing() end)
    self.window:SetShown(Data.db.global.checklist.open)
    Utils:SetBackgroundColor(self.window, Data.db.global.checklist.windowBackgroundColor.r, Data.db.global.checklist.windowBackgroundColor.g, Data.db.global.checklist.windowBackgroundColor.b, Data.db.global.checklist.windowBackgroundColor.a)

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
    self.window.titlebar.title:SetText("Checklist")

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
        rootMenu:CreateCheckbox(
          "Hide in combat",
          function() return Data.db.global.checklist.hideInCombat end,
          function()
            Data.db.global.checklist.hideInCombat = not Data.db.global.checklist.hideInCombat
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide in dungeons",
          function() return Data.db.global.checklist.hideInDungeons end,
          function()
            Data.db.global.checklist.hideInDungeons = not Data.db.global.checklist.hideInDungeons
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide completed objectives",
          function() return Data.db.global.checklist.hideCompletedObjectives end,
          function()
            Data.db.global.checklist.hideCompletedObjectives = not Data.db.global.checklist.hideCompletedObjectives
            self:Render()
          end
        )
        rootMenu:CreateTitle("Window")
        local windowScale = rootMenu:CreateButton("Scaling")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return Data.db.global.checklist.windowScale == i end,
            function(data)
              Data.db.global.checklist.windowScale = data
              self:Render()
            end,
            i
          )
        end

        local colorInfo = {
          r = Data.db.global.checklist.windowBackgroundColor.r,
          g = Data.db.global.checklist.windowBackgroundColor.g,
          b = Data.db.global.checklist.windowBackgroundColor.b,
          opacity = Data.db.global.checklist.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              Data.db.global.checklist.windowBackgroundColor.r = r
              Data.db.global.checklist.windowBackgroundColor.g = g
              Data.db.global.checklist.windowBackgroundColor.b = b
              if a then
                Data.db.global.checklist.windowBackgroundColor.a = a
              end
              Utils:SetBackgroundColor(self.window, Data.db.global.checklist.windowBackgroundColor.r, Data.db.global.checklist.windowBackgroundColor.g, Data.db.global.checklist.windowBackgroundColor.b, Data.db.global.checklist.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              Data.db.global.checklist.windowBackgroundColor.r = color.r
              Data.db.global.checklist.windowBackgroundColor.g = color.g
              Data.db.global.checklist.windowBackgroundColor.b = color.b
              if color.a then
                Data.db.global.checklist.windowBackgroundColor.a = color.a
              end
              Utils:SetBackgroundColor(self.window, Data.db.global.checklist.windowBackgroundColor.r, Data.db.global.checklist.windowBackgroundColor.g, Data.db.global.checklist.windowBackgroundColor.b, Data.db.global.checklist.windowBackgroundColor.a)
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
          function() return Data.db.global.checklist.windowBorder end,
          function()
            Data.db.global.checklist.windowBorder = not Data.db.global.checklist.windowBorder
            self:Render()
          end
        )
        -- rootMenu:CreateCheckbox(
        --   "Show the title bar",
        --   function() return Data.db.global.checklist.windowTitlebar end,
        --   function()
        --     Data.db.global.checklist.windowTitlebar = not Data.db.global.checklist.windowTitlebar
        --     self:Render()
        --   end
        -- )
      end)

      self.window.titlebar.SettingsButton.Icon = self.window.titlebar:CreateTexture(self.window.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      self.window.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.window.titlebar.SettingsButton, "CENTER")
      self.window.titlebar.SettingsButton.Icon:SetSize(12, 12)
      self.window.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      self.window.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Columns Button
      self.window.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.window.titlebar)
      self.window.titlebar.ColumnsButton:SetPoint("RIGHT", self.window.titlebar.SettingsButton, "LEFT", 0, 0)
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
        local hidden = Data.db.global.checklist.hiddenColumns
        Utils:TableForEach(self:GetColumns(true), function(column)
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

    self.window.table = UI:CreateTableFrame({
      header = {
        enabled = true,
        sticky = true,
        height = Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = Constants.TABLE_ROW_HEIGHT,
        highlight = false,
        striped = true
      },
      cells = {
        padding = Constants.TABLE_CELL_PADDING,
        highlight = true
      },
    })
    self.window.table:SetParent(self.window)
    self.window.table:SetPoint("TOPLEFT", self.window, "TOPLEFT", 0, -Constants.TITLEBAR_HEIGHT)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window, "BOTTOMRIGHT", 0, 0)
  end

  if not character then
    self.window:Hide()
    return
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
    Utils:TableForEach(character.professions, function(characterProfession)
      local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
        return dataProfession.skillLineID == characterProfession.skillLineID
      end)
      if not dataProfession then return end

      Utils:TableForEach(dataProfession.objectives, function(professionObjective)
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
            if not Data.cache.isDarkmoonOpen then
              progress.total = 0
            end
          end
        end

        if progress.total > 0 and progress.completed == progress.total and Data.db.global.checklist.hideCompletedObjectives then
          return
        end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        Utils:TableForEach(dataColumns, function(dataColumn)
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
        tableHeight = tableHeight + self.window.table.config.rows.height
      end)
    end)
  end

  self.window.titlebar.title:SetShown(tableWidth > minWindowWidth)
  self.window.border:SetShown(Data.db.global.checklist.windowBorder)
  self.window.titlebar:SetShown(Data.db.global.checklist.windowTitlebar)
  self.window.table:SetData(tableData)
  self.window:SetWidth(math.max(tableWidth, minWindowWidth))
  self.window:SetHeight(math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT - 200))
  self.window:SetScale(Data.db.global.checklist.windowScale / 100)
end

function Checklist:GetColumns(unfiltered)
  local hidden = Data.db.global.checklist.hiddenColumns
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
        local objective = Data:GetObjective(data.professionObjective.objectiveID)
        if not objective then
          return {
            text = "?"
          }
        end
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
    --     local objective = Data:GetObjective(data.professionObjective.objectiveID)
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
                if requires and Utils:TableCount(requires) > 0 then
                  GameTooltip:AddLine(" ")
                  GameTooltip:AddLine("Requirements:")
                  Utils:TableForEach(requires, function(req)
                    local text = " "
                    local amount = format("x%d", req.amount)
                    local completed = false
                    if req.type == "item" then
                      local _, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(req.id)
                      local itemCount = C_Item.GetItemCount(req.id)
                      text = format("%s %s", CreateSimpleTextureMarkup(itemTexture or [[Interface\Icons\INV_Misc_QuestionMark]]), itemLink or "Loading...")
                      if itemCount then
                        amount = format("%d / %d", itemCount, req.amount)
                        if itemCount >= req.amount then
                          completed = true
                        end
                      end
                    end
                    if req.type == "currency" then
                      local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(req.id)
                      if currencyInfo then
                        local _, _, _, hex = C_Item.GetItemQualityColor(currencyInfo.quality)
                        text = format("%s |c%s%s|r", CreateSimpleTextureMarkup(currencyInfo.iconFileID or [[Interface\Icons\INV_Misc_QuestionMark]]), hex, currencyInfo.name)
                        amount = format("%d / %d", currencyInfo.quantity, req.amount)
                        if currencyInfo.quantity > req.amount then
                          completed = true
                        end
                      end
                    end
                    if req.type == "renown" then
                      local renownLevel = C_MajorFactions.GetCurrentRenownLevel(req.id) or 0
                      local renownInfo = C_MajorFactions.GetMajorFactionData(req.id)
                      if renownInfo and renownLevel > 0 then
                        text = renownInfo.name
                        amount = format("%d / %d", renownLevel, req.amount)
                        if renownLevel > req.amount then
                          completed = true
                        end
                      end
                    end
                    GameTooltip:AddDoubleLine(text, format("%s %s", amount, CreateAtlasMarkup(completed and "common-icon-checkmark" or "common-icon-redx", 13, 13)), 1, 1, 1, 1, 1, 1)
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

  local filteredColumns = Utils:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
