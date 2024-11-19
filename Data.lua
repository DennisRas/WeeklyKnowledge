---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = {}
addon.Data = Data

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local Utils = addon.Utils
local AceDB = LibStub("AceDB-3.0")

---@type WK_DataCache
Data.cache = {
  isDarkmoonOpen = false,
  inCombat = false,
  items = {},
  mapInfo = {},
  weeklyProgress = {},
}

Data.DBVersion = 8
Data.defaultDB = {
  ---@type WK_DefaultGlobal
  global = {
    minimap = {
      minimapPos = 235,
      hide = false,
      lock = false
    },
    characters = {},
    main = {
      hiddenColumns = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      checklistHelpTipClosed = false,
    },
    checklist = {
      open = false,
      hiddenColumns = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      windowTitlebar = true,
      hideCompletedObjectives = false,
      hideInCombat = false,
      hideInDungeons = true,
      hideTable = false,
      hideTableHeader = false,
      hideUniqueObjectives = false,
      hideUniqueVendorObjectives = false,
    },
  }
}

---@type WK_Character
Data.defaultCharacter = {
  enabled = true,
  lastUpdate = 0,
  GUID = "",
  name = "",
  realmName = "",
  level = 0,
  factionEnglish = "",
  factionName = "",
  raceID = 0,
  raceEnglish = "",
  raceName = "",
  classID = 0,
  classFile = nil,
  className = "",
  professions = {},
  completed = {},
}

