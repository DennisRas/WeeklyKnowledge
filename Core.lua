local WP = LibStub("AceAddon-3.0"):NewAddon("WeeklyProfessions", "AceConsole-3.0", "AceTimer-3.0", "AceEvent-3.0", "AceBucket-3.0")
WP.Libs = {}
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

local DARKMOON_EVENT_ID = 479
local ROW_HEIGHT = 20
local WINDOW_PADDING = 20

local function CheckDarkmoonOpen()
  local date = C_DateAndTime.GetCurrentCalendarTime()
  if date and date.monthDay then
    local today = date.monthDay
    local numEvents = C_Calendar.GetNumDayEvents(0, today)
    if numEvents then
      for i = 1, numEvents do
        local event = C_Calendar.GetDayEvent(0, today, i)
        if event and event.id == DARKMOON_EVENT_ID then
          return true
        end
      end
    end
  end
  return false
end

local tasks = {
  "Mettle",
  "Trainer",
  "Collect",
  "Work Order",
  "Drops",
  "Treasures",
  "Treatise",
  "Curios",
  "Darkmoon"
}

local professions = {
  [171] = {
    name = "Alchemy",
    variantID = 2823,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70530, 70531, 70532, 70533}},
      {limit = 1, quests = {77932, 77933, 75371, 66937, 66938, 66940, 72427, 75363}},
      {limit = 0, quests = {}},
      {limit = 2, quests = {70511, 70504}},
      {limit = 2, quests = {66373, 66374}},
      {limit = 1, quests = {74108}},
      {limit = 1, quests = {74935}},
      {limit = 1, quests = {29506},                                                 darkmoon = true},
    }
  },
  [164] = {
    name = "Blacksmithing",
    variantID = 2822,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70233, 70234, 70235, 70211}},
      {limit = 1, quests = {66517, 66897, 66941, 72398, 75569, 75148, 77935, 77936}},
      {limit = 1, quests = {70589}},
      {limit = 2, quests = {70513, 70512}},
      {limit = 2, quests = {66381, 66382}},
      {limit = 1, quests = {74109}},
      {limit = 1, quests = {74931}},
      {limit = 1, quests = {29508},                                                 darkmoon = true},
    }
  },
  [333] = {
    name = "Enchanting",
    variantID = 2825,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {72172, 72173, 72155, 72175}},
      {limit = 1, quests = {66884, 66900, 66935, 72423, 75865, 75150, 77910, 77937}},
      {limit = 0, quests = {}},
      {limit = 2, quests = {70515, 70514}},
      {limit = 2, quests = {66377, 66378}},
      {limit = 1, quests = {74110}},
      {limit = 1, quests = {74927}},
      {limit = 1, quests = {29510},                                                 darkmoon = true},
    }
  },
  [202] = {
    name = "Engineering",
    variantID = 2827,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70540, 70539, 70545, 70557}},
      {limit = 1, quests = {66890, 66891, 66942, 72396, 75575, 75608, 77891, 77938}},
      {limit = 1, quests = {70591}},
      {limit = 2, quests = {70517, 70516}},
      {limit = 2, quests = {66379, 66380}},
      {limit = 1, quests = {74111}},
      {limit = 1, quests = {74934}},
      {limit = 1, quests = {29511},                                                 darkmoon = true},
    }
  },
  [182] = {
    name = "Herbalism",
    variantID = 2832,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70613, 70614, 70615, 70616}},
      {limit = 0, quests = {}},
      {limit = 0, quests = {}},
      {limit = 6, quests = {71857, 71858, 71859, 71860, 71861, 71864}},
      {limit = 0, quests = {}},
      {limit = 1, quests = {74107}},
      {limit = 1, quests = {74933}},
      {limit = 1, quests = {29514},                                   darkmoon = true},
    }
  },
  [773] = {
    name = "Inscription",
    variantID = 2828,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70558, 70559, 70560, 70561}},
      {limit = 1, quests = {66943, 66944, 66945, 72438, 75573, 75149, 77889, 77914}},
      {limit = 1, quests = {70592}},
      {limit = 2, quests = {70519, 70518}},
      {limit = 2, quests = {66375, 66376}},
      {limit = 1, quests = {74105}},
      {limit = 1, quests = {74932}},
      {limit = 1, quests = {29515},                                                 darkmoon = true},
    }
  },
  [755] = {
    name = "Jewelcrafting",
    variantID = 2829,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70562, 70563, 70564, 70565}},
      {limit = 1, quests = {66516, 66949, 66950, 72428, 75362, 75602, 77912, 77892}},
      {limit = 1, quests = {70593}},
      {limit = 2, quests = {70521, 70520}},
      {limit = 2, quests = {66388, 66389}},
      {limit = 1, quests = {74112}},
      {limit = 1, quests = {74936}},
      {limit = 1, quests = {29516},                                                 darkmoon = true},
    }
  },
  [165] = {
    name = "Leatherworking",
    variantID = 2830,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70567, 70568, 70569, 70571}},
      {limit = 1, quests = {66363, 66364, 66951, 72407, 75354, 75368, 77945, 77946}},
      {limit = 1, quests = {70594}},
      {limit = 2, quests = {70523, 70522}},
      {limit = 2, quests = {66384, 66385}},
      {limit = 1, quests = {74113}},
      {limit = 1, quests = {74928}},
      {limit = 1, quests = {29517},                                                 darkmoon = true},
    }
  },
  [186] = {
    name = "Mining",
    variantID = 2833,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70617, 70618, 72156, 72157}},
      {limit = 0, quests = {}},
      {limit = 0, quests = {}},
      {limit = 6, quests = {72160, 72161, 72162, 72163, 72164, 72165}},
      {limit = 0, quests = {}},
      {limit = 1, quests = {74106}},
      {limit = 1, quests = {74926}},
      {limit = 1, quests = {29518},                                   darkmoon = true},
    }
  },
  [393] = {
    name = "Skinning",
    variantID = 2834,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70619, 70620, 72158, 72159}},
      {limit = 0, quests = {}},
      {limit = 0, quests = {}},
      {limit = 6, quests = {70381, 70383, 70384, 70385, 70386, 70389}},
      {limit = 0, quests = {}},
      {limit = 1, quests = {74114}},
      {limit = 1, quests = {74930}},
      {limit = 1, quests = {29519},                                   darkmoon = true},
    }
  },
  [197] = {
    name = "Tailoring",
    variantID = 2831,
    tasks = {
      {limit = 1, quests = {70221}},
      {limit = 1, quests = {70586, 70587, 70572, 70582}},
      {limit = 1, quests = {66899, 66952, 66953, 72410, 75407, 75600, 77947, 77949}},
      {limit = 1, quests = {70595}},
      {limit = 2, quests = {70524, 70525}},
      {limit = 2, quests = {66386, 66387}},
      {limit = 1, quests = {74115}},
      {limit = 1, quests = {74929}},
      {limit = 1, quests = {29520},                                                 darkmoon = true},
    }
  },
}

