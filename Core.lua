local WP = LibStub("AceAddon-3.0"):NewAddon("WeeklyKnowledge", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
WP.Libs = {}
WP.Libs.AceDB = LibStub:GetLibrary("AceDB-3.0")
WP.Libs.AceConfig = LibStub:GetLibrary("AceConfig-3.0")
WP.Libs.LDB = LibStub:GetLibrary("LibDataBroker-1.1")
WP.Libs.LDBIcon = LibStub("LibDBIcon-1.0")
WP.cache = {
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
  classFile = "",
  className = "",
  isDarkmoonOpen = false,
}

--@debug@
_G.WP = WP;
--@end-debug@

WP.DBVersion = 2
WP.defaultDB = {
  global = {
    minimap = {
      minimapPos = 235,
      hide = false,
      lock = false
    },
    hiddenColumns = {},
    windowScale = 100,
    windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
    characters = {},
  }
}

WP.defaultCharacter = {
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
  classFile = "",
  className = "",
  professions = {},
  completed = {},
}

local DARKMOON_EVENT_ID = 479
local ROW_HEIGHT = 24
local TITLEBAR_HEIGHT = 30
local MAX_WINDOW_HEIGHT = 600
local WP_CATEGORY_UNIQUE = "Uniques"
local WP_CATEGORY_TREATISE = "Treatise"
local WP_CATEGORY_ARTISANQUEST = "Artisan"
local WP_CATEGORY_TREASURE = "Treasure"
local WP_CATEGORY_GATHERING = "Gathering"
local WP_CATEGORY_TRAINER = "Trainer"
local WP_CATEGORY_DARKMOON = "Darkmoon"
local WP_CATEGORIES = {
  WP_CATEGORY_UNIQUE,
  WP_CATEGORY_TREATISE,
  WP_CATEGORY_ARTISANQUEST,
  WP_CATEGORY_TREASURE,
  WP_CATEGORY_GATHERING,
  WP_CATEGORY_TRAINER,
  WP_CATEGORY_DARKMOON,
}
local WP_CATEGORIES_TOOLTIPS = {
  ["Skill"] = "Your current profession skill progress.",
  ["Knowledge"] = "Your current knowledge points.",
  [WP_CATEGORY_UNIQUE] = "These are one-time knowledge point items found in treasures around the world and sold by Artisan/Renown/Kej vendors.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),
  [WP_CATEGORY_TREATISE] = "These can be crafted by inscribers. Send a Crafting Order if you don't have the inscription profession.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_ARTISANQUEST] = "Quest: Kala Clayhoof from Artisan's Consortium wants you to fulfill Crafting Orders.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_TREASURE] = "These are randomly looted from treasures and dirt around the world.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_GATHERING] = "These are randomly looted from gathering nodes around the world. You may (not confirmed) randomly find additional items beyond the weekly limit.\n\nThese are also looted from Disenchanting.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_TRAINER] = "Quest: Complete a quest at your profession trainer.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_DARKMOON] = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Monthly")
}
local WP_DATA = {
  {
    name = "Alchemy",
    skillLineID = 171,
    skillLineVariantID = 2871,
    spellID = 423321,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83725}, itemID = 222546, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84133}, itemID = 228773, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83253}, itemID = 225234, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83255}, itemID = 225235, points = 2},
      {category = WP_CATEGORY_DARKMOON,     quests = {29506}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83840}, itemID = 226265, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83841}, itemID = 226266, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83842}, itemID = 226267, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83843}, itemID = 226268, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83844}, itemID = 226269, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83845}, itemID = 226270, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83846}, itemID = 226271, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83847}, itemID = 226272, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {81146}, itemID = 227409, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {81147}, itemID = 227420, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {81148}, itemID = 227431, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83058}, itemID = 224645, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82633}, itemID = 224024, points = 10},
    }
  },
  {
    name = "Blacksmithing",
    skillLineID = 164,
    skillLineVariantID = 2872,
    spellID = 423332,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83726}, itemID = 222554, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84127}, itemID = 228774, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83256}, itemID = 225233, points = 1},
      {category = WP_CATEGORY_TREASURE,     quests = {83257}, itemID = 225232, points = 1},
      {category = WP_CATEGORY_DARKMOON,     quests = {29508}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83848}, itemID = 226276, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83849}, itemID = 226277, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83850}, itemID = 226278, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83851}, itemID = 226279, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83852}, itemID = 226280, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83853}, itemID = 226281, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83854}, itemID = 226282, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83855}, itemID = 226283, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {84226}, itemID = 227407, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {84227}, itemID = 227418, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {84228}, itemID = 227429, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83059}, itemID = 224647, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82631}, itemID = 224038, points = 10},
    }
  },
  {
    name = "Enchanting",
    skillLineID = 333,
    skillLineVariantID = 2874,
    spellID = 423334,
    objectives = {
      {category = WP_CATEGORY_TREATISE,  quests = {83727},                             itemID = 222550, points = 1},
      {category = WP_CATEGORY_TRAINER,   quests = {84084, 84085, 84086},               itemID = 227667, points = 3, limit = 1},
      {category = WP_CATEGORY_GATHERING, quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1},
      {category = WP_CATEGORY_GATHERING, quests = {84295},                             itemID = 227661, points = 4},
      {category = WP_CATEGORY_TREASURE,  quests = {83258},                             itemID = 225231, points = 1},
      {category = WP_CATEGORY_TREASURE,  quests = {83259},                             itemID = 225230, points = 1},
      {category = WP_CATEGORY_DARKMOON,  quests = {29510},                             itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83856},                             itemID = 226284, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83859},                             itemID = 226285, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83860},                             itemID = 226286, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83861},                             itemID = 226287, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83862},                             itemID = 226288, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83863},                             itemID = 226289, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83864},                             itemID = 226290, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83865},                             itemID = 226291, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {81076},                             itemID = 227411, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {81077},                             itemID = 227422, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {81078},                             itemID = 227433, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {82635},                             itemID = 224050, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {83060},                             itemID = 224652, points = 10},
    }
  },
  {
    name = "Engineering",
    skillLineID = 202,
    skillLineVariantID = 2875,
    spellID = 423335,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83728}, itemID = 222621, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84128}, itemID = 228775, points = 1},
      {category = WP_CATEGORY_TREASURE,     quests = {83260}, itemID = 225228, points = 1},
      {category = WP_CATEGORY_TREASURE,     quests = {83261}, itemID = 225229, points = 1},
      {category = WP_CATEGORY_DARKMOON,     quests = {29511}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83866}, itemID = 226292, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83867}, itemID = 226293, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83868}, itemID = 226294, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83869}, itemID = 226295, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83870}, itemID = 226296, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83871}, itemID = 226297, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83872}, itemID = 226298, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83873}, itemID = 226299, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {84229}, itemID = 227412, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {84230}, itemID = 227423, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {84231}, itemID = 227434, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82632}, itemID = 224052, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83063}, itemID = 224653, points = 10},
    }
  },
  {
    name = "Herbalism",
    skillLineID = 182,
    skillLineVariantID = 2877,
    spellID = 441327,
    objectives = {
      {category = WP_CATEGORY_TREATISE,  quests = {83729},                             itemID = 222552, points = 1},
      {category = WP_CATEGORY_TRAINER,   quests = {82970, 82958, 82965, 82916, 82962}, itemID = 224817, points = 3, limit = 1},
      {category = WP_CATEGORY_GATHERING, quests = {81416, 81417, 81418, 81419, 81420}, itemID = 224264, points = 1},
      {category = WP_CATEGORY_GATHERING, quests = {81421},                             itemID = 224265, points = 4},
      {category = WP_CATEGORY_DARKMOON,  quests = {29514},                             itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83874},                             itemID = 226300, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83875},                             itemID = 226301, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83876},                             itemID = 226302, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83877},                             itemID = 226303, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83878},                             itemID = 226304, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83879},                             itemID = 226305, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83880},                             itemID = 226306, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83881},                             itemID = 226307, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {81422},                             itemID = 227415, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {81423},                             itemID = 227426, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {81424},                             itemID = 227437, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {82630},                             itemID = 224023, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {83066},                             itemID = 224656, points = 10},
    }
  },
  {
    name = "Inscription",
    skillLineID = 773,
    skillLineVariantID = 2878,
    spellID = 423338,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83730}, itemID = 222548, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84129}, itemID = 228776, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83262}, itemID = 225227, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83264}, itemID = 225226, points = 2},
      {category = WP_CATEGORY_DARKMOON,     quests = {29515}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83882}, itemID = 226308, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83883}, itemID = 226309, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83884}, itemID = 226310, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83885}, itemID = 226311, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83886}, itemID = 226312, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83887}, itemID = 226313, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83888}, itemID = 226314, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83889}, itemID = 226315, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {80749}, itemID = 227408, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {80750}, itemID = 227419, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {80751}, itemID = 227430, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82636}, itemID = 224053, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83064}, itemID = 224654, points = 10},
    }
  },
  {
    name = "Jewelcrafting",
    skillLineID = 755,
    skillLineVariantID = 2879,
    spellID = 423339,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83731}, itemID = 222551, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84130}, itemID = 228777, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83265}, itemID = 225224, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83266}, itemID = 225225, points = 2},
      {category = WP_CATEGORY_DARKMOON,     quests = {29516}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83890}, itemID = 226316, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83891}, itemID = 226317, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83892}, itemID = 226318, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83893}, itemID = 226319, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83894}, itemID = 226320, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83895}, itemID = 226321, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83896}, itemID = 226322, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83897}, itemID = 226323, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {81259}, itemID = 227413, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {81260}, itemID = 227424, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {81261}, itemID = 227435, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83065}, itemID = 224655, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82637}, itemID = 224054, points = 10},
    }
  },
  {
    name = "Leatherworking",
    skillLineID = 165,
    skillLineVariantID = 2880,
    spellID = 423340,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83732}, itemID = 222549, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84131}, itemID = 228778, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83267}, itemID = 225223, points = 1},
      {category = WP_CATEGORY_TREASURE,     quests = {83268}, itemID = 225222, points = 1},
      {category = WP_CATEGORY_DARKMOON,     quests = {29517}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83898}, itemID = 226324, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83899}, itemID = 226325, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83900}, itemID = 226326, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83901}, itemID = 226327, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83902}, itemID = 226328, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83903}, itemID = 226329, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83904}, itemID = 226330, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83905}, itemID = 226331, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {80978}, itemID = 227414, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {80979}, itemID = 227425, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {80980}, itemID = 227436, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83068}, itemID = 224658, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82626}, itemID = 224056, points = 10},
    }
  },
  {
    name = "Mining",
    skillLineID = 186,
    skillLineVariantID = 2881,
    spellID = 423341,
    objectives = {
      {category = WP_CATEGORY_TREATISE,  quests = {83733},                             itemID = 222553, points = 1},
      {category = WP_CATEGORY_TRAINER,   quests = {83104, 83105, 83103, 83106, 83102}, itemID = 224818, points = 3, limit = 1},
      {category = WP_CATEGORY_GATHERING, quests = {83050, 83051, 83052, 83053, 83054}, itemID = 224583, points = 1},
      {category = WP_CATEGORY_GATHERING, quests = {83049},                             itemID = 224584, points = 3},
      {category = WP_CATEGORY_DARKMOON,  quests = {29518},                             itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83906},                             itemID = 226332, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83907},                             itemID = 226333, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83908},                             itemID = 226334, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83909},                             itemID = 226335, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83910},                             itemID = 226336, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83911},                             itemID = 226337, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83912},                             itemID = 226338, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83913},                             itemID = 226339, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {81390},                             itemID = 227416, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {81391},                             itemID = 227427, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {81392},                             itemID = 227438, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {83062},                             itemID = 224651, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {82614},                             itemID = 224055, points = 10},
    }
  },
  {
    name = "Skinning",
    skillLineID = 393,
    skillLineVariantID = 2882,
    spellID = 423342,
    objectives = {
      {category = WP_CATEGORY_TREATISE,  quests = {83734},                             itemID = 222649, points = 1},
      {category = WP_CATEGORY_TRAINER,   quests = {83097, 83098, 83100, 82992, 82993}, itemID = 224807, points = 3, limit = 1},
      {category = WP_CATEGORY_GATHERING, quests = {81459, 81460, 81461, 81462, 81463}, itemID = 224780, points = 1},
      {category = WP_CATEGORY_GATHERING, quests = {81464},                             itemID = 224781, points = 2},
      {category = WP_CATEGORY_DARKMOON,  quests = {29519},                             itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83914},                             itemID = 226340, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83915},                             itemID = 226341, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83916},                             itemID = 226342, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83917},                             itemID = 226343, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83918},                             itemID = 226344, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83919},                             itemID = 226345, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83920},                             itemID = 226346, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {83921},                             itemID = 226347, points = 3},
      {category = WP_CATEGORY_UNIQUE,    quests = {84232},                             itemID = 227417, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {84233},                             itemID = 227428, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {84234},                             itemID = 227439, points = 15},
      {category = WP_CATEGORY_UNIQUE,    quests = {83067},                             itemID = 224657, points = 10},
      {category = WP_CATEGORY_UNIQUE,    quests = {82596},                             itemID = 224007, points = 10},
    }
  },
  {
    name = "Tailoring",
    skillLineID = 197,
    skillLineVariantID = 2883,
    spellID = 423343,
    objectives = {
      {category = WP_CATEGORY_TREATISE,     quests = {83735}, itemID = 222547, points = 1},
      {category = WP_CATEGORY_ARTISANQUEST, quests = {84132}, itemID = 228779, points = 2},
      {category = WP_CATEGORY_TREASURE,     quests = {83269}, itemID = 225221, points = 1},
      {category = WP_CATEGORY_TREASURE,     quests = {83270}, itemID = 225220, points = 1},
      {category = WP_CATEGORY_DARKMOON,     quests = {29520}, itemID = 0,      points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83922}, itemID = 226348, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83923}, itemID = 226349, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83924}, itemID = 226350, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83925}, itemID = 226351, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83926}, itemID = 226352, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83927}, itemID = 226353, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83928}, itemID = 226354, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {83929}, itemID = 226355, points = 3},
      {category = WP_CATEGORY_UNIQUE,       quests = {80871}, itemID = 227410, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {80872}, itemID = 227421, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {80873}, itemID = 227432, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {82634}, itemID = 224036, points = 10},
      {category = WP_CATEGORY_UNIQUE,       quests = {83061}, itemID = 224648, points = 10},
    }
  }
}