---@type WK_ObjectiveType[]
Data.ObjectiveTypes = {
  {
    id = Enum.WK_Objectives.Unique,
    name = L["Uniques"],
    description = L["Uniques_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),
    type = "item",
    repeatable = L["NonRepeatable"],
  },
  {
    id = Enum.WK_Objectives.Treatise,
    name = L["Treatise"],
    description = L["Treatise_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode(L["Weekly"]),
    type = "item",
    repeatable = L["Weekly"],
  },
  {
    id = Enum.WK_Objectives.ArtisanQuest,
    name = L["Artisan"],
    description = L["ArtisanQuest_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode(L["Weekly"]),
    type = "quest",
    repeatable = L["Weekly"],
  },
  {
    id = Enum.WK_Objectives.Treasure,
    name = L["Treasure"],
    description = L["Treasure_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode(L["Weekly"]),
    type = "item",
    repeatable = L["Weekly"],
  },
  {
    id = Enum.WK_Objectives.Gathering,
    name = L["Gathering"],
    description = L["Gathering_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode(L["Weekly"]),
    type = "item",
    repeatable = L["Weekly"],
  },
  {
    id = Enum.WK_Objectives.TrainerQuest,
    name = L["Trainer"],
    description = L["TrainerQuest_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode(L["Weekly"]),
    type = "quest",
    repeatable = L["Weekly"],
  },
  {
    id = Enum.WK_Objectives.DarkmoonQuest,
    name = L["Darkmoon"],
    description = L["DarkmoonQuest_Desc"] .. WHITE_FONT_COLOR:WrapTextInColorCode(L["Monthly"]),
    type = "quest",
    repeatable = L["Monthly"],
  },
}

---@type WK_Objective[]
Data.Objectives = {
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {81146},                             itemID = 227409, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {81147},                             itemID = 227420, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {81148},                             itemID = 227431, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {82633},                             itemID = 224024, points = 10, loc = {m = 2213, x = 45.6, y = 13.2, hint = L["Vendor_Siesbarg_Hint"]},                   requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83058},                             itemID = 224645, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = L["Vendor_Auditor_Balwurz_Hint"]},            requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Alchemy Notes
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83840},                             itemID = 226265, points = 3,  loc = {m = 2339, x = 32.5, y = 60.5, hint = L["Item_226265_Hint"]}},                      -- Earthen Iron Powder
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83841},                             itemID = 226266, points = 3,  loc = {m = 2248, x = 57.7, y = 61.8, hint = L["Item_226266_Hint"]}},                      -- Metal Dornogal Frame
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83842},                             itemID = 226267, points = 3,  loc = {m = 2214, x = 42.2, y = 24.1, hint = L["Item_226267_Hint"]}},                      -- Reinforced Beaker
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83843},                             itemID = 226268, points = 3,  loc = {m = 2214, x = 64.9, y = 61.8, hint = L["Item_226268_Hint"]}},                      -- Engraved Stirring Rod
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83844},                             itemID = 226269, points = 3,  loc = {m = 2215, x = 42.6, y = 55.1, hint = L["Item_226269_Hint"]}},                      -- Chemist's Purified Water
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83845},                             itemID = 226270, points = 3,  loc = {m = 2215, x = 41.7, y = 55.8, hint = L["Item_226270_Hint"]}},                      -- Sanctified Mortar and Pestle
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83846},                             itemID = 226271, points = 3,  loc = {m = 2213, x = 45.5, y = 13.3, hint = L["Item_226271_Hint"]}},                      -- Nerubian Mixing Salts
  {professionID = 171, typeID = Enum.WK_Objectives.Unique,        quests = {83847},                             itemID = 226272, points = 3,  loc = {m = 2255, x = 42.9, y = 57.3, hint = L["Item_226272_Hint"]}},                      -- Dark Apothecary's Vial
  {professionID = 171, typeID = Enum.WK_Objectives.Treatise,      quests = {83725},                             itemID = 222546, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 171, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84133},                             itemID = 228773, points = 2,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 171, typeID = Enum.WK_Objectives.Treasure,      quests = {83253},                             itemID = 225234, points = 2,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 171, typeID = Enum.WK_Objectives.Treasure,      quests = {83255},                             itemID = 225235, points = 2,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 171, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29506},                             itemID = 0,      points = 3,  loc = {m = 407, x = 50.2, y = 69.6, hint = L["Talk_Sylannia_Darkmoon_Quest_29506_Hint"]},             requires = {{type = "item", id = 1645, amount = 5}}},
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {82631},                             itemID = 224038, points = 10, loc = {m = 2213, x = 46.6, y = 21.6, hint = L["Vendor_Rakka_Hint"]},                      requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83059},                             itemID = 224647, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = L["Vendor_Auditor_Balwurz_Hint"]},            requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Blacksmithing Notes
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83848},                             itemID = 226276, points = 3,  loc = {m = 2248, x = 59.8, y = 61.9, hint = L["Item_226276_Hint"]}},                      -- Ancient Earthen Anvil
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83849},                             itemID = 226277, points = 3,  loc = {m = 2339, x = 47.7, y = 26.5, hint = L["Item_226277_Hint"]}},                      -- Dornogal Hammer
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83850},                             itemID = 226278, points = 3,  loc = {m = 2214, x = 47.7, y = 33.2, hint = L["Item_226278_Hint"]}},                      -- Ringing Hammer Vise
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83851},                             itemID = 226279, points = 3,  loc = {m = 2214, x = 60.5, y = 53.7, hint = L["Item_226279_Hint"]}},                      -- Earthen Chisels
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83852},                             itemID = 226280, points = 3,  loc = {m = 2215, x = 47.6, y = 61.1, hint = L["Item_226280_Hint"]}},                      -- Holy Flame Forge
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83853},                             itemID = 226281, points = 3,  loc = {m = 2215, x = 44.0, y = 55.6, hint = L["Item_226281_Hint"]}},                      -- Radiant Tongs
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83854},                             itemID = 226282, points = 3,  loc = {m = 2213, x = 46.6, y = 22.7, hint = L["Item_226282_Hint"]}},                      -- Nerubian Smith's Kit
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {83855},                             itemID = 226283, points = 3,  loc = {m = 2255, x = 53.0, y = 51.3, hint = L["Item_226283_Hint"]}},                      -- Spiderling's Wire Brush
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {84226},                             itemID = 227407, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {84227},                             itemID = 227418, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 164, typeID = Enum.WK_Objectives.Unique,        quests = {84228},                             itemID = 227429, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 164, typeID = Enum.WK_Objectives.Treatise,      quests = {83726},                             itemID = 222554, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 164, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84127},                             itemID = 228774, points = 2,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 164, typeID = Enum.WK_Objectives.Treasure,      quests = {83256},                             itemID = 225233, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 164, typeID = Enum.WK_Objectives.Treasure,      quests = {83257},                             itemID = 225232, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 164, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29508},                             itemID = 0,      points = 3,  loc = {m = 407, x = 51.0, y = 81.8, hint = L["Talk_Yebb_Neblegear_Darkmoon_Quest_29508_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {81076},                             itemID = 227411, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {81077},                             itemID = 227422, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {81078},                             itemID = 227433, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {82635},                             itemID = 224050, points = 10, loc = {m = 2213, x = 45.6, y = 33.6, hint = L["Vendor_Iliani_Hint"]},                     requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83060},                             itemID = 224652, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = L["Vendor_Auditor_Balwurz_Hint"]},            requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Enchanting Notes
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83856},                             itemID = 226284, points = 3,  loc = {m = 2248, x = 57.6, y = 61.6, hint = L["Item_226284_Hint"]}},                      -- Grinded Earthen Gem
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83859},                             itemID = 226285, points = 3,  loc = {m = 2339, x = 57.9, y = 56.9, hint = L["Item_226285_Hint"]}},                      -- Silver Dornogal Rod
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83860},                             itemID = 226286, points = 3,  loc = {m = 2214, x = 44.6, y = 22.2, hint = L["Item_226286_Hint"]}},                      -- Soot-Coated Orb
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83861},                             itemID = 226287, points = 3,  loc = {m = 2214, x = 67.1, y = 65.9, hint = L["Item_226287_Hint"]}},                      -- Animated Enchanting Dust
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83862},                             itemID = 226288, points = 3,  loc = {m = 2215, x = 40.1, y = 70.5, hint = L["Item_226288_Hint"]}},                      -- Essence of Holy Fire
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83863},                             itemID = 226289, points = 3,  loc = {m = 2215, x = 48.6, y = 64.5, hint = L["Item_226289_Hint"]}},                      -- Enchanted Arathi Scroll
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83864},                             itemID = 226290, points = 3,  loc = {m = 2213, x = 61.6, y = 21.9, hint = L["Item_226290_Hint"]}},                      -- Book of Dark Magic
  {professionID = 333, typeID = Enum.WK_Objectives.Unique,        quests = {83865},                             itemID = 226291, points = 3,  loc = {m = 2255, x = 57.3, y = 44.1, hint = L["Item_226291_Hint"]}},                      -- Void Shard
  {professionID = 333, typeID = Enum.WK_Objectives.Treatise,      quests = {83727},                             itemID = 222550, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.Treasure,      quests = {83258},                             itemID = 225231, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.Treasure,      quests = {83259},                             itemID = 225230, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.Gathering,     quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1,  loc = {hint = L["Randomly_Looted_Disenchanting_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.Gathering,     quests = {84295},                             itemID = 227661, points = 4,  loc = {hint = L["Randomly_Looted_Disenchanting_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.TrainerQuest,  quests = {84084, 84085, 84086},               itemID = 227667, points = 3,  limit = 1,                                                                                loc = {m = 2339, x = 52.8, y = 71.2, hint = L["Talk_Enchanting_Trainer_Hint"]}},
  {professionID = 333, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29510},                             itemID = 0,      points = 3,  loc = {m = 407, x = 53.2, y = 76.6, hint = L["Talk_Sayge_Darkmoon_Quest_29510_Hint"]}},
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {82632},                             itemID = 224052, points = 10, loc = {m = 2213, x = 58.2, y = 31.6, hint = L["Vendor_Rukku_Hint"]},                      requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83063},                             itemID = 224653, points = 10, loc = {m = 2214, x = 47.2, y = 32.8, hint = L["Vendor_Waxmonger_Squick_Hint"]},           requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83866},                             itemID = 226292, points = 3,  loc = {m = 2248, x = 61.3, y = 69.6, hint = L["Item_226292_Hint"]}},                      -- Rock Engineer's Wrench
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83867},                             itemID = 226293, points = 3,  loc = {m = 2339, x = 64.7, y = 52.7, hint = L["Item_226293_Hint"]}},                      -- Dornogal Spectacles
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83868},                             itemID = 226294, points = 3,  loc = {m = 2214, x = 42.6, y = 27.3, hint = L["Item_226294_Hint"]}},                      -- Inert Mining Bomb
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83869},                             itemID = 226295, points = 3,  loc = {m = 2214, x = 64.5, y = 58.8, hint = L["Item_226295_Hint"]}},                      -- Earthen Construct Blueprints
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83870},                             itemID = 226296, points = 3,  loc = {m = 2215, x = 46.4, y = 61.5, hint = L["Item_226296_Hint"]}},                      -- Holy Firework Dud
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83871},                             itemID = 226297, points = 3,  loc = {m = 2215, x = 41.6, y = 48.9, hint = L["Item_226297_Hint"]}},                      -- Arathi Safety Gloves
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83872},                             itemID = 226298, points = 3,  loc = {m = 2255, x = 56.8, y = 38.7, hint = L["Item_226298_Hint"]}},                      -- Puppeted Mechanical Spider
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {83873},                             itemID = 226299, points = 3,  loc = {m = 2213, x = 63.1, y = 11.5, hint = L["Item_226299_Hint"]}},                      -- Emptied Venom Canister
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {84229},                             itemID = 227412, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {84230},                             itemID = 227423, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 202, typeID = Enum.WK_Objectives.Unique,        quests = {84231},                             itemID = 227434, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 202, typeID = Enum.WK_Objectives.Treatise,      quests = {83728},                             itemID = 222621, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 202, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84128},                             itemID = 228775, points = 1,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 202, typeID = Enum.WK_Objectives.Treasure,      quests = {83260},                             itemID = 225228, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 202, typeID = Enum.WK_Objectives.Treasure,      quests = {83261},                             itemID = 225229, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 202, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29511},                             itemID = 0,      points = 3,  loc = {m = 407, x = 49.6, y = 60.8, hint = L["Talk_Rinling_Darkmoon_Quest_29511_Hint"]}},
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {81422},                             itemID = 227415, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {81423},                             itemID = 227426, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {81424},                             itemID = 227437, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {82630},                             itemID = 224023, points = 10, loc = {m = 2213, x = 47.0, y = 16.2, hint = L["Vendor_Llyot_hint"]},                      requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83066},                             itemID = 224656, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = L["Vendor_Auralia_Steelstrike_Hint"]},        requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83874},                             itemID = 226300, points = 3,  loc = {m = 2248, x = 57.6, y = 61.5, hint = L["Item_226300_Hint"]}},                      -- Ancient Flower
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83875},                             itemID = 226301, points = 3,  loc = {m = 2339, x = 59.2, y = 23.7, hint = L["Item_226301_Hint"]}},                      -- Dornogal Gardening Scythe
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83876},                             itemID = 226302, points = 3,  loc = {m = 2214, x = 48.3, y = 35.0, hint = L["Item_226302_Hint"]}},                      -- Earthen Digging Fork
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83877},                             itemID = 226303, points = 3,  loc = {m = 2214, x = 52.9, y = 65.8, hint = L["Item_226303_Hint"]}},                      -- Fungarian Slicer's Knife
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83878},                             itemID = 226304, points = 3,  loc = {m = 2215, x = 47.8, y = 63.3, hint = L["Item_226304_Hint"]}},                      -- Arathi Garden Trowel
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83879},                             itemID = 226305, points = 3,  loc = {m = 2215, x = 35.9, y = 55.0, hint = L["Item_226305_Hint"]}},                      -- Arathi Herb Pruner
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83880},                             itemID = 226306, points = 3,  loc = {m = 2213, x = 54.7, y = 20.8, hint = L["Item_226306_Hint"]}},                      -- Web-Entangled Lotus
  {professionID = 182, typeID = Enum.WK_Objectives.Unique,        quests = {83881},                             itemID = 226307, points = 3,  loc = {m = 2213, x = 46.7, y = 16.0, hint = L["Item_226307_Hint"]}},                      -- Tunneler's Shovel
  {professionID = 182, typeID = Enum.WK_Objectives.Treatise,      quests = {83729},                             itemID = 222552, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 182, typeID = Enum.WK_Objectives.Gathering,     quests = {81416, 81417, 81418, 81419, 81420}, itemID = 224264, points = 1,  loc = {hint = L["Randomly_Looted_Herbs_Hint"]}},
  {professionID = 182, typeID = Enum.WK_Objectives.Gathering,     quests = {81421},                             itemID = 224265, points = 4,  loc = {hint = L["Randomly_Looted_Herbs_Hint"]}},
  {professionID = 182, typeID = Enum.WK_Objectives.TrainerQuest,  quests = {82970, 82958, 82965, 82916, 82962}, itemID = 224817, points = 3,  limit = 1,                                                                                loc = {m = 2339, x = 44.8, y = 69.4, hint = L["Talk_Herbalism_Trainer_Hint"]}},
  {professionID = 182, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29514},                             itemID = 0,      points = 3,  loc = {m = 407, x = 55.0, y = 70.6, hint = L["Talk_Chronos_Darkmoon_Quest_29514_Hint"]}},
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {80749},                             itemID = 227408, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {80750},                             itemID = 227419, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {80751},                             itemID = 227430, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {82636},                             itemID = 224053, points = 10, loc = {m = 2213, x = 42.2, y = 26.8, hint = L["Vendor_Nuel_Prill_Hint"]},                 requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83064},                             itemID = 224654, points = 10, loc = {m = 2214, x = 47.2, y = 32.8, hint = L["Vendor_Waxmonger_Squick_Hint"]},           requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83882},                             itemID = 226308, points = 3,  loc = {m = 2339, x = 57.2, y = 47.1, hint = L["Item_226308_Hint"]}},                      -- Dornogal Scribe's Quill
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83883},                             itemID = 226309, points = 3,  loc = {m = 2248, x = 56.0, y = 60.1, hint = L["Item_226309_Hint"]}},                      -- Historian's Dip Pen
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83884},                             itemID = 226310, points = 3,  loc = {m = 2214, x = 48.5, y = 34.2, hint = L["Item_226310_Hint"]}},                      -- Runic Scroll
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83885},                             itemID = 226311, points = 3,  loc = {m = 2214, x = 62.5, y = 58.1, hint = L["Item_226311_Hint"]}},                      -- Blue Earthen Pigment
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83886},                             itemID = 226312, points = 3,  loc = {m = 2215, x = 43.2, y = 58.9, hint = L["Item_226312_Hint"]}},                      -- Informant's Fountain Pen
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83887},                             itemID = 226313, points = 3,  loc = {m = 2215, x = 42.8, y = 49.1, hint = L["Item_226313_Hint"]}},                      -- Calligrapher's Chiseled Marker
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83888},                             itemID = 226314, points = 3,  loc = {m = 2255, x = 55.9, y = 43.9, hint = L["Item_226314_Hint"]}},                      -- Nerubian Texts
  {professionID = 773, typeID = Enum.WK_Objectives.Unique,        quests = {83889},                             itemID = 226315, points = 3,  loc = {m = 2213, x = 50.1, y = 31.0, hint = L["Item_226315_Hint"]}},                      -- Venomancer's Ink Well
  {professionID = 773, typeID = Enum.WK_Objectives.Treatise,      quests = {83730},                             itemID = 222548, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 773, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84129},                             itemID = 228776, points = 2,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 773, typeID = Enum.WK_Objectives.Treasure,      quests = {83262},                             itemID = 225227, points = 2,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 773, typeID = Enum.WK_Objectives.Treasure,      quests = {83264},                             itemID = 225226, points = 2,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 773, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29515},                             itemID = 0,      points = 3,  loc = {m = 407, x = 53.2, y = 76.6, hint = L["Talk_Sayge_Darkmoon_Quest_29515_Hint"]},    requires = {{type = "item", id = 39354, amount = 5}}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {81259},                             itemID = 227413, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {81260},                             itemID = 227424, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {81261},                             itemID = 227435, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {82637},                             itemID = 224054, points = 10, loc = {m = 2213, x = 47.6, y = 18.6, hint = L["Vendor_Alvus_Valavulu_Hint"]},             requires = {{type = "currency", id = 3056, amount = 565}}}, -- Emergent Crystals of the Surface-Dwellers
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83065},                             itemID = 224655, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = L["Vendor_Auralia_Steelstrike_Hint"]},        requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83890},                             itemID = 226316, points = 3,  loc = {m = 2248, x = 63.5, y = 66.8, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83891},                             itemID = 226317, points = 3,  loc = {m = 2339, x = 34.9, y = 52.3, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83892},                             itemID = 226318, points = 3,  loc = {m = 2214, x = 48.5, y = 35.2, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83893},                             itemID = 226319, points = 3,  loc = {m = 2214, x = 57.0, y = 54.6, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83894},                             itemID = 226320, points = 3,  loc = {m = 2215, x = 47.5, y = 60.7, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83895},                             itemID = 226321, points = 3,  loc = {m = 2215, x = 44.7, y = 50.9, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83896},                             itemID = 226322, points = 3,  loc = {m = 2213, x = 47.7, y = 19.5, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Unique,        quests = {83897},                             itemID = 226323, points = 3,  loc = {m = 2255, x = 56.1, y = 58.7, hint = L["Object_Location_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Treatise,      quests = {83731},                             itemID = 222551, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84130},                             itemID = 228777, points = 2,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Treasure,      quests = {83265},                             itemID = 225224, points = 2,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 755, typeID = Enum.WK_Objectives.Treasure,      quests = {83266},                             itemID = 225225, points = 2,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},                                             -- Deepstone Fragment
  {professionID = 755, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29516},                             itemID = 0,      points = 3,  loc = {m = 407, x = 55.0, y = 70.6, hint = L["Talk_Chronos_Darkmoon_Quest_29516_Hint"]}},
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {80978},                             itemID = 227414, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {80979},                             itemID = 227425, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {80980},                             itemID = 227436, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {82626},                             itemID = 224056, points = 10, loc = {m = 2213, x = 43.5, y = 19.7, hint = L["Vendor_Kama_Hint"]},                       requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83068},                             itemID = 224658, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = L["Vendor_Auralia_Steelstrike_Hint"]},        requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83898},                             itemID = 226324, points = 3,  loc = {m = 2339, x = 68.1, y = 23.3, hint = L["Item_226324_Hint"]}},                      -- Earthen Lacing Tools
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83899},                             itemID = 226325, points = 3,  loc = {m = 2248, x = 58.7, y = 30.7, hint = L["Item_226325_Hint"]}},                      -- Dornogal Craftman's Flat Knife
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83900},                             itemID = 226326, points = 3,  loc = {m = 2214, x = 47.1, y = 34.8, hint = L["Item_226326_Hint"]}},                      -- Underground Stropping Compound
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83901},                             itemID = 226327, points = 3,  loc = {m = 2214, x = 64.3, y = 65.2, hint = L["Item_226327_Hint"]}},                      -- Earthen Awl
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83902},                             itemID = 226328, points = 3,  loc = {m = 2215, x = 47.5, y = 65.1, hint = L["Item_226328_Hint"]}},                      -- Arathi Beveler Set
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83903},                             itemID = 226329, points = 3,  loc = {m = 2215, x = 41.5, y = 57.8, hint = L["Item_226329_Hint"]}},                      -- Arathi Leather Burnisher
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83904},                             itemID = 226330, points = 3,  loc = {m = 2213, x = 55.2, y = 26.8, hint = L["Item_226330_Hint"]}},                      -- Nerubian Tanning Mallet
  {professionID = 165, typeID = Enum.WK_Objectives.Unique,        quests = {83905},                             itemID = 226331, points = 3,  loc = {m = 2255, x = 60.0, y = 53.9, hint = L["Item_226331_Hint"]}},                      -- Curved Nerubian Skinning Knife
  {professionID = 165, typeID = Enum.WK_Objectives.Treatise,      quests = {83732},                             itemID = 222549, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 165, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84131},                             itemID = 228778, points = 2,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 165, typeID = Enum.WK_Objectives.Treasure,      quests = {83267},                             itemID = 225223, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 165, typeID = Enum.WK_Objectives.Treasure,      quests = {83268},                             itemID = 225222, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 165, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29517},                             itemID = 0,      points = 3,  loc = {m = 407, x = 49.6, y = 60.8, hint = L["Talk_Rinling_Darkmoon_Quest_29517_Hint"]},  requires = {{type = "item", id = 6529, amount = 10}, {type = "item", id = 2320, amount = 5}, {type = "item", id = 6260, amount = 5}}},
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {81390},                             itemID = 227416, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {81391},                             itemID = 227427, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {81392},                             itemID = 227438, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {82614},                             itemID = 224055, points = 10, loc = {m = 2213, x = 46.6, y = 21.6, hint = L["Vendor_Rakka_Hint"]},                      requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83062},                             itemID = 224651, points = 10, loc = {m = 2214, x = 47.2, y = 32.8, hint = L["Vendor_Waxmonger_Squick_Hint"]},           requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83906},                             itemID = 226332, points = 3,  loc = {m = 2248, x = 58.2, y = 62.0, hint = L["Item_226332_Hint"]}},                      -- Earthen Miner's Gavel
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83907},                             itemID = 226333, points = 3,  loc = {m = 2339, x = 36.6, y = 79.3, hint = L["Item_226333_Hint"]}},                      -- Dornogal Chisel
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83908},                             itemID = 226334, points = 3,  loc = {m = 2214, x = 49.5, y = 27.5, hint = L["Item_226334_Hint"]}},                      -- Earthen Excavator's Shovel
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83909},                             itemID = 226335, points = 3,  loc = {m = 2214, x = 66.3, y = 66.2, hint = L["Item_226335_Hint"]}},                      -- Regenerating Ore
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83910},                             itemID = 226336, points = 3,  loc = {m = 2215, x = 46.1, y = 64.5, hint = L["Item_226336_Hint"]}},                      -- Arathi Precision Drill
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83911},                             itemID = 226337, points = 3,  loc = {m = 2215, x = 43.1, y = 56.8, hint = L["Item_226337_Hint"]}},                      -- Devout Archaeologist's Excavator
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83912},                             itemID = 226338, points = 3,  loc = {m = 2213, x = 46.8, y = 21.4, hint = L["Item_226338_Hint"]}},                      -- Heavy Spider Crusher
  {professionID = 186, typeID = Enum.WK_Objectives.Unique,        quests = {83913},                             itemID = 226339, points = 3,  loc = {m = 2213, x = 48.1, y = 40.7, hint = L["Item_226339_Hint"]}},                      -- Nerubian Mining Supplies
  {professionID = 186, typeID = Enum.WK_Objectives.Treatise,      quests = {83733},                             itemID = 222553, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 186, typeID = Enum.WK_Objectives.Gathering,     quests = {83050, 83051, 83052, 83053, 83054}, itemID = 224583, points = 1,  loc = {hint = L["Randomly_Looted_Mining_Hint"]}},
  {professionID = 186, typeID = Enum.WK_Objectives.Gathering,     quests = {83049},                             itemID = 224584, points = 3,  loc = {hint = L["Randomly_Looted_Mining_Hint"]}},
  {professionID = 186, typeID = Enum.WK_Objectives.TrainerQuest,  quests = {83104, 83105, 83103, 83106, 83102}, itemID = 224818, points = 3,  limit = 1,                                                                                loc = {m = 2339, x = 52.6, y = 52.6, hint = L["Talk_Mining_Trainer_Hint"]}},
  {professionID = 186, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29518},                             itemID = 0,      points = 3,  loc = {m = 407, x = 49.6, y = 60.8, hint = L["Talk_Rinling_Darkmoon_Quest_29518_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {82596},                             itemID = 224007, points = 10, loc = {m = 2213, x = 43.5, y = 19.7, hint = L["Vendor_Kama_Hint"]},                       requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83067},                             itemID = 224657, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = L["Vendor_Auralia_Steelstrike_Hint"]},        requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83914},                             itemID = 226340, points = 3,  loc = {m = 2339, x = 28.7, y = 51.8, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83915},                             itemID = 226341, points = 3,  loc = {m = 2248, x = 60.0, y = 28.0, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83916},                             itemID = 226342, points = 3,  loc = {m = 2214, x = 47.3, y = 28.4, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83917},                             itemID = 226343, points = 3,  loc = {m = 2214, x = 65.8, y = 61.9, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83918},                             itemID = 226344, points = 3,  loc = {m = 2215, x = 49.3, y = 62.1, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83919},                             itemID = 226345, points = 3,  loc = {m = 2215, x = 42.3, y = 53.9, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83920},                             itemID = 226346, points = 3,  loc = {m = 2213, x = 44.6, y = 49.3, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {83921},                             itemID = 226347, points = 3,  loc = {m = 2255, x = 56.5, y = 55.2, hint = L["Object_Location_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {84232},                             itemID = 227417, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {84233},                             itemID = 227428, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 393, typeID = Enum.WK_Objectives.Unique,        quests = {84234},                             itemID = 227439, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 393, typeID = Enum.WK_Objectives.Treatise,      quests = {83734},                             itemID = 222649, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Gathering,     quests = {81459, 81460, 81461, 81462, 81463}, itemID = 224780, points = 1,  loc = {hint = L["Randomly_Looted_Skinning_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.Gathering,     quests = {81464},                             itemID = 224781, points = 2,  loc = {hint = L["Randomly_Looted_Skinning_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.TrainerQuest,  quests = {83097, 83098, 83100, 82992, 82993}, itemID = 224807, points = 3,  limit = 1,                                                                                loc = {m = 2339, x = 54.4, y = 57.6, hint = L["Talk_Skinning_Trainer_Hint"]}},
  {professionID = 393, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29519},                             itemID = 0,      points = 3,  loc = {m = 407, x = 55.0, y = 70.6, hint = L["Talk_Chronos_Darkmoon_Quest_29519_Hint"]}},
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {80871},                             itemID = 227410, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 200}}},
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {80872},                             itemID = 227421, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 300}}},
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {80873},                             itemID = 227432, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = L["Vendor_Lyrendal_Hint"]},                   requires = {{type = "item", id = 210814, amount = 400}}},
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {82634},                             itemID = 224036, points = 10, loc = {m = 2213, x = 50.2, y = 16.8, hint = L["Vendor_Saaria_Hint"]},                     requires = {{type = "currency", id = 3056, amount = 565}}},
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83061},                             itemID = 224648, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = L["Vendor_Auditor_Balwurz_Hint"]},            requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Tailoring Notes
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83922},                             itemID = 226348, points = 3,  loc = {m = 2339, x = 61.5, y = 18.7, hint = L["Item_226348_Hint"]}},                      -- Dornogal Seam Ripper
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83923},                             itemID = 226349, points = 3,  loc = {m = 2248, x = 56.2, y = 61.0, hint = L["Item_226349_Hint"]}},                      -- Earthen Tape Measure
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83924},                             itemID = 226350, points = 3,  loc = {m = 2214, x = 48.9, y = 32.8, hint = L["Item_226350_Hint"]}},                      -- Runed Earthen Pins
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83925},                             itemID = 226351, points = 3,  loc = {m = 2214, x = 64.2, y = 60.3, hint = L["Item_226351_Hint"]}},                      -- Earthen Sticher's Snips
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83926},                             itemID = 226352, points = 3,  loc = {m = 2215, x = 49.3, y = 62.3, hint = L["Item_226352_Hint"]}},                      -- Arathi Rotary Cutter
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83927},                             itemID = 226353, points = 3,  loc = {m = 2215, x = 40.1, y = 68.1, hint = L["Item_226353_Hint"]}},                      -- Royal Outfitter's Protractor
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83928},                             itemID = 226354, points = 3,  loc = {m = 2255, x = 53.3, y = 53.0, hint = L["Item_226354_Hint"]}},                      -- Nerubian Quilt
  {professionID = 197, typeID = Enum.WK_Objectives.Unique,        quests = {83929},                             itemID = 226355, points = 3,  loc = {m = 2213, x = 50.5, y = 16.7, hint = L["Item_226355_Hint"]}},                      -- Nerubian's Pincushion
  {professionID = 197, typeID = Enum.WK_Objectives.Treatise,      quests = {83735},                             itemID = 222547, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = L["Crafting_Order_Inscription_Hint"]}},
  {professionID = 197, typeID = Enum.WK_Objectives.ArtisanQuest,  quests = {84132},                             itemID = 228779, points = 2,  loc = {m = 2339, x = 59.2, y = 55.6, hint = L["Quest_Kala_Clayhoof_Hint"]}},
  {professionID = 197, typeID = Enum.WK_Objectives.Treasure,      quests = {83269},                             itemID = 225221, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 197, typeID = Enum.WK_Objectives.Treasure,      quests = {83270},                             itemID = 225220, points = 1,  loc = {hint = L["Treasures_And_Dirt_Hint"]}},
  {professionID = 197, typeID = Enum.WK_Objectives.DarkmoonQuest, quests = {29520},                             itemID = 0,      points = 3,  loc = {m = 407, x = 55.6, y = 55.8, hint = L["Talk_Selina_Dourman_Darkmoon_Quest_29520_Hint"]},       requires = {{type = "item", id = 2320, amount = 1}, {type = "item", id = 2604, amount = 1}, {type = "item", id = 6260, amount = 1}}},
}

