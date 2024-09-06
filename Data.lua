---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = {}
addon.Data = Data

local Utils = addon.Utils
local AceDB = LibStub("AceDB-3.0")

---@type WK_DataCache
Data.cache = {
  isDarkmoonOpen = false,
  items = {},
}

Data.DBVersion = 4
Data.defaultDB = {
  ---@type WK_DefaultGlobal
  global = {
    weeklyReset = 0,
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
      hideTableHeader = false,
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

---@type WK_Objective[]
Data.Objectives = {
  {
    id = Enum.WK_Objectives.Unique,
    name = "Uniques",
    description = "These are one-time knowledge point items found in treasures around the world and sold by Artisan/Renown/Kej vendors.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),
    type = "item",
    repeatable = "No",
  },
  {
    id = Enum.WK_Objectives.Treatise,
    name = "Treatise",
    description = "These can be crafted by scribers. Send a Crafting Order if you don't have the inscription profession.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "item",
    repeatable = "Weekly",
  },
  {
    id = Enum.WK_Objectives.ArtisanQuest,
    name = "Artisan",
    description = "Quest: Kala Clayhoof from Artisan's Consortium wants you to fulfill Crafting Orders.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "quest",
    repeatable = "Weekly",
  },
  {
    id = Enum.WK_Objectives.Treasure,
    name = "Treasure",
    description = "These are randomly looted from treasures and dirt around the world.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "item",
    repeatable = "Weekly",
  },
  {
    id = Enum.WK_Objectives.Gathering,
    name = "Gathering",
    description = "These are randomly looted from gathering nodes around the world. You may (not confirmed) randomly find additional items beyond the weekly limit.\n\nThese are also looted from Disenchanting.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "item",
    repeatable = "Weekly",
  },
  {
    id = Enum.WK_Objectives.TrainerQuest,
    name = "Trainer",
    description = "Quest: Complete a quest at your profession trainer.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
    type = "quest",
    repeatable = "Weekly",
  },
  {
    id = Enum.WK_Objectives.DarkmoonQuest,
    name = "Darkmoon",
    description = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Monthly"),
    type = "quest",
    repeatable = "Monthly",
  },
}

---@type WK_Profession[]
Data.Professions = {
  {
    name = "Alchemy",
    skillLineID = 171,
    skillLineVariantID = 2871,
    spellID = 423321,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81146}, itemID = 227409, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81147}, itemID = 227420, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81148}, itemID = 227431, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82633}, itemID = 224024, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83058}, itemID = 224645, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83840}, itemID = 226265, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83841}, itemID = 226266, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83842}, itemID = 226267, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83843}, itemID = 226268, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83844}, itemID = 226269, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83845}, itemID = 226270, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83846}, itemID = 226271, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83847}, itemID = 226272, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83725}, itemID = 222546, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84133}, itemID = 228773, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83253}, itemID = 225234, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83255}, itemID = 225235, points = 2},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29506}, itemID = 0,      points = 3},
    }
  },
  {
    name = "Blacksmithing",
    skillLineID = 164,
    skillLineVariantID = 2872,
    spellID = 423332,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82631}, itemID = 224038, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83059}, itemID = 224647, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83848}, itemID = 226276, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83849}, itemID = 226277, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83850}, itemID = 226278, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83851}, itemID = 226279, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83852}, itemID = 226280, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83853}, itemID = 226281, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83854}, itemID = 226282, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83855}, itemID = 226283, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84226}, itemID = 227407, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84227}, itemID = 227418, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84228}, itemID = 227429, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83726}, itemID = 222554, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84127}, itemID = 228774, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83256}, itemID = 225233, points = 1},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83257}, itemID = 225232, points = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29508}, itemID = 0,      points = 3},
    }
  },
  {
    name = "Enchanting",
    skillLineID = 333,
    skillLineVariantID = 2874,
    spellID = 423334,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81076},                             itemID = 227411, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                        requires = {{type = "item", id = 210814, amount = 200}}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81077},                             itemID = 227422, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                        requires = {{type = "item", id = 210814, amount = 300}}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81078},                             itemID = 227433, points = 10, loc = {m = 2339, x = 59.6, y = 56.2, hint = "This item can be purchased from the vendor Lyrendal in Dornogal."},                        requires = {{type = "item", id = 210814, amount = 400}}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82635},                             itemID = 224050, points = 10, loc = {m = 2213, x = 45.6, y = 33.6, hint = "This item can be purcrashed from the vendor Iliani in City of Threads."},                  requires = {{type = "currency", id = 3056, amount = 565}}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83060},                             itemID = 224652, points = 10, loc = {m = 2339, x = 39.2, y = 24.2, hint = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."},                 requires = {{type = "renown", id = 2590, amount = 12}, {type = "item", id = 210814, amount = 50}}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83856},                             itemID = 226284, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83859},                             itemID = 226285, points = 3,  loc = {m = 2339, x = 57.9, y = 56.9, hint = "This item can be found in Dornogal leaning against a wooden pillar next to Clerk Gretal."}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83860},                             itemID = 226286, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83861},                             itemID = 226287, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83862},                             itemID = 226288, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83863},                             itemID = 226289, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83864},                             itemID = 226290, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83865},                             itemID = 226291, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83727},                             itemID = 222550, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83258},                             itemID = 225231, points = 1},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83259},                             itemID = 225230, points = 1},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {84295},                             itemID = 227661, points = 4},
      {objectiveID = Enum.WK_Objectives.TrainerQuest,  quests = {84084, 84085, 84086},               itemID = 227667, points = 3,  limit = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29510},                             itemID = 0,      points = 3,  loc = {m = 407, x = 53.2, y = 76.6, hint = "Talk to Sayge at the Darkmoon Faire and complete the quest."}},
    }
  },
  {
    name = "Engineering",
    skillLineID = 202,
    skillLineVariantID = 2875,
    spellID = 423335,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82632}, itemID = 224052, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83063}, itemID = 224653, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83866}, itemID = 226292, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83867}, itemID = 226293, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83868}, itemID = 226294, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83869}, itemID = 226295, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83870}, itemID = 226296, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83871}, itemID = 226297, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83872}, itemID = 226298, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83873}, itemID = 226299, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84229}, itemID = 227412, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84230}, itemID = 227423, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84231}, itemID = 227434, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83728}, itemID = 222621, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84128}, itemID = 228775, points = 1},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83260}, itemID = 225228, points = 1},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83261}, itemID = 225229, points = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29511}, itemID = 0,      points = 3},
    }
  },
  {
    name = "Herbalism",
    skillLineID = 182,
    skillLineVariantID = 2877,
    spellID = 441327,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81422},                             itemID = 227415, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81423},                             itemID = 227426, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81424},                             itemID = 227437, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82630},                             itemID = 224023, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83066},                             itemID = 224656, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83874},                             itemID = 226300, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83875},                             itemID = 226301, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83876},                             itemID = 226302, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83877},                             itemID = 226303, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83878},                             itemID = 226304, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83879},                             itemID = 226305, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83880},                             itemID = 226306, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83881},                             itemID = 226307, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83729},                             itemID = 222552, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {81416, 81417, 81418, 81419, 81420}, itemID = 224264, points = 1},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {81421},                             itemID = 224265, points = 4},
      {objectiveID = Enum.WK_Objectives.TrainerQuest,  quests = {82970, 82958, 82965, 82916, 82962}, itemID = 224817, points = 3,  limit = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29514},                             itemID = 0,      points = 3},
    }
  },
  {
    name = "Inscription",
    skillLineID = 773,
    skillLineVariantID = 2878,
    spellID = 423338,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80749}, itemID = 227408, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80750}, itemID = 227419, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80751}, itemID = 227430, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82636}, itemID = 224053, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83064}, itemID = 224654, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83882}, itemID = 226308, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83883}, itemID = 226309, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83884}, itemID = 226310, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83885}, itemID = 226311, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83886}, itemID = 226312, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83887}, itemID = 226313, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83888}, itemID = 226314, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83889}, itemID = 226315, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83730}, itemID = 222548, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84129}, itemID = 228776, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83262}, itemID = 225227, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83264}, itemID = 225226, points = 2},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29515}, itemID = 0,      points = 3},
    }
  },
  {
    name = "Jewelcrafting",
    skillLineID = 755,
    skillLineVariantID = 2879,
    spellID = 423339,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81259}, itemID = 227413, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81260}, itemID = 227424, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81261}, itemID = 227435, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82637}, itemID = 224054, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83065}, itemID = 224655, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83890}, itemID = 226316, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83891}, itemID = 226317, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83892}, itemID = 226318, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83893}, itemID = 226319, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83894}, itemID = 226320, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83895}, itemID = 226321, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83896}, itemID = 226322, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83897}, itemID = 226323, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83731}, itemID = 222551, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84130}, itemID = 228777, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83265}, itemID = 225224, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83266}, itemID = 225225, points = 2},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29516}, itemID = 0,      points = 3},
    }
  },
  {
    name = "Leatherworking",
    skillLineID = 165,
    skillLineVariantID = 2880,
    spellID = 423340,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80978}, itemID = 227414, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80979}, itemID = 227425, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80980}, itemID = 227436, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82626}, itemID = 224056, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83068}, itemID = 224658, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83898}, itemID = 226324, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83899}, itemID = 226325, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83900}, itemID = 226326, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83901}, itemID = 226327, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83902}, itemID = 226328, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83903}, itemID = 226329, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83904}, itemID = 226330, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83905}, itemID = 226331, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83732}, itemID = 222549, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84131}, itemID = 228778, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83267}, itemID = 225223, points = 1},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83268}, itemID = 225222, points = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29517}, itemID = 0,      points = 3},
    }
  },
  {
    name = "Mining",
    skillLineID = 186,
    skillLineVariantID = 2881,
    spellID = 423341,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81390},                             itemID = 227416, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81391},                             itemID = 227427, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {81392},                             itemID = 227438, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82614},                             itemID = 224055, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83062},                             itemID = 224651, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83906},                             itemID = 226332, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83907},                             itemID = 226333, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83908},                             itemID = 226334, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83909},                             itemID = 226335, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83910},                             itemID = 226336, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83911},                             itemID = 226337, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83912},                             itemID = 226338, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83913},                             itemID = 226339, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83733},                             itemID = 222553, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {83050, 83051, 83052, 83053, 83054}, itemID = 224583, points = 1},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {83049},                             itemID = 224584, points = 3},
      {objectiveID = Enum.WK_Objectives.TrainerQuest,  quests = {83104, 83105, 83103, 83106, 83102}, itemID = 224818, points = 3,  limit = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29518},                             itemID = 0,      points = 3},
    }
  },
  {
    name = "Skinning",
    skillLineID = 393,
    skillLineVariantID = 2882,
    spellID = 423342,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82596},                             itemID = 224007, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83067},                             itemID = 224657, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83914},                             itemID = 226340, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83915},                             itemID = 226341, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83916},                             itemID = 226342, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83917},                             itemID = 226343, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83918},                             itemID = 226344, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83919},                             itemID = 226345, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83920},                             itemID = 226346, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83921},                             itemID = 226347, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84232},                             itemID = 227417, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84233},                             itemID = 227428, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {84234},                             itemID = 227439, points = 15, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83734},                             itemID = 222649, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {81459, 81460, 81461, 81462, 81463}, itemID = 224780, points = 1},
      {objectiveID = Enum.WK_Objectives.Gathering,     quests = {81464},                             itemID = 224781, points = 2},
      {objectiveID = Enum.WK_Objectives.TrainerQuest,  quests = {83097, 83098, 83100, 82992, 82993}, itemID = 224807, points = 3,  limit = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29519},                             itemID = 0,      points = 3},
    }
  },
  {
    name = "Tailoring",
    skillLineID = 197,
    skillLineVariantID = 2883,
    spellID = 423343,
    objectives = {
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80871}, itemID = 227410, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80872}, itemID = 227421, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {80873}, itemID = 227432, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {82634}, itemID = 224036, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83061}, itemID = 224648, points = 10, loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83922}, itemID = 226348, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83923}, itemID = 226349, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83924}, itemID = 226350, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83925}, itemID = 226351, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83926}, itemID = 226352, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83927}, itemID = 226353, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83928}, itemID = 226354, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Unique,        quests = {83929}, itemID = 226355, points = 3,  loc = {m = 0, x = 0, y = 0, hint = ""}},
      {objectiveID = Enum.WK_Objectives.Treatise,      quests = {83735}, itemID = 222547, points = 1,  loc = {m = 2339, x = 58.0, y = 56.4, hint = "Place a crafting order if you can't craft this yourself with Inscription."}},
      {objectiveID = Enum.WK_Objectives.ArtisanQuest,  quests = {84132}, itemID = 228779, points = 2},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83269}, itemID = 225221, points = 1},
      {objectiveID = Enum.WK_Objectives.Treasure,      quests = {83270}, itemID = 225220, points = 1},
      {objectiveID = Enum.WK_Objectives.DarkmoonQuest, quests = {29520}, itemID = 0,      points = 3},
    }
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
    self.db.global.DBVersion = self.db.global.DBVersion + 1
    self:MigrateDB()
  end