function WP:MigrateDB()
  if type(self.db.global.DBVersion) ~= "number" then
    self.db.global.DBVersion = 1
  end
  if self.db.global.DBVersion < WP.DBVersion then
    if self.db.global.DBVersion == 1 then
      for characterGUID, character in pairs(self.db.global.characters) do
        character.GUID = characterGUID
        character.lastUpdate = 0
        character.enabled = true
        character.classID = character.class
        character.realmName = character.realm
        character.color = nil

        local remove = true
        for _, characterProfession in pairs(character.professions) do
          if characterProfession.latestExpansion then
            remove = false
          end
        end
        if remove then
          self.db.global.characters[characterGUID] = nil
        end
      end
    end
    self.db.global.DBVersion = self.db.global.DBVersion + 1
    self:MigrateDB()
  end
end

function WP:TaskWeeklyReset()
  if type(self.db.global.weeklyReset) == "number" and self.db.global.weeklyReset <= time() then
    for _, character in pairs(self.db.global.characters) do
      wipe(character.completed or {})
    end
  end
  self.db.global.weeklyReset = time() + C_DateAndTime.GetSecondsUntilWeeklyReset()
end

function WP:ScanCharacter()
  local character = self.db.global.characters[self.cache.GUID]
  if not character then
    character = CopyTable(self.defaultCharacter)
  end

  -- Update character info
  character.GUID = self.cache.GUID
  character.name = self.cache.name
  character.realmName = self.cache.realmName
  character.level = self.cache.level
  character.factionEnglish = self.cache.factionEnglish
  character.factionName = self.cache.factionName
  character.raceID = self.cache.raceID
  character.raceEnglish = self.cache.raceEnglish
  character.raceName = self.cache.raceName
  character.classID = self.cache.classID
  character.classFile = self.cache.classFile
  character.className = self.cache.className
  character.lastUpdate = GetServerTime()

  -- Reset character data
  character.professions = {}
  character.completed = {}

  -- Profession Tree tracking
  local prof1, prof2 = GetProfessions()
  for _, characterProfessionID in pairs({prof1, prof2}) do
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLineID, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(characterProfessionID)
    if skillLineID then
      for _, dataProfession in ipairs(WP_DATA) do
        if dataProfession.skillLineID == skillLineID and dataProfession.spellID and IsPlayerSpell(dataProfession.spellID) then
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
                for _, treeID in pairs(treeIDs) do
                  local treeNodes = C_Traits.GetTreeNodes(treeID)
                  if treeNodes then
                    for _, treeNode in pairs(treeNodes) do
                      local nodeInfo = C_Traits.GetNodeInfo(configID, treeNode)
                      if nodeInfo then
                        characterProfession.knowledgeLevel = nodeInfo.ranksPurchased > 1 and characterProfession.knowledgeLevel + (nodeInfo.currentRank - 1) or characterProfession.knowledgeLevel
                        characterProfession.knowledgeMaxLevel = characterProfession.knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
                      end
                    end
                  end
                end
              end
            end
          end

          table.insert(character.professions, characterProfession)
        end
      end
    end
  end

  -- Quest tracking
  for _, dataProfession in ipairs(WP_DATA) do
    if dataProfession.objectives then
      for _, objective in ipairs(dataProfession.objectives) do
        if objective.quests then
          for _, questID in ipairs(objective.quests) do
            if C_QuestLog.IsQuestFlaggedCompleted(questID) then
              character.completed[questID] = true
            end
          end
        end
      end
    end
  end

  if #character.professions then
    self.db.global.characters[self.cache.GUID] = character
  end
