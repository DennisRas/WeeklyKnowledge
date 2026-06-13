---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Checklist
local Checklist = {}
addon.Checklist = Checklist

local Constants = addon.Constants
local Data = addon.Data
local Helpers = addon.Helpers
local LibLiqUI = addon.libs.LiqUI
local SetBackgroundColor = LibLiqUI.Utils.SetBackgroundColor
local TableContains = LibLiqUI.Utils.TableContains
local TableCount = LibLiqUI.Utils.TableCount
local TableFilter = LibLiqUI.Utils.TableFilter
local TableForEach = LibLiqUI.Utils.TableForEach
local TableToggle = LibLiqUI.Utils.TableToggle

---@param objectiveA table
---@param objectiveB table
---@return boolean
local function checklistObjectiveIdentityLess(objectiveA, objectiveB)
  local categoryIdTextA = tostring(objectiveA.categoryID or "")
  local categoryIdTextB = tostring(objectiveB.categoryID or "")
  if categoryIdTextA ~= categoryIdTextB then return categoryIdTextA < categoryIdTextB end
  local questIdA = (objectiveA.quests and objectiveA.quests[1]) or 0
  local questIdB = (objectiveB.quests and objectiveB.quests[1]) or 0
  if questIdA ~= questIdB then return questIdA < questIdB end
  local spellIdA = objectiveA.spellID or 0
  local spellIdB = objectiveB.spellID or 0
  if spellIdA ~= spellIdB then return spellIdA < spellIdB end
  return (objectiveA.itemID or 0) < (objectiveB.itemID or 0)
end

---@param data { objective: table }
---@return string
local function checklistObjectiveRowSortText(data)
  local objective = data.objective
  if not objective then
    return ""
  end
  if objective.itemID and objective.itemID > 0 then
    local itemName = C_Item.GetItemInfo(objective.itemID)
    if itemName then
      return itemName
    end
    return format("Error: ItemID %d not found", objective.itemID or "?")
  end
  if objective.categoryID == Enum.WK_ObjectiveCategory.FirstCraft then
    local recipeInfo = Data.cache.tradeSkillRecipes and Data.cache.tradeSkillRecipes[objective.spellID]
    if not recipeInfo then
      recipeInfo = C_TradeSkillUI.GetRecipeInfo(objective.spellID)
      if recipeInfo then
        if not Data.cache.tradeSkillRecipes then
          Data.cache.tradeSkillRecipes = {}
        end
        Data.cache.tradeSkillRecipes[objective.spellID] = recipeInfo
      end
    end
    if recipeInfo and recipeInfo.name then
      return recipeInfo.name
    end
    return format("Error: RecipeID %d not found", objective.spellID or "?")
  end
  if objective.quests and TableCount(objective.quests) > 0 then
    local link = format("quest:%d:-1", objective.quests[1])
    local questTooltipData = C_TooltipInfo.GetHyperlink(link)
    if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
      return questTooltipData.lines[1].leftText
    end
    return format("Error: QuestID %d not found", objective.quests[1] or "?")
  end
  return "Unknown"
end

function Checklist:ToggleWindow()
  if not self.window then return end
  if self.window:IsVisible() then
    self.window:Hide()
  else
    if Data.cache.inCombat then return end
    self.window:Show()
  end
  Data.db.global.checklist.open = self.window:IsVisible()
  self:Render()
end

