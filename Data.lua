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
  progressCache = {},
  completedQuests = {},
  tradeSkillRecipes = {},
}

Data.DBVersion = 19
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
      selectedExpansions = {},
      hiddenColumns = {},
      windowScale = 100,
      windowBackgroundColor = {r = 0.11372549019, g = 0.14117647058, b = 0.16470588235, a = 1},
      windowBorder = true,
      checklistHelpTipClosed = false,
      hideLowLevelProfessions = false,
    },
    checklist = {
      selectedExpansions = {},
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
  firstCrafts = {},
  factions = {},
  currencies = {},
  items = {},
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
    -- Migrate profession currencies
    if self.db.global.DBVersion == 16 then
      for _, character in pairs(self.db.global.characters) do
        if type(character.currencies) ~= "table" then
          character.currencies = {}
        end
        if type(character.professions) == "table" then
          for _, characterProfession in pairs(character.professions) do
            -- Migrate catch up currency info
            if type(characterProfession.catchUpCurrencyInfo) == "table" then
              ---@type WK_CharacterCurrency
              local characterCurrency = {
                id = characterProfession.catchUpCurrencyInfo.currencyID,
                name = characterProfession.catchUpCurrencyInfo.name,
                iconFileID = characterProfession.catchUpCurrencyInfo.iconFileID,
                quality = characterProfession.catchUpCurrencyInfo.quality,
                quantity = characterProfession.catchUpCurrencyInfo.quantity,
                maxQuantity = characterProfession.catchUpCurrencyInfo.maxQuantity,
                rechargingCycleDurationMS = characterProfession.catchUpCurrencyInfo.rechargingCycleDurationMS,
                rechargingAmountPerCycle = characterProfession.catchUpCurrencyInfo.rechargingAmountPerCycle,
                lastUpdated = characterProfession.catchUpCurrencyInfo.lastUpdated,
              }
              character.currencies[characterProfession.catchUpCurrencyInfo.currencyID] = characterCurrency
            end
            -- Migrate concentration currency info
            if type(characterProfession.concentration) == "table" then
              ---@type WK_CharacterCurrency
              local characterCurrency = {
                id = characterProfession.concentration.currencyID,
                name = characterProfession.concentration.name,
                iconFileID = characterProfession.concentration.iconFileID,
                quality = characterProfession.concentration.quality or 0,
                quantity = characterProfession.concentration.quantity,
                maxQuantity = characterProfession.concentration.maxQuantity or 0,
                rechargingCycleDurationMS = characterProfession.concentration.rechargingCycleDurationMS or 0,
                rechargingAmountPerCycle = characterProfession.concentration.rechargingAmountPerCycle or 0,
                lastUpdated = characterProfession.concentration.lastUpdated or 0,
              }
              character.currencies[characterProfession.concentration.currencyID] = characterCurrency
            end
          end
        end
      end
    end
    -- Migrate selected expansions
    -- Remove Dragonflight professions
    if self.db.global.DBVersion == 17 then
      if not self.db.global.main.selectedExpansions then
        self.db.global.main.selectedExpansions = {}
      end
      if not self.db.global.checklist.selectedExpansions then
        self.db.global.checklist.selectedExpansions = {}
      end
      if self.db.global.main.selectedExpansion then
        self.db.global.main.selectedExpansions = {self.db.global.main.selectedExpansion}
        self.db.global.main.selectedExpansion = nil
      end
      if self.db.global.checklist.selectedExpansion then
        self.db.global.checklist.selectedExpansions = {self.db.global.checklist.selectedExpansion}
        self.db.global.checklist.selectedExpansion = nil
      end
      for _, character in pairs(self.db.global.characters) do
        if type(character.professions) == "table" then
          character.professions = Utils:TableFilter(character.professions, function(characterProfession)
            local skillLineVariant = self:GetSkillLineVariantByID(characterProfession.skillLineVariantID)
            if not skillLineVariant then return false end
            return skillLineVariant.expansionID ~= Enum.ExpansionLevel.Dragonflight
          end)
        end
      end
    end
    -- Transform item table to counts
    if self.db.global.DBVersion == 18 then
      for _, character in pairs(self.db.global.characters) do
        if type(character.items) == "table" then
          for k, v in pairs(character.items) do
            if type(v) == "table" and v.quantity then
              character.items[k] = v.quantity
            end
          end
        end
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

---Clear the progress cache.
---@param clearAll boolean? Clear progress for all characters if true
---@return table<string, WK_ObjectiveProgress>
function Data:ClearProgressCache(clearAll)
  if clearAll then
    self.cache.progressCache = wipe(self.cache.progressCache or {})
  else
    local character = self:GetCharacter()
    if character then
      self.cache.progressCache[character.GUID] = wipe(self.cache.progressCache[character.GUID] or {})
    end
  end
  return self.cache.progressCache
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
  self:ClearProgressCache(true)
end

---Update the current character.
function Data:ScanAll()
  self:ScanCharacterInfo()
  self:ScanCurrencies()
  self:ScanItems()
  self:ScanQuests()
  self:ScanProfessions()
  self:ScanCalendar()
end

--- Scan currencies for a character.
function Data:ScanCurrencies()
  Utils:Debug("┌ ScanCurrencies()")
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end
  local objectives = self:GetObjectives()
  if not objectives then return end
  local skillLineVariants = self:GetSkillLineVariants()
  if not skillLineVariants then return end

  ---@type table<integer, WK_CharacterCurrency> currencyID -> WK_CharacterCurrency
  local currencies = {}
  ---@type table<integer, boolean> currencyID -> true
  local currencyIDs = {}

  -- Track currency IDs from objectives
  Utils:TableForEach(objectives, function(objective)
    if objective.requires and Utils:TableCount(objective.requires) > 0 then
      Utils:TableForEach(objective.requires, function(requirement)
        if requirement.type == "currency" then
          currencyIDs[requirement.id] = true
        end
      end)
    end
  end)

  -- Track currency IDs from skill line variants
  Utils:TableForEach(skillLineVariants, function(skillLineVariant)
    if skillLineVariant.catchUpCurrencyID and skillLineVariant.catchUpCurrencyID > 0 then
      currencyIDs[skillLineVariant.catchUpCurrencyID] = true
    end
    if skillLineVariant.concentrationCurrencyID and skillLineVariant.concentrationCurrencyID > 0 then
      currencyIDs[skillLineVariant.concentrationCurrencyID] = true
    end
  end)

  -- Get currency info from the game
  Utils:TableForEach(currencyIDs, function(_, currencyID)
    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID)
    if currencyInfo then
      ---@type WK_CharacterCurrency
      local characterCurrency = {
        id = currencyID,
        name = currencyInfo.name,
        iconFileID = currencyInfo.iconFileID,
        quality = currencyInfo.quality,
        quantity = currencyInfo.quantity,
        maxQuantity = currencyInfo.maxQuantity,
        rechargingCycleDurationMS = currencyInfo.rechargingCycleDurationMS,
        rechargingAmountPerCycle = currencyInfo.rechargingAmountPerCycle,
        lastUpdated = GetServerTime(),
      }
      currencies[currencyID] = characterCurrency
    end
  end)

  character.currencies = currencies
  character.lastUpdate = GetServerTime()
  Utils:Debug("├ Currencies: ", Utils:TableCount(currencies))
  Utils:Debug("└ Finshed")
