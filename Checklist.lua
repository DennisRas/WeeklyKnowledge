---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

local Utils = addon.Utils
local Data = addon.Data
local UI = addon.UI

---@class WK_Checklist
local Checklist = {}
addon.Checklist = Checklist

function Checklist:ToggleWindow()
  if not self.frame then return end
  if self.frame:IsVisible() then
    self.frame:Hide()
  else
    self.frame:Show()
  end
  self:Render()
end

function Checklist:Render()
  local character = Data:GetCharacter()
  local dataColumns = self:GetColumns()
  local tableWidth = 0
  local tableHeight = 0
  ---@type WK_TableData
  local tableData = {
    columns = {
      {width = 260,},
      {width = 100,},
      {width = 80,},
      {
        width = 50,
        align = "CENTER",
      },
      {
        width = 40,
      },
    },
    rows = {}
  }

  if not self.frame then
    local frameName = addonName .. "ChecklistWindow"
    self.frame = CreateFrame("Frame", frameName, UIParent)
    self.frame:SetSize(500, 500)
    self.frame:SetFrameStrata("HIGH")
    self.frame:SetFrameLevel(8100)
    self.frame:SetClampedToScreen(true)
    self.frame:SetMovable(true)
    self.frame:SetPoint("CENTER")
    self.frame:SetUserPlaced(true)
    self.frame:RegisterForDrag("LeftButton")
    self.frame:EnableMouse(true)
    self.frame:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    self.frame:Hide()
    Utils:SetBackgroundColor(self.frame, Data.db.global.checklist.windowBackgroundColor.r, Data.db.global.checklist.windowBackgroundColor.g, Data.db.global.checklist.windowBackgroundColor.b, Data.db.global.checklist.windowBackgroundColor.a)

    self.frame.border = CreateFrame("Frame", "$parentBorder", self.frame, "BackdropTemplate")
    self.frame.border:SetPoint("TOPLEFT", self.frame, "TOPLEFT", -3, 3)
    self.frame.border:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 3, -3)
    self.frame.border:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 16, insets = {left = 4, right = 4, top = 4, bottom = 4}})
    self.frame.border:SetBackdropBorderColor(0, 0, 0, .5)
    self.frame.border:Show()

    self.frame.titlebar = CreateFrame("Frame", "$parentTitle", self.frame)
    self.frame.titlebar:SetPoint("TOPLEFT", self.frame, "TOPLEFT")
    self.frame.titlebar:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT")
    self.frame.titlebar:SetHeight(Constants.TITLEBAR_HEIGHT)
    self.frame.titlebar:RegisterForDrag("LeftButton")
    self.frame.titlebar:EnableMouse(true)
    self.frame.titlebar:SetScript("OnDragStart", function() self.frame:StartMoving() end)
    self.frame.titlebar:SetScript("OnDragStop", function() self.frame:StopMovingOrSizing() end)
    Utils:SetBackgroundColor(self.frame.titlebar, 0, 0, 0, 0.5)

    self.frame.titlebar.icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
    self.frame.titlebar.icon:SetPoint("LEFT", self.frame.titlebar, "LEFT", 6, 0)
    self.frame.titlebar.icon:SetSize(20, 20)
    self.frame.titlebar.icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon.blp")

    self.frame.titlebar.title = self.frame.titlebar:CreateFontString("$parentText", "OVERLAY")
    self.frame.titlebar.title:SetFontObject("SystemFont_Med2")
    self.frame.titlebar.title:SetPoint("LEFT", self.frame.titlebar, 28, 0)
    self.frame.titlebar.title:SetJustifyH("LEFT")
    self.frame.titlebar.title:SetJustifyV("MIDDLE")
    self.frame.titlebar.title:SetText("Checklist")

    do -- Close Button
      self.frame.titlebar.closeButton = CreateFrame("Button", "$parentCloseButton", self.frame.titlebar)
      self.frame.titlebar.closeButton:SetSize(Constants.TITLEBAR_HEIGHT, Constants.TITLEBAR_HEIGHT)
      self.frame.titlebar.closeButton:SetPoint("RIGHT", self.frame.titlebar, "RIGHT", 0, 0)
      self.frame.titlebar.closeButton:SetScript("OnClick", function() self:ToggleWindow() end)
      self.frame.titlebar.closeButton:SetScript("OnEnter", function()
        self.frame.titlebar.closeButton.Icon:SetVertexColor(1, 1, 1, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 0, 0, 0.2)
        GameTooltip:SetOwner(self.frame.titlebar.closeButton, "ANCHOR_TOP")
        GameTooltip:SetText("Close the window", 1, 1, 1, 1, true);
        GameTooltip:Show()
      end)
      self.frame.titlebar.closeButton:SetScript("OnLeave", function()
        self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
        Utils:SetBackgroundColor(self.frame.titlebar.closeButton, 1, 1, 1, 0)
        GameTooltip:Hide()
      end)

      self.frame.titlebar.closeButton.Icon = self.frame.titlebar:CreateTexture("$parentIcon", "ARTWORK")
      self.frame.titlebar.closeButton.Icon:SetPoint("CENTER", self.frame.titlebar.closeButton, "CENTER")
      self.frame.titlebar.closeButton.Icon:SetSize(10, 10)
      self.frame.titlebar.closeButton.Icon:SetTexture("Interface/AddOns/WeeklyKnowledge/Media/Icon_Close.blp")
      self.frame.titlebar.closeButton.Icon:SetVertexColor(0.7, 0.7, 0.7, 1)
    end

    self.frame.table = UI:CreateTableFrame({
      header = {
        enabled = true,
        sticky = true,
        height = Constants.TABLE_HEADER_HEIGHT,
      },
      rows = {
        height = Constants.ROW_HEIGHT,
        highlight = false,
        striped = true
      },
      cells = {
        padding = 6,
        highlight = true
      },
    })
    self.frame.table:SetParent(self.frame)
    self.frame.table:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -Constants.TITLEBAR_HEIGHT)
    self.frame.table:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", 0, 0)
  end

  if not character then
    self.frame:Hide()
    return
  end

  do -- Column config
    Utils:TableForEach(dataColumns, function(dataColumn)
      ---@type WK_TableDataColumn
      local column = {
        width = dataColumn.width,
        align = dataColumn.align or "LEFT",
      }
      table.insert(tableData.columns, column)
      tableWidth = tableWidth + dataColumn.width
    end)
  end

  do -- Header row
    ---@type WK_TableDataRow
    local row = {columns = {}}
    Utils:TableForEach(dataColumns, function(dataColumn)
      ---@type WK_TableDataCell
      local cell = {
        text = NORMAL_FONT_COLOR:WrapTextInColorCode(dataColumn.name),
        onEnter = dataColumn.onEnter,
        onLeave = dataColumn.onLeave,
      }
      table.insert(row.columns, cell)
    end)
    table.insert(tableData.rows, row)
    tableHeight = tableHeight + self.frame.table.config.header.height
  end

  Utils:TableForEach(character.professions, function(characterProfession)
    local dataProfession = Utils:TableFind(Data.Professions, function(dataProfession)
      return dataProfession.skillLineID == characterProfession.skillLineID
    end)
    if not dataProfession then return end

    Utils:TableForEach(dataProfession.objectives, function(professionObjective)
      if not professionObjective.itemID then
        return
      end
      local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(professionObjective.itemID)
      if not itemName then
        return
      end
      ---@type WK_TableDataRow
      local row = {columns = {}}
      local cellData = {
        character = character,
        characterProfession = characterProfession,
        dataProfession = dataProfession,
        itemName = itemName,
        itemLink = itemLink,
        itemTexture = itemTexture,
      }

      Utils:TableForEach(dataColumns, function(dataColumn)
        ---@type WK_TableDataCell
        local cell = dataColumn.cell(cellData)
        table.insert(row.columns, cell)
      end)

      table.insert(tableData.rows, row)
      tableHeight = tableHeight + self.frame.table.config.rows.height
    end)
  end)

  self.frame.table:SetData(tableData)
  self.frame:SetWidth(tableWidth)
  self.frame:SetHeight(math.min(tableHeight + Constants.TITLEBAR_HEIGHT, Constants.MAX_WINDOW_HEIGHT - 200))
  self.frame:SetScale(Data.db.global.checklist.windowScale / 100)
