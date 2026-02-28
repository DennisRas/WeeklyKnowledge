---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = {}
addon.Data = Data

local Utils = addon.Utils
local AceDB = LibStub("AceDB-3.0")

---True when chat messaging lockdown is active (C_ChatInfo.InChatMessagingLockdown). Calendar/ChatInfo APIs may return secrets; skip scan/update.
function Data:IsInChatMessagingLockdown()
  return C_ChatInfo and C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown()
end

---@type WK_DataCache
Data.cache = {
  calendarOpened = false,
  isDarkmoonOpen = false,
  inCombat = false,
  items = {},
  mapInfo = {},
  weeklyProgress = {},
  completedQuests = {},
  tradeSkillRecipes = {},
}

Data.DBVersion = 15
Data.defaultDB = {
  ---@type WK_DefaultGlobal
  global = {
    minimap = {
      minimapPos = 235,
      hide = false,
      lock = false
    },
    characters = {},
    showFullProfessionName = true,
    main = {
      selectedExpansion = nil,
      hiddenColumns = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      checklistHelpTipClosed = false,
      hideLowLevelProfessions = false,
    },
    checklist = {
      selectedExpansion = nil,
      open = false,
      hiddenColumns = {},
      hiddenCategories = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      windowTitlebar = true,
      hideCompletedObjectives = false,
      hideInCombat = false,
      hideInDungeons = true,
      hideTable = false,
      hideTableHeader = false,
    },
  }
}

local MISSING_INFO = 999999999
Data.MISSING_INFO = MISSING_INFO

---@type WK_Character
Data.defaultCharacter = {
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
  recipes = {},
}

---@type WK_Expansion[]
Data.Expansions = {
  {id = Enum.ExpansionLevel.Dragonflight, abbr = "DF",       name = "Dragonflight"},
  {id = Enum.ExpansionLevel.WarWithin,    abbr = "TWW",      name = "The War Within"},
  {id = Enum.ExpansionLevel.Midnight,     abbr = "Midnight", name = "Midnight"},
}

