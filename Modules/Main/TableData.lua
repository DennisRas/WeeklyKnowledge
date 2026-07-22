---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants

---@class WK_Main_TableData
local TableData = {}
addon.Main.TableData = TableData

local Data = addon.Data
local Helpers = addon.Helpers
local TableCount = addon.libs.LiqUI.Utils.TableCount
local TableForEach = addon.libs.LiqUI.Utils.TableForEach

--- Estimated concentration (same idea as the cell); used only for sort order.
---@param row LiqUI_TableDataRowExtended
---@return number
function TableData.ConcentrationEstimatedForSort(row)
  local character = row.character
  local characterProfession = row.characterProfession
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

---@param character WK_Character
---@return LiqUI_TableDataCellExtended
local function buildNameCell(character)
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
  if character == Data:GetCharacter() then
    name = format("%s %s", name, Constants.currentCharacterNameMarker)
  end
  ---@type LiqUI_TableDataCellExtended
  return { data = name }
end

---@param character WK_Character
---@return LiqUI_TableDataCellExtended
local function buildRealmCell(character)
  ---@type LiqUI_TableDataCellExtended
  return { data = character.realmName }
end

---@param character WK_Character
---@param skillLineVariantID integer
---@return LiqUI_TableDataCellExtended
local function buildProfessionCell(character, skillLineVariantID)
  local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
  if not variant then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  local skillLine = Data:GetSkillLineByID(variant.skillLineID or 0)
  if not skillLine then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  local text = skillLine.name
  if Data.db.global.showFullProfessionName then
    text = variant.name
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      if character == Data:GetCharacter() then
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(text, 1, 1, 1);
        GameTooltip:AddLine(format("<Click to open profession>"), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:Show()
      end
    end,
    onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:Hide()
    end,
    onClick = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData, button)
      if character == Data:GetCharacter() then
        C_TradeSkillUI.OpenTradeSkill(skillLine.id)
      end
    end,
  }
end

---@param skillLineVariantID integer
---@return LiqUI_TableDataCellExtended
local function buildExpansionCell(skillLineVariantID)
  local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
  if not variant then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  local expansion = Data:GetExpansionByID(variant.expansionID)
  if not expansion then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  ---@type LiqUI_TableDataCellExtended
  return { data = expansion.name }
end

---@param characterProfession WK_CharacterProfession
---@return LiqUI_TableDataCellExtended
local function buildSkillCell(characterProfession)
  local text = "-"
  local color = WHITE_FONT_COLOR
  if not characterProfession.skillLevel or characterProfession.skillLevel == 0 then
    ---@type LiqUI_TableDataCellExtended
    return {
      data = color:WrapTextInColorCode(text),
      onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("No data", 1, 1, 1);
        GameTooltip:AddLine("Log in on this character and open the profession window one time to fetch skill level data.", nil, nil, nil, true);
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        GameTooltip:Hide()
      end,
    }
  end
  if characterProfession.skillLevel > 0 and characterProfession.skillLevel == characterProfession.skillMaxLevel then
    color = GREEN_FONT_COLOR
  end
  text = color:WrapTextInColorCode(format("%d / %d", characterProfession.skillLevel, characterProfession.skillMaxLevel))
  ---@type LiqUI_TableDataCellExtended
  return { data = text }
end

---@param character WK_Character
---@param characterProfession WK_CharacterProfession
---@return LiqUI_TableDataCellExtended
local function buildConcentrationCell(character, characterProfession)
  local skillLineVariant = Data:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
  if not skillLineVariant then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  if not skillLineVariant.concentrationCurrencyID or skillLineVariant.concentrationCurrencyID == 0 then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  local currencyInfo = Data:GetCharacterCurrency(character, skillLineVariant.concentrationCurrencyID)
  if not currencyInfo then
    ---@type LiqUI_TableDataCellExtended
    return {
      data = "-",
      onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("No data", 1, 1, 1);
        GameTooltip:AddLine("Log in on this character to fetch concentration data.", nil, nil, nil, true);
        GameTooltip:Show()
      end,
      onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
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

  local displayText = maxQuantity > 0 and color:WrapTextInColorCode(format("%d / %d", estimatedQuantity, maxQuantity)) or ""

  ---@type LiqUI_TableDataCellExtended
  return {
    data = displayText,
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
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
    onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:Hide()
    end,
  }
end

---@param characterProfession WK_CharacterProfession
---@param skillLineVariantID integer
---@return LiqUI_TableDataCellExtended
local function buildKnowledgeCell(characterProfession, skillLineVariantID)
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

  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
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
    onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:Hide()
    end,
  }
end

