local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)
if not L then return end

-- Core strings
L["WeeklyReset"] = "Weekly Reset: Good job! Progress of your characters have been reset for a new week.";

L["TooltipLine1"] = "|cff00ff00Left click|r to open WeeklyKnowledge.";
L["TooltipLine2"] = "|cff00ff00Right click|r to open the Checklist.";
L["TooltipLine3"] = "|cff00ff00Drag|r to move this icon";
L["TooltipLocked"] = " |cffff0000(locked)|r";

-- Main strings
L["CloseTheWindow"] = "Close the window";

L["Settings"] = "Settings"
L["SettingsDesc"] = "Let's customize things a bit";
L["ShowTheMinimapButton"] = "Show the minimap button";
L["ShowMinimapIconDesc"] = "It does get crowded around the minimap sometimes.";
L["LockMinimapIcon"] = "Lock the minimap button";
L["LockMinimapIconDesc"] = "No more moving the button around accidentally!";

L["BackgroundColor"] = "Background color";
L["ShowTheBorder"] = "Show the border";
L["Window"] = "Window";
L["Scaling"] = "Scaling";

L["Characters"] = "Characters";
L["CharactersDesc"] = "Enable/Disable your characters.";

L["Columns"] = "Columns";
L["ColumnsDesc"] = "Enable/Disable table columns.";

L["Checklist"] = "Checklist";
L["ChecklistDesc"] = "Toggle the Checklist window";

L["Name"] = true;
L["NameDesc"] = "Your characters.";

L["Realm"] = true;
L["RealmDesc"] = "Realm names.";

L["Profession"] = "Profession";
L["ProfessionDesc"] = "Your professions";

L["Skill"] = true
L["SkillDesc"] = "Current skill levels.";

L["Knowledge"] = true;
L["KnowledgePoints"] = "Knowledge Points"
L["KnowledgePointsDesc"] = "Current knowledge gained.";

L["PointsSpentAt"] = "Points Spent:";
L["PointsUnspentAt"] = "Points Unspent:";
L["Locked"] = true;
L["CanUnlock"] = "Can Unlock";
L["MaxAt"] = "Max:";
L["SpecializationsAt"] = "Specializations:";

L["Items"] = "Items:";
L["Quests"] = "Quests:";
L["KnowledgePointsAt"] = "Knowledge Points:";

L["ItemLinkLoading"] = "Loading...";

L["Catch-Up"] = true;
L["Catch-UpDesc"] = "Keep track of your Knowledge Points progress and catch up on points from previous weeks.\n\nDo note that Treatise points are not included in calculations for this week.";

L["NoData"] = "No data";
L["NoDataDesc"] = "Log in to fetch the data for this character.";

L["WeeklyPointsAt"] = "Weekly Points:";
L["Catch-UpPointsAt"] = "Catch-Up Points:";
L["TotalAt"] = "Total:";

L["UnlockCatch-UpDesc"] = "Unlock Catch-Up this week:";
L["fmtPoints"] = "%s Points";
L["Catch-UpSpc"] = "Catch-Up ";
L["Gathering"] = true;
L["PatronOrders"] = "Patron Orders";

-- Data strings
L["Uniques"] = true;
L["Uniques_Desc"] = "These are one-time knowledge point items found in treasures around the world and sold by Artisan/Renown/Kej vendors.\n\nRepeatable: ";

L["Weekly"] = true;
L["NonRepeatable"] = "No";

L["Treatise"] = true;
L["Treatise_Desc"] = "These can be crafted by scribers. Send a Crafting Order if you don't have the inscription profession.\n\nRepeatable: ";

L["Artisan"] = true;
L["ArtisanQuest_Desc"] = "Quest: Kala Clayhoof from Artisan's Consortium wants you to fulfill Crafting Orders.\n\nRepeatable: ";

L["Treasure"] = true;
L["Treasure_Desc"] = "These are randomly looted from treasures and dirt around the world.\n\nRepeatable: ";

L["Gathering"] = true;
L["Gathering_Desc"] = "These are randomly looted from gathering nodes around the world. You may (not confirmed) randomly find additional items beyond the weekly limit.\n\nThese are also looted from Disenchanting.\n\nRepeatable: ";

L["Trainer"] = true;
L["TrainerQuest_Desc"] = "Quest: Complete a quest at your profession trainer.\n\nRepeatable: ";