---@type WK_ObjectiveCategory[]
Data.ObjectiveCategories = {
  {id = Enum.WK_ObjectiveCategory.Unique,        name = "Uniques",      description = "These are one-time items found in treasures around the world and sold by vendors.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),                                 type = "item",  repeatable = "No",},
  {id = Enum.WK_ObjectiveCategory.Treatise,      name = "Treatise",     description = "These can be crafted with Inscription. Send a Crafting Order if you don't have the profession.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),                type = "item",  repeatable = "Weekly",  hint = true,},
  {id = Enum.WK_ObjectiveCategory.WeeklyQuest,   name = "Weekly Quest", description = "Complete a quest from your profession trainer or from the Artisan's Consortium.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),                               type = "quest", repeatable = "Weekly",},
  {id = Enum.WK_ObjectiveCategory.Treasure,      name = "Treasure",     description = "These are randomly looted from treasures around the world.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),                                                    type = "item",  repeatable = "Weekly",  hint = true,},
  {id = Enum.WK_ObjectiveCategory.Gathering,     name = "Gathering",    description = "These are randomly looted from gathering nodes around the world.\n\nThese are also looted from Disenchanting.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"), type = "item",  repeatable = "Weekly",},
  {id = Enum.WK_ObjectiveCategory.DarkmoonQuest, name = "Darkmoon",     description = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Monthly"),                                                               type = "quest", repeatable = "Monthly",},
  {id = Enum.WK_ObjectiveCategory.CatchUp,       name = "Catch-Up",     description = "Keep track of your Knowledge Points progress and catch up on points from previous weeks.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Yes"),                         type = "item",  repeatable = "Yes",},
}

---@type WK_Objective[]
Data.Objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81146},                             itemID = 227409, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81147},                             itemID = 227420, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81148},                             itemID = 227431, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82633},                             itemID = 224024, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 45.6, y = 13.2, hint = "This item can be purchased from the vendor Siesbarg in City of Threads."},                                                                                                          requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83058},                             itemID = 224645, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."},                                                                                                               requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}},                                                   -- Jewel-Etched Alchemy Notes
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83840},                             itemID = 226265, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 32.5, y = 60.5, hint = "This item is a keg behind the pillars next to the gate."}},                                                                                                                                                                                                                                                                                    -- Earthen Iron Powder
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83841},                             itemID = 226266, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 57.7, y = 61.8, hint = "This item is a metal frame found on top of a big chest."}},                                                                                                                                                                                                                                                                                  -- Metal Dornogal Frame
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83842},                             itemID = 226267, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 42.2, y = 24.1, hint = "This item is a bottle found on the table inside the building on the bottom floor."}},                                                                                                                                                                                                                                                   -- Reinforced Beaker
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83843},                             itemID = 226268, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 64.9, y = 61.8, hint = "This item is a rod found next to the forge inside the building on the bottom floor."}},                                                                                                                                                                                                                                                 -- Engraved Stirring Rod
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83844},                             itemID = 226269, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 42.6, y = 55.1, hint = "This item is a bottle found on the table near the fountain."}},                                                                                                                                                                                                                                                                              -- Chemist's Purified Water
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83845},                             itemID = 226270, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 41.7, y = 55.8, hint = "This item is a mortar found on the table inside the orphanage building."}},                                                                                                                                                                                                                                                                  -- Sanctified Mortar and Pestle
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83846},                             itemID = 226271, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 45.5, y = 13.3, hint = "This item is a bottle found on the desk inside the building."}},                                                                                                                                                                                                                                                                          -- Nerubian Mixing Salts
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83847},                             itemID = 226272, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 42.9, y = 57.3, hint = "This item is a vial found on the broken table in the building."}},                                                                                                                                                                                                                                                                             -- Dark Apothecary's Vial
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85734},                             itemID = 232499, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87255},                             itemID = 235865, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83725},                             itemID = 222546, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84133},                             itemID = 228773, points = 2,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83253},                             itemID = 225234, points = 2,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83255},                             itemID = 225235, points = 2,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29506},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 50.2, y = 69.6, hint = "Talk to |cff00ff00Sylannia|r at the Darkmoon Faire and complete the quest |cffffff00A Fizzy Fusion|r."},                                                                           requires = {{type = "item", id = 1645, amount = 5}}},
  {skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228724, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82631},                             itemID = 224038, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 46.6, y = 21.6, hint = "This item can be purchased from the vendor Rakka in City of Threads."},                                                                                                             requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83059},                             itemID = 224647, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."},                                                                                                               requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}},                                                   -- Jewel-Etched Blacksmithing Notes
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83848},                             itemID = 226276, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 59.8, y = 61.9, hint = "This item is an anvil found inside the building."}},                                                                                                                                                                                                                                                                                         -- Ancient Earthen Anvil
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83849},                             itemID = 226277, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 47.7, y = 26.5, hint = "This item is a hammer found on a cube."}},                                                                                                                                                                                                                                                                                                     -- Dornogal Hammer
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83850},                             itemID = 226278, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 47.7, y = 33.2, hint = "This item is a hammer vise found next to the forge."}},                                                                                                                                                                                                                                                                                 -- Ringing Hammer Vise
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83851},                             itemID = 226279, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 60.5, y = 53.7, hint = "This item is a chisel found on the ground next to the forge."}},                                                                                                                                                                                                                                                                        -- Earthen Chisels
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83852},                             itemID = 226280, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 47.6, y = 61.1, hint = "This item is an anvil found on the table."}},                                                                                                                                                                                                                                                                                                -- Holy Flame Forge
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83853},                             itemID = 226281, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 44.0, y = 55.6, hint = "This item is a pair of tongs found on the table."}},                                                                                                                                                                                                                                                                                         -- Radiant Tongs
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83854},                             itemID = 226282, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 46.6, y = 22.7, hint = "This item is a crate found on the floor."}},                                                                                                                                                                                                                                                                                              -- Nerubian Smith's Kit
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83855},                             itemID = 226283, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 53.0, y = 51.3, hint = "This item is a brush found on the table inside the building."}},                                                                                                                                                                                                                                                                               -- Spiderling's Wire Brush
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84226},                             itemID = 227407, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84227},                             itemID = 227418, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84228},                             itemID = 227429, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85735},                             itemID = 232500, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87266},                             itemID = 235864, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83726},                             itemID = 222554, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84127},                             itemID = 228774, points = 2,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83256},                             itemID = 225233, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83257},                             itemID = 225232, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29508},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 51.0, y = 81.8, hint = "Talk to |cff00ff00Yebb Neblegear|r at the Darkmoon Faire and complete the quest |cffffff00Baby Needs Two Pair of Shoes|r.\n\nHint: There is an anvil behind the heirloom tent."}},
  {skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228726, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81076},                             itemID = 227411, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81077},                             itemID = 227422, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81078},                             itemID = 227433, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82635},                             itemID = 224050, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 45.6, y = 33.6, hint = "This item can be purchased from the vendor Iliani in City of Threads."},                                                                                                            requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83060},                             itemID = 224652, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."},                                                                                                               requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}},                                                   -- Jewel-Etched Enchanting Notes
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83856},                             itemID = 226284, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 57.6, y = 61.6, hint = "This item is a bottle found on a table."}},                                                                                                                                                                                                                                                                                                  -- Grinded Earthen Gem
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83859},                             itemID = 226285, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 57.9, y = 56.9, hint = "This item is leaning against a wooden pillar next to Clerk Gretal."}},                                                                                                                                                                                                                                                                         -- Silver Dornogal Rod
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83860},                             itemID = 226286, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 44.6, y = 22.2, hint = "This item is an orb found on the ground."}},                                                                                                                                                                                                                                                                                            -- Soot-Coated Orb
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83861},                             itemID = 226287, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 67.1, y = 65.9, hint = "This item is a bottle found on a table inside the building."}},                                                                                                                                                                                                                                                                         -- Animated Enchanting Dust
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83862},                             itemID = 226288, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 40.1, y = 70.5, hint = "This item is a candle found on a crate inside the building."}},                                                                                                                                                                                                                                                                              -- Essence of Holy Fire
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83863},                             itemID = 226289, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 48.6, y = 64.5, hint = "This item is a scroll found on a table inside the building."}},                                                                                                                                                                                                                                                                              -- Enchanted Arathi Scroll
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83864},                             itemID = 226290, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 61.6, y = 21.9, hint = "This item is a book found on a table."}},                                                                                                                                                                                                                                                                                                 -- Book of Dark Magic
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83865},                             itemID = 226291, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 57.3, y = 44.1, hint = "This item is a purple shard found on the left table."}},                                                                                                                                                                                                                                                                                       -- Void Shard
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85736},                             itemID = 232501, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87265},                             itemID = 235863, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83727},                             itemID = 222550, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83258},                             itemID = 225231, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83259},                             itemID = 225230, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1,  loc = {hint = "These are randomly looted from disenchanting items."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {84295},                             itemID = 227661, points = 4,  loc = {hint = "These are randomly looted from disenchanting items."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84084, 84085, 84086},               itemID = 227667, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.Dornogal, x = 52.8, y = 71.2, hint = "Talk to your profession trainer and complete the quest."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29510},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Putting Trash to Good Use|r."}},
  {skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 227662, points = 0,  loc = {hint = "These are randomly looted from disenchanting items once the weekly objectives below are completed."},                                                                                                                                  requires = {{type = "quest", name = "Treasure", quests = {83258, 83259}, match = "all"}, {type = "quest", name = "Disenchanting", quests = {84290, 84291, 84292, 84293, 84294, 84295}, match = "all"}, {type = "quest", name = "Trainer Quest", quests = {84084, 84085, 84086}, match = "any"}}},
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82632},                             itemID = 224052, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 58.2, y = 31.6, hint = "This item can be purchased from the vendor Rukku in City of Threads."},                                                                                                             requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83063},                             itemID = 224653, points = 10, loc = {m = Enum.WK_Map.TheRingingDeeps, x = 47.2, y = 32.8, hint = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."},                                                                                              requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83866},                             itemID = 226292, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 61.3, y = 69.6, hint = "This item is a wrench found on the table in the building."}},                                                                               -- Rock Engineer's Wrench
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83867},                             itemID = 226293, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 64.7, y = 52.7, hint = "This item can be found on the table behind Madam Goya."}},                                                                                    -- Dornogal Spectacles
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83868},                             itemID = 226294, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 42.6, y = 27.3, hint = "This item is a bomb on a crate next to the rails."}},                                                                                  -- Inert Mining Bomb
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83869},                             itemID = 226295, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 64.5, y = 58.8, hint = "This item is a scroll found on the floor behind the table inside the building."}},                                                     -- Earthen Construct Blueprints
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83870},                             itemID = 226296, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 46.4, y = 61.5, hint = "This item is a bag found at the top of the stairs."}},                                                                                      -- Holy Firework Dud
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83871},                             itemID = 226297, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 41.6, y = 48.9, hint = "This item is a box found on the airship behind the dungeon entrance."}},                                                                    -- Arathi Safety Gloves
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83872},                             itemID = 226298, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 56.8, y = 38.7, hint = "This item is a mechanical spider found on the table at the back of the inn."}},                                                               -- Puppeted Mechanical Spider
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83873},                             itemID = 226299, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 63.1, y = 11.5, hint = "This item is a canister found on the floor next to the harpoon."}},                                                                      -- Emptied Venom Canister
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84229},                             itemID = 227412, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84230},                             itemID = 227423, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84231},                             itemID = 227434, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85737},                             itemID = 232507, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87264},                             itemID = 235862, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83728},                             itemID = 222621, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84128},                             itemID = 228775, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83260},                             itemID = 225228, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83261},                             itemID = 225229, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29511},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Talkin' Tonks|r."}},
  {skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228730, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81422},                             itemID = 227415, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81423},                             itemID = 227426, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81424},                             itemID = 227437, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82630},                             itemID = 224023, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 47.0, y = 16.2, hint = "This item can be purchased from the vendor Llyot in City of Threads."},                                                                                                             requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83066},                             itemID = 224656, points = 10, loc = {m = Enum.WK_Map.Hallowfall, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."},                                                                                                       requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83874},                             itemID = 226300, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 57.6, y = 61.5, hint = "This item is a flower found in a bed of flowers."}},                                                                       -- Ancient Flower
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83875},                             itemID = 226301, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 23.7, hint = "This item is a scythe found at the bottom of the tree."}},                                                                   -- Dornogal Gardening Scythe
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83876},                             itemID = 226302, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 44.13, y = 35.03, hint = "This item is a fork found on the table inside the building."}},                                                     -- Earthen Digging Fork
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83877},                             itemID = 226303, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 48.72, y = 65.81, hint = "This item is a knife found on the ground."}},                                                                       -- Fungarian Slicer's Knife
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83878},                             itemID = 226304, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 47.8, y = 63.3, hint = "This item is a trowel found on the ground."}},                                                                             -- Arathi Garden Trowel
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83879},                             itemID = 226305, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 35.9, y = 55.0, hint = "This item is a pair of tongs found next to the stairs."}},                                                                 -- Arathi Herb Pruner
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83880},                             itemID = 226306, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 54.7, y = 20.8, hint = "This item is a flower found on the ground under the statue."}},                                                         -- Web-Entangled Lotus
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83881},                             itemID = 226307, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 46.7, y = 16.0, hint = "This item is a shovel found on the desk."}},                                                                            -- Tunneler's Shovel
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85738},                             itemID = 232503, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87263},                             itemID = 235861, points = 15, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83729},                             itemID = 222552, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {81416, 81417, 81418, 81419, 81420}, itemID = 224264, points = 1,  loc = {hint = "These are randomly looted from herbs around the world."}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {81421},                             itemID = 224265, points = 4,  loc = {hint = "These are randomly looted from herbs around the world."}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {82970, 82958, 82965, 82916, 82962}, itemID = 224817, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.Dornogal, x = 44.8, y = 69.4, hint = "Talk to your profession trainer and complete the quest."}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29514},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Herbs for Healing|r."}},
  {skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 224835, points = 0,  loc = {hint = "These are randomly looted from herbs around the world once the weekly objectives below are completed."},                                                                                                                               requires = {{type = "quest", name = "Trainer Quest", quests = {82970, 82958, 82965, 82916, 82962}, match = "any"}, {type = "quest", name = "Gathering", quests = {81416, 81417, 81418, 81419, 81420, 81421}, match = "all"}}},
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80749},                             itemID = 227408, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80750},                             itemID = 227419, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80751},                             itemID = 227430, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82636},                             itemID = 224053, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 42.2, y = 26.8, hint = "This item can be purchased from the vendor Nuel Prill in City of Threads."},                                                                                                        requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83064},                             itemID = 224654, points = 10, loc = {m = Enum.WK_Map.TheRingingDeeps, x = 47.2, y = 32.8, hint = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."},                                                                                              requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83882},                             itemID = 226308, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 57.2, y = 47.1, hint = "This item is a quill found on the shelf in the back of the auction house."}},                                                            -- Dornogal Scribe's Quill
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83883},                             itemID = 226309, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 56.0, y = 60.1, hint = "This item is a pen found on the shelf in the building."}},                                                                             -- Historian's Dip Pen
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83884},                             itemID = 226310, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 48.5, y = 34.2, hint = "This item is a scroll found on the table inside the building."}},                                                                 -- Runic Scroll
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83885},                             itemID = 226311, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 62.5, y = 58.1, hint = "This item is a pot found on the table inside the building."}},                                                                    -- Blue Earthen Pigment
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83886},                             itemID = 226312, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 43.2, y = 58.9, hint = "This item is a pen found on the table at the top of the stairs."}},                                                                    -- Informant's Fountain Pen
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83887},                             itemID = 226313, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 42.8, y = 49.1, hint = "This item is a chisel found on the table on the top floor inside the building."}},                                                     -- Calligrapher's Chiseled Marker
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83888},                             itemID = 226314, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 55.9, y = 43.9, hint = "This item is a scroll found on the floor of the center main platform."}},                                                                -- Nerubian Texts
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83889},                             itemID = 226315, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 50.1, y = 31.0, hint = "This item is an ink well found on the desk inside the building."}},                                                                 -- Venomancer's Ink Well
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85739},                             itemID = 232508, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87262},                             itemID = 235860, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83730},                             itemID = 222548, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84129},                             itemID = 228776, points = 2,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83262},                             itemID = 225227, points = 2,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83264},                             itemID = 225226, points = 2,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29515},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Writing the Future|r"},                                                                           requires = {{type = "item", id = 39354, amount = 5}}},
  {skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228732, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81259},                             itemID = 227413, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81260},                             itemID = 227424, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81261},                             itemID = 227435, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82637},                             itemID = 224054, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 47.6, y = 18.6, hint = "This item can be purchased from the vendor Alvus Valavulu in City of Threads."},                                                                                                    requires = {{type = "currency", id = 3056, amount = 565}}},                                                   -- Emergent Crystals of the Surface-Dwellers
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83065},                             itemID = 224655, points = 10, loc = {m = Enum.WK_Map.Hallowfall, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."},                                                                                                       requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83890},                             itemID = 226316, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 63.5, y = 66.8, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83891},                             itemID = 226317, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 34.9, y = 52.3, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83892},                             itemID = 226318, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 48.5, y = 35.2, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83893},                             itemID = 226319, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 57.0, y = 54.6, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83894},                             itemID = 226320, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 47.5, y = 60.7, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83895},                             itemID = 226321, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 44.7, y = 50.9, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83896},                             itemID = 226322, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 47.7, y = 19.5, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83897},                             itemID = 226323, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 56.1, y = 58.7, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85740},                             itemID = 232504, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87261},                             itemID = 235859, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83731},                             itemID = 222551, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84130},                             itemID = 228777, points = 2,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83265},                             itemID = 225224, points = 2,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83266},                             itemID = 225225, points = 2,  loc = {hint = "These are randomly looted from treasures around the world."}},                                                     -- Deepstone Fragment
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29516},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Keeping the Faire Sparkling|r."}},
  {skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228734, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80978},                             itemID = 227414, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80979},                             itemID = 227425, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80980},                             itemID = 227436, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82626},                             itemID = 224056, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 43.5, y = 19.7, hint = "This item can be purchased from the vendor Kama in City of Threads."},                                                                                                              requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83068},                             itemID = 224658, points = 10, loc = {m = Enum.WK_Map.Hallowfall, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."},                                                                                                       requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83898},                             itemID = 226324, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 68.1, y = 23.3, hint = "This item is a tool found on the rack inside the building."}},                                                                 -- Earthen Lacing Tools
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83899},                             itemID = 226325, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 58.7, y = 30.7, hint = "This item is a knife found on a hay bale inside the building."}},                                                            -- Dornogal Craftman's Flat Knife
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83900},                             itemID = 226326, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 47.1, y = 34.8, hint = "This item is a bottle found on the shelf inside the building."}},                                                       -- Underground Stropping Compound
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83901},                             itemID = 226327, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 64.3, y = 65.2, hint = "This item is a tool found on the table inside the building."}},                                                         -- Earthen Awl
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83902},                             itemID = 226328, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 47.5, y = 65.1, hint = "This item is a pair of tongs found on the table inside the building."}},                                                     -- Arathi Beveler Set
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83903},                             itemID = 226329, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 41.5, y = 57.8, hint = "This item is a tool found on a barrel."}},                                                                                   -- Arathi Leather Burnisher
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83904},                             itemID = 226330, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 55.2, y = 26.8, hint = "This item is a mallet found on the table inside the building."}},                                                         -- Nerubian Tanning Mallet
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83905},                             itemID = 226331, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 60.0, y = 53.9, hint = "This item is a knife found on the desk."}},                                                                                    -- Curved Nerubian Skinning Knife
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85741},                             itemID = 232505, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87260},                             itemID = 235858, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83732},                             itemID = 222549, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84131},                             itemID = 228778, points = 2,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83267},                             itemID = 225223, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83268},                             itemID = 225222, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29517},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Eyes on the Prizes|r."},                                                                        requires = {{type = "item", id = 6529, amount = 10}, {type = "item", id = 2320, amount = 5}, {type = "item", id = 6260, amount = 5}}},
  {skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228736, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81390},                             itemID = 227416, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81391},                             itemID = 227427, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {81392},                             itemID = 227438, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82614},                             itemID = 224055, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 46.6, y = 21.6, hint = "This item can be purchased from the vendor Rakka in City of Threads."},                                                                                                             requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83062},                             itemID = 224651, points = 10, loc = {m = Enum.WK_Map.TheRingingDeeps, x = 47.2, y = 32.8, hint = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."},                                                                                              requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83906},                             itemID = 226332, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 58.2, y = 62.0, hint = "This item is a gavel found on the table."}},                                                                                      -- Earthen Miner's Gavel
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83907},                             itemID = 226333, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 36.6, y = 79.3, hint = "This item is a chisel found on the crystal statue."}},                                                                              -- Dornogal Chisel
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83908},                             itemID = 226334, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 45.3, y = 27.5, hint = "This item is a shovel found on the ground."}},                                                                               -- Earthen Excavator's Shovel
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83909},                             itemID = 226335, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 62.09, y = 66.23, hint = "This item is ore found on the ground."}},                                                                                  -- Regenerating Ore
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83910},                             itemID = 226336, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 46.1, y = 64.5, hint = "This item is a drill found on the table under the building."}},                                                                   -- Arathi Precision Drill
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83911},                             itemID = 226337, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 43.1, y = 56.8, hint = "This item is a tool found on the table behind the mining trainer."}},                                                             -- Devout Archaeologist's Excavator
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83912},                             itemID = 226338, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 46.8, y = 21.4, hint = "This item is a crusher found on the desk near the forge."}},                                                                   -- Heavy Spider Crusher
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83913},                             itemID = 226339, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 48.1, y = 40.7, hint = "This item is a cart found on the ground between the flowers and roots."}},                                                     -- Nerubian Mining Supplies
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85742},                             itemID = 232509, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87259},                             itemID = 235857, points = 15, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83733},                             itemID = 222553, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {83050, 83051, 83052, 83053, 83054}, itemID = 224583, points = 1,  loc = {hint = "These are randomly looted from mining nodes around the world."}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {83049},                             itemID = 224584, points = 3,  loc = {hint = "These are randomly looted from mining nodes around the world."}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {83104, 83105, 83103, 83106, 83102}, itemID = 224818, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.Dornogal, x = 52.6, y = 52.6, hint = "Talk to your profession trainer and complete the quest."}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29518},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Rearm, Reuse, Recycle|r."}},
  {skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 224838, points = 0,  loc = {hint = "These are randomly looted from mining nodes around the world once the weekly objectives below are completed."},                                                                                                                        requires = {{type = "quest", name = "Trainer Quest", quests = {83104, 83105, 83103, 83106, 83102}, match = "any"}, {type = "quest", name = "Gathering", quests = {83050, 83051, 83052, 83053, 83054, 83049}, match = "all"}}},
  -- The War Within: Skinning
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82596},                             itemID = 224007, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 43.5, y = 19.7, hint = "This item can be purchased from the vendor Kama in City of Threads."},                                                                                                              requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83067},                             itemID = 224657, points = 10, loc = {m = Enum.WK_Map.Hallowfall, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."},                                                                                                       requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83914},                             itemID = 226340, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 28.7, y = 51.8, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83915},                             itemID = 226341, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 60.0, y = 28.0, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83916},                             itemID = 226342, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 47.3, y = 28.4, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83917},                             itemID = 226343, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 65.8, y = 61.9, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83918},                             itemID = 226344, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 49.3, y = 62.1, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83919},                             itemID = 226345, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 42.3, y = 53.9, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83920},                             itemID = 226346, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 44.6, y = 49.3, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83921},                             itemID = 226347, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 56.5, y = 55.2, hint = "This item can be found in an object on the location below."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84232},                             itemID = 227417, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84233},                             itemID = 227428, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {84234},                             itemID = 227439, points = 15, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85744},                             itemID = 232506, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87258},                             itemID = 235856, points = 15, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83734},                             itemID = 222649, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {81459, 81460, 81461, 81462, 81463}, itemID = 224780, points = 1,  loc = {hint = "These are randomly looted from skinning around the world."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {81464},                             itemID = 224781, points = 2,  loc = {hint = "These are randomly looted from skinning around the world."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {83097, 83098, 83100, 82992, 82993}, itemID = 224807, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.Dornogal, x = 54.4, y = 57.6, hint = "Talk to your profession trainer and complete the quest."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29519},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Tan My Hide|r."}},
  {skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 224782, points = 0,  loc = {hint = "These are randomly looted from skinning around the world once the weekly objectives below are completed."},                                                                                                                            requires = {{type = "quest", name = "Trainer Quest", quests = {83097, 83098, 83100, 82992, 82993}, match = "any"}, {type = "quest", name = "Gathering", quests = {81459, 81460, 81461, 81462, 81463, 81464}, match = "all"}}},
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80871},                             itemID = 227410, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 200}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80872},                             itemID = 227421, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 300}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {80873},                             itemID = 227432, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                                                                                                                      requires = {{type = "item", id = 210814, amount = 400}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {82634},                             itemID = 224036, points = 10, loc = {m = Enum.WK_Map.CityOfThreads, x = 50.2, y = 16.8, hint = "This item can be purchased from the vendor Saaria in City of Threads."},                                                                                                            requires = {{type = "currency", id = 3056, amount = 565}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83061},                             itemID = 224648, points = 10, loc = {m = Enum.WK_Map.Dornogal, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."},                                                                                                               requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}},                                                   -- Jewel-Etched Tailoring Notes
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83922},                             itemID = 226348, points = 3,  loc = {m = Enum.WK_Map.Dornogal, x = 61.5, y = 18.7, hint = "This item is a knife found on the table in the back of the building."}},                                                                                                                                                                                                                                                                       -- Dornogal Seam Ripper
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83923},                             itemID = 226349, points = 3,  loc = {m = Enum.WK_Map.IsleOfDorn, x = 56.2, y = 61.0, hint = "This item is a tape measure found on the table."}},                                                                                                                                                                                                                                                                                          -- Earthen Tape Measure
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83924},                             itemID = 226350, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 48.9, y = 32.8, hint = "This item is a pin found on the shelf in the back right room of the inn."}},                                                                                                                                                                                                                                                            -- Runed Earthen Pins
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83925},                             itemID = 226351, points = 3,  loc = {m = Enum.WK_Map.TheRingingDeeps, x = 64.2, y = 60.3, hint = "This item is a pair of scisssors found on the table."}},                                                                                                                                                                                                                                                                                -- Earthen Sticher's Snips
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83926},                             itemID = 226352, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 49.3, y = 62.3, hint = "This item is a cutter found on the table."}},                                                                                                                                                                                                                                                                                                -- Arathi Rotary Cutter
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83927},                             itemID = 226353, points = 3,  loc = {m = Enum.WK_Map.Hallowfall, x = 40.1, y = 68.1, hint = "This item is a protractor found on a crate inside the building."}},                                                                                                                                                                                                                                                                          -- Royal Outfitter's Protractor
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83928},                             itemID = 226354, points = 3,  loc = {m = Enum.WK_Map.AzjKahet, x = 53.3, y = 53.0, hint = "This item is a quilt found inside the building to the left."}},                                                                                                                                                                                                                                                                                -- Nerubian Quilt
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {83929},                             itemID = 226355, points = 3,  loc = {m = Enum.WK_Map.CityOfThreads, x = 50.5, y = 16.7, hint = "This item is a pincushian found on the desk."}},                                                                                                                                                                                                                                                                                          -- Nerubian's Pincushion
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {85745},                             itemID = 232502, points = 10, loc = {m = Enum.WK_Map.Undermine, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"},                                                                                                                                              requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {87257},                             itemID = 235855, points = 10, loc = {m = Enum.WK_Map.Tazavesh, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"},                                                                                                                                                       requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83735},                             itemID = 222547, points = 1,  loc = {m = Enum.WK_Map.Dornogal, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {84132},                             itemID = 228779, points = 2,  loc = {m = Enum.WK_Map.Dornogal, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83269},                             itemID = 225221, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {83270},                             itemID = 225220, points = 1,  loc = {hint = "These are randomly looted from treasures around the world."}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29520},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.6, y = 55.8, hint = "Talk to |cff00ff00Selina Dourman|r at the Darkmoon Faire and complete the quest |cffffff00Banners, Banners Everywhere!|r"},                                                        requires = {{type = "item", id = 2320, amount = 1}, {type = "item", id = 2604, amount = 1}, {type = "item", id = 6260, amount = 1}}},
  {skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 228738, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89115},                             itemID = 238536, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 49.1, y = 75.6, hint = "A bunch of peacebloom flowers on a crate."}},                                                                                                                                                                                                                                                                                                                                                         -- Freshly Plucked Peacebloom Freshly Plucked Peacebloom - Silvermoon City
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89117},                             itemID = 238538, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 47.8, y = 51.6, hint = "A potion found on a bench."}},                                                                                                                                                                                                                                                                                                                                                                        -- Pristine Potion Pristine Potion - Silvermoon City
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89114},                             itemID = 238535, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 40.3, y = 51.1, hint = "A vial found on a cart."}},                                                                                                                                                                                                                                                                                                                                                                                  -- Vial of Zul'Aman Oddities Vial of Zul'Aman Oddities - Zul'Aman
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89116},                             itemID = 238537, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 49.1, y = 23.5, hint = "A bowl found on a table."}},                                                                                                                                                                                                                                                                                                                                                                                -- Measured Ladle Measured Ladle - Zul'Aman, Atal'Aman
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89113},                             itemID = 238534, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 34.7, y = 24.7, hint = "A vial found on the ground."}},                                                                                                                                                                                                                                                                                                                                                                             -- Vial of Rootlands Oddities Vial of Rootlands Oddities - Harandar
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89112},                             itemID = 238533, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 41.8, y = 40.5, hint = "A vial on the ground next to some big bones."}},                                                                                                                                                                                                                                                                                                                                                         -- Vial of Voidstorm Oddities Vial of Voidstorm Oddities - Voidstorm, Slayer's Rise
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89111},                             itemID = 238532, points = 3,  loc = {m = MISSING_INFO, x = MISSING_INFO, y = MISSING_INFO, hint = ""}},                                                                                                                                                                                                                                                                                                                                                                                                -- Vial of Eversong Oddities Vial of Eversong Oddities
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89118},                             itemID = 238539, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 32.7, y = 43.2, hint = "A small bottle on the ground."}},                                                                                                                                                                                                                                                                                                                                                                          -- Failed Experiment Failed Experiment - Voidstorm
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93794},                             itemID = 262645, points = 10, loc = {m = Enum.WK_Map.Voidstorm, x = 52.6, y = 72.8, hint = "<Renown Quartermaster> Void Researcher Anomander"},                                                                                                                                     requires = {{type = "renown", id = Enum.WK_Faction.TheSingularity, amount = 9}, {type = "currency", id = Enum.WK_Currency.ArtisanAlchemistMoxie, amount = 75}}},                                                   -- Beyond the Event Horizon: Alchemy
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29506},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 50.2, y = 69.6, hint = "Talk to |cff00ff00Sylannia|r at the Darkmoon Faire and complete the quest |cffffff00A Fizzy Fusion|r."},                                                                           requires = {{type = "item", id = 1645, amount = 5}}},                                                                                                                                                              -- Darkmoon Faire
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95127},                             itemID = 245755, points = 1},
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93690},                             itemID = 263454, points = 1,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93528},                             itemID = 259188, points = 2},
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93529},                             itemID = 259189, points = 2},
  {skillLineVariantID = 2906, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246320, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89177},                             itemID = 238540, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 26.84, y = 60.54, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89178},                             itemID = 238541, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 48.32, y = 75.78, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89179},                             itemID = 238542, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 33.08, y = 65.82, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89180},                             itemID = 238543, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 56.84, y = 40.77, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89181},                             itemID = 238544, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 30.51, y = 68.99, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89182},                             itemID = 238545, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 66.34, y = 50.85, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89183},                             itemID = 238546, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 53.40, y = 49.60, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89184},                             itemID = 238547, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 60.00, y = 53.40, hint = ""}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93795},                             itemID = 262644, points = 10, loc = {m = Enum.WK_Map.Voidstorm, x = 52.6, y = 72.8, hint = "<Renown Quartermaster> Void Researcher Anomander"},                                                                                                                                     requires = {{type = "renown", id = Enum.WK_Faction.TheSingularity, amount = 9}, {type = "currency", id = Enum.WK_Currency.ArtisanBlacksmithMoxie, amount = 75}}},                                                   -- Beyond the Event Horizon: Blacksmithing
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29508},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 51.0, y = 81.8, hint = "Talk to |cff00ff00Yebb Neblegear|r at the Darkmoon Faire and complete the quest |cffffff00Baby Needs Two Pair of Shoes|r.\n\nHint: There is an anvil behind the heirloom tent."}},                                                                                                                                                                                                                     -- Darkmoon Faire
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95128},                             itemID = 245763, points = 1},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93691},                             itemID = 263455, points = 2,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93530},                             itemID = 259190, points = 1},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93531},                             itemID = 259191, points = 1},
  {skillLineVariantID = 2907, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246322, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89100},                             itemID = 238548, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 48.71, y = 22.53, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89101},                             itemID = 238549, points = 3,  loc = {m = MISSING_INFO, x = MISSING_INFO, y = MISSING_INFO, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89102},                             itemID = 238550, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 35.49, y = 58.82, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89103},                             itemID = 238551, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 60.75, y = 53.01, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89104},                             itemID = 238552, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 37.75, y = 65.22, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89105},                             itemID = 238553, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 65.72, y = 50.22, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89106},                             itemID = 238554, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 40.41, y = 51.18, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89107},                             itemID = 238555, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 63.49, y = 32.60, hint = ""}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92374},                             itemID = 257600, points = 10, loc = {m = Enum.WK_Map.EversongWoods, x = 43.4, y = 47.4, hint = "<Renown Quartermaster> Caeris Fairdawn"},                                                                                                                                           requires = {{type = "renown", id = Enum.WK_Faction.SilvermoonCity, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanEnchanterMoxie, amount = 75}}},                                                            -- Skill Issue: Enchanting
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92186},                             itemID = 250445, points = 10, loc = {hint = "Chel the Chip <Abundance Vendor>"},                                                                                                                                                                                                    requires = {{type = "currency", id = Enum.WK_Currency.UnalloyedAbundance, amount = 400}, {type = "currency", id = Enum.WK_Currency.ArtisanAlchemistMoxie, amount = 75}}},                                                   -- Echo of Abundance: Enchanting
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29510},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Putting Trash to Good Use|r."}},                                                                                                                                                                                                                                                                                              -- Darkmoon Faire
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95129},                             itemID = 245759, points = 1},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93532},                             itemID = 259192, points = 2},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93533},                             itemID = 259193, points = 2},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {95048, 95049, 95050, 95051, 95052}, itemID = 267654, points = 1,  loc = {hint = "These are randomly looted from disenchanting items."}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {95053},                             itemID = 267655, points = 4,  loc = {hint = "These are randomly looted from disenchanting items."}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93699, 93698},                      itemID = 263464, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.SilvermoonCity, x = 47.8, y = 53.8, hint = "Complete a quest from |cffffff00Dolothos|r <Enchanting Trainer>."}},
  {skillLineVariantID = 2909, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 267653, points = 0,  loc = {hint = "These are randomly looted from disenchanting items once the weekly objectives below are completed."},                                                                                                                                  requires = {{type = "quest", name = "Treasure", quests = {93532, 93533}, match = "all"}, {type = "quest", name = "Disenchanting", quests = {95048, 95049, 95050, 95051, 95052, 95053}, match = "all"}, {type = "quest", name = "Trainer Quest", quests = {93699, 93698}, match = "any"}}},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89133},                             itemID = 238556, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 62.00, y = 54.60, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89134},                             itemID = 238557, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 28.93, y = 39.03, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89135},                             itemID = 238558, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 39.57, y = 45.79, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89136},                             itemID = 238559, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 68.00, y = 49.81, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89137},                             itemID = 238560, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 54.13, y = 51.01, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89138},                             itemID = 238561, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 65.14, y = 34.76, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89139},                             itemID = 238562, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 64.30, y = 56.20, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89140},                             itemID = 238563, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 34.21, y = 87.80, hint = ""}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93796},                             itemID = 262646, points = 10, loc = {m = Enum.WK_Map.Voidstorm, x = 52.6, y = 72.8, hint = "<Renown Quartermaster> Void Researcher Anomander"},                                                                                                                                     requires = {{type = "renown", id = Enum.WK_Faction.TheSingularity, amount = 9}, {type = "currency", id = Enum.WK_Currency.ArtisanEngineerMoxie, amount = 75}}},                                                   -- Beyond the Event Horizon: Engineering
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29511},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Talkin' Tonks|r."}},                                                                                                                                                                                                                                                                                              -- Darkmoon Faire
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {83728},                             itemID = 245809, points = 1},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93692},                             itemID = 263456, points = 1,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93534},                             itemID = 259194, points = 1},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93535},                             itemID = 259195, points = 1},
  {skillLineVariantID = 2910, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246326, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89162},                             itemID = 238468, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 38.32, y = 67.04, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89161},                             itemID = 238469, points = 3,  loc = {m = MISSING_INFO, x = MISSING_INFO, y = MISSING_INFO, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89160},                             itemID = 238470, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 49.02, y = 75.93, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89159},                             itemID = 238471, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 36.66, y = 25.06, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89158},                             itemID = 238472, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 64.25, y = 30.46, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89157},                             itemID = 238473, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 76.13, y = 51.05, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89156},                             itemID = 238474, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 34.69, y = 57.07, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89155},                             itemID = 238475, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 51.11, y = 55.71, hint = ""}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93411},                             itemID = 258410, points = 10, loc = {m = Enum.WK_Map.Harandar, x = 51.0, y = 50.8, hint = "<Renown Quartermaster> Naynar"},                                                                                                                                                         requires = {{type = "renown", id = Enum.WK_Faction.Harati, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanHerbalistMoxie, amount = 75}}},                                                                   -- Traditions of the Haranir: Herbalism
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92174},                             itemID = 250443, points = 10, loc = {hint = "Chel the Chip <Abundance Vendor>"},                                                                                                                                                                                                    requires = {{type = "currency", id = Enum.WK_Currency.UnalloyedAbundance, amount = 400}, {type = "currency", id = Enum.WK_Currency.ArtisanHerbalistMoxie, amount = 75}}},                                                  -- Echo of Abundance: Herbalism
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29514},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Herbs for Healing|r."}},                                                                                                                                                                                                                                                                                                   -- Darkmoon Faire
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95130},                             itemID = 245761, points = 1},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {81425, 81426, 81427, 81428, 81429}, itemID = 238465, points = 1,  loc = {hint = "These are randomly looted from herbs around the world."}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {81430},                             itemID = 238466, points = 4,  loc = {hint = "These are randomly looted from herbs around the world."}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93704, 93703, 93702, 93700},        itemID = 263462, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.SilvermoonCity, x = 48.2, y = 51.6, hint = "Complete a quest from |cffffff00Botanist Nathera|r <Herbalism Trainer>."}},
  {skillLineVariantID = 2912, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 238467, points = 0,  loc = {hint = "These are randomly looted from herbs around the world once the weekly objectives below are completed."},                                                                                                                               requires = {{type = "quest", name = "Trainer Quest", quests = {93704, 93703, 93702, 93700}, match = "any"}, {type = "quest", name = "Gathering", quests = {81425, 81426, 81427, 81428, 81429, 81430}, match = "all"}}},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89067},                             itemID = 238572, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 60.69, y = 84.26, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89068},                             itemID = 238573, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 40.48, y = 49.35, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89069},                             itemID = 238574, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 48.31, y = 75.55, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89070},                             itemID = 238575, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 52.43, y = 52.61, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89071},                             itemID = 238576, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 52.75, y = 49.98, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89072},                             itemID = 238577, points = 3,  loc = {m = MISSING_INFO, x = MISSING_INFO, y = MISSING_INFO, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89073},                             itemID = 238578, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 47.65, y = 50.39, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89074},                             itemID = 238579, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 40.35, y = 61.23, hint = ""}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93412},                             itemID = 258411, points = 10, loc = {m = Enum.WK_Map.Harandar, x = 51.0, y = 50.8, hint = "<Renown Quartermaster> Naynar"},                                                                                                                                                         requires = {{type = "renown", id = Enum.WK_Faction.Harati, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanScribeMoxie, amount = 75}}},                                                  -- Traditions of the Haranir: Inscription
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29515},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Writing the Future|r"},                                                                           requires = {{type = "item", id = 39354, amount = 5}}},                                                                                                                                                 -- Darkmoon Faire
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95131},                             itemID = 245757, points = 1},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93693},                             itemID = 263457, points = 4,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93536},                             itemID = 259196, points = 2},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93537},                             itemID = 259197, points = 2},
  {skillLineVariantID = 2913, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246328, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89122},                             itemID = 238580, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 50.50, y = 56.59, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89123},                             itemID = 238581, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 30.49, y = 69.04, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89124},                             itemID = 238582, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 28.72, y = 46.63, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89125},                             itemID = 238583, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 56.62, y = 40.88, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89126},                             itemID = 238584, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 62.76, y = 53.45, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89127},                             itemID = 238585, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 55.44, y = 47.82, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89128},                             itemID = 238586, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 54.20, y = 51.04, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89129},                             itemID = 238587, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 39.64, y = 38.82, hint = ""}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93222},                             itemID = 257599, points = 10, loc = {m = Enum.WK_Map.EversongWoods, x = 43.4, y = 47.4, hint = "<Renown Quartermaster> Caeris Fairdawn"},                                                                                                                                           requires = {{type = "renown", id = Enum.WK_Faction.SilvermoonCity, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanJewelcrafterMoxie, amount = 75}}},                                                  -- Skill Issue: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29516},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Keeping the Faire Sparkling|r."}},                                                                                                                                                                                                                                                                                   -- Darkmoon Faire
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95133},                             itemID = 245760, points = 1},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93694},                             itemID = 263458, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93539},                             itemID = 259198, points = 2},
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93538},                             itemID = 259199, points = 2},                                          -- Deepstone Fragment
  {skillLineVariantID = 2914, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246330, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89089},                             itemID = 238588, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 33.08, y = 78.91, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89090},                             itemID = 238589, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 34.72, y = 56.92, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89091},                             itemID = 238590, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 30.75, y = 83.97, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89092},                             itemID = 238591, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 45.29, y = 45.61, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89093},                             itemID = 238592, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 53.74, y = 51.67, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89094},                             itemID = 238593, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 51.69, y = 51.32, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89095},                             itemID = 238594, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 36.10, y = 25.17, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89096},                             itemID = 238595, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 44.76, y = 56.26, hint = ""}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92371},                             itemID = 250922, points = 10, loc = {m = Enum.WK_Map.ZulAman, x = 45.8, y = 65.8, hint = "<Renown Quartermaster> Magovu"},                                                                                                                                                          requires = {{type = "renown", id = Enum.WK_Faction.AmaniTribe, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanLeatherworkerMoxie, amount = 75}}},                                                   -- Whisper of the Loa: Leatherworking
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29517},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Eyes on the Prizes|r."},                                                                        requires = {{type = "item", id = 6529, amount = 10}, {type = "item", id = 2320, amount = 5}, {type = "item", id = 6260, amount = 5}}},                                                                             -- Darkmoon Faire
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95134},                             itemID = 245758, points = 1},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93695},                             itemID = 263459, points = 2,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93540},                             itemID = 259200, points = 2},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93541},                             itemID = 259201, points = 2},
  {skillLineVariantID = 2915, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246332, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89144},                             itemID = 238596, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 30.48, y = 69.07, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89145},                             itemID = 238597, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 42.00, y = 46.53, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89146},                             itemID = 238598, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 54.24, y = 51.59, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89147},                             itemID = 238599, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 37.98, y = 45.38, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89148},                             itemID = 238600, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 28.73, y = 38.56, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89149},                             itemID = 238601, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 33.29, y = 65.91, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89150},                             itemID = 238602, points = 3,  loc = {m = Enum.WK_Map.Voidstorm, x = 41.84, y = 38.21, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89151},                             itemID = 238603, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 38.83, y = 65.86, hint = ""}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92372},                             itemID = 250924, points = 10, loc = {m = Enum.WK_Map.ZulAman, x = 45.8, y = 65.8, hint = "<Renown Quartermaster> Magovu"},                                                                                                                                                          requires = {{type = "renown", id = Enum.WK_Faction.AmaniTribe, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanMinerMoxie, amount = 75}}},                                                                -- Whisper of the Loa: Mining
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92187},                             itemID = 250444, points = 10, loc = {hint = "Chel the Chip <Abundance Vendor>"},                                                                                                                                                                                                    requires = {{type = "currency", id = Enum.WK_Currency.UnalloyedAbundance, amount = 400}, {type = "currency", id = Enum.WK_Currency.ArtisanMinerMoxie, amount = 75}}},                                                   -- Echo of Abundance: Mining
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29518},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Rearm, Reuse, Recycle|r."}},                                                                                                                                                                                                                                                                                            -- Darkmoon Faire
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95135},                             itemID = 245762, points = 1},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {88673, 88674, 88675, 88676, 88677}, itemID = 237496, points = 1,  loc = {hint = "These are randomly looted from mining nodes around the world."}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {88678},                             itemID = 237506, points = 3,  loc = {hint = "These are randomly looted from mining nodes around the world."}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93709, 93708, 93706, 93705},        itemID = 263463, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.SilvermoonCity, x = 42.6, y = 52.8, hint = "Complete a quest from |cffffff00Belil|r <Mining Trainer>."}},
  {skillLineVariantID = 2916, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 237507, points = 0,  loc = {hint = "These are randomly looted from mining nodes around the world once the weekly objectives below are completed."},                                                                                                                        requires = {{type = "quest", name = "Trainer Quest", quests = {93709, 93708, 93706, 93705}, match = "any"}, {type = "quest", name = "Gathering", quests = {88673, 88674, 88675, 88676, 88677, 88678}, match = "all"}}},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89166},                             itemID = 238628, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 76.09, y = 51.08, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89167},                             itemID = 238629, points = 3,  loc = {m = Enum.WK_Map.AtalAman, x = 44.90, y = 45.17, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89168},                             itemID = 238630, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 69.52, y = 49.17, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89169},                             itemID = 238631, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 45.50, y = 42.40, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89170},                             itemID = 238632, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 40.39, y = 36.01, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89171},                             itemID = 238633, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 43.13, y = 55.62, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89172},                             itemID = 238634, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 33.07, y = 79.07, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89173},                             itemID = 238635, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 48.40, y = 76.26, hint = ""}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92373},                             itemID = 250923, points = 10, loc = {m = Enum.WK_Map.ZulAman, x = 45.8, y = 65.8, hint = "<Renown Quartermaster> Magovu"},                                                                                                                                                          requires = {{type = "renown", id = Enum.WK_Faction.AmaniTribe, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanSkinnerMoxie, amount = 75}}},                                                                -- Whisper of the Loa: Skinning
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {92188},                             itemID = 250360, points = 10, loc = {hint = "Chel the Chip <Abundance Vendor>"},                                                                                                                                                                                                    requires = {{type = "currency", id = Enum.WK_Currency.UnalloyedAbundance, amount = 400}, {type = "currency", id = Enum.WK_Currency.ArtisanSkinnerMoxie, amount = 75}}},                                                   -- Echo of Abundance: Skinning
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29519},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Tan My Hide|r."}},                                                                                                                                                                                                                                                                                                        -- Darkmoon Faire
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95136},                             itemID = 245828, points = 1},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {88534, 88549, 88537, 88536, 88530}, itemID = 238625, points = 1,  loc = {hint = "These are randomly looted from skinning around the world."}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.Gathering,     quests = {88529},                             itemID = 238626, points = 3,  loc = {hint = "These are randomly looted from skinning around the world."}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93714, 93711, 93710},               itemID = 263461, points = 3,  limit = 1,                                                                                                                                                                                                                                            loc = {m = Enum.WK_Map.SilvermoonCity, x = 43.2, y = 55.6, hint = "Complete a quest from |cffffff00Tyn|r <Skinning Trainer>."}},
  {skillLineVariantID = 2917, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 238627, points = 0,  loc = {hint = "These are randomly looted from skinning around the world once the weekly objectives below are completed."},                                                                                                                            requires = {{type = "quest", name = "Trainer Quest", quests = {93714, 93711, 93710}, match = "any"}, {type = "quest", name = "Gathering", quests = {88534, 88549, 88537, 88536, 88530, 88529}, match = "all"}}},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89078},                             itemID = 238612, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 70.56, y = 50.90, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89079},                             itemID = 238613, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 35.73, y = 61.22, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89080},                             itemID = 238614, points = 3,  loc = {m = Enum.WK_Map.EversongWoods, x = 46.36, y = 34.87, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89081},                             itemID = 238615, points = 3,  loc = {m = Enum.WK_Map.Harandar, x = 69.76, y = 51.05, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89082},                             itemID = 238616, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 62.01, y = 83.52, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89083},                             itemID = 238617, points = 3,  loc = {m = Enum.WK_Map.SlayersRise, x = 61.39, y = 85.12, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89084},                             itemID = 238618, points = 3,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 31.79, y = 68.28, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {89085},                             itemID = 238619, points = 3,  loc = {m = Enum.WK_Map.ZulAman, x = 40.53, y = 49.36, hint = ""}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Unique,        quests = {93201},                             itemID = 257601, points = 10, loc = {m = Enum.WK_Map.EversongWoods, x = 43.4, y = 47.4, hint = "<Renown Quartermaster> Caeris Fairdawn"},                                                                                                                                           requires = {{type = "renown", id = Enum.WK_Faction.SilvermoonCity, amount = 6}, {type = "currency", id = Enum.WK_Currency.ArtisanTailorMoxie, amount = 50}}},                                                   -- Skill Issue: Tailoring
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29520},                             itemID = 0,      points = 3,  loc = {m = Enum.WK_Map.DarkmoonIsland, x = 55.6, y = 55.8, hint = "Talk to |cff00ff00Selina Dourman|r at the Darkmoon Faire and complete the quest |cffffff00Banners, Banners Everywhere!|r"},                                                        requires = {{type = "item", id = 2320, amount = 1}, {type = "item", id = 2604, amount = 1}, {type = "item", id = 6260, amount = 1}}},                                                                           -- Darkmoon Faire
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Treatise,      quests = {95137},                             itemID = 245756, points = 1},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.WeeklyQuest,   quests = {93696},                             itemID = 263460, points = 2,  loc = {m = Enum.WK_Map.SilvermoonCity, x = 45.0, y = 55.2, hint = "Complete a quest from the Artisan's Consortium."}},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93542},                             itemID = 259202, points = 2},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.Treasure,      quests = {93543},                             itemID = 259203, points = 2},
  {skillLineVariantID = 2918, categoryID = Enum.WK_ObjectiveCategory.CatchUp,       quests = {},                                  itemID = 246334, points = 0,  loc = {hint = "Awarded from Patron Orders at your crafting station."}},
}

