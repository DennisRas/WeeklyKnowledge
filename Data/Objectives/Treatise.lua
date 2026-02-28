---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local category = Enum.WK_ObjectiveCategory.Treatise

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = category, quests = {83725}, itemID = 222546, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {83726}, itemID = 222554, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {83727}, itemID = 222550, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = category, quests = {83728}, itemID = 222621, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {83729}, itemID = 222552, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {83730}, itemID = 222548, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = category, quests = {83731}, itemID = 222551, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = category, quests = {83732}, itemID = 222549, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {83733}, itemID = 222553, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = category, quests = {83734}, itemID = 222649, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = category, quests = {83735}, itemID = 222547, points = 1, loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {95127}, itemID = 245755, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {95128}, itemID = 245763, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {95129}, itemID = 245759, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {83728}, itemID = 245809, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {95130}, itemID = 245761, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {95131}, itemID = 245757, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {95133}, itemID = 245760, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {95134}, itemID = 245758, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {95135}, itemID = 245762, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {95136}, itemID = 245828, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {95137}, itemID = 245756, points = 1, loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.6, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
