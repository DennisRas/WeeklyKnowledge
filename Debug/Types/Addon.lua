---@class WK_Libs
---@field LibDataBroker unknown
---@field LibDBIcon unknown
---@field AceDB AceDB-3.0
---@field AceAddon AceAddon-3.0
---@field LiqUI LiqUI

---@class WK_Core : AceAddon, AceConsole-3.0, AceTimer-3.0, AceEvent-3.0, AceBucket-3.0

---@class WK_Window : LiqUI_WindowInstance
---@field table LiqUI_TableInstance|nil

---@class WK_Main
---@field window WK_Window|nil
---@field table LiqUI_TableInstance|nil
---@field TableData WK_Main_TableData
---@field TableColumns WK_Main_TableColumns

---@class WK_Checklist
---@field window WK_Window|nil
---@field table LiqUI_TableInstance|nil
---@field TableData WK_Checklist_TableData
---@field TableColumns WK_Checklist_TableColumns

---@class WK_Helpers

---@class WK_Constants
---@field prefix string
---@field commands string[]
---@field currentCharacterNameMarker string

---@class WK_Addon
---@field name string
---@field title string
---@field version string
---@field notes string
---@field debug boolean
---@field Core WK_Core
---@field libs WK_Libs
---@field Constants WK_Constants
---@field Helpers WK_Helpers
---@field Data WK_Data
---@field Main WK_Main
---@field Checklist WK_Checklist