---@param character WK_Character
---@param characterProfession WK_CharacterProfession
---@param skillLineVariantID integer
---@param objectiveCategory WK_ObjectiveCategory
---@return LiqUI_TableDataCellExtended
local function buildCategoryCell(character, characterProfession, skillLineVariantID, objectiveCategory)
  local categoryProfessionProgress = Data:GetCategoryProfessionProgress(character, objectiveCategory, characterProfession)
  if not categoryProfessionProgress then
    ---@type LiqUI_TableDataCellExtended
    return { data = "Error" }
  end

  local text = format("%d / %d", categoryProfessionProgress.objectivesCompleted, categoryProfessionProgress.objectivesTotal)

  if objectiveCategory.id == Constants.objectiveCategory.CatchUp then
    text = format("%d / %d", categoryProfessionProgress.pointsEarned, categoryProfessionProgress.pointsTotal)
  elseif categoryProfessionProgress.objectivesTotal == 0 then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end

  if categoryProfessionProgress.pointsEarned > 0 and categoryProfessionProgress.pointsEarned >= categoryProfessionProgress.pointsTotal then
    text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
  end

  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      if not categoryProfessionProgress then
        return
      end
      local showTooltip = function()
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(objectiveCategory.name, 1, 1, 1)

        local requirementsHeading = "Requirements:"

        if objectiveCategory.id == Constants.objectiveCategory.CatchUp then
          GameTooltip:AddDoubleLine("Points Earned:", format("%d", categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
          GameTooltip:AddDoubleLine("Points Available:", format("%d", categoryProfessionProgress.pointsTotal - categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
          GameTooltip:AddDoubleLine("Max Points:", format("%d", categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
          requirementsHeading = "Unlock Catch-Up This Week:"
        elseif objectiveCategory.id == Constants.objectiveCategory.FirstCraft then
          GameTooltip:AddDoubleLine("Completed:", format("%d", categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
          GameTooltip:AddDoubleLine("Remaining:", format("%d", categoryProfessionProgress.pointsTotal - categoryProfessionProgress.pointsEarned), nil, nil, nil, 1, 1, 1)
          GameTooltip:AddDoubleLine("Max:", format("%d", categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
        elseif objectiveCategory.id == Constants.objectiveCategory.DarkmoonQuest then
          GameTooltip:AddDoubleLine("Quests:", format("%d / %d", categoryProfessionProgress.objectivesCompleted, categoryProfessionProgress.objectivesTotal), nil, nil, nil, 1, 1, 1)
          GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", categoryProfessionProgress.pointsEarned, categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
        else
          GameTooltip:AddDoubleLine("Items:", format("%d / %d", categoryProfessionProgress.objectivesCompleted, categoryProfessionProgress.objectivesTotal), nil, nil, nil, 1, 1, 1)
          GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", categoryProfessionProgress.pointsEarned, categoryProfessionProgress.pointsTotal), nil, nil, nil, 1, 1, 1)
        end

        if objectiveCategory.id == Constants.objectiveCategory.CatchUp or objectiveCategory.id == Constants.objectiveCategory.DarkmoonQuest then
          if TableCount(categoryProfessionProgress.requirements) > 0 then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(requirementsHeading)
            TableForEach(categoryProfessionProgress.requirements, function(requirement)
              Helpers:RenderRequirementTooltip(requirement, character, skillLineVariantID, objectiveCategory.id)
            end)
          end
        end

        if TableCount(categoryProfessionProgress.items) > 0 then
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine("Rewards:")
          TableForEach(categoryProfessionProgress.items, function(isLooted, itemID)
            local item = Data.cache.items[itemID]
            local itemCached = item and item:IsItemDataCached()
            local icon = itemCached and item:GetItemIcon() or 134400
            local name = itemCached and item:GetItemLink() or "Loading..."
            if objectiveCategory.id == Constants.objectiveCategory.CatchUp then
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

      if TableCount(categoryProfessionProgress.items) > 0 then
        TableForEach(categoryProfessionProgress.items, function(isLooted, itemID)
          Data.cache.items[itemID] = Item:CreateFromItemID(itemID)
          Data.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
        end)
      end

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
    onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:Hide()
    end,
  }
end

---@param character WK_Character
---@param characterProfession WK_CharacterProfession
---@return WK_TableRowData
function TableData.BuildRow(character, characterProfession)
  local skillLineVariantID = characterProfession.skillLineVariantID

  ---@type LiqUI_TableDataCellExtended[]
  local cells = {
    buildNameCell(character),
    buildRealmCell(character),
    buildProfessionCell(character, skillLineVariantID),
    buildExpansionCell(skillLineVariantID),
    buildSkillCell(characterProfession),
    buildConcentrationCell(character, characterProfession),
    buildKnowledgeCell(characterProfession, skillLineVariantID),
  }

  local objectiveCategories = Data:GetObjectiveCategories()
  TableForEach(objectiveCategories, function(objectiveCategory)
    if objectiveCategory.id == Constants.objectiveCategory.DarkmoonQuest and not Data.cache.isDarkmoonOpen then
      return
    end
    table.insert(cells, buildCategoryCell(character, characterProfession, skillLineVariantID, objectiveCategory))
  end)

  ---@type WK_TableRowData
  return {
    data = cells,
    character = character,
    characterProfession = characterProfession,
    skillLineVariantID = skillLineVariantID,
  }
end
