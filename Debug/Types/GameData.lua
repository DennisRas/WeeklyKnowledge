---@class WK_Currency
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field name string

---@class WK_Faction
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

---@class WK_TomTom
---@field AddWaypoint fun(self: WK_TomTom, mapID: number, x: number, y: number, options: WK_TomTomWaypointOptions)

---@class WK_TomTomWaypointOptions
---@field title string
---@field from string