---@type WK_SkillLine[]
Data.SkillLines = {
  {id = 171, name = "Alchemy"},
  {id = 164, name = "Blacksmithing"},
  {id = 333, name = "Enchanting"},
  {id = 202, name = "Engineering"},
  {id = 182, name = "Herbalism"},
  {id = 773, name = "Inscription"},
  {id = 755, name = "Jewelcrafting"},
  {id = 165, name = "Leatherworking"},
  {id = 186, name = "Mining"},
  {id = 393, name = "Skinning"},
  {id = 197, name = "Tailoring"},
}

---@type WK_SkillLineVariant[]
Data.SkillLineVariants = {
  -- Dragonflight (Dragon Isles)
  {id = 2823, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 171, name = "Dragon Isles Alchemy",        catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2822, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 164, name = "Dragon Isles Blacksmithing",  catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2825, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 333, name = "Dragon Isles Enchanting",     catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2827, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 202, name = "Dragon Isles Engineering",    catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2832, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 182, name = "Dragon Isles Herbalism",      catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2828, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 773, name = "Dragon Isles Inscription",    catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2829, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 755, name = "Dragon Isles Jewelcrafting",  catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2830, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 165, name = "Dragon Isles Leatherworking", catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2833, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 186, name = "Dragon Isles Mining",         catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2834, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 393, name = "Dragon Isles Skinning",       catchUpCurrencyID = 0,    catchUpItemID = 0,},
  {id = 2831, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 197, name = "Dragon Isles Tailoring",      catchUpCurrencyID = 0,    catchUpItemID = 0,},
  -- The War Within (Khaz Algar)
  {id = 2871, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 171, name = "Khaz Algar Alchemy",          catchUpCurrencyID = 3057, catchUpItemID = 228724,},
  {id = 2872, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 164, name = "Khaz Algar Blacksmithing",    catchUpCurrencyID = 3058, catchUpItemID = 228726,},
  {id = 2874, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 333, name = "Khaz Algar Enchanting",       catchUpCurrencyID = 3059, catchUpItemID = 227662,},
  {id = 2875, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 202, name = "Khaz Algar Engineering",      catchUpCurrencyID = 3060, catchUpItemID = 228730,},
  {id = 2877, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 182, name = "Khaz Algar Herbalism",        catchUpCurrencyID = 3061, catchUpItemID = 224835,},
  {id = 2878, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 773, name = "Khaz Algar Inscription",      catchUpCurrencyID = 3062, catchUpItemID = 228732,},
  {id = 2879, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 755, name = "Khaz Algar Jewelcrafting",    catchUpCurrencyID = 3063, catchUpItemID = 228734,},
  {id = 2880, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 165, name = "Khaz Algar Leatherworking",   catchUpCurrencyID = 3064, catchUpItemID = 228736,},
  {id = 2881, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 186, name = "Khaz Algar Mining",           catchUpCurrencyID = 3065, catchUpItemID = 224838,},
  {id = 2882, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 393, name = "Khaz Algar Skinning",         catchUpCurrencyID = 3066, catchUpItemID = 224782,},
  {id = 2883, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 197, name = "Khaz Algar Tailoring",        catchUpCurrencyID = 3067, catchUpItemID = 228738,},
  -- Midnight
  {id = 2906, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 171, name = "Midnight Alchemy",            catchUpCurrencyID = 3189, catchUpItemID = 246320,},
  {id = 2907, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 164, name = "Midnight Blacksmithing",      catchUpCurrencyID = 3199, catchUpItemID = 246322,},
  {id = 2909, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 333, name = "Midnight Enchanting",         catchUpCurrencyID = 3198, catchUpItemID = 267653,},
  {id = 2910, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 202, name = "Midnight Engineering",        catchUpCurrencyID = 3197, catchUpItemID = 246326,},
  {id = 2912, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 182, name = "Midnight Herbalism",          catchUpCurrencyID = 3196, catchUpItemID = 238467,},
  {id = 2913, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 773, name = "Midnight Inscription",        catchUpCurrencyID = 3195, catchUpItemID = 246328,},
  {id = 2914, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 755, name = "Midnight Jewelcrafting",      catchUpCurrencyID = 3194, catchUpItemID = 246330,},
  {id = 2915, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 165, name = "Midnight Leatherworking",     catchUpCurrencyID = 3193, catchUpItemID = 246332,},
  {id = 2916, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 186, name = "Midnight Mining",             catchUpCurrencyID = 3192, catchUpItemID = 237507,},
  {id = 2917, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 393, name = "Midnight Skinning",           catchUpCurrencyID = 3191, catchUpItemID = 238627,},
  {id = 2918, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 197, name = "Midnight Tailoring",          catchUpCurrencyID = 3190, catchUpItemID = 246334,},
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
      for _, character in pairs(self.db.global.characters) do
        for _, characterProfession in pairs(character.professions) do
          characterProfession.enabled = true
        end
      end
    end
    -- Move enabled setting to saved professions only
    if self.db.global.DBVersion == 8 then
      for _, character in pairs(self.db.global.characters) do
        if character.enabled == false then
          for _, characterProfession in pairs(character.professions) do
            characterProfession.enabled = false
          end
        end
        character.enabled = nil
      end
    end
    -- Remove denormalized keys and rename levels to skillLevel
    if self.db.global.DBVersion == 10 then
      for _, character in pairs(self.db.global.characters) do
        if type(character.professions) == "table" then
          for _, characterProfession in pairs(character.professions) do
            characterProfession.skillLineID = nil
            characterProfession.name = nil
            if characterProfession.level ~= nil then
              characterProfession.skillLevel = characterProfession.level
              characterProfession.level = nil
            end
            if characterProfession.maxLevel ~= nil then
              characterProfession.skillMaxLevel = characterProfession.maxLevel
              characterProfession.maxLevel = nil
            end
          end
        end
      end
    end
    -- Fix professions without skillLine data. Look for the saved catchupCunrrecy or get rid of the profession if no catchup currency is found.
    if self.db.global.DBVersion == 11 then
      for _, character in pairs(self.db.global.characters) do
        if type(character.professions) == "table" then
          local professions = {}
          for _, characterProfession in pairs(character.professions) do
            local keep = true
            if not characterProfession.skillLineVariantID then
              local catchupCurrencyInfo = characterProfession.catchUpCurrencyInfo
              if catchupCurrencyInfo and catchupCurrencyInfo.currencyID then
                for _, skillLineVariant in pairs(self.SkillLineVariants) do
                  if skillLineVariant.catchUpCurrencyID == catchupCurrencyInfo.currencyID then
                    characterProfession.skillLineID = skillLineVariant.skillLineID
                    characterProfession.skillLineVariantID = skillLineVariant.id
                    break
                  end
                end
              else
                keep = false
              end
            end
            if keep then
              table.insert(professions, characterProfession)
            end
          end
          character.professions = professions
        end
      end
    end
    -- Migrate hidden categories
    if self.db.global.DBVersion == 13 then
      if not self.db.global.checklist.hiddenCategories then
        self.db.global.checklist.hiddenCategories = {}
      end
      if self.db.global.checklist.hideUniqueObjectives then
        self.db.global.checklist.hiddenCategories[Enum.WK_ObjectiveCategory.Unique] = true
        self.db.global.checklist.hideUniqueObjectives = nil
      end
      if self.db.global.checklist.hideUniqueVendorObjectives then
        self.db.global.checklist.hideUniqueVendorObjectives = nil
      end
      if self.db.global.checklist.hideCatchUpObjectives then
        self.db.global.checklist.hiddenCategories[Enum.WK_ObjectiveCategory.CatchUp] = true
        self.db.global.checklist.hideCatchUpObjectives = nil
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
      local objectiveCategory = self:GetObjectiveCategoryByID(objective.categoryID)
      if not objectiveCategory or objectiveCategory.repeatable ~= "Weekly" then return end
      Utils:TableForEach(objective.quests, function(questID)
        questsToReset[questID] = true
      end)
    end)
    for _, character in pairs(self.db.global.characters) do
      if type(character.lastUpdate) == "number" and character.lastUpdate <= self.db.global.weeklyReset and type(character.completed) == "table" then
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

