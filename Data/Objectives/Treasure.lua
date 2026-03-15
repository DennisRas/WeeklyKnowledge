---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local MISSING_INFO = Data.MISSING_INFO

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83253}, itemID = 225234, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Alchemical Sediment
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83255}, itemID = 225235, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Deepstone Crucible
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83256}, itemID = 225233, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Dense Bladestone
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83257}, itemID = 225232, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Coreway Billet
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83258}, itemID = 225231, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Powdered Fulgurance
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83259}, itemID = 225230, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Crystalline Repository
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83260}, itemID = 225228, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Rust-Locked Mechanism
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83261}, itemID = 225229, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Earthen Induction Coil
  -- The War Within: Herbalism
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83262}, itemID = 225227, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Wax-Sealed Records
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83264}, itemID = 225226, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Striated Inkstone
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83265}, itemID = 225224, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Diaphanous Gem Shards
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83266}, itemID = 225225, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Deepstone Fragment
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83267}, itemID = 225223, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Sturdy Nerubian Carapace
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83268}, itemID = 225222, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Stone-Leather Swatch
  -- The War Within: Mining
  -- The War Within: Skinning
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83269}, itemID = 225221, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Spool of Webweave
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83270}, itemID = 225220, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Chitin Needle

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93528}, itemID = 259188, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Lightbloomed Spore Sample
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93529}, itemID = 259189, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Aged Cruor
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93530}, itemID = 259190, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Thalassian Whestone
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93531}, itemID = 259191, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Infused Quenching Oil
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93532}, itemID = 259192, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Voidstorm Ashes
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93533}, itemID = 259193, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Lost Thalassian Vellum
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93534}, itemID = 259194, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Dance Gear
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93535}, itemID = 259195, points = 1, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Dawn Capacitor
  -- Midnight: Herbalism
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93536}, itemID = 259196, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Brilliant Phoenix Ink
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93537}, itemID = 259197, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Loa-Blessed Rune
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93539}, itemID = 259198, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Void-Touched Eversong Diamond Fragments
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93538}, itemID = 259199, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Harandar Stone Sample
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93540}, itemID = 259200, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Amani Tanning Oil
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93541}, itemID = 259201, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Thalassian Mana Oil
  -- Midnight: Mining
  -- Midnight: Skinning
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93542}, itemID = 259202, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Embroidered Memento
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {93543}, itemID = 259203, points = 2, loc = {hint = "These are randomly looted from treasures around the world."}}, -- Finely Woven Lynx Collar
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