---@type WK_Profession[]
Data.Professions = {
  {
    name = L["Alchemy"],
    skillLineID = 171,
    skillLineVariantID = 2871,
    spellID = 423321,
    catchUpCurrencyID = 3057,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228724,
  },
  {
    name = L["Blacksmithing"],
    skillLineID = 164,
    skillLineVariantID = 2872,
    spellID = 423332,
    catchUpCurrencyID = 3058,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228726,
  },
  {
    name = L["Enchanting"],
    skillLineID = 333,
    skillLineVariantID = 2874,
    spellID = 423334,
    catchUpCurrencyID = 3059,
    catchUpWeeklyCap = 0,
    catchUpItemID = 227662,
  },
  {
    name = L["Engineering"],
    skillLineID = 202,
    skillLineVariantID = 2875,
    spellID = 423335,
    catchUpCurrencyID = 3060,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228730,
  },
  {
    name = L["Herbalism"],
    skillLineID = 182,
    skillLineVariantID = 2877,
    spellID = 441327,
    catchUpCurrencyID = 3061,
    catchUpWeeklyCap = 0,
    catchUpItemID = 224835,
  },
  {
    name = L["Inscription"],
    skillLineID = 773,
    skillLineVariantID = 2878,
    spellID = 423338,
    catchUpCurrencyID = 3062,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228732,
  },
  {
    name = L["Jewelcrafting"],
    skillLineID = 755,
    skillLineVariantID = 2879,
    spellID = 423339,
    catchUpCurrencyID = 3063,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228734,
  },
  {
    name = L["Leatherworking"],
    skillLineID = 165,
    skillLineVariantID = 2880,
    spellID = 423340,
    catchUpCurrencyID = 3064,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228736,
  },
  {
    name = L["Mining"],
    skillLineID = 186,
    skillLineVariantID = 2881,
    spellID = 423341,
    catchUpCurrencyID = 3065,
    catchUpWeeklyCap = 0,
    catchUpItemID = 224838,
  },
  {
    name = L["Skinning"],
    skillLineID = 393,
    skillLineVariantID = 2882,
    spellID = 423342,
    catchUpCurrencyID = 3066,
    catchUpWeeklyCap = 0,
    catchUpItemID = 224782,
  },
  {
    name = L["Tailoring"],
    skillLineID = 197,
    skillLineVariantID = 2883,
    spellID = 423343,
    catchUpCurrencyID = 3067,
    catchUpWeeklyCap = 0,
    catchUpItemID = 228738,
  }
}

