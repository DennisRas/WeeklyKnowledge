---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Main
local Main = {}
addon.Main = Main

local Constants = addon.Constants
local Data = addon.Data
local Checklist = addon.Checklist
local Helpers = addon.Helpers
local LibLiqUI = addon.libs.LiqUI
local LibDBIcon = addon.libs.LibDBIcon
local SetBackgroundColor = LibLiqUI.Utils.SetBackgroundColor
local TableContains = LibLiqUI.Utils.TableContains
local TableCount = LibLiqUI.Utils.TableCount
local TableFilter = LibLiqUI.Utils.TableFilter
local TableForEach = LibLiqUI.Utils.TableForEach
local TableToggle = LibLiqUI.Utils.TableToggle

do
  local dialogName = "WEEKLYKNOWLEDGE_DELETE_CHARACTER"
  StaticPopupDialogs[dialogName] = {
    text = "Remove %s?\nThis cannot be undone.\nTo add this character again, log in on them.",
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(_, character)
      if character then
        Data:DeleteCharacter(character)
        Main:Render()
      end
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
  }
end

function Main:ToggleWindow()
  if not self.window then return end
  if self.window:IsVisible() then
    self.window:Hide()
  else
    if Data.cache.inCombat then return end
    self.window:Show()
  end
  self:Render()
end

