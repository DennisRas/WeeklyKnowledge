---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local MISSING_INFO = Data.MISSING_INFO
local category = Enum.WK_ObjectiveCategory.FirstCraft

---@type WK_Objective[]
local objectives = {
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450246,  points = 1}, -- Beledar's Bulwark
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450238,  points = 1}, -- Charged Claymore
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450240,  points = 1}, -- Charged Crusher
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450237,  points = 1}, -- Charged Facesmasher
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450239,  points = 1}, -- Charged Halberd
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450235,  points = 1}, -- Charged Hexsword
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450241,  points = 1}, -- Charged Invoker
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450236,  points = 1}, -- Charged Runeaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450242,  points = 1}, -- Charged Slicer
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450221,  points = 1}, -- Everforged Breastplate
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450230,  points = 1}, -- Everforged Dagger
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450223,  points = 1}, -- Everforged Defender
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450228,  points = 1}, -- Everforged Gauntlets
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450234,  points = 1}, -- Everforged Greataxe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450222,  points = 1}, -- Everforged Greatbelt
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450224,  points = 1}, -- Everforged Helm
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450225,  points = 1}, -- Everforged Legplates
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450231,  points = 1}, -- Everforged Longsword
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450233,  points = 1}, -- Everforged Mace
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450227,  points = 1}, -- Everforged Pauldrons
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450220,  points = 1}, -- Everforged Sabatons
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450229,  points = 1}, -- Everforged Stabber
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450226,  points = 1}, -- Everforged Vambraces
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450232,  points = 1}, -- Everforged Warglaive
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450245,  points = 1}, -- Sanctified Steps
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450250,  points = 1}, -- Siphoning Stiletto
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450281,  points = 1}, -- Artisan Blacksmith's Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450282,  points = 1}, -- Artisan Blacksmith's Toolbox
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450279,  points = 1}, -- Artisan Leatherworker's Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450280,  points = 1}, -- Artisan Leatherworker's Toolset
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450278,  points = 1}, -- Artisan Needle Set
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450276,  points = 1}, -- Artisan Pickaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450275,  points = 1}, -- Artisan Sickle
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450277,  points = 1}, -- Artisan Skinning Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 453727,  points = 1}, -- Everburning Ignition
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 1259675, points = 1}, -- Rusting Bolted Bench
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 1259681, points = 1}, -- Shredderwheel Storage Chest
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450218,  points = 1}, -- Sanctified Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 455001,  points = 1}, -- Algari Competitor's Axe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 454998,  points = 1}, -- Algari Competitor's Dagger
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 455003,  points = 1}, -- Algari Competitor's Greatsword
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 454997,  points = 1}, -- Algari Competitor's Pickaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438921,  points = 1}, -- Algari Competitor's Plate Armguards
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438914,  points = 1}, -- Algari Competitor's Plate Breastplate
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438916,  points = 1}, -- Algari Competitor's Plate Gauntlets
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438918,  points = 1}, -- Algari Competitor's Plate Greaves
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438917,  points = 1}, -- Algari Competitor's Plate Helm
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438919,  points = 1}, -- Algari Competitor's Plate Pauldrons
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438915,  points = 1}, -- Algari Competitor's Plate Sabatons
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 438920,  points = 1}, -- Algari Competitor's Plate Waistguard
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 454999,  points = 1}, -- Algari Competitor's Scepter
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 455000,  points = 1}, -- Algari Competitor's Shield
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 455002,  points = 1}, -- Algari Competitor's Skewer
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 455004,  points = 1}, -- Algari Competitor's Sword
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450284,  points = 1}, -- Forged Framework
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450286,  points = 1}, -- Ironclaw Razorstone
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450288,  points = 1}, -- Adjustable Framework
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450255,  points = 1}, -- Ironclaw Great Mace
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450254,  points = 1}, -- Ironclaw Knuckles
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450289,  points = 1}, -- Tempered Framework
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450263,  points = 1}, -- Dredger's Developed Legplates
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450265,  points = 1}, -- Dredger's Developed Pauldrons
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450266,  points = 1}, -- Dredger's Developed Gauntlets
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450262,  points = 1}, -- Dredger's Developed Helm
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450261,  points = 1}, -- Dredger's Developed Defender
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450256,  points = 1}, -- Ironclaw Axe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450253,  points = 1}, -- Ironclaw Sword
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450274,  points = 1}, -- Proficient Blacksmith's Toolbox
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450272,  points = 1}, -- Proficient Leatherworker's Toolset
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450270,  points = 1}, -- Proficient Needle Set
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450260,  points = 1}, -- Dredger's Developed Greatbelt
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450264,  points = 1}, -- Dredger's Plate Vambraces
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450252,  points = 1}, -- Ironclaw Dirk
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450257,  points = 1}, -- Ironclaw Great Axe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450251,  points = 1}, -- Ironclaw Stiletto
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450273,  points = 1}, -- Proficient Blacksmith's Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450271,  points = 1}, -- Proficient Leatherworker's Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450217,  points = 1}, -- Charged Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450219,  points = 1}, -- Ironclaw Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450259,  points = 1}, -- Dredger's Plate Breastplate
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450268,  points = 1}, -- Proficient Pickaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450267,  points = 1}, -- Proficient Sickle
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450269,  points = 1}, -- Proficient Skinning Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450291,  points = 1}, -- Coreforged Repair Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450258,  points = 1}, -- Dredger's Plate Sabatons
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450216,  points = 1}, -- Core Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450292,  points = 1}, -- Coreforged Skeleton Key
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450287,  points = 1}, -- Ironclaw Weightstone
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450285,  points = 1}, -- Ironclaw Whetstone
  {skillLineVariantID = 2872, categoryID = category, quests = {MISSING_INFO}, spellID = 450283,  points = 1}, -- Earthen Master's Hammer
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {80350},        spellID = 439705,  points = 1}, -- Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80356},        spellID = 439712,  points = 1}, -- Bismuth Seam
  {skillLineVariantID = 2881, categoryID = category, quests = {80353},        spellID = 439709,  points = 1}, -- Rich Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80368},        spellID = 439724,  points = 1}, -- Camouflaged Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80365},        spellID = 439721,  points = 1}, -- EZ-Mine Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80359},        spellID = 439715,  points = 1}, -- Crystallized Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80362},        spellID = 439718,  points = 1}, -- Weeping Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80371},        spellID = 439727,  points = 1}, -- Webbed Bismuth
  -- {skillLineVariantID = 2881, categoryID = category, quests = {}, spellID = 439707,  points = 1},  -- Aqirite (bug?)
  {skillLineVariantID = 2881, categoryID = category, quests = {80357},        spellID = 439713,  points = 1}, -- Aqirite Seam
  {skillLineVariantID = 2881, categoryID = category, quests = {80354},        spellID = 439710,  points = 1}, -- Rich Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80369},        spellID = 439725,  points = 1}, -- Camouflaged Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80366},        spellID = 439722,  points = 1}, -- EZ-Mine Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80360},        spellID = 439716,  points = 1}, -- Crystallized Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80363},        spellID = 439719,  points = 1}, -- Weeping Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80372},        spellID = 439728,  points = 1}, -- Webbed Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80352},        spellID = 439708,  points = 1}, -- Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80358},        spellID = 439714,  points = 1}, -- Ironclaw Seam
  {skillLineVariantID = 2881, categoryID = category, quests = {80355},        spellID = 439711,  points = 1}, -- Rich Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80370},        spellID = 439726,  points = 1}, -- Camouflaged Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80367},        spellID = 439723,  points = 1}, -- EZ-Mine Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80361},        spellID = 439717,  points = 1}, -- Crystallized Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80364},        spellID = 439720,  points = 1}, -- Weeping Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80373},        spellID = 439729,  points = 1}, -- Webbed Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {92134},        spellID = 1250351, points = 1}, -- Desolate Deposit
  {skillLineVariantID = 2881, categoryID = category, quests = {92135},        spellID = 1250356, points = 1}, -- Rich Desolate Deposit
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {79906},        spellID = 435811,  points = 1}, -- Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79907},        spellID = 435812,  points = 1}, -- Lush Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79911},        spellID = 435851,  points = 1}, -- Camouflaged Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79908},        spellID = 435838,  points = 1}, -- Crystallized Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79910},        spellID = 435843,  points = 1}, -- Irradiated Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79912},        spellID = 435850,  points = 1}, -- Sporefused Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79909},        spellID = 435840,  points = 1}, -- Altered Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79913},        spellID = 435821,  points = 1}, -- Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79914},        spellID = 435829,  points = 1}, -- Lush Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79918},        spellID = 435860,  points = 1}, -- Camouflaged Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79915},        spellID = 435857,  points = 1}, -- Crystallized Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79917},        spellID = 435859,  points = 1}, -- Irradiated Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79919},        spellID = 435861,  points = 1}, -- Sporefused Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79916},        spellID = 435858,  points = 1}, -- Altered Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79920},        spellID = 435822,  points = 1}, -- Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79921},        spellID = 435830,  points = 1}, -- Lush Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79925},        spellID = 435866,  points = 1}, -- Camouflaged Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79922},        spellID = 435862,  points = 1}, -- Crystallized Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79924},        spellID = 435865,  points = 1}, -- Irradiated Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79926},        spellID = 435867,  points = 1}, -- Sporefused Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79923},        spellID = 435864,  points = 1}, -- Altered Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79927},        spellID = 435823,  points = 1}, -- Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79928},        spellID = 435834,  points = 1}, -- Lush Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79931},        spellID = 435872,  points = 1}, -- Camouflaged Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79929},        spellID = 435870,  points = 1}, -- Crystallized Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79930},        spellID = 435871,  points = 1}, -- Irradiated Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79932},        spellID = 435873,  points = 1}, -- Sporefused Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79933},        spellID = 435826,  points = 1}, -- Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79934},        spellID = 435836,  points = 1}, -- Lush Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79937},        spellID = 435879,  points = 1}, -- Camouflaged Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79935},        spellID = 435877,  points = 1}, -- Crystallized Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79936},        spellID = 435878,  points = 1}, -- Irradiated Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79938},        spellID = 435880,  points = 1}, -- Sporefused Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {92132},        spellID = 1250314, points = 1}, -- Phantom Bloom
  {skillLineVariantID = 2877, categoryID = category, quests = {92133},        spellID = 1250317, points = 1}, -- Lush Phantom Bloom
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {88475},        spellID = 1225343, points = 1}, -- Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88476},        spellID = 1225349, points = 1}, -- Rich Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88480},        spellID = 1225350, points = 1}, -- Refulgent Copper Seam
  {skillLineVariantID = 2916, categoryID = category, quests = {88479},        spellID = 1225354, points = 1}, -- Primal Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88487},        spellID = 1225351, points = 1}, -- Lightfused Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88486},        spellID = 1225353, points = 1}, -- Wild Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88463},        spellID = 1225352, points = 1}, -- Voidbound Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88477},        spellID = 1225347, points = 1}, -- Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88478},        spellID = 1225365, points = 1}, -- Rich Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88481},        spellID = 1225366, points = 1}, -- Umbral Tin Seam
  {skillLineVariantID = 2916, categoryID = category, quests = {88469},        spellID = 1225369, points = 1}, -- Primal Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88488},        spellID = 1225367, points = 1}, -- Lightfused Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88485},        spellID = 1225368, points = 1}, -- Wild Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88470},        spellID = 1225370, points = 1}, -- Voidbound Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88471},        spellID = 1225348, points = 1}, -- Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88491},        spellID = 1225355, points = 1}, -- Rich Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88466},        spellID = 1225357, points = 1}, -- Brilliant Silver Seam
  {skillLineVariantID = 2916, categoryID = category, quests = {88490},        spellID = 1225361, points = 1}, -- Primal Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88484},        spellID = 1225359, points = 1}, -- Lightfused Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88472},        spellID = 1225363, points = 1}, -- Wild Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88465},        spellID = 1225362, points = 1}, -- Voidbound Brilliant Silver
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {87729},        spellID = 1223099, points = 1}, -- Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87730},        spellID = 1223148, points = 1}, -- Lush Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87731},        spellID = 1224883, points = 1}, -- Lightfused Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87734},        spellID = 1224898, points = 1}, -- Voidbound Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87733},        spellID = 1224888, points = 1}, -- Primal Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87732},        spellID = 1224893, points = 1}, -- Wild Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87735},        spellID = 1223135, points = 1}, -- Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87736},        spellID = 1223151, points = 1}, -- Lush Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87737},        spellID = 1224886, points = 1}, -- Lightfused Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87740},        spellID = 1224901, points = 1}, -- Voidbound Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87739},        spellID = 1224891, points = 1}, -- Primal Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87738},        spellID = 1224896, points = 1}, -- Wild Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87741},        spellID = 1223137, points = 1}, -- Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87742},        spellID = 1223150, points = 1}, -- Lush Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87743},        spellID = 1224885, points = 1}, -- Lightfused Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87746},        spellID = 1224900, points = 1}, -- Voidbound Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87745},        spellID = 1224890, points = 1}, -- Primal Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87744},        spellID = 1224895, points = 1}, -- Wild Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87747},        spellID = 1223138, points = 1}, -- Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87748},        spellID = 1223146, points = 1}, -- Lush Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87749},        spellID = 1224882, points = 1}, -- Lightfused Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87752},        spellID = 1224897, points = 1}, -- Voidbound Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87751},        spellID = 1224887, points = 1}, -- Primal Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87750},        spellID = 1224892, points = 1}, -- Wild Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87753},        spellID = 1223139, points = 1}, -- Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87755},        spellID = 1224884, points = 1}, -- Lightfused Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87754},        spellID = 1223149, points = 1}, -- Lush Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87758},        spellID = 1224899, points = 1}, -- Voidbound Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87757},        spellID = 1224889, points = 1}, -- Primal Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87756},        spellID = 1224894, points = 1}, -- Wild Mana Lily
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
