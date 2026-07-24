---@class WK_Addon
local addon = select(2, ...)

local Constants = addon.Constants

---@class WK_Data
local Data = addon.Data
local category = Constants.objectiveCategory.WeeklyQuest

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = category, quests = {84133},                             itemID = 228773, points = 2, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {84127},                             itemID = 228774, points = 2, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {84084, 84085, 84086},               itemID = 227667, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.Dornogal, x = 52.8, y = 71.2, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = category, quests = {84128},                             itemID = 228775, points = 1, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {82916, 82958, 82962, 82965, 82970}, itemID = 224817, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.Dornogal, x = 44.8, y = 69.4, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {84129},                             itemID = 228776, points = 2, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = category, quests = {84130},                             itemID = 228777, points = 2, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = category, quests = {84131},                             itemID = 228778, points = 2, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {83102, 83103, 83104, 83105, 83106}, itemID = 224818, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.Dornogal, x = 52.6, y = 52.6, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = category, quests = {82992, 82993, 83097, 83098, 83100}, itemID = 224807, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.Dornogal, x = 54.4, y = 57.6, hint = "Talk to your profession trainer and complete the quest."}},
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = category, quests = {84132},                             itemID = 228779, points = 2, loc = {m = Constants.map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {93690},                             itemID = 263454, points = 1, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {93691},                             itemID = 263455, points = 2, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {93697, 93698, 93699},               itemID = 263464, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.SilvermoonCity, x = 47.8, y = 53.8, hint = "Complete a quest from |cffffff00Dolothos|r <Enchanting Trainer>."}},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {93692},                             itemID = 263456, points = 1, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {93700, 93701, 93702, 93703, 93704}, itemID = 263462, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.SilvermoonCity, x = 48.2, y = 51.6, hint = "Complete a quest from |cffffff00Botanist Nathera|r <Herbalism Trainer>."}},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {93693},                             itemID = 263457, points = 4, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {93694},                             itemID = 263458, points = 3, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {93695},                             itemID = 263459, points = 2, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {93705, 93706, 93707, 93708, 93709}, itemID = 263463, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.SilvermoonCity, x = 42.6, y = 52.8, hint = "Complete a quest from |cffffff00Belil|r <Mining Trainer>."}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {93710, 93711, 93712, 93713, 93714}, itemID = 263461, points = 3, limit = 1,                                                                                                                      loc = {m = Constants.map.SilvermoonCity, x = 43.2, y = 55.6, hint = "Complete a quest from |cffffff00Tyn|r <Skinning Trainer>."}},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {93696},                             itemID = 263460, points = 2, loc = {m = Constants.map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},

  -- Dragonflight: Alchemy
  {skillLineVariantID = 2823, categoryID = category, quests = {75363, 72427, 66940, 66938, 66937, 75363, 75371, 77933, 77932},        itemID = 198608, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Dhurrel or Dothenos or Kayann or Magnolia Oaken|r."}},
  {skillLineVariantID = 2823, categoryID = category, quests = {70532, 70533, 70530, 70531},                                           itemID = 198608, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.4, y = 71.6, hint = "Complete a quest from |cffffff00Conflago|r <Alchemy Trainer>."}},
  -- Dragonflight: Blacksmithing
  {skillLineVariantID = 2822, categoryID = category, quests = {66517, 66897, 66941, 75148, 75569, 77936, 77935},                      itemID = 198606, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Dhurrel or Kayann or Magnolia Oaken|r."}},
  {skillLineVariantID = 2822, categoryID = category, quests = {70234, 70233, 70235, 70211},                                           itemID = 198606, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.9, y = 46.6, hint = "Complete a quest from |cffffff00Metalshaper Kuroko|r <Blacksmithing Trainer>."}},
  {skillLineVariantID = 2822, categoryID = category, quests = {70589},                                                                itemID = 198606, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 35.4, y = 58.7, hint = "Complete a quest from Azley."}},
  -- Dragonflight: Enchanting
  {skillLineVariantID = 2825, categoryID = category, quests = {66900, 66884, 72423, 66935, 75150, 75865, 77910, 77937},               itemID = 198610, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Temnaayu or Gnoklin Quirkcoil or Kayann or Magnolia Oaken|r."}},
  {skillLineVariantID = 2825, categoryID = category, quests = {72175, 72173, 72172, 72155},                                           itemID = 198610, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 31.1, y = 61.3, hint = "Complete a quest from |cffffff00Soragosa|r <Enchanting Trainer>."}},
  -- Dragonflight: Engineering
  {skillLineVariantID = 2827, categoryID = category, quests = {72396, 66890, 66942, 66891, 75575, 75608, 77938, 77891},               itemID = 198611, points = 2, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Dothenos, Gnoklin Quirkcoil, Kayann, Magnolia Oaken|r."}},
  {skillLineVariantID = 2827, categoryID = category, quests = {70540, 70539, 70545, 70557},                                           itemID = 198611, points = 2, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 42.2, y = 48.9, hint = "Complete a quest from |cffffff00Clinkyclick Shatterboom|r <Engineering Trainer>."}},
  {skillLineVariantID = 2827, categoryID = category, quests = {70591},                                                                itemID = 198611, points = 2, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 35.4, y = 58.7, hint = "Complete a quest from Azley."}},
  -- Dragonflight: Herbalism
  {skillLineVariantID = 2832, categoryID = category, quests = {70614, 70615, 70613, 70616},                                           itemID = 199115, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 37.9, y = 68.5, hint = "Complete a quest from |cffffff00Agrikus|r <Herbalism Trainer>."}},
  -- Dragonflight: Inscription
  {skillLineVariantID = 2828, categoryID = category, quests = {66945, 72438, 66943, 66944, 75149, 75573, 77889, 77914},               itemID = 198607, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Dothenos, Gnoklin Quirkcoil, Kayann, Magnolia Oaken|r."}},
  {skillLineVariantID = 2828, categoryID = category, quests = {70561, 70558, 70559, 70560},                                           itemID = 198607, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 38.9, y = 73.3, hint = "Complete a quest from |cffffff00Talendara|r <Inscription Trainer>."}},
  {skillLineVariantID = 2828, categoryID = category, quests = {70592},                                                                itemID = 198607, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 35.4, y = 58.7, hint = "Complete a quest from Azley."}},
  -- Dragonflight: Jewelcrafting
  {skillLineVariantID = 2829, categoryID = category, quests = {75362, 66950, 66949, 72428, 66516, 75362, 75602, 77892, 77912},        itemID = 198612, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Kayann, Temnaayu, Gnoklin Quirkcoil, Kayann, Magnolia Oaken|r."}},
  {skillLineVariantID = 2829, categoryID = category, quests = {70565, 70564, 70563, 70562},                                           itemID = 198612, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 40.7, y = 61.2, hint = "Complete a quest from |cffffff00Tuluradormi|r <Jewelcrafting Trainer>."}},
  {skillLineVariantID = 2829, categoryID = category, quests = {70593},                                                                itemID = 198612, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 35.4, y = 58.7, hint = "Complete a quest from Azley."}},
  -- Dragonflight: Leatherworking
  {skillLineVariantID = 2830, categoryID = category, quests = {66363, 66951, 72407, 66364, 75354, 75368, 77945, 77946},               itemID = 198613, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Dhurrel, Temnaayu, Kayann, Magnolia Oaken|r."}},
  {skillLineVariantID = 2830, categoryID = category, quests = {70571, 70569, 70568, 70567},                                           itemID = 198613, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 28.7, y = 61.4, hint = "Complete a quest from |cffffff00Hideshaper Koruz|r <Leatherworking Trainer>."}},
  {skillLineVariantID = 2830, categoryID = category, quests = {70594},                                                                itemID = 198613, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 35.4, y = 58.7, hint = "Complete a quest from Azley."}},
  -- Dragonflight: Mining
  {skillLineVariantID = 2833, categoryID = category, quests = {72156, 70617, 70618, 72157},                                           itemID = 199122, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 39.0, y = 51.3, hint = "Complete a quest from |cffffff00Sekita the Burrower|r <Mining Trainer>."}},
  -- Dragonflight: Skinning
  {skillLineVariantID = 2834, categoryID = category, quests = {72158, 70619, 72159, 70620},                                           itemID = 199128, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 28.7, y = 60.5, hint = "Complete a quest from |cffffff00Ralathor the Rugged|r <Skinning Trainer>."}},
  -- Dragonflight: Tailoring
  {skillLineVariantID = 2831, categoryID = category, quests = {66952, 72410, 75407, 75600, 77949, 77947, 66899},                      itemID = 198609, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 36.7, y = 62.5, hint = "Complete a quest from |cffffff00Dothenos, Gnoklin Quirkcoil, Kayann, Magnolia Oaken|r."}},
  {skillLineVariantID = 2831, categoryID = category, quests = {70587, 70586, 70572, 70582},                                           itemID = 198609, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 31.9, y = 67.1, hint = "Complete a quest from |cffffff00Threadfinder Fulafong|r <Tailoring Trainer>."}},
  {skillLineVariantID = 2831, categoryID = category, quests = {70595},                                                                itemID = 198609, points = 3, limit = 1,         loc = {m = Constants.map.Valdrakken, x = 35.4, y = 58.7, hint = "Complete a quest from Azley."}},
}

Data:RegisterObjectives(objectives)
