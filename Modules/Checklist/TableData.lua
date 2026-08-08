---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants

---@class WK_Checklist_TableData
local TableData = {}
addon.Checklist.TableData = TableData

local Data = addon.Data
local Helpers = addon.Helpers
local TableCount = addon.libs.LiqUI.Utils.TableCount
local TableForEach = addon.libs.LiqUI.Utils.TableForEach

---@param objective WK_Objective
---@return LiqUI_TableDataCellExtended
local function buildObjectiveCell(objective)
  if objective.itemID and objective.itemID > 0 then
    local text = format("Error: ItemID %d not found", objective.itemID or "?")
    local link = ""
    local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(objective.itemID)
    if itemName then
      text = itemName
    end
    if itemLink then
      link = itemLink
    end
    if itemTexture then
      text = format("|T%s:0|t %s", itemTexture, itemLink or text or "[Not Loaded]")
    end

    ---@type LiqUI_TableDataCellExtended
    return {
      data = text,
      onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        if link and strlen(link) > 0 then
          GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
          GameTooltip:SetHyperlink(link)
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          GameTooltip:Show()
        end
      end,
      onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        GameTooltip:Hide()
      end,
      onClick = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData, button)
        if link and strlen(link) > 0 then
          if IsModifiedClick("CHATLINK") then
            if not ChatEdit_InsertLink(link) then
              ChatFrame_OpenChat(link);
            end
          end
        end
      end,
    }
  end

  if objective.categoryID == Constants.objectiveCategory.FirstCraft then
    local text = format("Error: RecipeID %d not found", objective.spellID or "?")
    local link = ""
    local recipeInfo = Data.cache.tradeSkillRecipes and Data.cache.tradeSkillRecipes[objective.spellID]
    if not recipeInfo then
      recipeInfo = C_TradeSkillUI.GetRecipeInfo(objective.spellID)
      if recipeInfo then
        if not Data.cache.tradeSkillRecipes then
          Data.cache.tradeSkillRecipes = {}
        end
        Data.cache.tradeSkillRecipes[objective.spellID] = recipeInfo
      end
    end
    if recipeInfo then
      link = C_Spell.GetSpellLink(recipeInfo.recipeID or objective.spellID)
      text = format("|T%s:0|t %s", recipeInfo.icon, recipeInfo.name)
    end
    ---@type LiqUI_TableDataCellExtended
    return {
      data = text,
      onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        if link and strlen(link) > 0 then
          GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
          GameTooltip:SetHyperlink(link)
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine("<Click to open Recipe>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          GameTooltip:Show()
        end
      end,
      onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        GameTooltip:Hide()
      end,
      onClick = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData, button)
        if link and strlen(link) > 0 then
          if IsModifiedClick("CHATLINK") then
            if not ChatEdit_InsertLink(link) then
              ChatFrame_OpenChat(link);
            end
          else
            C_TradeSkillUI.OpenRecipe(objective.spellID)
          end
        end
      end,
    }
  end

  if objective.quests and TableCount(objective.quests) > 0 then
    local text = format("Error: QuestID %d not found", objective.quests[1] or "?")
    local link = format("quest:%d:-1", objective.quests[1])
    local questTooltipData = C_TooltipInfo.GetHyperlink(link)
    if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
      text = WrapTextInColorCode(format("%s [%s]", CreateAtlasMarkup("questlog-questtypeicon-Recurring", 14, 14), questTooltipData.lines[1].leftText), "ffffff00")
    end
    ---@type LiqUI_TableDataCellExtended
    return {
      data = text,
      onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        if link and strlen(link) > 0 then
          GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
          GameTooltip:SetHyperlink(link)
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          GameTooltip:Show()
        end
      end,
      onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
        GameTooltip:Hide()
      end,
      onClick = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData, button)
        if link and strlen(link) > 0 then
          if IsModifiedClick("CHATLINK") then
            if not ChatEdit_InsertLink(link) then
              ChatFrame_OpenChat(link);
            end
          end
        end
      end,
    }
  end

  ---@type LiqUI_TableDataCellExtended
  return {
    data = "Unknown",
  }
end

