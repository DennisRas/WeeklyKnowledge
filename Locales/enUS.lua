local addonName = select(1, ...)
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)

if not L then
  return
end

-- Bindings and slash commands
L["binding_toggle_checklist"] = "Toggle Checklist window"
L["binding_toggle_main"] = "Toggle WeeklyKnowledge window"

L["command_drag"] = "Drag"
L["command_hidden"] = "hidden"
L["command_left_click"] = "Left click"
L["command_locked"] = "(locked)"
L["command_minimap_status"] = "Minimap button %s."
L["command_right_click"] = "Right click"
L["command_shown"] = "shown"
L["command_usage"] = "Usage: /wk [checklist | minimap]"

L["prompt_weekly_reset"] = "Weekly Reset: Good job! Progress of your characters have been reset for a new week."

-- Common labels and statuses
L["label_categories"] = "Categories"
L["label_category"] = "Category"
L["label_characters"] = "Characters"
L["label_checklist"] = "Checklist"
L["label_columns"] = "Columns"
L["label_completed"] = "Completed:"
L["label_concentration"] = "Concentration"
L["label_coordinates"] = "Coordinates:"
L["label_error"] = "Error"
L["label_estimated"] = "Estimated"
L["label_expansion"] = "Expansion"
L["label_items"] = "Items:"
L["label_knowledge"] = "Knowledge"
L["label_knowledge_points"] = "Knowledge Points"
L["label_last_saved"] = "Last Saved"
L["label_loading"] = "Loading..."
L["label_location"] = "Location"
L["label_location_colon"] = "Location:"
L["label_locked"] = "Locked"
L["label_max"] = "Max:"
L["label_maxed_at"] = "Maxed at:"
L["label_monthly"] = "Monthly"
L["label_name"] = "Name"
L["label_no"] = "No"
L["label_no_data"] = "No data"
L["label_objective"] = "Objective"
L["label_objective_pin"] = "Objective Pin"
L["label_points"] = "Points"
L["label_points_available"] = "Points Available:"
L["label_points_earned"] = "Points Earned:"
L["label_points_spent"] = "Points Spent:"
L["label_points_unspent"] = "Points Unspent:"
L["label_profession"] = "Profession"
L["label_progress"] = "Progress"
L["label_quests"] = "Quests:"
L["label_realm"] = "Realm"
L["label_remaining"] = "Remaining:"
L["label_repeat"] = "Repeat?"
L["label_requirements"] = "Requirements:"
L["label_rewards"] = "Rewards:"
L["label_saved_at"] = "Saved at:"
L["label_settings"] = "Settings"
L["label_skill"] = "Skill"
L["label_specializations"] = "Specializations:"
L["label_time_to_max"] = "Time to max:"
L["label_toggle_list"] = "Toggle List"
L["label_unknown"] = "Unknown"
L["label_unlock_catch_up"] = "Unlock Catch-Up This Week:"
L["label_weekly"] = "Weekly"
L["label_window"] = "Window"
L["label_yes"] = "Yes"

L["status_can_unlock"] = "Can Unlock"

-- Buttons and menu options
L["button_background_color"] = "Background color"
L["button_lock_minimap"] = "Lock the minimap button"
L["button_remove_character"] = "Remove character"
L["button_scaling"] = "Scaling"
L["button_show_border"] = "Show the border"
L["button_show_full_profession_name"] = "Show full profession name"
L["button_show_minimap"] = "Show the minimap button"

L["menu_hide_completed_objectives"] = "Hide completed objectives"
L["menu_hide_in_combat"] = "Hide in combat"
L["menu_hide_in_dungeons"] = "Hide in dungeons"
L["menu_hide_low_level_professions"] = "Hide low level professions"

-- Main and checklist window text
L["main_empty_state"] = "It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or character above?\n\nIf this is your first time using this addon then make sure to open your professions at least once."
L["checklist_empty_state"] = "It does not look like you have any active professions.\nDid you maybe filter out the wrong expansion or category above?\n\nIf this is your first time using this addon then make sure to open your professions at least once."
L["popup_delete_character"] = "Remove %s?\nThis cannot be undone.\nTo add this character again, log in on them."

