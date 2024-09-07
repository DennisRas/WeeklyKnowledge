---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

local Data = addon.Data
local Main = addon.Main
local Checklist = addon.Checklist
local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

local Core = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
addon.Core = Core

_G.WeeklyKnowledge = addon

function Core:Render()
  Main:Render()
  Checklist:Render()
end

function Core:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE"] = "Show/Hide the window"
  self:RegisterChatCommand("wk", function() Main:ToggleWindow() end)
  self:RegisterChatCommand("weeklyknowledge", function() Main:ToggleWindow() end)

  Data:InitDB()
  Data:MigrateDB()
  if Data:TaskWeeklyReset() then
    self:Print("Weekly Reset: Good job! Progress of your characters have been reset for a new week.")
  end

  local WKLDB = LibDataBroker:NewDataObject(addonName, {
    label = addonName,
    type = "launcher",
    icon = "Interface/AddOns/WeeklyKnowledge/Media/Icon.blp",
    OnClick = function()
      Main:ToggleWindow()
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText("WeeklyKnowledge", 1, 1, 1)
      tooltip:AddLine("Click to open WeeklyKnowledge", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = "Drag to move this icon"
      if Data.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
  })
  LibDBIcon:Register(addonName, WKLDB, Data.db.global.minimap)
  LibDBIcon:AddButtonToCompartment(addonName)

  if not self.frame then
    local frameName = "WeeklyKnowledgeMainWindow"
    self.frame = CreateFrame("Frame", frameName, UIParent)
    self.frame:SetSize(1000, 500)
    self.frame:SetFrameStrata("HIGH")
    self.frame:SetFrameLevel(8000)
    self.frame:SetClampedToScreen(true)
    self.frame:SetMovable(true)
    self.frame:SetPoint("CENTER")
    self.frame:SetUserPlaced(true)
    WP:SetBackgroundColor(self.frame, self.db.global.windowBackgroundColor.r, self.db.global.windowBackgroundColor.g, self.db.global.windowBackgroundColor.b, self.db.global.windowBackgroundColor.a)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:EnableMouse(true)
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame:Hide()
    self.frame.border = CreateFrame("Frame", "$parentBorder", self.frame, "BackdropTemplate")
    self.frame.border:SetPoint("TOPLEFT", self.frame, "TOPLEFT", -3, 3)
    self.frame.border:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 3, -3)
    self.frame.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.frame.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.frame.border:Show()
    self.frame.titlebar = CreateFrame("Frame", "$parentTitle", self.frame)
    self.frame.titlebar:SetPoint("TOPLEFT", self.frame, "TOPLEFT")
    self.frame.titlebar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT")
    WP:SetBackgroundColor(self.frame.titlebar, 0, 0, 0, 0.5)
    self.frame.titlebar:SetHeight(TITLEBAR_HEIGHT + 1)
    self.frame.titlebar:RegisterForDrag("LeftButton")
    self.frame.titlebar:EnableMouse(true)
    self.frame.titlebar:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame.titlebar:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame.titlebar.icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frame.titlebar.icon:SetPoint("LEFT", self.frame.titlebar, "LEFT", 6, 0)
    self.frame.titlebar.icon:SetSize(20, 20)
    self.frame.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")
    self.frame.titlebar.title = self.frame.titlebar:CreateFontString("$parentText", "OVERLAY")
    self.frame.titlebar.title:SetFontObject("SystemFont_Med2")
    self.frame.titlebar.title:SetPoint("LEFT", self.frame.titlebar, 28, 0)
    self.frame.titlebar.title:SetJustifyH("LEFT")
    self.frame.titlebar.title:SetJustifyV("MIDDLE")
    self.frame.titlebar.title:SetText("WeeklyKnowledge")
    self.frame.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.frame.titlebar)
    self.frame.titlebar.closeButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
    self.frame.titlebar.closeButton:SetPoint("RIGHT", self.frame.titlebar, "RIGHT", 0, 0)
    self.frame.titlebar.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
    self.frame.titlebar.closeButton.Icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frame.titlebar.closeButton.Icon:SetPoint("CENTER", self.frame.titlebar.closeButton, "CENTER")
    self.frame.titlebar.closeButton.Icon:SetSize(10, 10)
    self.frame.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
    self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    self.frame.titlebar.closeButton:SetScript("OnEnter", function()
      self.frame.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
      self:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 0, 0, 0.2)
      GameTooltip:ClearAllPoints()
      GameTooltip:ClearLines()
      GameTooltip:SetOwner(self.frame.titlebar.closeButton, "ANCHOR_TOP")
      GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
      GameTooltip:Show()
    end)
    self.frame.titlebar.closeButton:SetScript("OnLeave", function()
      self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 1, 1, 0)
      GameTooltip:Hide()
    end)

    do -- Settings
      self.frame.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.frame.titlebar)
      self.frame.titlebar.SettingsButton:SetPoint("RIGHT", self.frame.titlebar.closeButton, "LEFT", 0, 0)
      self.frame.titlebar.SettingsButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frame.titlebar.SettingsButton:SetScript("OnEnter", function()
        self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(self.frame.titlebar.SettingsButton, 1, 1, 1, 0.05)
        GameTooltip:SetOwner(self.frame.titlebar.SettingsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Settings", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Let's customize things a bit", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.SettingsButton:SetScript("OnLeave", function()
        self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(self.frame.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.SettingsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.frame.titlebar.SettingsButton, "CENTER")
      self.frame.titlebar.SettingsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
        local showMinimapIcon = rootMenu:CreateCheckbox(
          "Show the minimap button",
          function() return not self.db.global.minimap.hide end,
          function()
            self.db.global.minimap.hide = not self.db.global.minimap.hide
            self.Libs.LDBIcon:Refresh("WeeklyKnowledge", self.db.global.minimap)
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
            self.Libs.LDBIcon:Refresh("WeeklyKnowledge", self.db.global.minimap)
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
            function() return self.db.global.windowScale == i end,
            function(data)
              self.db.global.windowScale = data
              self:Render()
            end,
            i
          )
        end

        local colorInfo = {
          r = self.db.global.windowBackgroundColor.r,
          g = self.db.global.windowBackgroundColor.g,
          b = self.db.global.windowBackgroundColor.b,
          opacity = self.db.global.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            if r then
              self.db.global.windowBackgroundColor.r = r
              self.db.global.windowBackgroundColor.g = g
              self.db.global.windowBackgroundColor.b = b
              self:SetBackgroundColor(self.frame, self.db.global.windowBackgroundColor.r, self.db.global.windowBackgroundColor.g, self.db.global.windowBackgroundColor.b, self.db.global.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              self.db.global.windowBackgroundColor.r = color.r
              self.db.global.windowBackgroundColor.g = color.g
              self.db.global.windowBackgroundColor.b = color.b
              self:SetBackgroundColor(self.frame, self.db.global.windowBackgroundColor.r, self.db.global.windowBackgroundColor.g, self.db.global.windowBackgroundColor.b, self.db.global.windowBackgroundColor.a)
            end
          end,
          hasOpacity = 0,
        }
        rootMenu:CreateColorSwatch(
          "Window color",
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )
      end)
    end

    do -- Characters
      self.frame.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.frame.titlebar)
      self.frame.titlebar.CharactersButton:SetPoint("RIGHT", self.frame.titlebar.SettingsButton, "LEFT", 0, 0)
      self.frame.titlebar.CharactersButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frame.titlebar.CharactersButton:SetScript("OnEnter", function()
        self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(self.frame.titlebar.CharactersButton, 1, 1, 1, 0.05)
        GameTooltip:ClearAllPoints()
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(self.frame.titlebar.CharactersButton, "ANCHOR_TOP")
        GameTooltip:SetText("Characters", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable your characters.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.CharactersButton:SetScript("OnLeave", function()
        self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(self.frame.titlebar.CharactersButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.CharactersButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.CharactersButton.Icon:SetPoint("CENTER", self.frame.titlebar.CharactersButton, "CENTER")
      self.frame.titlebar.CharactersButton.Icon:SetSize(14, 14)
      self.frame.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Characters.blp")
      self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
        for _, character in pairs(self:GetCharacters(true)) do
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
            function(data)
              self.db.global.characters[data].enabled = not self.db.global.characters[data].enabled
              self:Render()
            end,
            character.GUID
          )
        end
      end)
    end

    do -- Columns
      self.frame.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.frame.titlebar)
      self.frame.titlebar.ColumnsButton:SetPoint("RIGHT", self.frame.titlebar.CharactersButton, "LEFT", 0, 0)
      self.frame.titlebar.ColumnsButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frame.titlebar.ColumnsButton:SetScript("OnEnter", function()
        self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(self.frame.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        GameTooltip:ClearAllPoints()
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(self.frame.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Columns", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable table columns.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.ColumnsButton:SetScript("OnLeave", function()
        self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(self.frame.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.ColumnsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.ColumnsButton.Icon:SetPoint("CENTER", self.frame.titlebar.ColumnsButton, "CENTER")
      self.frame.titlebar.ColumnsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Columns.blp")
      self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = self.db.global.hiddenColumns
        for _, column in pairs(self:GetColumns(true)) do
          rootMenu:CreateCheckbox(
            column.name,
            function() return not hidden[column.name] end,
            function(data)
              self.db.global.hiddenColumns[data] = not self.db.global.hiddenColumns[data]
              self:Render()
            end,
            column.name
          )
        end
      end)
    end

    table.insert(UISpecialFrames, frameName)

    self.frame.table = self:NewTable({
      header = {
        enabled = true,
        sticky = true,
        height = math.floor(ROW_HEIGHT * 1.3),
      },
      rows = {
        height = ROW_HEIGHT,
        highlight = true,
        striped = true
      }
    })
    self.frame.table:SetParent(self.frame)
    self.frame.table:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -TITLEBAR_HEIGHT)
    self.frame.table:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)
  end
end

function Core:OnEnable()
  self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
    Data.cache.inCombat = true
    self:Render()
  end)
  self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    Data.cache.inCombat = false
    self:Render()
  end)
  self:RegisterBucketEvent(
    {
      "ACTIVE_TALENT_GROUP_CHANGED",
      "BAG_UPDATE_DELAYED",
      "CHAT_MSG_LOOT",
      "ITEM_COUNT_CHANGED",
      "PLAYER_SPECIALIZATION_CHANGED",
      "PLAYER_TALENT_UPDATE",
      "QUEST_COMPLETE",
      "QUEST_TURNED_IN",
      "SKILL_LINES_CHANGED",
      "TRAIT_CONFIG_UPDATED",
      "UNIT_INVENTORY_CHANGED",
    },
    3,
    function()
      Data:ScanCharacter()
      self:Render()
    end
  )

  self:RegisterBucketEvent({"CALENDAR_UPDATE_EVENT_LIST",}, 1, function()
    Data:ScanCalendar()
    self:Render()
  end)
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  C_Calendar.SetAbsMonth(currentCalendarTime.month, currentCalendarTime.year)
  C_Calendar.OpenCalendar()

  Data:ScanCharacter()
  self:Render()
end

function Core:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end

function WP:ToggleWindow()
  if self.frame:IsVisible() then
    self.frame:Hide()
  else
    self:Render()
    self.frame:Show()
  end
end

function WP:Render()
  if not self.frame then return end
  local columns = self:GetColumns()
  local tableWidth = 0
  local tableHeight = 0
  local data = {
    columns = {},
    rows = {}
  }

  do -- Column config
    WP:TableForEach(columns, function(column)
      table.insert(data.columns, {
        width = column.width,
        align = column.align or "LEFT",
      })
      tableWidth = tableWidth + column.width
    end)
  end

  do -- Header row
    local row = {
      columns = {}
    }
    WP:TableForEach(columns, function(column)
      table.insert(row.columns, {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(column.name),
        onEnter = column.onEnter,
        onLeave = column.onLeave,
        -- backgroundColor = {r = 0, g = 0, b = 0, a = 0.3},
      })
    end)
    table.insert(data.rows, row)
    tableHeight = tableHeight + self.frame.table.config.header.height
  end

  for _, character in pairs(self:GetCharacters()) do
    for _, characterProfession in ipairs(character.professions) do
      for _, dataProfession in ipairs(WP_DATA) do
        if dataProfession.skillLineID == characterProfession.skillLineID then
          local row = {
            columns = {}
          }

          for _, column in pairs(columns) do
            table.insert(row.columns, column.cell(character, characterProfession, dataProfession))
          end

          table.insert(data.rows, row)
          tableHeight = tableHeight + self.frame.table.config.rows.height
        end
      end
    end
  end

  self.frame.table:SetData(data)
  self.frame:SetWidth(tableWidth)
  self.frame:SetHeight(math.min(tableHeight + TITLEBAR_HEIGHT, MAX_WINDOW_HEIGHT)) -- ST height + ST header + frame padding + titlebar
  self.frame:SetScale(self.db.global.windowScale / 100)
end

local TableCollection = {}

function WP:NewTable(config)
  local frame = WP:CreateScrollFrame("WeeklyKnowledgeTable" .. (WP:TableCount(TableCollection) + 1))
  frame.config = CreateFromMixins(
    {
      header = {
        enabled = true,
        sticky = false,
        height = 30,
      },
      rows = {
        height = 22,
        highlight = true,
        striped = true
      },
      columns = {
        width = 100,
        highlight = false,
        striped = false
      },
      cells = {
        padding = 8,
        highlight = false
      },
      data = {
        columns = {},
        rows = {},
      },
    },
    config or {}
  )
  frame.rows = {}
  frame.data = frame.config.data

  ---Set the table data
  function frame:SetData(data)
    frame.data = data
    frame:RenderTable()
  end

  function frame:SetRowHeight(height)
    self.config.rows.height = height
    self:Update()
  end

  function frame:RenderTable()
    local offsetY = 0
    local offsetX = 0

    WP:TableForEach(frame.rows, function(rowFrame) rowFrame:Hide() end)
    WP:TableForEach(frame.data.rows, function(row, rowIndex)
      local rowFrame = frame.rows[rowIndex]
      local rowHeight = rowIndex == 1 and 30 or frame.config.rows.height

      if not rowFrame then
        rowFrame = CreateFrame("Button", "$parentRow" .. rowIndex, frame.content)
        rowFrame.columns = {}
        frame.rows[rowIndex] = rowFrame
      end

      rowFrame.data = row
      rowFrame:SetPoint("TOPLEFT", frame.content, "TOPLEFT", 0, -offsetY)
      rowFrame:SetPoint("TOPRIGHT", frame.content, "TOPRIGHT", 0, -offsetY)
      rowFrame:SetHeight(rowHeight)
      rowFrame:SetScript("OnEnter", function() rowFrame:onEnterHandler(rowFrame) end)
      rowFrame:SetScript("OnLeave", function() rowFrame:onLeaveHandler(rowFrame) end)
      rowFrame:SetScript("OnClick", function() rowFrame:onClickHandler(rowFrame) end)
      rowFrame:Show()

      if frame.config.rows.striped and rowIndex % 2 == 1 then
        WP:SetBackgroundColor(rowFrame, 1, 1, 1, .02)
      end

      if row.backgroundColor then
        WP:SetBackgroundColor(rowFrame, row.backgroundColor.r, row.backgroundColor.g, row.backgroundColor.b, row.backgroundColor.a)
      end

      function rowFrame:onEnterHandler(arg1, arg2, arg3)
        if rowIndex > 1 then
          WP:SetHighlightColor(rowFrame, 1, 1, 1, .03)
        end
        if row.OnEnter then
          row:OnEnter(arg1, arg2, arg3)
        end
      end

      function rowFrame:onLeaveHandler(...)
        if rowIndex > 1 then
          WP:SetHighlightColor(rowFrame, 1, 1, 1, 0)
        end
        if row.OnLeave then
          row:OnLeave(...)
        end
      end

      function rowFrame:onClickHandler(...)
        if row.OnClick then
          row:OnClick(...)
        end
      end

      -- Sticky header
      if frame.config.header.sticky and rowIndex == 1 then
        if frame then
          rowFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -offsetY)
          rowFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -offsetY)
          rowFrame:SetToplevel(true)
          rowFrame:SetFrameStrata("HIGH")
        end
        if not row.backgroundColor then
          WP:SetBackgroundColor(rowFrame, 0.0784, 0.0980, 0.1137, 1)
        end
      end

      offsetX = 0
      WP:TableForEach(rowFrame.columns, function(columnFrame) columnFrame:Hide() end)
      WP:TableForEach(row.columns, function(column, columnIndex)
        local columnFrame = rowFrame.columns[columnIndex]
        local columnConfig = frame.data.columns[columnIndex]
        local columnWidth = columnConfig and columnConfig.width or frame.config.columns.width
        local columnTextAlign = columnConfig and columnConfig.align or "LEFT"

        if not columnFrame then
          columnFrame = CreateFrame("Button", "$parentCol" .. columnIndex, rowFrame)
          columnFrame.text = columnFrame:CreateFontString("$parentText", "OVERLAY")
          columnFrame.text:SetFontObject("GameFontHighlightSmall")
          rowFrame.columns[columnIndex] = columnFrame
        end

        columnFrame.data = column
        columnFrame:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", offsetX, 0)
        columnFrame:SetPoint("BOTTOMLEFT", rowFrame, "BOTTOMLEFT", offsetX, 0)
        columnFrame:SetWidth(columnWidth)
        columnFrame:SetScript("OnEnter", function() columnFrame:onEnterHandler(columnFrame) end)
        columnFrame:SetScript("OnLeave", function() columnFrame:onLeaveHandler(columnFrame) end)
        columnFrame:SetScript("OnClick", function() columnFrame:onClickHandler(columnFrame) end)
        columnFrame.text:SetWordWrap(false)
        columnFrame.text:SetJustifyH(columnTextAlign)
        columnFrame.text:SetPoint("TOPLEFT", columnFrame, "TOPLEFT", frame.config.cells.padding, -frame.config.cells.padding)
        columnFrame.text:SetPoint("BOTTOMRIGHT", columnFrame, "BOTTOMRIGHT", -frame.config.cells.padding, frame.config.cells.padding)
        columnFrame.text:SetText(column.text)
        columnFrame:Show()

        if column.backgroundColor then
          WP:SetBackgroundColor(columnFrame, column.backgroundColor.r, column.backgroundColor.g, column.backgroundColor.b, column.backgroundColor.a)
        end

        function columnFrame:onEnterHandler(...)
          rowFrame:onEnterHandler(...)
          if column.onEnter then
            column.onEnter(...)
          end
        end

        function columnFrame:onLeaveHandler(...)
          rowFrame:onLeaveHandler(...)
          if column.onLeave then
            column.onLeave(...)
          end
          -- TODO: move tooltip stuff to the callback source
          if column.onEnter then
            GameTooltip:Hide()
          end
        end

        function columnFrame:onClickHandler(...)
          rowFrame:onClickHandler(...)
          if column.onClick then
            column:onClick(...)
          end
        end

        offsetX = offsetX + columnWidth
      end)

      offsetY = offsetY + rowHeight
    end)

    frame.content:SetSize(offsetX, offsetY)
  end

  frame:HookScript("OnSizeChanged", function() frame:RenderTable() end)
  frame:RenderTable()
  table.insert(TableCollection, frame)
  return frame;
