---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

local Utils = addon.Utils
local Data = addon.Data
local LibDBIcon = LibStub("LibDBIcon-1.0")

---@class WK_UI
local UI = {}
addon.UI = UI

local ROW_HEIGHT = 24
local TITLEBAR_HEIGHT = 30
local MAX_WINDOW_HEIGHT = 600

function UI:GetColumns(unfiltered)
  local hidden = Data.db.global.hiddenColumns
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
      cell = function(character, characterProfession, dataProfession)
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
      cell = function(character, characterProfession, dataProfession)
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
      cell = function(character, characterProfession, dataProfession)
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
      cell = function(character, characterProfession, dataProfession)
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
      cell = function(character, characterProfession, dataProfession)
        if characterProfession.knowledgeMaxLevel > 0 then
          return {text = characterProfession.knowledgeLevel > 0 and characterProfession.knowledgeLevel == characterProfession.knowledgeMaxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(characterProfession.knowledgeLevel .. " / " .. characterProfession.knowledgeMaxLevel) or characterProfession.knowledgeLevel .. " / " .. characterProfession.knowledgeMaxLevel}
        end
        return {text = ""}
      end,
    },
  }

  Utils:TableForEach(Data.Objectives, function(dataObjective)
    -- for _, dataObjective in ipairs(Data.Objectives) do
    table.insert(columns, {
      name = dataObjective.name,
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(dataObjective, 1, 1, 1);
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
                GameTooltip:SetText(dataObjective, 1, 1, 1);
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
    })
    -- end
  end)

  if unfiltered then
    return columns
  end

  local filteredColumns = Utils:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end

function UI:ToggleWindow()
  if not self.frame then return end
  if self.frame:IsVisible() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
  self:Render()
end

