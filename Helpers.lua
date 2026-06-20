---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Helpers
local Helpers = {}
addon.Helpers = Helpers

local Constants = addon.Constants
local LibLiqUI = addon.libs.LiqUI
local TableFind = LibLiqUI.Utils.TableFind

---True if the value is a secret (WoW API); use before comparing/using API return values that may be secret.
---@param value any
---@return boolean
function Helpers:IsSecretValue(value)
  if issecretvalue == nil then return false end
  ---@diagnostic disable-next-line: param-type-mismatch
  return issecretvalue(value)
end

---@param characterA table
---@param characterB table
---@return number
function Helpers:CompareCharacterNameRealm(characterA, characterB)
  local nameCompare = strcmputf8i(characterA.name or "", characterB.name or "")
  if nameCompare ~= 0 then return nameCompare end
  return strcmputf8i(characterA.realmName or "", characterB.realmName or "")
end

---Print a debug message
---@param ... any
function Helpers:Debug(...)
  if addon.debug then
    addon.Core:Print(...)
  end
end

--- Render requirement tooltip
---@param objectiveProgressRequirement WK_ObjectiveProgressRequirement
---@param character WK_Character
---@param skillLineVariantID number
---@param objectiveCategoryID WK_ObjectiveCategoryId
function Helpers:RenderRequirementTooltip(objectiveProgressRequirement, character, skillLineVariantID, objectiveCategoryID)
  local leftText = "-"
  local rightText = "-"
  local leftColor = WHITE_FONT_COLOR
  local rightColor = WHITE_FONT_COLOR
  if objectiveProgressRequirement.requirement.type == "item" then
    leftText = format("ItemID: %d", objectiveProgressRequirement.requirement.id)
    rightText = format("%d / %d", 0, objectiveProgressRequirement.requirement.amount or 0)
    local quantity = character.items and character.items[objectiveProgressRequirement.requirement.id] or 0
    local item = addon.Data.cache.items[objectiveProgressRequirement.requirement.id]
    local itemCached = item and item:IsItemDataCached()
    local name = "Loading..."
    local icon = 134400
    if itemCached then
      icon = item:GetItemIcon() or 134400
      name = item:GetItemLink() or "Loading..."
    end
    leftText = format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name)
    rightText = format("%d / %d", quantity, objectiveProgressRequirement.requirement.amount or 0)
    if quantity >= objectiveProgressRequirement.requirement.amount then
      rightColor = GREEN_FONT_COLOR
    else
      rightColor = RED_FONT_COLOR
    end
  elseif objectiveProgressRequirement.requirement.type == "currency" then
    leftText = format("CurrencyID: %d", objectiveProgressRequirement.requirement.id)
    rightText = format("%d / %d", 0, objectiveProgressRequirement.requirement.amount or 0)
    local name = "Loading..."
    local quantity = 0
    local icon = 134400
    local characterCurrency = character.currencies and character.currencies[objectiveProgressRequirement.requirement.id] or nil
    if characterCurrency then
      if characterCurrency.name then
        name = characterCurrency.name
      end
      if characterCurrency.quantity then
        quantity = characterCurrency.quantity
      end
      if characterCurrency.iconFileID and characterCurrency.iconFileID > 0 then
        icon = characterCurrency.iconFileID
      end
      leftText = format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name)
      rightText = format("%d / %d", quantity, objectiveProgressRequirement.requirement.amount or 0)
    end
    if quantity >= objectiveProgressRequirement.requirement.amount then
      rightColor = GREEN_FONT_COLOR
    else
      rightColor = RED_FONT_COLOR
    end
  elseif objectiveProgressRequirement.requirement.type == "quest" then
    leftText = format("QuestID: %d", objectiveProgressRequirement.requirement.quests[1] or "?")
    rightText = CreateAtlasMarkup("common-icon-redx", 12, 12)
    if objectiveProgressRequirement.requirement.name then
      leftText = format("%s %s", objectiveProgressRequirement.requirement.name, objectiveCategoryID == Constants.objectiveCategory.CatchUp and "" or "(Quest)")
    end
    if objectiveProgressRequirement.isCompleted then
      rightText = CreateAtlasMarkup("common-icon-checkmark", 12, 12)
    end
  elseif objectiveProgressRequirement.requirement.type == "renown" then
    leftText = format("FactionID: %d", objectiveProgressRequirement.requirement.id)
    rightText = format("%d / %d", 0, objectiveProgressRequirement.requirement.amount or 0)
    local level = 0
    local factionInfo = C_MajorFactions.GetMajorFactionData(objectiveProgressRequirement.requirement.id)
    if factionInfo then
      leftText = format("%s (Renown)", factionInfo.name)
      rightText = format("%d / %d", 0, objectiveProgressRequirement.requirement.amount or 0)
    end
    if character.factions and character.factions[objectiveProgressRequirement.requirement.id] then
      level = character.factions[objectiveProgressRequirement.requirement.id].level or 0
      rightText = format("%d / %d", level, objectiveProgressRequirement.requirement.amount or 0)
    end
    if level >= objectiveProgressRequirement.requirement.amount then
      rightColor = GREEN_FONT_COLOR
    else
      rightColor = RED_FONT_COLOR
    end
  elseif objectiveProgressRequirement.requirement.type == "skill" then
    leftText = format("SkillID: %d", objectiveProgressRequirement.requirement.id)
    rightText = format("%d / %d", 0, objectiveProgressRequirement.requirement.amount or 0)
    local skillLevel = 0
    local characterProfession = TableFind(character.professions, function(characterProfession)
      return characterProfession.skillLineVariantID == skillLineVariantID
    end)
    if characterProfession then
      skillLevel = characterProfession.skillLevel or 0
    end
    rightText = format("%d / %d", skillLevel, objectiveProgressRequirement.requirement.amount or 0)
    if skillLevel >= objectiveProgressRequirement.requirement.amount then
      rightColor = GREEN_FONT_COLOR
    else
      rightColor = RED_FONT_COLOR
    end
  end

  GameTooltip:AddDoubleLine(leftColor:WrapTextInColorCode(leftText), rightColor:WrapTextInColorCode(rightText), 1, 1, 1, 1, 1, 1)
end
