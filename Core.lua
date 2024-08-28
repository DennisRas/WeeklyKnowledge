local WP = LibStub("AceAddon-3.0"):NewAddon("WeeklyKnowledge", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
WP.Libs = {}
WP.Libs.AceDB = LibStub:GetLibrary("AceDB-3.0")
WP.Libs.AceConfig = LibStub:GetLibrary("AceConfig-3.0")
WP.Libs.LDB = LibStub:GetLibrary("LibDataBroker-1.1")
WP.Libs.LDBIcon = LibStub("LibDBIcon-1.0")
WP.Libs.ST = LibStub("ScrollingTable")

local defaultDB = {
  global = {
    minimap = {
      minimapPos = 235,
      hide = false,
      lock = false
    },
    characters = {}
  }
}

local DARKMOON_EVENT_ID = 479
local ROW_HEIGHT = 20
local WINDOW_PADDING = 20

local function CheckDarkmoonOpen()
  local date = C_DateAndTime.GetCurrentCalendarTime()
  if date and date.monthDay then
    local today = date.monthDay
    local numEvents = C_Calendar.GetNumDayEvents(0, today)
    if numEvents then
      for i = 1, numEvents do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.id == DARKMOON_EVENT_ID then
          return true
        end
      end
    end
  end
  return false
end


local isDarkmoonOpen = CheckDarkmoonOpen()

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
}

local WP_CATEGORIES_TOOLTIPS = {
  ["Skill"] = "Your current profession skill progress.",
  ["Knowledge"] = "Your current knowledge points.",
  [WP_CATEGORY_UNIQUE] = "These are one-time knowledge point items found in treasures around the world and sold by Artisan/Renown/Kej vendors.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("No"),
  [WP_CATEGORY_TREATISE] = "These can be crafted by inscribers. Send a Crafting Order if you don't have the inscription profession.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_ARTISANQUEST] = "Quest: Kala Clayhoof of the Artisan's Consortium wants you to fulfill Crafting Orders.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_TREASURE] = "These are randomly looted from treasures and dirt around the world.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_GATHERING] = "These are randomly looted from gathering nodes around the world. You may (not confirmed) randomly find additional items beyond the weekly limit.\n\nThese are also looted from Disenchanting.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_TRAINER] = "Quest: Complete a quest at your profession trainer.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Weekly"),
  [WP_CATEGORY_DARKMOON] = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: " .. WHITE_FONT_COLOR:WrapTextInColorCode("Monthly")
}

if isDarkmoonOpen then
  table.insert(WP_CATEGORIES, WP_CATEGORY_DARKMOON)
end

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
      {category = WP_CATEGORY_DARKMOON,     quests = {29506}, itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,     quests = {29508}, itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_TRAINER,   quests = {84085, 84086},                      itemID = 227667, points = 3, limit = 1},
      {category = WP_CATEGORY_GATHERING, quests = {84290, 84291, 84292, 84293, 84294}, itemID = 227659, points = 1},
      {category = WP_CATEGORY_GATHERING, quests = {84295},                             itemID = 227661, points = 4},
      {category = WP_CATEGORY_TREASURE,  quests = {83258},                             itemID = 225231, points = 1},
      {category = WP_CATEGORY_TREASURE,  quests = {83259},                             itemID = 225230, points = 1},
      {category = WP_CATEGORY_DARKMOON,  quests = {29510},                             itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,     quests = {29511}, itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,  quests = {29514},                             itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,     quests = {29515}, itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,     quests = {29516}, itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,     quests = {29517}, itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,  quests = {29518},                             itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,  quests = {29519},                             itemID = 0,      points = 0},
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
      {category = WP_CATEGORY_DARKMOON,     quests = {29520}, itemID = 0,      points = 0},
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

