---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = {}
addon.Data = Data

local Utils = addon.Utils
local AceDB = LibStub("AceDB-3.0")

---True when chat messaging lockdown is active (C_ChatInfo.InChatMessagingLockdown). Calendar/ChatInfo APIs may return secrets; skip scan/update.
function Data:IsInChatMessagingLockdown()
  return C_ChatInfo and C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown()
end

---@type WK_DataCache
Data.cache = {
  calendarOpened = false,
  isDarkmoonOpen = false,
  inCombat = false,
  items = {},
  mapInfo = {},
  weeklyProgress = {},
  completedQuests = {},
  tradeSkillRecipes = {},
}

Data.DBVersion = 16
Data.defaultDB = {
  ---@type WK_DefaultGlobal
  global = {
    minimap = {
      minimapPos = 235,
      hide = false,
      lock = false
    },
    characters = {},
    showFullProfessionName = true,
    main = {
      selectedExpansion = nil,
      hiddenColumns = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      checklistHelpTipClosed = false,
      hideLowLevelProfessions = false,
    },
    checklist = {
      selectedExpansion = nil,
      open = false,
      hiddenColumns = {},
      hiddenCategories = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      windowTitlebar = true,
      hideCompletedObjectives = false,
      hideInCombat = false,
      hideInDungeons = true,
      hideTable = false,
      hideTableHeader = false,
    },
  }
}

local MISSING_INFO = 999999999
Data.MISSING_INFO = MISSING_INFO

---@type WK_Character
Data.defaultCharacter = {
  lastUpdate = 0,
  GUID = "",
  name = "",
  realmName = "",
  level = 0,
  factionEnglish = "",
  factionName = "",
  raceID = 0,
  raceEnglish = "",
  raceName = "",
  classID = 0,
  classFile = nil,
  className = "",
  professions = {},
  completed = {},
}

---@type WK_Objective[]
Data.Objectives = {}
---@type WK_ObjectiveCategory[]
Data.ObjectiveCategories = {}
---@type WK_SkillLineVariant[]
Data.SkillLineVariants = {}
---@type WK_SkillLine[]
Data.SkillLines = {}
---@type WK_Expansion[]
Data.Expansions = {}

function Data:InitDB()
  ---@class AceDBObject-3.0
  ---@field global WK_DefaultGlobal
  self.db = AceDB:New(
    "WeeklyKnowledgeDB",
    self.defaultDB,
    true
  )
end

