-- Usage: lua Debug/Tests/Localization.lua <addon directory> <libraries directory> <locale>
local root, libraries, locale = assert(arg[1]), assert(arg[2]), arg[3] or "zhCN"
local function read(path)
  local file = assert(io.open(path, "r"))
  local text = file:read("*a")
  file:close()
  return text
end
local toc = read(root .. "/WeeklyKnowledge.toc")
local position = 0
for _, entry in ipairs({ "Libs\\AceLocale-3.0\\AceLocale-3.0.xml", "Boot.lua", "Locales\\enUS.lua", "Locales\\zhCN.lua", "Locales\\Init.lua", "Data.lua", "Modules\\Main\\Module.lua" }) do
  local found = assert(toc:find(entry, position + 1, true), "TOC missing or out of order: " .. entry)
  position = found
end
GetLocale = function() return locale end
strmatch = string.match
geterrorhandler = function() return function(message) error(message) end end
dofile(libraries .. "/LibStub/LibStub.lua")
dofile(libraries .. "/AceLocale-3.0/AceLocale-3.0.lua")
for _, name in ipairs({ "LibDataBroker-1.1", "LibDBIcon-1.0", "AceDB-3.0", "AceAddon-3.0", "LiqUI-1.0" }) do
  LibStub:NewLibrary(name, 1)
end
C_AddOns = { GetAddOnInfo = function() return "WeeklyKnowledge", "WeeklyKnowledge", "" end,
  GetAddOnMetadata = function() return "test" end }
local addon = {}
for _, path in ipairs({ "Boot.lua", "Locales/enUS.lua", "Locales/zhCN.lua", "Locales/Init.lua" }) do
  assert(loadfile(root .. "/" .. path))("WeeklyKnowledge", addon)
end
assert(addon.L, "addon.L was not initialized")
local expected = locale == "zhCN" and "角色" or "Characters"
assert(addon.L.TITLEBAR_CHARACTERS == expected, "wrong locale selection")
local keys = {}
for key in read(root .. "/Locales/enUS.lua"):gmatch('L%["([^"]+)"%] =') do keys[key] = true end
for _, path in ipairs({ "Data.lua", "Data/ObjectiveCategories.lua", "Modules/Main/Module.lua", "Modules/Main/TableColumns.lua", "Modules/Checklist/Module.lua", "Modules/Checklist/TableColumns.lua" }) do
  for key in read(root .. "/" .. path):gmatch('L%["([^"]+)"%]') do
    assert(keys[key], path .. " references an undefined locale key: " .. key)
  end
end
print("PASS: locale loading order, initialization, keys and fallback (" .. locale .. ")")