end

function WP:GetCharacters(unfiltered)
  local characters = {}
  for characterGUID, character in pairs(self.db.global.characters) do
    local include = true
    if not unfiltered then
      if not character.enabled then
        include = false
      end
    end

    if include then
      table.insert(characters, character)
    end
  end

  table.sort(characters, function(a, b)
    return a.lastUpdate > b.lastUpdate
  end)

  return characters
end

---Set the background color for a parent frame
---@param parent any
---@param r number
---@param g number
---@param b number
---@param a number
function WP:SetBackgroundColor(parent, r, g, b, a)
  if not parent.Background then
    parent.Background = parent:CreateTexture("Background", "BACKGROUND")
    parent.Background:SetTexture("Interface/BUTTONS/WHITE8X8")
    parent.Background:SetAllPoints()
  end

  parent.Background:SetVertexColor(r, g, b, a)
end

---Set the highlight color for a parent frame
---@param parent any
---@param r number?
---@param g number?
---@param b number?
---@param a number?
function WP:SetHighlightColor(parent, r, g, b, a)
  if not parent.Highlight then
    parent.Highlight = parent:CreateTexture("Highlight", "OVERLAY")
    parent.Highlight:SetTexture("Interface/BUTTONS/WHITE8X8")
    parent.Highlight:SetAllPoints()
  end

  if type(r) == "table" then
    r, g, b, a = r.a, r.g, r.b, r.a
  end

  if type(r) == nil then
    r, g, b, a = 1, 1, 1, 0.1
  end

  parent.Highlight:SetVertexColor(r, g, b, a)
end

function WP:IsMinimapIconShown()
  return not self.db.global.minimap.hide
end

function WP:SetMinimapIconShown(_, value)
  self.db.global.minimap.hide = not value
  self.Libs.LDBIcon:Refresh("WeeklyKnowledge", self.db.global.minimap)
end

function WP:HandleChatCmd(msg)
  if msg == "minimap" then
    self:SetMinimapIconShown(nil, self.db.global.minimap.hide)
  else
    self:ToggleWindow()
  end
end

