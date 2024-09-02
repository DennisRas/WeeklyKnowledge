---@class WK_DefaultDBGlobal
---@field DBVersion integer
---@field weeklyReset integer
---@field minimap {minimapPos: number, hide: boolean, lock: boolean }
---@field hiddenColumns table<string, boolean>
---@field windowScale integer
---@field windowBackgroundColor {r: number, g: number, b: number, a: number}
---@field characters table<string, WK_Character>

---@class WK_Character
---@field GUID string|WOWGUID
---@field enabled boolean
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

---@class WK_CharacterProfession
---@field skillLineID integer
---@field level integer
---@field maxLevel integer
---@field knowledgeLevel integer
---@field knowledgeMaxLevel integer

---@class WK_Objective
---@field name string
---@field description string
---@field type "item" | "quest"
---@field repeatable "No" | "Weekly" | "Monthly"

---@class WK_Profession
---@field name string
---@field skillLineID integer Profession ID
---@field skillLineVariantID integer Profession Expansion Variant ID
---@field spellID integer Learned Profession Spell ID
---@field objectives WK_ProfessionObjective[]

---@class WK_ProfessionObjective
---@field category WK_Objective
---@field quests integer[]
---@field itemID integer?
---@field points integer
---@field limit integer?

---@class WK_DataCache
---@field isDarkmoonOpen boolean
---@field items table<integer, ItemMixin>

---@class WK_DataColumn
---@field name string
---@field width integer
---@field align "LEFT" | "CENTER" | "RIGHT" | nil
---@field onEnter function?
---@field onLeave function?
---@field cell fun(character: WK_Character, characterProfession: WK_CharacterProfession, dataProfession: WK_Profession): WK_TableDataCell

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