L["Darkmoon"] = true;
L["DarkmoonQuest_Desc"] = "Quest: Complete a quest at the Darkmoon Faire.\n\nRepeatable: ";
L["Monthly"] = true;

-- Data.Professions
L["Alchemy"] = true
L["Blacksmithing"] = true
L["Enchanting"] = true
L["Engineering"] = true
L["Herbalism"] = true
L["Inscription"] = true
L["Jewelcrafting"] = true
L["Leatherworking"] = true
L["Mining"] = true
L["Skinning"] = true
L["Tailoring"] = true

-- Data.Objectives hints

L["Vendor_Lyrendal_Hint"] = "This item can be purchased from the vendor Lyrendal in Dornogal."
L["Vendor_Siesbarg_Hint"] = "This item can be purchased from the vendor Siesbarg in City of Threads."
L["Vendor_Auditor_Balwurz_Hint"] = "This item can be purchased from the vendor Auditor Balwurz in Dornogal."
L["Vendor_Rakka_Hint"] = "This item can be purchased from the vendor Rakka in City of Threads."
L["Vendor_Iliani_Hint"] = "This item can be purchased from the vendor Iliani in City of Threads."
L["Vendor_Rukku_Hint"] = "This item can be purchased from the vendor Rukku in City of Threads."
L["Vendor_Waxmonger_Squick_Hint"] = "This item can be purchased from the vendor Waxmonger Squick in The Ringing Deeps."
L["Vendor_Llyot_hint"] = "This item can be purchased from the vendor Llyot in City of Threads."
L["Vendor_Auralia_Steelstrike_Hint"] = "This item can be purchased from the vendor Auralia Steelstrike in Hallowfall."
L["Vendor_Nuel_Prill_Hint"] = "This item can be purchased from the vendor Nuel Prill in City of Threads."
L["Vendor_Alvus_Valavulu_Hint"] = "This item can be purchased from the vendor Alvus Valavulu in City of Threads."
L["Vendor_Kama_Hint"] = "This item can be purchased from the vendor Kama in City of Threads."
L["Vendor_Saaria_Hint"] = "This item can be purchased from the vendor Saaria in City of Threads."

L["Crafting_Order_Inscription_Hint"] = "Place a crafting order if you can't craft this yourself with Inscription."
L["Treasures_And_Dirt_Hint"] = "These are randomly looted from treasures and dirt around the world."
L["Object_Location_Hint"] = "This item can be found in an object on the location below."
L["Quest_Kala_Clayhoof_Hint"] = "Complete a quest from Kala Clayhoof in the Artisan's Consortium."

L["Randomly_Looted_Disenchanting_Hint"] = "These are randomly looted from disenchanting items."
L["Randomly_Looted_Herbs_Hint"] = "These are randomly looted from herbs around the world."
L["Randomly_Looted_Mining_Hint"] = "These are randomly looted from mining nodes around the world."
L["Randomly_Looted_Skinning_Hint"] = "These are randomly looted from skinning nodes around the world."

L["Talk_Sylannia_Darkmoon_Quest_29506_Hint"] = "Talk to |cff00ff00Sylannia|r at the Darkmoon Faire and complete the quest |cffffff00A Fizzy Fusion|r."
L["Talk_Yebb_Neblegear_Darkmoon_Quest_29508_Hint"] = "Talk to |cff00ff00Yebb Neblegear|r at the Darkmoon Faire and complete the quest |cffffff00Baby Needs Two Pair of Shoes|r.\n\nHint: There is an anvil behind the heirloom tent."
L["Talk_Sayge_Darkmoon_Quest_29510_Hint"] = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Putting Trash to Good Use|r."
L["Talk_Rinling_Darkmoon_Quest_29511_Hint"] = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Talkin' Tonks|r."
L["Talk_Chronos_Darkmoon_Quest_29514_Hint"] = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Herbs for Healing|r."
L["Talk_Sayge_Darkmoon_Quest_29515_Hint"] = "Talk to |cff00ff00Sayge|r at the Darkmoon Faire and complete the quest |cffffff00Writing the Future|r"
L["Talk_Chronos_Darkmoon_Quest_29516_Hint"] = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Keeping the Faire Sparkling|r."
L["Talk_Rinling_Darkmoon_Quest_29517_Hint"] = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Eyes on the Prizes|r."
L["Talk_Rinling_Darkmoon_Quest_29518_Hint"] = "Talk to |cff00ff00Rinling|r at the Darkmoon Faire and complete the quest |cffffff00Rearm, Reuse, Recycle|r."
L["Talk_Chronos_Darkmoon_Quest_29519_Hint"] = "Talk to |cff00ff00Chronos|r at the Darkmoon Faire and complete the quest |cffffff00Tan My Hide|r."
L["Talk_Selina_Dourman_Darkmoon_Quest_29520_Hint"] = "Talk to |cff00ff00Selina Dourman|r at the Darkmoon Faire and complete the quest |cffffff00Banners, Banners Everywhere!|r."

