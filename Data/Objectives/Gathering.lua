---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local MISSING_INFO = Data.MISSING_INFO
local category = Enum.WK_ObjectiveCategory.Gathering

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  -- The War Within: Blacksmithing
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1, loc = {hint = "These are randomly looted from disenchanting items."}},
  {skillLineVariantID = 2874, categoryID = category, quests = {84295},                             itemID = 227661, points = 4, loc = {hint = "These are randomly looted from disenchanting items."}},
  -- The War Within: Engineering
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {81416, 81417, 81418, 81419, 81420}, itemID = 224264, points = 1, loc = {hint = "These are randomly looted from herbs around the world."}},
  {skillLineVariantID = 2877, categoryID = category, quests = {81421},                             itemID = 224265, points = 4, loc = {hint = "These are randomly looted from herbs around the world."}},
  -- The War Within: Inscription
  -- The War Within: Jewelcrafting
  -- The War Within: Leatherworking
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {83050, 83051, 83052, 83053, 83054}, itemID = 224583, points = 1, loc = {hint = "These are randomly looted from mining nodes around the world."}},
  {skillLineVariantID = 2881, categoryID = category, quests = {83049},                             itemID = 224584, points = 3, loc = {hint = "These are randomly looted from mining nodes around the world."}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = category, quests = {81459, 81460, 81461, 81462, 81463}, itemID = 224780, points = 1, loc = {hint = "These are randomly looted from skinning around the world."}},
  {skillLineVariantID = 2882, categoryID = category, quests = {81464},                             itemID = 224781, points = 2, loc = {hint = "These are randomly looted from skinning around the world."}},
  -- The War Within: Tailoring

  -- Midnight: Alchemy
  -- Midnight: Blacksmithing
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {95048, 95049, 95050, 95051, 95052}, itemID = 267654, points = 1, loc = {hint = "These are randomly looted from disenchanting items."}},
  {skillLineVariantID = 2909, categoryID = category, quests = {95053},                             itemID = 267655, points = 4, loc = {hint = "These are randomly looted from disenchanting items."}},
  -- Midnight: Engineering
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {81425, 81426, 81427, 81428, 81429}, itemID = 238465, points = 1, loc = {hint = "These are randomly looted from herbs around the world."}},
  {skillLineVariantID = 2912, categoryID = category, quests = {81430},                             itemID = 238466, points = 4, loc = {hint = "These are randomly looted from herbs around the world."}},
  -- Midnight: Inscription
  -- Midnight: Jewelcrafting
  -- Midnight: Leatherworking
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {88673, 88674, 88675, 88676, 88677}, itemID = 237496, points = 1, loc = {hint = "These are randomly looted from mining nodes around the world."}},
  {skillLineVariantID = 2916, categoryID = category, quests = {88678},                             itemID = 237506, points = 3, loc = {hint = "These are randomly looted from mining nodes around the world."}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {88534, 88549, 88537, 88536, 88530}, itemID = 238625, points = 1, loc = {hint = "These are randomly looted from skinning around the world."}},
  {skillLineVariantID = 2917, categoryID = category, quests = {88529},                             itemID = 238626, points = 3, loc = {hint = "These are randomly looted from skinning around the world."}},
  -- Midnight: Tailoring
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