function Data:MigrateDB()
  if type(self.db.global.DBVersion) ~= "number" then
    self.db.global.DBVersion = self.DBVersion
  end
  if self.db.global.DBVersion < self.DBVersion then
    -- Set up new character data structure
    if self.db.global.DBVersion == 1 then
      for characterGUID, character in pairs(self.db.global.characters) do
        character.GUID = characterGUID
        character.lastUpdate = 0
        character.enabled = true
        ---@diagnostic disable-next-line: undefined-field
        character.classID = character.class
        ---@diagnostic disable-next-line: undefined-field
        character.realmName = character.realm
        ---@diagnostic disable-next-line: inject-field
        character.color = nil

        local remove = true
        for _, characterProfession in pairs(character.professions) do
          ---@diagnostic disable-next-line: undefined-field
          if characterProfession.latestExpansion then
            remove = false
          end
        end
        if remove then
          self.db.global.characters[characterGUID] = nil
        end
      end
    end
    -- Fix missing weekly reset (week 2 of expansion)
    if self.db.global.DBVersion == 2 then
      if not self.db.global.weeklyReset then
        self.db.global.weeklyReset = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset() - 604800
      end
    end
    -- Fix race condition with WK.cache.GUID being empty
    -- Move to new window settings
    if self.db.global.DBVersion == 3 then
      self.db.global.characters[""] = nil
      if self.db.global.hiddenColumns and Utils:TableCount(self.db.global.hiddenColumns) > 0 then
        self.db.global.main.hiddenColumns = Utils:TableCopy(self.db.global.hiddenColumns)
        ---@diagnostic disable-next-line: inject-field
        self.db.global.hiddenColumns = nil
      end
      if self.db.global.windowScale then
        self.db.global.main.windowScale = self.db.global.windowScale
        self.db.global.checklist.windowScale = self.db.global.windowScale
        ---@diagnostic disable-next-line: inject-field
        self.db.global.windowScale = nil
      end
      if self.db.global.windowBackgroundColor then
        self.db.global.main.windowBackgroundColor = self.db.global.windowBackgroundColor
        self.db.global.checklist.windowBackgroundColor = self.db.global.windowBackgroundColor
        ---@diagnostic disable-next-line: inject-field
        self.db.global.windowBackgroundColor = nil
      end
    end
    -- Remove unused attributes and old/broken characters
    if self.db.global.DBVersion == 5 then
      for characterGUID, character in pairs(self.db.global.characters) do
        character.class = nil
        character.color = nil
        character.realm = nil
        if type(character.enabled) ~= "boolean" then
          character.enabled = true
        end
        if type(character.lastUpdate) ~= "number" then
          self.db.global.characters[characterGUID] = nil
        elseif type(character.classID) ~= "number" then
          self.db.global.characters[characterGUID] = nil
        elseif type(character.professions) ~= "table" then
          self.db.global.characters[characterGUID] = nil
        elseif #character.professions < 1 then
          self.db.global.characters[characterGUID] = nil
        end
      end
    end
    if self.db.global.DBVersion == 6 then
      for _, character in pairs(self.db.global.characters) do
        for _, characterProfession in pairs(character.professions) do
          characterProfession.enabled = true
        end
      end
    end
    -- Move enabled setting to saved professions only
    if self.db.global.DBVersion == 8 then
      for _, character in pairs(self.db.global.characters) do
        if character.enabled == false then
          for _, characterProfession in pairs(character.professions) do
            characterProfession.enabled = false
          end
        end
        character.enabled = nil
      end
    end
    -- Remove denormalized keys and rename levels to skillLevel
    if self.db.global.DBVersion == 10 then
      for _, character in pairs(self.db.global.characters) do
        if type(character.professions) == "table" then
          for _, characterProfession in pairs(character.professions) do
            characterProfession.skillLineID = nil
            characterProfession.name = nil
            if characterProfession.level ~= nil then
              characterProfession.skillLevel = characterProfession.level
              characterProfession.level = nil
            end
            if characterProfession.maxLevel ~= nil then
              characterProfession.skillMaxLevel = characterProfession.maxLevel
              characterProfession.maxLevel = nil
            end
          end
        end
      end
    end
    -- Fix professions without skillLine data. Look for the saved catchupCunrrecy or get rid of the profession if no catchup currency is found.
    if self.db.global.DBVersion == 11 then
      for _, character in pairs(self.db.global.characters) do
        if type(character.professions) == "table" then
          local professions = {}
          for _, characterProfession in pairs(character.professions) do
            local keep = true
            if not characterProfession.skillLineVariantID then
              local catchupCurrencyInfo = characterProfession.catchUpCurrencyInfo
              if catchupCurrencyInfo and catchupCurrencyInfo.currencyID then
                for _, skillLineVariant in pairs(self.SkillLineVariants) do
                  if skillLineVariant.catchUpCurrencyID == catchupCurrencyInfo.currencyID then
                    characterProfession.skillLineID = skillLineVariant.skillLineID
                    characterProfession.skillLineVariantID = skillLineVariant.id
                    break
                  end
                end
              else
                keep = false
              end
            end
            if keep then
              table.insert(professions, characterProfession)
            end
          end
          character.professions = professions
        end
      end
    end
    -- Migrate hidden categories
    if self.db.global.DBVersion == 13 then
      if not self.db.global.checklist.hiddenCategories then
        self.db.global.checklist.hiddenCategories = {}
      end
      if self.db.global.checklist.hideUniqueObjectives then
        self.db.global.checklist.hiddenCategories[Enum.WK_ObjectiveCategory.Unique] = true
        self.db.global.checklist.hideUniqueObjectives = nil
      end
      if self.db.global.checklist.hideUniqueVendorObjectives then
        self.db.global.checklist.hideUniqueVendorObjectives = nil
      end
      if self.db.global.checklist.hideCatchUpObjectives then
        self.db.global.checklist.hiddenCategories[Enum.WK_ObjectiveCategory.CatchUp] = true
        self.db.global.checklist.hideCatchUpObjectives = nil
      end
    end
    self.db.global.DBVersion = self.db.global.DBVersion + 1
    self:MigrateDB()
  end
