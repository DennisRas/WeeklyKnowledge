---@class WK_DefaultGlobal
---@field DBVersion integer?
---@field weeklyReset integer?
---@field minimap {minimapPos: number, hide: boolean, lock: boolean }
---@field characters table<string, WK_Character>
---@field main WK_DefaultGlobalMain
---@field checklist WK_DefaultGlobalhecklist

---@class WK_Expansion
---@field id Enum.ExpansionLevel
---@field abbr string Abbreviation key, e.g. "DF", "TWW", "Midnight"
---@field name string Full name

---@class WK_Faction
---@field id integer MajorFactionData.factionID
---@field expansionID Enum.ExpansionLevel MajorFactionData.expansionID
---@field name string MajorFactionData.name

---@class WK_Currency
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field name string

---@class WK_DefaultGlobalMain
---@field selectedExpansion Enum.ExpansionLevel? or nil for all
---@field hiddenColumns table<string, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field windowBorder boolean Show the border?
---@field fontSize integer?
---@field checklistHelpTipClosed boolean?
---@field hideLowLevelProfessions boolean?

---@class WK_DefaultGlobalhecklist
---@field selectedExpansion Enum.ExpansionLevel? or nil for all
---@field hiddenColumns table<string, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field windowBorder boolean Show the border?
---@field windowTitlebar boolean
---@field fontSize integer?
---@field open boolean
---@field hideCompletedObjectives boolean
---@field hideInCombat boolean
---@field hideInDungeons boolean
---@field hideTable boolean
---@field hideTableHeader boolean
---@field hideUniqueObjectives boolean
---@field hideUniqueVendorObjectives boolean
---@field hideCatchUpObjectives boolean

---@class WK_Character
---@field GUID string|WOWGUID Character GUID
---@field name string Character name
---@field realmName string Realm name
---@field level integer Character level
---@field factionEnglish string Faction English name
---@field factionName string Faction name
---@field raceID integer Race ID
---@field raceEnglish string Race English name
---@field raceName string Race name
---@field classID integer Class ID
---@field classFile ClassFile? Class file
---@field className string Class name
---@field lastUpdate number Last update time
---@field professions WK_CharacterProfession[] Profession information for the character
---@field completed table<integer, boolean> questID -> true Completed quests for the character

---@class WK_CharacterProfession
---@field enabled boolean
---@field skillLineVariantID integer
---@field skillLevel integer Profession skill (e.g. 100/100)
---@field skillMaxLevel integer Profession skill cap
---@field knowledgeLevel integer
---@field knowledgeMaxLevel integer
---@field knowledgeUnspent integer
---@field specializations WK_CharacterProfessionSpecialization[]
---@field catchUpCurrencyInfo CurrencyInfo?
---@field tradeSkillRecipes TradeSkillRecipeInfo[] Recipes for the profession

---@class WK_CharacterProfessionSpecialization
---@field rootNodeID integer
---@field rootIconID integer
---@field name string
---@field description string
---@field state Enum.ProfessionsSpecTabState
---@field treeID integer
---@field configID integer
---@field knowledgeLevel integer
---@field knowledgeMaxLevel integer

---@class WK_SkillLine
---@field id integer skillLineID (matches GetProfessionInfo skillLineID)
---@field name string

---@class WK_SkillLineVariant
---@field id integer skillLineVariantID (matches GetProfessionInfo skillLineVariantID)
---@field expansionID Enum.ExpansionLevel
---@field skillLineID integer References WK_SkillLine.id
---@field name string Expansion-specific name (e.g. "Khaz Algar Alchemy")
---@field catchUpCurrencyID integer
---@field catchUpItemID integer

---@class WK_ObjectiveCategory
---@field id Enum.WK_ObjectiveCategory
---@field name string
---@field description string
---@field type "item" | "quest"
---@field repeatable "No" | "Yes" | "Weekly" | "Monthly"
---@field hint boolean?

---@alias WK_ObjectiveRequirementType "item" | "currency" | "renown" | "skill" | "quest"
---@alias WK_ObjectiveRequirementMatch "all" | "any"

---@class WK_ObjectiveLocation
---@field m number? UiMapID (e.g. Enum.WK_Map)
---@field x number?
---@field y number?
---@field hint string?