end

function Checklist:GetColumns(unfiltered)
  local hidden = Data.db.global.checklist.hiddenColumns
  local columns = {
    {
      name = "Item",
      width = 260,
      cell = function(data)
        return {
          text = "|T" .. data.itemTexture .. ":0|t " .. data.itemLink,
          onEnter = function(columnFrame)
            GameTooltip:ClearAllPoints()
            GameTooltip:ClearLines()
            GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(data.itemLink)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("<Shift Click to Link to Chat>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
          onClick = function()
            if IsModifiedClick("CHATLINK") then
              if not ChatEdit_InsertLink(data.itemLink) then
                ChatFrame_OpenChat(data.itemLink);
              end
            end
          end,
        }
      end,
    },
    {
      name = "Profession",
      width = 100,
      cell = function(data)
        return {
          text = data.dataProfession.name,
        }
      end,
    },
    {
      name = "Category",
      width = 80,
      cell = function(data)
        return {
          text = data.professionObjective.category.name,
        }
      end,
    },
    {
      name = "Points",
      width = 50,
      align = "CENTER",
      cell = function(data)
        return {
          text = "+" .. tostring(data.professionObjective.points),
        }
      end,
    },
    {
      name = "",
      width = 40,
      cell = function()
        return {
          text = CreateAtlasMarkup("Waypoint-MapPin-Untracked", 20, 20),
          onEnter = function(columnFrame)
            GameTooltip:SetOwner(columnFrame, "ANCHOR_RIGHT")
            GameTooltip:SetText("Do you know de wey?")
            GameTooltip:AddDoubleLine("Location:", "-", 1, 1, 1, 1, 1, 1)
            GameTooltip:AddDoubleLine("Coordinates:", "00.00 / 00.00", 1, 1, 1, 1, 1, 1)
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("<Click to Pin on Map>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
            GameTooltip:Show()
          end,
          onLeave = function()
            GameTooltip:Hide()
          end,
        }
      end,
    },
  }

  if unfiltered then
    return columns
  end

  local filteredColumns = Utils:TableFilter(columns, function(column)
    return not hidden[column.name]
  end)

  return filteredColumns
end