function Data:InitDB()
  ---@class AceDBObject-3.0
  ---@field global WK_DefaultGlobal
  self.db = AceDB:New(
    "WeeklyKnowledgeDB",
    self.defaultDB,
    true
  )
end

function Data:MigrateDB()
  if type(self.db.global.DBVersion) ~= "number" then
    self.db.global.DBVersion = self.DBVersion
  end
  if self.db.global.DBVersion < self.DBVersion then
    -- Set up new character data structure
    if self.db.global.DBVersion == 1 then
      for characterGUID, character in pairs(self.db.global.characters) do
        character.GUID = characterGUID
        character.lastUpdate = 0
        character.enabled = true
        ---@diagnostic disable-next-line: undefined-field
        character.classID = character.class
        ---@diagnostic disable-next-line: undefined-field
        character.realmName = character.realm
        ---@diagnostic disable-next-line: inject-field
        character.color = nil

        local remove = true
        for _, characterProfession in pairs(character.professions) do
          ---@diagnostic disable-next-line: undefined-field
          if characterProfession.latestExpansion then
            remove = false
          end
        end
        if remove then
          self.db.global.characters[characterGUID] = nil
        end
      end
    end
    -- Fix missing weekly reset (week 2 of expansion)
    if self.db.global.DBVersion == 2 then
      if not self.db.global.weeklyReset then
        self.db.global.weeklyReset = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
      end
    end
    -- Fix race condition with WK.cache.GUID being empty
    -- Move to new window settings
    if self.db.global.DBVersion == 3 then
      self.db.global.characters[""] = nil
      if self.db.global.hiddenColumns and Utils:TableCount(self.db.global.hiddenColumns) > 0 then
        self.db.global.main.hiddenColumns = Utils:TableCopy(self.db.global.hiddenColumns)
        ---@diagnostic disable-next-line: inject-field
        self.db.global.hiddenColumns = nil
      end
      if self.db.global.windowScale then
        self.db.global.main.windowScale = self.db.global.windowScale
        self.db.global.checklist.windowScale = self.db.global.windowScale
        ---@diagnostic disable-next-line: inject-field
        self.db.global.windowScale = nil
      end
      if self.db.global.windowBackgroundColor then
        self.db.global.main.windowBackgroundColor = self.db.global.windowBackgroundColor
        self.db.global.checklist.windowBackgroundColor = self.db.global.windowBackgroundColor
        ---@diagnostic disable-next-line: inject-field
        self.db.global.windowBackgroundColor = nil
      end
    end
    -- Remove unused attributes and old/broken characters
    if self.db.global.DBVersion == 5 then
      for characterGUID, character in pairs(self.db.global.characters) do
        character.class = nil
        character.color = nil
        character.realm = nil
        if type(character.enabled) ~= "boolean" then
          character.enabled = true
        end
        if type(character.lastUpdate) ~= "number" then
          self.db.global.characters[characterGUID] = nil
        elseif type(character.classID) ~= "number" then
          self.db.global.characters[characterGUID] = nil
        elseif type(character.professions) ~= "table" then
          self.db.global.characters[characterGUID] = nil
        elseif #character.professions < 1 then
          self.db.global.characters[characterGUID] = nil
        end
      end
    end
    if self.db.global.DBVersion == 6 then
      for characterGUID, character in pairs(self.db.global.characters) do
        for _, characterProfession in pairs(character.professions) do
          characterProfession.enabled = true
        end
      end
    end
    self.db.global.DBVersion = self.db.global.DBVersion + 1
    self:MigrateDB()
  end