---Clear the weekly progress cache.
function Data:ClearWeeklyProgress()
  if type(self.cache.weeklyProgress) == "table" then
    self.cache.weeklyProgress = {}
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

---Remove a character from the addon. No undo; log in on that character again to reintroduce.
---@param characterOrGUID WK_Character|string
function Data:DeleteCharacter(characterOrGUID)
  local GUID = type(characterOrGUID) == "table" and characterOrGUID.GUID or characterOrGUID
  if not GUID or self.db.global.characters[GUID] == nil then return end
  self.db.global.characters[GUID] = nil
  if type(self.cache.weeklyProgress) == "table" then
    self.cache.weeklyProgress = {}
  end
end

---Check to see if the Darkmoon Faire event is live.
---Bails early when calendar may return secret values (SecretInChatMessagingLockdown; taint-safe).
function Data:ScanCalendar()
  if self:IsInChatMessagingLockdown() then return end
  if not self.cache.calendarOpened then
    local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
    if currentCalendarTime and currentCalendarTime.month then
      C_Calendar.SetAbsMonth(currentCalendarTime.month, currentCalendarTime.year)
      C_Calendar.OpenCalendar()
      self.cache.calendarOpened = true
    end
  end
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  if not currentCalendarTime or not currentCalendarTime.monthDay then
    return
  end
  local today = currentCalendarTime.monthDay
  local numEvents = C_Calendar.GetNumDayEvents(0, today)
  if not numEvents then
    return
  end
  for i = 1, numEvents do
    local event = C_Calendar.GetDayEvent(0, today, i)
    if event and not Utils:IsSecretValue(event.eventID) and event.eventID == 479 then
      self.cache.isDarkmoonOpen = true
    end
  end
