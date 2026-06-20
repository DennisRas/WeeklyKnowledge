---@class WK_Addon
local addon = select(2, ...)

addon.libs = addon.libs or {}
addon.libs.LibDataBroker = LibStub("LibDataBroker-1.1")
addon.libs.LibDBIcon = LibStub("LibDBIcon-1.0")
addon.libs.AceDB = LibStub("AceDB-3.0")
addon.libs.AceAddon = LibStub("AceAddon-3.0")
addon.libs.LiqUI = LibStub("LiqUI-1.0")