end

---Check to see if the Darkmoon Faire event is live.
---Bails early when calendar may return secret values (SecretInChatMessagingLockdown; taint-safe).
function Data:ScanCalendar()
  Utils:Debug("┌ ScanCalendar()")
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
  Utils:Debug("├ Darkmoon Faire is open: ", self.cache.isDarkmoonOpen and "Yes" or "No")
  Utils:Debug("└ Finshed")
end

--- Scan all professions and recipes
function Data:ScanProfessions()
  Utils:Debug("┌ ScanProfessions()")
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  -- Get all profession trade skill lines variants from the game that we care about
  local skillLineVariants = C_TradeSkillUI.GetAllProfessionTradeSkillLines()
  local filteredSkillLineVariants = Utils:TableFilter(skillLineVariants or {}, function(skillLineVariantID)
    local skillLineVariant = self:GetSkillLineVariantByID(skillLineVariantID)
    if not skillLineVariant then return false end
    local expansion = self:GetExpansionByID(skillLineVariant.expansionID)
    if not expansion then return false end
    if not expansion.enabled then return false end
    return true
  end)
  if Utils:TableCount(filteredSkillLineVariants) == 0 then
    return
  end

  Utils:TableForEach(skillLineVariants, function(skillLineVariantID)
    local skillLineVariant = self:GetSkillLineVariantByID(skillLineVariantID)
    if not skillLineVariant then return end
    local expansion = self:GetExpansionByID(skillLineVariant.expansionID)
    if not expansion then return end
    if not expansion.enabled then return end

    -- Find the character profession if it exists.
    local characterProfession = Utils:TableFind(character.professions, function(characterProfession)
      return characterProfession.skillLineVariantID == skillLineVariantID
    end)

    -- We are now only adding a new profession if we can actually access the profession info.
    -- This means that the TradeSKillUI must have been opened once this session.
    local professionInfo = C_TradeSkillUI.GetBaseProfessionInfo()
    if professionInfo and professionInfo.professionID > 0 then
      local professionVariantInfo = C_TradeSkillUI.GetProfessionInfoBySkillLineID(skillLineVariantID)
      if professionVariantInfo and professionVariantInfo.skillLevel and professionVariantInfo.skillLevel > 0 and professionVariantInfo.maxSkillLevel and professionVariantInfo.maxSkillLevel > 0 then
        if not characterProfession then
          ---@type WK_CharacterProfession
          characterProfession = {
            enabled = true,
            skillLineVariantID = skillLineVariantID,
            skillLevel = professionVariantInfo.skillLevel,
            skillMaxLevel = professionVariantInfo.maxSkillLevel,
            knowledgeLevel = 0,
            knowledgeMaxLevel = 0,
            knowledgeUnspent = 0,
            specializations = {},
          }
          table.insert(character.professions, characterProfession)
        else
          characterProfession.skillLevel = professionVariantInfo.skillLevel
          characterProfession.skillMaxLevel = professionVariantInfo.maxSkillLevel
        end
      end
    end

    -- Okay let's just give up here. This is not a profession we care about.
    if not characterProfession then
      return
    end

    -- Get specialization currency info
    local specializationCurrencyInfo = C_ProfSpecs.GetCurrencyInfoForSkillLine(skillLineVariantID)
    if specializationCurrencyInfo and specializationCurrencyInfo.numAvailable then
      characterProfession.knowledgeUnspent = specializationCurrencyInfo.numAvailable or 0
    end

    -- Scan knowledge trees for the profession
    local totalKnowledgeLevel = 0
    local totalKnowledgeMaxLevel = 0
    local specializations = {}
    local configID = C_ProfSpecs.GetConfigIDForSkillLine(skillLineVariantID)
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

    characterProfession.knowledgeLevel = totalKnowledgeLevel
    characterProfession.knowledgeMaxLevel = totalKnowledgeMaxLevel
    characterProfession.specializations = specializations
  end)

  character.lastUpdate = GetServerTime()
  Utils:Debug("├ Professions: ", Utils:TableCount(character.professions))
  Utils:Debug("└ Finshed")