end

function Data:ScanProfession()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  local tradeSkillLines = C_TradeSkillUI.GetAllProfessionTradeSkillLines()
  if not tradeSkillLines then
    return
  end

  local professions = {}
  Utils:TableForEach(tradeSkillLines, function(tradeSkillLineID)
    -- Skip professions we don't care about
    local skillLineVariant = self:GetSkillLineVariantByID(tradeSkillLineID)
    if not skillLineVariant then
      return
    end

    -- Find the character profession if it exists.
    local profession = Utils:TableFind(character.professions, function(characterProfession)
      return characterProfession.skillLineVariantID == tradeSkillLineID
    end)

    -- If we didn't find a profession, let's try to create one with basic info if possible.
    if not profession then
      local prof1, prof2 = GetProfessions()
      if not prof1 and not prof2 then
        return
      end
      Utils:TableForEach({prof1, prof2}, function(professionIndex)
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(professionIndex)
        if name and skillLine and skillLine == skillLineVariant.skillLineID then
          --@type WK_CharacterProfession
          profession = {
            enabled = true,
            skillLineID = skillLineVariant.skillLineID,
            skillLineVariantID = tradeSkillLineID,
            skillLevel = 0,
            skillMaxLevel = 0,
            knowledgeLevel = 0,
            knowledgeMaxLevel = 0,
            knowledgeUnspent = 0,
            specializations = {},
            catchUpCurrencyInfo = nil,
            tradeSkillRecipes = {},
          }
        end
      end)
    end

    -- Okay let's just give up here. This is not a profession we care about.
    if not profession then
      return
    end

    do -- All this is very limited until the TradeSkillUI has been opened or is currently open.
      -- This only works once the TradeSkillUI has been opened.
      local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(tradeSkillLineID)
      if info and info.skillLevel and info.skillLevel > 0 then
        profession.skillLevel = info.skillLevel
        profession.skillMaxLevel = info.maxSkillLevel
      end

      -- If the TradeSkillUI is open, get recipes
      local baseProfessionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
      if baseProfessionInfo and baseProfessionInfo.professionID == skillLineVariant.skillLineID then
        local recipeIDs = C_TradeSkillUI.GetAllRecipeIDs()
        if recipeIDs and Utils:TableCount(recipeIDs) > 0 then
          local tradeSkillRecipes = {}
          Utils:TableForEach(recipeIDs, function(recipeID)
            -- skip recipes that are not in the profession variant
            if not C_TradeSkillUI.IsRecipeInSkillLine(recipeID, tradeSkillLineID) then return end
            local recipeInfo = C_TradeSkillUI.GetRecipeInfo(recipeID)
            if not recipeInfo then return end
            table.insert(tradeSkillRecipes, recipeInfo)
          end)
          profession.tradeSkillRecipes = tradeSkillRecipes
        end
      end
    end

    -- Get specialization currency info
    local specializationCurrencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(tradeSkillLineID)
    if specializationCurrencyInfo and specializationCurrencyInfo.numAvailable then
      profession.knowledgeUnspent = specializationCurrencyInfo.numAvailable or 0
    end

    -- Get catch up currency info
    if skillLineVariant.catchUpCurrencyID then
      local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(skillLineVariant.catchUpCurrencyID)
      if currencyInfo and currencyInfo.quantity then
        profession.catchUpCurrencyInfo = currencyInfo
      end
    end

    -- Scan knowledge spent/max for the profession
    local totalKnowledgeLevel = 0
    local totalKnowledgeMaxLevel = 0
    local specializations = {}
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(tradeSkillLineID)
    if configID and configID > 0 then
      local configInfo = C_Traits.GetConfigInfo(configID)
      if configInfo then
        local treeIDs = configInfo.treeIDs
        if treeIDs then
          Utils:TableForEach(treeIDs, function(treeID)
            local treeNodes = C_Traits.GetTreeNodes(treeID)
            if not treeNodes then return end
            ---@type WK_CharacterProfessionSpecialization
            local specialization = {
              rootNodeID = 0,
              name = "",
              rootIconID = 0,
              description = "",
              state = Enum.ProfessionsSpecTabState.Locked,
              treeID = 0,
              configID = 0,
              knowledgeLevel = 0,
              knowledgeMaxLevel = 0,
            }

            local tabInfo = C_ProfSpecs.GetTabInfo(treeID)
            if tabInfo then
              local state = C_ProfSpecs.GetStateForTab(treeID, configID)
              specialization.rootNodeID = tabInfo.rootNodeID
              specialization.rootIconID = tabInfo.rootIconID
              specialization.name = tabInfo.name
              specialization.description = tabInfo.description
              specialization.state = state
              specialization.treeID = treeID
              specialization.configID = configID
              specialization.knowledgeLevel = 0
              specialization.knowledgeMaxLevel = 0

              Utils:TableForEach(treeNodes, function(treeNode)
                local nodeInfo = C_Traits.GetNodeInfo(configID, treeNode)
                if not nodeInfo then return end
                if nodeInfo.ranksPurchased > 1 then
                  totalKnowledgeLevel = totalKnowledgeLevel + (nodeInfo.currentRank - 1)
                  specialization.knowledgeLevel = specialization.knowledgeLevel + (nodeInfo.currentRank - 1)
                end
                totalKnowledgeMaxLevel = totalKnowledgeMaxLevel + (nodeInfo.maxRanks - 1)
                specialization.knowledgeMaxLevel = specialization.knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
              end)

              table.insert(specializations, specialization)
            end
          end)
        end
      end
    end

    profession.knowledgeLevel = totalKnowledgeLevel
    profession.knowledgeMaxLevel = totalKnowledgeMaxLevel
    profession.specializations = specializations

    -- Remove profession if it do not have a max knowledge level or is 0
    if profession and (not profession.knowledgeMaxLevel or profession.knowledgeMaxLevel == 0) then
      return
    end

    table.insert(professions, profession)
  end)

  character.professions = professions
  character.lastUpdate = GetServerTime()
