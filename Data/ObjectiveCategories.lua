---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data

---@type WK_ObjectiveCategory[]
Data.ObjectiveCategories = {
  {id = Enum.WK_ObjectiveCategory.Unique,        name = "Uniques",      description = "These are one-time items found in treasures around the world and sold by vendors.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),                                 type = "item",   repeatable = "No",},
  {id = Enum.WK_ObjectiveCategory.FirstCraft,    name = "First Craft",  description = "These are your first craft or first gathering bonuses.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),                                                            type = "recipe", repeatable = "No",},
  {id = Enum.WK_ObjectiveCategory.Treatise,      name = "Treatise",     description = "These can be crafted with Inscription. Send a Crafting Order if you don't have the profession.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),                type = "item",   repeatable = "Weekly",  hint = true,},
  {id = Enum.WK_ObjectiveCategory.WeeklyQuest,   name = "Weekly Quest", description = "Complete a quest from your profession trainer or from the Artisan's Consortium.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),                               type = "quest",  repeatable = "Weekly",},
  {id = Enum.WK_ObjectiveCategory.Treasure,      name = "Treasure",     description = "These are randomly looted from treasures around the world.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),                                                    type = "item",   repeatable = "Weekly",  hint = true,},
  {id = Enum.WK_ObjectiveCategory.Gathering,     name = "Gathering",    description = "These are randomly looted from gathering nodes around the world.\n\nThese are also looted from Disenchanting.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"), type = "item",   repeatable = "Weekly",},
  {id = Enum.WK_ObjectiveCategory.DarkmoonQuest, name = "Darkmoon",     description = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Monthly"),                                                               type = "quest",  repeatable = "Monthly",},
  {id = Enum.WK_ObjectiveCategory.CatchUp,       name = "Catch-Up",     description = "Keep track of your Knowledge Points progress and catch up on points from previous weeks.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Yes"),                         type = "item",   repeatable = "Yes",},
}