local options = {
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

local frame, st
function WP:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE"] = "Show/Hide the window"
  self:RegisterChatCommand("wk", "HandleChatCmd")
  self:RegisterChatCommand("weeklyknowledge", "HandleChatCmd")
  self.Libs.AceConfig:RegisterOptionsTable("WeeklyKnowledge", options)
  self.db = self.Libs.AceDB:New("WeeklyKnowledgeDB", defaultDB, true)
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

  if not frame then
    local frameName = "WeeklyKnowledgeMainWindow"
    frame = CreateFrame("Frame", frameName, UIParent, "BackdropTemplate")
    frame:SetSize(1000, 500)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(8000)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetPoint("CENTER")
    frame:SetUserPlaced(true)
    frame:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    frame:SetBackdropColor(0, 0, 0, 0.95)
    frame:SetBackdropBorderColor(0, 0, 0, .5)
    frame:RegisterForDrag("LeftButton")
    frame:EnableMouse(true)
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:Hide()
    frame.title = CreateFrame("Frame", "$parentTitle", frame, "BackdropTemplate")
    frame.title:SetPoint("BOTTOM", frame, "TOP", 0, -8)
    frame.title:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    frame.title:SetBackdropColor(0, 0, 0, 1)
    frame.title:SetBackdropBorderColor(0, 0, 0, .5)
    frame.title:SetSize(150, 30)
    frame.title:RegisterForDrag("LeftButton")
    frame.title:EnableMouse(true)
    frame.title:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame.title:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame.title.text = frame.title:CreateFontString("$parentText", "OVERLAY")
    frame.title.text:SetFontObject("GameFontHighlight_NoShadow")
    frame.title.text:SetAllPoints()
    frame.title.text:SetJustifyH("CENTER")
    frame.title.text:SetJustifyV("MIDDLE")
    frame.title.text:SetText("WeeklyKnowledge")
    frame.closeButton = CreateFrame("Button", "$parentCloseButton", frame)
    frame.closeButton:SetSize(32, 32)
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    frame.closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    frame.closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
    frame.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)

    table.insert(UISpecialFrames, frameName)
  end
end

function WP:OnEnable()
  self:RegisterEvent("CHAT_MSG_LOOT", "Run")
  self:RegisterEvent("BAG_UPDATE", "Run")
  self:RegisterEvent("QUEST_COMPLETE", "Run")
  self:RegisterEvent("QUEST_TURNED_IN", "Run")
  self:RegisterEvent("UNIT_INVENTORY_CHANGED", "Run")
  self:RegisterEvent("ITEM_COUNT_CHANGED", "Run")
  self:RegisterEvent("BAG_UPDATE", "Run")
  self:RegisterEvent("TRAIT_CONFIG_UPDATED", "Run")
  self:Run()
end