L["Talk_Enchanting_Trainer_Hint"] = "Talk to your enchanting trainer |cff00ff00Nagad|r and complete the quest."
L["Talk_Herbalism_Trainer_Hint"] = "Talk to your herbalism trainer |cff00ff00Akdan|r and complete the quest."
L["Talk_Mining_Trainer_Hint"] = "Talk to your mining trainer |cff00ff00Tarib|r and complete the quest."
L["Talk_Skinning_Trainer_Hint"] = "Talk to your skinning trainer |cff00ff00Ginnad|r and complete the quest."

L["Item_226265_Hint"] = "This item is a keg behind the pillars next to the gate."
L["Item_226266_Hint"] = "This item is a metal frame found on top of a big chest."
L["Item_226267_Hint"] = "This item is a bottle found on the table inside the building on the bottom floor."
L["Item_226268_Hint"] = "This item is a rod found next to the forge inside the building on the bottom floor."
L["Item_226269_Hint"] = "This item is a bottle found on the table near the fountain."
L["Item_226270_Hint"] = "This item is a mortar found on the table inside the orphanage building."
L["Item_226271_Hint"] = "This item is a bottle found on the desk inside the building."
L["Item_226272_Hint"] = "This item is a vial found on the broken table in the building."
L["Item_226276_Hint"] = "This item is an anvil found inside the building."
L["Item_226277_Hint"] = "This item is a hammer found on a cube."
L["Item_226278_Hint"] = "This item is a hammer vise found next to the forge."
L["Item_226279_Hint"] = "This item is a chisel found on the ground next to the forge."
L["Item_226280_Hint"] = "This item is an anvil found on the table."
L["Item_226281_Hint"] = "This item is a pair of tongs found on the table."
L["Item_226282_Hint"] = "This item is a crate found on the floor."
L["Item_226283_Hint"] = "This item is a brush found on the table inside the building."
L["Item_226284_Hint"] = "This item is a bottle found on a table."
L["Item_226285_Hint"] = "This item is leaning against a wooden pillar next to Clerk Gretal."
L["Item_226286_Hint"] = "This item is an orb found on the ground."
L["Item_226287_Hint"] = "This item is a bottle found on a table inside the building."
L["Item_226288_Hint"] = "This item is a candle found on a crate inside the building."
L["Item_226289_Hint"] = "This item is a scroll found on a table inside the building."
L["Item_226290_Hint"] = "This item is a book found on a table."
L["Item_226291_Hint"] = "This item is a purple shard found on the left table."
L["Item_226292_Hint"] = "This item is a wrench found on the table in the building."
L["Item_226293_Hint"] = "This item can be found on the table behind Madam Goya."
L["Item_226294_Hint"] = "This item is a bomb on a crate next to the rails."
L["Item_226295_Hint"] = "This item is a scroll found on the floor behind the table inside the building."
L["Item_226296_Hint"] = "This item is a bag found at the top of the stairs."
L["Item_226297_Hint"] = "This item is a box found on the airship behind the dungeon entrance."
L["Item_226298_Hint"] = "This item is a mechanical spider found on the table at the back of the inn."
L["Item_226299_Hint"] = "This item is a canister found on the floor next to the harpoon."
L["Item_226300_Hint"] = "This item is a flower found in a bed of flowers."
L["Item_226301_Hint"] = "This item is a scythe found at the bottom of the tree."
L["Item_226302_Hint"] = "This item is a fork found on the table inside the building."
L["Item_226303_Hint"] = "This item is a knife found on the ground."
L["Item_226304_Hint"] = "This item is a trowel found on the ground."
L["Item_226305_Hint"] = "This item is a pair of tongs found next to the stairs."
L["Item_226306_Hint"] = "This item is a flower found on the ground under the statue."
L["Item_226307_Hint"] = "This item is a shovel found on the desk."
L["Item_226308_Hint"] = "This item is a quill found on the shelf in the back of the auction house."
L["Item_226309_Hint"] = "This item is a pen found on the shelf in the building."
L["Item_226310_Hint"] = "This item is a scroll found on the table inside the building."
L["Item_226311_Hint"] = "This item is a pot found on the table inside the building."
L["Item_226312_Hint"] = "This item is a pen found on the table at the top of the stairs."
L["Item_226313_Hint"] = "This item is a chisel found on the table on the top floor inside the building."
L["Item_226314_Hint"] = "This item is a scroll found on the floor of the center main platform."
L["Item_226315_Hint"] = "This item is an ink well found on the desk inside the building."
L["Item_226324_Hint"] = "This item is a tool found on the rack inside the building."
L["Item_226325_Hint"] = "This item is a knife found on a hay bale inside the building."
L["Item_226326_Hint"] = "This item is a bottle found on the shelf inside the building."
L["Item_226327_Hint"] = "This item is a tool found on the table inside the building."
L["Item_226328_Hint"] = "This item is a pair of tongs found on the table inside the building."
L["Item_226329_Hint"] = "This item is a tool found on a barrel."
L["Item_226330_Hint"] = "This item is a mallet found on the table inside the building."
L["Item_226331_Hint"] = "This item is a knife found on the desk."
L["Item_226332_Hint"] = "This item is a gavel found on the table."
L["Item_226333_Hint"] = "This item is a chisel found on the crystal statue."
L["Item_226334_Hint"] = "This item is a shovel found on the ground."
L["Item_226335_Hint"] = "This item is ore found on the ground."
L["Item_226336_Hint"] = "This item is a drill found on the table under the building."
L["Item_226337_Hint"] = "This item is a tool found on the table behind the mining trainer."
L["Item_226338_Hint"] = "This item is a crusher found on the desk near the forge."
L["Item_226339_Hint"] = "This item is a cart found on the ground between the flowers and roots."
L["Item_226348_Hint"] = "This item is a knife found on the table in the back of the building."
L["Item_226349_Hint"] = "This item is a tape measure found on the table."
L["Item_226350_Hint"] = "This item is a pin found on the shelf in the back right room of the inn."
L["Item_226351_Hint"] = "This item is a pair of scisssors found on the table."
L["Item_226352_Hint"] = "This item is a cutter found on the table."
L["Item_226353_Hint"] = "This item is a protractor found on a crate inside the building."
L["Item_226354_Hint"] = "This item is a quilt found inside the building to the left."
L["Item_226355_Hint"] = "This item is a pincushian found on the desk."