end

---Find a table item by callback
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): boolean
---@return T|nil, number|nil
function WP:TableFind(tbl, callback)
  for i, v in ipairs(tbl) do
    if callback(v, i) then
      return v, i
    end
  end
  return nil, nil
end

---Find a table item by key and value
---@generic T
---@param tbl T[]
---@param key string
---@param val any
---@return T|nil
function WP:TableGet(tbl, key, val)
  return WP:TableFind(tbl, function(elm)
    return elm[key] and elm[key] == val
  end)
end

---Create a new table containing all elements that pass truth test
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): boolean
---@return T[]
function WP:TableFilter(tbl, callback)
  local t = {}
  for i, v in ipairs(tbl) do
    if callback(v, i) then
      table.insert(t, v)
    end
  end
  return t
end

---Count table items
---@param tbl table
---@return number
function WP:TableCount(tbl)
  local n = 0
  for _ in pairs(tbl) do
    n = n + 1
  end
  return n
end

---Deep copy a table
---@generic T
---@param tbl T[]
---@param cache table?
---@return T[]
function WP:TableCopy(tbl, cache)
  local t = {}
  cache = cache or {}
  cache[tbl] = t
  self:TableForEach(tbl, function(v, k)
    if type(v) == "table" then
      t[k] = cache[v] or self:TableCopy(v, cache)
    else
      t[k] = v
    end
  end)
  return t