function Checklist:Render()
  local character = Data:GetCharacter()
  local dataColumns = self:GetColumns()
  local expansions = Data:GetExpansions()

  local tableWidth = 0
  local tableHeight = 0
  ---@type WK_TableRow[]
  local dataRows = {}

  if not self.window then
    local mediaPath = "Interface/AddOns/WeeklyKnowledge/Media/"
    self.window = addon.LiqUI.Window:New({
      name = "Checklist",
      title = "Checklist",
      icon = mediaPath .. "Icon.blp",
      point = { "TOPLEFT", UIParent, "TOPLEFT", 8, -8 },
      border = 4,
      onClose = function()
        Data.db.global.checklist.open = false
      end,
      titlebarButtons = {
        {
          name = "Settings",
          icon = mediaPath .. "Icon_Settings.blp",
          tooltipTitle = "Settings",
          tooltipDescription = "Let's customize things a bit",
          setupMenu = function(window, rootMenu)
        local showFullProfessionName = rootMenu:CreateCheckbox(
          "Show full profession name",
          function() return Data.db.global.showFullProfessionName end,
          function()
            Data.db.global.showFullProfessionName = not Data.db.global.showFullProfessionName
            self:Render()
            if addon.Main and addon.Main.Render then
              addon.Main:Render()
            end
          end
        )
        showFullProfessionName:SetTooltip(function(tooltip, elementDescription)
          GameTooltip_SetTitle(tooltip, MenuUtil.GetElementText(elementDescription));
          GameTooltip_AddNormalLine(tooltip, "Show the full profession name with the expansion variant.");
        end)

        rootMenu:CreateCheckbox(
          "Hide in combat",
          function() return Data.db.global.checklist.hideInCombat end,
          function()
            Data.db.global.checklist.hideInCombat = not Data.db.global.checklist.hideInCombat
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide in dungeons",
          function() return Data.db.global.checklist.hideInDungeons end,
          function()
            Data.db.global.checklist.hideInDungeons = not Data.db.global.checklist.hideInDungeons
            self:Render()
          end
        )
        rootMenu:CreateCheckbox(
          "Hide completed objectives",
          function() return Data.db.global.checklist.hideCompletedObjectives end,
          function()
            Data.db.global.checklist.hideCompletedObjectives = not Data.db.global.checklist.hideCompletedObjectives
            self:Render()
          end
        )
        rootMenu:CreateTitle("Window")
        local windowScale = rootMenu:CreateButton("Scaling")
        for i = 80, 200, 10 do
          windowScale:CreateRadio(
            i .. "%",
            function() return (window.db.scale or 100) == i end,
            function(data)
              window.db.scale = data
              self:Render()
            end,
            i
          )
        end

        local windowColor = window.db.windowColor
        local colorInfo = {
          r = windowColor.r,
          g = windowColor.g,
          b = windowColor.b,
          opacity = windowColor.a,
          swatchFunc = function()
            local r, g, b = ColorPickerFrame:GetColorRGB();
            local a = ColorPickerFrame:GetColorAlpha();
            if r then
              windowColor.r = r
              windowColor.g = g
              windowColor.b = b
              if a then
                windowColor.a = a
              end
              SetBackgroundColor(window, windowColor.r, windowColor.g, windowColor.b, windowColor.a)
            end
          end,
          opacityFunc = function() end,
          cancelFunc = function(color)
            if color.r then
              windowColor.r = color.r
              windowColor.g = color.g
              windowColor.b = color.b
              if color.a then
                windowColor.a = color.a
              end
              SetBackgroundColor(window, windowColor.r, windowColor.g, windowColor.b, windowColor.a)
            end
          end,
          hasOpacity = 1,
        }
        rootMenu:CreateColorSwatch(
          "Background color",
          function()
            ColorPickerFrame:SetupColorPickerAndShow(colorInfo)
          end,
          colorInfo
        )

        rootMenu:CreateCheckbox(
          "Show the border",
          function() return window.db.border ~= false end,
          function()
            window.db.border = window.db.border == false
            self:Render()
          end
        )
        -- rootMenu:CreateCheckbox(
        --   "Show the title bar",
        --   function() return Data.db.global.checklist.windowTitlebar end,
        --   function()
        --     Data.db.global.checklist.windowTitlebar = not Data.db.global.checklist.windowTitlebar
        --     self:Render()
        --   end
        -- )
          end,
        },
        {
          name = "Expansion",
          icon = mediaPath .. "Icon_House.blp",
          iconSize = 14,
          tooltipTitle = "Expansion",
          tooltipDescription = "Filter table by expansion.",
          setupMenu = function(_, rootMenu)
            TableForEach(Data:GetExpansions(), function(expansion)
          rootMenu:CreateCheckbox(
            expansion.name,
            function() return TableContains(Data.db.global.checklist.selectedExpansions, expansion.id) end,
            function()
              Data.db.global.checklist.selectedExpansions = TableToggle(Data.db.global.checklist.selectedExpansions, expansion.id)
              self:Render()
            end,
            expansion.id
          )
            end)
          end,
        },
        {
          name = "Columns",
          icon = mediaPath .. "Icon_Columns.blp",
          tooltipTitle = "Columns",
          tooltipDescription = "Toggle columns.",
          setupMenu = function(_, rootMenu)
        local hidden = Data.db.global.checklist.hiddenColumns
        TableForEach(self:GetColumns(true), function(column)
          if not column.hideable then return end
          rootMenu:CreateCheckbox(
            column.headerText,
            function() return not hidden[column.id] end,
            function(id)
              hidden[id] = not hidden[id]
              self:Render()
            end,
            column.id
          )
            end)
          end,
        },
        {
          name = "Categories",
          icon = mediaPath .. "Icon_Category.blp",
          iconSize = 11,
          tooltipTitle = "Categories",
          tooltipDescription = "Toggle categories.",
          setupMenu = function(_, rootMenu)
        local hidden = Data.db.global.checklist.hiddenCategories
        TableForEach(Data.ObjectiveCategories, function(category)
          rootMenu:CreateCheckbox(
            category.name,
            function() return not hidden[category.id] end,
            function(categoryID)
              hidden[categoryID] = not hidden[categoryID]
              self:Render()
            end,
            category.id
          )
            end)
          end,
        },
        {
          name = "Toggle",
          icon = mediaPath .. "Icon_Toggle.blp",
          iconSize = 16,
          tooltipTitle = "Toggle List",
          tooltipDescription = "Expand/Collapse the checklist.",
          onClick = function()
            Data.db.global.checklist.hideTable = not Data.db.global.checklist.hideTable
            self:Render()
          end,
        },
      },
    })
    self.window:SetFrameLevel(8100)
    self.window.placeholderText = addon.LiqUI.Window:GetBodyPlaceholderText(self.window.body)
    self.window.placeholderText:SetFontObject("SystemFont_Med1")
    self.window.placeholderText:Hide()

    self.window.table = addon.LiqUI.Table:New({
      name = "Checklist",
      header = {
        enabled = true,
        sticky = true,
        height = Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = Constants.TABLE_ROW_HEIGHT,
        highlight = false,
        striped = true
      },
      cells = {
        padding = Constants.TABLE_CELL_PADDING,
        fontObject = "GameFontHighlightSmall",
      },
      sorting = {
        enabled = true,
        defaultOrder = "desc",
        defaultCompare = function(a, b)
          local rowDataA, rowDataB = a.data, b.data
          if not rowDataA or not rowDataB then return false end
          local progressA, progressB = rowDataA.progress, rowDataB.progress
          local questsCompletedA = progressA and (progressA.questsCompleted or 0) or 0
          local questsCompletedB = progressB and (progressB.questsCompleted or 0) or 0
          if questsCompletedA ~= questsCompletedB then
            return questsCompletedA > questsCompletedB
          end
          local pointsEarnedA = progressA and (progressA.pointsEarned or 0) or 0
          local pointsEarnedB = progressB and (progressB.pointsEarned or 0) or 0
          if pointsEarnedA ~= pointsEarnedB then
            return pointsEarnedA > pointsEarnedB
          end
          local labelCompare = strcmputf8i(checklistObjectiveRowSortText(rowDataA), checklistObjectiveRowSortText(rowDataB))
          if labelCompare ~= 0 then
            return labelCompare < 0
          end
          local objectiveA, objectiveB = rowDataA.objective, rowDataB.objective
          if not objectiveA or not objectiveB then return false end
          return checklistObjectiveIdentityLess(objectiveA, objectiveB)
        end,
      },
    })
    self.window.table:SetParent(self.window.body)
    self.window.table:SetPoint("TOPLEFT", self.window.body, "TOPLEFT", 0, 0)
    self.window.table:SetPoint("BOTTOMRIGHT", self.window.body, "BOTTOMRIGHT", 0, 0)
  end

  if not character then
    self.window:Hide()
    return
  end

  -- Quick hotfix to avoid excessive rendering
  if (not self.window:IsVisible() and not Data.db.global.checklist.open) or (Data.cache.inCombat and Data.db.global.checklist.hideInCombat) then
    self.window:Hide()
    return
  end

  for _, column in ipairs(dataColumns) do
    tableWidth = tableWidth + column.width
  end
  if self.window.table.config.header.enabled then
    tableHeight = tableHeight + self.window.table.config.header.height
  end

  local characterProfessions = character.professions

  local rowCount = 0
  local objectives = Data:GetObjectives()
  local selectedExpansions = Data.db.global.checklist.selectedExpansions or {}

  do -- Table data
    TableForEach(characterProfessions, function(characterProfession)
      local skillLineVariantID = characterProfession.skillLineVariantID
      local skillLineVariant = Data:GetSkillLineVariantByID(skillLineVariantID)
      if not skillLineVariant then return end

      -- Skip if the skill line variant is not the selected expansion
      if TableCount(selectedExpansions) > 0 and not TableContains(selectedExpansions, skillLineVariant.expansionID) then
        -- print("Checklist: Skipping skill line variant", skillLineVariant.name, Data.db.global.checklist.selectedExpansion, skillLineVariant.expansionID)
        return
      end
      local filteredObjectives = TableFilter(objectives, function(objective)
        local debugID = objective.quests[1] or objective.spellID or objective.itemID

        -- Hide objective if not the correct profession
        if objective.skillLineVariantID ~= skillLineVariantID then
          -- print("Checklist: Skipping objective", debugID, "not the correct profession")
          return false
        end

        -- Hide objectives that are not repeatable
        -- Hide Darkmoon objectives
        if not Data.cache.isDarkmoonOpen and objective.categoryID == Enum.WK_ObjectiveCategory.DarkmoonQuest then
          -- print("Checklist: Skipping Darkmoon objective", debugID)
          return false
        end

        -- Hide if category is hidden
        local hiddenCategories = Data.db.global.checklist.hiddenCategories
        if hiddenCategories and hiddenCategories[objective.categoryID] then
          -- print("Checklist: Skipping hidden category objective", debugID)
          return false
        end

        -- Hide Uniques if enabled
        if Data.db.global.checklist.hideUniqueObjectives and objective.categoryID == Enum.WK_ObjectiveCategory.Unique then
          -- print("Checklist: Skipping Unique objective", debugID)
          return false
        end

        -- Hide Vendor Uniques if enabled
        if Data.db.global.checklist.hideUniqueVendorObjectives and objective.categoryID == Enum.WK_ObjectiveCategory.Unique and objective.requires and TableCount(objective.requires) > 0 then
          -- print("Checklist: Skipping Unique Vendor objective", debugID)
          return false
        end

        -- Hide Catch-Up if enabled
        if Data.db.global.checklist.hideCatchUpObjectives and objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
          -- print("Checklist: Skipping Catch-Up objective", debugID)
          return false
        end

        return true
      end)
      TableForEach(filteredObjectives, function(objective)
        local progress = Data:GetObjectiveProgress(character, objective)

        -- Skip if the objective is completed and hide completed objectives is enabled
        if Data.db.global.checklist.hideCompletedObjectives and progress.questsCompleted == progress.questsTotal then
          -- print("Checklist: Skipping completed objective", debugID)
          return
        end

        ---@type WK_TableRow
        local row = {
          data = {
            character = character,
            characterProfession = characterProfession,
            skillLineVariantID = skillLineVariantID,
            objective = objective,
            progress = progress,
          },
        }
        table.insert(dataRows, row)
        tableHeight = tableHeight + self.window.table.config.rows.height
        rowCount = rowCount + 1
      end)
    end)
  end

  local tableData = addon.LiqUI.Table.BuildData(dataColumns, dataRows)

  local windowWidth     = tableWidth
  local windowHeight    = Constants.TITLEBAR_HEIGHT
  local minWindowWidth  = 200
  local maxWindowHeight = 300
  if Data.db.global.checklist.hideTable then
    self.window.table:Hide()
    self.window.placeholderText:Hide()
    windowHeight = Constants.TITLEBAR_HEIGHT
  else
    if rowCount == 0 then
      self.window.placeholderText:SetText("It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or category above?\n\nIf this is your first time using this addon then make sure to open your professions at least once.")
      windowHeight = 200
      self.window.placeholderText:Show()
      self.window.table:Hide()
    else
      windowHeight = windowHeight + tableHeight
      self.window.placeholderText:Hide()
      self.window.table:Show()
    end
  end
  windowHeight = math.min(windowHeight, maxWindowHeight)
  windowWidth  = math.max(windowWidth, minWindowWidth)

  self.window:SetShown(Data.db.global.checklist.open)
  if self.window.border then
    self.window.border:SetShown(self.window.db.border ~= false)
  end
  if self.window.titlebar then
    self.window.titlebar:SetShown(Data.db.global.checklist.windowTitlebar)
  end
  self.window.table:SetData(tableData)
  self.window:SetBodySize(windowWidth, windowHeight - Constants.TITLEBAR_HEIGHT + 2)
  self.window:SetClampRectInsets(self.window:GetWidth() / 2, self.window:GetWidth() / -2, 0, self.window:GetHeight() / 2)
  self.window:SetScale((self.window.db.scale or 100) / 100)
  if Data.cache.inCombat and Data.db.global.checklist.hideInCombat then
    self.window:Hide()
  end