-- Tooltip text
L["tooltip_categories"] = "Toggle categories."
L["tooltip_characters"] = "Enable/Disable your characters."
L["tooltip_checklist_button"] = "Toggle the Checklist window"
L["tooltip_click_map_pin"] = "<Click to place a pin on the map>"
L["tooltip_click_open_profession"] = "<Click to open profession>"
L["tooltip_click_open_recipe"] = "<Click to open Recipe>"
L["tooltip_close_window"] = "Close the window"
L["tooltip_columns"] = "Enable/Disable table columns."
L["tooltip_columns_checklist"] = "Toggle columns."
L["tooltip_current_concentration"] = "Current concentration."
L["tooltip_current_knowledge"] = "Current knowledge gained."
L["tooltip_current_skill"] = "Current skill levels.\n\nNote: This is only updated when you open the profession window or craft a recipe."
L["tooltip_customize"] = "Let's customize things a bit"
L["tooltip_do_you_know_de_wey"] = "Do you know de wey?"
L["tooltip_drag_minimap"] = "Drag to move this icon"
L["tooltip_expansion_filter_checklist"] = "Filter table by expansion."
L["tooltip_expansion_filter_main"] = "Filter rows by selected expansions."
L["tooltip_expansion_row"] = "Expansion for this profession row."
L["tooltip_hide_low_level_professions"] = "Hide professions with a skill level below 25."
L["tooltip_left_click_open"] = "to open WeeklyKnowledge."
L["tooltip_link_chat"] = "<Shift Click to Link to Chat>"
L["tooltip_link_map_pin"] = "<Shift click to share pin in chat>"
L["tooltip_log_in_concentration"] = "Log in on this character to fetch concentration data."
L["tooltip_log_in_skill"] = "Log in on this character and open the profession window one time to fetch skill level data."
L["tooltip_move_minimap_crowded"] = "It does get crowded around the minimap sometimes."
L["tooltip_no_more_moving_minimap"] = "No more moving the button around accidentally!"
L["tooltip_place_tomtom"] = "<Alt click to place a TomTom waypoint>"
L["tooltip_professions"] = "Your professions."
L["tooltip_realms"] = "Realm names."
L["tooltip_right_click_open"] = "to open the Checklist."
L["tooltip_show_full_profession_name"] = "Show the full profession name with the expansion variant."
L["tooltip_toggle_list"] = "Expand/Collapse the checklist."
L["tooltip_your_characters"] = "Your characters."

-- Data and objective categories
L["expansion_dragonflight"] = "Dragonflight"
L["expansion_midnight"] = "Midnight"
L["expansion_war_within"] = "The War Within"

L["category_catch_up"] = "Catch-Up"
L["category_darkmoon"] = "Darkmoon"
L["category_first_craft"] = "First Craft"
L["category_gathering"] = "Gathering"
L["category_treatise"] = "Treatise"
L["category_treasure"] = "Treasure"
L["category_uniques"] = "Uniques"
L["category_weekly_quest"] = "Weekly Quest"

L["objective_desc_catch_up"] = "Keep track of your catch-up points.\n\nYou will be able to gain these points once you've completed some of the other objectives.\n\nRepeatable: %s"
L["objective_desc_darkmoon"] = "Complete a quest at the Darkmoon Faire.\n\nRepeatable: %s"
L["objective_desc_first_craft"] = "These are your first craft or first gathering bonuses.\n\nNote: Not every profession or expansion is updated yet.\n\nRepeatable: %s"
L["objective_desc_gathering"] = "These are randomly looted from gathering nodes around the world.\n\nFor Enchanting these are looted from Disenchanting.\n\nRepeatable: %s"
L["objective_desc_treatise"] = "These can be crafted with Inscription. Send a Crafting Order if you don't have the profession.\n\nRepeatable: %s"
L["objective_desc_treasure"] = "These are randomly looted from treasures around the world.\n\nRepeatable: %s"
L["objective_desc_uniques"] = "These are one-time items found in treasures around the world and sold by vendors.\n\nRepeatable: %s"
L["objective_desc_weekly_quest"] = "Complete a quest from your profession trainer or from the Artisan's Consortium.\n\nRepeatable: %s"

