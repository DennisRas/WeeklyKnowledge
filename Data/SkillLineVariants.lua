---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

---@type WK_SkillLineVariant[]
Data.SkillLineVariants = {
  -- Dragonflight (Dragon Isles)
  {id = 2823, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 171, name = L["variant_dragon_isles_alchemy"],        catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3054
  {id = 2822, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 164, name = L["variant_dragon_isles_blacksmithing"],  catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3050
  {id = 2825, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 333, name = L["variant_dragon_isles_enchanting"],     catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3051
  {id = 2827, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 202, name = L["variant_dragon_isles_engineering"],    catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3052
  {id = 2832, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 182, name = L["variant_dragon_isles_herbalism"],      catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0},
  {id = 2828, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 773, name = L["variant_dragon_isles_inscription"],    catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3053
  {id = 2829, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 755, name = L["variant_dragon_isles_jewelcrafting"],  catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3047
  {id = 2830, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 165, name = L["variant_dragon_isles_leatherworking"], catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3049
  {id = 2833, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 186, name = L["variant_dragon_isles_mining"],         catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0},
  {id = 2834, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 393, name = L["variant_dragon_isles_skinning"],       catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0},
  {id = 2831, expansionID = Enum.ExpansionLevel.Dragonflight, skillLineID = 197, name = L["variant_dragon_isles_tailoring"],      catchUpCurrencyID = 0,    catchUpItemID = 0,      concentrationCurrencyID = 0}, -- 3048
  -- The War Within (Khaz Algar)
  {id = 2871, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 171, name = L["variant_khaz_algar_alchemy"],          catchUpCurrencyID = 3057, catchUpItemID = 228724, concentrationCurrencyID = 3045},
  {id = 2872, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 164, name = L["variant_khaz_algar_blacksmithing"],    catchUpCurrencyID = 3058, catchUpItemID = 228726, concentrationCurrencyID = 3040},
  {id = 2874, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 333, name = L["variant_khaz_algar_enchanting"],       catchUpCurrencyID = 3059, catchUpItemID = 227662, concentrationCurrencyID = 3046},
  {id = 2875, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 202, name = L["variant_khaz_algar_engineering"],      catchUpCurrencyID = 3060, catchUpItemID = 228730, concentrationCurrencyID = 3044},
  {id = 2877, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 182, name = L["variant_khaz_algar_herbalism"],        catchUpCurrencyID = 3061, catchUpItemID = 224835, concentrationCurrencyID = 0},
  {id = 2878, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 773, name = L["variant_khaz_algar_inscription"],      catchUpCurrencyID = 3062, catchUpItemID = 228732, concentrationCurrencyID = 3043},
  {id = 2879, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 755, name = L["variant_khaz_algar_jewelcrafting"],    catchUpCurrencyID = 3063, catchUpItemID = 228734, concentrationCurrencyID = 3013},
  {id = 2880, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 165, name = L["variant_khaz_algar_leatherworking"],   catchUpCurrencyID = 3064, catchUpItemID = 228736, concentrationCurrencyID = 3042},
  {id = 2881, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 186, name = L["variant_khaz_algar_mining"],           catchUpCurrencyID = 3065, catchUpItemID = 224838, concentrationCurrencyID = 0},
  {id = 2882, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 393, name = L["variant_khaz_algar_skinning"],         catchUpCurrencyID = 3066, catchUpItemID = 224782, concentrationCurrencyID = 0},
  {id = 2883, expansionID = Enum.ExpansionLevel.WarWithin,    skillLineID = 197, name = L["variant_khaz_algar_tailoring"],        catchUpCurrencyID = 3067, catchUpItemID = 228738, concentrationCurrencyID = 3041},
  -- Midnight
  {id = 2906, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 171, name = L["variant_midnight_alchemy"],            catchUpCurrencyID = 3189, catchUpItemID = 246320, concentrationCurrencyID = 3161},
  {id = 2907, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 164, name = L["variant_midnight_blacksmithing"],      catchUpCurrencyID = 3199, catchUpItemID = 246322, concentrationCurrencyID = 3162},
  {id = 2909, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 333, name = L["variant_midnight_enchanting"],         catchUpCurrencyID = 3198, catchUpItemID = 267653, concentrationCurrencyID = 3163},
  {id = 2910, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 202, name = L["variant_midnight_engineering"],        catchUpCurrencyID = 3197, catchUpItemID = 246326, concentrationCurrencyID = 3164},
  {id = 2912, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 182, name = L["variant_midnight_herbalism"],          catchUpCurrencyID = 3196, catchUpItemID = 238467, concentrationCurrencyID = 0},
  {id = 2913, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 773, name = L["variant_midnight_inscription"],        catchUpCurrencyID = 3195, catchUpItemID = 246328, concentrationCurrencyID = 3165},
  {id = 2914, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 755, name = L["variant_midnight_jewelcrafting"],      catchUpCurrencyID = 3194, catchUpItemID = 246330, concentrationCurrencyID = 3166},
  {id = 2915, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 165, name = L["variant_midnight_leatherworking"],     catchUpCurrencyID = 3193, catchUpItemID = 246332, concentrationCurrencyID = 3167},
  {id = 2916, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 186, name = L["variant_midnight_mining"],             catchUpCurrencyID = 3192, catchUpItemID = 237507, concentrationCurrencyID = 0},
  {id = 2917, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 393, name = L["variant_midnight_skinning"],           catchUpCurrencyID = 3191, catchUpItemID = 238627, concentrationCurrencyID = 0},
  {id = 2918, expansionID = Enum.ExpansionLevel.Midnight,     skillLineID = 197, name = L["variant_midnight_tailoring"],          catchUpCurrencyID = 3190, catchUpItemID = 246334, concentrationCurrencyID = 3168},
}