function Main:Render()
  local selectedExpansions = Data.db.global.main.selectedExpansions or {}
  local expansions = Data:GetExpansions()
  local characters = Data:GetCharacters()
  local columns = self:GetTableColumns()
  local objectiveCategories = Data:GetObjectiveCategories()
  local tableWidth = 0
  local tableHeight = 0
  ---@type WK_TableRow[]
  local dataRows = {}

  if not self.window then
    local mediaPath = "Interface/AddOns/WeeklyKnowledge/Media/"
    self.window = addon.LiqUI.Window:New({
      name = "Main",
      title = addonName,
      icon = mediaPath .. "Icon.blp",
      point = { "CENTER" },
      border = 4,
      titlebarButtons = {
        {
          name = "Settings",
          icon = mediaPath .. "Icon_Settings.blp",
          tooltipTitle = "Settings",
          tooltipDescription = "Let's customize things a bit",
          setupMenu = function(window, rootMenu)
        local showFullProfessionName = rootMenu:CreateCheckbox(
          "Show full profession name",
          function() return Data.db.global.showFullProfessionName end,
          function()
            Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
            self:Render()
            if addon.Checklist and addon.Checklist.Render then
              addon.Checklist:Render()
            end
          end
        )
        showFullProfessionName:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "Show the full profession name with the expansion variant.");
        end)

        local hideLowLevelProfessions = rootMenu:CreateCheckbox(
          "Hide low level professions",
          function() return Data.db.global.main.hideLowLevelProfessions end,
          function()
            Data.db.global.main.hideLowLevelProfessions = not Data.db.global.main.hideLowLevelProfessions
            self:Render()
          end
        )
        hideLowLevelProfessions:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "Hide professions with a skill level below 25.");
        end)

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

        rootMenu:CreateTitle("Window")
        local windowScale = rootMenu:CreateButton("Scaling")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return (window.db.scale or 100) == i end,
            function(data)
              window.db.scale = data
              self:Render()
            end,
            i
          )
        end

        local windowColor = window.db.windowColor
        local colorInfo = {
          r = windowColor.r,
          g = windowColor.g,
          b = windowColor.b,
          opacity = windowColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              windowColor.r = r
              windowColor.g = g
              windowColor.b = b
              if a then
                windowColor.a = a
              end
              SetBackgroundColor(window, windowColor.r, windowColor.g, windowColor.b, windowColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              windowColor.r = color.r
              windowColor.g = color.g
              windowColor.b = color.b
              if color.a then
                windowColor.a = color.a
              end
              SetBackgroundColor(window, windowColor.r, windowColor.g, windowColor.b, windowColor.a)
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
          function() return window.db.border ~= false end,
          function()
            window.db.border = window.db.border == false
            self:Render()
          end
        )
          end,
        },
        {
          name = "Characters",
          icon = mediaPath .. "Icon_Characters.blp",
          iconSize = 14,
          tooltipTitle = "Characters",
          tooltipDescription = "Enable/Disable your characters.",
          setupMenu = function(_, rootMenu)
            rootMenu:SetScrollMode(GetScreenHeight() - 20)
            TableForEach(Data:GetCharacters(), function(character)
          local name = character.name
          if character.realmName then
            name = format("%s - %s", character.name, character.realmName)
          end
          if character.classID then
            local _, classFile = GetClassInfo(character.classID)
            if classFile then
              local color = C_ClassColor.GetClassColor(classFile)
              if color then
                name = color:WrapTextInColorCode(name)
              end
            end
          end

          local characterButton = rootMenu:CreateButton(name)

          if TableCount(character.professions) > 0 then
            TableForEach(character.professions, function(characterProfession)
              local variant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
              local professionName = (variant and variant.name) or "?"
              characterButton:CreateCheckbox(
                professionName,
                function() return characterProfession.enabled or false end,
                function()
                  characterProfession.enabled = not characterProfession.enabled
                  self:Render()
                end
              )
            end)
          end
          if character.GUID ~= UnitGUID("player") then
            characterButton:CreateButton("Remove character", function()
              local characterName = character.name
              if character.realmName then
                characterName = format("%s - %s", character.name, character.realmName)
              end
              StaticPopup_Show("WEEKLYKNOWLEDGE_DELETE_CHARACTER", characterName, nil, character)
            end)
          end
            end)
          end,
        },
        {
          name = "Expansion",
          icon = mediaPath .. "Icon_House.blp",
          iconSize = 14,
          tooltipTitle = "Expansion",
          tooltipDescription = "Filter rows by selected expansions.",
          setupMenu = function(_, rootMenu)
            TableForEach(Data:GetExpansions(), function(expansion)
          rootMenu:CreateCheckbox(
            expansion.name,
            function() return TableContains(Data.db.global.main.selectedExpansions, expansion.id) end,
            function()
              Data.db.global.main.selectedExpansions = TableToggle(Data.db.global.main.selectedExpansions, expansion.id)
              self:Render()
            end,
            expansion.id
          )
            end)
          end,
        },
        {
          name = "Columns",
          icon = mediaPath .. "Icon_Columns.blp",
          tooltipTitle = "Columns",
          tooltipDescription = "Enable/Disable table columns.",
          setupMenu = function(_, rootMenu)
        local hidden = Data.db.global.main.hiddenColumns
        TableForEach(self:GetTableColumns(true), function(column)
          if not column.hideable then return end
          rootMenu:CreateCheckbox(
            column.headerText,
            function() return not hidden[column.id] end,
            function(id)
              hidden[id] = not hidden[id]
              self:Render()
            end,
            column.id
          )
            end)
          end,
        },
        {
          name = "Checklist",
          icon = mediaPath .. "Icon_Checklist.blp",
          iconSize = 16,
          tooltipTitle = "Checklist",
          tooltipDescription = "Toggle the Checklist window",
          onClick = function()
            Checklist:ToggleWindow()
            self:Render()
          end,
        },
      },
    })
    self.window:SetFrameLevel(8000)
    self.window.placeholderText = addon.LiqUI.Window:GetBodyPlaceholderText(self.window.body)
    self.window.placeholderText:SetFontObject("SystemFont_Med1")
    self.window.placeholderText:Hide()

    self.window.table = addon.LiqUI.Table:New({
      name = "Main",
      header = {
        enabled = true,
        sticky = true,
        height = Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = Constants.TABLE_ROW_HEIGHT,
        highlight = true,
        striped = true
      },
      cells = {
        padding = Constants.TABLE_CELL_PADDING,
        fontObject = "GameFontHighlightSmall",
      },
      sorting = {
        enabled = true,
        defaultOrder = "desc",
        defaultCompare = function(a, b)
          local rowDataA, rowDataB = a.data, b.data
          if not rowDataA or not rowDataB then return false end
          local characterA, characterB = rowDataA.character, rowDataB.character
          local lastUpdateA, lastUpdateB = characterA.lastUpdate, characterB.lastUpdate
          if type(lastUpdateA) == "number" and type(lastUpdateB) == "number" then
            if lastUpdateA ~= lastUpdateB then
              return lastUpdateA > lastUpdateB
            end
          elseif type(lastUpdateA) == "number" then
            return true
          elseif type(lastUpdateB) == "number" then
            return false
          end
          local identityCompare = Helpers:CompareCharacterNameRealm(characterA, characterB)
          if identityCompare ~= 0 then return identityCompare < 0 end
          return (rowDataA.skillLineVariantID or 0) < (rowDataB.skillLineVariantID or 0)
        end,
      },
    })
    self.window.table:SetParent(self.window.body)
    self.window.table:SetPoint("TOPLEFT", self.window.body, "TOPLEFT", 0, 0)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window.body, "BOTTOMRIGHT", 0, 0)
  end

  -- Quick hotfix to avoid excessive rendering
  if not self.window:IsVisible() then
    return
  end

  for _, column in ipairs(columns) do
    tableWidth = tableWidth + column.width
  end
  if self.window.table.config.header.enabled then
    tableHeight = tableHeight + self.window.table.config.header.height
  end

  local rowCount = 0
  do -- Table data rows
    TableForEach(characters, function(character)
      local professions = TableFilter(character.professions or {}, function(characterProfession)
        local skillLineVariant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
        if not skillLineVariant then return false end
        if TableCount(selectedExpansions) > 0 and not TableContains(selectedExpansions, skillLineVariant.expansionID) then return false end
        if not characterProfession.enabled then return false end
        if Data.db.global.main.hideLowLevelProfessions and (characterProfession.skillLevel and characterProfession.skillLevel > 0 and characterProfession.skillLevel < 25) then return false end
        return true
      end)

      TableForEach(professions, function(characterProfession)
        ---@type WK_TableRow
        local row = {
          data = {
            character = character,
            characterProfession = characterProfession,
            skillLineVariantID = characterProfession.skillLineVariantID,
          },
        }
        table.insert(dataRows, row)
        tableHeight = tableHeight + self.window.table.config.rows.height
        rowCount = rowCount + 1
      end)
    end)
  end

  local tableData = addon.LiqUI.Table.BuildData(columns, dataRows)

  local minWindowWidth = 500
  local windowHeight = math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT) + 2
  local windowWidth = math.max(tableWidth, minWindowWidth)

  if rowCount == 0 then
    windowHeight = 250
    windowWidth = minWindowWidth
    self.window.placeholderText:SetText("It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or character above?\n\nIf this is your first time using this addon then make sure to open your professions at least once.")
    self.window.placeholderText:Show()
    self.window.table:Hide()
    self.window:SetBodySize(minWindowWidth, windowHeight - Constants.TITLEBAR_HEIGHT)
  else
    self.window.placeholderText:Hide()
    self.window.table:Show()
    self.window:SetBodySize(windowWidth, windowHeight - Constants.TITLEBAR_HEIGHT)
  end

  if self.window.titlebar then
    self.window.titlebar.title:SetShown(windowWidth > minWindowWidth)
  end
  if self.window.border then
    self.window.border:SetShown(self.window.db.border ~= false)
  end
  self.window.table:SetData(tableData)
  self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
  self.window:SetScale((self.window.db.scale or 100) / 100)
