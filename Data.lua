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
}

Data.DBVersion = 11
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
      selectedExpansion = nil,
      hiddenColumns = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      checklistHelpTipClosed = false,
    },
    checklist = {
      selectedExpansion = nil,
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
      hideCatchUpObjectives = false,
    },
  }
}

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
}

---@type table<Enum.ExpansionLevel, WK_Expansion>
Data.Expansions = {
  [Enum.ExpansionLevel.Dragonflight] = {id = Enum.ExpansionLevel.Dragonflight, abbr = "DF", name = "Dragonflight"},
  [Enum.ExpansionLevel.WarWithin]    = {id = Enum.ExpansionLevel.WarWithin, abbr = "TWW", name = "The War Within"},
  [Enum.ExpansionLevel.Midnight]     = {id = Enum.ExpansionLevel.Midnight, abbr = "Midnight", name = "Midnight"},
}

---@type table<Enum.WK_ObjectiveCategory, WK_ObjectiveCategory>
Data.ObjectiveCategories = {
  [Enum.WK_ObjectiveCategory.Unique] = {
    id = Enum.WK_ObjectiveCategory.Unique,
    name = "Uniques",
    description = "These are one-time knowledge point items found in treasures around the world and sold by Artisan/Renown/Kej vendors.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),
    type = "item",
    repeatable = "No",
  },
  [Enum.WK_ObjectiveCategory.Treatise] = {
    id = Enum.WK_ObjectiveCategory.Treatise,
    name = "Treatise",
    description = "These can be crafted by scribers. Send a Crafting Order if you don't have the inscription profession.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "item",
    repeatable = "Weekly",
  },
  [Enum.WK_ObjectiveCategory.ArtisanQuest] = {
    id = Enum.WK_ObjectiveCategory.ArtisanQuest,
    name = "Artisan",
    description = "Quest: Kala Clayhoof from Artisan's Consortium wants you to fulfill Crafting Orders.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "quest",
    repeatable = "Weekly",
  },
  [Enum.WK_ObjectiveCategory.Treasure] = {
    id = Enum.WK_ObjectiveCategory.Treasure,
    name = "Treasure",
    description = "These are randomly looted from treasures and dirt around the world.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "item",
    repeatable = "Weekly",
  },
  [Enum.WK_ObjectiveCategory.Gathering] = {
    id = Enum.WK_ObjectiveCategory.Gathering,
    name = "Gathering",
    description = "These are randomly looted from gathering nodes around the world. You may (not confirmed) randomly find additional items beyond the weekly limit.\n\nThese are also looted from Disenchanting.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "item",
    repeatable = "Weekly",
  },
  [Enum.WK_ObjectiveCategory.TrainerQuest] = {
    id = Enum.WK_ObjectiveCategory.TrainerQuest,
    name = "Trainer",
    description = "Quest: Complete a quest at your profession trainer.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "quest",
    repeatable = "Weekly",
  },
  [Enum.WK_ObjectiveCategory.DarkmoonQuest] = {
    id = Enum.WK_ObjectiveCategory.DarkmoonQuest,
    name = "Darkmoon",
    description = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Monthly"),
    type = "quest",
    repeatable = "Monthly",
  },
  [Enum.WK_ObjectiveCategory.CatchUp] = {
    id = Enum.WK_ObjectiveCategory.CatchUp,
    name = "Catch-Up",
    description = "Keep track of your Knowledge Points progress and catch up on points from previous weeks.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Yes"),
    type = "item",
    repeatable = "Yes",
  },
}

