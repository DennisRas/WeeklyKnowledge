--------------------------------------------------------------------------------
-- Global DB
--------------------------------------------------------------------------------

---@class WK_TableSortState
---@field columnId string?
---@field direction ("asc" | "desc")?

---@class WK_DefaultGlobal
---@field DBVersion integer?
---@field weeklyReset integer?
---@field minimap {minimapPos: number, hide: boolean, lock: boolean }
---@field showFullProfessionName boolean?
---@field characters table<string, WK_Character>
---@field main WK_DefaultGlobalMain
---@field checklist WK_DefaultGlobalChecklist

---@class WK_DefaultGlobalMain
---@field selectedExpansions Enum.ExpansionLevel[]?
---@field hiddenColumns table<string, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field windowBorder boolean
---@field fontSize integer?
---@field checklistHelpTipClosed boolean?
---@field hideLowLevelProfessions boolean?
---@field tableSort WK_TableSortState?

---@class WK_DefaultGlobalChecklist
---@field selectedExpansions Enum.ExpansionLevel[]?
---@field hiddenColumns table<string, boolean>
---@field hiddenCategories table<Enum.WK_ObjectiveCategory, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field windowBorder boolean
---@field windowTitlebar boolean
---@field fontSize integer?
---@field open boolean
---@field hideCompletedObjectives boolean
---@field hideInCombat boolean
---@field hideInDungeons boolean
---@field hideTable boolean
---@field hideTableHeader boolean
---@field tableSort WK_TableSortState?

--------------------------------------------------------------------------------
-- Game Data References
--------------------------------------------------------------------------------

---@class WK_Expansion
---@field id Enum.ExpansionLevel
---@field enabled boolean
---@field abbr string
---@field name string

---@class WK_Faction
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field name string

---@class WK_Currency
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field name string

---@class WK_SkillLine
---@field id integer
---@field name string

---@class WK_SkillLineVariant
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field skillLineID integer
---@field name string
---@field catchUpCurrencyID integer
---@field catchUpItemID integer
---@field concentrationCurrencyID integer

--------------------------------------------------------------------------------
-- Character Data
--------------------------------------------------------------------------------

---@class WK_Character
---@field GUID string|WOWGUID
---@field name string
---@field realmName string
---@field level integer
---@field factionEnglish string
---@field factionName string
---@field raceID integer
---@field raceEnglish string
---@field raceName string
---@field classID integer
---@field classFile ClassFile?
---@field className string
---@field lastUpdate number
---@field professions WK_CharacterProfession[]
---@field completed table<integer, boolean>
---@field firstCrafts table<integer, WK_CharacterFirstCraft>
---@field factions table<integer, WK_CharacterFaction>
---@field currencies table<integer, WK_CharacterCurrency>
---@field items table<integer, integer>

---@class WK_CharacterCurrency
---@field id integer
---@field name string
---@field iconFileID integer
---@field quality integer
---@field quantity integer
---@field maxQuantity integer
---@field rechargingCycleDurationMS integer
---@field rechargingAmountPerCycle integer
---@field lastUpdated number

---@class WK_CharacterFaction
---@field id integer
---@field level integer

---@class WK_CharacterFirstCraft
---@field id integer
---@field completed boolean

---@class WK_CharacterProfession
---@field enabled boolean
---@field skillLineVariantID integer
---@field skillLevel integer
---@field skillMaxLevel integer
---@field knowledgeLevel integer
---@field knowledgeMaxLevel integer
---@field knowledgeUnspent integer
---@field specializations WK_CharacterProfessionSpecialization[]

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

--------------------------------------------------------------------------------
-- Objectives Data
--------------------------------------------------------------------------------

---@class WK_ObjectiveCategory
---@field id Enum.WK_ObjectiveCategory
---@field name string
---@field description string
---@field type "item" | "quest" | "recipe"
---@field repeatable "No" | "Yes" | "Weekly" | "Monthly"
---@field hint boolean?

---@alias WK_ObjectiveRequirementType "item" | "currency" | "renown" | "skill" | "quest"
---@alias WK_ObjectiveRequirementMatch "all" | "any"

---@class WK_ObjectiveLocation
---@field m number?
---@field x number?
---@field y number?
---@field hint string?

---@class WK_ObjectiveRequirement
---@field type WK_ObjectiveRequirementType
---@field id integer?
---@field amount integer?
---@field name string?
---@field quests integer[]?
---@field match WK_ObjectiveRequirementMatch?

---@class WK_Objective
---@field skillLineVariantID integer
---@field categoryID Enum.WK_ObjectiveCategory
---@field quests integer[]
---@field spellID integer?
---@field itemID integer?
---@field points integer
---@field limit integer?
---@field loc WK_ObjectiveLocation?
---@field requires WK_ObjectiveRequirement[]?

--------------------------------------------------------------------------------
-- Progress State
--------------------------------------------------------------------------------

---@class WK_ObjectiveProgressRequirement
---@field requirement WK_ObjectiveRequirement
---@field isCompleted boolean

