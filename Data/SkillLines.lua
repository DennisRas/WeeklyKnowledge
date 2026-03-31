---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

---@type WK_SkillLine[]
Data.SkillLines = {
  {id = 171, name = L["profession_alchemy"]},
  {id = 164, name = L["profession_blacksmithing"]},
  {id = 333, name = L["profession_enchanting"]},
  {id = 202, name = L["profession_engineering"]},
  {id = 182, name = L["profession_herbalism"]},
  {id = 773, name = L["profession_inscription"]},
  {id = 755, name = L["profession_jewelcrafting"]},
  {id = 165, name = L["profession_leatherworking"]},
  {id = 186, name = L["profession_mining"]},
  {id = 393, name = L["profession_skinning"]},
  {id = 197, name = L["profession_tailoring"]},
}
