---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local MISSING_INFO = Data.MISSING_INFO
local category = Enum.WK_ObjectiveCategory.CatchUp

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = category, quests = {}, itemID = 228724, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {}, itemID = 228726, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {}, itemID = 227662, points = 0, loc = {hint = "These are randomly looted from disenchanting items once the weekly objectives below are completed."},           requires = {{type = "quest", name = "Treasure", quests = {83258, 83259}, match = "all"}, {type = "quest", name = "Disenchanting", quests = {84290, 84291, 84292, 84293, 84294, 84295}, match = "all"}, {type = "quest", name = "Trainer Quest", quests = {84084, 84085, 84086}, match = "any"}}},
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = category, quests = {}, itemID = 228730, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {}, itemID = 224835, points = 0, loc = {hint = "These are randomly looted from herbs around the world once the weekly objectives below are completed."},        requires = {{type = "quest", name = "Trainer Quest", quests = {82970, 82958, 82965, 82916, 82962}, match = "any"}, {type = "quest", name = "Gathering", quests = {81416, 81417, 81418, 81419, 81420, 81421}, match = "all"}}},
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {}, itemID = 228732, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = category, quests = {}, itemID = 228734, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = category, quests = {}, itemID = 228736, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {}, itemID = 224838, points = 0, loc = {hint = "These are randomly looted from mining nodes around the world once the weekly objectives below are completed."}, requires = {{type = "quest", name = "Trainer Quest", quests = {83104, 83105, 83103, 83106, 83102}, match = "any"}, {type = "quest", name = "Gathering", quests = {83050, 83051, 83052, 83053, 83054, 83049}, match = "all"}}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = category, quests = {}, itemID = 224782, points = 0, loc = {hint = "These are randomly looted from skinning around the world once the weekly objectives below are completed."},     requires = {{type = "quest", name = "Trainer Quest", quests = {83097, 83098, 83100, 82992, 82993}, match = "any"}, {type = "quest", name = "Gathering", quests = {81459, 81460, 81461, 81462, 81463, 81464}, match = "all"}}},
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = category, quests = {}, itemID = 228738, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {}, itemID = 246320, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {}, itemID = 246322, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {}, itemID = 267653, points = 0, loc = {hint = "These are randomly looted from disenchanting items once the weekly objectives below are completed."},           requires = {{type = "quest", name = "Treasure", quests = {93532, 93533}, match = "all"}, {type = "quest", name = "Disenchanting", quests = {95048, 95049, 95050, 95051, 95052, 95053}, match = "all"}, {type = "quest", name = "Trainer Quest", quests = {93699, 93698}, match = "any"}}},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {}, itemID = 246326, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {}, itemID = 238467, points = 0, loc = {hint = "These are randomly looted from herbs around the world once the weekly objectives below are completed."},        requires = {{type = "quest", name = "Trainer Quest", quests = {93704, 93703, 93702, 93700}, match = "any"}, {type = "quest", name = "Gathering", quests = {81425, 81426, 81427, 81428, 81429, 81430}, match = "all"}}},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {}, itemID = 246328, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {}, itemID = 246330, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {}, itemID = 246332, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {}, itemID = 237507, points = 0, loc = {hint = "These are randomly looted from mining nodes around the world once the weekly objectives below are completed."}, requires = {{type = "quest", name = "Trainer Quest", quests = {93709, 93708, 93706, 93705}, match = "any"}, {type = "quest", name = "Gathering", quests = {88673, 88674, 88675, 88676, 88677, 88678}, match = "all"}}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {}, itemID = 238627, points = 0, loc = {hint = "These are randomly looted from skinning around the world once the weekly objectives below are completed."},     requires = {{type = "quest", name = "Trainer Quest", quests = {93714, 93711, 93710}, match = "any"}, {type = "quest", name = "Gathering", quests = {88534, 88549, 88537, 88536, 88530, 88529}, match = "all"}}},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {}, itemID = 246334, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