---@param skillLineVariantID integer
---@return LiqUI_TableDataCellExtended
local function buildProfessionCell(skillLineVariantID)
  local text = ""
  local variant = Data:GetSkillLineVariantByID(skillLineVariantID)
  if not variant then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  local skillLine = Data:GetSkillLineByID(variant and variant.skillLineID or 0)
  if not skillLine then
    ---@type LiqUI_TableDataCellExtended
    return { data = "" }
  end
  text = Data:GetSkillLineDisplayName(skillLine)
  if Data.db.global.showFullProfessionName then
    text = Data:GetSkillLineVariantDisplayName(variant)
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
      GameTooltip:SetText(text, 1, 1, 1);
      GameTooltip:AddLine(format("<Click to open profession>"), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
      GameTooltip:Show()
    end,
    onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:Hide()
    end,
    onClick = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData, button)
      C_TradeSkillUI.OpenTradeSkill(skillLine.id)
    end,
  }
end

---@param skillLineVariantID integer
---@return LiqUI_TableDataCellExtended
local function buildExpansionCell(skillLineVariantID)
  local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
  local expansion = skillLineVariant and Data:GetExpansionByID(skillLineVariant.expansionID)
  ---@type LiqUI_TableDataCellExtended
  return {
    data = Data:GetExpansionDisplayName(expansion),
  }
end

---@param objective WK_Objective
---@return LiqUI_TableDataCellExtended
local function buildCategoryCell(objective)
  local objectiveCategory = Data:GetObjectiveCategoryByID(objective.categoryID)
  if not objectiveCategory then
    ---@type LiqUI_TableDataCellExtended
    return {
      data = "?",
    }
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = objectiveCategory.name,
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
      GameTooltip:SetText(objectiveCategory.name, 1, 1, 1);
      GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
      GameTooltip:Show()
    end,
    onLeave = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      GameTooltip:Hide()
    end,
  }
end

---@param objective WK_Objective
---@return LiqUI_TableDataCellExtended
local function buildLocationCell(objective)
  local text = " "
  if objective and objective.loc and objective.loc.m then
    if Data.cache.mapInfo[objective.loc.m] then
      text = Data.cache.mapInfo[objective.loc.m].name
    else
      local mapInfo = C_Map.GetMapInfo(objective.loc.m)
      if mapInfo then
        Data.cache.mapInfo[objective.loc.m] = mapInfo
        text = mapInfo.name
      end
    end
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
  }
end

---@param objective WK_Objective
---@return LiqUI_TableDataCellExtended
local function buildRepeatableCell(objective)
  if not objective then
    ---@type LiqUI_TableDataCellExtended
    return {
      data = " ",
    }
  end
  local objectiveCategory = Data:GetObjectiveCategoryByID(objective.categoryID)
  if not objectiveCategory then
    ---@type LiqUI_TableDataCellExtended
    return {
      data = " ",
    }
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = Data:GetRepeatableDisplayName(objectiveCategory.repeatable),
  }
end

---@param progress WK_ObjectiveProgress
---@return LiqUI_TableDataCellExtended
local function buildProgressCell(progress)
  local text = format("%d / %d", progress.questsCompleted, progress.questsTotal)
  if progress.isCompleted then
    text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
  }
end

---@param progress WK_ObjectiveProgress
---@return LiqUI_TableDataCellExtended
local function buildPointsCell(progress)
  local text = format("%d / %d", progress.pointsEarned, progress.pointsTotal)
  if progress.isCompleted then
    text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
  end
  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
  }
end

