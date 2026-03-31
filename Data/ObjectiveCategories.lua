---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

---@type WK_ObjectiveCategory[]
Data.ObjectiveCategories = {
  {id = Enum.WK_ObjectiveCategory.Unique,        name = L["category_uniques"],      description = format(L["objective_desc_uniques"],      WHITE_FONT_COLOR:WrapTextInColorCode(L["label_no"])),      type = "item",   repeatable = L["label_no"],},
  {id = Enum.WK_ObjectiveCategory.FirstCraft,    name = L["category_first_craft"],  description = format(L["objective_desc_first_craft"],  WHITE_FONT_COLOR:WrapTextInColorCode(L["label_no"])),      type = "recipe", repeatable = L["label_no"],},
  {id = Enum.WK_ObjectiveCategory.Treatise,      name = L["category_treatise"],     description = format(L["objective_desc_treatise"],     WHITE_FONT_COLOR:WrapTextInColorCode(L["label_weekly"])),  type = "item",   repeatable = L["label_weekly"], hint = true,},
  {id = Enum.WK_ObjectiveCategory.WeeklyQuest,   name = L["category_weekly_quest"], description = format(L["objective_desc_weekly_quest"], WHITE_FONT_COLOR:WrapTextInColorCode(L["label_weekly"])),  type = "quest",  repeatable = L["label_weekly"],},
  {id = Enum.WK_ObjectiveCategory.Treasure,      name = L["category_treasure"],     description = format(L["objective_desc_treasure"],     WHITE_FONT_COLOR:WrapTextInColorCode(L["label_weekly"])),  type = "item",   repeatable = L["label_weekly"], hint = true,},
  {id = Enum.WK_ObjectiveCategory.Gathering,     name = L["category_gathering"],    description = format(L["objective_desc_gathering"],    WHITE_FONT_COLOR:WrapTextInColorCode(L["label_weekly"])),  type = "item",   repeatable = L["label_weekly"],},
  {id = Enum.WK_ObjectiveCategory.DarkmoonQuest, name = L["category_darkmoon"],     description = format(L["objective_desc_darkmoon"],     WHITE_FONT_COLOR:WrapTextInColorCode(L["label_monthly"])), type = "quest",  repeatable = L["label_monthly"],},
  {id = Enum.WK_ObjectiveCategory.CatchUp,       name = L["category_catch_up"],     description = format(L["objective_desc_catch_up"],     WHITE_FONT_COLOR:WrapTextInColorCode(L["label_yes"])),     type = "item",   repeatable = L["label_yes"],},
}
