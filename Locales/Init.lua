---@class WK_Addon
local addon = select(2, ...)

addon.L = addon.libs.AceLocale:GetLocale(addon.name)
