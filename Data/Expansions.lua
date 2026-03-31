---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

---@type WK_Expansion[]
Data.Expansions = {
  {id = Enum.ExpansionLevel.Dragonflight, enabled = false, abbr = "DF",       name = L["expansion_dragonflight"]}, -- Disable for now since it's not set up yet.
  {id = Enum.ExpansionLevel.WarWithin,    enabled = true,  abbr = "TWW",      name = L["expansion_war_within"]},
  {id = Enum.ExpansionLevel.Midnight,     enabled = true,  abbr = "Midnight", name = L["expansion_midnight"]},
}