-- Interface strings

-- Checklist strings
L["Checklist"] = true

L["Profession"] = true
L["Category"] = true
L["Location"] = true
L["Progress"] = true
L["Points"] = true
L["Objective"] = true

L["HideInCombat"] = "Hide in combat";
L["HideInDungeons"] = "Hide in dungeons";
L["HideCompletedObjectives"] = "Hide completed objectives";
L["HideAllUniques"] = "Hide all Uniques";
L["HideAllUniquesDesc"] = "Hide all objectives from the Uniques category.";
L["HideVendorUniques"] = "Hide vendor Uniques";
L["HideVendorUniquesDesc"] = "Hide Uniques that are purchased from a vendor.";

L["ToggleObjectives"] = "Toggle objectives";
L["ToggleObjectivesDesc"] = "Expand/Collapse the list.";

L["ZeroProfCount"] = "It does not look like you have any TWW professions.";
L["LookPatronOrders"] = "Good job! You are done :-)\nMake sure to take a look at your Patron Orders!";

L["ShiftClickToLinkToChat"] = "<Shift Click to Link to Chat>";

L["DoYouKnowTheWay"] = "Do you know the way?";
L["LocationAt"] = "Location:";
L["CoordinatesAt"] = "Coordinates:";
L["RequirementsA"] = "Requirements:";

L["ClickToPlaceAPinOnTheMap"] = "<Click to place a pin on the map>";
L["ShiftClickToShareAPinInChat"] = "<Shift click to share pin in chat>";
L["AltClickToPlaceAWaypoint"] = "<Alt click to place a TomTom waypoint>";

-- Types strings
