---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge
local TableCollection = {}

function WK:CreateScrollFrame(name, parent)
  local frame = CreateFrame("ScrollFrame", name, parent)
  frame.content = CreateFrame("Frame", "$parentContent", frame)
  frame.scrollbarH = CreateFrame("Slider", "$parentScrollbarH", frame, "UISliderTemplate")
  frame.scrollbarV = CreateFrame("Slider", "$parentScrollbarV", frame, "UISliderTemplate")

  frame:SetScript("OnMouseWheel", function(_, delta)
    if IsModifierKeyDown() or not frame.scrollbarV:IsVisible() then
      frame.scrollbarH:SetValue(frame.scrollbarH:GetValue() - delta * ((frame.content:GetWidth() - frame:GetWidth()) * 0.2))
    else
      frame.scrollbarV:SetValue(frame.scrollbarV:GetValue() - delta * ((frame.content:GetHeight() - frame:GetHeight()) * 0.2))
    end
  end)
  frame:SetScript("OnSizeChanged", function() frame:RenderScrollFrame() end)
  frame:SetScrollChild(frame.content)
  frame.content:SetScript("OnSizeChanged", function() frame:RenderScrollFrame() end)

  frame.scrollbarH:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
  frame.scrollbarH:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.scrollbarH:SetHeight(6)
  frame.scrollbarH:SetMinMaxValues(0, 100)
  frame.scrollbarH:SetValue(0)
  frame.scrollbarH:SetValueStep(1)
  frame.scrollbarH:SetOrientation("HORIZONTAL")
  frame.scrollbarH:SetObeyStepOnDrag(true)
  frame.scrollbarH.thumb = frame.scrollbarH:GetThumbTexture()
  frame.scrollbarH.thumb:SetPoint("CENTER")
  frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.15)
  frame.scrollbarH.thumb:SetHeight(10)
  frame.scrollbarH:SetScript("OnValueChanged", function(_, value) frame:SetHorizontalScroll(value) end)
  frame.scrollbarH:SetScript("OnEnter", function() frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.2) end)
  frame.scrollbarH:SetScript("OnLeave", function() frame.scrollbarH.thumb:SetColorTexture(1, 1, 1, 0.15) end)

  frame.scrollbarV:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
  frame.scrollbarV:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
  frame.scrollbarV:SetWidth(6)
  frame.scrollbarV:SetMinMaxValues(0, 100)
  frame.scrollbarV:SetValue(0)
  frame.scrollbarV:SetValueStep(1)
  frame.scrollbarV:SetOrientation("VERTICAL")
  frame.scrollbarV:SetObeyStepOnDrag(true)
  frame.scrollbarV.thumb = frame.scrollbarV:GetThumbTexture()
  frame.scrollbarV.thumb:SetPoint("CENTER")
  frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.15)
  frame.scrollbarV.thumb:SetWidth(10)
  frame.scrollbarV:SetScript("OnValueChanged", function(_, value) frame:SetVerticalScroll(value) end)
  frame.scrollbarV:SetScript("OnEnter", function() frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.2) end)
  frame.scrollbarV:SetScript("OnLeave", function() frame.scrollbarV.thumb:SetColorTexture(1, 1, 1, 0.15) end)

  if frame.scrollbarH.NineSlice then frame.scrollbarH.NineSlice:Hide() end
  if frame.scrollbarV.NineSlice then frame.scrollbarV.NineSlice:Hide() end

  function frame:RenderScrollFrame()
    if math.floor(frame.content:GetWidth()) > math.floor(frame:GetWidth()) then
      frame.scrollbarH:SetMinMaxValues(0, frame.content:GetWidth() - frame:GetWidth())
      frame.scrollbarH.thumb:SetWidth(frame.scrollbarH:GetWidth() / 5)
      frame.scrollbarH.thumb:SetHeight(frame.scrollbarH:GetHeight())
      frame.scrollbarH:Show()
    else
      frame:SetHorizontalScroll(0)
      frame.scrollbarH:Hide()
    end
    if math.floor(frame.content:GetHeight()) > math.floor(frame:GetHeight()) then
      frame.scrollbarV:SetMinMaxValues(0, frame.content:GetHeight() - frame:GetHeight())
      frame.scrollbarV.thumb:SetHeight(frame.scrollbarV:GetHeight() / 5)
      frame.scrollbarV.thumb:SetWidth(frame.scrollbarV:GetWidth())
      frame.scrollbarV:Show()
    else
      frame:SetVerticalScroll(0)
      frame.scrollbarV:Hide()
    end
  end

  frame:RenderScrollFrame()
  return frame
end