end

--- Scan all quests for a character.
function Data:ScanQuests()
  Utils:Debug("┌ ScanQuests()")
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end
  local objectives = self:GetObjectives()
  if not objectives then return end

  ---@type number[]
  local quests = {}
  ---@type table<number, boolean>
  local completedQuests = {}

  local firstCrafts = {}
  local firstCraftsAvailable = 0

  Utils:TableForEach(objectives, function(objective)
    -- Quests
    if objective.quests and Utils:TableCount(objective.quests) > 0 then
      Utils:TableForEach(objective.quests or {}, function(questID)
        if questID and questID > 0 then
          table.insert(quests, questID)
        end
      end)
      -- First Craft fallback on spellID
    elseif objective.categoryID == Enum.WK_ObjectiveCategory.FirstCraft and objective.spellID and objective.spellID > 0 then
      firstCrafts[objective.spellID] = C_TradeSkillUI.IsRecipeFirstCraft(objective.spellID)
      if firstCrafts[objective.spellID] then
        firstCraftsAvailable = firstCraftsAvailable + 1
      end
    end
    if objective.requires and Utils:TableCount(objective.requires) > 0 then
      Utils:TableForEach(objective.requires, function(requirement)
        if requirement.type == "quest" then
          Utils:TableForEach(requirement.quests or {}, function(questID)
            if questID and questID > 0 then
              table.insert(quests, questID)
            end
          end)
        end
      end)
    end
  end)

  quests = Utils:TableUnique(quests)
  if Utils:TableCount(quests) > 0 then
    Utils:TableForEach(quests, function(questID)
      local isCompleted = C_QuestLog.IsQuestFlaggedCompleted(questID)
      if isCompleted then
        completedQuests[questID] = true
      end
    end)
  end

  character.firstCrafts = firstCrafts
  character.completed = completedQuests
  character.lastUpdate = GetServerTime()
  Utils:Debug("├ Quests: ", Utils:TableCount(quests), "Completed: ", Utils:TableCount(completedQuests))
  Utils:Debug("├ SsellIDs: ", Utils:TableCount(firstCrafts), "FirstCrafts: ", firstCraftsAvailable)
  Utils:Debug("└ Finshed")