function WP:GetColumns(unfiltered)
  local hidden = self.db.global.hiddenColumns
  local filteredColumns = {}
  local columns = {
    {
      name = "Name",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Name", 1, 1, 1);
        GameTooltip:AddLine("Your characters.")
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      cell = function(character, characterProfession, dataProfession)
        local characterName = character.name
        local _, classFile = GetClassInfo(character.classID)
        if classFile then
          local color = C_ClassColor.GetClassColor(classFile)
          if color then
            characterName = color:WrapTextInColorCode(characterName)
          end
        end
        return {text = characterName}
      end,
    },
    {
      name = "Realm",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Realm", 1, 1, 1);
        GameTooltip:AddLine("Realm names.")
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      cell = function(character, characterProfession, dataProfession)
        return {text = character.realmName}
      end,
    },
    {
      name = "Profession",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Profession", 1, 1, 1);
        GameTooltip:AddLine("Your professions.")
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 80,
      cell = function(character, characterProfession, dataProfession)
        return {text = dataProfession.name}
      end,
    },
    {
      name = "Skill",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Skill", 1, 1, 1);
        GameTooltip:AddLine("Current skill levels.")
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 80,
      align = "CENTER",
      cell = function(character, characterProfession, dataProfession)
        return {text = characterProfession.level > 0 and characterProfession.level == characterProfession.maxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(characterProfession.level .. " / " .. characterProfession.maxLevel) or characterProfession.level .. " / " .. characterProfession.maxLevel}
      end,
    },
    {
      name = "Knowledge",
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText("Knowledge", 1, 1, 1);
        GameTooltip:AddLine("Current knowledge gained.")
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 80,
      align = "CENTER",
      cell = function(character, characterProfession, dataProfession)
        if characterProfession.knowledgeMaxLevel > 0 then
          return {text = characterProfession.knowledgeLevel > 0 and characterProfession.knowledgeLevel == characterProfession.knowledgeMaxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(characterProfession.knowledgeLevel .. " / " .. characterProfession.knowledgeMaxLevel) or characterProfession.knowledgeLevel .. " / " .. characterProfession.knowledgeMaxLevel}
        end
        return {text = ""}
      end,
    },
  }

  for _, categoryName in ipairs(WP_CATEGORIES) do
    table.insert(columns, {
      name = categoryName,
      onEnter = function(cellFrame)
        GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
        GameTooltip:SetText(categoryName, 1, 1, 1);
        GameTooltip:AddLine(WP_CATEGORIES_TOOLTIPS[categoryName], nil, nil, nil, true)
        -- GameTooltip:AddLine(" ")
        -- GameTooltip:AddLine("<Click to Sort Column>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b, true)
        GameTooltip:Show()
      end,
      onLeave = function()
        GameTooltip:Hide()
      end,
      width = 90,
      align = "CENTER",
      cell = function(character, characterProfession, dataProfession)
        if not characterProfession.knowledgeMaxLevel or characterProfession.knowledgeMaxLevel == 0 then
          return {text = ""}
        end

        local completed = 0
        local total = 0
        local points = 0
        local pointsTotal = 0

        for _, objective in ipairs(dataProfession.objectives) do
          if objective.category == categoryName then
            if objective.quests then
              local limit = 0
              for _, questID in ipairs(objective.quests) do
                total = total + 1
                pointsTotal = pointsTotal + objective.points
                if objective.limit and total > objective.limit then
                  total = objective.limit
                end
                if character.completed[questID] then
                  completed = completed + 1
                  points = points + objective.points
                end
              end

              local isDarkmoonOpen = false
              if objective.category == WP_CATEGORY_DARKMOON then
                local date = C_DateAndTime.GetCurrentCalendarTime()
                if date and date.monthDay then
                  local today = date.monthDay
                  local numEvents = C_Calendar.GetNumDayEvents(0, today)
                  if numEvents then
                    for i = 1, numEvents do
                      local event = C_Calendar.GetDayEvent(0, today, i)
                      if event and event.eventID == DARKMOON_EVENT_ID then
                        isDarkmoonOpen = true
                      end
                    end
                  end
                end
                if not isDarkmoonOpen then
                  total = 0
                end
              end
            end
          end
        end

        local result = completed .. " / " .. total
        if total == 0 then
          result = ""
        elseif completed == total then
          result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
        end

        if total == 0 then
          return {text = ""}
        else
          return {
            text = result,
            onEnter = function(cellFrame)
              GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText(categoryName, 1, 1, 1);
              local label = "Items:"
              if categoryName == WP_CATEGORY_ARTISANQUEST or categoryName == WP_CATEGORY_DARKMOON or categoryName == WP_CATEGORY_TRAINER then
                label = "Quests:"
              end
              GameTooltip:AddDoubleLine(label, format("%d / %d", completed, total), nil, nil, nil, 1, 1, 1)
              GameTooltip:AddDoubleLine("Knowledge Points:", format("%d / %d", points, pointsTotal), nil, nil, nil, 1, 1, 1)
              GameTooltip:Show()
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
          }
        end
      end
    })
  end

  if unfiltered then
    return columns
  end

  for _, column in pairs(columns) do
    if not hidden[column.name] then
      table.insert(filteredColumns, column)
    end
  end

  return filteredColumns
end

function WP:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE"] = "Show/Hide the window"
  self:RegisterChatCommand("wk", "HandleChatCmd")
  self:RegisterChatCommand("weeklyknowledge", "HandleChatCmd")

  -- Options
  self.Libs.AceConfig:RegisterOptionsTable(
    "WeeklyKnowledge",
    {
      name = "WeeklyKnowledge",
      handler = WP,
      type = "group",
      args = {
        minimap = {
          type = "toggle",
          name = "Minimap Icon",
          desc = "Toggles the display of the minimap icon.",
          get = "IsMinimapIconShown",
          set = "SetMinimapIconShown"
        }
      }
    }
  )

  -- Database
  self.db = self.Libs.AceDB:New(
    "WeeklyKnowledgeDB",
    self.defaultDB,
    true
  )
  self:MigrateDB()

  local libDataObject = {
    label = "WeeklyKnowledge",
    tocname = "WeeklyKnowledge",
    type = "launcher",
    icon = "Interface/AddOns/WeeklyKnowledge/Media/Icon.blp",
    OnClick = function()
      self:ToggleWindow()
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText("WeeklyKnowledge", 1, 1, 1)
      tooltip:AddLine("Click to open WeeklyKnowledge", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = "Drag to move this icon"
      if self.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
  }

  self.Libs.LDB:NewDataObject("WeeklyKnowledge", libDataObject)
  self.Libs.LDBIcon:Register("WeeklyKnowledge", libDataObject, self.db.global.minimap)
  self.Libs.LDBIcon:AddButtonToCompartment("WeeklyKnowledge")

  if not self.frame then
    local frameName = "WeeklyKnowledgeMainWindow"
    self.frame = CreateFrame("Frame", frameName, UIParent)
    self.frame:SetSize(1000, 500)
    self.frame:SetFrameStrata("HIGH")
    self.frame:SetFrameLevel(8000)
    self.frame:SetClampedToScreen(true)
    self.frame:SetMovable(true)
    self.frame:SetPoint("CENTER")
    self.frame:SetUserPlaced(true)
    WP:SetBackgroundColor(self.frame, self.db.global.windowBackgroundColor.r, self.db.global.windowBackgroundColor.g, self.db.global.windowBackgroundColor.b, self.db.global.windowBackgroundColor.a)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:EnableMouse(true)
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame:Hide()
    self.frame.border = CreateFrame("Frame", "$parentBorder", self.frame, "BackdropTemplate")
    self.frame.border:SetPoint("TOPLEFT", self.frame, "TOPLEFT", -3, 3)
    self.frame.border:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 3, -3)
    self.frame.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.frame.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.frame.border:Show()
    self.frame.titlebar = CreateFrame("Frame", "$parentTitle", self.frame)
    self.frame.titlebar:SetPoint("TOPLEFT", self.frame, "TOPLEFT")
    self.frame.titlebar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT")
    WP:SetBackgroundColor(self.frame.titlebar, 0, 0, 0, 0.5)
    self.frame.titlebar:SetHeight(TITLEBAR_HEIGHT + 1)
    self.frame.titlebar:RegisterForDrag("LeftButton")
    self.frame.titlebar:EnableMouse(true)
    self.frame.titlebar:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame.titlebar:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame.titlebar.icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frame.titlebar.icon:SetPoint("LEFT", self.frame.titlebar, "LEFT", 6, 0)
    self.frame.titlebar.icon:SetSize(20, 20)
    self.frame.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")
    self.frame.titlebar.title = self.frame.titlebar:CreateFontString("$parentText", "OVERLAY")
    self.frame.titlebar.title:SetFontObject("SystemFont_Med2")
    self.frame.titlebar.title:SetPoint("LEFT", self.frame.titlebar, 28, 0)
    self.frame.titlebar.title:SetJustifyH("LEFT")
    self.frame.titlebar.title:SetJustifyV("MIDDLE")
    self.frame.titlebar.title:SetText("WeeklyKnowledge")
    self.frame.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.frame.titlebar)
    self.frame.titlebar.closeButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
    self.frame.titlebar.closeButton:SetPoint("RIGHT", self.frame.titlebar, "RIGHT", 0, 0)
    self.frame.titlebar.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
    self.frame.titlebar.closeButton.Icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frame.titlebar.closeButton.Icon:SetPoint("CENTER", self.frame.titlebar.closeButton, "CENTER")
    self.frame.titlebar.closeButton.Icon:SetSize(10, 10)
    self.frame.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
    self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    self.frame.titlebar.closeButton:SetScript("OnEnter", function()
      self.frame.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
      self:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 0, 0, 0.2)
      GameTooltip:ClearAllPoints()
      GameTooltip:ClearLines()
      GameTooltip:SetOwner(self.frame.titlebar.closeButton, "ANCHOR_TOP")
      GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
      GameTooltip:Show()
    end)
    self.frame.titlebar.closeButton:SetScript("OnLeave", function()
      self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 1, 1, 0)
      GameTooltip:Hide()
    end)

    do -- Settings
      self.frame.titlebar.SettingsButton = CreateFrame("DropdownButton", "$parentSettingsButton", self.frame.titlebar)
      self.frame.titlebar.SettingsButton:SetPoint("RIGHT", self.frame.titlebar.closeButton, "LEFT", 0, 0)
      self.frame.titlebar.SettingsButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frame.titlebar.SettingsButton:SetScript("OnEnter", function()
        self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(self.frame.titlebar.SettingsButton, 1, 1, 1, 0.05)
        GameTooltip:SetOwner(self.frame.titlebar.SettingsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Settings", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Let's customize things a bit", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.SettingsButton:SetScript("OnLeave", function()
        self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(self.frame.titlebar.SettingsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.SettingsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.SettingsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.SettingsButton.Icon:SetPoint("CENTER", self.frame.titlebar.SettingsButton, "CENTER")
      self.frame.titlebar.SettingsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.SettingsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp")
      self.frame.titlebar.SettingsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.SettingsButton:SetupMenu(function(_, rootMenu)
        local showMinimapIcon = rootMenu:CreateCheckbox(
          "Show the minimap button",
          function() return not self.db.global.minimap.hide end,
          function()
            self.db.global.minimap.hide = not self.db.global.minimap.hide
            self.Libs.LDBIcon:Refresh("WeeklyKnowledge", self.db.global.minimap)
          end
        )
        showMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "It does get crowded around the minimap sometimes.");
        end)

        local lockMinimapIcon = rootMenu:CreateCheckbox(
          "Lock the minimap button",
          function() return self.db.global.minimap.lock end,
          function()
            self.db.global.minimap.lock = not self.db.global.minimap.lock
            self.Libs.LDBIcon:Refresh("WeeklyKnowledge", self.db.global.minimap)
          end
        )
        lockMinimapIcon:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "No more moving the button around accidentally!");
        end)

        local interfaceTitle = rootMenu:CreateTitle("Interface")
        local windowScale = rootMenu:CreateButton("Window scale")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return self.db.global.windowScale == i end,
            function(data)
              self.db.global.windowScale = data
              self:Render()
            end,
            i
          )
        end

        local colorInfo = {
          r = self.db.global.windowBackgroundColor.r,
          g = self.db.global.windowBackgroundColor.g,
          b = self.db.global.windowBackgroundColor.b,
          opacity = self.db.global.windowBackgroundColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            if r then
              self.db.global.windowBackgroundColor.r = r
              self.db.global.windowBackgroundColor.g = g
              self.db.global.windowBackgroundColor.b = b
              self:SetBackgroundColor(self.frame, self.db.global.windowBackgroundColor.r, self.db.global.windowBackgroundColor.g, self.db.global.windowBackgroundColor.b, self.db.global.windowBackgroundColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              self.db.global.windowBackgroundColor.r = color.r
              self.db.global.windowBackgroundColor.g = color.g
              self.db.global.windowBackgroundColor.b = color.b
              self:SetBackgroundColor(self.frame, self.db.global.windowBackgroundColor.r, self.db.global.windowBackgroundColor.g, self.db.global.windowBackgroundColor.b, self.db.global.windowBackgroundColor.a)
            end
          end,
          hasOpacity = 0,
        }
        rootMenu:CreateColorSwatch(
          "Window color",
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )
      end)
    end

    do -- Characters
      self.frame.titlebar.CharactersButton = CreateFrame("DropdownButton", "$parentCharactersButton", self.frame.titlebar)
      self.frame.titlebar.CharactersButton:SetPoint("RIGHT", self.frame.titlebar.SettingsButton, "LEFT", 0, 0)
      self.frame.titlebar.CharactersButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frame.titlebar.CharactersButton:SetScript("OnEnter", function()
        self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(self.frame.titlebar.CharactersButton, 1, 1, 1, 0.05)
        GameTooltip:ClearAllPoints()
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(self.frame.titlebar.CharactersButton, "ANCHOR_TOP")
        GameTooltip:SetText("Characters", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable your characters.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.CharactersButton:SetScript("OnLeave", function()
        self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(self.frame.titlebar.CharactersButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.CharactersButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.CharactersButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.CharactersButton.Icon:SetPoint("CENTER", self.frame.titlebar.CharactersButton, "CENTER")
      self.frame.titlebar.CharactersButton.Icon:SetSize(14, 14)
      self.frame.titlebar.CharactersButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Characters.blp")
      self.frame.titlebar.CharactersButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.CharactersButton:SetupMenu(function(_, rootMenu)
        for _, character in pairs(self:GetCharacters(true)) do
          local text = format("%s - %s", character.name, character.realmName)
          local _, classFile = GetClassInfo(character.classID)
          if classFile then
            local color = C_ClassColor.GetClassColor(classFile)
            if color then
              text = color:WrapTextInColorCode(text)
            end
          end

          rootMenu:CreateCheckbox(
            text,
            function() return character.enabled or false end,
            function(data)
              self.db.global.characters[data].enabled = not self.db.global.characters[data].enabled
              self:Render()
            end,
            character.GUID
          )
        end
      end)
    end

    do -- Columns
      self.frame.titlebar.ColumnsButton = CreateFrame("DropdownButton", "$parentColumnsButton", self.frame.titlebar)
      self.frame.titlebar.ColumnsButton:SetPoint("RIGHT", self.frame.titlebar.CharactersButton, "LEFT", 0, 0)
      self.frame.titlebar.ColumnsButton:SetSize(TITLEBAR_HEIGHT, TITLEBAR_HEIGHT)
      self.frame.titlebar.ColumnsButton:SetScript("OnEnter", function()
        self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.9, 0.9, 0.9, 1)
        self:SetBackgroundColor(self.frame.titlebar.ColumnsButton, 1, 1, 1, 0.05)
        GameTooltip:ClearAllPoints()
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(self.frame.titlebar.ColumnsButton, "ANCHOR_TOP")
        GameTooltip:SetText("Columns", 1, 1, 1, 1, true);
        GameTooltip:AddLine("Enable/Disable table columns.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        GameTooltip:Show()
      end)
      self.frame.titlebar.ColumnsButton:SetScript("OnLeave", function()
        self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        self:SetBackgroundColor(self.frame.titlebar.ColumnsButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)
      self.frame.titlebar.ColumnsButton.Icon = self.frame.titlebar:CreateTexture(self.frame.titlebar.ColumnsButton:GetName() .. "Icon", "ARTWORK")
      self.frame.titlebar.ColumnsButton.Icon:SetPoint("CENTER", self.frame.titlebar.ColumnsButton, "CENTER")
      self.frame.titlebar.ColumnsButton.Icon:SetSize(12, 12)
      self.frame.titlebar.ColumnsButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Columns.blp")
      self.frame.titlebar.ColumnsButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
      self.frame.titlebar.ColumnsButton:SetupMenu(function(_, rootMenu)
        local hidden = self.db.global.hiddenColumns
        for _, column in pairs(self:GetColumns(true)) do
          rootMenu:CreateCheckbox(
            column.name,
            function() return not hidden[column.name] end,
            function(data)
              self.db.global.hiddenColumns[data] = not self.db.global.hiddenColumns[data]
              self:Render()
            end,
            column.name
          )
        end
      end)
    end

    table.insert(UISpecialFrames, frameName)

    self.frame.table = self:NewTable({
      header = {
        enabled = true,
        sticky = true,
        height = math.floor(ROW_HEIGHT * 1.3),
      },
      rows = {
        height = ROW_HEIGHT,
        highlight = true,
        striped = true
      }
    })
    self.frame.table:SetParent(self.frame)
    self.frame.table:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -TITLEBAR_HEIGHT)
    self.frame.table:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)
  end
end

function WP:OnEnable()
  self:RegisterBucketEvent(
    {
      "ACTIVE_TALENT_GROUP_CHANGED",
      "BAG_UPDATE_DELAYED",
      "CHAT_MSG_LOOT",
      "ITEM_COUNT_CHANGED",
      "PLAYER_SPECIALIZATION_CHANGED",
      "PLAYER_TALENT_UPDATE",
      "QUEST_COMPLETE",
      "QUEST_TURNED_IN",
      "SKILL_LINES_CHANGED",
      "TRAIT_CONFIG_UPDATED",
      "UNIT_INVENTORY_CHANGED",
    },
    3,
    function()
      self:ScanCharacter()
      self:Render()
    end
  )

  -- Is the Darkmoon Faire open?
  local date = C_DateAndTime.GetCurrentCalendarTime()
  if date and date.monthDay then
    local today = date.monthDay
    local numEvents = C_Calendar.GetNumDayEvents(0, today)
    if numEvents then
      for i = 1, numEvents do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.eventID == DARKMOON_EVENT_ID then
          self.cache.isDarkmoonOpen = true
        end
      end
    end
  end

  local localizedRaceName, englishRaceName, raceID = UnitRace("player")
  local localizedClassName, classFile, classID = UnitClass("player")
  local englishFactionName, localizedFactionName = UnitFactionGroup("player")
  self.cache.GUID = UnitGUID("player")
  self.cache.name = UnitName("player")
  self.cache.realmName = GetRealmName()
  self.cache.level = UnitLevel("player")
  self.cache.raceID = raceID
  self.cache.raceEnglish = englishRaceName
  self.cache.raceName = localizedRaceName
  self.cache.classID = classID
  self.cache.classFile = classFile
  self.cache.className = localizedClassName
  self.cache.factionEnglish = englishFactionName
  self.cache.factionName = localizedFactionName

  self:ScanCharacter()
  self:Render()
end

function WP:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end

function WP:ToggleWindow()
  if self.frame:IsVisible() then
    self.frame:Hide()
  else
    self:Render()
    self.frame:Show()
  end
end

function WP:Render()
  if not self.frame then return end
  local columns = self:GetColumns()
  local tableWidth = 0
  local tableHeight = 0
  local data = {
    columns = {},
    rows = {}
  }

  do -- Column config
    WP:TableForEach(columns, function(column)
      table.insert(data.columns, {
        width = column.width,
        align = column.align or "LEFT",
      })
      tableWidth = tableWidth + column.width
    end)
  end

  do -- Header row
    local row = {
      columns = {}
    }
    WP:TableForEach(columns, function(column)
      table.insert(row.columns, {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(column.name),
        onEnter = column.onEnter,
        onLeave = column.onLeave,
        -- backgroundColor = {r = 0, g = 0, b = 0, a = 0.3},
      })
    end)
    table.insert(data.rows, row)
    tableHeight = tableHeight + self.frame.table.config.header.height
  end

  for _, character in pairs(self:GetCharacters()) do
    for _, characterProfession in ipairs(character.professions) do
      for _, dataProfession in ipairs(WP_DATA) do
        if dataProfession.skillLineID == characterProfession.skillLineID then
          local row = {
            columns = {}
          }

          for _, column in pairs(columns) do
            table.insert(row.columns, column.cell(character, characterProfession, dataProfession))
          end

          table.insert(data.rows, row)
          tableHeight = tableHeight + self.frame.table.config.rows.height
        end
      end
    end
  end

  self.frame.table:SetData(data)
  self.frame:SetWidth(tableWidth)
  self.frame:SetHeight(math.min(tableHeight + TITLEBAR_HEIGHT, MAX_WINDOW_HEIGHT)) -- ST height + ST header + frame padding + titlebar
  self.frame:SetScale(self.db.global.windowScale / 100)
end

local TableCollection = {}

function WP:NewTable(config)
  local frame = WP:CreateScrollFrame("WeeklyKnowledgeTable" .. (WP:TableCount(TableCollection) + 1))
  frame.config = CreateFromMixins(
    {
      header = {
        enabled = true,
        sticky = false,
        height = 30,
      },
      rows = {
        height = 22,
        highlight = true,
        striped = true
      },
      columns = {
        width = 100,
        highlight = false,
        striped = false
      },
      cells = {
        padding = 8,
        highlight = false
      },
      data = {
        columns = {},
        rows = {},
      },
    },
    config or {}
  )
  frame.rows = {}
  frame.data = frame.config.data

  ---Set the table data
  function frame:SetData(data)
    frame.data = data
    frame:RenderTable()
  end

  function frame:SetRowHeight(height)
    self.config.rows.height = height
    self:Update()
  end

  function frame:RenderTable()
    local offsetY = 0
    local offsetX = 0

    WP:TableForEach(frame.rows, function(rowFrame) rowFrame:Hide() end)
    WP:TableForEach(frame.data.rows, function(row, rowIndex)
      local rowFrame = frame.rows[rowIndex]
      local rowHeight = rowIndex == 1 and 30 or frame.config.rows.height

      if not rowFrame then
        rowFrame = CreateFrame("Button", "$parentRow" .. rowIndex, frame.content)
        rowFrame.columns = {}
        frame.rows[rowIndex] = rowFrame
      end

      rowFrame.data = row
      rowFrame:SetPoint("TOPLEFT", frame.content, "TOPLEFT", 0, -offsetY)
      rowFrame:SetPoint("TOPRIGHT", frame.content, "TOPRIGHT", 0, -offsetY)
      rowFrame:SetHeight(rowHeight)
      rowFrame:SetScript("OnEnter", function() rowFrame:onEnterHandler(rowFrame) end)
      rowFrame:SetScript("OnLeave", function() rowFrame:onLeaveHandler(rowFrame) end)
      rowFrame:SetScript("OnClick", function() rowFrame:onClickHandler(rowFrame) end)
      rowFrame:Show()

      if frame.config.rows.striped and rowIndex % 2 == 1 then
        WP:SetBackgroundColor(rowFrame, 1, 1, 1, .02)
      end

      if row.backgroundColor then
        WP:SetBackgroundColor(rowFrame, row.backgroundColor.r, row.backgroundColor.g, row.backgroundColor.b, row.backgroundColor.a)
      end

      function rowFrame:onEnterHandler(arg1, arg2, arg3)
        if rowIndex > 1 then
          WP:SetHighlightColor(rowFrame, 1, 1, 1, .03)
        end
        if row.OnEnter then
          row:OnEnter(arg1, arg2, arg3)
        end
      end

      function rowFrame:onLeaveHandler(...)
        if rowIndex > 1 then
          WP:SetHighlightColor(rowFrame, 1, 1, 1, 0)
        end
        if row.OnLeave then
          row:OnLeave(...)
        end
      end

      function rowFrame:onClickHandler(...)
        if row.OnClick then
          row:OnClick(...)
        end
      end

      -- Sticky header
      if frame.config.header.sticky and rowIndex == 1 then
        if frame then
          rowFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -offsetY)
          rowFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -offsetY)
          rowFrame:SetToplevel(true)
          rowFrame:SetFrameStrata("HIGH")
        end
        if not row.backgroundColor then
          WP:SetBackgroundColor(rowFrame, 0.0784, 0.0980, 0.1137, 1)
        end
      end

      offsetX = 0
      WP:TableForEach(rowFrame.columns, function(columnFrame) columnFrame:Hide() end)
      WP:TableForEach(row.columns, function(column, columnIndex)
        local columnFrame = rowFrame.columns[columnIndex]
        local columnConfig = frame.data.columns[columnIndex]
        local columnWidth = columnConfig and columnConfig.width or frame.config.columns.width
        local columnTextAlign = columnConfig and columnConfig.align or "LEFT"

        if not columnFrame then
          columnFrame = CreateFrame("Button", "$parentCol" .. columnIndex, rowFrame)
          columnFrame.text = columnFrame:CreateFontString("$parentText", "OVERLAY")
          columnFrame.text:SetFontObject("GameFontHighlightSmall")
          rowFrame.columns[columnIndex] = columnFrame
        end

        columnFrame.data = column
        columnFrame:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", offsetX, 0)
        columnFrame:SetPoint("BOTTOMLEFT", rowFrame, "BOTTOMLEFT", offsetX, 0)
        columnFrame:SetWidth(columnWidth)
        columnFrame:SetScript("OnEnter", function() columnFrame:onEnterHandler(columnFrame) end)
        columnFrame:SetScript("OnLeave", function() columnFrame:onLeaveHandler(columnFrame) end)
        columnFrame:SetScript("OnClick", function() columnFrame:onClickHandler(columnFrame) end)
        columnFrame.text:SetWordWrap(false)
        columnFrame.text:SetJustifyH(columnTextAlign)
        columnFrame.text:SetPoint("TOPLEFT", columnFrame, "TOPLEFT", frame.config.cells.padding, -frame.config.cells.padding)
        columnFrame.text:SetPoint("BOTTOMRIGHT", columnFrame, "BOTTOMRIGHT", -frame.config.cells.padding, frame.config.cells.padding)
        columnFrame.text:SetText(column.text)
        columnFrame:Show()

        if column.backgroundColor then
          WP:SetBackgroundColor(columnFrame, column.backgroundColor.r, column.backgroundColor.g, column.backgroundColor.b, column.backgroundColor.a)
        end

        function columnFrame:onEnterHandler(...)
          rowFrame:onEnterHandler(...)
          if column.onEnter then
            column.onEnter(...)
          end
        end

        function columnFrame:onLeaveHandler(...)
          rowFrame:onLeaveHandler(...)
          if column.onLeave then
            column.onLeave(...)
          end
          -- TODO: move tooltip stuff to the callback source
          if column.onEnter then
            GameTooltip:Hide()
          end
        end

        function columnFrame:onClickHandler(...)
          rowFrame:onClickHandler(...)
          if column.onClick then
            column:onClick(...)
          end
        end

        offsetX = offsetX + columnWidth
      end)

      offsetY = offsetY + rowHeight
    end)

    frame.content:SetSize(offsetX, offsetY)
  end

  frame:HookScript("OnSizeChanged", function() frame:RenderTable() end)
  frame:RenderTable()
  table.insert(TableCollection, frame)
  return frame;
end

---Find a table item by callback
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): boolean
---@return T|nil, number|nil
function WP:TableFind(tbl, callback)
  for i, v in ipairs(tbl) do
    if callback(v, i) then
      return v, i
    end
  end
  return nil, nil
