---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants

---@class WK_Checklist_TableData
local TableData = {}
addon.Checklist.TableData = TableData

local Data = addon.Data
local Helpers = addon.Helpers
local LiqUI = addon.libs.LiqUI
local TableCount = LiqUI.Utils.TableCount
local TableForEach = LiqUI.Utils.TableForEach

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

    ---@param cellFrame LiqUI_TableCellFrame
    ---@param _rowFrame LiqUI_TableRowFrame
    ---@param _rowIndex integer
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _rowData LiqUI_TableDataRowExtended
    ---@param _cellData LiqUI_TableDataCellExtended|nil
    local function showItemObjectiveTooltip(cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData)
      if link and strlen(link) > 0 then
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:Show()
      end
    end

    ---@param _cellFrame LiqUI_TableCellFrame
    ---@param _rowFrame LiqUI_TableRowFrame
    ---@param _rowIndex integer
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _rowData LiqUI_TableDataRowExtended
    ---@param _cellData LiqUI_TableDataCellExtended|nil
    ---@param _button string
    local function linkItemObjective(_cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData, _button)
      if link and strlen(link) > 0 then
        if IsModifiedClick("CHATLINK") then
          if not ChatEdit_InsertLink(link) then
            ChatFrame_OpenChat(link);
          end
        end
      end
    end

    ---@type LiqUI_TableDataCellExtended
    return {
      data = text,
      onEnter = showItemObjectiveTooltip,
      onLeave = GameTooltip_Hide,
      onClick = linkItemObjective,
    }
  end

  if objective.categoryID == Constants.objectiveCategory.FirstCraft then
    local spellID = objective.spellID
    if not spellID then
      ---@type LiqUI_TableDataCellExtended
      return {
        data = "Error: RecipeID not found",
      }
    end
    local text = format("Error: RecipeID %d not found", spellID)
    local link = ""
    local recipeInfo = Data.cache.tradeSkillRecipes and Data.cache.tradeSkillRecipes[spellID]
    if not recipeInfo then
      recipeInfo = C_TradeSkillUI.GetRecipeInfo(spellID)
      if recipeInfo then
        if not Data.cache.tradeSkillRecipes then
          Data.cache.tradeSkillRecipes = {}
        end
        Data.cache.tradeSkillRecipes[spellID] = recipeInfo
      end
    end
    if recipeInfo then
      link = C_Spell.GetSpellLink(recipeInfo.recipeID or spellID)
      text = format("|T%s:0|t %s", recipeInfo.icon, recipeInfo.name)
    end
    ---@param cellFrame LiqUI_TableCellFrame
    ---@param _rowFrame LiqUI_TableRowFrame
    ---@param _rowIndex integer
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _rowData LiqUI_TableDataRowExtended
    ---@param _cellData LiqUI_TableDataCellExtended|nil
    local function showRecipeObjectiveTooltip(cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData)
      if link and strlen(link) > 0 then
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("<Click to open Recipe>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:Show()
      end
    end

    ---@param _cellFrame LiqUI_TableCellFrame
    ---@param _rowFrame LiqUI_TableRowFrame
    ---@param _rowIndex integer
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _rowData LiqUI_TableDataRowExtended
    ---@param _cellData LiqUI_TableDataCellExtended|nil
    ---@param _button string
    local function openRecipeObjective(_cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData, _button)
      if link and strlen(link) > 0 then
        if IsModifiedClick("CHATLINK") then
          if not ChatEdit_InsertLink(link) then
            ChatFrame_OpenChat(link);
          end
        else
          C_TradeSkillUI.OpenRecipe(spellID)
        end
      end
    end

    ---@type LiqUI_TableDataCellExtended
    return {
      data = text,
      onEnter = showRecipeObjectiveTooltip,
      onLeave = GameTooltip_Hide,
      onClick = openRecipeObjective,
    }
  end

  if objective.quests and TableCount(objective.quests) > 0 then
    local text = format("Error: QuestID %d not found", objective.quests[1] or "?")
    local link = format("quest:%d:-1", objective.quests[1])
    local questTooltipData = C_TooltipInfo.GetHyperlink(link)
    if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
      text = WrapTextInColorCode(format("%s [%s]", CreateAtlasMarkup("questlog-questtypeicon-Recurring", 14, 14), questTooltipData.lines[1].leftText), "ffffff00")
    end
    ---@param cellFrame LiqUI_TableCellFrame
    ---@param _rowFrame LiqUI_TableRowFrame
    ---@param _rowIndex integer
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _rowData LiqUI_TableDataRowExtended
    ---@param _cellData LiqUI_TableDataCellExtended|nil
    local function showQuestObjectiveTooltip(cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData)
      if link and strlen(link) > 0 then
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetHyperlink(link)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
        GameTooltip:Show()
      end
    end

    ---@param _cellFrame LiqUI_TableCellFrame
    ---@param _rowFrame LiqUI_TableRowFrame
    ---@param _rowIndex integer
    ---@param _columnIndex integer
    ---@param _columnId string|nil
    ---@param _rowData LiqUI_TableDataRowExtended
    ---@param _cellData LiqUI_TableDataCellExtended|nil
    ---@param _button string
    local function linkQuestObjective(_cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData, _button)
      if link and strlen(link) > 0 then
        if IsModifiedClick("CHATLINK") then
          if not ChatEdit_InsertLink(link) then
            ChatFrame_OpenChat(link);
          end
        end
      end
    end

    ---@type LiqUI_TableDataCellExtended
    return {
      data = text,
      onEnter = showQuestObjectiveTooltip,
      onLeave = GameTooltip_Hide,
      onClick = linkQuestObjective,
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
  text = skillLine.name
  if Data.db.global.showFullProfessionName then
    text = variant.name
  end
  ---@param cellFrame LiqUI_TableCellFrame
  ---@param _rowFrame LiqUI_TableRowFrame
  ---@param _rowIndex integer
  ---@param _columnIndex integer
  ---@param _columnId string|nil
  ---@param _rowData LiqUI_TableDataRowExtended
  ---@param _cellData LiqUI_TableDataCellExtended|nil
  local function showProfessionCellTooltip(cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData)
    GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
    GameTooltip:SetText(text, 1, 1, 1);
    GameTooltip:AddLine(format("<Click to open profession>"), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
    GameTooltip:Show()
  end

  ---@param _cellFrame LiqUI_TableCellFrame
  ---@param _rowFrame LiqUI_TableRowFrame
  ---@param _rowIndex integer
  ---@param _columnIndex integer
  ---@param _columnId string|nil
  ---@param _rowData LiqUI_TableDataRowExtended
  ---@param _cellData LiqUI_TableDataCellExtended|nil
  ---@param _button string
  local function openProfessionFromCell(_cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData, _button)
    C_TradeSkillUI.OpenTradeSkill(skillLine.id)
  end

  ---@type LiqUI_TableDataCellExtended
  return {
    data = text,
    onEnter = showProfessionCellTooltip,
    onLeave = GameTooltip_Hide,
    onClick = openProfessionFromCell,
  }
end

---@param skillLineVariantID integer
---@return LiqUI_TableDataCellExtended
local function buildExpansionCell(skillLineVariantID)
  local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
  local expansion = skillLineVariant and LiqUI.Data:GetExpansionByID(skillLineVariant.expansionID)
  ---@type LiqUI_TableDataCellExtended
  return {
    data = expansion and expansion.name or "",
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
  ---@param cellFrame LiqUI_TableCellFrame
  ---@param _rowFrame LiqUI_TableRowFrame
  ---@param _rowIndex integer
  ---@param _columnIndex integer
  ---@param _columnId string|nil
  ---@param _rowData LiqUI_TableDataRowExtended
  ---@param _cellData LiqUI_TableDataCellExtended|nil
  local function showCategoryCellTooltip(cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData)
    GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
    GameTooltip:SetText(objectiveCategory.name, 1, 1, 1);
    GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
    GameTooltip:Show()
  end

  ---@type LiqUI_TableDataCellExtended
  return {
    data = objectiveCategory.name,
    onEnter = showCategoryCellTooltip,
    onLeave = GameTooltip_Hide,
  }
end

---@param objective WK_Objective
---@return LiqUI_TableDataCellExtended
local function buildLocationCell(objective)
  local text = " "
  local loc = objective.loc
  local mapID = loc and loc.m
  if mapID then
    if Data.cache.mapInfo[mapID] then
      text = Data.cache.mapInfo[mapID].name
    else
      local mapInfo = C_Map.GetMapInfo(mapID)
      if mapInfo then
        Data.cache.mapInfo[mapID] = mapInfo
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
    data = objectiveCategory.repeatable or "",
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
  ---@type WK_TomTom?
  local TomTomGlobal = _G["TomTom"]
  local loc = objective.loc
  local mapID = loc and loc.m
  local mapX = loc and loc.x
  local mapY = loc and loc.y
  local mapInfo = nil
  local mapPoint = nil
  if mapID then
    mapInfo = C_Map.GetMapInfo(mapID)
    if mapInfo and mapX and mapY then
      local uiMapID = mapID
      local coordX = mapX
      local coordY = mapY
      mapPoint = UiMapPoint.CreateFromCoordinates(uiMapID, coordX / 100, coordY / 100)
    end
  end

  ---@param cellFrame LiqUI_TableCellFrame
  ---@param _rowFrame LiqUI_TableRowFrame
  ---@param _rowIndex integer
  ---@param _columnIndex integer
  ---@param _columnId string|nil
  ---@param _rowData LiqUI_TableDataRowExtended
  ---@param _cellData LiqUI_TableDataCellExtended|nil
  local function showWaypointCellTooltip(cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData)
    local function showTooltip()
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Do you know de wey?", 1, 1, 1)

        if loc and loc.hint then
          GameTooltip:AddLine(loc.hint, nil, nil, nil, true)
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

        if mapX and mapY then
          if not mapInfo then
            GameTooltip:AddLine(" ")
          end
          GameTooltip:AddDoubleLine("Coordinates:", format("%.1f / %.1f", mapX, mapY), nil, nil, nil, 1, 1, 1)
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
          local tooltipMapID = mapID
          if tooltipMapID then
            if C_Map.CanSetUserWaypointOnMap(tooltipMapID) or TomTomGlobal then
              GameTooltip:AddLine(" ")
            end
            if C_Map.CanSetUserWaypointOnMap(tooltipMapID) then
              GameTooltip:AddLine("<Click to place a pin on the map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:AddLine("<Shift click to share pin in chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            end
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
          local itemID = requirement.requirement.id
          if requirement.requirement.type == "item" and itemID then
            Data.cache.items[itemID] = Item:CreateFromItemID(itemID)
            Data.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
          end
        end)
      end

    showTooltip()
  end

  ---@param _cellFrame LiqUI_TableCellFrame
  ---@param _rowFrame LiqUI_TableRowFrame
  ---@param _rowIndex integer
  ---@param _columnIndex integer
  ---@param _columnId string|nil
  ---@param _rowData LiqUI_TableDataRowExtended
  ---@param _cellData LiqUI_TableDataCellExtended|nil
  ---@param _button string
  local function clickWaypointCell(_cellFrame, _rowFrame, _rowIndex, _columnIndex, _columnId, _rowData, _cellData, _button)
    local pinMapID = mapID
      if not mapPoint then
        return
      end
      if not pinMapID then
        return
      end
      local pinX = mapX
      if not pinX then
        return
      end
      local pinY = mapY
      if not pinY then
        return
      end
    if IsAltKeyDown() and TomTomGlobal then
      local text = "Objective"
      ---@type WK_TomTomWaypointOptions
      local waypointOptions = {title = text, from = addon.name}
      TomTomGlobal:AddWaypoint(pinMapID, pinX / 100, pinY / 100, waypointOptions)
    elseif C_Map.CanSetUserWaypointOnMap(pinMapID) then
      if IsModifiedClick("CHATLINK") then
        local hyperlink = format("|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r", pinMapID, pinX * 100, pinY * 100, MAP_PIN_HYPERLINK)
        if not ChatEdit_InsertLink(hyperlink) then
          ChatFrame_OpenChat(hyperlink);
        end
      else
        C_Map.SetUserWaypoint(mapPoint)
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
      end
    end
  end

  ---@type LiqUI_TableDataCellExtended
  return {
    data = CreateAtlasMarkup("Waypoint-MapPin-Tracked", 20, 20, -4),
    onEnter = showWaypointCellTooltip,
    onLeave = GameTooltip_Hide,
    onClick = clickWaypointCell,
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