end

function Data:ScanQuests()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  -- Track completed quests
  local completedQuests = {}
  Utils:TableForEach(self:GetObjectives(), function(objective)
    if not objective.quests then return end
    Utils:TableForEach(objective.quests, function(questID)
      if self.cache.completedQuests[questID] then
        completedQuests[questID] = true
        return
      end
      local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(questID)
      if isCompleted then
        completedQuests[questID] = true
        self.cache.completedQuests[questID] = true
      end
    end)
  end)
  character.completed = completedQuests
  character.lastUpdate = GetServerTime()
end

function Data:ScanCharacter()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
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

  -- -- Don't track a character without any professions
  -- if Utils:TableCount(character.professions) < 1 then
  --   self.db.global.characters[character.GUID] = nil
  -- end
end

---@return table<WOWGUID, WK_Character>
function Data:GetCharacters()
  local characters = Utils:TableFilter(self.db.global.characters, function(character)
    -- Ignore ghost characters (Bug: https://github.com/DennisRas/WeeklyKnowledge/issues/47)
    if not character.name or character.name == "" then
      return false
    end
    return true
  end)

  table.sort(characters, function(a, b)
    if type(a.lastUpdate) == "number" and type(b.lastUpdate) == "number" then
      return a.lastUpdate > b.lastUpdate
    end
    return strcmputf8i(a.name, b.name) < 0
  end)

  return characters
end

---@return WK_Expansion[]
function Data:GetExpansions()
  return self.Expansions
end

---@param expansionID Enum.ExpansionLevel
---@return WK_Expansion?
function Data:GetExpansionByID(expansionID)
  for _, expansion in ipairs(self.Expansions) do
    if expansion.id == expansionID then
      return expansion
    end
  end
  return nil
end

---@return WK_SkillLine[]
function Data:GetSkillLines()
  return self.SkillLines
end

---@param skillLineID integer
---@return WK_SkillLine?
function Data:GetSkillLineByID(skillLineID)
  for _, skillLine in ipairs(self.SkillLines) do
    if skillLine.id == skillLineID then
      return skillLine
    end
  end
  return nil
end

---@return WK_SkillLineVariant[]
function Data:GetSkillLineVariants()
  return self.SkillLineVariants
end

---@param skillLineVariantID integer
---@return WK_SkillLineVariant?
function Data:GetSkillLineVariantByID(skillLineVariantID)
  for _, variant in ipairs(self.SkillLineVariants) do
    if variant.id == skillLineVariantID then
      return variant
    end
  end
  return nil
end

---@return WK_Objective[]
function Data:GetObjectives()
  return self.Objectives
end

---@return WK_ObjectiveCategory[]
function Data:GetObjectiveCategories()
  return self.ObjectiveCategories
end

---@param categoryID Enum.WK_ObjectiveCategory
---@return WK_ObjectiveCategory?
function Data:GetObjectiveCategoryByID(categoryID)
  for _, category in ipairs(self.ObjectiveCategories) do
    if category.id == categoryID then
      return category
    end
  end
  return nil
end

---@return WK_Progress[]
function Data:GetWeeklyProgress()
  local characters = self:GetCharacters()
  local objectives = self:GetObjectives()
  local objectiveCategories = self:GetObjectiveCategories()

  self.cache.weeklyProgress = wipe(self.cache.weeklyProgress or {})
  Utils:TableForEach(characters, function(character)
    local completed = (type(character.completed) == "table" and character.completed) or {}
    Utils:TableForEach(character.professions, function(characterProfession)
      local variant = self:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
      if not variant then return end

      local sumPointsEarned = 0
      local sumPointsTotal = 0

      for _, objective in pairs(objectives) do
        if objective.skillLineVariantID ~= characterProfession.skillLineVariantID or not objective.quests then
          -- skip
        elseif objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
          -- handled below
        else
          ---@type WK_Progress
          local progress = {
            characterGUID = character.GUID,
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
            if completed[questID] then
              if objective.itemID and objective.itemID > 0 then
                progress.items[objective.itemID] = true
              end
              progress.questsCompleted = progress.questsCompleted + 1
              progress.pointsEarned = progress.pointsEarned + objective.points
            end
          end)

          if objective.categoryID == Enum.WK_ObjectiveCategory.DarkmoonQuest then
            if not self.cache.isDarkmoonOpen then
              progress.questsTotal = 0
            end
          end

          if (
              objective.categoryID == Enum.WK_ObjectiveCategory.ArtisanQuest
              or objective.categoryID == Enum.WK_ObjectiveCategory.Treasure
              or objective.categoryID == Enum.WK_ObjectiveCategory.Gathering
              or objective.categoryID == Enum.WK_ObjectiveCategory.TrainerQuest
            ) then
            if progress.questsTotal > 0 then
              sumPointsEarned = sumPointsEarned + progress.pointsEarned
              sumPointsTotal = sumPointsTotal + progress.pointsTotal
            end
          end

          table.insert(self.cache.weeklyProgress, progress)
        end
      end

      local catchUpInfo = characterProfession.catchUpCurrencyInfo
      if variant.catchUpCurrencyID and catchUpInfo and catchUpInfo.quantity ~= nil and catchUpInfo.maxQuantity ~= nil then
        for _, objective in pairs(self.Objectives) do
          if objective.skillLineVariantID == characterProfession.skillLineVariantID and objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
            ---@type WK_Progress
            local progress = {
              characterGUID = character.GUID,
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

            progress.pointsEarned = catchUpInfo.quantity - sumPointsEarned
            progress.pointsTotal = catchUpInfo.maxQuantity - sumPointsTotal

            if progress.pointsEarned < progress.pointsTotal then
              progress.questsTotal = progress.pointsTotal - progress.pointsEarned
            else
              progress.questsTotal = progress.pointsTotal
              progress.questsCompleted = progress.pointsTotal
            end

            table.insert(self.cache.weeklyProgress, progress)
          end
        end
      end
    end)
  end)

  return self.cache.weeklyProgress
end