end

---Find a table item by key and value
---@generic T
---@param tbl T[]
---@param key string
---@param val any
---@return T|nil
function WP:TableGet(tbl, key, val)
  return WP:TableFind(tbl, function(elm)
    return elm[key] and elm[key] == val
  end)
end

---Create a new table containing all elements that pass truth test
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): boolean
---@return T[]
function WP:TableFilter(tbl, callback)
  local t = {}
  for i, v in ipairs(tbl) do
    if callback(v, i) then
      table.insert(t, v)
    end
  end
  return t
end

---Count table items
---@param tbl table
---@return number
function WP:TableCount(tbl)
  local n = 0
  for _ in pairs(tbl) do
    n = n + 1
  end
  return n
end

---Deep copy a table
---@generic T
---@param tbl T[]
---@param cache table?
---@return T[]
function WP:TableCopy(tbl, cache)
  local t = {}
  cache = cache or {}
  cache[tbl] = t
  self:TableForEach(tbl, function(v, k)
    if type(v) == "table" then
      t[k] = cache[v] or self:TableCopy(v, cache)
    else
      t[k] = v
    end
  end)
  return t
end

---Map each item in a table
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): any
---@return T[]
function WP:TableMap(tbl, callback)
  local t = {}
  self:TableForEach(tbl, function(v, k)
    local newv, newk = callback(v, k)
    t[newk and newk or k] = newv
  end)
  return t
