# Changelog

## v1.2.3 - 2026-03-06

### Added

- Added more hints to unique items.

### Fixed

- Fixed an issue with bugged text under requirements in the checklist tooltips. Fixes #107
- Fixed an issue with some characters having no itemCount data. Fixes #110 (Thank you Jinatha for the report).

## v1.2.2 - 2026-03-04

### Added

- Added an introduction message for first time users.
- Added missing skinning trainer quest.
- Added hints to several unique items.

### Updated

- Catch-Up column now shows 0/0 when Catch-Up isn't active yet.
- Checklist now shows 0/0 when Catch-Up isn't active yet.
- Disable Dragonflight for now.
- You can now filter the main window and checklist by multiple expansions at once instead of just one.
- Character progress, items, quests and currencies are now stored and updated in a more reliable way to reduce missing or outdated data between sessions.
- Updated addon description with additional credit.

### Fixed

- The column Knowledge now actually updates when you open an item that gives knowledge points.
- Reduced crashes and errors caused by missing or partially loaded item or currency data.
- Fixed issues where some profession variants and first crafts were not tracked or awarded correctly in the overview.
- Fixed treatise: Thalassian Treatise on Engineering.
- Fixed an issue with Weekly Quests counting all quests from the weekly rotation.
- Fixed an issue with data being reset when logging out without opening the addon first. Silly silly bugs.

## v1.2.1 - 2026-03-03

### Added

- Added new tooltips for First Craft, Darkmoon and Catch-Up.

### Updated

- Updated the tooltips for many of the columns and Checklist info.

### Fixed

- Fixed an issue during first login: Progress being processed for the first time was causing non-cached item issues.

## v1.2.0 - 2026-03-02