---@param character WK_Character
---@param objective WK_Objective
---@param progress WK_ObjectiveProgress
---@return LiqUI_TableDataCellExtended
local function buildWaypointCell(character, objective, progress)
  local TomTomGlobal = _G["TomTom"]
  local mapInfo = nil
  local mapPoint = nil

  if objective.loc and objective.loc.m then
    mapInfo = C_Map.GetMapInfo(objective.loc.m)
  end

  if mapInfo then
    mapPoint = UiMapPoint.CreateFromCoordinates(objective.loc.m, objective.loc.x / 100, objective.loc.y / 100)
  end

  ---@type LiqUI_TableDataCellExtended
  return {
    data = CreateAtlasMarkup("Waypoint-MapPin-Tracked", 20, 20, -4),
    onEnter = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData)
      local showTooltip = function()
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Do you know de wey?", 1, 1, 1)

        if objective.loc and objective.loc.hint then
          GameTooltip:AddLine(objective.loc.hint, nil, nil, nil, true)
        elseif objective.categoryID == Constants.objectiveCategory.FirstCraft then
          local objectiveCategory = Data:GetObjectiveCategoryByID(objective.categoryID)
          if objectiveCategory then
            GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
          end
        end

        if mapInfo then
          GameTooltip:AddLine(" ")
          GameTooltip:AddDoubleLine("Location:", mapInfo.name, nil, nil, nil, 1, 1, 1)
        end

        if objective.loc and objective.loc.x then
          if not mapInfo then
            GameTooltip:AddLine(" ")
          end
          GameTooltip:AddDoubleLine("Coordinates:", format("%.1f / %.1f", objective.loc.x, objective.loc.y), nil, nil, nil, 1, 1, 1)
        end

        local requirementsHeading = "Requirements:"
        if objective.categoryID == Constants.objectiveCategory.CatchUp then
          requirementsHeading = "Unlock Catch-Up This Week:"
        end

        if TableCount(progress.requirements) > 0 then
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine(requirementsHeading)
          TableForEach(progress.requirements, function(requirement)
            Helpers:RenderRequirementTooltip(requirement, character, objective.skillLineVariantID, objective.categoryID)
          end)
        end

        if TableCount(progress.items) > 0 then
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine("Rewards:")
          TableForEach(progress.items, function(isLooted, itemID)
            local item = Data.cache.items[itemID]
            local itemCached = item and item:IsItemDataCached()
            local icon = itemCached and item:GetItemIcon() or 134400
            local name = itemCached and item:GetItemLink() or "Loading..."
            if objective.categoryID == Constants.objectiveCategory.CatchUp then
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

        if mapPoint then
          if C_Map.CanSetUserWaypointOnMap(objective.loc.m) or TomTomGlobal then
            GameTooltip:AddLine(" ")
          end
          if C_Map.CanSetUserWaypointOnMap(objective.loc.m) then
            GameTooltip:AddLine("<Click to place a pin on the map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            GameTooltip:AddLine("<Shift click to share pin in chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          end
          if TomTomGlobal then
            GameTooltip:AddLine("<Alt click to place a TomTom waypoint>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          end
        end
        GameTooltip:Show()
      end

      if TableCount(progress.items) > 0 then
        TableForEach(progress.items, function(isLooted, itemID)
          Data.cache.items[itemID] = Item:CreateFromItemID(itemID)
          Data.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
        end)
      end

      if TableCount(progress.requirements) > 0 then
        TableForEach(progress.requirements, function(requirement)
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
    onClick = function(cellFrame, rowFrame, rowIndex, columnIndex, columnId, rowData, cellData, button)
      if mapPoint then
        if IsAltKeyDown() and TomTomGlobal then
          local text = "Objective"
          TomTomGlobal:AddWaypoint(objective.loc.m, objective.loc.x / 100, objective.loc.y / 100, {title = text, from = addon.name})
        elseif C_Map.CanSetUserWaypointOnMap(objective.loc.m) then
          if IsModifiedClick("CHATLINK") then
            local hyperlink = format("|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r", objective.loc.m, objective.loc.x * 100, objective.loc.y * 100, MAP_PIN_HYPERLINK)
            if not ChatEdit_InsertLink(hyperlink) then
              ChatFrame_OpenChat(hyperlink);
            end
          else
            C_Map.SetUserWaypoint(mapPoint)
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
          end
        end
      end
    end,
  }
end

---@param character WK_Character
---@param characterProfession WK_CharacterProfession
---@param objective WK_Objective
---@param progress WK_ObjectiveProgress
---@return WK_TableRowData
function TableData.BuildRow(character, characterProfession, objective, progress)
  local skillLineVariantID = characterProfession.skillLineVariantID
  ---@type WK_TableRowData
  local row = {
    data = {
      buildObjectiveCell(objective),
      buildProfessionCell(skillLineVariantID),
      buildExpansionCell(skillLineVariantID),
      buildCategoryCell(objective),
      buildLocationCell(objective),
      buildRepeatableCell(objective),
      buildProgressCell(progress),
      buildPointsCell(progress),
      buildWaypointCell(character, objective, progress),
    },
    character = character,
    characterProfession = characterProfession,
    skillLineVariantID = skillLineVariantID,
    objective = objective,
    progress = progress,
  }
  return row
end