end

---Get column data
---@param unfiltered boolean?
---@return WK_TableColumn[]
function Checklist:GetColumns(unfiltered)
  local hidden = Data.db.global.checklist.hiddenColumns

  ---@type WK_TableColumn[]
  local columns = {
    {
      id = "objective",
      headerText = "Objective",
      width = 260,
      render = function(data)
        if data.objective.itemID and data.objective.itemID > 0 then
          local text = format("Error: ItemID %d not found", data.objective.itemID or "?")
          local link = ""
          -- Todo: Cache/Re-render item info
          local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(data.objective.itemID)
          if itemName then
            text = itemName
          end
          if itemLink then
            link = itemLink
          end
          if itemTexture then
            text = format("|T%s:0|t %s", itemTexture, itemLink or text or "[Not Loaded]")
          end

          return {
            text = text,
            onEnter = function(columnFrame)
              if link and strlen(link) > 0 then
                GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(link)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                GameTooltip:Show()
              end
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
            onClick = function()
              if link and strlen(link) > 0 then
                if IsModifiedClick("CHATLINK") then
                  if not ChatEdit_InsertLink(link) then
                    ChatFrame_OpenChat(link);
                  end
                end
              end
            end,
          }
        elseif data.objective.categoryID == Enum.WK_ObjectiveCategory.FirstCraft then
          local text = format("Error: RecipeID %d not found", data.objective.spellID or "?")
          local link = ""
          local recipeInfo = Data.cache.tradeSkillRecipes and Data.cache.tradeSkillRecipes[data.objective.spellID]
          if not recipeInfo then
            recipeInfo = C_TradeSkillUI.GetRecipeInfo(data.objective.spellID)
            if recipeInfo then
              if not Data.cache.tradeSkillRecipes then
                Data.cache.tradeSkillRecipes = {}
              end
              Data.cache.tradeSkillRecipes[data.objective.spellID] = recipeInfo
            end
          end
          if recipeInfo then
            link = C_Spell.GetSpellLink(recipeInfo.recipeID or data.objective.spellID)
            text = format("|T%s:0|t %s", recipeInfo.icon, recipeInfo.name)
          end
          return {
            text = text,
            onEnter = function(columnFrame)
              if link and strlen(link) > 0 then
                GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(link)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("<Click to open Recipe>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                GameTooltip:Show()
              end
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
            onClick = function()
              if link and strlen(link) > 0 then
                if IsModifiedClick("CHATLINK") then
                  if not ChatEdit_InsertLink(link) then
                    ChatFrame_OpenChat(link);
                  end
                else
                  C_TradeSkillUI.OpenRecipe(data.objective.spellID)
                end
              end
            end,
          }
        elseif data.objective.quests and TableCount(data.objective.quests) > 0 then
          local text = format("Error: QuestID %d not found", data.objective.quests[1] or "?")
          local link = format("quest:%d:-1", data.objective.quests[1])
          local questTooltipData = C_TooltipInfo.GetHyperlink(link)
          if questTooltipData and questTooltipData.lines and questTooltipData.lines[1] and questTooltipData.lines[1].leftText then
            text = WrapTextInColorCode(format("%s [%s]", CreateAtlasMarkup("questlog-questtypeicon-Recurring", 14, 14), questTooltipData.lines[1].leftText), "ffffff00")
          end
          return {
            text = text,
            onEnter = function(columnFrame)
              if link and strlen(link) > 0 then
                GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
                GameTooltip:SetHyperlink(link)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                GameTooltip:Show()
              end
            end,
            onLeave = function()
              GameTooltip:Hide()
            end,
            onClick = function()
              if link and strlen(link) > 0 then
                if IsModifiedClick("CHATLINK") then
                  if not ChatEdit_InsertLink(link) then
                    ChatFrame_OpenChat(link);
                  end
                end
              end
            end,
          }
        else
          local text = "Unknown"
          return {
            text = text,
          }
        end
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local skillLineVariantA = a.data.skillLineVariantID or 0
          local skillLineVariantB = b.data.skillLineVariantID or 0
          if skillLineVariantA ~= skillLineVariantB then return skillLineVariantA < skillLineVariantB end
          local labelCompare = strcmputf8i(checklistObjectiveRowSortText(a.data), checklistObjectiveRowSortText(b.data))
          if labelCompare ~= 0 then return labelCompare < 0 end
          local objectiveA, objectiveB = a.data.objective, b.data.objective
          if not objectiveA or not objectiveB then return false end
          return checklistObjectiveIdentityLess(objectiveA, objectiveB)
        end,
      },
    },
    {
      id = "profession",
      headerText = "Profession",
      width = Data.db.global.showFullProfessionName and 160 or 100,
      hideable = true,
      render = function(data)
        local text = ""
        local variant = Data:GetSkillLineVariantByID(data.skillLineVariantID)
        if not variant then return {text = ""} end
        local skillLine = Data:GetSkillLineByID(variant and variant.skillLineID or 0)
        if not skillLine then return {text = ""} end
        text = skillLine.name
        if Data.db.global.showFullProfessionName then
          text = variant.name
        end
        return {
          text = text,
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(text, 1, 1, 1);
            GameTooltip:AddLine(format("<Click to open profession>"), GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            C_TradeSkillUI.OpenTradeSkill(skillLine.id)
          end,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function skillLineNameLower(rowData)
            local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
            local skillLine = variant and Data:GetSkillLineByID(variant.skillLineID or 0)
            return skillLine and skillLine.name:lower() or ""
          end
          local nameA, nameB = skillLineNameLower(a.data), skillLineNameLower(b.data)
          if nameA ~= nameB then return nameA < nameB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "expansion",
      headerText = "Expansion",
      width = 120,
      hideable = true,
      render = function(data)
        local skillLineVariant = Data:GetSkillLineVariantByID(data.skillLineVariantID)
        local expansion = skillLineVariant and Data:GetExpansionByID(skillLineVariant.expansionID)
        return {
          text = expansion and expansion.name or "",
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function expansionNameLower(rowData)
            local variant = Data:GetSkillLineVariantByID(rowData.skillLineVariantID)
            local expansion = variant and Data:GetExpansionByID(variant.expansionID)
            return expansion and expansion.name:lower() or ""
          end
          local nameA, nameB = expansionNameLower(a.data), expansionNameLower(b.data)
          if nameA ~= nameB then return nameA < nameB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "category",
      headerText = "Category",
      name = "Category",
      width = 80,
      hideable = true,
      render = function(data)
        local objectiveCategory = Data:GetObjectiveCategoryByID(data.objective.categoryID)
        if not objectiveCategory then
          return {
            text = "?"
          }
        end
        return {
          text = objectiveCategory.name,
          onEnter = function(cellFrame)
            GameTooltip:SetOwner(cellFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText(objectiveCategory.name, 1, 1, 1);
            GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function categoryNameLower(rowData)
            local objectiveCategory = Data:GetObjectiveCategoryByID(rowData.objective.categoryID)
            return objectiveCategory and objectiveCategory.name:lower() or ""
          end
          local nameA, nameB = categoryNameLower(a.data), categoryNameLower(b.data)
          if nameA ~= nameB then return nameA < nameB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "location",
      headerText = "Location",
      width = 100,
      hideable = true,
      render = function(data)
        local text = " "
        if data.objective and data.objective.loc and data.objective.loc.m then
          if Data.cache.mapInfo[data.objective.loc.m] then
            text = Data.cache.mapInfo[data.objective.loc.m].name
          else
            local mapInfo = C_Map.GetMapInfo(data.objective.loc.m)
            if mapInfo then
              Data.cache.mapInfo[data.objective.loc.m] = mapInfo
              text = mapInfo.name
            end
          end
        end
        return {
          text = text
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local mapIdA = a.data.objective.loc and a.data.objective.loc.m or 0
          local mapIdB = b.data.objective.loc and b.data.objective.loc.m or 0
          if mapIdA ~= mapIdB then return mapIdA < mapIdB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "repeatable",
      headerText = "Repeat?",
      name = "Repeat?",
      width = 60,
      hideable = true,
      render = function(data)
        local objective = data.objective
        if not objective then
          return {
            text = " "
          }
        end
        local objectiveCategory = Data:GetObjectiveCategoryByID(objective.categoryID)
        if not objectiveCategory then
          return {
            text = " "
          }
        end
        return {
          text = objectiveCategory.repeatable or "",
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local function repeatableLabel(rowData)
            local objectiveCategory = Data:GetObjectiveCategoryByID(rowData.objective.categoryID)
            return objectiveCategory and objectiveCategory.repeatable or ""
          end
          local labelA, labelB = repeatableLabel(a.data), repeatableLabel(b.data)
          if labelA ~= labelB then return labelA < labelB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "progress",
      headerText = "Progress",
      width = 70,
      align = "CENTER",
      hideable = true,
      render = function(data)
        local text = format("%d / %d", data.progress.questsCompleted, data.progress.questsTotal)
        if data.progress.isCompleted then
          text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
        end

        return {
          text = text,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local questsCompletedA = a.data.progress and (a.data.progress.questsCompleted or 0) or 0
          local questsCompletedB = b.data.progress and (b.data.progress.questsCompleted or 0) or 0
          if questsCompletedA ~= questsCompletedB then return questsCompletedA < questsCompletedB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "points",
      headerText = "Points",
      name = "Points",
      width = 70,
      align = "CENTER",
      hideable = true,
      render = function(data)
        local text = format("%d / %d", data.progress.pointsEarned, data.progress.pointsTotal)
        if data.progress.isCompleted then
          text = GREEN_FONT_COLOR:WrapTextInColorCode(text)
        end

        return {
          text = text,
        }
      end,
      sorting = {
        enabled = true,
        compare = function(a, b)
          local pointsEarnedA = a.data.progress and (a.data.progress.pointsEarned or 0) or 0
          local pointsEarnedB = b.data.progress and (b.data.progress.pointsEarned or 0) or 0
          if pointsEarnedA ~= pointsEarnedB then return pointsEarnedA < pointsEarnedB end
          if a.data.skillLineVariantID ~= b.data.skillLineVariantID then
            return a.data.skillLineVariantID < b.data.skillLineVariantID
          end
          return Helpers:CompareCharacterNameRealm(a.data.character, b.data.character) < 0
        end,
      },
    },
    {
      id = "waypoint",
      headerText = "",
      width = 50,
      align = "CENTER",
      sorting = {
        enabled = false,
      },
      render = function(data)
        local TomTomGlobal = _G["TomTom"]
        local mapInfo = nil
        local mapPoint = nil

        if data.objective.loc and data.objective.loc.m then
          mapInfo = C_Map.GetMapInfo(data.objective.loc.m)
        end

        if mapInfo then
          mapPoint = UiMapPoint.CreateFromCoordinates(data.objective.loc.m, data.objective.loc.x / 100, data.objective.loc.y / 100)
        end

        return {
          text = CreateAtlasMarkup("Waypoint-MapPin-Tracked", 20, 20, -4),
          onEnter = function(columnFrame)
            local showTooltip = function()
              GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
              GameTooltip:SetText("Do you know de wey?", 1, 1, 1)

              if data.objective.loc and data.objective.loc.hint then
                GameTooltip:AddLine(data.objective.loc.hint, nil, nil, nil, true)
              elseif data.objective.categoryID == Enum.WK_ObjectiveCategory.FirstCraft then
                local objectiveCategory = Data:GetObjectiveCategoryByID(data.objective.categoryID)
                if objectiveCategory then
                  GameTooltip:AddLine(objectiveCategory.description, nil, nil, nil, true)
                end
              end

              if mapInfo then
                GameTooltip:AddLine(" ")
                GameTooltip:AddDoubleLine("Location:", mapInfo.name, nil, nil, nil, 1, 1, 1)
              end

              if data.objective.loc and data.objective.loc.x then
                if not mapInfo then
                  GameTooltip:AddLine(" ")
                end
                GameTooltip:AddDoubleLine("Coordinates:", format("%.1f / %.1f", data.objective.loc.x, data.objective.loc.y), nil, nil, nil, 1, 1, 1)
              end

              local requirementsHeading = "Requirements:"
              if data.objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
                requirementsHeading = "Unlock Catch-Up This Week:"
              end

              -- Requirements
              if TableCount(data.progress.requirements) > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(requirementsHeading)
                TableForEach(data.progress.requirements, function(requirement)
                  Helpers:RenderRequirementTooltip(requirement, data.character, data.objective.skillLineVariantID, data.objective.categoryID)
                end)
              end

              -- Item Rewards
              if TableCount(data.progress.items) > 0 then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("Rewards:")
                TableForEach(data.progress.items, function(isLooted, itemID)
                  local item = Data.cache.items[itemID]
                  local itemCached = item and item:IsItemDataCached()
                  local icon = itemCached and item:GetItemIcon() or 134400
                  local name = itemCached and item:GetItemLink() or "Loading..."
                  if data.objective.categoryID == Enum.WK_ObjectiveCategory.CatchUp then
                    GameTooltip:AddLine(format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name), 1, 1, 1, true)
                  else
                    GameTooltip:AddDoubleLine(
                      format("%s %s", CreateSimpleTextureMarkup(icon, 13, 13), name),
                      CreateAtlasMarkup(isLooted and "common-icon-checkmark" or "common-icon-redx", 12, 12),
                      1, 1, 1, 1, 1, 1
                    )
                  end
                end)
              end

              if mapPoint then
                if C_Map.CanSetUserWaypointOnMap(data.objective.loc.m) or TomTomGlobal then
                  GameTooltip:AddLine(" ")
                end
                if C_Map.CanSetUserWaypointOnMap(data.objective.loc.m) then
                  GameTooltip:AddLine("<Click to place a pin on the map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                  GameTooltip:AddLine("<Shift click to share pin in chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                end
                if TomTomGlobal then
                  GameTooltip:AddLine("<Alt click to place a TomTom waypoint>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
                end
              end
              GameTooltip:Show()
            end

            -- Continue on item load
            if TableCount(data.progress.items) > 0 then
              TableForEach(data.progress.items, function(isLooted, itemID)
                Data.cache.items[itemID] = Item:CreateFromItemID(itemID)
                Data.cache.items[itemID]:ContinueOnItemLoad(showTooltip)
              end)
            end

            -- Continue on item requirement load
            if TableCount(data.progress.requirements) > 0 then
              TableForEach(data.progress.requirements, function(requirement)
                if requirement.requirement.type == "item" then
                  Data.cache.items[requirement.requirement.id] = Item:CreateFromItemID(requirement.requirement.id)
                  Data.cache.items[requirement.requirement.id]:ContinueOnItemLoad(showTooltip)
                end
              end)
            end

            showTooltip()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if mapPoint then
              if IsAltKeyDown() and TomTomGlobal then
                local text = "Objective"
                TomTomGlobal:AddWaypoint(data.objective.loc.m, data.objective.loc.x / 100, data.objective.loc.y / 100, {title = text, from = addonName})
              elseif C_Map.CanSetUserWaypointOnMap(data.objective.loc.m) then
                if IsModifiedClick("CHATLINK") then
                  local hyperlink = format("|cffffff00|Hworldmap:%d:%d:%d|h[%s]|h|r", data.objective.loc.m, data.objective.loc.x * 100, data.objective.loc.y * 100, MAP_PIN_HYPERLINK)
                  if not ChatEdit_InsertLink(hyperlink) then
                    ChatFrame_OpenChat(hyperlink);
                  end
                else
                  C_Map.SetUserWaypoint(mapPoint)
                  C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                end
              end
            end
          end,
        }
      end,
    },
  }

  if unfiltered then
    return columns
  end

  local filteredColumns = TableFilter(columns, function(column)
    return not hidden[column.id]
  end)

  return filteredColumns
end