end

---Clear quest progress after a weekly reset
---@return boolean
function Data:TaskWeeklyReset()
  local hasReset = false
  if type(self.db.global.weeklyReset) == "number" and self.db.global.weeklyReset <= GetServerTime() then
    local questsToReset = {}
    Utils:TableForEach(self.Objectives, function(objective)
      local objectiveCategory = self:GetObjectiveCategoryByID(objective.categoryID)
      if not objectiveCategory or objectiveCategory.repeatable ~= "Weekly" then return end
      Utils:TableForEach(objective.quests, function(questID)
        questsToReset[questID] = true
      end)
    end)
    for _, character in pairs(self.db.global.characters) do
      if type(character.lastUpdate) == "number" and character.lastUpdate <= self.db.global.weeklyReset and type(character.completed) == "table" then
        for questID in pairs(character.completed) do
          if questsToReset[questID] then
            character.completed[questID] = nil
            hasReset = true
          end
        end
      end
    end
  end
  self.db.global.weeklyReset = GetServerTime() + C_DateAndTime.GetSecondsUntilWeeklyReset()
  return hasReset
end

---Clear the weekly progress cache.
function Data:ClearWeeklyProgress()
  if type(self.cache.weeklyProgress) == "table" then
    self.cache.weeklyProgress = {}
  end
end

---Get stored character by GUID
---@param GUID WOWGUID?
---@return WK_Character|nil
function Data:GetCharacter(GUID)
  if GUID == nil then
    GUID = UnitGUID("player")
  end

  if GUID == nil then
    return nil
  end

  if self.db.global.characters[GUID] == nil then
    self.db.global.characters[GUID] = Utils:TableCopy(self.defaultCharacter)
  end

  self.db.global.characters[GUID].GUID = GUID

  return self.db.global.characters[GUID]
end

---Remove a character from the addon. No undo; log in on that character again to reintroduce.
---@param characterOrGUID WK_Character|string
function Data:DeleteCharacter(characterOrGUID)
  local GUID = type(characterOrGUID) == "table" and characterOrGUID.GUID or characterOrGUID
  if not GUID or self.db.global.characters[GUID] == nil then return end
  self.db.global.characters[GUID] = nil
  if type(self.cache.weeklyProgress) == "table" then
    self.cache.weeklyProgress = {}
  end
end

---Check to see if the Darkmoon Faire event is live.
---Bails early when calendar may return secret values (SecretInChatMessagingLockdown; taint-safe).
function Data:ScanCalendar()
  if self:IsInChatMessagingLockdown() then return end
  if not self.cache.calendarOpened then
    local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
    if currentCalendarTime and currentCalendarTime.month then
      C_Calendar.SetAbsMonth(currentCalendarTime.month, currentCalendarTime.year)
      C_Calendar.OpenCalendar()
      self.cache.calendarOpened = true
    end
  end
  local currentCalendarTime = C_DateAndTime.GetCurrentCalendarTime()
  if not currentCalendarTime or not currentCalendarTime.monthDay then
    return
  end
  local today = currentCalendarTime.monthDay
  local numEvents = C_Calendar.GetNumDayEvents(0, today)
  if not numEvents then
    return
  end
  for i = 1, numEvents do
    local event = C_Calendar.GetDayEvent(0, today, i)
    if event and not Utils:IsSecretValue(event.eventID) and event.eventID == 479 then
      self.cache.isDarkmoonOpen = true
    end
  end
end