end

---Get columns for the table
---@param unfiltered boolean? Show all columns, even if they are hidden
---@return WK_TableColumn[]
function Main:GetTableColumns(unfiltered)
  local hidden = Data.db.global.main.hiddenColumns
  local objectiveCategories = Data:GetObjectiveCategories()
  local currentCharacter = Data:GetCharacter()

  --- Estimated concentration (same idea as the cell); used only for sort order.
  ---@param data WK_TableRowData
  ---@return number
  local function concentrationEstimatedForSort(data)
    local character = data.character
    local characterProfession = data.characterProfession
    local skillLineVariant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
    if not skillLineVariant or not skillLineVariant.concentrationCurrencyID or skillLineVariant.concentrationCurrencyID == 0 then
      return -1
    end
    local currencyInfo = Data:GetCharacterCurrency(character, skillLineVariant.concentrationCurrencyID)
    if not currencyInfo then
      return -1
    end
    local currentQuantity = currencyInfo.quantity
    local maxQuantity = currencyInfo.maxQuantity
    local timeDifference = GetServerTime() - currencyInfo.lastUpdated
    local cyclesSinceLastUpdate = timeDifference / (currencyInfo.rechargingCycleDurationMS / 1000)
    return math.min(currentQuantity + cyclesSinceLastUpdate, maxQuantity)
  end

  ---@type WK_TableColumn[]
  local columns = {
    {
      id = "name",
      headerText = "Name",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Name", 1, 1, 1);
        GameTooltip:AddLine("Your characters.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      hideable = true,
      render = function(data)
        local character = data.character
        local name = character.name
        if character.classID then
          local _, classFile = GetClassInfo(character.classID)
          if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
              name = color:WrapTextInColorCode(name)
            end
          end
        end
        return {text = name}
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "realm",
      headerText = "Realm",
      name = "Realm",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Realm", 1, 1, 1);
        GameTooltip:AddLine("Realm names.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      hideable = true,
      render = function(data)
        local character = data.character
        return {text = character.realmName}
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          return strcmputf8i(a.data.character.realmName or "", b.data.character.realmName or "") < 0
        end,
      },
    },
    {
      id = "profession",
      headerText = "Profession",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Profession", 1, 1, 1);
        GameTooltip:AddLine("Your professions.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = Data.db.global.showFullProfessionName and 160 or 100,
      hideable = true,
      render = function(data)
        local character = data.character
        local skillLineVariantID = data.skillLineVariantID
        local text = ""
        local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
        if not variant then return {text = ""} end
        local skillLine = Data:GetSkillLineByID(variant and variant.skillLineID or 0)
        if not skillLine then return {text = ""} end
        text = skillLine.name
        if Data.db.global.showFullProfessionName then
          text = variant.name
        end
        return {
          text = text,
          onEnter = function(cellFrame)
            if character == currentCharacter then
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText(text, 1, 1, 1);
              GameTooltip:AddLine(format("<Click to open profession>"), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:Show()
            end
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if character == currentCharacter then
              C_TradeSkillUI.OpenTradeSkill(skillLine.id)
            end
          end,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function skillLineNameLower(rowData)
            local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
            local skillLine = variant and Data:GetSkillLineByID(variant.skillLineID or 0)
            return skillLine and skillLine.name:lower() or ""
          end
          local nameA, nameB = skillLineNameLower(a.data), skillLineNameLower(b.data)
          if nameA ~= nameB then return nameA < nameB end
          return a.data.skillLineVariantID < b.data.skillLineVariantID
        end,
      },
    },
    {
      id = "expansion",
      headerText = "Expansion",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Expansion", 1, 1, 1);
        GameTooltip:AddLine("Expansion for this profession row.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 120,
      hideable = true,
      render = function(data)
        local skillLineVariantID = data.skillLineVariantID
        local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
        if not variant then return {text = ""} end
        local expansion = variant and Data:GetExpansionByID(variant.expansionID)
        if not expansion then return {text = ""} end
        return {text = expansion.name}
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function expansionNameLower(rowData)
            local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
            local expansion = variant and Data:GetExpansionByID(variant.expansionID)
            return expansion and expansion.name:lower() or ""
          end
          local nameA, nameB = expansionNameLower(a.data), expansionNameLower(b.data)
          if nameA ~= nameB then return nameA < nameB end
          return a.data.skillLineVariantID < b.data.skillLineVariantID
        end,
      },
    },
    {
      id = "skill",
      headerText = "Skill",
      name = "Skill",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Skill", 1, 1, 1);
        GameTooltip:AddLine("Current skill levels.\n\nNote: This is only updated when you open the profession window or craft a recipe.", nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 80,
      align = "CENTER",
      hideable = true,
      render = function(data)
        local characterProfession = data.characterProfession
        local text = "-"
        local color = WHITE_FONT_COLOR
        if not characterProfession.skillLevel or characterProfession.skillLevel == 0 then
          return {
            text = color:WrapTextInColorCode(text),
            onEnter = function(cellFrame)
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText("No data", 1, 1, 1);
              GameTooltip:AddLine("Log in on this character and open the profession window one time to fetch skill level data.", nil, nil, nil, true);
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
          }
        end
        if characterProfession.skillLevel > 0 and characterProfession.skillLevel == characterProfession.skillMaxLevel then
          color = GREEN_FONT_COLOR
        end
        text = color:WrapTextInColorCode(format("%d / %d", characterProfession.skillLevel, characterProfession.skillMaxLevel))
        return {text = text}
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local skillLevelA = a.data.characterProfession.skillLevel
          local skillLevelB = b.data.characterProfession.skillLevel
          local sortKeyA = (skillLevelA and skillLevelA > 0) and skillLevelA or -1
          local sortKeyB = (skillLevelB and skillLevelB > 0) and skillLevelB or -1
          if sortKeyA ~= sortKeyB then return sortKeyA < sortKeyB end
          return a.data.skillLineVariantID < b.data.skillLineVariantID
        end,
      },
    },
    {
      id = "concentration",
      headerText = "Concentration",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Concentration", 1, 1, 1);
        GameTooltip:AddLine("Current concentration.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      hideable = true,
      render = function(data)
        local character = data.character
        local characterProfession = data.characterProfession
        local skillLineVariant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
        if not skillLineVariant then return {text = ""} end
        if not skillLineVariant.concentrationCurrencyID or skillLineVariant.concentrationCurrencyID == 0 then return {text = ""} end
        local currencyInfo = Data:GetCharacterCurrency(character, skillLineVariant.concentrationCurrencyID)
        if not currencyInfo then
          return {
            text = "-",
            onEnter = function(cellFrame)
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText("No data", 1, 1, 1);
              GameTooltip:AddLine("Log in on this character to fetch concentration data.", nil, nil, nil, true);
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
          }
        end

        local currentQuantity = currencyInfo.quantity
        local maxQuantity = currencyInfo.maxQuantity
        local timeDifference = GetServerTime() - currencyInfo.lastUpdated
        local cyclesSinceLastUpdate = timeDifference / (currencyInfo.rechargingCycleDurationMS / 1000)
        local estimatedQuantity = math.min(currentQuantity + cyclesSinceLastUpdate, maxQuantity)
        local quantityToMax = math.max(0, maxQuantity - estimatedQuantity)
        local timeToMax = quantityToMax * (currencyInfo.rechargingCycleDurationMS / 1000)
        local color = WHITE_FONT_COLOR

        if estimatedQuantity >= currencyInfo.maxQuantity then
          color = GREEN_FONT_COLOR
        end
        if estimatedQuantity == 0 then
          color = RED_FONT_COLOR
        end

        local text = maxQuantity > 0 and color:WrapTextInColorCode(format("%d / %d", estimatedQuantity, maxQuantity)) or ""

        return {
          text = text,
          color = color,
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(currencyInfo.name, 1, 1, 1);
            if timeToMax > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Estimated", 1, 1, 1, true)
              GameTooltip:AddDoubleLine("Concentration:", format("%d / %d", estimatedQuantity, currencyInfo.maxQuantity), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine("Time to max:", SecondsToTime(timeToMax), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine("Maxed at:", tostring(date("%c", currencyInfo.lastUpdated + timeToMax)), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Last Saved", 1, 1, 1, true)
            end
            GameTooltip:AddDoubleLine("Concentration:", format("%d / %d", currencyInfo.quantity, currencyInfo.maxQuantity), nil, nil, nil, 1, 1, 1)
            GameTooltip:AddDoubleLine("Saved at:", tostring(date("%c", currencyInfo.lastUpdated)), nil, nil, nil, 1, 1, 1)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local estimatedA = concentrationEstimatedForSort(a.data)
          local estimatedB = concentrationEstimatedForSort(b.data)
          if estimatedA ~= estimatedB then return estimatedA < estimatedB end
          return a.data.skillLineVariantID < b.data.skillLineVariantID
        end,
      },
    },
    {
      id = "knowledge",
      headerText = "Knowledge",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Knowledge Points", 1, 1, 1);
        GameTooltip:AddLine("Current knowledge gained.")
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 100,
      align = "CENTER",
      hideable = true,
      render = function(data)
        local characterProfession = data.characterProfession
        local skillLineVariantID = data.skillLineVariantID
        local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
        local text = ""

        if characterProfession.knowledgeLevel then
          text = format("%d", characterProfession.knowledgeLevel)
          if characterProfession.knowledgeUnspent and characterProfession.knowledgeUnspent > 0 then
            text = format(
              "%d %s",
              characterProfession.knowledgeLevel,
              LIGHTBLUE_FONT_COLOR:WrapTextInColorCode(format("(%d)", characterProfession.knowledgeUnspent))
            )
          end
        end
        if characterProfession.knowledgeMaxLevel then
          text = format("%s / %d", text, characterProfession.knowledgeMaxLevel)
        end
        if characterProfession.knowledgeMaxLevel > 0 and characterProfession.knowledgeLevel == characterProfession.knowledgeMaxLevel then
          text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
        end

        return {
          text = text,
          onEnter = function(cellFrame)
            local pointsSpentColor = LIGHTGRAY_FONT_COLOR
            local pointsSpentValue = "?"
            local pointsUnspentColor = LIGHTGRAY_FONT_COLOR
            local pointsUnspentValue = "?"
            local pointsMaxColor = LIGHTGRAY_FONT_COLOR
            local pointsMaxValue = "?"

            if characterProfession.knowledgeLevel then
              pointsSpentColor = WHITE_FONT_COLOR
              pointsSpentValue = tostring(characterProfession.knowledgeLevel)
            end

            if characterProfession.knowledgeUnspent then
              pointsUnspentColor = WHITE_FONT_COLOR
              if characterProfession.knowledgeUnspent > 0 then
                pointsUnspentColor = LIGHTBLUE_FONT_COLOR
              end
              pointsUnspentValue = tostring(characterProfession.knowledgeUnspent)
            end

            if characterProfession.knowledgeMaxLevel then
              pointsMaxColor = WHITE_FONT_COLOR
              pointsMaxValue = tostring(characterProfession.knowledgeMaxLevel)
            end

            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(skillLineVariant and skillLineVariant.name or "", 1, 1, 1)
            GameTooltip:AddDoubleLine("Points Spent:", pointsSpentValue, nil, nil, nil, pointsSpentColor.r, pointsSpentColor.g, pointsSpentColor.b)
            GameTooltip:AddDoubleLine("Points Unspent:", pointsUnspentValue, nil, nil, nil, pointsUnspentColor.r, pointsUnspentColor.g, pointsUnspentColor.b)
            GameTooltip:AddDoubleLine("Max:", pointsMaxValue, nil, nil, nil, pointsMaxColor.r, pointsMaxColor.g, pointsMaxColor.b)

            if characterProfession.specializations and TableCount(characterProfession.specializations) > 0 then
              GameTooltip:AddLine(" ")
              GameTooltip:AddLine("Specializations:")
              TableForEach(characterProfession.specializations, function(characterProfessionSpecialization)
                local name = characterProfessionSpecialization.name
                if strlenutf8(name) > 20 then
                  name = format("%s...", strsub(name, 1, 20))
                end
                local value = format("%d / %d", characterProfessionSpecialization.knowledgeLevel or 0, characterProfessionSpecialization.knowledgeMaxLevel or 0)
                if characterProfessionSpecialization.rootIconID then
                  name = format("|T%d:12|t %s", characterProfessionSpecialization.rootIconID, name)
                end
                if characterProfessionSpecialization.state and characterProfessionSpecialization.state == Enum.ProfessionsSpecTabState.Locked then
                  value = LIGHTGRAY_FONT_COLOR:WrapTextInColorCode("Locked")
                end
                if characterProfessionSpecialization.state and characterProfessionSpecialization.state == Enum.ProfessionsSpecTabState.Unlockable then
                  value = DIM_GREEN_FONT_COLOR:WrapTextInColorCode("Can Unlock")
                end
                GameTooltip:AddDoubleLine(name, value, 1, 1, 1, 1, 1, 1)
              end)
            end

            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function totalKnowledgePoints(rowData)
            if not rowData.characterProfession then return 0 end
            return (rowData.characterProfession.knowledgeLevel or 0) + (rowData.characterProfession.knowledgeUnspent or 0)
          end
          local totalA, totalB = totalKnowledgePoints(a.data), totalKnowledgePoints(b.data)
          if totalA ~= totalB then return totalA < totalB end
          return a.data.skillLineVariantID < b.data.skillLineVariantID
        end,
      },
    },
  }

  -- Category Progress
  TableForEach(objectiveCategories, function(objectiveCategory)
    -- Skip Darkmoon objectives if the Darkmoon Faire is not open
    if objectiveCategory.id == Enum.WK_ObjectiveCategory.DarkmoonQuest and not Data.cache.isDarkmoonOpen then
      return
    end

    local dataColumn = {
      id = format("category_%s", tostring(objectiveCategory.id)),
      headerText = objectiveCategory.name,
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(objectiveCategory.name, 1, 1, 1);
        GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      hideable = true,
      align = "CENTER",
      sorting = {
        enabled = true,
        compare = function(a, b)
          local progressA = Data:GetCategoryProfessionProgress(a.data.character, objectiveCategory, a.data.characterProfession)
          local progressB = Data:GetCategoryProfessionProgress(b.data.character, objectiveCategory, b.data.characterProfession)
          if not progressA and not progressB then return false end
          if not progressA then return true end
          if not progressB then return false end
          if objectiveCategory.id == Enum.WK_ObjectiveCategory.CatchUp then
            local pointsEarnedA = progressA.pointsEarned or 0
            local pointsEarnedB = progressB.pointsEarned or 0
            if pointsEarnedA ~= pointsEarnedB then return pointsEarnedA < pointsEarnedB end
          else
            local objectivesCompletedA = progressA.objectivesCompleted or 0
            local objectivesCompletedB = progressB.objectivesCompleted or 0
            if objectivesCompletedA ~= objectivesCompletedB then return objectivesCompletedA < objectivesCompletedB end
          end
          return a.data.skillLineVariantID < b.data.skillLineVariantID
        end,
      },
      render = function(data)
        local character = data.character
        local characterProfession = data.characterProfession
        local skillLineVariantID = data.skillLineVariantID
        local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
        local categoryProfessionProgress = Data:GetCategoryProfessionProgress(character, objectiveCategory, characterProfession)
        if not categoryProfessionProgress then
          return {text = "Error"}
        end

        local text = format("%d / %d", categoryProfessionProgress.objectivesCompleted, categoryProfessionProgress.objectivesTotal)

        if objectiveCategory.id == Enum.WK_ObjectiveCategory.CatchUp then
          text = format("%d / %d", categoryProfessionProgress.pointsEarned, categoryProfessionProgress.pointsTotal)
          -- if categoryProfessionProgress.objectivesTotal == 0 then
          --   text = "-"
          -- end
        elseif categoryProfessionProgress.objectivesTotal == 0 then
          return {text = ""}
        end

        if categoryProfessionProgress.pointsEarned > 0 and categoryProfessionProgress.pointsEarned >= categoryProfessionProgress.pointsTotal then
          text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
        end

        return {
          text = text,
          onEnter = function(cellFrame)
            local showTooltip = function()
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText(objectiveCategory.name, 1, 1, 1)

              local requirementsHeading = "Requirements:"

              if objectiveCategory.id == Enum.WK_ObjectiveCategory.CatchUp then
                GameTooltip:AddDoubleLine("Points Earned:", format("%d", categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Points Available:", format("%d", categoryProfessionProgress.pointsTotal - categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Max Points:", format("%d", categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
                requirementsHeading = "Unlock Catch-Up This Week:"
              elseif objectiveCategory.id == Enum.WK_ObjectiveCategory.FirstCraft then
                GameTooltip:AddDoubleLine("Completed:", format("%d", categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Remaining:", format("%d", categoryProfessionProgress.pointsTotal - categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Max:", format("%d", categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
              elseif objectiveCategory.id == Enum.WK_ObjectiveCategory.DarkmoonQuest then
                GameTooltip:AddDoubleLine("Quests:", format("%d / %d", categoryProfessionProgress.objectivesCompleted, categoryProfessionProgress.objectivesTotal), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", categoryProfessionProgress.pointsEarned, categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
              else
                GameTooltip:AddDoubleLine("Items:", format("%d / %d", categoryProfessionProgress.objectivesCompleted, categoryProfessionProgress.objectivesTotal), nil, nil, nil, 1, 1, 1)
                GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", categoryProfessionProgress.pointsEarned, categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
              end

              -- Requirements
              if objectiveCategory.id == Enum.WK_ObjectiveCategory.CatchUp or objectiveCategory.id == Enum.WK_ObjectiveCategory.DarkmoonQuest then
                if TableCount(categoryProfessionProgress.requirements) > 0 then
                  GameTooltip:AddLine(" ")
                  GameTooltip:AddLine(requirementsHeading)
                  TableForEach(categoryProfessionProgress.requirements, function(requirement)
                    Helpers:RenderRequirementTooltip(requirement, character, skillLineVariantID, objectiveCategory.id)
                  end)
                end
              end

              -- Item Rewards
              if TableCount(categoryProfessionProgress.items) > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("Rewards:")
                TableForEach(categoryProfessionProgress.items, function(isLooted, itemID)
                  local item = Data.cache.items[itemID]
                  local itemCached = item and item:IsItemDataCached()
                  local icon = itemCached and item:GetItemIcon() or 134400
                  local name = itemCached and item:GetItemLink() or "Loading..."
                  if objectiveCategory.id == Enum.WK_ObjectiveCategory.CatchUp then
                    GameTooltip:AddLine(format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name), 1, 1, 1, true)
                  else
                    GameTooltip:AddDoubleLine(
                      format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name),
                      CreateAtlasMarkup(isLooted and "common-icon-checkmark" or "common-icon-redx", 12, 12),
                      1, 1, 1, 1, 1, 1
                    )
                  end
                end)
              end

              GameTooltip:Show()
            end

            -- Continue on item load
            if TableCount(categoryProfessionProgress.items) > 0 then
              TableForEach(categoryProfessionProgress.items, function(isLooted, itemID)
                Data.cache.items[itemID] = Item:CreateFromItemID(itemID)
                Data.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
              end)
            end

            -- Continue on item requirement load
            if TableCount(categoryProfessionProgress.requirements) > 0 then
              TableForEach(categoryProfessionProgress.requirements, function(requirement)
                if requirement.requirement.type == "item" then
                  Data.cache.items[requirement.requirement.id] = Item:CreateFromItemID(requirement.requirement.id)
                  Data.cache.items[requirement.requirement.id]:ContinueOnItemLoad(showTooltip)
                end
              end)
            end

            showTooltip()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end
    }
    table.insert(columns, dataColumn)
  end)

  if unfiltered then
    return columns
  end

  local filteredColumns = TableFilter(columns, function(column)
    return not hidden[column.id]
  end)

  return filteredColumns
end