end

---Clear quest progress after a weekly reset
---@return boolean
function Data:TaskWeeklyReset()
  local hasReset = false
  if type(self.db.global.weeklyReset) == "number" and self.db.global.weeklyReset <= GetServerTime() then
    local questsToReset = {}
    Utils:TableForEach(self.Objectives, function(objective)
      local objectiveType = Utils:TableGet(self.ObjectiveTypes, "id", objective.typeID)
      if not objectiveType or objectiveType.repeatable ~= "Weekly" then return end
      Utils:TableForEach(objective.quests, function(questID)
        questsToReset[questID] = true
      end)
    end)
    for _, character in pairs(self.db.global.characters) do
      if type(character.lastUpdate) == "number" and character.lastUpdate <= self.db.global.weeklyReset then
        for questID in pairs(character.completed) do
          if questsToReset[questID] then
            character.completed[questID] = nil
            hasReset = true
          end
        end
      end
    end
  end
  self.db.global.weeklyReset = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset()
  return hasReset
end

---Get an objective by enum/id
---@param enum Enum.WK_Objectives
---@return WK_ObjectiveType|nil
function Data:GetObjective(enum)
  return Utils:TableFind(self.ObjectiveTypes, function(objective)
    return objective.typeID == enum
  end)
end

---Check to see if the Darkmoon Faire event is live
function Data:ScanCalendar()
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  if currentCalendarTime and currentCalendarTime.monthDay then
    local today = currentCalendarTime.monthDay
    local numEvents = C_Calendar.GetNumDayEvents(0, today)
    if numEvents then
      for i = 1, numEvents do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.eventID == 479 then
          self.cache.isDarkmoonOpen = true
        end
      end
    end
  end