function WP:ToggleWindow()
  if not st then
    st = self.Libs.ST:CreateST(
      {},
      nil,
      ROW_HEIGHT,
      nil,
      frame
    )
    st:SetDefaultHighlight(1, 1, 1, 0.075)
    st.frame:SetBackdrop(nil)
    st.frame:SetBackdropColor(0, 0, 0, 0)
    st.frame:SetBackdropBorderColor(0, 0, 0, 0)
    local ScrollTroughBorder = _G[st.frame:GetName() .. "ScrollTroughBorder"]
    if ScrollTroughBorder then
      ScrollTroughBorder.background:Hide()
    end
    st:RegisterEvents({
      ["OnEnter"] = function(rowFrame, cellFrame, data, cols, row, realRow, column, tbl, ...)
        local col = cols[column]
        if col and col.name and not (row or realRow) then
          GameTooltip:SetOwner(cellFrame, "ANCHOR_TOP")
          GameTooltip:SetText(col.name, 1, 1, 1);
          if col.tooltip then
            GameTooltip:AddLine(col.tooltip, nil, nil, nil, true)
          end
          GameTooltip:AddLine(" ")
          GameTooltip:AddLine("<Click to Sort>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          GameTooltip:Show()
        end
      end,
      ["OnLeave"] = function()
        GameTooltip:Hide()
      end,
      ["OnClick"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, table, button, ...) -- LS: added "button" argument
        if button == "LeftButton" then                                                                  -- LS: only handle on LeftButton click (right passes thru)
          if not (row or realrow) then
            for i, col in ipairs(st.cols) do
              if i ~= column then -- clear out all other sort marks
                cols[i].sort = nil;
              end
            end
            local sortorder = self.Libs.ST.SORT_DSC;
            if not cols[column].sort and cols[column].defaultsort then
              sortorder = cols[column].defaultsort; -- sort by columns default sort first;
            elseif cols[column].sort and cols[column].sort == self.Libs.ST.SORT_DSC then
              sortorder = self.Libs.ST.SORT_ASC;
            end
            cols[column].sort = sortorder;
            table:SortData();
          else
            local selected
            if table.multiselection then
              selected = (table.selected and table.selected:IsSelected(realrow))
            else
              selected = (table:GetSelection() == realrow)
            end
            if selected then
              table:ClearSelection(realrow);
            else
              table:SetSelection(realrow);
            end
          end
          return true;
        end
      end,
    })
  end

  if frame:IsVisible() then
    frame:Hide()
  else
    frame:Show()
    self:Run()
  end
end

function WP:Run()
  local _, playerClassFile, playerClassID = UnitClass("player")
  local characterData = {
    name = UnitName("player"),
    realm = GetRealmName(),
    class = playerClassID,
    color = C_ClassColor.GetClassColor(playerClassFile):GenerateHexColor(),
    professions = {},
    completed = {},
  }

  -- Profession Tree tracking
  local prof1, prof2 = GetProfessions()
  for _, playerProfessionID in pairs({prof1, prof2}) do
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLineID, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(playerProfessionID)
    if skillLineID then
      for _, dataProfession in ipairs(WP_DATA) do
        if dataProfession.skillLineID == skillLineID then
          local characterProfession = {
            skillLineID = skillLineID,
            level = skillLevel,
            maxLevel = maxSkillLevel,
            knowledgeLevel = 0,
            knowledgeMaxLevel = 0,
            latestExpansion = dataProfession.spellID and IsPlayerSpell(dataProfession.spellID) or false,
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

          table.insert(characterData.professions, characterProfession)
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
              characterData.completed[questID] = true
            end
          end
        end
      end
    end
  end

  self.db.global.characters[UnitGUID("player")] = characterData

  -- Build table data
  local rows = {}
  local cols = {
    {
      name = "Name",
      width = 80
    },
    {
      name = "Profession",
      width = 80
    },
    {
      name = "Skill",
      width = 80,
      align = "CENTER"
    },
    {
      name = "Knowledge",
      width = 80,
      align = "CENTER"
    },
  }

  for _, categoryName in ipairs(WP_CATEGORIES) do
    table.insert(cols, {
      name = categoryName,
      tooltip = WP_CATEGORIES_TOOLTIPS[categoryName],
      width = 90,
      align = "CENTER"
    })
  end

  -- Data rows
  for _, savedCharacter in pairs(self.db.global.characters) do
    local playerName = savedCharacter.name
    if savedCharacter.color then
      playerName = WrapTextInColorCode(playerName, savedCharacter.color)
    end
    for _, savedProfession in ipairs(savedCharacter.professions) do
      for _, dataProfession in ipairs(WP_DATA) do
        if dataProfession.skillLineID == savedProfession.skillLineID and savedProfession.latestExpansion then
          local row = {
            playerName,
            dataProfession.name,
            savedProfession.level > 0 and savedProfession.level == savedProfession.maxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(savedProfession.level .. " / " .. savedProfession.maxLevel) or savedProfession.level .. " / " .. savedProfession.maxLevel,
          }

          if savedProfession.knowledgeMaxLevel > 0 then
            table.insert(row, savedProfession.knowledgeLevel > 0 and savedProfession.knowledgeLevel == savedProfession.knowledgeMaxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(savedProfession.knowledgeLevel .. " / " .. savedProfession.knowledgeMaxLevel) or savedProfession.knowledgeLevel .. " / " .. savedProfession.knowledgeMaxLevel)

            for _, categoryName in ipairs(WP_CATEGORIES) do
              local completed = 0
              local total = 0

              for _, objective in ipairs(dataProfession.objectives) do
                if objective.category == categoryName then
                  if objective.category == WP_CATEGORY_DARKMOON and not isDarkmoonOpen then
                    total = 0
                  else
                    if objective.quests then
                      local limit = 0
                      for _, questID in ipairs(objective.quests) do
                        total = total + 1
                        if objective.limit and total > objective.limit then
                          total = objective.limit
                        end
                        if savedCharacter.completed[questID] then
                          completed = completed + 1
                        end
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
              table.insert(row, result)
            end
          else
            table.insert(row, "")
          end
          table.insert(rows, row)
        end
      end
    end
  end

  if st then
    st:SetDisplayCols(cols)
    st:SetData(rows, true)
    st:Refresh()
    frame:SetWidth(st.frame:GetWidth() + WINDOW_PADDING)
    frame:SetHeight(st.frame:GetHeight() + ROW_HEIGHT + 5 + WINDOW_PADDING)
    st.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", WINDOW_PADDING / 2, -(WINDOW_PADDING / 2 + ROW_HEIGHT + 5))
  end
end
