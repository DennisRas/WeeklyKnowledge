---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Checklist
local Checklist = {}
addon.Checklist = Checklist

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

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
  ---@type WK_TableData
  local tableData = {
    columns = {},
    rows = {}
  }

  if not self.window then
    local frameName = addonName .. "ChecklistWindow"
    self.window = CreateFrame("Frame", frameName, UIParent)
    self.window:SetSize(500, 500)
    self.window:SetFrameStrata("MEDIUM")
    self.window:SetFrameLevel(8100)
    self.window:SetToplevel(true)
    self.window:SetClampedToScreen(true)
    self.window:SetMovable(true)
    self.window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 8, -8)
    self.window:SetUserPlaced(true)
    self.window:RegisterForDrag("LeftButton")
    self.window:EnableMouse(true)
    self.window:SetScript("OnDragStart", function() self.window:StartMoving() end)
    self.window:SetScript("OnDragStop", function() self.window:StopMovingOrSizing() end)
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
    self.window.titlebar.title:SetText(L["Checklist"])

    self.window.textbox = self.window:CreateFontString("$parentTextbox", "ARTWORK")
    self.window.textbox:SetFontObject("SystemFont_Med1")
    self.window.textbox:SetPoint("TOPLEFT", self.window, "TOPLEFT", 20, -Constants.TITLEBAR_HEIGHT - 20)
    self.window.textbox:SetPoint("BOTTOMRIGHT", self.window, "BOTTOMRIGHT", -20, 20)
    self.window.textbox:SetJustifyH("CENTER")
    self.window.textbox:SetJustifyV("MIDDLE")
    self.window.textbox:Hide()

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
        rootMenu:CreateCheckbox(
          L["HideInCombat"],
          function() return Data.db.global.checklist.hideInCombat end,
          function()
            Data.db.global.checklist.hideInCombat = not Data.db.global.checklist.hideInCombat
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          L["HideInDungeons"],
          function() return Data.db.global.checklist.hideInDungeons end,
          function()
            Data.db.global.checklist.hideInDungeons = not Data.db.global.checklist.hideInDungeons
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          L["HideCompletedObjectives"],
          function() return Data.db.global.checklist.hideCompletedObjectives end,
          function()
            Data.db.global.checklist.hideCompletedObjectives = not Data.db.global.checklist.hideCompletedObjectives
            self:Render()
          end
        )
        local hideAllUniques = rootMenu:CreateCheckbox(
          L["HideAllUniques"],
          function() return Data.db.global.checklist.hideUniqueObjectives end,
          function()
            Data.db.global.checklist.hideUniqueObjectives = not Data.db.global.checklist.hideUniqueObjectives
            self:Render()
          end
        )
        hideAllUniques:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, L["HideAllUniquesDesc"]);
        end)
        local hideVendorUniques = rootMenu:CreateCheckbox(
          L["HideVendorUniques"],
          function() return Data.db.global.checklist.hideUniqueVendorObjectives end,
          function()
            Data.db.global.checklist.hideUniqueVendorObjectives = not Data.db.global.checklist.hideUniqueVendorObjectives
            self:Render()
          end
        )
        hideVendorUniques:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, L["HideVendorUniquesDesc"]);
        end)
        rootMenu:CreateTitle(L["Window"])
        local windowScale = rootMenu:CreateButton(L["Scaling"])
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
          L["BackgroundColor"],
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )

        rootMenu:CreateCheckbox(
          L["ShowTheBorder"],
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

    do -- Toggle Button
      self.window.titlebar.toggleButton = CreateFrame("Button", "$parentToggleButton", self.window.titlebar)
      self.window.titlebar.toggleButton:SetPoint("RIGHT", self.window.titlebar.ColumnsButton, "LEFT", 0, 0)
      self.window.titlebar.toggleButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.window.titlebar.toggleButton:SetScript("OnClick", function()
        Data.db.global.checklist.hideTable = not Data.db.global.checklist.hideTable
        self:Render()
      end)
      self.window.titlebar.toggleButton:SetScript("OnEnter", function()
        self.window.titlebar.toggleButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        Utils:SetBackgroundColor(self.window.titlebar.toggleButton, 1, 1, 1, 0.05)
        GameTooltip:SetOwner(self.window.titlebar.toggleButton, "ANCHOR_TOP")
        GameTooltip:SetText(L["ToggleObjectives"], 1, 1, 1, 1, true)
        GameTooltip:AddLine(L["ToggleObjectivesDesc"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.window.titlebar.toggleButton:SetScript("OnLeave", function()
        self.window.titlebar.toggleButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.window.titlebar.toggleButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      self.window.titlebar.toggleButton.Icon = self.window.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      self.window.titlebar.toggleButton.Icon:SetPoint("CENTER", self.window.titlebar.toggleButton, "CENTER")
      self.window.titlebar.toggleButton.Icon:SetSize(16, 16)
      self.window.titlebar.toggleButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Toggle.blp")
      self.window.titlebar.toggleButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
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

  local weeklyProgress = Data:GetWeeklyProgress()

  local rows = 0
  local profCount = 0
  do -- Table data
    Utils:TableForEach(character.professions, function(characterProfession)
      local profession = Utils:TableGet(Data.Professions, "skillLineID", characterProfession.skillLineID)
      if not profession then return end

      local objectives = Utils:TableFilter(Data.Objectives, function(objective)
        return objective.professionID == profession.skillLineID
      end)

      Utils:TableForEach(objectives, function(objective)
        -- Hide Darkmoon objectives
        if objective.typeID == Enum.WK_Objectives.DarkmoonQuest then
          if not Data.cache.isDarkmoonOpen then
            return
          end
        end

        -- Hide Uniques if enabled
        if objective.typeID == Enum.WK_Objectives.Unique then
          if Data.db.global.checklist.hideUniqueObjectives then
            return
          elseif Data.db.global.checklist.hideUniqueVendorObjectives and objective.requires and Utils:TableCount(objective.requires) > 0 then
            return
          end
        end

        local item = {
          id = objective.itemID,
          name = "",
          link = "",
          texture = "",
        }

        if objective.itemID then
          local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(objective.itemID)
          if itemName then
            item.name = itemName
            item.link = itemLink
            item.texture = itemTexture
          end
        end

        local progress = Utils:TableFind(weeklyProgress, function(progress)
          return progress.objective == objective and progress.character == character
        end)
        if not progress then return end

        -- local progress = {
        --   completed = 0,
        --   total = 0,
        --   points = 0,
        --   pointsTotal = 0,
        -- }

        -- if objective.quests then
        --   local limit = 0

        --   for _, questID in ipairs(objective.quests) do
        --     progress.questsTotal = progress.questsTotal + 1
        --     progress.pointsEarnedTotal = progress.pointsTotal + objective.points
        --     if objective.limit and progress.questsTotal > objective.limit then
        --       progress.pointsTotal = objective.limit * objective.points
        --       progress.questsTotal = objective.limit
        --     end
        --     if character.completed[questID] then
        --       progress.questsCompleted = progress.questsCompleted + 1
        --       progress.pointsEarned = progress.points + objective.points
        --     end
        --   end
        -- end

        if progress.questsTotal > 0 and progress.questsCompleted == progress.questsTotal and Data.db.global.checklist.hideCompletedObjectives then
          return
        end

        ---@type WK_TableDataRow
        local row = {columns = {}}
        Utils:TableForEach(dataColumns, function(dataColumn)
          local cellData = {
            character = character,
            characterProfession = characterProfession,
            dataProfession = profession,
            objective = objective,
            progress = progress,
            item = item
          }
          ---@type WK_TableDataCell
          local cell = dataColumn.cell(cellData)
          table.insert(row.columns, cell)
        end)

        table.insert(tableData.rows, row)
        tableHeight = tableHeight + self.window.table.config.rows.height
        rows = rows + 1
      end)
      profCount = profCount + 1
    end)
  end

  local windowWidth     = tableWidth
  local windowHeight    = Constants.TITLEBAR_HEIGHT
  local minWindowWidth  = 200
  local maxWindowHeight = 300
  if Data.db.global.checklist.hideTable then
    self.window.table:Hide()
    self.window.textbox:Hide()
  else
    if rows == 0 then
      windowHeight = 100
      self.window.textbox:Show()
      self.window.table:Hide()
    else
      windowHeight = windowHeight + tableHeight
      self.window.textbox:Hide()
      self.window.table:Show()
    end
  end
  if rows == 0 then
    windowWidth = 500
  end
  windowHeight = math.min(windowHeight, maxWindowHeight)
  windowWidth  = math.max(windowWidth, minWindowWidth)

  self.window.textbox:SetText(profCount == 0 and L["ZeroProfCount"] or L["LookPatronOrders"])
  self.window:SetShown(Data.db.global.checklist.open)
  self.window.border:SetShown(Data.db.global.checklist.windowBorder)
  self.window.titlebar:SetShown(Data.db.global.checklist.windowTitlebar)
  -- self.window.titlebar.title:SetShown(windowWidth > minWindowWidth)
  self.window.table:SetData(tableData)
  self.window:SetWidth(windowWidth)
  self.window:SetHeight(windowHeight + 2)
  self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
  self.window:SetScale(Data.db.global.checklist.windowScale / 100)
  if Data.cache.inCombat and Data.db.global.checklist.hideInCombat then
    self.window:Hide()
  end
end

function Checklist:GetColumns(unfiltered)
  local hidden = Data.db.global.checklist.hiddenColumns
  local columns = {
    {
      name = L["Objective"],
      width = 260,
      cell = function(data)
        local text = ""
        local link = data.item.link
        local canShare = false
        if data.item.id and data.item.id > 0 and data.item.link then
          text = data.item.link
          canShare = true
          if data.item.texture then
            text = "|T" .. data.item.texture .. ":0|t " .. data.item.link
          end
        else
          text = L["Quest"]
          local questTooltipData = C_TooltipInfo.GetHyperlink("quest:" .. data.objective.quests[1] .. ":-1")
          if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
            -- link = format("|cffffff00|Hquest:%d:70|h[%s]|h|r", data.objective.quests[1], questTooltipData.lines[1].leftText) -- Isn't working
            link = "quest:" .. data.objective.quests[1] .. ":-1"
            text = WrapTextInColorCode(format("%s [%s]", CreateAtlasMarkup("questlog-questtypeicon-Recurring", 14, 14), questTooltipData.lines[1].leftText), "ffffff00")
          end
        end
        return {
          text = text,
          onEnter = function(columnFrame)
            GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
            if link and strlen(link) > 0 then
              GameTooltip:SetHyperlink(link)
              if canShare then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(L["ShiftClickToLinkToChat"], GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              end
            end
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if link and strlen(link) > 0 and canShare then
              if IsModifiedClick("CHATLINK") then
                if not ChatEdit_InsertLink(link) then
                  ChatFrame_OpenChat(link);
                end
              end
            end
          end,
        }
      end,
    },
    {
      name = L["Profession"],
      width = 100,
      toggleHidden = true,
      cell = function(data)
        return {
          text = data.dataProfession.name,
        }
      end,
    },
    {
      name = L["Category"],
      width = 80,
      toggleHidden = true,
      cell = function(data)
        local objectiveType = Utils:TableGet(Data.ObjectiveTypes, "id", data.objective.typeID)
        if not objectiveType then
          return {
            text = "?"
          }
        end
        return {
          text = objectiveType.name,
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(objectiveType.name, 1, 1, 1);
            GameTooltip:AddLine(objectiveType.description, nil, nil, nil, true)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
    },
    {
      name = L["Location"],
      width = 100,
      toggleHidden = true,
      cell = function(data)
        local text = " "
        if data.objective then
          local loc = data.objective.loc
          if loc and loc.m then
            if Data.cache.mapInfo[loc.m] then
              text = Data.cache.mapInfo[loc.m].name
            else
              local mapInfo = C_Map.GetMapInfo(loc.m)
              if mapInfo then
                Data.cache.mapInfo[loc.m] = mapInfo
                text = mapInfo.name
              end
            end
          end
        end
        return {
          text = text,
        }
      end,
    },
    -- {
    --   name = "Repeat",
    --   width = 60,
    --   toggleHidden = true,
    --   cell = function(data)
    --     local objective = Data:GetObjective(data.objective.objectiveID)
    --     return {
    --       text = objective.repeatable,
    --     }
    --   end,
    -- },
    {
      name = L["Progress"],
      width = 70,
      align = "CENTER",
      toggleHidden = true,
      cell = function(data)
        local result = format("%d / %d", data.progress.questsCompleted, data.progress.questsTotal)
        if data.progress.questsTotal == 0 then
          result = ""
        elseif data.progress.questsCompleted == data.progress.questsTotal then
          result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
        end

        return {
          text = result,
        }
      end,
    },
    {
      name = L["Points"],
      width = 70,
      align = "CENTER",
      toggleHidden = true,
      cell = function(data)
        local result = format("%d / %d", data.progress.pointsEarned, data.progress.pointsTotal)
        if data.progress.questsTotal == 0 then
          result = ""
        elseif data.progress.pointsEarned == data.progress.pointsTotal then
          result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
        end

        return {
          text = result,
        }
      end,
    },
    {
      name = "",
      width = 50,
      align = "CENTER",
      cell = function(data)
        local loc = data.objective.loc
        local requires = data.objective.requires
        local TomTom = _G["TomTom"]
        if data.objective then
          local mapInfo = nil
          local point = nil
          if loc and loc.m then
            mapInfo = C_Map.GetMapInfo(loc.m)
          end
          if mapInfo then
            point = UiMapPoint.CreateFromCoordinates(loc.m, loc.x / 100, loc.y / 100)
          end
          return {
            text = CreateAtlasMarkup("Waypoint-MapPin-Tracked", 20, 20, -4),
            onEnter = function(columnFrame)
              local showTooltip = function()
                GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
                GameTooltip:SetText(L["DoYouKnowTheWay"], 1, 1, 1)
                if loc and loc.hint then
                  GameTooltip:AddLine(loc.hint, nil, nil, nil, true)
                end
                if mapInfo then
                  GameTooltip:AddLine(" ")
                  GameTooltip:AddDoubleLine(L["LocationAt"], mapInfo.name, nil, nil, nil, 1, 1, 1)
                end
                if loc and loc.x then
                  if not mapInfo then
                    GameTooltip:AddLine(" ")
                  end
                  GameTooltip:AddDoubleLine(L["CoordinatesAt"], format("%.1f / %.1f", loc.x, loc.y), nil, nil, nil, 1, 1, 1)
                end
                if requires and Utils:TableCount(requires) > 0 then
                  GameTooltip:AddLine(" ")
                  GameTooltip:AddLine(L["RequirementsA"])
                  Utils:TableForEach(requires, function(req)
                    local leftText = " "
                    local rightText = format("x%d", req.amount)
                    local completed = false
                    if req.type == "item" then
                      local _, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(req.id)
                      local itemCount = C_Item.GetItemCount(req.id)
                      leftText = format("%s %s", CreateSimpleTextureMarkup(itemTexture or [[Interface\Icons\INV_Misc_QuestionMark]]), itemLink or "Loading...")
                      if itemCount then
                        rightText = format("%d / %d", itemCount, req.amount)
                        if itemCount >= req.amount then
                          completed = true
                        end
                      end
                    end
                    if req.type == "currency" then
                      local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(req.id)
                      if currencyInfo then
                        local _, _, _, hex = C_Item.GetItemQualityColor(currencyInfo.quality)
                        leftText = format("%s |c%s%s|r", CreateSimpleTextureMarkup(currencyInfo.iconFileID or [[Interface\Icons\INV_Misc_QuestionMark]]), hex, currencyInfo.name)
                        rightText = format("%d / %d", currencyInfo.quantity, req.amount)
                        if currencyInfo.quantity >= req.amount then
                          completed = true
                        end
                      end
                    end
                    if req.type == "renown" then
                      local renownInfo = C_MajorFactions.GetMajorFactionData(req.id)
                      local renownLevel = C_MajorFactions.GetCurrentRenownLevel(req.id) or 0
                      if renownInfo and renownLevel > 0 then
                        leftText = renownInfo.name
                        rightText = format("%d / %d", renownLevel, req.amount)
                        if renownLevel >= req.amount then
                          completed = true
                        end
                      end
                    end
                    GameTooltip:AddDoubleLine(leftText, format("%s %s", rightText, CreateAtlasMarkup(completed and "common-icon-checkmark" or "common-icon-redx", 13, 13)), 1, 1, 1, 1, 1, 1)
                  end)
                end
                if point then
                  if C_Map.CanSetUserWaypointOnMap(loc.m) or TomTom then
                    GameTooltip:AddLine(" ")
                  end
                  if C_Map.CanSetUserWaypointOnMap(loc.m) then
                    GameTooltip:AddLine(L["ClickToPlaceAPinOnTheMap"], GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                    GameTooltip:AddLine(L["ShiftClickToShareAPinInChat"], GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                  end
                  if TomTom then
                    GameTooltip:AddLine(L["AltClickToPlaceAWaypoint"], GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                  end
                end
                GameTooltip:Show()
              end

              if requires and Utils:TableCount(requires) > 0 then
                Utils:TableForEach(requires, function(req)
                  if req.type == "item" then
                    Data.cache.items[req.id] = Item:CreateFromItemID(req.id)
                    Data.cache.items[req.id]:ContinueOnItemLoad(showTooltip)
                  end
                end)
              end

              showTooltip()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
            onClick = function()
              if point then
                if IsAltKeyDown() and TomTom then
                  local text = L["Objective"]
                  if data.item.id and data.item.id > 0 and data.item.link then
                    text = data.item.link
                    if data.item.texture then
                      text = "|T" .. data.item.texture .. ":0|t " .. data.item.link
                    end
                  else
                    text = L["Quest"]
                    local questTooltipData = C_TooltipInfo.GetHyperlink("quest:" .. data.objective.quests[1] .. ":-1")
                    if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
                      text = WrapTextInColorCode(format("%s [%s]", CreateAtlasMarkup("questlog-questtypeicon-Recurring", 14, 14), questTooltipData.lines[1].leftText), "ffffff00")
                    end
                  end
                  TomTom:AddWaypoint(loc.m, loc.x / 100, loc.y / 100, {title = text, from = addonName})
                elseif C_Map.CanSetUserWaypointOnMap(loc.m) then
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
              end
            end,
          }
        end
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
