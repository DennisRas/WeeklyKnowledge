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
  ---@type WK_DataColumn[]
  local dataColumns = {
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
    table.insert(dataColumns, dataColumn)
  end)

  if unfiltered then
    return dataColumns
  end

  local filteredColumns = Utils:TableFilter(dataColumns, function(column)
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

function UI:ToggleChecklist()
  if not self.frameChecklist then return end
  if self.frameChecklist:IsVisible() then
    self.frameChecklist:Hide()
  else
    self.frameChecklist:Show()
  end
  self:Render()
end

function UI:Render()
  self:RenderMain()
  self:RenderChecklist()
end

function UI:RenderMain()
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
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              Data.db.global.windowBackgroundColor.r = r
              Data.db.global.windowBackgroundColor.g = g
              Data.db.global.windowBackgroundColor.b = b
              if a then
                Data.db.global.windowBackgroundColor.a = a
              end
              Utils:SetBackgroundColor(self.frame, Data.db.global.windowBackgroundColor.r, Data.db.global.windowBackgroundColor.g, Data.db.global.windowBackgroundColor.b, Data.db.global.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              Data.db.global.windowBackgroundColor.r = color.r
              Data.db.global.windowBackgroundColor.g = color.g
              Data.db.global.windowBackgroundColor.b = color.b
              if color.a then
                Data.db.global.windowBackgroundColor.a = color.a
              end
              Utils:SetBackgroundColor(self.frame, Data.db.global.windowBackgroundColor.r, Data.db.global.windowBackgroundColor.g, Data.db.global.windowBackgroundColor.b, Data.db.global.windowBackgroundColor.a)
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
      self.frame.titlebar.ChecklistButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
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
        Data.db.global.checklistHelpTipClosed = true
        self:ToggleChecklist()
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

  -- Show helptip for new checklist
  local checklistHelpTipText = "Check out the new checklist!"
  if Data.db.global.checklistHelpTipClosed then
    HelpTip:Hide(self.frame, checklistHelpTipText)
  else
    HelpTip:Show(
      self.frame,
      {
        text = checklistHelpTipText,
        buttonStyle = HelpTip.ButtonStyle.Close,
        targetPoint = HelpTip.Point.TopEdgeCenter,
        onAcknowledgeCallback = function()
          Data.db.global.checklistHelpTipClosed = true
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
  self.frame:SetHeight(math.min(tableHeight + TITLEBAR_HEIGHT, MAX_WINDOW_HEIGHT))
  self.frame:SetScale(Data.db.global.windowScale / 100)

  self:RenderChecklist()
end

function UI:RenderChecklist()
  local character = Data:GetCharacter()
  if not character then return end
  local tableWidth = 530
  local tableHeight = 0
  local rowHeight = 20
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

  if not self.frameChecklist then
    local frameName = addonName .. "ChecklistWindow"
    self.frameChecklist = CreateFrame("Frame", frameName, UIParent)
    self.frameChecklist:SetSize(500, 500)
    self.frameChecklist:SetFrameStrata("HIGH")
    self.frameChecklist:SetFrameLevel(8100)
    self.frameChecklist:SetClampedToScreen(true)
    self.frameChecklist:SetMovable(true)
    self.frameChecklist:SetPoint("CENTER")
    self.frameChecklist:SetUserPlaced(true)
    self.frameChecklist:RegisterForDrag("LeftButton")
    self.frameChecklist:EnableMouse(true)
    self.frameChecklist:SetScript("OnDragStart", function() self.frameChecklist:StartMoving() end)
    self.frameChecklist:SetScript("OnDragStop", function() self.frameChecklist:StopMovingOrSizing() end)
    self.frameChecklist:Hide()
    Utils:SetBackgroundColor(self.frameChecklist, Data.db.global.windowBackgroundColor.r, Data.db.global.windowBackgroundColor.g, Data.db.global.windowBackgroundColor.b, Data.db.global.windowBackgroundColor.a)

    self.frameChecklist.border = CreateFrame("Frame", "$parentBorder", self.frameChecklist, "BackdropTemplate")
    self.frameChecklist.border:SetPoint("TOPLEFT", self.frameChecklist, "TOPLEFT", -3, 3)
    self.frameChecklist.border:SetPoint("BOTTOMRIGHT", self.frameChecklist, "BOTTOMRIGHT", 3, -3)
    self.frameChecklist.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.frameChecklist.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.frameChecklist.border:Show()

    self.frameChecklist.titlebar = CreateFrame("Frame", "$parentTitle", self.frameChecklist)
    self.frameChecklist.titlebar:SetPoint("TOPLEFT", self.frameChecklist, "TOPLEFT")
    self.frameChecklist.titlebar:SetPoint("TOPRIGHT", self.frameChecklist, "TOPRIGHT")
    self.frameChecklist.titlebar:SetHeight(TITLEBAR_HEIGHT + 1)
    self.frameChecklist.titlebar:RegisterForDrag("LeftButton")
    self.frameChecklist.titlebar:EnableMouse(true)
    self.frameChecklist.titlebar:SetScript("OnDragStart", function() self.frameChecklist:StartMoving() end)
    self.frameChecklist.titlebar:SetScript("OnDragStop", function() self.frameChecklist:StopMovingOrSizing() end)
    Utils:SetBackgroundColor(self.frameChecklist.titlebar, 0, 0, 0, 0.5)

    self.frameChecklist.titlebar.icon = self.frameChecklist.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frameChecklist.titlebar.icon:SetPoint("LEFT", self.frameChecklist.titlebar, "LEFT", 6, 0)
    self.frameChecklist.titlebar.icon:SetSize(20, 20)
    self.frameChecklist.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")

    self.frameChecklist.titlebar.title = self.frameChecklist.titlebar:CreateFontString("$parentText", "OVERLAY")
    self.frameChecklist.titlebar.title:SetFontObject("SystemFont_Med2")
    self.frameChecklist.titlebar.title:SetPoint("LEFT", self.frameChecklist.titlebar, 28, 0)
    self.frameChecklist.titlebar.title:SetJustifyH("LEFT")
    self.frameChecklist.titlebar.title:SetJustifyV("MIDDLE")
    self.frameChecklist.titlebar.title:SetText("Checklist")

    do -- Close Button
      self.frameChecklist.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.frameChecklist.titlebar)
      self.frameChecklist.titlebar.closeButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frameChecklist.titlebar.closeButton:SetPoint("RIGHT", self.frameChecklist.titlebar, "RIGHT", 0, 0)
      self.frameChecklist.titlebar.closeButton:SetScript("OnClick", function() self:ToggleChecklist() end)
      self.frameChecklist.titlebar.closeButton:SetScript("OnEnter", function()
        self.frameChecklist.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        Utils:SetBackgroundColor(self.frameChecklist.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(self.frameChecklist.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
        GameTooltip:Show()
      end)
      self.frameChecklist.titlebar.closeButton:SetScript("OnLeave", function()
        self.frameChecklist.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frameChecklist.titlebar.closeButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      self.frameChecklist.titlebar.closeButton.Icon = self.frameChecklist.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      self.frameChecklist.titlebar.closeButton.Icon:SetPoint("CENTER", self.frameChecklist.titlebar.closeButton, "CENTER")
      self.frameChecklist.titlebar.closeButton.Icon:SetSize(10, 10)
      self.frameChecklist.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
      self.frameChecklist.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    table.insert(UISpecialFrames, frameName)

    self.frameChecklist.table = UI:CreateTableFrame({
      header = {
        enabled = true,
        sticky = true,
        height = math.floor(rowHeight * 1.3),
      },
      rows = {
        height = rowHeight,
        highlight = false,
        striped = true
      },
      cells = {
        padding = 6,
        highlight = true
      },
    })
    self.frameChecklist.table:SetParent(self.frameChecklist)
    self.frameChecklist.table:SetPoint("TOPLEFT", self.frameChecklist, "TOPLEFT", 0, -TITLEBAR_HEIGHT)
    self.frameChecklist.table:SetPoint("BOTTOMRIGHT", self.frameChecklist, "BOTTOMRIGHT", 0, 0)
  end

  do -- Header row
    ---@type WK_TableDataRow
    local row = {
      columns = {
        {
          text = NORMAL_FONT_COLOR:WrapTextInColorCode("Item"),
        },
        {
          text = NORMAL_FONT_COLOR:WrapTextInColorCode("Profession"),
        },
        {
          text = NORMAL_FONT_COLOR:WrapTextInColorCode("Category"),
        },
        {
          text = NORMAL_FONT_COLOR:WrapTextInColorCode("Points"),
        },
        {
          text = "",
        },
      }
    }
    table.insert(tableData.rows, row)
    tableHeight = tableHeight + self.frameChecklist.table.config.header.height
  end


  Utils:TableForEach(character.professions, function(characterProfession)
    local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
      return dataProfession.skillLineID == characterProfession.skillLineID
    end)
    if not dataProfession then return end

    Utils:TableForEach(dataProfession.objectives, function(professionObjective)
      if not professionObjective.itemID then
        return
      end
      local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(professionObjective.itemID)
      if not itemName then
        return
      end
      ---@type WK_TableDataRow
      local row = {
        -- onEnter = function(rowFrame)
        --   GameTooltip:SetOwner(rowFrame, "ANCHOR_RIGHT")
        --   GameTooltip:SetText("Do you know de way?")
        --   GameTooltip:AddLine(" ")
        --   GameTooltip:AddLine("<Shift Click to Show on Map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        --   GameTooltip:Show()
        -- end,
        -- onLeave = function()
        --   GameTooltip:Hide()
        -- end,
        columns = {
          {
            text = "|T" .. itemTexture .. ":0|t " .. itemLink,
            onEnter = function(columnFrame)
              GameTooltip:ClearAllPoints()
              GameTooltip:ClearLines()
              GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
              GameTooltip:SetHyperlink(itemLink)
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
            onClick = function()
              if IsModifiedClick("CHATLINK") then
                if not ChatEdit_InsertLink(itemLink) then
                  ChatFrame_OpenChat(itemLink);
                end
              end
            end
          },
          {
            text = dataProfession.name,
          },
          {
            text = professionObjective.category.name,
          },
          {
            text = "+" .. tostring(professionObjective.points),
          },
          {
            text = CreateAtlasMarkup("Waypoint-MapPin-Untracked", 20, 20),
            onEnter = function(columnFrame)
              GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText("Do you know de wey?")
              GameTooltip:AddDoubleLine("Location:", "-", 1, 1, 1, 1, 1, 1)
              GameTooltip:AddDoubleLine("Coordinates:", "00.00 / 00.00", 1, 1, 1, 1, 1, 1)
              -- GameTooltip:AddDoubleLine("X:", "0", nil, nil, nil, 1, 1, 1)
              -- GameTooltip:AddDoubleLine("Y:", "0", nil, nil, nil, 1, 1, 1)
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("<Click to Pin on Map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
          },
        }
      }
      table.insert(tableData.rows, row)
      tableHeight = tableHeight + self.frameChecklist.table.config.rows.height
    end)
  end)

  self.frameChecklist.table:SetData(tableData)
  self.frameChecklist:SetWidth(tableWidth)
  self.frameChecklist:SetHeight(math.min(tableHeight + TITLEBAR_HEIGHT, 300))
  self.frameChecklist:SetScale(Data.db.global.windowScale / 100)

  -- self.frameChecklist:Show()
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
      ---@type WK_TableData
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
      local rowHeight = frame.config.rows.height
      if rowIndex == 1 and frame.config.header.enabled then
        rowHeight = frame.config.header.height
      end

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

      function rowFrame:onEnterHandler(f)
        if rowIndex > 1 or not frame.config.header.enabled then
          Utils:SetHighlightColor(rowFrame, 1, 1, 1, .03)
        end
        if row.onEnter then
          row:onEnter(f)
        end
      end

      function rowFrame:onLeaveHandler(f)
        if rowIndex > 1 or not frame.config.header.enabled then
          Utils:SetHighlightColor(rowFrame, 1, 1, 1, 0)
        end
        if row.onLeave then
          row:onLeave(f)
        end
      end

      function rowFrame:onClickHandler(f)
        if row.onClick then
          row:onClick(f)
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

        function columnFrame:onEnterHandler(f)
          rowFrame:onEnterHandler(f)
          if column.onEnter then
            column.onEnter(f)
          end
        end

        function columnFrame:onLeaveHandler(f)
          rowFrame:onLeaveHandler(f)
          if column.onLeave then
            column.onLeave(f)
          end
        end

        function columnFrame:onClickHandler(f)
          rowFrame:onClickHandler(f)
          if column.onClick then
            column:onClick(f)
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
