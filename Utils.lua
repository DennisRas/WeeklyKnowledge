---@type string
local addonName = select(1, ...)
local WK = _G.WeeklyKnowledge

---Set the background color for a parent frame
---@param parent any
---@param r number?
---@param g number?
---@param b number?
---@param a number?
function WK:SetBackgroundColor(parent, r, g, b, a)
  if not parent.Background then
    parent.Background = parent:CreateTexture("Background", "BACKGROUND")
    parent.Background:SetTexture("Interface/BUTTONS/WHITE8X8")
    parent.Background:SetAllPoints()
  end

  if type(r) == "table" then
    r, g, b, a = r.a, r.g, r.b, r.a
  end

  if type(r) == nil then
    r, g, b, a = 0, 0, 0, 0.1
  end

  parent.Background:SetVertexColor(r, g, b, a)
end

---Set the highlight color for a parent frame
---@param parent any
---@param r number?
---@param g number?
---@param b number?
---@param a number?
function WK:SetHighlightColor(parent, r, g, b, a)
  if not parent.Highlight then
    parent.Highlight = parent:CreateTexture("Highlight", "OVERLAY")
    parent.Highlight:SetTexture("Interface/BUTTONS/WHITE8X8")
    parent.Highlight:SetAllPoints()
  end

  if type(r) == "table" then
    r, g, b, a = r.a, r.g, r.b, r.a
  end

  if type(r) == nil then
    r, g, b, a = 1, 1, 1, 0.1
  end

  parent.Highlight:SetVertexColor(r, g, b, a)
end

---Find a table item by callback
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): boolean
---@return T|nil, number|nil
function WK:TableFind(tbl, callback)
  for i, v in pairs(tbl) do
    if callback(v, i) then
      return v, i
    end
  end
  return nil, nil
end

---Find a table item by key and value
---@generic T
---@param tbl T[]
---@param key string
---@param val any
---@return T|nil
function WK:TableGet(tbl, key, val)
  return self:TableFind(tbl, function(elm)
    return elm[key] and elm[key] == val
  end)
end

---Create a new table containing all elements that pass truth test
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): boolean
---@return T[]
function WK:TableFilter(tbl, callback)
  local t = {}
  for i, v in pairs(tbl) do
    if callback(v, i) then
      table.insert(t, v)
    end
  end
  return t
end

---Count table items
---@param tbl table
---@return number
function WK:TableCount(tbl)
  local n = 0
  for _ in pairs(tbl) do
    n = n + 1
  end
  return n
end

---Deep copy a table
---@generic T
---@param tbl T[]
---@param cache table?
---@return T[]
function WK:TableCopy(tbl, cache)
  local t = {}
  cache = cache or {}
  cache[tbl] = t
  self:TableForEach(tbl, function(v, k)
    if type(v) == "table" then
      t[k] = cache[v] or self:TableCopy(v, cache)
    else
      t[k] = v
    end
  end)
  return t
end

---Map each item in a table
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number): any
---@return T[]
function WK:TableMap(tbl, callback)
  local t = {}
  self:TableForEach(tbl, function(v, k)
    local newv, newk = callback(v, k)
    t[newk and newk or k] = newv
  end)
  return t
end

---Run a callback on each table item
---@generic T
---@param tbl T[]
---@param callback fun(value: T, index: number)
---@return T[]
function WK:TableForEach(tbl, callback)
  assert(tbl, "Must be a table!")
  for ik, iv in pairs(tbl) do
    callback(iv, ik)
  end
  return tbl
end
