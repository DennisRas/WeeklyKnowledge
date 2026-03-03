---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data

---@type WK_Expansion[]
Data.Expansions = {
  -- {id = Enum.ExpansionLevel.Dragonflight, abbr = "DF",       name = "Dragonflight"}, -- Disable for now since it's not set up yet.
  {id = Enum.ExpansionLevel.WarWithin, abbr = "TWW",      name = "The War Within"},
  {id = Enum.ExpansionLevel.Midnight,  abbr = "Midnight", name = "Midnight"},
}
