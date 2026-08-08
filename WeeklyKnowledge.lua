---@class WK_Addon
local addon = select(2, ...)

local Data = addon.Data
local Constants = addon.Constants
local LibAceAddon = addon.libs.AceAddon
local LibDataBroker = addon.libs.LibDataBroker
local LibDBIcon = addon.libs.LibDBIcon
local LibLiqUI = addon.libs.LiqUI
local TableForEach = LibLiqUI.Utils.TableForEach

local Core = LibAceAddon:NewAddon(addon.name, "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
addon.Core = Core
addon.debug = false

--@debug@
addon.debug = false
--@end-debug@

function Core:Render()
  addon.Main:ApplyTableColumns()
  addon.Checklist:ApplyTableColumns()
  addon.Main:Render()
  addon.Checklist:Render()
end

function Core:HandleCommand(message)
  local cmd = self:GetArgs(message, 1)
  if not cmd then
    addon.Main:ToggleWindow()
    return
  end
  if cmd:lower() == "checklist" then
    addon.Checklist:ToggleWindow()
    return
  end
  if cmd:lower() == "minimap" then
    Data.db.global.minimap.hide = not Data.db.global.minimap.hide
    LibDBIcon:Refresh(addon.name, Data.db.global.minimap)
    self:Print("Minimap button " .. (Data.db.global.minimap.hide and "hidden" or "shown") .. ".")
    self:Render()
    return
  end
  if cmd:lower() == "toggle" then
    addon.Main:ToggleWindow()
    return
  end
  self:Print(format("Usage: /%s [checklist | minimap]", addon.name:lower()))
end

function Core:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE_MAIN"] = "Toggle WeeklyKnowledge window"
  _G["BINDING_NAME_WEEKLYKNOWLEDGE_CHECKLIST"] = "Toggle Checklist window"
  _G["WEEKLYKNOWLEDGE_TOGGLE_MAIN"] = function()
    if addon and addon.Main then addon.Main:ToggleWindow() end
  end
  _G["WEEKLYKNOWLEDGE_TOGGLE_CHECKLIST"] = function()
    if addon and addon.Checklist then addon.Checklist:ToggleWindow() end
  end
  self:RegisterChatCommand(addon.name:lower(), "HandleCommand")
  TableForEach(Constants.commands, function(command)
    self:RegisterChatCommand(command, "HandleCommand")
  end)

  Data:InitDB()
  Data:MigrateDB()
  LibLiqUI.Constants.layout.media.iconSettings = "Interface/AddOns/WeeklyKnowledge/Media/Icon_Settings.blp"
  LibLiqUI.Constants.layout.media.iconClose = "Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp"
  if Data:TaskWeeklyReset() then
    self:Print("Weekly Reset: Good job! Progress of your characters have been reset for a new week.")
  end

  local WKLDB = LibDataBroker:NewDataObject(addon.name, {
    label = addon.title,
    type = "launcher",
    icon = "Interface/AddOns/WeeklyKnowledge/Media/Icon.blp",
    OnClick = function(...)
      local _, b = ...
      if b and b == "RightButton" then
        addon.Checklist:ToggleWindow()
      else
        addon.Main:ToggleWindow()
      end
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText(addon.title, 1, 1, 1)
      tooltip:AddLine("|cff00ff00Left click|r to open " .. addon.title .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      tooltip:AddLine("|cff00ff00Right click|r to open the Checklist.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = "|cff00ff00Drag|r to move this icon"
      if Data.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end,
  })
  LibDBIcon:Register(addon.name, WKLDB, Data.db.global.minimap)
  LibDBIcon:AddButtonToCompartment(addon.name)

  self:Render()
end

function Core:OnEnable()
  self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
    Data.cache.inCombat = true
    self:Render()
  end)
  self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    Data.cache.inCombat = false
    self:Render()
  end)
  self:RegisterBucketEvent(
    {
      "PLAYER_LEVEL_CHANGED",
    },
    3,
    function()
      Data:ClearProgressCache()
      Data:ScanAll()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    {
      "BAG_UPDATE_DELAYED",
    },
    2,
    function()
      Data:ClearProgressCache()
      Data:ScanItems()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    {
      "QUEST_COMPLETE",
      "QUEST_LOG_UPDATE",
      "QUEST_TURNED_IN",
    },
    3,
    function()
      Data:ClearProgressCache()
      Data:ScanQuests()
      Data:ScanCurrencies()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    {
      "NEW_RECIPE_LEARNED",
      "SKILL_LINES_CHANGED",
      "TRADE_SKILL_DATA_SOURCE_CHANGED",
      "TRADE_SKILL_DETAILS_UPDATE",
      "TRADE_SKILL_LIST_UPDATE",
      "TRADE_SKILL_SHOW",
      "TRAIT_CONFIG_UPDATED",
      "TRAIT_TREE_CURRENCY_INFO_UPDATED",
    },
    1,
    function()
      Data:ClearProgressCache()
      Data:ScanAll()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    {
      "CALENDAR_UPDATE_EVENT_LIST",
    },
    1,
    function()
      Data:ClearProgressCache()
      Data:ScanCalendar()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    {
      "CURRENCY_DISPLAY_UPDATE",
    },
    1,
    function()
      Data:ClearProgressCache()
      Data:ScanCurrencies()
      self:Render()
    end
  )

  Data:ScanAll()
  self:Render()
end

function Core:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end
