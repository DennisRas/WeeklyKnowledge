---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local MISSING_INFO = Data.MISSING_INFO
local category = Enum.WK_ObjectiveCategory.WeeklyQuest

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = category, quests = {84133},                             itemID = 228773, points = 2, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {84127},                             itemID = 228774, points = 2, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {84084, 84085, 84086},               itemID = 227667, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.Dornogal, x = 52.8, y = 71.2, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = category, quests = {84128},                             itemID = 228775, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {82916, 82958, 82962, 82965, 82970}, itemID = 224817, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.Dornogal, x = 44.8, y = 69.4, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {84129},                             itemID = 228776, points = 2, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = category, quests = {84130},                             itemID = 228777, points = 2, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = category, quests = {84131},                             itemID = 228778, points = 2, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {83102, 83103, 83104, 83105, 83106}, itemID = 224818, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.Dornogal, x = 52.6, y = 52.6, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = category, quests = {82992, 82993, 83097, 83098, 83100}, itemID = 224807, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.Dornogal, x = 54.4, y = 57.6, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = category, quests = {84132},                             itemID = 228779, points = 2, loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {93690},                             itemID = 263454, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {93691},                             itemID = 263455, points = 2, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {93698, 93699},                      itemID = 263464, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.SilvermoonCity, x = 47.8, y = 53.8, hint = "Complete a quest from |cffffff00Dolothos|r <Enchanting Trainer>."}},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {93692},                             itemID = 263456, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {93700, 93702, 93703, 93704},        itemID = 263462, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.SilvermoonCity, x = 48.2, y = 51.6, hint = "Complete a quest from |cffffff00Botanist Nathera|r <Herbalism Trainer>."}},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {93693},                             itemID = 263457, points = 4, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {93694},                             itemID = 263458, points = 3, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {93695},                             itemID = 263459, points = 2, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {93705, 93706, 93708, 93709},        itemID = 263463, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.SilvermoonCity, x = 42.6, y = 52.8, hint = "Complete a quest from |cffffff00Belil|r <Mining Trainer>."}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {93710, 93711, 93712, 93714},        itemID = 263461, points = 3, limit = 1,                                                                                                                      loc = {m = Enum.WK_Map.SilvermoonCity, x = 43.2, y = 55.6, hint = "Complete a quest from |cffffff00Tyn|r <Skinning Trainer>."}},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {93696},                             itemID = 263460, points = 2, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