end

---Get stored character by GUID
---@param GUID WOWGUID?
---@return WK_Character|nil
function Data:GetCharacter(GUID)
  if GUID == nil then
    GUID = UnitGUID("player")
  end

  if GUID == nil then
    return nil
  end

  if self.db.global.characters[GUID] == nil then
    self.db.global.characters[GUID] = Utils:TableCopy(self.defaultCharacter)
  end

  self.db.global.characters[GUID].GUID = GUID

  return self.db.global.characters[GUID]
end

function Data:ScanCharacter()
  local character = self:GetCharacter()
  if not character then return end

  -- Update character info
  local localizedRaceName, englishRaceName, raceID = UnitRace("player")
  local localizedClassName, classFile, classID = UnitClass("player")
  local englishFactionName, localizedFactionName = UnitFactionGroup("player")
  character.name = UnitName("player")
  character.realmName = GetRealmName()
  character.level = UnitLevel("player")
  character.factionEnglish = englishFactionName
  character.factionName = localizedFactionName
  character.raceID = raceID
  character.raceEnglish = englishRaceName
  character.raceName = localizedRaceName
  character.classID = classID
  character.classFile = classFile
  character.className = localizedClassName
  character.lastUpdate = GetServerTime()


  -- Profession Tree tracking
  local professions = {}
  local prof1, prof2 = GetProfessions()
  Utils:TableForEach({prof1, prof2}, function(characterProfessionID)
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLineID, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(characterProfessionID)
    if not skillLineID then return end

    local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
      return dataProfession.skillLineID == skillLineID and dataProfession.spellID and IsPlayerSpell(dataProfession.spellID)
    end)
    if not dataProfession then return end

    local characterProfession = Utils:TableFind(character.professions, function(characterProfession)
      return characterProfession.skillLineID == skillLineID
    end)

    if not characterProfession then
      ---@type WK_CharacterProfession
      characterProfession = {
        enabled = true,
        skillLineID = skillLineID,
        level = skillLevel,
        maxLevel = maxSkillLevel,
        knowledgeLevel = 0,
        knowledgeMaxLevel = 0,
        knowledgeUnspent = 0,
        specializations = {}
      }
    end

    characterProfession.skillLineID = skillLineID
    characterProfession.level = skillLevel
    characterProfession.maxLevel = maxSkillLevel
    characterProfession.specializations = {}

    local currencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(dataProfession.skillLineVariantID)
    if currencyInfo and currencyInfo.numAvailable then
      characterProfession.knowledgeUnspent = currencyInfo.numAvailable
    end

    if dataProfession.catchUpCurrencyID then
      local catchUpCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo(dataProfession.catchUpCurrencyID)
      if catchUpCurrencyInfo and catchUpCurrencyInfo.quantity then
        characterProfession.catchUpCurrencyInfo = catchUpCurrencyInfo
      end
    end

    -- Scan knowledge spent/max
    local knowledgeLevel = 0
    local knowledgeMaxLevel = 0
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(dataProfession.skillLineVariantID)
    if configID and configID > 0 then
      local configInfo = C_Traits.GetConfigInfo(configID)
      if configInfo then
        local treeIDs = configInfo.treeIDs
        if treeIDs then
          Utils:TableForEach(treeIDs, function(treeID)
            local treeNodes = C_Traits.GetTreeNodes(treeID)
            if not treeNodes then return end
            local tabInfo = C_ProfSpecs.GetTabInfo(treeID)
            local specialization
            if tabInfo then
              specialization = tabInfo
              specialization.state = C_ProfSpecs.GetStateForTab(treeID, configID)
              specialization.treeID = treeID
              specialization.configID = configID
              specialization.knowledgeLevel = 0
              specialization.knowledgeMaxLevel = 0
            end
            Utils:TableForEach(treeNodes, function(treeNode)
              local nodeInfo = C_Traits.GetNodeInfo(configID, treeNode)
              if not nodeInfo then return end
              if nodeInfo.ranksPurchased > 1 then
                knowledgeLevel = knowledgeLevel + (nodeInfo.currentRank - 1)
                if tabInfo and specialization then
                  specialization.knowledgeLevel = specialization.knowledgeLevel + (nodeInfo.currentRank - 1)
                end
              end
              knowledgeMaxLevel = knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
              if tabInfo and specialization then
                specialization.knowledgeMaxLevel = specialization.knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
              end
            end)
            table.insert(characterProfession.specializations, specialization)
          end)
        end
      end
    end

    characterProfession.knowledgeLevel = knowledgeLevel
    characterProfession.knowledgeMaxLevel = knowledgeMaxLevel

    table.insert(professions, characterProfession)
  end)
  character.professions = professions

  -- Quest tracking
  character.completed = {}
  Utils:TableForEach(self.Objectives, function(objective)
    if not objective.quests then return end
    Utils:TableForEach(objective.quests, function(questID)
      if C_QuestLog.IsQuestFlaggedCompleted(questID) then
        character.completed[questID] = true
      end
    end)
  end)

  -- Let's not track a character without a TWW profession
  if Utils:TableCount(character.professions) < 1 then
    self.db.global.characters[character.GUID] = nil
  end
