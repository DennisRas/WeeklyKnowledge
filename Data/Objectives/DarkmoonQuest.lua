---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local category = Enum.WK_ObjectiveCategory.DarkmoonQuest

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = category, quests = {29506}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 50.2, y = 69.6, hint = "Talk to |cff00ff00Sylannia|r at the Darkmoon Faire and complete the quest |cffffff00A Fizzy Fusion|r."},                                                                         requires = {{type = "item", id = 1645, amount = 5}}},
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {29508}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 51.0, y = 81.8, hint = "Talk to |cff00ff00Yebb Neblegear|r at the Darkmoon Faire and complete the quest |cffffff00Baby Needs Two Pair of Shoes|r.\n\nHint: There is an anvil behind the heirloom tent."}},
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {29510}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Putting Trash to Good Use|r."}},
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = category, quests = {29511}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Talkin' Tonks|r."}},
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {29514}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Herbs for Healing|r."}},
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {29515}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Writing the Future|r"},                                                                         requires = {{type = "item", id = 39354, amount = 5}}},
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = category, quests = {29516}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Keeping the Faire Sparkling|r."}},
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = category, quests = {29517}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Eyes on the Prizes|r."},                                                                      requires = {{type = "item", id = 6529, amount = 10}, {type = "item", id = 2320, amount = 5}, {type = "item", id = 6260, amount = 5}}},
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {29518}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Rearm, Reuse, Recycle|r."}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = category, quests = {29519}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Tan My Hide|r."}},
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = category, quests = {29520}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.6, y = 55.8, hint = "Talk to |cff00ff00Selina Dourman|r at the Darkmoon Faire and complete the quest |cffffff00Banners, Banners Everywhere!|r"},                                                      requires = {{type = "item", id = 2320, amount = 1}, {type = "item", id = 2604, amount = 1}, {type = "item", id = 6260, amount = 1}}},

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {29506}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 50.2, y = 69.6, hint = "Talk to |cff00ff00Sylannia|r at the Darkmoon Faire and complete the quest |cffffff00A Fizzy Fusion|r."},                                                                         requires = {{type = "item", id = 1645, amount = 5}}},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {29508}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 51.0, y = 81.8, hint = "Talk to |cff00ff00Yebb Neblegear|r at the Darkmoon Faire and complete the quest |cffffff00Baby Needs Two Pair of Shoes|r.\n\nHint: There is an anvil behind the heirloom tent."}},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {29510}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Putting Trash to Good Use|r."}},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {29511}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Talkin' Tonks|r."}},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {29514}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Herbs for Healing|r."}},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {29515}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Writing the Future|r"},                                                                         requires = {{type = "item", id = 39354, amount = 5}}},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {29516}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Keeping the Faire Sparkling|r."}},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {29517}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Eyes on the Prizes|r."},                                                                      requires = {{type = "item", id = 6529, amount = 10}, {type = "item", id = 2320, amount = 5}, {type = "item", id = 6260, amount = 5}}},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {29518}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Rearm, Reuse, Recycle|r."}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {29519}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Tan My Hide|r."}},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {29520}, itemID = 0, points = 3, loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.6, y = 55.8, hint = "Talk to |cff00ff00Selina Dourman|r at the Darkmoon Faire and complete the quest |cffffff00Banners, Banners Everywhere!|r"},                                                      requires = {{type = "item", id = 2320, amount = 1}, {type = "item", id = 2604, amount = 1}, {type = "item", id = 6260, amount = 1}}},
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
