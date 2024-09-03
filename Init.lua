---@type string
local addonName = select(1, ...)
local addon = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
addon.name = addonName
_G.WeeklyKnowledge = addon
