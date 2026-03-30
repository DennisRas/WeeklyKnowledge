# Changelog

## v1.2.6 - 2026-03-30

- Updated the changelog to be more concise and easier to read.

## v1.2.5 - 2026-03-15

- Added scrollbar for the character list (for the truly dedicated altoholics with 60+ characters).
- Fixed incorrect KP points from 2 to 1 for Alchemy and Engineering treasures.

## v1.2.4 - 2026-03-10

- Added automatic detection of your professions when using the addon for the first time. It's still recommended that you open your professions for full data.
- Fixed invalid/fake professions being added when opening a guild or chat link profession. They should be removed automatically with this update.

## v1.2.3 - 2026-03-06

- Added automatic removal of invalid or unlearned professions.
- Added quest requirement to Unique: Pure Void Crystal. Fixes #107.
- Updated ~80 unique items with new or corrected location hints and coordinates.
- Updated location or requirement data for several uniques:
  - Silvermoon Blacksmith's Hammer
  - Sin'dorei Master's Forgemace
  - Speculative Voidstorm Crystal
  - Voidstorm Defense Spear
  - Vial of Eversong Oddities
  - Enchanted Sunfire Silk
  - What To Do When Nothing Works.
- Fixed bugged text under requirements in the Checklist tooltips. Fixes #107.
- Fixed an issue where a character could have no `itemCount` or `.items` data. Fixes #110 (thank you Jinatha for the report).
- Fixed an upvalue bug in the Checklist tooltips that could cause errors.
- Fixed a small loop bug when processing skills.

## v1.2.2 - 2026-03-04

- Added an introduction message for first-time users.
- Added the missing Skinning trainer quest.
- Added hints to several unique items.
- Updated Catch-Up column to show 0/0 when Catch-Up isn't active yet.
- Updated Checklist to show 0/0 when Catch-Up isn't active yet.
- Updated expansion handling by disabling Dragonflight for now.
- Updated main window and Checklist filters to allow multiple expansions at once instead of just one.
- Updated character progress, items, quests and currencies storage to be more reliable and reduce missing or outdated data between sessions.
- Updated addon description with additional credit.
- Fixed the Knowledge column so it actually updates when you open an item that grants knowledge points.
- Fixed crashes and errors caused by missing or partially loaded item or currency data.
- Fixed several profession variants and First Crafts not being tracked or awarded correctly in the overview.
- Fixed treatise: Thalassian Treatise on Engineering.
- Fixed Weekly Quests counting all quests from the weekly rotation.
- Fixed data being reset when logging out without opening the addon first. Silly silly bugs.

## v1.2.1 - 2026-03-03

- Added new tooltips for First Craft, Darkmoon and Catch-Up.
- Updated many column and Checklist info tooltips.
- Fixed a first-login issue where progress being processed for the first time caused non-cached item issues.

## v1.2.0 - 2026-03-02

