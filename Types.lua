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

---@class WK_DefaultGlobalMain
---@field selectedExpansion Enum.ExpansionLevel? or nil for all
---@field hiddenColumns table<string, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field windowBorder boolean Show the border?
---@field fontSize integer?
---@field checklistHelpTipClosed boolean?

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
---@field completed table<integer, boolean> questID -> true

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
---@field spellID integer
---@field catchUpCurrencyID integer
---@field catchUpWeeklyCap integer
---@field catchUpItemID integer

---@class WK_ObjectiveCategory
---@field id Enum.WK_ObjectiveCategory
---@field name string
---@field description string
---@field type "item" | "quest"
---@field repeatable "No" | "Yes" | "Weekly" | "Monthly"

---@class WK_Objective
---@field id integer
---@field skillLineVariantID integer Profession variant (unique per expansion); expansion from Data:GetSkillLineVariant
---@field categoryID Enum.WK_ObjectiveCategory
---@field quests integer[]
---@field itemID integer?
---@field points integer
---@field limit integer?

---@class WK_Progress
---@field characterGUID string
---@field objectiveId integer WK_Objective.id
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
}
