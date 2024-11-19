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
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

_G.WeeklyKnowledge = addon

function Core:Render()
  Main:Render()
  Checklist:Render()
end

function Core:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE"] = "Show/Hide the window"
  self:RegisterChatCommand("wk", function() Main:ToggleWindow() end)
  self:RegisterChatCommand("weeklyknowledge", function() Main:ToggleWindow() end)

  Data:InitDB()
  Data:MigrateDB()
  if Data:TaskWeeklyReset() then
    self:Print(L["WeeklyReset"])
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
      tooltip:AddLine(L["TooltipLine1"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      tooltip:AddLine(L["TooltipLine2"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = L["TooltipLine3"]
      if Data.db.global.minimap.lock then
        dragText = dragText .. L["TooltipLocked"]
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
      "ACTIVE_TALENT_GROUP_CHANGED",
      "BAG_UPDATE_DELAYED",
      "CHAT_MSG_LOOT",
      "ITEM_COUNT_CHANGED",
      "PLAYER_SPECIALIZATION_CHANGED",
      "PLAYER_TALENT_UPDATE",
      "QUEST_COMPLETE",
      "QUEST_TURNED_IN",
      "SKILL_LINES_CHANGED",
      "TRAIT_CONFIG_UPDATED",
      "UNIT_INVENTORY_CHANGED",
    },
    3,
    function()
      Data.cache.weeklyProgress = {}
      Data:ScanCharacter()
      self:Render()
    end
  )

  self:RegisterBucketEvent({"CALENDAR_UPDATE_EVENT_LIST",}, 1, function()
    Data.cache.weeklyProgress = {}
    Data:ScanCalendar()
    self:Render()
  end)
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  C_Calendar.SetAbsMonth(currentCalendarTime.month, currentCalendarTime.year)
  C_Calendar.OpenCalendar()

  Data:ScanCharacter()
  self:Render()
end

function Core:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end