function Data:ScanProfession()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  local tradeSkillLines = C_TradeSkillUI.GetAllProfessionTradeSkillLines()
  if not tradeSkillLines then
    return
  end

  local professions = {}
  Utils:TableForEach(tradeSkillLines, function(tradeSkillLineID)
    -- Skip professions we don't care about
    local skillLineVariant = self:GetSkillLineVariantByID(tradeSkillLineID)
    if not skillLineVariant then
      return
    end

    -- Find the character profession if it exists.
    local profession = Utils:TableFind(character.professions, function(characterProfession)
      return characterProfession.skillLineVariantID == tradeSkillLineID
    end)

    -- If we didn't find a profession, let's try to create one with basic info if possible.
    if not profession then
      local prof1, prof2 = GetProfessions()
      if not prof1 and not prof2 then
        return
      end
      Utils:TableForEach({prof1, prof2}, function(professionIndex)
        local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(professionIndex)
        if name and skillLine and skillLine == skillLineVariant.skillLineID then
          ---@type WK_CharacterProfession
          profession = {
            enabled = true,
            skillLineID = skillLineVariant.skillLineID,
            skillLineVariantID = tradeSkillLineID,
            skillLevel = 0,
            skillMaxLevel = 0,
            knowledgeLevel = 0,
            knowledgeMaxLevel = 0,
            knowledgeUnspent = 0,
            specializations = {},
            catchUpCurrencyInfo = nil,
            concentration = {
              currencyID = 0,
              lastUpdated = 0,
              name = "",
              description = "",
              icon = 0,
              quantity = 0,
              maxQuantity = 0,
              rechargingCycleDurationMS = 0,
              rechargingAmountPerCycle = 0,
            },
          }
        end
      end)
    end

    -- Okay let's just give up here. This is not a profession we care about.
    if not profession then
      return
    end

    -- Get specialization currency info
    local specializationCurrencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(tradeSkillLineID)
    if specializationCurrencyInfo and specializationCurrencyInfo.numAvailable then
      profession.knowledgeUnspent = specializationCurrencyInfo.numAvailable or 0
    end

    -- Get catch up currency info
    if skillLineVariant.catchUpCurrencyID then
      local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(skillLineVariant.catchUpCurrencyID)
      if currencyInfo and currencyInfo.quantity then
        profession.catchUpCurrencyInfo = currencyInfo
      end
    end

    -- Get concentration info
    local concentrationCurrencyID = C_TradeSkillUI.GetConcentrationCurrencyID(tradeSkillLineID)
    if concentrationCurrencyID and concentrationCurrencyID > 0 then
      local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(concentrationCurrencyID)
      if currencyInfo and currencyInfo.quantity and currencyInfo.maxQuantity then
        ---@type WK_CharacterProfessionConcentration
        profession.concentration = {
          currencyID = currencyInfo.currencyID,
          lastUpdated = GetServerTime(),
          name = currencyInfo.name,
          description = currencyInfo.description,
          icon = currencyInfo.iconFileID,
          quantity = currencyInfo.quantity,
          maxQuantity = currencyInfo.maxQuantity,
          rechargingCycleDurationMS = currencyInfo.rechargingCycleDurationMS,
          rechargingAmountPerCycle = currencyInfo.rechargingAmountPerCycle,
        }
      end
    end

    -- Scan knowledge spent/max for the profession
    local totalKnowledgeLevel = 0
    local totalKnowledgeMaxLevel = 0
    local specializations = {}
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(tradeSkillLineID)
    if configID and configID > 0 then
      local configInfo = C_Traits.GetConfigInfo(configID)
      if configInfo then
        local treeIDs = configInfo.treeIDs
        if treeIDs then
          Utils:TableForEach(treeIDs, function(treeID)
            local treeNodes = C_Traits.GetTreeNodes(treeID)
            if not treeNodes then return end
            ---@type WK_CharacterProfessionSpecialization
            local specialization = {
              rootNodeID = 0,
              name = "",
              rootIconID = 0,
              description = "",
              state = Enum.ProfessionsSpecTabState.Locked,
              treeID = 0,
              configID = 0,
              knowledgeLevel = 0,
              knowledgeMaxLevel = 0,
            }

            local tabInfo = C_ProfSpecs.GetTabInfo(treeID)
            if tabInfo then
              local state = C_ProfSpecs.GetStateForTab(treeID, configID)
              specialization.rootNodeID = tabInfo.rootNodeID
              specialization.rootIconID = tabInfo.rootIconID
              specialization.name = tabInfo.name
              specialization.description = tabInfo.description
              specialization.state = state
              specialization.treeID = treeID
              specialization.configID = configID
              specialization.knowledgeLevel = 0
              specialization.knowledgeMaxLevel = 0

              Utils:TableForEach(treeNodes, function(treeNode)
                local nodeInfo = C_Traits.GetNodeInfo(configID, treeNode)
                if not nodeInfo then return end
                if nodeInfo.ranksPurchased > 1 then
                  totalKnowledgeLevel = totalKnowledgeLevel + (nodeInfo.currentRank - 1)
                  specialization.knowledgeLevel = specialization.knowledgeLevel + (nodeInfo.currentRank - 1)
                end
                totalKnowledgeMaxLevel = totalKnowledgeMaxLevel + (nodeInfo.maxRanks - 1)
                specialization.knowledgeMaxLevel = specialization.knowledgeMaxLevel + (nodeInfo.maxRanks - 1)
              end)

              table.insert(specializations, specialization)
            end
          end)
        end
      end
    end

    profession.knowledgeLevel = totalKnowledgeLevel
    profession.knowledgeMaxLevel = totalKnowledgeMaxLevel
    profession.specializations = specializations

    -- Remove profession if it do not have a max knowledge level or is 0
    if profession and (not profession.knowledgeMaxLevel or profession.knowledgeMaxLevel == 0) then
      return
    end

    table.insert(professions, profession)
  end)

  character.professions = professions
  character.lastUpdate = GetServerTime()