end

---Map each item in a table
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): any
---@return T[]
function WP:TableMap(tbl, callback)
  local t = {}
  self:TableForEach(tbl, function(v, k)
    local newv, newk = callback(v, k)
    t[newk and newk or k] = newv
  end)
  return t
end

---Run a callback on each table item
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number)
---@return T[]
function WP:TableForEach(tbl, callback)
  assert(tbl, "Must be a table!")
  for ik, iv in pairs(tbl) do
    callback(iv, ik)
  end
  return tbl
end

function WP:CreateScrollFrame(name, parent)
  local frame = CreateFrame("ScrollFrame", name, parent)
  frame.content = CreateFrame("Frame", "$parentContent", frame)
  frame.scrollbarH = CreateFrame("Slider", "$parentScrollbarH", frame, "UISliderTemplate")
  frame.scrollbarV = CreateFrame("Slider", "$parentScrollbarV", frame, "UISliderTemplate")

  frame:SetScript("OnMouseWheel", function(_, delta)
    if IsModifierKeyDown() or not frame.scrollbarV:IsVisible() then
      frame.scrollbarH:SetValue(frame.scrollbarH:GetValue() - delta * ((frame.content:GetWidth() - frame:GetWidth()) * 0.2))
    else
      frame.scrollbarV:SetValue(frame.scrollbarV:GetValue() - delta * ((frame.content:GetHeight() - frame:GetHeight()) * 0.2))
    end
  end)
  frame:SetScript("OnSizeChanged", function() frame:RenderScrollFrame() end)
  frame:SetScrollChild(frame.content)
  frame.content:SetScript("OnSizeChanged", function() frame:RenderScrollFrame() end)

  frame.scrollbarH:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
  frame.scrollbarH:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.scrollbarH:SetHeight(6)
  frame.scrollbarH:SetMinMaxValues(0, 100)
  frame.scrollbarH:SetValue(0)
  frame.scrollbarH:SetValueStep(1)
  frame.scrollbarH:SetOrientation("HORIZONTAL")
  frame.scrollbarH:SetObeyStepOnDrag(true)
  frame.scrollbarH.thumb = frame.scrollbarH:GetThumbTexture()
  frame.scrollbarH.thumb:SetPoint("CENTER")
  frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.15)
  frame.scrollbarH.thumb:SetHeight(10)
  frame.scrollbarH:SetScript("OnValueChanged", function(_, value) frame:SetHorizontalScroll(value) end)
  frame.scrollbarH:SetScript("OnEnter", function() frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.2) end)
  frame.scrollbarH:SetScript("OnLeave", function() frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.15) end)

  frame.scrollbarV:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.scrollbarV:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
  frame.scrollbarV:SetWidth(6)
  frame.scrollbarV:SetMinMaxValues(0, 100)
  frame.scrollbarV:SetValue(0)
  frame.scrollbarV:SetValueStep(1)
  frame.scrollbarV:SetOrientation("VERTICAL")
  frame.scrollbarV:SetObeyStepOnDrag(true)
  frame.scrollbarV.thumb = frame.scrollbarV:GetThumbTexture()
  frame.scrollbarV.thumb:SetPoint("CENTER")
  frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.15)
  frame.scrollbarV.thumb:SetWidth(10)
  frame.scrollbarV:SetScript("OnValueChanged", function(_, value) frame:SetVerticalScroll(value) end)
  frame.scrollbarV:SetScript("OnEnter", function() frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.2) end)
  frame.scrollbarV:SetScript("OnLeave", function() frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.15) end)

  if frame.scrollbarH.NineSlice then frame.scrollbarH.NineSlice:Hide() end
  if frame.scrollbarV.NineSlice then frame.scrollbarV.NineSlice:Hide() end

  function frame:RenderScrollFrame()
    if math.floor(frame.content:GetWidth()) > math.floor(frame:GetWidth()) then
      frame.scrollbarH:SetMinMaxValues(0, frame.content:GetWidth() - frame:GetWidth())
      frame.scrollbarH.thumb:SetWidth(frame.scrollbarH:GetWidth() / 5)
      frame.scrollbarH.thumb:SetHeight(frame.scrollbarH:GetHeight())
      frame.scrollbarH:Show()
    else
      frame:SetHorizontalScroll(0)
      frame.scrollbarH:Hide()
    end
    if math.floor(frame.content:GetHeight()) > math.floor(frame:GetHeight()) then
      frame.scrollbarV:SetMinMaxValues(0, frame.content:GetHeight() - frame:GetHeight())
      frame.scrollbarV.thumb:SetHeight(frame.scrollbarV:GetHeight() / 5)
      frame.scrollbarV.thumb:SetWidth(frame.scrollbarV:GetWidth())
      frame.scrollbarV:Show()
    else
      frame:SetVerticalScroll(0)
      frame.scrollbarV:Hide()
    end
  end

  frame:RenderScrollFrame()
  return frame
end
