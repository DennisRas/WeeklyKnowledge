---@class WK_DefaultGlobal
---@field DBVersion integer?
---@field weeklyReset integer?
---@field minimap {minimapPos: number, hide: boolean, lock: boolean }
---@field showFullProfessionName boolean? Show the full profession name with the expansion variant
---@field characters table<string, WK_Character>
---@field main WK_DefaultGlobalMain
---@field checklist WK_DefaultGlobalhecklist

---@class WK_Expansion
---@field id Enum.ExpansionLevel
---@field enabled boolean Whether the expansion is enabled in the addon
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
---@field selectedExpansions Enum.ExpansionLevel[]? or empty table for all
---@field hiddenColumns table<string, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field windowBorder boolean Show the border?
---@field fontSize integer?
---@field checklistHelpTipClosed boolean?
---@field hideLowLevelProfessions boolean? Hide professions with a skill level below 25

---@class WK_DefaultGlobalhecklist
---@field selectedExpansions Enum.ExpansionLevel[]? or empty table for all
---@field hiddenColumns table<string, boolean>
---@field hiddenCategories table<Enum.WK_ObjectiveCategory, boolean>
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
---@field firstCrafts table<integer, WK_CharacterFirstCraft> spellID -> WK_CharacterFirstCraft
---@field factions table<integer, WK_CharacterFaction> factionID -> WK_CharacterFaction
---@field currencies table<integer, WK_CharacterCurrency> currencyID -> WK_CharacterCurrency
---@field items table<integer, integer> itemID -> quantity

---@class WK_CharacterCurrency
---@field id integer Currency ID
---@field name string Name
---@field iconFileID integer Icon file ID
---@field quality integer Quality
---@field quantity integer Current quantity
---@field maxQuantity integer Max quantity
---@field rechargingCycleDurationMS integer Recharging cycle duration in milliseconds (e.g. 10000)
---@field rechargingAmountPerCycle integer Recharging amount per cycle (e.g. 1)
---@field lastUpdated number Last update time

---@class WK_CharacterFaction
---@field id integer Faction ID
---@field level integer Level

---@class WK_CharacterFirstCraft
---@field id integer Spell ID (Recipe ID)
---@field completed boolean Whether the first craft has been completed

---@class WK_CharacterProfession
---@field enabled boolean
---@field skillLineVariantID integer
---@field skillLevel integer Profession skill (e.g. 100/100)
---@field skillMaxLevel integer Profession skill cap
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
---@field concentrationCurrencyID integer

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
---@field spellID integer?
---@field itemID integer?
---@field points integer
---@field limit integer?
---@field loc WK_ObjectiveLocation?
---@field requires WK_ObjectiveRequirement[]?

---@class WK_ObjectiveProgress
---@field character WK_Character The character the progress is for.
---@field objective WK_Objective The objective the progress is for.
---@field isCompleted boolean Whether the objective is completed.
---@field questsCompleted number The number of quests completed for the objective.
---@field questsTotal number The total number of quests for the objective.
---@field pointsEarned number The number of points earned for the objective.
---@field pointsTotal number The total number of points for the objective.
---@field requirementsMet number The number of requirements met for the objective.
---@field requirementsTotal number The total number of requirements for the objective.
---@field requirements WK_ObjectiveProgressRequirement[] A table of requirements completed for the objective.
---@field items table<integer, boolean> A table of items that have been collected for the objective.

---@class WK_ObjectiveProgressRequirement
---@field requirement WK_ObjectiveRequirement The requirement.
---@field isCompleted boolean Whether the requirement is completed.

---@class WK_CategoryProgress
---@field character WK_Character The character the progress is for.
---@field objectiveCategory WK_ObjectiveCategory The category the progress is for.
---@field objectivesCompleted number The number of objectives completed in the category.
---@field objectivesTotal number The total number of objectives in the category.
---@field pointsEarned number The number of points earned in the category.
---@field pointsTotal number The total number of points in the category.
---@field requirementsMet number The number of requirements met in the category.
---@field requirementsTotal number The total number of requirements in the category.
---@field requirements WK_ObjectiveProgressRequirement[] A table of requirement completions in the category.
---@field items table<integer, boolean> A table of items that have been collected in the category.

---@class WK_ProfessionProgress
---@field character WK_Character The character the progress is for.
---@field profession WK_CharacterProfession The profession the progress is for.
---@field objectivesCompleted number The number of objectives completed in the profession.
---@field objectivesTotal number The total number of objectives in the profession.
---@field pointsEarned number The number of points earned in the profession.
---@field pointsTotal number The total number of points in the profession.
---@field requirementsMet number The number of requirements met in the profession.
---@field requirementsTotal number The total number of requirements in the profession.
---@field requirements WK_ObjectiveProgressRequirement[] A table of requirement completions in the profession.
---@field items table<integer, boolean> A table of items that have been collected in the profession.

---@class WK_DataCache
---@field calendarOpened boolean
---@field isDarkmoonOpen boolean
---@field inCombat boolean
---@field items table<integer, ItemMixin>
---@field mapInfo table<integer, UiMapDetails>
---@field progressCache table<string, WK_ObjectiveProgress[]> Character GUID -> WK_ObjectiveProgress[]
---@field completedQuests table<integer, boolean> questID -> true
---@field tradeSkillRecipes TradeSkillRecipeInfo[] Trade skill recipes

---@class WK_CategoryProfessionProgress
---@field character WK_Character The character the progress is for.
---@field category WK_ObjectiveCategory The category the progress is for.
---@field profession WK_CharacterProfession The profession the progress is for.
---@field objectivesCompleted number The number of objectives completed in the category and profession.
---@field objectivesTotal number The total number of objectives in the category and profession.
---@field pointsEarned number The number of points earned in the category and profession.
---@field pointsTotal number The total number of points in the category and profession.
---@field requirementsMet number The number of requirements met in the category and profession.
---@field requirementsTotal number The total number of requirements in the category and profession.
---@field requirements WK_ObjectiveProgressRequirement[] A table of requirement completions in the category and profession.
---@field items table<integer, boolean> A table of items that have been collected in the category and profession.

---@class WK_DataColumn
---@field name string
---@field width integer
---@field align "LEFT" | "CENTER" | "RIGHT" | nil
---@field onEnter function?
---@field onLeave function?
---@field cell fun(character: WK_Character, characterProfession: WK_CharacterProfession, skillLineVariantID: integer): WK_TableDataCell
---@field toggleHidden boolean

---@class WK_CheckListItem
---@field id integer
---@field name string
---@field link string
---@field texture integer

---@class WK_ChecklistData
---@field character WK_Character
---@field characterProfession WK_CharacterProfession
---@field skillLineVariantID integer
---@field objective WK_Objective
---@field progress WK_ObjectiveProgress

---@class WK_ChecklistColumn
---@field name string
---@field width number
---@field cell fun(data: WK_ChecklistData): WK_TableDataCell

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
  SilvermoonCity = 2393,
}
