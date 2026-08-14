---@class WK_Addon
local addon = select(2, ...)

local name, title, notes = C_AddOns.GetAddOnInfo(select(1, ...))
addon.name = name
addon.title = title
addon.notes = notes
addon.version = C_AddOns.GetAddOnMetadata(name, "Version") or ""

addon.libs = addon.libs or {}
addon.libs.LibDataBroker = LibStub("LibDataBroker-1.1")
addon.libs.LibDBIcon = LibStub("LibDBIcon-1.0")
addon.libs.AceDB = LibStub("AceDB-3.0")
addon.libs.AceLocale = LibStub("AceLocale-3.0")
addon.libs.AceAddon = LibStub("AceAddon-3.0")
addon.libs.LiqUI = LibStub("LiqUI-1.0")

--@debug@
_G[addon.name] = addon
--@end-debug@
