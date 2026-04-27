---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

local Data = addon.Data
local Main = addon.Main
local Checklist = addon.Checklist
local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

local Core = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
addon.Core = Core
addon.debug = false

_G[addonName] = addon

--@debug@
addon.debug = false
--@end-debug@

function Core:Render()
  Main:Render()
  Checklist:Render()
end

function Core:HandleCommand(message)
  local cmd = self:GetArgs(message, 1)
  if not cmd then
    Main:ToggleWindow()
    return
  end
  if cmd:lower() == "checklist" then
    Checklist:ToggleWindow()
    return
  end
  if cmd:lower() == "minimap" then
    Data.db.global.minimap.hide = not Data.db.global.minimap.hide
    LibDBIcon:Refresh(addonName, Data.db.global.minimap)
    self:Print("Minimap button " .. (Data.db.global.minimap.hide and "hidden" or "shown") .. ".")
    self:Render()
    return
  end
  if cmd:lower() == "toggle" then
    Main:ToggleWindow()
    return
  end
  self:Print("Usage: /wk [checklist | minimap]")
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
  self:RegisterChatCommand("wk", "HandleCommand")
  self:RegisterChatCommand("weeklyknowledge", "HandleCommand")

  Data:InitDB()
  Data:MigrateDB()
  if Data:TaskWeeklyReset() then
    self:Print("Weekly Reset: Good job! Progress of your characters have been reset for a new week.")
  end

  local WKLDB = LibDataBroker:NewDataObject(addonName, {
    label = addonName,
    type = "launcher",
    icon = "Interface/AddOns/WeeklyKnowledge/Media/Icon.blp",
    OnClick = function(...)
      local _, b = ...
      if b and b == "RightButton" then
        Checklist:ToggleWindow()
      else
        Main:ToggleWindow()
      end
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText(addonName, 1, 1, 1)
      tooltip:AddLine("|cff00ff00Left click|r to open WeeklyKnowledge.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      tooltip:AddLine("|cff00ff00Right click|r to open the Checklist.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = "|cff00ff00Drag|r to move this icon"
      if Data.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
  })
  LibDBIcon:Register(addonName, WKLDB, Data.db.global.minimap)
  LibDBIcon:AddButtonToCompartment(addonName)

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
      "PLAYER_LEVEL_CHANGED"
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
  self:RegisterBucketEvent(
    { "PROFESSION_EQUIPMENT_CHANGED" },
    2,
    function()
      -- Note: ClearProgressCache() is intentionally omitted -- profGearScore
      -- is not stored in progressCache, so clearing it would be a no-op here.
      Data:ScanProfessionEquipment()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    { "GET_ITEM_INFO_RECEIVED" },
    1,
    function()
      if Data:NeedsProfessionEquipmentRescan() then
        Data:ScanProfessionEquipment()
        self:Render()
      end
    end
  )

  Data:ScanAll()
  self:Render()
end

function Core:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end
