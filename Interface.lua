---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Interface
local UI = {}
addon.UI = UI

UI.ScrollCollection = {}

local Utils = addon.Utils

function UI:CreateScrollFrame(config)
  local tableCount = addon.Table and addon.Table.collection and Utils:TableCount(addon.Table.collection) or 0
  local frame = CreateFrame("ScrollFrame", "WeeklyKnowledgeScrollFrame" .. (tableCount + 1))
  local defaultScrollConfig = {
    scrollSpeedHorizontal = 20,
    scrollSpeedVertical = 20,
  }
  local mergedScrollConfig = CopyTable(defaultScrollConfig)
  Utils:TableMergeDeep(mergedScrollConfig, config or {})
  frame.config = mergedScrollConfig

  frame.content = CreateFrame("Frame", "$parentContent", frame)
  frame.scrollbarH = CreateFrame("Slider", "$parentScrollbarH", frame, "UISliderTemplate")
  frame.scrollbarV = CreateFrame("Slider", "$parentScrollbarV", frame, "UISliderTemplate")

  frame:SetScript("OnMouseWheel", function(_, delta)
    if IsModifierKeyDown() or not frame.scrollbarV:IsVisible() then
      frame.scrollbarH:SetValue(frame.scrollbarH:GetValue() - delta * frame.config.scrollSpeedHorizontal)
    else
      frame.scrollbarV:SetValue(frame.scrollbarV:GetValue() - delta * frame.config.scrollSpeedVertical)
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
    local viewportWidth = frame:GetWidth()
    local viewportHeight = frame:GetHeight()
    local contentWidth = frame.content:GetWidth()
    local contentHeight = frame.content:GetHeight()
    local ratioWidth = viewportWidth / contentWidth
    local ratioHeight = viewportHeight / contentHeight
    -- Horizontal
    if ratioWidth < 1 then
      frame.scrollbarH:SetValueStep(frame.config.scrollSpeedHorizontal)
      frame.scrollbarH:SetMinMaxValues(0, contentWidth - viewportWidth)
      frame.scrollbarH.thumb:SetWidth(viewportWidth * ratioWidth)
      frame.scrollbarH.thumb:SetHeight(frame.scrollbarH:GetHeight())
      frame.scrollbarH:Show()
    else
      frame:SetHorizontalScroll(0)
      frame.scrollbarH:Hide()
    end
    -- Vertical
    if ratioHeight < 1 then
      frame.scrollbarV:SetValueStep(frame.config.scrollSpeedVertical)
      frame.scrollbarV:SetMinMaxValues(0, contentHeight - viewportHeight)
      frame.scrollbarV.thumb:SetHeight(math.min(viewportHeight * ratioHeight, viewportHeight / 3))
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