---@class WK_ObjectiveRequirement
---@field type WK_ObjectiveRequirementType
---@field id integer? item/currency/renown ID
---@field amount integer?
---@field name string? quest requirement label
---@field quests integer[]? quest IDs for type "quest"
---@field match WK_ObjectiveRequirementMatch? for type "quest": all or any

---@class WK_Objective
---@field skillLineVariantID integer Profession variant (unique per expansion); expansion from Data:GetSkillLineVariant
---@field categoryID Enum.WK_ObjectiveCategory
---@field quests integer[]
---@field itemID integer?
---@field points integer
---@field limit integer?
---@field loc WK_ObjectiveLocation?
---@field requires WK_ObjectiveRequirement[]?

---@class WK_Progress
---@field characterGUID string
---@field objective WK_Objective
---@field questsCompleted number
---@field questsTotal number
---@field pointsEarned number
---@field pointsTotal number
---@field items table<number, boolean>

---@class WK_DataCache
---@field calendarOpened boolean
---@field isDarkmoonOpen boolean
---@field inCombat boolean
---@field items table<integer, ItemMixin>
---@field mapInfo table<integer, UiMapDetails>
---@field weeklyProgress WK_Progress[]
---@field completedQuests table<integer, boolean> questID -> true
---@field tradeSkillRecipes TradeSkillRecipeInfo[] Trade skill recipes

---@class WK_DataColumn
---@field name string
---@field width integer
---@field align "LEFT" | "CENTER" | "RIGHT" | nil
---@field onEnter function?
---@field onLeave function?
---@field cell fun(character: WK_Character, characterProfession: WK_CharacterProfession, skillLineVariantID: integer): WK_TableDataCell
---@field toggleHidden boolean

---@class WK_TableData
---@field columns WK_TableDataColumn[]?
---@field rows WK_TableDataRow[]

---@class WK_TableDataColumn
---@field width number
---@field align string?

---@class WK_TableDataRow
---@field columns WK_TableDataCell[]
---@field backgroundColor {r: number, g: number, b: number, a: number}?
---@field onEnter function?
---@field onLeave function?
---@field onClick function?

---@class WK_TableDataCell
---@field text string?
---@field backgroundColor {r: number, g: number, b: number, a: number}?
---@field onEnter function?
---@field onLeave function?
---@field onClick function?

---@enum Enum.WK_ObjectiveCategory
Enum.WK_ObjectiveCategory = {
  Unique = "Unique",
  Treatise = "Treatise",
  ArtisanQuest = "ArtisanQuest",
  Treasure = "Treasure",
  Gathering = "Gathering",
  TrainerQuest = "TrainerQuest",
  DarkmoonQuest = "DarkmoonQuest",
  CatchUp = "CatchUp",
  WeeklyQuest = "WeeklyQuest",
}

---@enum Enum.WK_Factions
Enum.WK_Faction = {
  AmaniTribe = 2696,
  TheSingularity = 2699,
  Harati = 2704,
  SilvermoonCity = 2710
}

---@enum Enum.WK_Currencies
Enum.WK_Currency = {
  VoidlightMarl = 3316,
  ArtisanAlchemistMoxie = 3256,
  ArtisanBlacksmithMoxie = 3257,
  ArtisanEnchanterMoxie = 3258,
  ArtisanEngineerMoxie = 3259,
  ArtisanHerbalistMoxie = 3260,
  ArtisanScribeMoxie = 3261,
  ArtisanJewelcrafterMoxie = 3262,
  ArtisanLeatherworkerMoxie = 3263,
  ArtisanMinerMoxie = 3264,
  ArtisanSkinnerMoxie = 3265,
  ArtisanTailorMoxie = 3266,
  UnalloyedAbundance = 3377,
}

---@enum Enum.WK_Maps
Enum.WK_Map = {
  DarkmoonIsland = 407,
  Dornogal = 2339,
  CityOfThreads = 2213,
  Hallowfall = 2215,
  AzjKahet = 2255,
  TheRingingDeeps = 2214,
  IsleOfDorn = 2248,
  Undermine = 2346,
  Tazavesh = 2472,
  Voidstorm = 2405,
  ZulAman = 2437,
  AtalAman = 2536,
  Harandar = 2413,
  EversongWoods = 2395,
  SlayersRise = 2444,
}