This is a massive update and there's a big chance that your character data may break.  
If that happens then I urge you to log your characters again and open your profession windows.  
Thank you to everyone who's been helping out testing, giving feedback and providing data and insight.  
If you experience any issues, reach out on [https://github.com/DennisRas/WeeklyKnowledge](https://github.com/DennisRas/WeeklyKnowledge) or write a comment on CurseForge.

### Added

- Added Midnight data - Some data still need to be found and/or updated.
- Added a new option to remove a character from the addon via the Characters dropdown.
- Added keybindings to toggle the windows (Options -> Keybindings -> WeeklyKnowledge). Credit to narcolic for the feature (PR #85).
- Added Unique objectives for the Undermine renown quartermaster (Smaks Topskimmer). Credit to pepedressingroom for the data.
- Added Unique objectives for the Khaz Algar renown quartermaster in Karesh (Om'sirik). Credit to jcdny for the data.
- Requirements tooltip now shows profession skill (name and level) when an objective has a skill requirement.
- Added caching for checking completed quests/objectives in order to improve performance.
- Added a new category named Weekly Quest; This is the old Artisan/Trainer columns merged.
- Added a new column in the Main window: First Craft; This will show you the amount of first craft points available from your profession recipes.
- ADded a new column in the Main window: Concentration; This will keep track of your concentration with an estimate of when it's maxed out.
- Added a new setting in the Main window: You can now hide characters/professions with a skill level below 25.
- Added a new column in the Checklist window: Repeatable.
- Added a new category filter in the Checklist window.
- Added a new section to the addon description giving credit to the awesome people! You rock <3
- Added a new setting to show the profession names with or without the expansion variant.
- Added new chat commands: /wk checklist and /wk minimap
- You can now click the profession in the columns and Checklist to open your profession.

### Updated

- Removed the per-character checkbox in the Character dropdown. The character list is now based on the toggled professions.
- The addon now only loads/updates while out of combat. You can open the windows after combat. You can always close them, even in combat.
- Updated the Repeatable status to Catch-Up
- Updated some location hints - Yeah this takes a lot of time and many are still missing :-P
- Checklist window no longer changes window size when no professions or objectives are active.
- Updated the addon description.

### Fixed

- Fixed error when catch-up currency data is missing or outdated. Fixes #80.
- Fixed error when opening the addon during combat or in instances. Fixes #84.
- Corrected waypoints for four profession knowledge items in The Ringing Deeps (zone map changed in 11.1). Fixes #81.
- Fixed an issue with windows not staying in position after reloading/loading.
- Fixed a bug with hidden columns completely vanishing

## v1.1.10 - 2026-01-26

### Updated

- Updated the TOC number to support Midnight pre-patch

## v1.1.9 - 2025-03-13

### Updated

- Catch-Up objectives in the Checklist no longer include knowledge points available for the current week (Thanks to [Belazor](https://github.com/belazor-wow/))

### Fixed

- Resolved an issue where old characters without Catch-Up currency info were causing errors

## v1.1.8 - 2025-02-26

### Added

- Added Catch-Up objectives to the Checklist (Thanks to [Belazor](https://github.com/belazor-wow/))
- Added addon category for the new AddOn List. Credit: Warcraft Wiki

### Updated

- Improved the performance of the addon when not shown on screen
- Updated the TOC number to support patch 11.1

### Fixed

- Fixed a bug related to the Darkmoon Faire (Thanks to [Belazor](https://github.com/belazor-wow/))

## v1.1.7 - 2024-10-16

### Added

- Introduced a new Catch-Up column. Feedback is greatly appreciated!

### Updated

- Window frames can now be partially dragged off-screen to the sides and bottom.

### Fixed

- Resolved an issue where ghost characters were appearing on the character list.

## v1.1.6 - 2024-09-16

_Please note: You will need to log in to your characters again to apply the following changes._

### Added

- Introduced a column indicator displaying unspent knowledge points
- Added a new tooltip for the Knowledge column
- The new Knowledge tooltip now shows an overview of spent, unspent, and maximum knowledge points
- Added a profession specialization overview to the Knowledge tooltip

### Fixed

- Resolved an issue where knowledge points would increase after every reload
- Fixed a bug that prevented profession skill levels from updating during gameplay

## v1.1.5 - 2024-09-15

### Added

- Added a new Character setting for hiding unused professions

## v1.1.4 - 2024-09-11

### Fixed

- Fixed a bug with unused/invalid characters causing errors
- Fixed a bug with characters not showing up in the main window or dropdown

## v1.1.3 - 2024-09-09

### Added

- Introduced a new Checklist setting: "Hide all uniques"
- Added a Checklist setting for hiding vendor-specific uniques
- Integrated support for TomTom waypoints within the Checklist window
- Right clicking the minimap icon will now open the Checklist window

### Updated

- Expanded and improved detailed descriptions for many world uniques
- The Darkmoon Faire column now automatically hides when the event is inactive
- Adjusted scrolling behavior to move by 2 rows for smoother navigation
- Redesigned scrollbars to be more visible, user-friendly, and less prone to bugs
- Addon windows now remain behind other UI elements unless selected

### Fixed

- Darkmoon Faire objectives will now correctly disappear from the checklist when the event is inactive
- Resolved an old issue with character sorting
- Fixed an issue where checklist waypoint icons weren't displaying properly for certain players

## v1.1.2 - 2024-09-08

### Added

- Added a new checklist column: Location

### Updated

- Added detailed descriptions to most world uniques

### Fixed

- Fixed an incorect location for Jewel-Etched Tailoring Notes (Thanks Shikimi)
- Fixed a major issue of "ADDON_ACTION_BLOCKED" in certain situations while in combat (A massive thanks to Linaori, Numy and Meo 🦆 from the WoWUIDev Discord server for helping with the investigation and solution)

## v1.1.1 - 2024-09-07

### Fixed

- Adjusted the requirements for the Darkmoon Faire quest "Eyes on the Prizes" (Thanks masterkain)

## v1.1.0 - 2024-09-07

A big shout-out to the WoWUIDev Discord community for all the guidance, help and testing. You rock!
If you encounter a bug or incorrect data, please don't hesitate to reach out. Write a comment or visit the GitHub source :-)
Thank you for your support.

### Added

- Added a new Checklist window
- Added map/location sources to objectives
- Added hints on how to complete objectives
- Added waypoints for objectives
- Added requirements for objectives
- You can now see the items missing/needed in the main window tooltips
- New Setting: Show/hide window border

### Updated

- Updated a couple of tooltip descriptions

### Fixed

- Fixed a bug with Darkmoon values not showing on login (Thansk @Lombra)
- Fixed a bug with ghost characters showing up on the list (scary!)
- Scrollbars no longer overlap the column headers
- Background color of column headers are no longer just grey if window color is different
- Fixed a bug with transparent background colors not being transparent

## v1.0.4 - 2024-09-04

### Fixed

- Fixed a bug with weekly reset. Character progress should now be reset. A big shout-out to the player community in the comments for showing interest in helping fix these issues. You are much appreciated!

## v1.0.3 - 2024-09-01

### Added

- New column: Realm
- New setting: You can now show/hide characters
- New setting: You can now show/hide columns
- New setting: You can now show/hide the minimap icon
- New setting: You can now lock the minimap icon
- New setting: You can now scale the main window
- New setting: You can now change the base color of the main window

### Updated

- Addon interface has been fully rewritten with a new design
- Column sorting is disabled for now. Will be back soon!
- Characters are sorted by most recent activity for now.
- Tooltips now show whether you are finding items or doing quests

### Fixed

- Addon now updates when you learn/unlearn a TWW profession
- Darkmoon Faire column is now visible
- Characters with old expansion professions are no longer saved/shown
- Fixed incorrect Darkmoon KP values
- The addon performance has been improved using 100x less memory
- Weekly progress will now reset for all characters on weekly reset
- Added missing quest from the Enchanting trainer
- Knowledge Points are now calculated properly for Trainer quests

## v1.0.2 - 2024-08-28

### Added

- You can now close the window with the Escape key
- Added new progress tooltips with knowledge points
- Added a new command to show/hide the minimap icon

### Updated

- Added colors to the header column
- Renamed "Work Order" to "Artisan"
- Rewritten column descriptions to clarify the sources
- Updated the addon description

## v1.0.1 - 2024-08-27

### Fixed

- Fixed a bug with missing libraries - Thanks @IvViral

## v1.0.0 - 2024-08-27

- First release <3