end

--- Scan all character information for the current character.
function Data:ScanCharacterInfo()
  Utils:Debug("┌ ScanCharacterInfo()")
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end

  -- Update character information
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
  Utils:Debug("└ Finshed")
end

--- Scan all character item counts for the current character.
function Data:ScanItems()
  Utils:Debug("┌ ScanItems()")
  if self:IsInChatMessagingLockdown() then return end
  if InCombatLockdown and InCombatLockdown() then return end
  local character = self:GetCharacter()
  if not character then return end
  local objectives = self:GetObjectives()
  if not objectives then return end

  ---@type table<number, number>
  local itemCounts = {}
  local itemCountTotal = 0
  ---@type number[]
  local itemIDs = {}
  Utils:TableForEach(objectives, function(objective)
    if objective.itemID and objective.itemID > 0 then
      table.insert(itemIDs, objective.itemID)
    end
    if objective.requires and Utils:TableCount(objective.requires) > 0 then
      Utils:TableForEach(objective.requires, function(requirement)
        if requirement.type == "item" then
          table.insert(itemIDs, requirement.id)
        end
      end)
    end
  end)
  itemIDs = Utils:TableUnique(itemIDs)
  if Utils:TableCount(itemIDs) > 0 then
    Utils:TableForEach(itemIDs, function(itemID)
      if itemID and itemID > 0 then
        local itemCount = C_Item.GetItemCount(itemID)
        if itemCount and itemCount > 0 then
          itemCounts[itemID] = itemCount
          itemCountTotal = itemCountTotal + itemCount
        end
      end
    end)
  end
  character.items = itemCounts
  character.lastUpdate = GetServerTime()
  Utils:Debug("├ Items: ", Utils:TableCount(itemIDs), "Count: ", itemCountTotal)
  Utils:Debug("└ Finshed")
end