-- Alchemy
L["profession_alchemy"] = "Alchemy"
L["variant_dragon_isles_alchemy"] = "Dragon Isles Alchemy"
L["variant_khaz_algar_alchemy"] = "Khaz Algar Alchemy"
L["variant_midnight_alchemy"] = "Midnight Alchemy"

-- Blacksmithing
L["profession_blacksmithing"] = "Blacksmithing"
L["variant_dragon_isles_blacksmithing"] = "Dragon Isles Blacksmithing"
L["variant_khaz_algar_blacksmithing"] = "Khaz Algar Blacksmithing"
L["variant_midnight_blacksmithing"] = "Midnight Blacksmithing"

-- Enchanting
L["profession_enchanting"] = "Enchanting"
L["variant_dragon_isles_enchanting"] = "Dragon Isles Enchanting"
L["variant_khaz_algar_enchanting"] = "Khaz Algar Enchanting"
L["variant_midnight_enchanting"] = "Midnight Enchanting"

-- Engineering
L["profession_engineering"] = "Engineering"
L["variant_dragon_isles_engineering"] = "Dragon Isles Engineering"
L["variant_khaz_algar_engineering"] = "Khaz Algar Engineering"
L["variant_midnight_engineering"] = "Midnight Engineering"

-- Herbalism
L["profession_herbalism"] = "Herbalism"
L["variant_dragon_isles_herbalism"] = "Dragon Isles Herbalism"
L["variant_khaz_algar_herbalism"] = "Khaz Algar Herbalism"
L["variant_midnight_herbalism"] = "Midnight Herbalism"

-- Inscription
L["profession_inscription"] = "Inscription"
L["variant_dragon_isles_inscription"] = "Dragon Isles Inscription"
L["variant_khaz_algar_inscription"] = "Khaz Algar Inscription"
L["variant_midnight_inscription"] = "Midnight Inscription"

-- Jewelcrafting
L["profession_jewelcrafting"] = "Jewelcrafting"
L["variant_dragon_isles_jewelcrafting"] = "Dragon Isles Jewelcrafting"
L["variant_khaz_algar_jewelcrafting"] = "Khaz Algar Jewelcrafting"
L["variant_midnight_jewelcrafting"] = "Midnight Jewelcrafting"

-- Leatherworking
L["profession_leatherworking"] = "Leatherworking"
L["variant_dragon_isles_leatherworking"] = "Dragon Isles Leatherworking"
L["variant_khaz_algar_leatherworking"] = "Khaz Algar Leatherworking"
L["variant_midnight_leatherworking"] = "Midnight Leatherworking"

-- Mining
L["profession_mining"] = "Mining"
L["variant_dragon_isles_mining"] = "Dragon Isles Mining"
L["variant_khaz_algar_mining"] = "Khaz Algar Mining"
L["variant_midnight_mining"] = "Midnight Mining"

-- Skinning
L["profession_skinning"] = "Skinning"
L["variant_dragon_isles_skinning"] = "Dragon Isles Skinning"
L["variant_khaz_algar_skinning"] = "Khaz Algar Skinning"
L["variant_midnight_skinning"] = "Midnight Skinning"

-- Tailoring
L["profession_tailoring"] = "Tailoring"
L["variant_dragon_isles_tailoring"] = "Dragon Isles Tailoring"
L["variant_khaz_algar_tailoring"] = "Khaz Algar Tailoring"
L["variant_midnight_tailoring"] = "Midnight Tailoring"

-- Error and fallback text
L["error_item_not_found"] = "Error: ItemID %d not found"
L["error_quest_not_found"] = "Error: QuestID %d not found"
L["error_recipe_not_found"] = "Error: RecipeID %d not found"
