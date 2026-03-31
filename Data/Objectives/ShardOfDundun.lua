---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local category = Enum.WK_ObjectiveCategory.ShardOfDundun

---@type WK_Objective[]
local objectives = {
  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Skinning
  {skillLineVariantID = 2917, categoryID = category, quests = {89507}, points = 8},
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {89507}, points = 8},
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