---@return table<WOWGUID, WK_Character>
function Data:GetCharacters()
  local characters = Utils:TableFilter(self.db.global.characters or {}, function(character)
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
  local expansions = Utils:TableFilter(self.Expansions, function(expansion)
    return expansion.enabled
  end)
  return expansions
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

-- Get the progress for all objectives for the current character.
function Data:GetAllProgress()
  local character = self:GetCharacter()
  if not character then return end
  local objectives = self:GetObjectives()
  if not objectives then return end
  Utils:TableForEach(objectives, function(objective)
    self:GetObjectiveProgress(character, objective)
  end)
end

-- Get the progress for a single objective.
---@param character WK_Character
---@param objective WK_Objective
---@return WK_ObjectiveProgress
function Data:GetObjectiveProgress(character, objective)
  local progressCache = self.cache.progressCache[character.GUID]
  if progressCache then
    local objectiveProgress = Utils:TableFind(progressCache, function(objectiveProgress)
      return objectiveProgress.objective == objective
    end)
    if objectiveProgress then
      return objectiveProgress
    end
  end
  ---@type WK_ObjectiveProgress
  local objectiveProgress = {
    character = character,
    objective = objective,
    isCompleted = false,
    questsCompleted = 0,
    questsTotal = 0,
    pointsEarned = 0,
    pointsTotal = 0,
    requirementsMet = 0,
    requirementsTotal = 0,
    requirements = {},
    items = {},
  }

  local skillLineVariant = self:GetSkillLineVariantByID(objective.skillLineVariantID)
  if not skillLineVariant then return objectiveProgress end
  local skillLine = self:GetSkillLineByID(skillLineVariant.skillLineID)
  if not skillLine then return objectiveProgress end
  local currentCharacter = self:GetCharacter()
  if not currentCharacter then return objectiveProgress end

  if objective.itemID and objective.itemID > 0 then
    objectiveProgress.items[objective.itemID] = false
  end

  -- Catch Up
  if objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
    local characterCurrency = self:GetCharacterCurrency(character, skillLineVariant.catchUpCurrencyID)
    if characterCurrency then
      objectiveProgress.pointsEarned = characterCurrency.quantity or 0
      objectiveProgress.pointsTotal = characterCurrency.maxQuantity or 0
      objectiveProgress.questsCompleted = characterCurrency.quantity or 0
      objectiveProgress.questsTotal = characterCurrency.maxQuantity or 0
    end
  end

  -- Quests
  if objective.quests and Utils:TableCount(objective.quests) > 0 then
    character.completed = character.completed or {}
    -- Weekly Quests is just one quest id
    if objective.limit and objective.limit > 0 then
      local isCompleted = 0
      Utils:TableForEach(objective.quests, function(questID)
        if character.completed[questID] then
          isCompleted = isCompleted + 1
        end
      end)
      if isCompleted >= objective.limit then
        objectiveProgress.isCompleted = true
        objectiveProgress.pointsEarned = objectiveProgress.pointsEarned + (objective.points * objective.limit)
        objectiveProgress.questsCompleted = objectiveProgress.questsCompleted + objective.limit
      end
      objectiveProgress.pointsTotal = objectiveProgress.pointsTotal + (objective.points * objective.limit)
      objectiveProgress.questsTotal = objectiveProgress.questsTotal + objective.limit
    else
      Utils:TableForEach(objective.quests, function(questID)
        if character.completed[questID] then
          objectiveProgress.isCompleted = true
          objectiveProgress.pointsEarned = objectiveProgress.pointsEarned + objective.points
          objectiveProgress.questsCompleted = objectiveProgress.questsCompleted + 1
        end
        objectiveProgress.pointsTotal = objectiveProgress.pointsTotal + objective.points
        objectiveProgress.questsTotal = objectiveProgress.questsTotal + 1
      end)
    end
  else
    -- First Craft fallback on spellID
    if objective.categoryID == Enum.WK_ObjectiveCategory.FirstCraft and objective.spellID and objective.spellID > 0 then
      character.firstCrafts = character.firstCrafts or {}
      if character.firstCrafts[objective.spellID] ~= true then
        -- objectiveProgress.isCompleted = true
        objectiveProgress.pointsEarned = objectiveProgress.pointsEarned + objective.points
        objectiveProgress.questsCompleted = objectiveProgress.questsCompleted + 1
      end
      objectiveProgress.pointsTotal = objectiveProgress.pointsTotal + objective.points
      objectiveProgress.questsTotal = objectiveProgress.questsTotal + 1
    end
  end

  -- Darkmoon Quest
  if objective.categoryID == Enum.WK_ObjectiveCategory.DarkmoonQuest then
    if not self.cache.isDarkmoonOpen then
      objectiveProgress.pointsEarned = 0
      objectiveProgress.pointsTotal = 0
      objectiveProgress.questsCompleted = 0
      objectiveProgress.questsTotal = 0
    end
  end

  -- Requirements
  if objective.requires and #objective.requires > 0 then
    for _, requirement in pairs(objective.requires) do
      ---@type WK_ObjectiveProgressRequirement
      local objectiveProgressRequirement = {
        requirement = requirement,
        leftText = "-",
        rightText = "-",
        isCompleted = false,
      }
      if requirement.type == "quest" then
        local characterQuests = character.completed or {}
        local isCompleted = 0
        if requirement.match == "all" then
          Utils:TableForEach(requirement.quests, function(questID)
            objectiveProgress.requirementsTotal = objectiveProgress.requirementsTotal + 1
            local questCompleted = characterQuests[questID]
            if questCompleted then
              isCompleted = isCompleted + 1
              objectiveProgress.requirementsMet = objectiveProgress.requirementsMet + 1
            end
          end)
          if objectiveProgress.requirementsMet >= objectiveProgress.requirementsTotal then
            objectiveProgressRequirement.isCompleted = true
          end
        end
        if requirement.match == "any" then
          objectiveProgress.requirementsTotal = objectiveProgress.requirementsTotal + 1
          Utils:TableForEach(requirement.quests, function(questID)
            if characterQuests[questID] then
              objectiveProgress.requirementsMet = objectiveProgress.requirementsMet + 1
              objectiveProgressRequirement.isCompleted = true
              return
            end
          end)
        end
      end
      if requirement.type == "item" then
        local characterItems = character.items or {}
        objectiveProgress.requirementsTotal = objectiveProgress.requirementsTotal + 1
        local itemID = requirement.id
        if itemID and itemID > 0 then
          local quantity = characterItems[itemID] or 0
          if quantity >= requirement.amount then
            objectiveProgressRequirement.isCompleted = true
            objectiveProgress.requirementsMet = objectiveProgress.requirementsMet + 1
          end
        end
      end
      if requirement.type == "currency" then
        local characterCurrencies = character.currencies or {}
        objectiveProgress.requirementsTotal = objectiveProgress.requirementsTotal + 1
        local currencyID = requirement.id
        if currencyID and currencyID > 0 then
          local characterCurrency = characterCurrencies[currencyID]
          if characterCurrency then
            if characterCurrency.quantity and characterCurrency.quantity >= requirement.amount then
              objectiveProgressRequirement.isCompleted = true
              objectiveProgress.requirementsMet = objectiveProgress.requirementsMet + 1
            end
          end
        end
      end
      if requirement.type == "renown" then
        local characterFactions = character.factions or {}
        local renownInfo = C_MajorFactions.GetMajorFactionData(requirement.id)
        objectiveProgress.requirementsTotal = objectiveProgress.requirementsTotal + 1
        if renownInfo then
          local renownLevel = 0
          if character == currentCharacter then
            renownLevel = C_MajorFactions.GetCurrentRenownLevel(requirement.id) or 0
            characterFactions[requirement.id] = characterFactions[requirement.id] or {id = requirement.id, level = 0}
            characterFactions[requirement.id].level = renownLevel
          elseif characterFactions[requirement.id] then
            renownLevel = characterFactions[requirement.id].level
          end
          if renownLevel >= requirement.amount then
            objectiveProgressRequirement.isCompleted = true
            objectiveProgress.requirementsMet = objectiveProgress.requirementsMet + 1
          end
        end
      end
      if requirement.type == "skill" then
        local characterProfessions = character.professions or {}
        objectiveProgress.requirementsTotal = objectiveProgress.requirementsTotal + 1
        Utils:TableForEach(characterProfessions, function(characterProfession)
          if characterProfession.skillLineVariantID == requirement.id then
            local skillLevel = characterProfession.skillLevel or 0
            if skillLevel >= requirement.amount then
              objectiveProgressRequirement.isCompleted = true
              objectiveProgress.requirementsMet = objectiveProgress.requirementsMet + 1
            end
            return
          end
        end)
      end
      table.insert(objectiveProgress.requirements, objectiveProgressRequirement)
    end
  end

  if objectiveProgress.pointsEarned >= objectiveProgress.pointsTotal and objectiveProgress.pointsTotal > 0 then
    objectiveProgress.isCompleted = true
    -- Mark item rewards as looted
    if objective.itemID and objective.itemID > 0 then
      objectiveProgress.items[objective.itemID] = true
    end
  end

  self.cache.progressCache[character.GUID] = self.cache.progressCache[character.GUID] or wipe(self.cache.progressCache[character.GUID] or {})
  table.insert(self.cache.progressCache[character.GUID], objectiveProgress)
  return objectiveProgress
end

-- Get the progress for all objectives for a single category
---@param character WK_Character
---@param objectiveCategory WK_ObjectiveCategory
---@return WK_CategoryProgress
function Data:GetCategoryProgress(character, objectiveCategory)
  local categories = self:GetObjectiveCategories()
  local objectives = self:GetObjectives()
  ---@type WK_CategoryProgress
  local categoryProgress = {
    character = character,
    objectiveCategory = objectiveCategory,
    objectivesCompleted = 0,
    objectivesTotal = 0,
    pointsEarned = 0,
    pointsTotal = 0,
    requirementsMet = 0,
    requirementsTotal = 0,
    requirements = {},
    items = {},
  }

  Utils:TableForEach(categories, function(category)
    -- Skip categories we don't care about
    if category.id ~= objectiveCategory.id then
      return
    end

    Utils:TableForEach(objectives, function(objective)
      -- Skip objectives we don't care about
      if objective.categoryID ~= objectiveCategory.id then
        return
      end

      local objectiveProgress = self:GetObjectiveProgress(character, objective)
      if not objectiveProgress then return end
      if objectiveProgress.isCompleted then
        categoryProgress.objectivesCompleted = objectiveProgress.questsCompleted + 1
      end
      categoryProgress.objectivesTotal = objectiveProgress.questsTotal + 1
      categoryProgress.pointsEarned = categoryProgress.pointsEarned + objectiveProgress.pointsEarned
      categoryProgress.pointsTotal = categoryProgress.pointsTotal + objectiveProgress.pointsTotal
      categoryProgress.requirementsMet = categoryProgress.requirementsMet + objectiveProgress.requirementsMet
      categoryProgress.requirementsTotal = categoryProgress.requirementsTotal + objectiveProgress.requirementsTotal
      categoryProgress.requirements = Utils:TableMerge(categoryProgress.requirements, objectiveProgress.requirements)
      categoryProgress.items = Utils:TableMerge(categoryProgress.items, objectiveProgress.items, true)
    end)
  end)

  return categoryProgress
end

-- Get the progress for all objectives for a single profession.
---@param character WK_Character
---@param profession WK_CharacterProfession
---@return WK_ProfessionProgress
function Data:GetProfessionProgress(character, profession)
  ---@type WK_ProfessionProgress
  local professionProgress = {
    character = character,
    profession = profession,
    objectivesCompleted = 0,
    objectivesTotal = 0,
    pointsEarned = 0,
    pointsTotal = 0,
    requirementsMet = 0,
    requirementsTotal = 0,
    requirements = {},
    items = {},
  }

  local objectives = self:GetObjectives()
  Utils:TableForEach(objectives, function(objective)
    if objective.skillLineVariantID ~= profession.skillLineVariantID then
      return
    end
    local objectiveProgress = self:GetObjectiveProgress(character, objective)
    professionProgress.objectivesCompleted = professionProgress.objectivesCompleted + objectiveProgress.questsCompleted
    professionProgress.objectivesTotal = professionProgress.objectivesTotal + objectiveProgress.questsTotal
    professionProgress.pointsEarned = professionProgress.pointsEarned + objectiveProgress.pointsEarned
    professionProgress.pointsTotal = professionProgress.pointsTotal + objectiveProgress.pointsTotal
    professionProgress.requirementsMet = professionProgress.requirementsMet + objectiveProgress.requirementsMet
    professionProgress.requirementsTotal = professionProgress.requirementsTotal + objectiveProgress.requirementsTotal
    professionProgress.requirements = Utils:TableMerge(professionProgress.requirements, objectiveProgress.requirements)
    professionProgress.items = Utils:TableMerge(professionProgress.items, objectiveProgress.items, true)
  end)

  return professionProgress
end

---@param character WK_Character
---@param objectiveCategory WK_ObjectiveCategory
---@param characterProfession WK_CharacterProfession
---@return WK_CategoryProfessionProgress
function Data:GetCategoryProfessionProgress(character, objectiveCategory, characterProfession)
  ---@type WK_CategoryProfessionProgress
  local categoryProfessionProgress = {
    character = character,
    category = objectiveCategory,
    profession = characterProfession,
    objectivesCompleted = 0,
    objectivesTotal = 0,
    pointsEarned = 0,
    pointsTotal = 0,
    requirementsMet = 0,
    requirementsTotal = 0,
    requirements = {},
    items = {},
  }

  local objectives = self:GetObjectives()
  Utils:TableForEach(objectives, function(objective)
    -- Skip objectives we don't care about
    if objective.categoryID ~= objectiveCategory.id then
      return
    end
    -- Skip objectives we don't care about
    if objective.skillLineVariantID ~= characterProfession.skillLineVariantID then
      return
    end

    local objectiveProgress = self:GetObjectiveProgress(character, objective)
    categoryProfessionProgress.objectivesCompleted = categoryProfessionProgress.objectivesCompleted + objectiveProgress.questsCompleted
    categoryProfessionProgress.objectivesTotal = categoryProfessionProgress.objectivesTotal + objectiveProgress.questsTotal
    categoryProfessionProgress.pointsEarned = categoryProfessionProgress.pointsEarned + objectiveProgress.pointsEarned
    categoryProfessionProgress.pointsTotal = categoryProfessionProgress.pointsTotal + objectiveProgress.pointsTotal
    categoryProfessionProgress.requirementsMet = categoryProfessionProgress.requirementsMet + objectiveProgress.requirementsMet
    categoryProfessionProgress.requirementsTotal = categoryProfessionProgress.requirementsTotal + objectiveProgress.requirementsTotal
    categoryProfessionProgress.requirements = Utils:TableMerge(categoryProfessionProgress.requirements, objectiveProgress.requirements)
    categoryProfessionProgress.items = Utils:TableMerge(categoryProfessionProgress.items, objectiveProgress.items, true)
  end)

  return categoryProfessionProgress
end

---@param character WK_Character
---@param currencyID integer Currency ID
---@return WK_CharacterCurrency|nil
function Data:GetCharacterCurrency(character, currencyID)
  character.currencies = character.currencies or {}

  return character.currencies and character.currencies[currencyID] or nil
end
