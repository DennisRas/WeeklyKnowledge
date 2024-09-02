---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

local Data = addon.Data
local UI = addon.UI

--@debug@
_G.WK = addon
--@end-debug@

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

local Core = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
addon.Core = Core

function Core:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE"] = "Show/Hide the window"
  self:RegisterChatCommand("wk", UI.ToggleWindow)
  self:RegisterChatCommand("weeklyknowledge", UI.ToggleWindow)
  Data:InitDB()
  Data:MigrateDB()

  local libDataObject = {
    label = addonName,
    tocname = addonName,
    type = "launcher",
    icon = "Interface/AddOns/WeeklyKnowledge/Media/Icon.blp",
    OnClick = function()
      UI:ToggleWindow()
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText(addonName, 1, 1, 1)
      tooltip:AddLine("Click to open WeeklyKnowledge", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = "Drag to move this icon"
      if Data.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
  }

  LibDataBroker:NewDataObject(addonName, libDataObject)
  LibDBIcon:Register(addonName, libDataObject, Data.db.global.minimap)
  LibDBIcon:AddButtonToCompartment(addonName)
end

function Core:OnEnable()
  local localizedRaceName, englishRaceName, raceID = UnitRace("player")
  local localizedClassName, classFile, classID = UnitClass("player")
  local englishFactionName, localizedFactionName = UnitFactionGroup("player")
  Data.cache.GUID = UnitGUID("player")
  Data.cache.name = UnitName("player")
  Data.cache.realmName = GetRealmName()
  Data.cache.level = UnitLevel("player")
  Data.cache.raceID = raceID
  Data.cache.raceEnglish = englishRaceName
  Data.cache.raceName = localizedRaceName
  Data.cache.classID = classID
  Data.cache.classFile = classFile
  Data.cache.className = localizedClassName
  Data.cache.factionEnglish = englishFactionName
  Data.cache.factionName = localizedFactionName

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
      Data:ScanCharacter()
      UI:Render()
    end
  )

  self:RegisterBucketEvent({"CALENDAR_UPDATE_EVENT_LIST",}, 1, function()
    Data:ScanCalendar()
    UI:Render()
  end)
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  C_Calendar.SetAbsMonth(currentCalendarTime.month, currentCalendarTime.year)
  C_Calendar.OpenCalendar()

  Data:ScanCharacter()
  UI:Render()
end

function Core:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end