end

function Data:ScanQuests()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  -- Track completed quests
  local completedQuests = {}
  Utils:TableForEach(self:GetObjectives(), function(objective)
    if not objective.quests then return end
    Utils:TableForEach(objective.quests, function(questID)
      if self.cache.completedQuests[questID] then
        completedQuests[questID] = true
        return
      end
      local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(questID)
      if isCompleted then
        completedQuests[questID] = true
        self.cache.completedQuests[questID] = true
      end
    end)
  end)

  character.completed = completedQuests
  character.lastUpdate = GetServerTime()
end

function Data:ScanCharacter()
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  -- Update character info
  local localizedRaceName, englishRaceName, raceID = UnitRace("player")
  local localizedClassName, classFile, classID = UnitClass("player")
  local englishFactionName, localizedFactionName = UnitFactionGroup("player")
  character.name = UnitName("player")
  character.realmName = GetRealmName()
  character.level = UnitLevel("player")
  character.factionEnglish = englishFactionName
  character.factionName = localizedFactionName
  character.raceID = raceID
  character.raceEnglish = englishRaceName
  character.raceName = localizedRaceName
  character.classID = classID
  character.classFile = classFile
  character.className = localizedClassName
  character.lastUpdate = GetServerTime()

  -- -- Don't track a character without any professions
  -- if Utils:TableCount(character.professions) < 1 then
  --   self.db.global.characters[character.GUID] = nil
  -- end
end