function WK:CreateTableFrame(config)
  local tableFrame = CreateFrame("Frame", "WeeklyKnowledgeTable" .. (self:TableCount(TableCollection) + 1))
  tableFrame.scrollFrame = self:CreateScrollFrame("$parentScrollFrame", tableFrame)

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
        padding = self.Constants.TABLE_CELL_PADDING,
        highlight = false
      },
      ---@type WK_TableData
      data = {
        columns = {},
        rows = {},
      },
    },
    config or {}
  )
  tableFrame.rows = {}
  tableFrame.data = tableFrame.config.data

  ---Set the table data
  function tableFrame:SetData(data)
    tableFrame.data = data
    tableFrame:RenderTable()
  end

  function tableFrame:SetRowHeight(height)
    self.config.rows.height = height
    self:RenderTable()
  end

  function tableFrame:RenderTable()
    local offsetY = 0
    local offsetX = 0

    WK:TableForEach(tableFrame.rows, function(rowFrame) rowFrame:Hide() end)
    WK:TableForEach(tableFrame.data.rows, function(row, rowIndex)
      local rowFrame = tableFrame.rows[rowIndex]
      local rowHeight = tableFrame.config.rows.height
      local isStickyRow = false

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
          WK:SetBackgroundColor(rowFrame, 0, 0, 0, 0.3)
        end
      else
        rowFrame:SetParent(tableFrame.scrollFrame.content)
        rowFrame:SetPoint("TOPLEFT", tableFrame.scrollFrame.content, "TOPLEFT", 0, -offsetY)
        rowFrame:SetPoint("TOPRIGHT", tableFrame.scrollFrame.content, "TOPRIGHT", 0, -offsetY)
        if tableFrame.config.rows.striped and rowIndex % 2 == 1 then
          WK:SetBackgroundColor(rowFrame, 1, 1, 1, .02)
        end
      end

      if row.backgroundColor then
        WK:SetBackgroundColor(rowFrame, row.backgroundColor.r, row.backgroundColor.g, row.backgroundColor.b, row.backgroundColor.a)
      end

      rowFrame.data = row
      rowFrame:SetHeight(rowHeight)
      rowFrame:SetScript("OnEnter", function() rowFrame:onEnterHandler(rowFrame) end)
      rowFrame:SetScript("OnLeave", function() rowFrame:onLeaveHandler(rowFrame) end)
      rowFrame:SetScript("OnClick", function() rowFrame:onClickHandler(rowFrame) end)
      rowFrame:Show()

      function rowFrame:onEnterHandler(f)
        if rowIndex > 1 or not tableFrame.config.header.enabled then
          WK:SetHighlightColor(rowFrame, 1, 1, 1, .03)
        end
        if row.onEnter then
          row:onEnter(f)
        end
      end

      function rowFrame:onLeaveHandler(f)
        if rowIndex > 1 or not tableFrame.config.header.enabled then
          WK:SetHighlightColor(rowFrame, 1, 1, 1, 0)
        end
        if row.onLeave then
          row:onLeave(f)
        end
      end

      function rowFrame:onClickHandler(f)
        if row.onClick then
          row:onClick(f)
        end
      end

      offsetX = 0
      WK:TableForEach(rowFrame.columns, function(columnFrame) columnFrame:Hide() end)
      WK:TableForEach(row.columns, function(column, columnIndex)
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
        columnFrame:SetScript("OnClick", function() columnFrame:onClickHandler(columnFrame) end)
        columnFrame.text:SetWordWrap(false)
        columnFrame.text:SetJustifyH(columnTextAlign)
        columnFrame.text:SetPoint("TOPLEFT", columnFrame, "TOPLEFT", tableFrame.config.cells.padding, -tableFrame.config.cells.padding)
        columnFrame.text:SetPoint("BOTTOMRIGHT", columnFrame, "BOTTOMRIGHT", -tableFrame.config.cells.padding, tableFrame.config.cells.padding)
        columnFrame.text:SetText(column.text)
        columnFrame:Show()

        if column.backgroundColor then
          WK:SetBackgroundColor(columnFrame, column.backgroundColor.r, column.backgroundColor.g, column.backgroundColor.b, column.backgroundColor.a)
        end

        function columnFrame:onEnterHandler(f)
          rowFrame:onEnterHandler(f)
          if column.onEnter then
            column.onEnter(f)
          end
        end

        function columnFrame:onLeaveHandler(f)
          rowFrame:onLeaveHandler(f)
          if column.onLeave then
            column.onLeave(f)
          end
        end

        function columnFrame:onClickHandler(f)
          rowFrame:onClickHandler(f)
          if column.onClick then
            column:onClick(f)
          end
        end

        offsetX = offsetX + columnWidth
      end)

      if not isStickyRow then
        offsetY = offsetY + rowHeight
      end
    end)

    tableFrame.scrollFrame:SetPoint("TOPLEFT", tableFrame, "TOPLEFT", 0, tableFrame.config.header.sticky and -tableFrame.config.header.height or 0)
    tableFrame.scrollFrame:SetPoint("BOTTOMRIGHT", tableFrame, "BOTTOMRIGHT")
    tableFrame.scrollFrame.content:SetSize(offsetX, offsetY)
  end

  tableFrame.scrollFrame:HookScript("OnSizeChanged", function() tableFrame:RenderTable() end)
  tableFrame:RenderTable()
  table.insert(TableCollection, tableFrame)
  return tableFrame;
end