function UI:Render()
  local columns = self:GetColumns()
  local tableWidth = 0
  local tableHeight = 0
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
    Utils:SetBackgroundColor(self.frame, Data.db.global.windowBackgroundColor.r, Data.db.global.windowBackgroundColor.g, Data.db.global.windowBackgroundColor.b, Data.db.global.windowBackgroundColor.a)

    self.frame.border = CreateFrame("Frame", "$parentBorder", self.frame, "BackdropTemplate")
    self.frame.border:SetPoint("TOPLEFT", self.frame, "TOPLEFT", -3, 3)
    self.frame.border:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 3, -3)
    self.frame.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.frame.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.frame.border:Show()

    self.frame.titlebar = CreateFrame("Frame", "$parentTitle", self.frame)
    self.frame.titlebar:SetPoint("TOPLEFT", self.frame, "TOPLEFT")
    self.frame.titlebar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT")
    self.frame.titlebar:SetHeight(TITLEBAR_HEIGHT + 1)
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
      self.frame.titlebar.closeButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
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
      self.frame.titlebar.SettingsButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
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
            function() return Data.db.global.windowScale == i end,
            function(data)
              Data.db.global.windowScale = data
              self:Render()
            end,
            i
          )
        end

        local colorInfo = {
          r = Data.db.global.windowBackgroundColor.r,
          g = Data.db.global.windowBackgroundColor.g,
          b = Data.db.global.windowBackgroundColor.b,
          opacity = Data.db.global.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            if r then
              Data.db.global.windowBackgroundColor.r = r
              Data.db.global.windowBackgroundColor.g = g
              Data.db.global.windowBackgroundColor.b = b
              Utils:SetBackgroundColor(self.frame, Data.db.global.windowBackgroundColor.r, Data.db.global.windowBackgroundColor.g, Data.db.global.windowBackgroundColor.b, Data.db.global.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              Data.db.global.windowBackgroundColor.r = color.r
              Data.db.global.windowBackgroundColor.g = color.g
              Data.db.global.windowBackgroundColor.b = color.b
              Utils:SetBackgroundColor(self.frame, Data.db.global.windowBackgroundColor.r, Data.db.global.windowBackgroundColor.g, Data.db.global.windowBackgroundColor.b, Data.db.global.windowBackgroundColor.a)
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

      self.frame.titlebar.SettingsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.frame.titlebar.SettingsButton, "CENTER")
      self.frame.titlebar.SettingsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    do -- Characters Button
      self.frame.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.frame.titlebar)
      self.frame.titlebar.CharactersButton:SetPoint("RIGHT", self.frame.titlebar.SettingsButton, "LEFT", 0, 0)
      self.frame.titlebar.CharactersButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
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
            function(data)
              Data.db.global.characters[data].enabled = not Data.db.global.characters[data].enabled
              self:Render()
            end,
            character.GUID
          )
        end)
      end)
    end

    do -- Columns Button
      self.frame.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.frame.titlebar)
      self.frame.titlebar.ColumnsButton:SetPoint("RIGHT", self.frame.titlebar.CharactersButton, "LEFT", 0, 0)
      self.frame.titlebar.ColumnsButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
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
        local hidden = Data.db.global.hiddenColumns
        Utils:TableForEach(self:GetColumns(true), function(column)
          rootMenu:CreateCheckbox(
            column.name,
            function() return not hidden[column.name] end,
            function(data)
              Data.db.global.hiddenColumns[data] = not Data.db.global.hiddenColumns[data]
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

    self.frame.table = UI:CreateTableFrame({
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

    table.insert(UISpecialFrames, frameName)
  end

  do -- Column config
    Utils:TableForEach(columns, function(column)
      table.insert(tableData.columns, {
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
    Utils:TableForEach(columns, function(column)
      table.insert(row.columns, {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(column.name),
        onEnter = column.onEnter,
        onLeave = column.onLeave,
      })
    end)
    table.insert(tableData.rows, row)
    tableHeight = tableHeight + self.frame.table.config.header.height
  end

  Utils:TableForEach(Data:GetCharacters(), function(character)
    Utils:TableForEach(character.professions, function(characterProfession)
      local row = {columns = {}}

      local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
        return dataProfession.skillLineID == characterProfession.skillLineID
      end)
      if not dataProfession then return end

      Utils:TableForEach(columns, function(column)
        table.insert(row.columns, column.cell(character, characterProfession, dataProfession))
      end)

      table.insert(tableData.rows, row)
      tableHeight = tableHeight + self.frame.table.config.rows.height
    end)
  end)

  self.frame.table:SetData(tableData)
  self.frame:SetWidth(tableWidth)
  self.frame:SetHeight(math.min(tableHeight + TITLEBAR_HEIGHT, MAX_WINDOW_HEIGHT))
  self.frame:SetScale(Data.db.global.windowScale / 100)
end

function UI:CreateScrollFrame(name, parent)
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

local TableCollection = {}
function UI:CreateTableFrame(config)
  local frame = self:CreateScrollFrame("WeeklyKnowledgeTable" .. (Utils:TableCount(TableCollection) + 1))
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
    self:RenderTable()
  end

  function frame:RenderTable()
    local offsetY = 0
    local offsetX = 0

    Utils:TableForEach(frame.rows, function(rowFrame) rowFrame:Hide() end)
    Utils:TableForEach(frame.data.rows, function(row, rowIndex)
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
        Utils:SetBackgroundColor(rowFrame, 1, 1, 1, .02)
      end

      if row.backgroundColor then
        Utils:SetBackgroundColor(rowFrame, row.backgroundColor.r, row.backgroundColor.g, row.backgroundColor.b, row.backgroundColor.a)
      end

      function rowFrame:onEnterHandler(arg1, arg2, arg3)
        if rowIndex > 1 then
          self:SetHighlightColor(rowFrame, 1, 1, 1, .03)
        end
        if row.OnEnter then
          row:OnEnter(arg1, arg2, arg3)
        end
      end

      function rowFrame:onLeaveHandler(...)
        if rowIndex > 1 then
          self:SetHighlightColor(rowFrame, 1, 1, 1, 0)
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
          Utils:SetBackgroundColor(rowFrame, 0.0784, 0.0980, 0.1137, 1)
        end
      end

      offsetX = 0
      Utils:TableForEach(rowFrame.columns, function(columnFrame) columnFrame:Hide() end)
      Utils:TableForEach(row.columns, function(column, columnIndex)
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
          Utils:SetBackgroundColor(columnFrame, column.backgroundColor.r, column.backgroundColor.g, column.backgroundColor.b, column.backgroundColor.a)
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