---@return table<WOWGUID, WK_Character>
function Data:GetCharacters()
  local characters = Utils:TableFilter(self.db.global.characters, function(character)
    -- Ignore ghost characters (Bug: https://github.com/DennisRas/WeeklyKnowledge/issues/47)
    if not character.name or character.name == "" then
      return false
    end
    return true
  end)

  table.sort(characters, function(a, b)
    if type(a.lastUpdate) == "number" and type(b.lastUpdate) == "number" then
      return a.lastUpdate > b.lastUpdate
    end
    return strcmputf8i(a.name, b.name) < 0
  end)

  return characters
end

---@return WK_Expansion[]
function Data:GetExpansions()
  return self.Expansions
end

---@param expansionID Enum.ExpansionLevel
---@return WK_Expansion?
function Data:GetExpansionByID(expansionID)
  for _, expansion in ipairs(self.Expansions) do
    if expansion.id == expansionID then
      return expansion
    end
  end
  return nil
end

---@return WK_SkillLine[]
function Data:GetSkillLines()
  return self.SkillLines
end

---@param skillLineID integer
---@return WK_SkillLine?
function Data:GetSkillLineByID(skillLineID)
  for _, skillLine in ipairs(self.SkillLines) do
    if skillLine.id == skillLineID then
      return skillLine
    end
  end
  return nil
end

---@return WK_SkillLineVariant[]
function Data:GetSkillLineVariants()
  return self.SkillLineVariants
end

---@param skillLineVariantID integer
---@return WK_SkillLineVariant?
function Data:GetSkillLineVariantByID(skillLineVariantID)
  for _, variant in ipairs(self.SkillLineVariants) do
    if variant.id == skillLineVariantID then
      return variant
    end
  end
  return nil
end

---@return WK_Objective[]
function Data:GetObjectives()
  return self.Objectives
end

---@return WK_ObjectiveCategory[]
function Data:GetObjectiveCategories()
  return self.ObjectiveCategories
end

---@param categoryID Enum.WK_ObjectiveCategory
---@return WK_ObjectiveCategory?
function Data:GetObjectiveCategoryByID(categoryID)
  for _, category in ipairs(self.ObjectiveCategories) do
    if category.id == categoryID then
      return category
    end
  end
  return nil
end

---@return WK_Progress[]
function Data:GetWeeklyProgress()
  local characters = self:GetCharacters()
  local objectives = self:GetObjectives()
  local objectiveCategories = self:GetObjectiveCategories()

  self.cache.weeklyProgress = wipe(self.cache.weeklyProgress or {})
  Utils:TableForEach(characters, function(character)
    local completed = (type(character.completed) == "table" and character.completed) or {}
    Utils:TableForEach(character.professions, function(characterProfession)
      local variant = self:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
      if not variant then return end

      local sumPointsEarned = 0
      local sumPointsTotal = 0

      for _, objective in pairs(objectives) do
        if objective.skillLineVariantID ~= characterProfession.skillLineVariantID or not objective.quests then
          -- skip
        elseif objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
          -- handled below
        else
          ---@type WK_Progress
          local progress = {
            characterGUID = character.GUID,
            objective = objective,
            questsCompleted = 0,
            questsTotal = 0,
            pointsEarned = 0,
            pointsTotal = 0,
            items = {},
          }

          if objective.itemID and objective.itemID > 0 then
            progress.items[objective.itemID] = false
          end

          Utils:TableForEach(objective.quests, function(questID)
            progress.questsTotal = progress.questsTotal + 1
            progress.pointsTotal = progress.pointsTotal + objective.points
            if objective.limit and progress.questsTotal > objective.limit then
              progress.pointsTotal = objective.limit * objective.points
              progress.questsTotal = objective.limit
            end
            if completed[questID] then
              if objective.itemID and objective.itemID > 0 then
                progress.items[objective.itemID] = true
              end
              progress.questsCompleted = progress.questsCompleted + 1
              progress.pointsEarned = progress.pointsEarned + objective.points
            end
          end)

          if objective.categoryID == Enum.WK_ObjectiveCategory.DarkmoonQuest then
            if not self.cache.isDarkmoonOpen then
              progress.questsTotal = 0
            end
          end

          if (
              objective.categoryID == Enum.WK_ObjectiveCategory.ArtisanQuest
              or objective.categoryID == Enum.WK_ObjectiveCategory.Treasure
              or objective.categoryID == Enum.WK_ObjectiveCategory.Gathering
              or objective.categoryID == Enum.WK_ObjectiveCategory.TrainerQuest
            ) then
            if progress.questsTotal > 0 then
              sumPointsEarned = sumPointsEarned + progress.pointsEarned
              sumPointsTotal = sumPointsTotal + progress.pointsTotal
            end
          end

          table.insert(self.cache.weeklyProgress, progress)
        end
      end

      local catchUpInfo = characterProfession.catchUpCurrencyInfo
      if variant.catchUpCurrencyID and catchUpInfo and catchUpInfo.quantity ~= nil and catchUpInfo.maxQuantity ~= nil then
        for _, objective in pairs(self.Objectives) do
          if objective.skillLineVariantID == characterProfession.skillLineVariantID and objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
            ---@type WK_Progress
            local progress = {
              characterGUID = character.GUID,
              objective = objective,
              questsCompleted = 0,
              questsTotal = 0,
              pointsEarned = 0,
              pointsTotal = 0,
              items = {},
            }

            if objective.itemID and objective.itemID > 0 then
              progress.items[objective.itemID] = false
            end

            progress.pointsEarned = catchUpInfo.quantity - sumPointsEarned
            progress.pointsTotal = catchUpInfo.maxQuantity - sumPointsTotal

            if progress.pointsEarned < progress.pointsTotal then
              progress.questsTotal = progress.pointsTotal - progress.pointsEarned
            else
              progress.questsTotal = progress.pointsTotal
              progress.questsCompleted = progress.pointsTotal
            end

            table.insert(self.cache.weeklyProgress, progress)
          end
        end
      end
    end)
  end)

  return self.cache.weeklyProgress
end
