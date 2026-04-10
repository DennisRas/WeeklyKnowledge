---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_TableModule
local Table = {}
addon.Table = Table

Table.collection = {}

local Utils = addon.Utils
local Constants = addon.Constants
local UI = addon.UI

--- Strip |c color, |H links, |T textures, etc. for plain-text comparisons (Blizzard API).
---@param text string?
---@return string
local function stripFormattingForSort(text)
  text = tostring(text or "")
  if C_StringUtil and C_StringUtil.StripHyperlinks then
    return C_StringUtil.StripHyperlinks(text)
  end
  text = text:gsub("|c%x%x%x%x%x%x%x%x", "")
  text = text:gsub("|r", "")
  return text
end

--- Comparable value from visible cell text (progress N/M uses numerator; plain number; else lowercase string).
---@param text string?
---@return number|string
function Table:GetCellTextSortValue(text)
  text = stripFormattingForSort(text)
  local num, den = text:match("^%s*(%d+)%s*/%s*(%d+)%s*$")
  if num and den then
    return tonumber(num)
  end
  local numeric = tonumber(text:match("^%s*([%+%-]?[%d%.]+)%s*$"))
  if numeric ~= nil then
    return numeric
  end
  return text:lower()
end

--- Factory: scroll table with optional header, sorting, striped rows.
---@param config table? Merged into defaults; may include config.data (WK_TableData).
---@return Frame tableFrame Has SetData, RenderTable, scrollFrame, config, data, sortState, rows
function Table:CreateFrame(config)
  local tableCount = Utils:TableCount(self.collection)
  local tableFrame = CreateFrame("Frame", "WeeklyKnowledgeTable" .. (tableCount + 1))
  tableFrame.config = CreateFromMixins(
    {
      header = {
        enabled = true,
        sticky = false,
        height = 30,
      },
      rows = {
        height = 22,
        highlight = true,
        striped = true
      },
      columns = {
        width = 100,
        highlight = false,
        striped = false
      },
      cells = {
        padding = Constants.TABLE_CELL_PADDING,
        highlight = false
      },
      ---@type WK_TableSortConfig
      sorting = {
        enabled = false,
        defaultOrder = "desc",
      },
      ---@type WK_TableData
      data = {
        columns = {},
        rows = {},
      },
    },
    config or {}
  )
  do
    local sorting = tableFrame.config.sorting
    if sorting and sorting.enabled then
      if type(sorting.defaultColumn) ~= "string" or sorting.defaultColumn == "" then
        error("WeeklyKnowledge Table: sorting.enabled requires sorting.defaultColumn", 2)
      end
    end
  end
  tableFrame.rows = {}
  tableFrame.data = tableFrame.config.data
  ---@type WK_TableSortState
  tableFrame.sortState = {columnId = nil, direction = nil, isDefault = true}

  ---@param columnId string?
  ---@return number|nil
  function tableFrame:ColumnIndexForId(columnId)
    if not columnId or not self.data or not self.data.columns then
      return nil
    end
    for i, col in ipairs(self.data.columns) do
      if col.id == columnId then
        return i
      end
    end
    return nil
  end

  function tableFrame:SetSortStateToDefault()
    local sorting = self.config.sorting
    local state = self.sortState
    if type(sorting.defaultColumn) == "string" and sorting.defaultColumn ~= "" then
      state.columnId = sorting.defaultColumn
      state.direction = (sorting.defaultOrder == "asc") and "asc" or "desc"
    else
      state.columnId = nil
      state.direction = nil
    end
    state.isDefault = true
  end

  function tableFrame:ValidateSortState()
    local sorting = self.config.sorting
    if not sorting or not sorting.enabled then
      return
    end
    local state = self.sortState
    if not state or not state.columnId then
      return
    end
    if self:ColumnIndexForId(state.columnId) then
      return
    end
    self:SetSortStateToDefault()
    if sorting.onStateChanged then
      sorting.onStateChanged(state)
    end
  end

  do
    local sorting = tableFrame.config.sorting
    local saved = sorting and sorting.savedState
    if saved and (saved.columnId ~= nil or saved.direction ~= nil) then
      tableFrame.sortState.columnId = saved.columnId
      tableFrame.sortState.direction = saved.direction
    else
      tableFrame:SetSortStateToDefault()
    end
  end

  local function notifySortStateChanged()
    local sorting = tableFrame.config.sorting
    if sorting and sorting.onStateChanged then
      sorting.onStateChanged(tableFrame.sortState)
    end
  end

  tableFrame.scrollFrame = UI:CreateScrollFrame({
    name = "$parentScrollFrame",
    scrollSpeedVertical = tableFrame.config.rows.height * 2
  })

  function tableFrame:ApplySortToData()
    local sorting = self.config.sorting
    if not sorting or not sorting.enabled then return end

    local rows = self.data.rows
    if not rows or #rows <= 1 then return end

    local headerEnabled = self.config.header.enabled
    local dataStart = headerEnabled and 2 or 1
    if not rows[dataStart] then return end

    local state = self.sortState
    local sortColumnIndex = self:ColumnIndexForId(state.columnId)
    if state.columnId and state.direction and not sortColumnIndex then
      return
    end
    local columnSort = state.columnId and state.direction and sortColumnIndex
    if not columnSort then
      return
    end

    local ascending = state.direction == "asc"

    local dataRows = {}
    for i = dataStart, #rows do
      dataRows[#dataRows + 1] = rows[i]
    end

    local currentCharacter = addon.Data:GetCharacter()  -- current character

    ---@param row WK_TableRow
    ---@param colIndex number
    local function getSortValueFromColumn(row, colIndex)
      local colCfg = self.data.columns[colIndex]
      if colCfg and colCfg.getSortValue and row.data then
        local ok, value = pcall(colCfg.getSortValue, row.data)
        if ok and value ~= nil then
          return value
        end
      end
      local cell = row.cells and row.cells[colIndex]
      return Table:GetCellTextSortValue(cell and cell.text)
    end

    ---@param row WK_TableRow
    local function getSortValue(row)
      return getSortValueFromColumn(row, sortColumnIndex)
    end

    ---@param row WK_TableRow
    local function isCurrentCharacter(row)
      local nameValue = row.data.character.name
      if not nameValue then return false end
      return tostring(nameValue):lower() == tostring(currentCharacter.name):lower()
    end

    table.sort(dataRows, function(a, b)
      if state.isDefault then
        local aIsCurrent = isCurrentCharacter(a)
        local bIsCurrent = isCurrentCharacter(b)

        if aIsCurrent and not bIsCurrent then return true end
        if not aIsCurrent and bIsCurrent then return false end
        if aIsCurrent and bIsCurrent then return false end
      end

      local va = getSortValue(a)
      local vb = getSortValue(b)
      if type(va) == "number" and type(vb) == "number" then
        if va == vb then return false end
        if ascending then
          return va < vb
        end
        return va > vb
      end
      va = tostring(va or ""):lower()
      vb = tostring(vb or ""):lower()
      if va == vb then return false end
      if ascending then
        return va < vb
      end
      return va > vb
    end)

    for i = 1, #dataRows do
      rows[dataStart + i - 1] = dataRows[i]
    end
  end

  ---@param columnId string Stable column id
  ---@param button string? "LeftButton"|"RightButton"|… (from Button OnClick)
  function tableFrame:OnHeaderColumnClick(columnId, button)
    if type(columnId) ~= "string" or columnId == "" then return end
    local state = self.sortState
    if not state then
      state = {columnId = nil, direction = nil}
      self.sortState = state
    end

    if button == "RightButton" then
      self:SetSortStateToDefault()
      self:ApplySortToData()
      self:RenderTable()
      notifySortStateChanged()
      return
    end

    if state.columnId == columnId then
      state.direction = (state.direction == "asc") and "desc" or "asc"
    else
      state.columnId = columnId
      state.direction = "desc"
    end
    state.isDefault = false
    self:ApplySortToData()
    self:RenderTable()
    notifySortStateChanged()
  end

  function tableFrame:SetData(data)
    self.data = data
    self:ValidateSortState()
    self:ApplySortToData()
    self:RenderTable()
  end

  function tableFrame:SetRowHeight(height)
    self.config.rows.height = height
    self:RenderTable()
  end

  function tableFrame:RenderTable()
    local offsetY = 0
    local offsetX = 0

    Utils:TableForEach(tableFrame.rows, function(rowFrame) rowFrame:Hide() end)
    Utils:TableForEach(tableFrame.data.rows, function(row, rowIndex)
      local rowFrame = tableFrame.rows[rowIndex]
      local rowHeight = tableFrame.config.rows.height
      local isStickyRow = false
      local isHeaderRow = (rowIndex == 1 and tableFrame.config.header.enabled)

      if not rowFrame then
        rowFrame = CreateFrame("Button", "$parentRow" .. rowIndex, tableFrame)
        rowFrame.columns = {}
        tableFrame.rows[rowIndex] = rowFrame
      end

      if rowIndex == 1 then
        if tableFrame.config.header.enabled then
          rowHeight = tableFrame.config.header.height
        end
        if tableFrame.config.header.sticky then
          isStickyRow = true
        end
      end

      -- Sticky header
      if isStickyRow then
        rowFrame:SetParent(tableFrame)
        rowFrame:SetPoint("TOPLEFT", tableFrame, "TOPLEFT", 0, 0)
        rowFrame:SetPoint("TOPRIGHT", tableFrame, "TOPRIGHT", 0, 0)
        if not row.backgroundColor then
          Utils:SetBackgroundColor(rowFrame, 0, 0, 0, 0.3)
        end
      else
        rowFrame:SetParent(tableFrame.scrollFrame.content)
        rowFrame:SetPoint("TOPLEFT", tableFrame.scrollFrame.content, "TOPLEFT", 0, -offsetY)
        rowFrame:SetPoint("TOPRIGHT", tableFrame.scrollFrame.content, "TOPRIGHT", 0, -offsetY)
        if tableFrame.config.rows.striped and rowIndex % 2 == 1 then
          Utils:SetBackgroundColor(rowFrame, 1, 1, 1, .02)
        end
      end

      if row.backgroundColor then
        Utils:SetBackgroundColor(rowFrame, row.backgroundColor.r, row.backgroundColor.g, row.backgroundColor.b, row.backgroundColor.a)
      end

      rowFrame.data = row
      rowFrame:SetHeight(rowHeight)
      rowFrame:SetScript("OnEnter", function() rowFrame:onEnterHandler(rowFrame) end)
      rowFrame:SetScript("OnLeave", function() rowFrame:onLeaveHandler(rowFrame) end)
      rowFrame:SetScript("OnClick", function(_, button, ...)
        rowFrame:onClickHandler(rowFrame, button)
      end)
      rowFrame:Show()

      function rowFrame:onEnterHandler(f)
        if rowIndex > 1 or not tableFrame.config.header.enabled then
          Utils:SetHighlightColor(rowFrame, 1, 1, 1, .03)
        end
        if row.onEnter then
          row.onEnter(f)
        end
      end

      function rowFrame:onLeaveHandler(f)
        if rowIndex > 1 or not tableFrame.config.header.enabled then
          Utils:SetHighlightColor(rowFrame, 1, 1, 1, 0)
        end
        if row.onLeave then
          row.onLeave(f)
        end
      end

      function rowFrame:onClickHandler(f, button)
        if row.onClick then
          row.onClick(f, button)
        end
      end

      offsetX = 0
      Utils:TableForEach(rowFrame.columns, function(columnFrame) columnFrame:Hide() end)
      Utils:TableForEach(row.cells, function(column, columnIndex)
        local columnFrame = rowFrame.columns[columnIndex]
        local columnConfig = tableFrame.data.columns[columnIndex]
        local columnWidth = columnConfig and columnConfig.width or tableFrame.config.columns.width
        local columnTextAlign = columnConfig and columnConfig.align or "LEFT"

        if not columnFrame then
          columnFrame = CreateFrame("Button", "$parentCol" .. columnIndex, rowFrame)
          columnFrame.text = columnFrame:CreateFontString("$parentText", "OVERLAY")
          columnFrame.text:SetFontObject("GameFontHighlightSmall")
          rowFrame.columns[columnIndex] = columnFrame
        end

        columnFrame.data = column
        columnFrame:SetPoint("TOPLEFT", rowFrame, "TOPLEFT", offsetX, 0)
        columnFrame:SetPoint("BOTTOMLEFT", rowFrame, "BOTTOMLEFT", offsetX, 0)
        columnFrame:SetWidth(columnWidth)
        columnFrame:SetScript("OnEnter", function() columnFrame:onEnterHandler(columnFrame) end)
        columnFrame:SetScript("OnLeave", function() columnFrame:onLeaveHandler(columnFrame) end)
        columnFrame:SetScript("OnClick", function(_, button, ...)
          columnFrame:onClickHandler(columnFrame, button)
        end)
        if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
          columnFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
        end
        columnFrame.text:SetWordWrap(false)
        columnFrame.text:SetJustifyH(columnTextAlign)
        columnFrame.text:SetPoint("TOPLEFT", columnFrame, "TOPLEFT", tableFrame.config.cells.padding, -tableFrame.config.cells.padding)
        columnFrame.text:SetPoint("BOTTOMRIGHT", columnFrame, "BOTTOMRIGHT", -tableFrame.config.cells.padding, tableFrame.config.cells.padding)
        columnFrame.text:SetText(column.text)
        columnFrame:Show()

        if column.backgroundColor then
          Utils:SetBackgroundColor(columnFrame, column.backgroundColor.r, column.backgroundColor.g, column.backgroundColor.b, column.backgroundColor.a)
        end

        if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
          local colCfg = tableFrame.data.columns[columnIndex]
          local state = tableFrame.sortState
          local show = colCfg and colCfg.sortable ~= false and colCfg.id and state
            and state.columnId == colCfg.id and state.direction ~= nil
          if show then
            Utils:SetHighlightColor(columnFrame, 1, 1, 1, 0.03)
          else
            Utils:SetHighlightColor(columnFrame, 1, 1, 1, 0)
          end
        end

        function columnFrame:onEnterHandler(f)
          rowFrame:onEnterHandler(f)
          if column.onEnter then
            column.onEnter(f)
          end
          if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
            local colCfg = tableFrame.data.columns[columnIndex]
            if colCfg and colCfg.sortable ~= false and colCfg.id then
              if not column.onEnter then
                GameTooltip:SetOwner(f, "ANCHOR_RIGHT")
                GameTooltip:SetText(colCfg.headerText or "", 1, 1, 1)
              else
                GameTooltip:AddLine(" ")
              end
              GameTooltip:AddLine("<Click to Sort>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:AddLine("<Right Click to Reset>", GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
              GameTooltip:Show()
            end
          end
        end

        function columnFrame:onLeaveHandler(f)
          rowFrame:onLeaveHandler(f)
          if column.onLeave then
            column.onLeave(f)
          end
          if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
            local colCfg = tableFrame.data.columns[columnIndex]
            if colCfg and colCfg.sortable ~= false and colCfg.id and not column.onLeave then
              GameTooltip:Hide()
            end
          end
        end

        function columnFrame:onClickHandler(f, button)
          if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
            local colCfg = tableFrame.data.columns[columnIndex]
            if colCfg and colCfg.sortable ~= false and colCfg.id then
              tableFrame:OnHeaderColumnClick(colCfg.id, button)
              return
            end
          end
          rowFrame:onClickHandler(f, button)
          if column.onClick then
            column.onClick(f, button)
          end
        end

        offsetX = offsetX + columnWidth
      end)

      if not isStickyRow then
        offsetY = offsetY + rowHeight
      end
    end)

    tableFrame.scrollFrame:SetParent(tableFrame)
    tableFrame.scrollFrame:SetPoint("TOPLEFT", tableFrame, "TOPLEFT", 0, tableFrame.config.header.sticky and -tableFrame.config.header.height or 0)
    tableFrame.scrollFrame:SetPoint("BOTTOMRIGHT", tableFrame, "BOTTOMRIGHT")
    tableFrame.scrollFrame.content:SetSize(offsetX, offsetY)
  end

  tableFrame.scrollFrame:HookScript("OnSizeChanged", function() tableFrame:RenderTable() end)
  tableFrame:RenderTable()
  table.insert(self.collection, tableFrame)
  return tableFrame
end