function WP:OnInitialize()
  self.db = self.Libs.AceDB:New("WeeklyProfessionsDB", defaultDB, true)
  local libDataObject = {
    label = "WeeklyProfessions",
    tocname = "WeeklyProfessions",
    type = "launcher",
    icon = "Interface/AddOns/WeeklyProfessions/Icon.blp",
    OnClick = function()
      self:ToggleWindow()
    end,
    OnTooltipShow = function(tooltip)
      tooltip:SetText("WeeklyProfessions", 1, 1, 1)
      tooltip:AddLine("Click to open WeeklyProfessions", NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
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
  self:RegisterEvent("TRAIT_CONFIG_UPDATED", "Run")
  self:Run()
end

local frame, st
function WP:ToggleWindow()
  if not frame then
    frame = CreateFrame("Frame", "WeeklyProfessionsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(1000, 500)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(8000)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetPoint("CENTER")
    frame:SetUserPlaced(true)
    frame:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    frame:SetBackdropColor(0, 0, 0, 0.95)
    frame:SetBackdropBorderColor(0, 0, 0, .5)
    frame:RegisterForDrag("LeftButton")
    frame:EnableMouse(true)
    frame:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame:Hide()
    frame.title = CreateFrame("Frame", "$parentTitle", frame, "BackdropTemplate")
    frame.title:SetPoint("BOTTOM", frame, "TOP", 0, -8)
    frame.title:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    frame.title:SetBackdropColor(0, 0, 0, 1)
    frame.title:SetBackdropBorderColor(0, 0, 0, .5)
    frame.title:SetSize(150, 30)
    frame.title:RegisterForDrag("LeftButton")
    frame.title:EnableMouse(true)
    frame.title:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame.title:SetScript("OnDragStop", function() frame:StopMovingOrSizing() end)
    frame.title.text = frame.title:CreateFontString("$parentText", "OVERLAY")
    frame.title.text:SetFontObject("GameFontHighlight_NoShadow")
    frame.title.text:SetAllPoints()
    frame.title.text:SetJustifyH("CENTER")
    frame.title.text:SetJustifyV("CENTER")
    frame.title.text:SetText("WeeklyProfessions")
    frame.closeButton = CreateFrame("Button", "$parentCloseButton", frame)
    frame.closeButton:SetSize(32, 32)
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
    frame.closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
    frame.closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
    frame.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
  end

  if not st then
    st = self.Libs.ST:CreateST(
      {},
      nil,
      ROW_HEIGHT,
      nil,
      frame
    )
    st:SetDefaultHighlight(1, 1, 1, 0.075)
    st.frame:SetBackdrop(nil)
    st.frame:SetBackdropColor(0, 0, 0, 0)
    st.frame:SetBackdropBorderColor(0, 0, 0, 0)
    local ScrollTroughBorder = _G[st.frame:GetName() .. "ScrollTroughBorder"]
    if ScrollTroughBorder then
      ScrollTroughBorder.background:Hide()
    end
  end

  if frame:IsVisible() then
    frame:Hide()
  else
    frame:Show()
    self:Run()
  end
end

function WP:Run()
  local _, playerClassFile, playerClassID = UnitClass("player")
  local character = {
    name = UnitName("player"),
    realm = GetRealmName(),
    class = playerClassID,
    color = C_ClassColor.GetClassColor(playerClassFile):GenerateHexColor(),
    professions = {},
    completed = {}
  }

  -- Profession Tree tracking
  local prof1, prof2 = GetProfessions()
  for _, playerProfessionID in pairs({prof1, prof2}) do
    local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(playerProfessionID)
    if skillLine then
      local profession = {
        id = skillLine,
        level = skillLevel,
        maxLevel = maxSkillLevel,
        knowledgeLevel = 0,
        knowledgeMaxLevel = 0
      }
      local configID = C_ProfSpecs.GetConfigIDForSkillLine(professions[skillLine].variantID)
      if configID then
        local configInfo = C_Traits.GetConfigInfo(configID)
        if configInfo then
          local treeIDs = configInfo.treeIDs
          if treeIDs then
            for _, treeID in pairs(treeIDs) do
              local treeNodes = C_Traits.GetTreeNodes(treeID)
              if treeNodes then
                for _, treeNode in pairs(treeNodes) do
                  local nodeInfo = C_Traits.GetNodeInfo(configID, treeNode)
                  if nodeInfo then
                    profession.knowledgeLevel = nodeInfo.ranksPurchased > 1 and profession.knowledgeLevel + (nodeInfo.currentRank - 1) or profession.knowledgeLevel
                    profession.knowledgeMaxLevel = profession.knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
                  end
                end
              end
            end
          end
        end
      end

      table.insert(character.professions, profession)
    end
  end

  -- Quest tracking
  for _, profession in pairs(professions) do
    if profession.tasks then
      for _, task in pairs(profession.tasks) do
        if task.quests then
          for _, questID in pairs(task.quests) do
            if C_QuestLog.IsQuestFlaggedCompleted(questID) then
              character.completed[questID] = true
            end
          end
        end
      end
    end
  end

  self.db.global.characters[UnitGUID("player")] = character

  -- Build table data
  local rows = {}
  local cols = {
    {
      name = "Name",
      width = 80
    },
    {
      name = "Profession",
      width = 80
    },
    {
      name = "Skill",
      width = 80,
      align = "CENTER"
    },
    {
      name = "Knowledge",
      width = 80,
      align = "CENTER"
    },
  }

  -- Header row
  for _, task in ipairs(tasks) do
    table.insert(cols, {
      name = task,
      width = 70,
      align = "CENTER"
    })
  end

  local isDarkmoonOpen = CheckDarkmoonOpen()

  -- Data rows
  for _, player in pairs(self.db.global.characters) do
    local playerName = player.name
    if player.color then
      playerName = WrapTextInColorCode(playerName, player.color)
    end
    for _, playerProfession in pairs(player.professions) do
      local profession = professions[playerProfession.id]
      if profession then
        local row = {
          playerName,
          profession.name,
          playerProfession.level > 0 and playerProfession.level == playerProfession.maxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(playerProfession.level .. " / " .. playerProfession.maxLevel) or playerProfession.level .. " / " .. playerProfession.maxLevel,
        }
        if playerProfession.knowledgeMaxLevel > 0 then
          table.insert(row, playerProfession.knowledgeLevel > 0 and playerProfession.knowledgeLevel == playerProfession.knowledgeMaxLevel and GREEN_FONT_COLOR:WrapTextInColorCode(playerProfession.knowledgeLevel .. " / " .. playerProfession.knowledgeMaxLevel) or playerProfession.knowledgeLevel .. " / " .. playerProfession.knowledgeMaxLevel)
          for taskIndex, task in pairs(tasks) do
            local completed = 0
            local limit = 0
            for professionTaskIndex, professionTask in pairs(profession.tasks) do
              if professionTaskIndex == taskIndex then
                if professionTask.darkmoon and not isDarkmoonOpen then
                  limit = 0
                else
                  if professionTask.quests then
                    for _, questID in pairs(professionTask.quests) do
                      if player.completed[questID] then
                        completed = completed + 1
                      end
                    end
                  end
                  limit = professionTask.limit
                end
              end
            end
            local result = completed .. " / " .. limit
            if limit == 0 then
              result = ""
            elseif completed == limit then
              result = GREEN_FONT_COLOR:WrapTextInColorCode(result)
            end
            table.insert(row, result)
          end
        else
          table.insert(row, "")
        end
        table.insert(rows, row)
      end
    end
  end

  if st then
    st:SetDisplayCols(cols)
    st:SetData(rows, true)
    st:Refresh()
    frame:SetWidth(st.frame:GetWidth() + WINDOW_PADDING)
    frame:SetHeight(st.frame:GetHeight() + ROW_HEIGHT + 5 + WINDOW_PADDING)
    st.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", WINDOW_PADDING / 2, -(WINDOW_PADDING / 2 + ROW_HEIGHT + 5))
  end
end