This is a massive update and there's a big chance that your character data may break.  
If that happens then I urge you to log your characters again and open your profession windows.  
Thank you to everyone who's been helping out testing, giving feedback and providing data and insight.  
If you experience any issues, reach out on [GitHub](https://github.com/DennisRas/WeeklyKnowledge) or write a comment on CurseForge.

- Added Midnight data (some data still needs to be found and/or updated).
- Added an option to remove a character from the addon via the Characters dropdown.
- Added keybindings to toggle the windows (Options -> Keybindings -> WeeklyKnowledge). Credit to narcolic for the feature (PR #85).
- Added Unique objectives for the Undermine renown quartermaster (Smaks Topskimmer). Credit to pepedressingroom for the data.
- Added Unique objectives for the Khaz Algar renown quartermaster in Karesh (Om'sirik). Credit to jcdny for the data.
- Updated Requirements tooltip to show profession skill (name and level) when an objective has a skill requirement.
- Added caching for checking completed quests/objectives to improve performance.
- Added a new category named Weekly Quest (old Artisan/Trainer columns merged).
- Added a First Craft column in the main window showing the amount of First Craft points available from your recipes.
- Added a Concentration column in the main window that tracks your concentration and estimates when it's maxed out.
- Added a main-window setting to hide characters/professions with a skill level below 25.
- Added a Repeatable column in the Checklist window.
- Added a new category filter in the Checklist window.
- Added a new section to the addon description giving credit to the awesome people! You rock <3
- Added a setting to show profession names with or without the expansion variant.
- Added chat commands: `/wk checklist` and `/wk minimap`.
- Added click-to-open for professions from the main and Checklist windows.
- Updated Character dropdown by removing the per-character checkbox (the character list is now based on toggled professions).
- Updated loading behavior so the addon only loads/updates while out of combat (you can open the windows after combat and always close them, even in combat).
- Updated Repeatable status to Catch-Up.
- Updated several location hints (many are still missing; this takes time! :-P).
- Updated Checklist window so it no longer changes size when no professions or objectives are active.
- Updated addon description.
- Fixed errors when Catch-Up currency data is missing or outdated. Fixes #80.
- Fixed errors when opening the addon during combat or in instances. Fixes #84.
- Fixed waypoints for four profession knowledge items in The Ringing Deeps (zone map changed in 11.1). Fixes #81.
- Fixed windows not staying in position after reloading/loading.
- Fixed a bug where hidden columns could completely vanish.

## v1.1.10 - 2026-01-26

- Updated TOC number to support Midnight pre-patch.

## v1.1.9 - 2025-03-13

- Updated Catch-Up objectives in the Checklist so they no longer include knowledge points available for the current week (thanks to [Belazor](https://github.com/belazor-wow/)).
- Fixed an issue where old characters without Catch-Up currency info were causing errors.

## v1.1.8 - 2025-02-26

- Added Catch-Up objectives to the Checklist (thanks to [Belazor](https://github.com/belazor-wow/)).
- Added addon category for the new AddOn List (credit: Warcraft Wiki).
- Updated performance when the addon is not shown on screen.
- Updated TOC number to support patch 11.1.
- Fixed a Darkmoon Faire-related bug (thanks to [Belazor](https://github.com/belazor-wow/)).

## v1.1.7 - 2024-10-16

- Added a new Catch-Up column (feedback is greatly appreciated!).
- Updated window frames to allow dragging partially off-screen to the sides and bottom.
- Fixed ghost characters appearing on the character list.

## v1.1.6 - 2024-09-16

_Please note: You will need to log in to your characters again to apply the following changes._

- Added a column indicator displaying unspent knowledge points.
- Added a new tooltip for the Knowledge column.
- Updated the Knowledge tooltip to show an overview of spent, unspent, and maximum knowledge points.
- Added a profession specialization overview to the Knowledge tooltip.
- Fixed knowledge points increasing after every reload.
- Fixed a bug that prevented profession skill levels from updating during gameplay.

## v1.1.5 - 2024-09-15

- Added a Character setting for hiding unused professions.

## v1.1.4 - 2024-09-11

- Fixed unused/invalid characters causing errors.
- Fixed characters not showing up in the main window or dropdown.

## v1.1.3 - 2024-09-09

- Added a Checklist setting: "Hide all uniques".
- Added a Checklist setting for hiding vendor-specific uniques.
- Added TomTom waypoint support within the Checklist window.
- Added right-click on the minimap icon to open the Checklist window.
- Updated and expanded detailed descriptions for many world uniques.
- Updated Darkmoon Faire column to automatically hide when the event is inactive.
- Updated scrolling behavior to move by 2 rows for smoother navigation.
- Updated scrollbars to be more visible, user-friendly, and less prone to bugs.
- Updated addon windows to remain behind other UI elements unless selected.
- Fixed Darkmoon Faire objectives so they correctly disappear from the Checklist when the event is inactive.
- Fixed an old issue with character sorting.
- Fixed Checklist waypoint icons not displaying properly for certain players.

## v1.1.2 - 2024-09-08

- Added a new Checklist column: Location.
- Updated most world uniques with detailed descriptions.
- Fixed an incorrect location for Jewel-Etched Tailoring Notes (thanks Shikimi).
- Fixed a major "ADDON_ACTION_BLOCKED" issue in certain combat situations (massive thanks to Linaori, Numy and Meo 🦆 from the WoWUIDev Discord for the investigation and solution).

## v1.1.1 - 2024-09-07

- Fixed the requirements for the Darkmoon Faire quest "Eyes on the Prizes" (thanks masterkain).

## v1.1.0 - 2024-09-07

A big shout-out to the WoWUIDev Discord community for all the guidance, help and testing. You rock!  
If you encounter a bug or incorrect data, please don't hesitate to reach out. Write a comment or visit the GitHub source :-)  
Thank you for your support.

- Added a Checklist window.
- Added map/location sources to objectives.
- Added hints on how to complete objectives.
- Added waypoints for objectives.
- Added requirements for objectives.
- Added tooltips in the main window showing the items missing/needed.
- Added a setting to show/hide the window border.
- Updated a couple of tooltip descriptions.
- Fixed Darkmoon values not showing on login (thanks @Lombra).
- Fixed ghost characters appearing on the list (scary!).
- Fixed scrollbars overlapping the column headers.
- Fixed column header background colors being just grey when the window color is different.
- Fixed transparent background colors not actually being transparent.

## v1.0.4 - 2024-09-04

- Fixed a weekly reset bug so character progress now resets correctly. A big shout-out to the player community in the comments for showing interest in helping fix these issues. You are much appreciated!

## v1.0.3 - 2024-09-01

- Added Realm column.
- Added setting to show/hide characters.
- Added setting to show/hide columns.
- Added setting to show/hide the minimap icon.
- Added setting to lock the minimap icon.
- Added setting to scale the main window.
- Added setting to change the base color of the main window.
- Updated addon interface with a fully rewritten design.
- Updated column sorting (temporarily disabled and will return later).
- Updated character sorting to use most recent activity for now.
- Updated tooltips to clarify whether you are finding items or doing quests.
- Fixed addon updates when you learn/unlearn a TWW profession.
- Fixed Darkmoon Faire column visibility.
- Fixed old-expansion profession characters being saved/shown.
- Fixed incorrect Darkmoon KP values.
- Fixed performance, reducing memory usage by roughly 100x.
- Fixed weekly progress reset so it now resets for all characters on weekly reset.
- Fixed missing quest from the Enchanting trainer.
- Fixed Knowledge Points calculation for Trainer quests.

## v1.0.2 - 2024-08-28

- Added support for closing the window with the Escape key.
- Added new progress tooltips with knowledge points.
- Added a command to show/hide the minimap icon.
- Updated header column with colors.
- Updated wording by renaming "Work Order" to "Artisan".
- Updated column descriptions to better clarify sources.
- Updated addon description.

## v1.0.1 - 2024-08-27

- Fixed missing libraries bug (thanks @IvViral).

## v1.0.0 - 2024-08-27

- First release <3
