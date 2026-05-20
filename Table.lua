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

---@param config WK_TableConfig?
---@return Frame
function Table:CreateFrame(config)
  local tableCount = Utils:TableCount(self.collection)
  local tableFrame = CreateFrame("Frame", "WeeklyKnowledgeTable" .. (tableCount + 1))
  ---@type WK_TableConfig
  local defaultTableConfig = {
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
    sorting = {
      enabled = false,
      defaultOrder = "desc",
      defaultCompare = function(_, _)
        return false
      end,
    },
    data = {
      columns = {},
      rows = {},
    },
  }
  local mergedConfig = CopyTable(defaultTableConfig)
  Utils:TableMergeDeep(mergedConfig, config or {})
  tableFrame.config = mergedConfig
  do
    local sorting = tableFrame.config.sorting
    if sorting and sorting.enabled then
      if type(sorting.defaultCompare) ~= "function" then
        error("WeeklyKnowledge Table: sorting.enabled requires sorting.defaultCompare", 2)
      end
      if sorting.defaultOrder ~= "asc" and sorting.defaultOrder ~= "desc" then
        error("WeeklyKnowledge Table: sorting.enabled requires sorting.defaultOrder to be \"asc\" or \"desc\"", 2)
      end
    end
  end
  tableFrame.rows = {}
  tableFrame.data = tableFrame.config.data
  ---@type WK_TableSortState
  tableFrame.sortState = {columnId = nil, direction = nil}

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
    local state = self.sortState
    state.columnId = nil
    state.direction = nil
  end

  function tableFrame:ValidateSortState()
    local sorting = self.config.sorting
    if not sorting or not sorting.enabled then
      return
    end
    local state = self.sortState
    if not state then
      return
    end
    if state.columnId and not self:ColumnIndexForId(state.columnId) then
      self:SetSortStateToDefault()
      if sorting.onStateChanged then
        sorting.onStateChanged(state)
      end
      return
    end
    if state.columnId then
      if state.direction ~= "asc" and state.direction ~= "desc" then
        state.direction = (sorting.defaultOrder == "asc") and "asc" or "desc"
      end
    else
      state.direction = nil
    end
  end

  do
    local sorting = tableFrame.config.sorting
    local saved = sorting and sorting.savedState
    if sorting and sorting.enabled and saved and type(saved.columnId) == "string" and saved.columnId ~= "" then
      tableFrame.sortState.columnId = saved.columnId
      if saved.direction == "asc" or saved.direction == "desc" then
        tableFrame.sortState.direction = saved.direction
      else
        tableFrame.sortState.direction = (sorting.defaultOrder == "asc") and "asc" or "desc"
      end
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

    local dataRows = {}
    for i = dataStart, #rows do
      dataRows[#dataRows + 1] = rows[i]
    end

    local columnSort = state.columnId and state.direction and sortColumnIndex
    if not columnSort then
      table.sort(dataRows, sorting.defaultCompare)
      for i = 1, #dataRows do
        rows[dataStart + i - 1] = dataRows[i]
      end
      return
    end

    local ascending = state.direction == "asc"
    local colCfg = self.data.columns[sortColumnIndex]
    if not colCfg or not colCfg.sorting then
      error(format("WeeklyKnowledge Table: column \"%s\" must define sorting", tostring(colCfg and colCfg.id)), 2)
    end
    local columnSorting = colCfg.sorting
    if not columnSorting.enabled then
      error(format("WeeklyKnowledge Table: column \"%s\" is not sortable (sorting.enabled is false)", tostring(colCfg.id)), 2)
    end
    if type(columnSorting.compare) ~= "function" then
      error(format("WeeklyKnowledge Table: column \"%s\" must define sorting.compare when sorting.enabled is true", tostring(colCfg.id)), 2)
    end
    table.sort(dataRows, function(a, b)
      if ascending then
        return columnSorting.compare(a, b)
      end
      return columnSorting.compare(b, a)
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

    local sortingCfg = self.config.sorting
    if state.columnId == columnId then
      state.direction = (state.direction == "asc") and "desc" or "asc"
    else
      state.columnId = columnId
      state.direction = (sortingCfg and sortingCfg.defaultOrder == "asc") and "asc" or "desc"
    end
    self:ApplySortToData()
    self:RenderTable()
    notifySortStateChanged()
  end

  function tableFrame:SetData(data)
    self.data = data
    if data and data.columns then
      for i, col in ipairs(data.columns) do
        if not col.sorting then
          error(format('WeeklyKnowledge Table: column #%d ("%s") must define sorting', i, tostring(col.id)), 2)
        end
      end
    end
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
        if column.icons then
          -- Icon cell: hide the FontString, show/create icon child frames
          columnFrame.text:Hide()
          columnFrame.iconFrames = columnFrame.iconFrames or {}

          for i, iconData in ipairs(column.icons) do
            local iconFrame = columnFrame.iconFrames[i]
            if not iconFrame then
              iconFrame = CreateFrame("Frame", nil, columnFrame)
              iconFrame.texture = iconFrame:CreateTexture(nil, "ARTWORK")
              iconFrame.texture:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", 1, -1)
              iconFrame.texture:SetPoint("BOTTOMRIGHT", iconFrame, "BOTTOMRIGHT", -1, 1)
              iconFrame.border = iconFrame:CreateTexture(nil, "BACKGROUND")
              iconFrame.border:SetAllPoints()
              iconFrame.overlay = iconFrame:CreateTexture(nil, "OVERLAY")
              columnFrame.iconFrames[i] = iconFrame
            end

            local iconSize = iconData.size or 18
            iconFrame:SetSize(iconSize, iconSize)
            iconFrame.texture:SetTexture(iconData.iconFileID)
            if iconData.unscanned then
              iconFrame.texture:SetVertexColor(0.4, 0.4, 0.4, 1)
            else
              iconFrame.texture:SetVertexColor(1, 1, 1, 1)
            end

            if iconData.borderColor then
              local bc = iconData.borderColor
              iconFrame.border:SetColorTexture(bc.r, bc.g, bc.b, 1)
              iconFrame.border:Show()
            else
              iconFrame.border:Hide()
            end

            iconFrame.overlay:SetSize(10, 10)
            iconFrame.overlay:ClearAllPoints()
            iconFrame.overlay:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", -2, 2)
            if iconData.overlayAtlas then
              iconFrame.overlay:SetAtlas(iconData.overlayAtlas)
              iconFrame.overlay:Show()
            else
              iconFrame.overlay:Hide()
            end

            iconFrame:ClearAllPoints()
            iconFrame:SetPoint("LEFT", columnFrame, "LEFT",
              tableFrame.config.cells.padding + (i - 1) * (iconSize + 2), 0)
            if iconData.onEnter or iconData.onLeave then
              iconFrame:EnableMouse(true)
              iconFrame:SetScript("OnEnter", iconData.onEnter or nil)
              iconFrame:SetScript("OnLeave", iconData.onLeave or nil)
              iconFrame:SetScript("OnMouseUp", function() columnFrame:onClickHandler(columnFrame) end)
            else
              iconFrame:EnableMouse(false)
              iconFrame:SetScript("OnEnter", nil)
              iconFrame:SetScript("OnLeave", nil)
              iconFrame:SetScript("OnMouseUp", nil)
            end
            iconFrame:Show()
          end

          -- Hide leftover icon frames from a previous wider render
          for i = #column.icons + 1, #columnFrame.iconFrames do
            columnFrame.iconFrames[i]:Hide()
          end
        else
          -- Text cell: show the FontString, hide any icon child frames
          columnFrame.text:Show()
          columnFrame.text:SetWordWrap(false)
          columnFrame.text:SetJustifyH(columnTextAlign)
          columnFrame.text:SetPoint("TOPLEFT", columnFrame, "TOPLEFT", tableFrame.config.cells.padding, -tableFrame.config.cells.padding)
          columnFrame.text:SetPoint("BOTTOMRIGHT", columnFrame, "BOTTOMRIGHT", -tableFrame.config.cells.padding, tableFrame.config.cells.padding)
          columnFrame.text:SetText(column.text)
          if columnFrame.iconFrames then
            for _, f in ipairs(columnFrame.iconFrames) do f:Hide() end
          end
        end
        columnFrame:Show()

        if column.backgroundColor then
          Utils:SetBackgroundColor(columnFrame, column.backgroundColor.r, column.backgroundColor.g, column.backgroundColor.b, column.backgroundColor.a)
        end

        if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
          local colCfg = tableFrame.data.columns[columnIndex]
          local state = tableFrame.sortState
          local show = colCfg and colCfg.sorting.enabled and state
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
            if colCfg and colCfg.sorting.enabled then
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
            if colCfg and colCfg.sorting.enabled and not column.onLeave then
              GameTooltip:Hide()
            end
          end
        end

        function columnFrame:onClickHandler(f, button)
          if isHeaderRow and tableFrame.config.sorting and tableFrame.config.sorting.enabled then
            local colCfg = tableFrame.data.columns[columnIndex]
            if colCfg and colCfg.sorting.enabled then
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