---@class WK_ObjectiveProgress
---@field character WK_Character
---@field objective WK_Objective
---@field isCompleted boolean
---@field questsCompleted number
---@field questsTotal number
---@field pointsEarned number
---@field pointsTotal number
---@field requirementsMet number
---@field requirementsTotal number
---@field requirements WK_ObjectiveProgressRequirement[]
---@field items table<integer, boolean>

---@class WK_CategoryProgress
---@field character WK_Character
---@field objectiveCategory WK_ObjectiveCategory
---@field objectivesCompleted number
---@field objectivesTotal number
---@field pointsEarned number
---@field pointsTotal number
---@field requirementsMet number
---@field requirementsTotal number
---@field requirements WK_ObjectiveProgressRequirement[]
---@field items table<integer, boolean>

---@class WK_ProfessionProgress
---@field character WK_Character
---@field profession WK_CharacterProfession
---@field objectivesCompleted number
---@field objectivesTotal number
---@field pointsEarned number
---@field pointsTotal number
---@field requirementsMet number
---@field requirementsTotal number
---@field requirements WK_ObjectiveProgressRequirement[]
---@field items table<integer, boolean>

---@class WK_CategoryProfessionProgress
---@field character WK_Character
---@field category WK_ObjectiveCategory
---@field profession WK_CharacterProfession
---@field objectivesCompleted number
---@field objectivesTotal number
---@field pointsEarned number
---@field pointsTotal number
---@field requirementsMet number
---@field requirementsTotal number
---@field requirements WK_ObjectiveProgressRequirement[]
---@field items table<integer, boolean>

--------------------------------------------------------------------------------
-- Cache
--------------------------------------------------------------------------------

---@class WK_DataCache
---@field calendarOpened boolean
---@field isDarkmoonOpen boolean
---@field inCombat boolean
---@field items table<integer, ItemMixin>
---@field mapInfo table<integer, UiMapDetails>
---@field progressCache table<string, WK_ObjectiveProgress[]>
---@field completedQuests table<integer, boolean>
---@field tradeSkillRecipes TradeSkillRecipeInfo[]

--------------------------------------------------------------------------------
-- Tables
--------------------------------------------------------------------------------

---@class WK_TableData
---@field columns WK_TableColumn[]?
---@field rows WK_TableRow[]

---@class WK_TableColumnSorting
---@field enabled boolean
---@field compare? fun(a: WK_TableRow, b: WK_TableRow): boolean

---@class WK_TableColumn
---@field id string
---@field headerText string
---@field width integer
---@field align "LEFT" | "CENTER" | "RIGHT" | nil
---@field onEnter function?
---@field onLeave function?
---@field toggleHidden boolean?
---@field renderCell fun(data: WK_TableRowData): WK_TableCell
---@field sorting WK_TableColumnSorting

---@class WK_TableRow
---@field cells WK_TableCell[]
---@field backgroundColor {r: number, g: number, b: number, a: number}?
---@field onEnter function?
---@field onLeave function?
---@field onClick function?
---@field data WK_TableRowData|nil

---@class WK_TableRowData
---@field character WK_Character
---@field characterProfession WK_CharacterProfession
---@field skillLineVariantID integer
---@field objective WK_Objective?
---@field progress WK_ObjectiveProgress?

---@class WK_TableCell
---@field text string?
---@field backgroundColor {r: number, g: number, b: number, a: number}?
---@field onEnter function?
---@field onLeave function?
---@field onClick function?

---@class WK_TableSortConfig
---@field enabled boolean
---@field defaultOrder "asc"|"desc"
---@field defaultCompare fun(a: WK_TableRow, b: WK_TableRow): boolean
---@field savedState WK_TableSortState?
---@field onStateChanged? fun(state: WK_TableSortState)

---@class WK_TableConfigHeader
---@field enabled boolean
---@field sticky boolean
---@field height number

---@class WK_TableConfigRows
---@field height number
---@field highlight boolean
---@field striped boolean

---@class WK_TableConfigColumnDefaults
---@field width number
---@field highlight boolean
---@field striped boolean

---@class WK_TableConfigCells
---@field padding number
---@field highlight boolean

---@class WK_TableConfig
---@field header WK_TableConfigHeader?
---@field rows WK_TableConfigRows?
---@field columns WK_TableConfigColumnDefaults?
---@field cells WK_TableConfigCells?
---@field sorting WK_TableSortConfig?
---@field data WK_TableData?

--------------------------------------------------------------------------------
-- Enums
--------------------------------------------------------------------------------

---@enum Enum.WK_ObjectiveCategory
Enum.WK_ObjectiveCategory = {
  Unique = "Unique",
  FirstCraft = "FirstCraft",
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
  AtalAman = 2536,
  AzjKahet = 2255,
  CityOfThreads = 2213,
  DarkmoonIsland = 407,
  Dornogal = 2339,
  EversongWoods = 2395,
  Hallowfall = 2215,
  Harandar = 2413,
  IsleOfDorn = 2248,
  SilvermoonCity = 2393,
  SlayersRise = 2444,
  Tazavesh = 2472,
  TheRingingDeeps = 2214,
  Undermine = 2346,
  Voidstorm = 2405,
  ZulAman = 2437,
}