end

---Run a callback on each table item
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number)
---@return T[]
function WP:TableForEach(tbl, callback)
  assert(tbl, "Must be a table!")
  for ik, iv in pairs(tbl) do
    callback(iv, ik)
  end
  return tbl
end

function WP:CreateScrollFrame(name, parent)
  local frame = CreateFrame("ScrollFrame", name, parent)
  frame.content = CreateFrame("Frame", "$parentContent", frame)
  frame.scrollbarH = CreateFrame("Slider", "$parentScrollbarH", frame, "UISliderTemplate")
  frame.scrollbarV = CreateFrame("Slider", "$parentScrollbarV", frame, "UISliderTemplate")

  frame:SetScript("OnMouseWheel", function(_, delta)
    if IsModifierKeyDown() or not frame.scrollbarV:IsVisible() then
      frame.scrollbarH:SetValue(frame.scrollbarH:GetValue() - delta * ((frame.content:GetWidth() - frame:GetWidth()) * 0.2))
    else
      frame.scrollbarV:SetValue(frame.scrollbarV:GetValue() - delta * ((frame.content:GetHeight() - frame:GetHeight()) * 0.2))
    end
  end)
  frame:SetScript("OnSizeChanged", function() frame:RenderScrollFrame() end)
  frame:SetScrollChild(frame.content)
  frame.content:SetScript("OnSizeChanged", function() frame:RenderScrollFrame() end)

  frame.scrollbarH:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
  frame.scrollbarH:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.scrollbarH:SetHeight(6)
  frame.scrollbarH:SetMinMaxValues(0, 100)
  frame.scrollbarH:SetValue(0)
  frame.scrollbarH:SetValueStep(1)
  frame.scrollbarH:SetOrientation("HORIZONTAL")
  frame.scrollbarH:SetObeyStepOnDrag(true)
  frame.scrollbarH.thumb = frame.scrollbarH:GetThumbTexture()
  frame.scrollbarH.thumb:SetPoint("CENTER")
  frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.15)
  frame.scrollbarH.thumb:SetHeight(10)
  frame.scrollbarH:SetScript("OnValueChanged", function(_, value) frame:SetHorizontalScroll(value) end)
  frame.scrollbarH:SetScript("OnEnter", function() frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.2) end)
  frame.scrollbarH:SetScript("OnLeave", function() frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.15) end)

  frame.scrollbarV:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.scrollbarV:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
  frame.scrollbarV:SetWidth(6)
  frame.scrollbarV:SetMinMaxValues(0, 100)
  frame.scrollbarV:SetValue(0)
  frame.scrollbarV:SetValueStep(1)
  frame.scrollbarV:SetOrientation("VERTICAL")
  frame.scrollbarV:SetObeyStepOnDrag(true)
  frame.scrollbarV.thumb = frame.scrollbarV:GetThumbTexture()
  frame.scrollbarV.thumb:SetPoint("CENTER")
  frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.15)
  frame.scrollbarV.thumb:SetWidth(10)
  frame.scrollbarV:SetScript("OnValueChanged", function(_, value) frame:SetVerticalScroll(value) end)
  frame.scrollbarV:SetScript("OnEnter", function() frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.2) end)
  frame.scrollbarV:SetScript("OnLeave", function() frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.15) end)

  if frame.scrollbarH.NineSlice then frame.scrollbarH.NineSlice:Hide() end
  if frame.scrollbarV.NineSlice then frame.scrollbarV.NineSlice:Hide() end

  function frame:RenderScrollFrame()
    if math.floor(frame.content:GetWidth()) > math.floor(frame:GetWidth()) then
      frame.scrollbarH:SetMinMaxValues(0, frame.content:GetWidth() - frame:GetWidth())
      frame.scrollbarH.thumb:SetWidth(frame.scrollbarH:GetWidth() / 5)
      frame.scrollbarH.thumb:SetHeight(frame.scrollbarH:GetHeight())
      frame.scrollbarH:Show()
    else
      frame:SetHorizontalScroll(0)
      frame.scrollbarH:Hide()
    end
    if math.floor(frame.content:GetHeight()) > math.floor(frame:GetHeight()) then
      frame.scrollbarV:SetMinMaxValues(0, frame.content:GetHeight() - frame:GetHeight())
      frame.scrollbarV.thumb:SetHeight(frame.scrollbarV:GetHeight() / 5)
      frame.scrollbarV.thumb:SetWidth(frame.scrollbarV:GetWidth())
      frame.scrollbarV:Show()
    else
      frame:SetVerticalScroll(0)
      frame.scrollbarV:Hide()
    end
  end

  frame:RenderScrollFrame()
  return frame
end
