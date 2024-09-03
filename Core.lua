---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge
local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

function WK:Render()
  self:RenderMain()
  self:RenderChecklist()
end

function WK:OnInitialize()
  _G["BINDING_NAME_WEEKLYKNOWLEDGE"] = "Show/Hide the window"
  self:RegisterChatCommand("wk", self.ToggleMainWindow)
  self:RegisterChatCommand("weeklyknowledge", self.ToggleMainWindow)

  self:InitDB()
  self:MigrateDB()

  local libDataObject = {
    label = addonName,
    tocname = addonName,
    type = "launcher",
    icon = "Interface/AddOns/WeeklyKnowledge/Media/Icon.blp",
    OnClick = function()
      self:ToggleMainWindow()
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText(addonName, 1, 1, 1)
      tooltip:AddLine("Click to open WeeklyKnowledge", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
      local dragText = "Drag to move this icon"
      if self.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
  }

  LibDataBroker:NewDataObject(addonName, libDataObject)
  LibDBIcon:Register(addonName, libDataObject, self.db.global.minimap)
  LibDBIcon:AddButtonToCompartment(addonName)

  self:Render()
end

function WK:OnEnable()
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
      self:ScanCharacter()
      self:Render()
    end
  )

  self:RegisterBucketEvent({"CALENDAR_UPDATE_EVENT_LIST",}, 1, function()
    self:ScanCalendar()
    self:Render()
  end)
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  C_Calendar.SetAbsMonth(currentCalendarTime.month, currentCalendarTime.year)
  C_Calendar.OpenCalendar()

  self:ScanCharacter()
  self:Render()
end

function WK:OnDisable()
  self:UnregisterAllEvents()
  self:UnregisterAllBuckets()
end
