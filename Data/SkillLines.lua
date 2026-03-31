---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

---@type WK_SkillLine[]
Data.SkillLines = {
  {id = 171, name = "Alchemy"},
  {id = 164, name = "Blacksmithing"},
  {id = 333, name = "Enchanting"},
  {id = 202, name = "Engineering"},
  {id = 182, name = "Herbalism"},
  {id = 773, name = "Inscription"},
  {id = 755, name = "Jewelcrafting"},
  {id = 165, name = "Leatherworking"},
  {id = 186, name = "Mining"},
  {id = 393, name = "Skinning"},
  {id = 197, name = "Tailoring"},
}
