---@class WK_ObjectiveCategory
---@field id WK_ObjectiveCategoryId
---@field name string
---@field description string
---@field type "item" | "quest" | "recipe"
---@field repeatable "No" | "Yes" | "Weekly" | "Monthly"
---@field hint boolean?

---@alias WK_ObjectiveRequirementType "item" | "currency" | "renown" | "skill" | "quest"
---@alias WK_ObjectiveRequirementMatch "all" | "any"

---@class WK_ObjectiveLocation
---@field m number?
---@field x number?
---@field y number?
---@field hint string?

---@class WK_ObjectiveRequirement
---@field type WK_ObjectiveRequirementType
---@field id integer?
---@field amount integer?
---@field name string?
---@field quests integer[]?
---@field match WK_ObjectiveRequirementMatch?

---@class WK_Objective
---@field skillLineVariantID integer
---@field categoryID WK_ObjectiveCategoryId
---@field quests integer[]
---@field spellID integer?
---@field itemID integer?
---@field points integer
---@field limit integer?
---@field loc WK_ObjectiveLocation?
---@field requires WK_ObjectiveRequirement[]?
