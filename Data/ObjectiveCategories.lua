---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants
local L = addon.L

---@class WK_Data
local Data = addon.Data

---@param text string
---@param repeatable string
---@return string
local function categoryDescription(text, repeatable)
  return text .. "\n\n" .. L["CATEGORY_REPEATABLE_LINE"]:format(WHITE_FONT_COLOR:WrapTextInColorCode(repeatable))
end

---@type WK_ObjectiveCategory[]
Data.ObjectiveCategories = {
  {id = Constants.objectiveCategory.Unique,        name = L["CATEGORY_UNIQUE"],        legacyName = "Uniques",      description = categoryDescription(L["CATEGORY_UNIQUE_DESC"],        L["REPEATABLE_NO"]),      type = "item",   repeatable = "No",},
  {id = Constants.objectiveCategory.FirstCraft,    name = L["CATEGORY_FIRST_CRAFT"],   legacyName = "First Craft",  description = categoryDescription(L["CATEGORY_FIRST_CRAFT_DESC"],   L["REPEATABLE_NO"]),      type = "recipe", repeatable = "No",},
  {id = Constants.objectiveCategory.Treatise,      name = L["CATEGORY_TREATISE"],      legacyName = "Treatise",     description = categoryDescription(L["CATEGORY_TREATISE_DESC"],      L["REPEATABLE_WEEKLY"]),  type = "item",   repeatable = "Weekly",  hint = true,},
  {id = Constants.objectiveCategory.WeeklyQuest,   name = L["CATEGORY_WEEKLY_QUEST"],  legacyName = "Weekly Quest", description = categoryDescription(L["CATEGORY_WEEKLY_QUEST_DESC"],  L["REPEATABLE_WEEKLY"]),  type = "quest",  repeatable = "Weekly",},
  {id = Constants.objectiveCategory.Treasure,      name = L["CATEGORY_TREASURE"],      legacyName = "Treasure",     description = categoryDescription(L["CATEGORY_TREASURE_DESC"],      L["REPEATABLE_WEEKLY"]),  type = "item",   repeatable = "Weekly",  hint = true,},
  {id = Constants.objectiveCategory.Gathering,     name = L["CATEGORY_GATHERING"],     legacyName = "Gathering",    description = categoryDescription(L["CATEGORY_GATHERING_DESC"],     L["REPEATABLE_WEEKLY"]),  type = "item",   repeatable = "Weekly",},
  {id = Constants.objectiveCategory.DarkmoonQuest, name = L["CATEGORY_DARKMOON"],      legacyName = "Darkmoon",     description = categoryDescription(L["CATEGORY_DARKMOON_DESC"],      L["REPEATABLE_MONTHLY"]), type = "quest",  repeatable = "Monthly",},
  {id = Constants.objectiveCategory.CatchUp,       name = L["CATEGORY_CATCH_UP"],      legacyName = "Catch-Up",     description = categoryDescription(L["CATEGORY_CATCH_UP_DESC"],      L["REPEATABLE_YES"]),     type = "item",   repeatable = "Yes",},
}