end

---Clear quest progress after a weekly reset
---@return boolean
function Data:TaskWeeklyReset()
  if type(self.db.global.weeklyReset) == "number" and self.db.global.weeklyReset <= GetServerTime() then
    local questsToReset = {}
    for _, profession in ipairs(self.Professions) do
      for _, professionObjective in ipairs(profession.objectives) do
        local dataObjecteive = self:GetObjective(professionObjective.objectiveID)
        if dataObjecteive then
          if dataObjecteive.repeatable ~= "Weekly" then
            for _, questID in ipairs(professionObjective.quests) do
              questsToReset[questID] = true
            end
          end
        end
      end
    end
    for _, character in pairs(self.db.global.characters) do
      if type(character.lastUpdate) == "number" and character.lastUpdate < self.db.global.weeklyReset then
        for questID in pairs(character.completed) do
          if questsToReset[questID] then
            character.completed[questID] = nil
          end
        end
      end
    end
    return true
  end
  self.db.global.weeklyReset = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset()
  return false
end

---Get an objective by enum/id
---@param enum Enum.WK_Objectives
---@return WK_Objective|nil
function Data:GetObjective(enum)
  return Utils:TableFind(self.Objectives, function(objective)
    return objective.id == enum
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

  -- Reset character data
  character.professions = {}
  character.completed = {}

  -- Profession Tree tracking
  local prof1, prof2 = GetProfessions()
  Utils:TableForEach({prof1, prof2}, function(characterProfessionID)
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLineID, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(characterProfessionID)
    if not skillLineID then return end

    local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
      return dataProfession.skillLineID == skillLineID and dataProfession.spellID and IsPlayerSpell(dataProfession.spellID)
    end)
    if not dataProfession then return end

    ---@type WK_CharacterProfession
    local characterProfession = {
      skillLineID = skillLineID,
      level = skillLevel,
      maxLevel = maxSkillLevel,
      knowledgeLevel = 0,
      knowledgeMaxLevel = 0,
    }

    -- Scan knowledge spent/max
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(dataProfession.skillLineVariantID)
    if configID and configID > 0 then
      local configInfo = C_Traits.GetConfigInfo(configID)
      if configInfo then
        local treeIDs = configInfo.treeIDs
        if treeIDs then
          Utils:TableForEach(treeIDs, function(treeID)
            local treeNodes = C_Traits.GetTreeNodes(treeID)
            if not treeNodes then return end
            Utils:TableForEach(treeNodes, function(treeNode)
              local nodeInfo = C_Traits.GetNodeInfo(configID, treeNode)
              if not nodeInfo then return end
              characterProfession.knowledgeLevel = nodeInfo.ranksPurchased > 1 and characterProfession.knowledgeLevel + (nodeInfo.currentRank - 1) or characterProfession.knowledgeLevel
              characterProfession.knowledgeMaxLevel = characterProfession.knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
            end)
          end)
        end
      end
    end

    table.insert(character.professions, characterProfession)
  end)

  -- Quest tracking
  Utils:TableForEach(Data.Professions, function(dataProfession)
    if not dataProfession.objectives then return end
    Utils:TableForEach(dataProfession.objectives, function(objective)
      if not objective.quests then return end
      Utils:TableForEach(objective.quests, function(questID)
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
          character.completed[questID] = true
        end
      end)
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
    if not unfiltered then
      if not character.enabled then
        include = false
      end
    end

    return include
  end)

  table.sort(characters, function(a, b)
    return a.lastUpdate > b.lastUpdate
  end)

  return characters
end