end

---Get characters
---@param unfiltered boolean?
---@return WK_Character[]
function Data:GetCharacters(unfiltered)
  local characters = Utils:TableFilter(self.db.global.characters, function(character)
    local include = true

    -- Ignore ghost characters (Bug: https://github.com/DennisRas/WeeklyKnowledge/issues/47)
    if not character.name or character.name == "" then
      include = false
    end

    if not unfiltered then
      if not character.enabled then
        include = false
      end
    end

    return include
  end)

  table.sort(characters, function(a, b)
    if type(a.lastUpdate) == "number" and type(b.lastUpdate) == "number" then
      return a.lastUpdate > b.lastUpdate
    end
    return strcmputf8i(a.name, b.name) < 0
  end)

  return characters
end

---Analyze all objectives and their progress
---@return table
function Data:GetWeeklyProgress()
  if type(self.cache.weeklyProgress) == "table" and Utils:TableCount(self.cache.weeklyProgress) > 0 then
    return self.cache.weeklyProgress
  end

  self.cache.weeklyProgress = {}

  Utils:TableForEach(self:GetCharacters(), function(character)
    Utils:TableForEach(character.professions, function(characterProfession)
      local profession = Utils:TableGet(self.Professions, "skillLineID", characterProfession.skillLineID)
      if not profession then return end

      local objectives = Utils:TableFilter(self.Objectives, function(objective)
        return objective.professionID == profession.skillLineID
      end)

      Utils:TableForEach(objectives, function(objective)
        if not objective.quests then return end
        local limit = 0
        local progress = {
          character = character,
          characterProfession = characterProfession,
          profession = profession,
          objective = objective,
          questsCompleted = 0,
          questsTotal = 0,
          pointsEarned = 0,
          pointsTotal = 0,
          items = {},
        }

        if objective.itemID and objective.itemID > 0 then
          progress.items[objective.itemID] = false
        end

        Utils:TableForEach(objective.quests, function(questID)
          progress.questsTotal = progress.questsTotal + 1
          progress.pointsTotal = progress.pointsTotal + objective.points
          if objective.limit and progress.questsTotal > objective.limit then
            progress.pointsTotal = objective.limit * objective.points
            progress.questsTotal = objective.limit
          end
          if character.completed[questID] then
            if objective.itemID and objective.itemID > 0 then
              progress.items[objective.itemID] = true
            end
            progress.questsCompleted = progress.questsCompleted + 1
            progress.pointsEarned = progress.pointsEarned + objective.points
          end
        end)

        if objective.objectiveID == Enum.WK_Objectives.DarkmoonQuest then
          if not self.cache.isDarkmoonOpen then
            progress.questsTotal = 0
          end
        end

        table.insert(self.cache.weeklyProgress, progress)
      end)
    end)
  end)

  return self.cache.weeklyProgress
end
