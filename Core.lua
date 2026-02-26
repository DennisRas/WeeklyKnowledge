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

_G.WeeklyKnowledge = addon

function Core:Render()
  Main:Render()
  Checklist:Render()
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
  self:RegisterChatCommand("wk", function() Main:ToggleWindow() end)
  self:RegisterChatCommand("weeklyknowledge", function() Main:ToggleWindow() end)

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
      Data:ClearWeeklyProgress()
      Data:ScanCharacter()
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
      Data:ClearWeeklyProgress()
      Data:ScanQuests()
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
    },
    3,
    function()
      Data:ClearWeeklyProgress()
      Data:ScanProfession()
      self:Render()
    end
  )
  self:RegisterBucketEvent(
    {
      "CALENDAR_UPDATE_EVENT_LIST",
    },
    1,
    function()
      Data:ClearWeeklyProgress()
      Data:ScanCalendar()
      self:Render()
    end)

  Data:ScanCharacter()
  self:Render()
end

function Core:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end