---@type table<integer, WK_Objective>
Data.Objectives = {
  [1] = {id = 1, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81146}, itemID = 227409, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [2] = {id = 2, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81147}, itemID = 227420, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [3] = {id = 3, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81148}, itemID = 227431, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [4] = {id = 4, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82633}, itemID = 224024, points = 10, loc = {m = 2213, x = 45.6, y = 13.2, hint = "This item can be purchased from the vendor Siesbarg in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [5] = {id = 5, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83058}, itemID = 224645, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."}, requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Alchemy Notes
  [6] = {id = 6, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83840}, itemID = 226265, points = 3, loc = {m = 2339, x = 32.5, y = 60.5, hint = "This item is a keg behind the pillars next to the gate."}},                                                                                                                     -- Earthen Iron Powder
  [7] = {id = 7, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83841}, itemID = 226266, points = 3, loc = {m = 2248, x = 57.7, y = 61.8, hint = "This item is a metal frame found on top of a big chest."}},                                                                                                                     -- Metal Dornogal Frame
  [8] = {id = 8, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83842}, itemID = 226267, points = 3, loc = {m = 2214, x = 42.2, y = 24.1, hint = "This item is a bottle found on the table inside the building on the bottom floor."}},                                                                                           -- Reinforced Beaker
  [9] = {id = 9, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83843}, itemID = 226268, points = 3, loc = {m = 2214, x = 64.9, y = 61.8, hint = "This item is a rod found next to the forge inside the building on the bottom floor."}},                                                                                         -- Engraved Stirring Rod
  [10] = {id = 10, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83844}, itemID = 226269, points = 3, loc = {m = 2215, x = 42.6, y = 55.1, hint = "This item is a bottle found on the table near the fountain."}},                                                                                                               -- Chemist's Purified Water
  [11] = {id = 11, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83845}, itemID = 226270, points = 3, loc = {m = 2215, x = 41.7, y = 55.8, hint = "This item is a mortar found on the table inside the orphanage building."}},                                                                                                   -- Sanctified Mortar and Pestle
  [12] = {id = 12, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83846}, itemID = 226271, points = 3, loc = {m = 2213, x = 45.5, y = 13.3, hint = "This item is a bottle found on the desk inside the building."}},                                                                                                              -- Nerubian Mixing Salts
  [13] = {id = 13, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83847}, itemID = 226272, points = 3, loc = {m = 2255, x = 42.9, y = 57.3, hint = "This item is a vial found on the broken table in the building."}},                                                                                                            -- Dark Apothecary's Vial
  [14] = {id = 14, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85734}, itemID = 232499, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [15] = {id = 15, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87255}, itemID = 235865, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [16] = {id = 16, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83725}, itemID = 222546, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [17] = {id = 17, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84133}, itemID = 228773, points = 2, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [18] = {id = 18, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83253}, itemID = 225234, points = 2, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [19] = {id = 19, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83255}, itemID = 225235, points = 2, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [20] = {id = 20, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29506}, itemID = 0, points = 3, loc = {m = 407, x = 50.2, y = 69.6, hint = "Talk to |cff00ff00Sylannia|r at the Darkmoon Faire and complete the quest |cffffff00A Fizzy Fusion|r."}, requires = {{type = "item", id = 1645, amount = 5}}},
  [21] = {id = 21, skillLineVariantID = 2871, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228724, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  [22] = {id = 22, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82631}, itemID = 224038, points = 10, loc = {m = 2213, x = 46.6, y = 21.6, hint = "This item can be purchased from the vendor Rakka in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [23] = {id = 23, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83059}, itemID = 224647, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."}, requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Blacksmithing Notes
  [24] = {id = 24, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83848}, itemID = 226276, points = 3, loc = {m = 2248, x = 59.8, y = 61.9, hint = "This item is an anvil found inside the building."}},                                                                                                                            -- Ancient Earthen Anvil
  [25] = {id = 25, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83849}, itemID = 226277, points = 3, loc = {m = 2339, x = 47.7, y = 26.5, hint = "This item is a hammer found on a cube."}},                                                                                                                                      -- Dornogal Hammer
  [26] = {id = 26, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83850}, itemID = 226278, points = 3, loc = {m = 2214, x = 47.7, y = 33.2, hint = "This item is a hammer vise found next to the forge."}},                                                                                                                         -- Ringing Hammer Vise
  [27] = {id = 27, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83851}, itemID = 226279, points = 3, loc = {m = 2214, x = 60.5, y = 53.7, hint = "This item is a chisel found on the ground next to the forge."}},                                                                                                                -- Earthen Chisels
  [28] = {id = 28, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83852}, itemID = 226280, points = 3, loc = {m = 2215, x = 47.6, y = 61.1, hint = "This item is an anvil found on the table."}},                                                                                                                                   -- Holy Flame Forge
  [29] = {id = 29, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83853}, itemID = 226281, points = 3, loc = {m = 2215, x = 44.0, y = 55.6, hint = "This item is a pair of tongs found on the table."}},                                                                                                                            -- Radiant Tongs
  [30] = {id = 30, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83854}, itemID = 226282, points = 3, loc = {m = 2213, x = 46.6, y = 22.7, hint = "This item is a crate found on the floor."}},                                                                                                                                    -- Nerubian Smith's Kit
  [31] = {id = 31, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83855}, itemID = 226283, points = 3, loc = {m = 2255, x = 53.0, y = 51.3, hint = "This item is a brush found on the table inside the building."}},                                                                                                                -- Spiderling's Wire Brush
  [32] = {id = 32, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84226}, itemID = 227407, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [33] = {id = 33, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84227}, itemID = 227418, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [34] = {id = 34, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84228}, itemID = 227429, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [35] = {id = 35, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85735}, itemID = 232500, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [36] = {id = 36, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87266}, itemID = 235864, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [37] = {id = 37, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83726}, itemID = 222554, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [38] = {id = 38, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84127}, itemID = 228774, points = 2, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [39] = {id = 39, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83256}, itemID = 225233, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [40] = {id = 40, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83257}, itemID = 225232, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [41] = {id = 41, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29508}, itemID = 0, points = 3, loc = {m = 407, x = 51.0, y = 81.8, hint = "Talk to |cff00ff00Yebb Neblegear|r at the Darkmoon Faire and complete the quest |cffffff00Baby Needs Two Pair of Shoes|r.\n\nHint: There is an anvil behind the heirloom tent."}},
  [42] = {id = 42, skillLineVariantID = 2872, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228726, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  [43] = {id = 43, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81076}, itemID = 227411, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [44] = {id = 44, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81077}, itemID = 227422, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [45] = {id = 45, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81078}, itemID = 227433, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [46] = {id = 46, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82635}, itemID = 224050, points = 10, loc = {m = 2213, x = 45.6, y = 33.6, hint = "This item can be purchased from the vendor Iliani in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [47] = {id = 47, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83060}, itemID = 224652, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."}, requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Enchanting Notes
  [48] = {id = 48, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83856}, itemID = 226284, points = 3, loc = {m = 2248, x = 57.6, y = 61.6, hint = "This item is a bottle found on a table."}},                                                                                                                                     -- Grinded Earthen Gem
  [49] = {id = 49, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83859}, itemID = 226285, points = 3, loc = {m = 2339, x = 57.9, y = 56.9, hint = "This item is leaning against a wooden pillar next to Clerk Gretal."}},                                                                                                          -- Silver Dornogal Rod
  [50] = {id = 50, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83860}, itemID = 226286, points = 3, loc = {m = 2214, x = 44.6, y = 22.2, hint = "This item is an orb found on the ground."}},                                                                                                                                    -- Soot-Coated Orb
  [51] = {id = 51, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83861}, itemID = 226287, points = 3, loc = {m = 2214, x = 67.1, y = 65.9, hint = "This item is a bottle found on a table inside the building."}},                                                                                                                 -- Animated Enchanting Dust
  [52] = {id = 52, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83862}, itemID = 226288, points = 3, loc = {m = 2215, x = 40.1, y = 70.5, hint = "This item is a candle found on a crate inside the building."}},                                                                                                                 -- Essence of Holy Fire
  [53] = {id = 53, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83863}, itemID = 226289, points = 3, loc = {m = 2215, x = 48.6, y = 64.5, hint = "This item is a scroll found on a table inside the building."}},                                                                                                                 -- Enchanted Arathi Scroll
  [54] = {id = 54, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83864}, itemID = 226290, points = 3, loc = {m = 2213, x = 61.6, y = 21.9, hint = "This item is a book found on a table."}},                                                                                                                                       -- Book of Dark Magic
  [55] = {id = 55, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83865}, itemID = 226291, points = 3, loc = {m = 2255, x = 57.3, y = 44.1, hint = "This item is a purple shard found on the left table."}},                                                                                                                        -- Void Shard
  [56] = {id = 56, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85736}, itemID = 232501, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [57] = {id = 57, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87265}, itemID = 235863, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [58] = {id = 58, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83727}, itemID = 222550, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [59] = {id = 59, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83258}, itemID = 225231, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [60] = {id = 60, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83259}, itemID = 225230, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [61] = {id = 61, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1, loc = {hint = "These are randomly looted from disenchanting items."}},
  [62] = {id = 62, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {84295}, itemID = 227661, points = 4, loc = {hint = "These are randomly looted from disenchanting items."}},
  [63] = {id = 63, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.TrainerQuest, quests = {84084, 84085, 84086}, itemID = 227667, points = 3, limit = 1, loc = {m = 2339, x = 52.8, y = 71.2, hint = "Talk to your enchanting trainer |cff00ff00Nagad|r and complete the quest."}},
  [64] = {id = 64, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29510}, itemID = 0, points = 3, loc = {m = 407, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Putting Trash to Good Use|r."}},
  [65] = {id = 65, skillLineVariantID = 2874, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 227662, points = 0, loc = {hint = "These are randomly looted from disenchanting items once the weekly objectives below are completed."}, requires = {{type = "quest", name = "Treasure", quests = {83258, 83259}, match = "all"}, {type = "quest", name = "Disenchanting", quests = {84290, 84291, 84292, 84293, 84294, 84295}, match = "all"}, {type = "quest", name = "Trainer Quest", quests = {84084, 84085, 84086}, match = "any"}}},
  [66] = {id = 66, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82632}, itemID = 224052, points = 10, loc = {m = 2213, x = 58.2, y = 31.6, hint = "This item can be purchased from the vendor Rukku in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [67] = {id = 67, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83063}, itemID = 224653, points = 10, loc = {m = 2214, x = 47.2, y = 32.8, hint = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."}, requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  [68] = {id = 68, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83866}, itemID = 226292, points = 3, loc = {m = 2248, x = 61.3, y = 69.6, hint = "This item is a wrench found on the table in the building."}},                      -- Rock Engineer's Wrench
  [69] = {id = 69, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83867}, itemID = 226293, points = 3, loc = {m = 2339, x = 64.7, y = 52.7, hint = "This item can be found on the table behind Madam Goya."}},                         -- Dornogal Spectacles
  [70] = {id = 70, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83868}, itemID = 226294, points = 3, loc = {m = 2214, x = 42.6, y = 27.3, hint = "This item is a bomb on a crate next to the rails."}},                              -- Inert Mining Bomb
  [71] = {id = 71, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83869}, itemID = 226295, points = 3, loc = {m = 2214, x = 64.5, y = 58.8, hint = "This item is a scroll found on the floor behind the table inside the building."}}, -- Earthen Construct Blueprints
  [72] = {id = 72, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83870}, itemID = 226296, points = 3, loc = {m = 2215, x = 46.4, y = 61.5, hint = "This item is a bag found at the top of the stairs."}},                             -- Holy Firework Dud
  [73] = {id = 73, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83871}, itemID = 226297, points = 3, loc = {m = 2215, x = 41.6, y = 48.9, hint = "This item is a box found on the airship behind the dungeon entrance."}},           -- Arathi Safety Gloves
  [74] = {id = 74, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83872}, itemID = 226298, points = 3, loc = {m = 2255, x = 56.8, y = 38.7, hint = "This item is a mechanical spider found on the table at the back of the inn."}},    -- Puppeted Mechanical Spider
  [75] = {id = 75, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83873}, itemID = 226299, points = 3, loc = {m = 2213, x = 63.1, y = 11.5, hint = "This item is a canister found on the floor next to the harpoon."}},                -- Emptied Venom Canister
  [76] = {id = 76, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84229}, itemID = 227412, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [77] = {id = 77, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84230}, itemID = 227423, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [78] = {id = 78, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84231}, itemID = 227434, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [79] = {id = 79, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85737}, itemID = 232507, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [80] = {id = 80, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87264}, itemID = 235862, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [81] = {id = 81, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83728}, itemID = 222621, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [82] = {id = 82, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84128}, itemID = 228775, points = 1, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [83] = {id = 83, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83260}, itemID = 225228, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [84] = {id = 84, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83261}, itemID = 225229, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [85] = {id = 85, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29511}, itemID = 0, points = 3, loc = {m = 407, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Talkin' Tonks|r."}},
  [86] = {id = 86, skillLineVariantID = 2875, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228730, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  [87] = {id = 87, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81422}, itemID = 227415, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [88] = {id = 88, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81423}, itemID = 227426, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [89] = {id = 89, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81424}, itemID = 227437, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [90] = {id = 90, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82630}, itemID = 224023, points = 10, loc = {m = 2213, x = 47.0, y = 16.2, hint = "This item can be purchased from the vendor Llyot in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [91] = {id = 91, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83066}, itemID = 224656, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."}, requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  [92] = {id = 92, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83874}, itemID = 226300, points = 3, loc = {m = 2248, x = 57.6, y = 61.5, hint = "This item is a flower found in a bed of flowers."}},              -- Ancient Flower
  [93] = {id = 93, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83875}, itemID = 226301, points = 3, loc = {m = 2339, x = 59.2, y = 23.7, hint = "This item is a scythe found at the bottom of the tree."}},        -- Dornogal Gardening Scythe
  [94] = {id = 94, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83876}, itemID = 226302, points = 3, loc = {m = 2214, x = 44.13, y = 35.03, hint = "This item is a fork found on the table inside the building."}}, -- Earthen Digging Fork
  [95] = {id = 95, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83877}, itemID = 226303, points = 3, loc = {m = 2214, x = 48.72, y = 65.81, hint = "This item is a knife found on the ground."}},                   -- Fungarian Slicer's Knife
  [96] = {id = 96, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83878}, itemID = 226304, points = 3, loc = {m = 2215, x = 47.8, y = 63.3, hint = "This item is a trowel found on the ground."}},                    -- Arathi Garden Trowel
  [97] = {id = 97, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83879}, itemID = 226305, points = 3, loc = {m = 2215, x = 35.9, y = 55.0, hint = "This item is a pair of tongs found next to the stairs."}},        -- Arathi Herb Pruner
  [98] = {id = 98, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83880}, itemID = 226306, points = 3, loc = {m = 2213, x = 54.7, y = 20.8, hint = "This item is a flower found on the ground under the statue."}},   -- Web-Entangled Lotus
  [99] = {id = 99, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83881}, itemID = 226307, points = 3, loc = {m = 2213, x = 46.7, y = 16.0, hint = "This item is a shovel found on the desk."}},                      -- Tunneler's Shovel
  [100] = {id = 100, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85738}, itemID = 232503, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [101] = {id = 101, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87263}, itemID = 235861, points = 15, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [102] = {id = 102, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83729}, itemID = 222552, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [103] = {id = 103, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {81416, 81417, 81418, 81419, 81420}, itemID = 224264, points = 1, loc = {hint = "These are randomly looted from herbs around the world."}},
  [104] = {id = 104, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {81421}, itemID = 224265, points = 4, loc = {hint = "These are randomly looted from herbs around the world."}},
  [105] = {id = 105, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.TrainerQuest, quests = {82970, 82958, 82965, 82916, 82962}, itemID = 224817, points = 3, limit = 1, loc = {m = 2339, x = 44.8, y = 69.4, hint = "Talk to your herbalism trainer |cff00ff00Akdan|r and complete the quest."}},
  [106] = {id = 106, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29514}, itemID = 0, points = 3, loc = {m = 407, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Herbs for Healing|r."}},
  [107] = {id = 107, skillLineVariantID = 2877, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 224835, points = 0, loc = {hint = "These are randomly looted from herbs around the world once the weekly objectives below are completed."}, requires = {{type = "quest", name = "Trainer Quest", quests = {82970, 82958, 82965, 82916, 82962}, match = "any"}, {type = "quest", name = "Gathering", quests = {81416, 81417, 81418, 81419, 81420, 81421}, match = "all"}}},
  [108] = {id = 108, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80749}, itemID = 227408, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [109] = {id = 109, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80750}, itemID = 227419, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [110] = {id = 110, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80751}, itemID = 227430, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [111] = {id = 111, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82636}, itemID = 224053, points = 10, loc = {m = 2213, x = 42.2, y = 26.8, hint = "This item can be purchased from the vendor Nuel Prill in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [112] = {id = 112, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83064}, itemID = 224654, points = 10, loc = {m = 2214, x = 47.2, y = 32.8, hint = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."}, requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  [113] = {id = 113, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83882}, itemID = 226308, points = 3, loc = {m = 2339, x = 57.2, y = 47.1, hint = "This item is a quill found on the shelf in the back of the auction house."}},      -- Dornogal Scribe's Quill
  [114] = {id = 114, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83883}, itemID = 226309, points = 3, loc = {m = 2248, x = 56.0, y = 60.1, hint = "This item is a pen found on the shelf in the building."}},                         -- Historian's Dip Pen
  [115] = {id = 115, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83884}, itemID = 226310, points = 3, loc = {m = 2214, x = 48.5, y = 34.2, hint = "This item is a scroll found on the table inside the building."}},                  -- Runic Scroll
  [116] = {id = 116, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83885}, itemID = 226311, points = 3, loc = {m = 2214, x = 62.5, y = 58.1, hint = "This item is a pot found on the table inside the building."}},                     -- Blue Earthen Pigment
  [117] = {id = 117, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83886}, itemID = 226312, points = 3, loc = {m = 2215, x = 43.2, y = 58.9, hint = "This item is a pen found on the table at the top of the stairs."}},                -- Informant's Fountain Pen
  [118] = {id = 118, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83887}, itemID = 226313, points = 3, loc = {m = 2215, x = 42.8, y = 49.1, hint = "This item is a chisel found on the table on the top floor inside the building."}}, -- Calligrapher's Chiseled Marker
  [119] = {id = 119, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83888}, itemID = 226314, points = 3, loc = {m = 2255, x = 55.9, y = 43.9, hint = "This item is a scroll found on the floor of the center main platform."}},          -- Nerubian Texts
  [120] = {id = 120, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83889}, itemID = 226315, points = 3, loc = {m = 2213, x = 50.1, y = 31.0, hint = "This item is an ink well found on the desk inside the building."}},                -- Venomancer's Ink Well
  [121] = {id = 121, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85739}, itemID = 232508, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [122] = {id = 122, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87262}, itemID = 235860, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [123] = {id = 123, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83730}, itemID = 222548, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [124] = {id = 124, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84129}, itemID = 228776, points = 2, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [125] = {id = 125, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83262}, itemID = 225227, points = 2, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [126] = {id = 126, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83264}, itemID = 225226, points = 2, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [127] = {id = 127, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29515}, itemID = 0, points = 3, loc = {m = 407, x = 53.2, y = 76.6, hint = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Writing the Future|r"}, requires = {{type = "item", id = 39354, amount = 5}}},
  [128] = {id = 128, skillLineVariantID = 2878, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228732, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  [129] = {id = 129, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81259}, itemID = 227413, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [130] = {id = 130, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81260}, itemID = 227424, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [131] = {id = 131, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81261}, itemID = 227435, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [132] = {id = 132, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82637}, itemID = 224054, points = 10, loc = {m = 2213, x = 47.6, y = 18.6, hint = "This item can be purchased from the vendor Alvus Valavulu in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}}, -- Emergent Crystals of the Surface-Dwellers
  [133] = {id = 133, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83065}, itemID = 224655, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."}, requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  [134] = {id = 134, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83890}, itemID = 226316, points = 3, loc = {m = 2248, x = 63.5, y = 66.8, hint = "This item can be found in an object on the location below."}},
  [135] = {id = 135, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83891}, itemID = 226317, points = 3, loc = {m = 2339, x = 34.9, y = 52.3, hint = "This item can be found in an object on the location below."}},
  [136] = {id = 136, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83892}, itemID = 226318, points = 3, loc = {m = 2214, x = 48.5, y = 35.2, hint = "This item can be found in an object on the location below."}},
  [137] = {id = 137, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83893}, itemID = 226319, points = 3, loc = {m = 2214, x = 57.0, y = 54.6, hint = "This item can be found in an object on the location below."}},
  [138] = {id = 138, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83894}, itemID = 226320, points = 3, loc = {m = 2215, x = 47.5, y = 60.7, hint = "This item can be found in an object on the location below."}},
  [139] = {id = 139, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83895}, itemID = 226321, points = 3, loc = {m = 2215, x = 44.7, y = 50.9, hint = "This item can be found in an object on the location below."}},
  [140] = {id = 140, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83896}, itemID = 226322, points = 3, loc = {m = 2213, x = 47.7, y = 19.5, hint = "This item can be found in an object on the location below."}},
  [141] = {id = 141, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83897}, itemID = 226323, points = 3, loc = {m = 2255, x = 56.1, y = 58.7, hint = "This item can be found in an object on the location below."}},
  [142] = {id = 142, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85740}, itemID = 232504, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [143] = {id = 143, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87261}, itemID = 235859, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [144] = {id = 144, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83731}, itemID = 222551, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [145] = {id = 145, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84130}, itemID = 228777, points = 2, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [146] = {id = 146, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83265}, itemID = 225224, points = 2, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [147] = {id = 147, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83266}, itemID = 225225, points = 2, loc = {hint = "These are randomly looted from treasures and dirt around the world."}}, -- Deepstone Fragment
  [148] = {id = 148, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29516}, itemID = 0, points = 3, loc = {m = 407, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Keeping the Faire Sparkling|r."}},
  [149] = {id = 149, skillLineVariantID = 2879, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228734, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  [150] = {id = 150, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80978}, itemID = 227414, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [151] = {id = 151, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80979}, itemID = 227425, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [152] = {id = 152, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80980}, itemID = 227436, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [153] = {id = 153, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82626}, itemID = 224056, points = 10, loc = {m = 2213, x = 43.5, y = 19.7, hint = "This item can be purchased from the vendor Kama in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [154] = {id = 154, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83068}, itemID = 224658, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."}, requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  [155] = {id = 155, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83898}, itemID = 226324, points = 3, loc = {m = 2339, x = 68.1, y = 23.3, hint = "This item is a tool found on the rack inside the building."}},           -- Earthen Lacing Tools
  [156] = {id = 156, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83899}, itemID = 226325, points = 3, loc = {m = 2248, x = 58.7, y = 30.7, hint = "This item is a knife found on a hay bale inside the building."}},        -- Dornogal Craftman's Flat Knife
  [157] = {id = 157, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83900}, itemID = 226326, points = 3, loc = {m = 2214, x = 47.1, y = 34.8, hint = "This item is a bottle found on the shelf inside the building."}},        -- Underground Stropping Compound
  [158] = {id = 158, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83901}, itemID = 226327, points = 3, loc = {m = 2214, x = 64.3, y = 65.2, hint = "This item is a tool found on the table inside the building."}},          -- Earthen Awl
  [159] = {id = 159, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83902}, itemID = 226328, points = 3, loc = {m = 2215, x = 47.5, y = 65.1, hint = "This item is a pair of tongs found on the table inside the building."}}, -- Arathi Beveler Set
  [160] = {id = 160, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83903}, itemID = 226329, points = 3, loc = {m = 2215, x = 41.5, y = 57.8, hint = "This item is a tool found on a barrel."}},                               -- Arathi Leather Burnisher
  [161] = {id = 161, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83904}, itemID = 226330, points = 3, loc = {m = 2213, x = 55.2, y = 26.8, hint = "This item is a mallet found on the table inside the building."}},        -- Nerubian Tanning Mallet
  [162] = {id = 162, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83905}, itemID = 226331, points = 3, loc = {m = 2255, x = 60.0, y = 53.9, hint = "This item is a knife found on the desk."}},                              -- Curved Nerubian Skinning Knife
  [163] = {id = 163, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85741}, itemID = 232505, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [164] = {id = 164, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87260}, itemID = 235858, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [165] = {id = 165, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83732}, itemID = 222549, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [166] = {id = 166, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84131}, itemID = 228778, points = 2, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [167] = {id = 167, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83267}, itemID = 225223, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [168] = {id = 168, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83268}, itemID = 225222, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [169] = {id = 169, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29517}, itemID = 0, points = 3, loc = {m = 407, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Eyes on the Prizes|r."}, requires = {{type = "item", id = 6529, amount = 10}, {type = "item", id = 2320, amount = 5}, {type = "item", id = 6260, amount = 5}}},
  [170] = {id = 170, skillLineVariantID = 2880, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228736, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
  [171] = {id = 171, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81390}, itemID = 227416, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [172] = {id = 172, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81391}, itemID = 227427, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [173] = {id = 173, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {81392}, itemID = 227438, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [174] = {id = 174, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82614}, itemID = 224055, points = 10, loc = {m = 2213, x = 46.6, y = 21.6, hint = "This item can be purchased from the vendor Rakka in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [175] = {id = 175, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83062}, itemID = 224651, points = 10, loc = {m = 2214, x = 47.2, y = 32.8, hint = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."}, requires = {{type = "renown", id = 2594, amount = 12}, {type = "item", id = 210814, amount = 50}}},
  [176] = {id = 176, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83906}, itemID = 226332, points = 3, loc = {m = 2248, x = 58.2, y = 62.0, hint = "This item is a gavel found on the table."}},                               -- Earthen Miner's Gavel
  [177] = {id = 177, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83907}, itemID = 226333, points = 3, loc = {m = 2339, x = 36.6, y = 79.3, hint = "This item is a chisel found on the crystal statue."}},                     -- Dornogal Chisel
  [178] = {id = 178, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83908}, itemID = 226334, points = 3, loc = {m = 2214, x = 45.3, y = 27.5, hint = "This item is a shovel found on the ground."}},                             -- Earthen Excavator's Shovel
  [179] = {id = 179, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83909}, itemID = 226335, points = 3, loc = {m = 2214, x = 62.09, y = 66.23, hint = "This item is ore found on the ground."}},                                -- Regenerating Ore
  [180] = {id = 180, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83910}, itemID = 226336, points = 3, loc = {m = 2215, x = 46.1, y = 64.5, hint = "This item is a drill found on the table under the building."}},            -- Arathi Precision Drill
  [181] = {id = 181, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83911}, itemID = 226337, points = 3, loc = {m = 2215, x = 43.1, y = 56.8, hint = "This item is a tool found on the table behind the mining trainer."}},      -- Devout Archaeologist's Excavator
  [182] = {id = 182, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83912}, itemID = 226338, points = 3, loc = {m = 2213, x = 46.8, y = 21.4, hint = "This item is a crusher found on the desk near the forge."}},               -- Heavy Spider Crusher
  [183] = {id = 183, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83913}, itemID = 226339, points = 3, loc = {m = 2213, x = 48.1, y = 40.7, hint = "This item is a cart found on the ground between the flowers and roots."}}, -- Nerubian Mining Supplies
  [184] = {id = 184, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85742}, itemID = 232509, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [185] = {id = 185, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87259}, itemID = 235857, points = 15, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [186] = {id = 186, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83733}, itemID = 222553, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [187] = {id = 187, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {83050, 83051, 83052, 83053, 83054}, itemID = 224583, points = 1, loc = {hint = "These are randomly looted from mining nodes around the world."}},
  [188] = {id = 188, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {83049}, itemID = 224584, points = 3, loc = {hint = "These are randomly looted from mining nodes around the world."}},
  [189] = {id = 189, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.TrainerQuest, quests = {83104, 83105, 83103, 83106, 83102}, itemID = 224818, points = 3, limit = 1, loc = {m = 2339, x = 52.6, y = 52.6, hint = "Talk to your mining trainer |cff00ff00Tarib|r and complete the quest."}},
  [190] = {id = 190, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29518}, itemID = 0, points = 3, loc = {m = 407, x = 49.6, y = 60.8, hint = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Rearm, Reuse, Recycle|r."}},
  [191] = {id = 191, skillLineVariantID = 2881, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 224838, points = 0, loc = {hint = "These are randomly looted from mining nodes around the world. once the weekly objectives below are completed."}, requires = {{type = "quest", name = "Trainer Quest", quests = {83104, 83105, 83103, 83106, 83102}, match = "any"}, {type = "quest", name = "Gathering", quests = {83050, 83051, 83052, 83053, 83054, 83049}, match = "all"}}},
  [192] = {id = 192, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82596}, itemID = 224007, points = 10, loc = {m = 2213, x = 43.5, y = 19.7, hint = "This item can be purchased from the vendor Kama in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [193] = {id = 193, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83067}, itemID = 224657, points = 10, loc = {m = 2215, x = 42.4, y = 55.0, hint = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."}, requires = {{type = "renown", id = 2570, amount = 14}, {type = "item", id = 210814, amount = 50}}},
  [194] = {id = 194, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83914}, itemID = 226340, points = 3, loc = {m = 2339, x = 28.7, y = 51.8, hint = "This item can be found in an object on the location below."}},
  [195] = {id = 195, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83915}, itemID = 226341, points = 3, loc = {m = 2248, x = 60.0, y = 28.0, hint = "This item can be found in an object on the location below."}},
  [196] = {id = 196, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83916}, itemID = 226342, points = 3, loc = {m = 2214, x = 47.3, y = 28.4, hint = "This item can be found in an object on the location below."}},
  [197] = {id = 197, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83917}, itemID = 226343, points = 3, loc = {m = 2214, x = 65.8, y = 61.9, hint = "This item can be found in an object on the location below."}},
  [198] = {id = 198, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83918}, itemID = 226344, points = 3, loc = {m = 2215, x = 49.3, y = 62.1, hint = "This item can be found in an object on the location below."}},
  [199] = {id = 199, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83919}, itemID = 226345, points = 3, loc = {m = 2215, x = 42.3, y = 53.9, hint = "This item can be found in an object on the location below."}},
  [200] = {id = 200, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83920}, itemID = 226346, points = 3, loc = {m = 2213, x = 44.6, y = 49.3, hint = "This item can be found in an object on the location below."}},
  [201] = {id = 201, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83921}, itemID = 226347, points = 3, loc = {m = 2255, x = 56.5, y = 55.2, hint = "This item can be found in an object on the location below."}},
  [202] = {id = 202, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84232}, itemID = 227417, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [203] = {id = 203, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84233}, itemID = 227428, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [204] = {id = 204, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {84234}, itemID = 227439, points = 15, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [205] = {id = 205, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85744}, itemID = 232506, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [206] = {id = 206, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87258}, itemID = 235856, points = 15, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [207] = {id = 207, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83734}, itemID = 222649, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [208] = {id = 208, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {81459, 81460, 81461, 81462, 81463}, itemID = 224780, points = 1, loc = {hint = "These are randomly looted from skinning around the world."}},
  [209] = {id = 209, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.Gathering, quests = {81464}, itemID = 224781, points = 2, loc = {hint = "These are randomly looted from skinning around the world."}},
  [210] = {id = 210, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.TrainerQuest, quests = {83097, 83098, 83100, 82992, 82993}, itemID = 224807, points = 3, limit = 1, loc = {m = 2339, x = 54.4, y = 57.6, hint = "Talk to your skinning trainer |cff00ff00Ginnad|r and complete the quest."}},
  [211] = {id = 211, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29519}, itemID = 0, points = 3, loc = {m = 407, x = 55.0, y = 70.6, hint = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Tan My Hide|r."}},
  [212] = {id = 212, skillLineVariantID = 2882, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 224782, points = 0, loc = {hint = "These are randomly looted from skinning around the world once the weekly objectives below are completed."}, requires = {{type = "quest", name = "Trainer Quest", quests = {83097, 83098, 83100, 82992, 82993}, match = "any"}, {type = "quest", name = "Gathering", quests = {81459, 81460, 81461, 81462, 81463, 81464}, match = "all"}}},
  [213] = {id = 213, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80871}, itemID = 227410, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 200}}},
  [214] = {id = 214, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80872}, itemID = 227421, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 300}}},
  [215] = {id = 215, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {80873}, itemID = 227432, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."}, requires = {{type = "item", id = 210814, amount = 400}}},
  [216] = {id = 216, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {82634}, itemID = 224036, points = 10, loc = {m = 2213, x = 50.2, y = 16.8, hint = "This item can be purchased from the vendor Saaria in City of Threads."}, requires = {{type = "currency", id = 3056, amount = 565}}},
  [217] = {id = 217, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83061}, itemID = 224648, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."}, requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}}, -- Jewel-Etched Tailoring Notes
  [218] = {id = 218, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83922}, itemID = 226348, points = 3, loc = {m = 2339, x = 61.5, y = 18.7, hint = "This item is a knife found on the table in the back of the building."}},                                                                                                        -- Dornogal Seam Ripper
  [219] = {id = 219, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83923}, itemID = 226349, points = 3, loc = {m = 2248, x = 56.2, y = 61.0, hint = "This item is a tape measure found on the table."}},                                                                                                                             -- Earthen Tape Measure
  [220] = {id = 220, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83924}, itemID = 226350, points = 3, loc = {m = 2214, x = 48.9, y = 32.8, hint = "This item is a pin found on the shelf in the back right room of the inn."}},                                                                                                    -- Runed Earthen Pins
  [221] = {id = 221, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83925}, itemID = 226351, points = 3, loc = {m = 2214, x = 64.2, y = 60.3, hint = "This item is a pair of scisssors found on the table."}},                                                                                                                        -- Earthen Sticher's Snips
  [222] = {id = 222, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83926}, itemID = 226352, points = 3, loc = {m = 2215, x = 49.3, y = 62.3, hint = "This item is a cutter found on the table."}},                                                                                                                                   -- Arathi Rotary Cutter
  [223] = {id = 223, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83927}, itemID = 226353, points = 3, loc = {m = 2215, x = 40.1, y = 68.1, hint = "This item is a protractor found on a crate inside the building."}},                                                                                                             -- Royal Outfitter's Protractor
  [224] = {id = 224, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83928}, itemID = 226354, points = 3, loc = {m = 2255, x = 53.3, y = 53.0, hint = "This item is a quilt found inside the building to the left."}},                                                                                                                 -- Nerubian Quilt
  [225] = {id = 225, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {83929}, itemID = 226355, points = 3, loc = {m = 2213, x = 50.5, y = 16.7, hint = "This item is a pincushian found on the desk."}},                                                                                                                                -- Nerubian's Pincushion
  [226] = {id = 226, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {85745}, itemID = 232502, points = 10, loc = {m = 2346, x = 43.8, y = 50.8, hint = "<Renown Quartermaster> Smaks Topskimmer"}, requires = {{type = "renown", id = 2653, amount = 16}, {type = "item", id = 210814, amount = 50}}},
  [227] = {id = 227, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Unique, quests = {87257}, itemID = 235855, points = 10, loc = {m = 2472, x = 40.6, y = 29.0, hint = "<Renown Quartermaster> Om'sirik"}, requires = {{type = "renown", id = 2658, amount = 12}, {type = "item", id = 210814, amount = 75}, {type = "skill", amount = 25}}},
  [228] = {id = 228, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treatise, quests = {83735}, itemID = 222547, points = 1, loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
  [229] = {id = 229, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.ArtisanQuest, quests = {84132}, itemID = 228779, points = 2, loc = {m = 2339, x = 59.2, y = 55.6, hint = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."}},
  [230] = {id = 230, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83269}, itemID = 225221, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [231] = {id = 231, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.Treasure, quests = {83270}, itemID = 225220, points = 1, loc = {hint = "These are randomly looted from treasures and dirt around the world."}},
  [232] = {id = 232, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.DarkmoonQuest, quests = {29520}, itemID = 0, points = 3, loc = {m = 407, x = 55.6, y = 55.8, hint = "Talk to |cff00ff00Selina Dourman|r at the Darkmoon Faire and complete the quest |cffffff00Banners, Banners Everywhere!|r"}, requires = {{type = "item", id = 2320, amount = 1}, {type = "item", id = 2604, amount = 1}, {type = "item", id = 6260, amount = 1}}},
  [233] = {id = 233, skillLineVariantID = 2883, categoryID = Enum.WK_ObjectiveCategory.CatchUp, quests = {}, itemID = 228738, points = 0, loc = {hint = "Awarded from Patron Orders at your crafting station."}},
}

---@type table<integer, WK_SkillLine>
Data.SkillLines = {
  [171] = {id = 171, name = "Alchemy"},
  [164] = {id = 164, name = "Blacksmithing"},
  [333] = {id = 333, name = "Enchanting"},
  [202] = {id = 202, name = "Engineering"},
  [182] = {id = 182, name = "Herbalism"},
  [773] = {id = 773, name = "Inscription"},
  [755] = {id = 755, name = "Jewelcrafting"},
  [165] = {id = 165, name = "Leatherworking"},
  [186] = {id = 186, name = "Mining"},
  [393] = {id = 393, name = "Skinning"},
  [197] = {id = 197, name = "Tailoring"},
}

---@type table<integer, WK_SkillLineVariant>
Data.SkillLineVariants = {
  -- Dragonflight (Dragon Isles)
  [2823] = {id = 2823, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 171, name = "Dragon Isles Alchemy", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2822] = {id = 2822, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 164, name = "Dragon Isles Blacksmithing", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2825] = {id = 2825, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 333, name = "Dragon Isles Enchanting", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2827] = {id = 2827, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 202, name = "Dragon Isles Engineering", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2832] = {id = 2832, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 182, name = "Dragon Isles Herbalism", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2828] = {id = 2828, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 773, name = "Dragon Isles Inscription", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2829] = {id = 2829, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 755, name = "Dragon Isles Jewelcrafting", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2830] = {id = 2830, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 165, name = "Dragon Isles Leatherworking", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2833] = {id = 2833, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 186, name = "Dragon Isles Mining", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2834] = {id = 2834, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 393, name = "Dragon Isles Skinning", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2831] = {id = 2831, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 197, name = "Dragon Isles Tailoring", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  -- The War Within (Khaz Algar)
  [2871] = {id = 2871, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 171, name = "Khaz Algar Alchemy", spellID = 423321, catchUpCurrencyID = 3057, catchUpWeeklyCap = 0, catchUpItemID = 228724},
  [2872] = {id = 2872, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 164, name = "Khaz Algar Blacksmithing", spellID = 423332, catchUpCurrencyID = 3058, catchUpWeeklyCap = 0, catchUpItemID = 228726},
  [2874] = {id = 2874, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 333, name = "Khaz Algar Enchanting", spellID = 423334, catchUpCurrencyID = 3059, catchUpWeeklyCap = 0, catchUpItemID = 227662},
  [2875] = {id = 2875, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 202, name = "Khaz Algar Engineering", spellID = 423335, catchUpCurrencyID = 3060, catchUpWeeklyCap = 0, catchUpItemID = 228730},
  [2877] = {id = 2877, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 182, name = "Khaz Algar Herbalism", spellID = 441327, catchUpCurrencyID = 3061, catchUpWeeklyCap = 0, catchUpItemID = 224835},
  [2878] = {id = 2878, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 773, name = "Khaz Algar Inscription", spellID = 423338, catchUpCurrencyID = 3062, catchUpWeeklyCap = 0, catchUpItemID = 228732},
  [2879] = {id = 2879, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 755, name = "Khaz Algar Jewelcrafting", spellID = 423339, catchUpCurrencyID = 3063, catchUpWeeklyCap = 0, catchUpItemID = 228734},
  [2880] = {id = 2880, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 165, name = "Khaz Algar Leatherworking", spellID = 423340, catchUpCurrencyID = 3064, catchUpWeeklyCap = 0, catchUpItemID = 228736},
  [2881] = {id = 2881, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 186, name = "Khaz Algar Mining", spellID = 423341, catchUpCurrencyID = 3065, catchUpWeeklyCap = 0, catchUpItemID = 224838},
  [2882] = {id = 2882, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 393, name = "Khaz Algar Skinning", spellID = 423342, catchUpCurrencyID = 3066, catchUpWeeklyCap = 0, catchUpItemID = 224782},
  [2883] = {id = 2883, expansionID = Enum.ExpansionLevel.WarWithin, skillLineID = 197, name = "Khaz Algar Tailoring", spellID = 423343, catchUpCurrencyID = 3067, catchUpWeeklyCap = 0, catchUpItemID = 228738},
  -- Midnight
  [2906] = {id = 2906, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 171, name = "Midnight Alchemy", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2907] = {id = 2907, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 164, name = "Midnight Blacksmithing", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2909] = {id = 2909, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 333, name = "Midnight Enchanting", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2910] = {id = 2910, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 202, name = "Midnight Engineering", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2912] = {id = 2912, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 182, name = "Midnight Herbalism", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2913] = {id = 2913, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 773, name = "Midnight Inscription", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2914] = {id = 2914, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 755, name = "Midnight Jewelcrafting", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2915] = {id = 2915, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 165, name = "Midnight Leatherworking", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2916] = {id = 2916, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 186, name = "Midnight Mining", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2917] = {id = 2917, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 393, name = "Midnight Skinning", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
  [2918] = {id = 2918, expansionID = Enum.ExpansionLevel.Midnight, skillLineID = 197, name = "Midnight Tailoring", spellID = 0, catchUpCurrencyID = 0, catchUpWeeklyCap = 0, catchUpItemID = 0},
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
    -- Move enabled setting to saved professions only
    if self.db.global.DBVersion == 8 then
      for characterGUID, character in pairs(self.db.global.characters) do
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
      local objectiveCategory = self.ObjectiveCategories[objective.categoryID]
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

function Data:ScanCharacter()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local objectives = self:GetObjectives()
  local character = self:GetCharacter()
  local skillLineVariants = self:GetSkillLineVariants()
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

  local tradeSkillLines = C_TradeSkillUI.GetAllProfessionTradeSkillLines()
  if not tradeSkillLines then return end

  Utils:TableForEach(tradeSkillLines, function(tradeSkillLineID)
    -- skip professions we don't care about
    local skillLineVariant = skillLineVariants[tradeSkillLineID]
    if not skillLineVariant then return end

    -- Is the profession learned?
    local info = C_TradeSkillUI.GetProfessionInfoBySkillLineID(tradeSkillLineID)
    if not info or not info.skillLevel or info.skillLevel <= 0 then return end

    -- Preserve enabled state
    local enabled = Utils:TableFind(character.professions, function(characterProfession)
      return characterProfession.skillLineVariantID == tradeSkillLineID and characterProfession.enabled
    end)

    -- Create profession object
    ---@type WK_CharacterProfession
    local profession = {
      enabled = enabled and true or false,
      skillLineID = info.professionID,
      skillLineVariantID = tradeSkillLineID,
      skillLevel = info.skillLevel,
      skillMaxLevel = info.maxSkillLevel,
      knowledgeLevel = 0,
      knowledgeMaxLevel = 0,
      knowledgeUnspent = 0,
      specializations = {},
      catchUpCurrencyInfo = nil,
    }

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

              table.insert(profession.specializations, specialization)
            end
          end)
        end
      end
    end

    profession.knowledgeLevel = totalKnowledgeLevel
    profession.knowledgeMaxLevel = totalKnowledgeMaxLevel

    table.insert(professions, profession)
  end)

  character.professions = professions

  -- Track completed quests
  local completedQuests = {}
  Utils:TableForEach(objectives, function(objective)
    if not objective.quests then return end
    Utils:TableForEach(objective.quests, function(questID)
      if completedQuests[questID] or self.cache.completedQuests[questID] then return end
      completedQuests[questID] = C_QuestLog.IsQuestFlaggedCompleted(questID)
      if completedQuests[questID] then
        self.cache.completedQuests[questID] = true
      end
    end)
  end)
  character.completed = completedQuests

  -- Don't track a character without any professions
  if Utils:TableCount(character.professions) < 1 then
    self.db.global.characters[character.GUID] = nil
  end
end

---@return table<WOWGUID, WK_Character>
function Data:GetCharacters()
  local characters = Utils:TableFilter(self.db.global.characters, function(character)
    -- Ignore ghost characters (Bug: https://github.com/DennisRas/WeeklyKnowledge/issues/47)
    return (character.name and character.name ~= "")
  end)

  table.sort(characters, function(a, b)
    if type(a.lastUpdate) == "number" and type(b.lastUpdate) == "number" then
      return a.lastUpdate > b.lastUpdate
    end
    return strcmputf8i(a.name, b.name) < 0
  end)

  return characters
end

---@return table<Enum.ExpansionLevel, WK_Expansion>
function Data:GetExpansions()
  return self.Expansions
end

---@return table<integer, WK_SkillLineVariant>
function Data:GetSkillLineVariants()
  return self.SkillLineVariants
end

---@return table<integer, WK_Objective>
function Data:GetObjectives()
  return self.Objectives
end

---@return table<Enum.WK_ObjectiveCategory, WK_ObjectiveCategory>
function Data:GetObjectiveCategories()
  return self.ObjectiveCategories
end

---@return WK_Progress[]
function Data:GetWeeklyProgress()
  local skillLineVariants = self:GetSkillLineVariants()
  local characters = self:GetCharacters()
  local objectives = self:GetObjectives()
  local objectiveCategories = self:GetObjectiveCategories()

  self.cache.weeklyProgress = wipe(self.cache.weeklyProgress or {})
  Utils:TableForEach(characters, function(character)
    local completed = (type(character.completed) == "table" and character.completed) or {}
    Utils:TableForEach(character.professions, function(characterProfession)
      local variant = skillLineVariants[characterProfession.skillLineVariantID]
      if not variant then return end

      local sumPointsEarned = 0
      local sumPointsTotal = 0

      for objectiveId, objective in pairs(objectives) do
        if objective.skillLineVariantID ~= characterProfession.skillLineVariantID or not objective.quests then
          -- skip
        elseif objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
          -- handled below
        else
          ---@type WK_Progress
          local progress = {
            characterGUID = character.GUID,
            objectiveId = objectiveId,
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
        for objectiveId, objective in pairs(self.Objectives) do
          if objective.skillLineVariantID == characterProfession.skillLineVariantID and objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
            ---@type WK_Progress
            local progress = {
              characterGUID = character.GUID,
              objectiveId = objectiveId,
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
