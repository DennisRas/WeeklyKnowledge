local WP = LibStub("AceAddon-3.0"):NewAddon("WeeklyProfessions", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
WP.Libs = {}
WP.Libs.AceGUI = LibStub("AceGUI-3.0")
WP.Libs.AceDB = LibStub:GetLibrary("AceDB-3.0")
WP.Libs.LDB = LibStub:GetLibrary("LibDataBroker-1.1")
WP.Libs.LDBIcon = LibStub("LibDBIcon-1.0")
WP.Libs.ST = LibStub("ScrollingTable")

local defaultDB = {
  global = {
    minimap = {
      minimapPos = 235,
      hide = false,
      lock = false
    },
    characters = {}
  }
}

local professions = {
  [171] = "Alchemy",
  [164] = "Blacksmithing",
  [333] = "Enchanting",
  [202] = "Engineering",
  [182] = "Herbalism",
  [773] = "Inscription",
  [755] = "Jewelcrafting",
  [165] = "Leatherworking",
  [186] = "Mining",
  [393] = "Skinning",
  [197] = "Tailoring",
}

local tasks = {
  {name = "Artisan Mettle",   limit = 1, quests = {70221}},
  {name = "Gathering Quests", limit = 1, quests = {70613, 70614, 70615, 70616, 70617, 70618, 72156, 72157, 70619, 70620, 72158, 72159}},
  {
    name = "Profession Quests",
    limit = 2,
    quests = {
      66937, 66938, 66940, 70530, 70531, 70532, 72427, 75363, 75371, 70533, 77932, 77933,
      66517, 66897, 66941, 70211, 70233, 70234, 70235, 72398, 75569, 75148, 77935, 77936,
      66884, 66900, 66935, 72155, 72172, 72173, 72175, 72423, 75865, 75150, 77910, 77937,
      66890, 66891, 66942, 70540, 70539, 70545, 70557, 72396, 75575, 75608, 77891, 77938,
      66943, 66944, 66945, 70558, 70559, 70560, 70561, 72438, 75573, 75149, 77889, 77914,
      66516, 66949, 66950, 70562, 70563, 70564, 70565, 72428, 75362, 75602, 77912, 77892,
      66363, 66364, 66951, 70567, 70568, 70569, 70571, 72407, 75354, 75368, 77945, 77946,
      66899, 66952, 66953, 70572, 70582, 70586, 70587, 72410, 75407, 75600, 77947, 77949
    }
  },
}

function WP:OnInitialize()
  self.db = self.Libs.AceDB:New("WeeklyProfessionsDB", defaultDB, true)
  local libDataObject = {
    label = "WeeklyProfessions",
    tocname = "WeeklyProfessions",
    type = "launcher",
    icon = "Interface/AddOns/Icon.blp",
    OnClick = function()
      self:ToggleWindow()
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText("WeeklyProfessions", 1, 1, 1)
      tooltip:AddLine("Click to show the character summary.", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g,
                      NORMAL_FONT_COLOR.b)
      local dragText = "Drag to move this icon"
      if self.db.global.minimap.lock then
        dragText = dragText .. " |cffff0000(locked)|r"
      end
      tooltip:AddLine(dragText .. ".", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
    end
  }
  self.Libs.LDB:NewDataObject("WeeklyProfessions", libDataObject)
  self.Libs.LDBIcon:Register("WeeklyProfessions", libDataObject, self.db.global.minimap)
  self.Libs.LDBIcon:AddButtonToCompartment("WeeklyProfessions")
end

function WP:OnEnable()
  self:RegisterEvent("CHAT_MSG_LOOT", "Run")
  self:RegisterEvent("BAG_UPDATE", "Run")
  self:RegisterEvent("QUEST_COMPLETE", "Run")
  self:RegisterEvent("QUEST_TURNED_IN", "Run")
  self:RegisterEvent("UNIT_INVENTORY_CHANGED", "Run")
  self:RegisterEvent("ITEM_COUNT_CHANGED", "Run")
  self:RegisterEvent("BAG_UPDATE", "Run")
  self:Run()
end

local frame, st
function WP:ToggleWindow()
  if not frame then
    frame = CreateFrame("Frame", "WeeklyProfessionsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(500, 500)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(8000)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetPoint("CENTER")
    frame:SetUserPlaced(true)
    frame:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    frame:SetBackdropColor(0, 0, 0, 0.8)
    frame:SetBackdropBorderColor(0, 0, 0, .5)
    frame:RegisterForDrag("LeftButton")
    frame:EnableMouse(true)
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    -- frame = WP.Libs.AceGUI:Create("Frame")
    -- frame:SetTitle("Example Frame")
    -- frame:SetStatusText("AceGUI-3.0 Example Container Frame")
    frame:Hide()
  end

  if not st then
    st = self.Libs.ST:CreateST(
      {

      },
      nil,
      20,
      nil,
      frame
    )
  end

  if frame:IsVisible() then
    frame:Hide()
  else
    frame:Show()
    self:Run()
  end
end

function WP:Run()
  local character = {
    name = UnitName("player"),
    realm = GetRealmName(),
    professions = {},
    completed = {}
  }
  local prof1, prof2 = GetProfessions()
  if prof1 then
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
    if skillLine then
      table.insert(character.professions, skillLine)
    end
  end
  if prof2 then
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof2)
    if skillLine then
      table.insert(character.professions, skillLine)
    end
  end

  for index, task in ipairs(tasks) do
    for questIndex, questID in ipairs(task.quests) do
      if C_QuestLog.IsQuestFlaggedCompleted(questID) then
        character.completed[questID] = true
        -- table.insert(character.completed, questID)
      end
    end
  end

  self.db.global.characters[UnitGUID("player")] = character

  local data = {}
  local cols = {
    {
      name = "Task",
      width = 200
    },
  }

  for playerGUID, player in pairs(self.db.global.characters) do
    table.insert(cols, {
      name = player.name,
      width = 100
    })
  end

  for taskIndex, task in ipairs(tasks) do
    local row = {task.name}
    for playerGUID, player in pairs(self.db.global.characters) do
      local completed = 0
      for questIndex, questID in ipairs(task.quests) do
        if player.completed[questID] then
          completed = completed + 1
        end
      end
      table.insert(row, completed .. " / " .. task.limit)
    end
    table.insert(data, row)
  end

  if st then
    st:SetDisplayCols(cols)
    st:SetData(data, true)
    st:Refresh()
  end
end
