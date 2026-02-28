---@type string
local addonName = select(1, ...)
---@class WK_Addon
local addon = select(2, ...)

---@class WK_Data
local Data = addon.Data
local Utils = addon.Utils
local MISSING_INFO = Data.MISSING_INFO
local category = Enum.WK_ObjectiveCategory.FirstCraft

-- {skillLineVariantID = 2918, categoryID = category, quests = {}, spellID =

---@type WK_Objective[]
local objectives = {
  -- The War Within: Alchemy
  {skillLineVariantID = 2871, categoryID = category, quests = {81132}, spellID = 433087,  points = 1}, -- Formulated Courage
  {skillLineVariantID = 2871, categoryID = category, quests = {81129}, spellID = 432204,  points = 1}, -- Harmonious Horticulture
  {skillLineVariantID = 2871, categoryID = category, quests = {84492}, spellID = 462121,  points = 1}, -- Bubbling Mycobloom Culture
  {skillLineVariantID = 2871, categoryID = category, quests = {84493}, spellID = 462122,  points = 1}, -- Petal Powder
  {skillLineVariantID = 2871, categoryID = category, quests = {81095}, spellID = 430590,  points = 1}, -- Algari Healing Potion
  {skillLineVariantID = 2871, categoryID = category, quests = {81096}, spellID = 430591,  points = 1}, -- Algari Mana Potion
  {skillLineVariantID = 2871, categoryID = category, quests = {81097}, spellID = 430592,  points = 1}, -- Cavedweller's Delight
  {skillLineVariantID = 2871, categoryID = category, quests = {81098}, spellID = 430593,  points = 1}, -- Slumbering Soul Serum
  {skillLineVariantID = 2871, categoryID = category, quests = {81101}, spellID = 430596,  points = 1}, -- Grotesque Vial
  {skillLineVariantID = 2871, categoryID = category, quests = {81104}, spellID = 430599,  points = 1}, -- Tempered Potion
  {skillLineVariantID = 2871, categoryID = category, quests = {81103}, spellID = 430598,  points = 1}, -- Frontline Potion
  {skillLineVariantID = 2871, categoryID = category, quests = {81105}, spellID = 430600,  points = 1}, -- Potion of the Reborn Cheetah
  {skillLineVariantID = 2871, categoryID = category, quests = {81102}, spellID = 430597,  points = 1}, -- Potion of Unwavering Focus
  {skillLineVariantID = 2871, categoryID = category, quests = {81099}, spellID = 430594,  points = 1}, -- Draught of Silent Footfalls
  {skillLineVariantID = 2871, categoryID = category, quests = {81100}, spellID = 430595,  points = 1}, -- Draught of Shocking Revelations
  {skillLineVariantID = 2871, categoryID = category, quests = {81109}, spellID = 430604,  points = 1}, -- Flask of Tempered Mastery
  {skillLineVariantID = 2871, categoryID = category, quests = {81108}, spellID = 430603,  points = 1}, -- Flask of Tempered Versatility
  {skillLineVariantID = 2871, categoryID = category, quests = {81107}, spellID = 430602,  points = 1}, -- Flask of Tempered Swiftness
  {skillLineVariantID = 2871, categoryID = category, quests = {81106}, spellID = 430601,  points = 1}, -- Flask of Tempered Aggression
  {skillLineVariantID = 2871, categoryID = category, quests = {81110}, spellID = 430605,  points = 1}, -- Flask of Alchemical Chaos
  {skillLineVariantID = 2871, categoryID = category, quests = {81116}, spellID = 430612,  points = 1}, -- Flask of Saving Graces
  {skillLineVariantID = 2871, categoryID = category, quests = {81115}, spellID = 430611,  points = 1}, -- Vicious Flask of the Wrecking Ball
  {skillLineVariantID = 2871, categoryID = category, quests = {81112}, spellID = 430607,  points = 1}, -- Vicious Flask of Classical Spirits
  {skillLineVariantID = 2871, categoryID = category, quests = {81113}, spellID = 430608,  points = 1}, -- Vicious Flask of Honor
  {skillLineVariantID = 2871, categoryID = category, quests = {81119}, spellID = 430615,  points = 1}, -- Phial of Truesight
  {skillLineVariantID = 2871, categoryID = category, quests = {81121}, spellID = 430617,  points = 1}, -- Phial of Bountiful Seasons
  {skillLineVariantID = 2871, categoryID = category, quests = {81118}, spellID = 430614,  points = 1}, -- Phial of Concentrated Ingenuity
  {skillLineVariantID = 2871, categoryID = category, quests = {81120}, spellID = 430616,  points = 1}, -- Phial of Enhanced Ambidexterity
  {skillLineVariantID = 2871, categoryID = category, quests = {81142}, spellID = 449573,  points = 1}, -- Mercurial Coalescence
  {skillLineVariantID = 2871, categoryID = category, quests = {81143}, spellID = 449574,  points = 1}, -- Ominous Coalescence
  {skillLineVariantID = 2871, categoryID = category, quests = {81144}, spellID = 449575,  points = 1}, -- Volatile Coalescence
  {skillLineVariantID = 2871, categoryID = category, quests = {81122}, spellID = 430618,  points = 1}, -- Mercurial Blessings
  {skillLineVariantID = 2871, categoryID = category, quests = {81126}, spellID = 430622,  points = 1}, -- Ominous Call
  {skillLineVariantID = 2871, categoryID = category, quests = {81125}, spellID = 430621,  points = 1}, -- Volatile Stone
  {skillLineVariantID = 2871, categoryID = category, quests = {81123}, spellID = 430619,  points = 1}, -- Mercurial Storms
  {skillLineVariantID = 2871, categoryID = category, quests = {81124}, spellID = 430620,  points = 1}, -- Volatile Weaving
  {skillLineVariantID = 2871, categoryID = category, quests = {81127}, spellID = 430623,  points = 1}, -- Ominous Gloom
  {skillLineVariantID = 2871, categoryID = category, quests = {81140}, spellID = 449571,  points = 1}, -- Mercurial Herbs
  {skillLineVariantID = 2871, categoryID = category, quests = {81141}, spellID = 449572,  points = 1}, -- Ominous Herbs
  {skillLineVariantID = 2871, categoryID = category, quests = {81145}, spellID = 449938,  points = 1}, -- Gleaming Chaos
  {skillLineVariantID = 2871, categoryID = category, quests = {81128}, spellID = 430624,  points = 1}, -- Gleaming Glory
  {skillLineVariantID = 2871, categoryID = category, quests = {81092}, spellID = 427185,  points = 1}, -- Algari Alchemist Stone
  {skillLineVariantID = 2871, categoryID = category, quests = {81130}, spellID = 432962,  points = 1}, -- Algari Flask Cauldron
  {skillLineVariantID = 2871, categoryID = category, quests = {81131}, spellID = 432963,  points = 1}, -- Algari Potion Cauldron
  {skillLineVariantID = 2871, categoryID = category, quests = {91819}, spellID = 1246966, points = 1}, -- Umbral Essentia
  {skillLineVariantID = 2871, categoryID = category, quests = {91032}, spellID = 1238010, points = 1}, -- Invigorating Healing Potion
  -- The War Within: Blacksmithing
  {skillLineVariantID = 2872, categoryID = category, quests = {80492}, spellID = 450216,  points = 1}, -- Core Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {80597}, spellID = 450219,  points = 1}, -- Ironclaw Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {80595}, spellID = 450217,  points = 1}, -- Charged Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {80596}, spellID = 450218,  points = 1}, -- Sanctified Alloy
  {skillLineVariantID = 2872, categoryID = category, quests = {83399}, spellID = 450292,  points = 1}, -- Coreforged Skeleton Key
  {skillLineVariantID = 2872, categoryID = category, quests = {83398}, spellID = 450291,  points = 1}, -- Coreforged Repair Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {80662}, spellID = 450284,  points = 1}, -- Forged Framework
  {skillLineVariantID = 2872, categoryID = category, quests = {80667}, spellID = 450289,  points = 1}, -- Tempered Framework
  {skillLineVariantID = 2872, categoryID = category, quests = {80666}, spellID = 450288,  points = 1}, -- Adjustable Framework
  {skillLineVariantID = 2872, categoryID = category, quests = {80665}, spellID = 450287,  points = 1}, -- Ironclaw Weightstone
  {skillLineVariantID = 2872, categoryID = category, quests = {80663}, spellID = 450285,  points = 1}, -- Ironclaw Whetstone
  {skillLineVariantID = 2872, categoryID = category, quests = {80664}, spellID = 450286,  points = 1}, -- Ironclaw Razorstone
  {skillLineVariantID = 2872, categoryID = category, quests = {80636}, spellID = 450258,  points = 1}, -- Dredger's Plate Sabatons
  {skillLineVariantID = 2872, categoryID = category, quests = {80637}, spellID = 450259,  points = 1}, -- Dredger's Plate Breastplate
  {skillLineVariantID = 2872, categoryID = category, quests = {80642}, spellID = 450264,  points = 1}, -- Dredger's Plate Vambraces
  {skillLineVariantID = 2872, categoryID = category, quests = {80639}, spellID = 450261,  points = 1}, -- Dredger's Developed Defender
  {skillLineVariantID = 2872, categoryID = category, quests = {80644}, spellID = 450266,  points = 1}, -- Dredger's Developed Gauntlets
  {skillLineVariantID = 2872, categoryID = category, quests = {80638}, spellID = 450260,  points = 1}, -- Dredger's Developed Greatbelt
  {skillLineVariantID = 2872, categoryID = category, quests = {80641}, spellID = 450263,  points = 1}, -- Dredger's Developed Legplates
  {skillLineVariantID = 2872, categoryID = category, quests = {80643}, spellID = 450265,  points = 1}, -- Dredger's Developed Pauldrons
  {skillLineVariantID = 2872, categoryID = category, quests = {80640}, spellID = 450262,  points = 1}, -- Dredger's Developed Helm
  {skillLineVariantID = 2872, categoryID = category, quests = {80602}, spellID = 450224,  points = 1}, -- Everforged Helm
  {skillLineVariantID = 2872, categoryID = category, quests = {80599}, spellID = 450221,  points = 1}, -- Everforged Breastplate
  {skillLineVariantID = 2872, categoryID = category, quests = {80603}, spellID = 450225,  points = 1}, -- Everforged Legplates
  {skillLineVariantID = 2872, categoryID = category, quests = {80598}, spellID = 450220,  points = 1}, -- Everforged Sabatons
  {skillLineVariantID = 2872, categoryID = category, quests = {80600}, spellID = 450222,  points = 1}, -- Everforged Greatbelt
  {skillLineVariantID = 2872, categoryID = category, quests = {80605}, spellID = 450227,  points = 1}, -- Everforged Pauldrons
  {skillLineVariantID = 2872, categoryID = category, quests = {80606}, spellID = 450228,  points = 1}, -- Everforged Gauntlets
  {skillLineVariantID = 2872, categoryID = category, quests = {80601}, spellID = 450223,  points = 1}, -- Everforged Defender
  {skillLineVariantID = 2872, categoryID = category, quests = {80604}, spellID = 450226,  points = 1}, -- Everforged Vambraces
  {skillLineVariantID = 2872, categoryID = category, quests = {80629}, spellID = 450251,  points = 1}, -- Ironclaw Stiletto
  {skillLineVariantID = 2872, categoryID = category, quests = {80630}, spellID = 450252,  points = 1}, -- Ironclaw Dirk
  {skillLineVariantID = 2872, categoryID = category, quests = {80632}, spellID = 450254,  points = 1}, -- Ironclaw Knuckles
  {skillLineVariantID = 2872, categoryID = category, quests = {80631}, spellID = 450253,  points = 1}, -- Ironclaw Sword
  {skillLineVariantID = 2872, categoryID = category, quests = {80634}, spellID = 450256,  points = 1}, -- Ironclaw Axe
  {skillLineVariantID = 2872, categoryID = category, quests = {80633}, spellID = 450255,  points = 1}, -- Ironclaw Great Mace
  {skillLineVariantID = 2872, categoryID = category, quests = {80635}, spellID = 450257,  points = 1}, -- Ironclaw Great Axe
  {skillLineVariantID = 2872, categoryID = category, quests = {80612}, spellID = 450234,  points = 1}, -- Everforged Greataxe
  {skillLineVariantID = 2872, categoryID = category, quests = {80617}, spellID = 450239,  points = 1}, -- Charged Halberd
  {skillLineVariantID = 2872, categoryID = category, quests = {80609}, spellID = 450231,  points = 1}, -- Everforged Longsword
  {skillLineVariantID = 2872, categoryID = category, quests = {80616}, spellID = 450238,  points = 1}, -- Charged Claymore
  {skillLineVariantID = 2872, categoryID = category, quests = {80613}, spellID = 450235,  points = 1}, -- Charged Hexsword
  {skillLineVariantID = 2872, categoryID = category, quests = {80607}, spellID = 450229,  points = 1}, -- Everforged Stabber
  {skillLineVariantID = 2872, categoryID = category, quests = {80608}, spellID = 450230,  points = 1}, -- Everforged Dagger
  {skillLineVariantID = 2872, categoryID = category, quests = {80611}, spellID = 450233,  points = 1}, -- Everforged Mace
  {skillLineVariantID = 2872, categoryID = category, quests = {80619}, spellID = 450241,  points = 1}, -- Charged Invoker
  {skillLineVariantID = 2872, categoryID = category, quests = {80610}, spellID = 450232,  points = 1}, -- Everforged Warglaive
  {skillLineVariantID = 2872, categoryID = category, quests = {80620}, spellID = 450242,  points = 1}, -- Charged Slicer
  {skillLineVariantID = 2872, categoryID = category, quests = {80615}, spellID = 450237,  points = 1}, -- Charged Facesmasher
  {skillLineVariantID = 2872, categoryID = category, quests = {80618}, spellID = 450240,  points = 1}, -- Charged Crusher
  {skillLineVariantID = 2872, categoryID = category, quests = {80614}, spellID = 450236,  points = 1}, -- Charged Runeaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {80623}, spellID = 450245,  points = 1}, -- Sanctified Steps
  {skillLineVariantID = 2872, categoryID = category, quests = {80628}, spellID = 450250,  points = 1}, -- Siphoning Stiletto
  {skillLineVariantID = 2872, categoryID = category, quests = {80624}, spellID = 450246,  points = 1}, -- Beledar's Bulwark
  {skillLineVariantID = 2872, categoryID = category, quests = {80651}, spellID = 450273,  points = 1}, -- Proficient Blacksmith's Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {80652}, spellID = 450274,  points = 1}, -- Proficient Blacksmith's Toolbox
  {skillLineVariantID = 2872, categoryID = category, quests = {80650}, spellID = 450272,  points = 1}, -- Proficient Leatherworker's Toolset
  {skillLineVariantID = 2872, categoryID = category, quests = {80649}, spellID = 450271,  points = 1}, -- Proficient Leatherworker's Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {80648}, spellID = 450270,  points = 1}, -- Proficient Needle Set
  {skillLineVariantID = 2872, categoryID = category, quests = {80647}, spellID = 450269,  points = 1}, -- Proficient Skinning Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {80645}, spellID = 450267,  points = 1}, -- Proficient Sickle
  {skillLineVariantID = 2872, categoryID = category, quests = {80646}, spellID = 450268,  points = 1}, -- Proficient Pickaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {80659}, spellID = 450281,  points = 1}, -- Artisan Blacksmith's Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {80660}, spellID = 450282,  points = 1}, -- Artisan Blacksmith's Toolbox
  {skillLineVariantID = 2872, categoryID = category, quests = {80658}, spellID = 450280,  points = 1}, -- Artisan Leatherworker's Toolset
  {skillLineVariantID = 2872, categoryID = category, quests = {80656}, spellID = 450278,  points = 1}, -- Artisan Needle Set
  {skillLineVariantID = 2872, categoryID = category, quests = {80657}, spellID = 450279,  points = 1}, -- Artisan Leatherworker's Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {80653}, spellID = 450275,  points = 1}, -- Artisan Sickle
  {skillLineVariantID = 2872, categoryID = category, quests = {80654}, spellID = 450276,  points = 1}, -- Artisan Pickaxe
  {skillLineVariantID = 2872, categoryID = category, quests = {80655}, spellID = 450277,  points = 1}, -- Artisan Skinning Knife
  {skillLineVariantID = 2872, categoryID = category, quests = {80661}, spellID = 450283,  points = 1}, -- Earthen Master's Hammer
  {skillLineVariantID = 2872, categoryID = category, quests = {80625}, spellID = 438914,  points = 1}, -- Algari Competitor's Plate Breastplate
  {skillLineVariantID = 2872, categoryID = category, quests = {80668}, spellID = 438920,  points = 1}, -- Algari Competitor's Plate Waistguard
  {skillLineVariantID = 2872, categoryID = category, quests = {84695}, spellID = 438917,  points = 1}, -- Algari Competitor's Plate Helm
  {skillLineVariantID = 2872, categoryID = category, quests = {84696}, spellID = 438918,  points = 1}, -- Algari Competitor's Plate Greaves
  {skillLineVariantID = 2872, categoryID = category, quests = {84697}, spellID = 438919,  points = 1}, -- Algari Competitor's Plate Pauldrons
  {skillLineVariantID = 2872, categoryID = category, quests = {80669}, spellID = 438921,  points = 1}, -- Algari Competitor's Plate Armguards
  {skillLineVariantID = 2872, categoryID = category, quests = {80626}, spellID = 438915,  points = 1}, -- Algari Competitor's Plate Sabatons
  {skillLineVariantID = 2872, categoryID = category, quests = {80627}, spellID = 438916,  points = 1}, -- Algari Competitor's Plate Gauntlets
  {skillLineVariantID = 2872, categoryID = category, quests = {83293}, spellID = 455000,  points = 1}, -- Algari Competitor's Shield
  {skillLineVariantID = 2872, categoryID = category, quests = {83294}, spellID = 455001,  points = 1}, -- Algari Competitor's Axe
  {skillLineVariantID = 2872, categoryID = category, quests = {83297}, spellID = 455004,  points = 1}, -- Algari Competitor's Sword
  {skillLineVariantID = 2872, categoryID = category, quests = {83291}, spellID = 454998,  points = 1}, -- Algari Competitor's Dagger
  {skillLineVariantID = 2872, categoryID = category, quests = {83292}, spellID = 454999,  points = 1}, -- Algari Competitor's Scepter
  {skillLineVariantID = 2872, categoryID = category, quests = {83295}, spellID = 455002,  points = 1}, -- Algari Competitor's Skewer
  {skillLineVariantID = 2872, categoryID = category, quests = {83296}, spellID = 455003,  points = 1}, -- Algari Competitor's Greatsword
  {skillLineVariantID = 2872, categoryID = category, quests = {83290}, spellID = 454997,  points = 1}, -- Algari Competitor's Pickaxe
  -- The War Within: Enchanting
  {skillLineVariantID = 2874, categoryID = category, quests = {81043}, spellID = 445371,  points = 1}, -- Mirror Powder
  {skillLineVariantID = 2874, categoryID = category, quests = {81067}, spellID = 445395,  points = 1}, -- Concentration Concentrate
  {skillLineVariantID = 2874, categoryID = category, quests = {81071}, spellID = 445399,  points = 1}, -- Enchanted Weathered Harbinger Crest
  {skillLineVariantID = 2874, categoryID = category, quests = {81020}, spellID = 445347,  points = 1}, -- Enchanted Runed Harbinger Crest
  {skillLineVariantID = 2874, categoryID = category, quests = {81027}, spellID = 445354,  points = 1}, -- Enchanted Gilded Harbinger Crest
  {skillLineVariantID = 2874, categoryID = category, quests = {81011}, spellID = 445338,  points = 1}, -- Algari Mana Oil
  {skillLineVariantID = 2874, categoryID = category, quests = {80991}, spellID = 445318,  points = 1}, -- Oil of Beledar's Grace
  {skillLineVariantID = 2874, categoryID = category, quests = {81019}, spellID = 445346,  points = 1}, -- Oil of Deep Toxins
  {skillLineVariantID = 2874, categoryID = category, quests = {81024}, spellID = 445351,  points = 1}, -- Oathsworn's Tenacity
  {skillLineVariantID = 2874, categoryID = category, quests = {81057}, spellID = 445385,  points = 1}, -- Stonebound Artistry
  {skillLineVariantID = 2874, categoryID = category, quests = {80990}, spellID = 445317,  points = 1}, -- Stormrider's Fury
  {skillLineVariantID = 2874, categoryID = category, quests = {81051}, spellID = 445379,  points = 1}, -- Council's Guile
  {skillLineVariantID = 2874, categoryID = category, quests = {81037}, spellID = 445364,  points = 1}, -- Algari Deftness
  {skillLineVariantID = 2874, categoryID = category, quests = {81052}, spellID = 445380,  points = 1}, -- Algari Perception
  {skillLineVariantID = 2874, categoryID = category, quests = {81001}, spellID = 445328,  points = 1}, -- Algari Finesse
  {skillLineVariantID = 2874, categoryID = category, quests = {81070}, spellID = 445398,  points = 1}, -- Algari Resourcefulness
  {skillLineVariantID = 2874, categoryID = category, quests = {81050}, spellID = 445378,  points = 1}, -- Algari Ingenuity
  {skillLineVariantID = 2874, categoryID = category, quests = {80994}, spellID = 445321,  points = 1}, -- Oathsworn's Strength
  {skillLineVariantID = 2874, categoryID = category, quests = {81026}, spellID = 445353,  points = 1}, -- Stormrider's Agility
  {skillLineVariantID = 2874, categoryID = category, quests = {80995}, spellID = 445322,  points = 1}, -- Council's Intellect
  {skillLineVariantID = 2874, categoryID = category, quests = {81006}, spellID = 445333,  points = 1}, -- Crystalline Radiance
  {skillLineVariantID = 2874, categoryID = category, quests = {81009}, spellID = 445336,  points = 1}, -- Authority of Storms
  {skillLineVariantID = 2874, categoryID = category, quests = {81031}, spellID = 445358,  points = 1}, -- Glimmering Critical Strike
  {skillLineVariantID = 2874, categoryID = category, quests = {81053}, spellID = 445381,  points = 1}, -- Glimmering Mastery
  {skillLineVariantID = 2874, categoryID = category, quests = {81056}, spellID = 445384,  points = 1}, -- Glimmering Haste
  {skillLineVariantID = 2874, categoryID = category, quests = {81013}, spellID = 445340,  points = 1}, -- Glimmering Versatility
  {skillLineVariantID = 2874, categoryID = category, quests = {81068}, spellID = 445396,  points = 1}, -- Defender's March
  {skillLineVariantID = 2874, categoryID = category, quests = {81008}, spellID = 445335,  points = 1}, -- Cavalry's March
  {skillLineVariantID = 2874, categoryID = category, quests = {81041}, spellID = 445368,  points = 1}, -- Scout's March
  {skillLineVariantID = 2874, categoryID = category, quests = {80993}, spellID = 445320,  points = 1}, -- Radiant Haste
  {skillLineVariantID = 2874, categoryID = category, quests = {81022}, spellID = 445349,  points = 1}, -- Radiant Versatility
  {skillLineVariantID = 2874, categoryID = category, quests = {81059}, spellID = 445387,  points = 1}, -- Radiant Critical Strike
  {skillLineVariantID = 2874, categoryID = category, quests = {81047}, spellID = 445375,  points = 1}, -- Radiant Mastery
  {skillLineVariantID = 2874, categoryID = category, quests = {81012}, spellID = 445339,  points = 1}, -- Authority of Radiant Power
  {skillLineVariantID = 2874, categoryID = category, quests = {81004}, spellID = 445331,  points = 1}, -- Authority of Air
  {skillLineVariantID = 2874, categoryID = category, quests = {81075}, spellID = 445403,  points = 1}, -- Authority of Fiery Resolve
  {skillLineVariantID = 2874, categoryID = category, quests = {81064}, spellID = 445392,  points = 1}, -- Whisper of Armored Avoidance
  {skillLineVariantID = 2874, categoryID = category, quests = {81017}, spellID = 445344,  points = 1}, -- Whisper of Silken Avoidance
  {skillLineVariantID = 2874, categoryID = category, quests = {81048}, spellID = 445376,  points = 1}, -- Whisper of Armored Speed
  {skillLineVariantID = 2874, categoryID = category, quests = {81021}, spellID = 445348,  points = 1}, -- Whisper of Silken Leech
  {skillLineVariantID = 2874, categoryID = category, quests = {81045}, spellID = 445373,  points = 1}, -- Whisper of Silken Speed
  {skillLineVariantID = 2874, categoryID = category, quests = {81046}, spellID = 445374,  points = 1}, -- Whisper of Armored Leech
  {skillLineVariantID = 2874, categoryID = category, quests = {81055}, spellID = 445383,  points = 1}, -- Cursed Versatility
  {skillLineVariantID = 2874, categoryID = category, quests = {81060}, spellID = 445388,  points = 1}, -- Cursed Haste
  {skillLineVariantID = 2874, categoryID = category, quests = {81066}, spellID = 445394,  points = 1}, -- Cursed Critical Strike
  {skillLineVariantID = 2874, categoryID = category, quests = {81032}, spellID = 445359,  points = 1}, -- Cursed Mastery
  {skillLineVariantID = 2874, categoryID = category, quests = {81007}, spellID = 445334,  points = 1}, -- Chant of Armored Avoidance
  {skillLineVariantID = 2874, categoryID = category, quests = {80998}, spellID = 445325,  points = 1}, -- Chant of Armored Leech
  {skillLineVariantID = 2874, categoryID = category, quests = {81003}, spellID = 445330,  points = 1}, -- Chant of Armored Speed
  {skillLineVariantID = 2874, categoryID = category, quests = {81058}, spellID = 445386,  points = 1}, -- Chant of Winged Grace
  {skillLineVariantID = 2874, categoryID = category, quests = {81061}, spellID = 445389,  points = 1}, -- Chant of Burrowing Rapidity
  {skillLineVariantID = 2874, categoryID = category, quests = {81065}, spellID = 445393,  points = 1}, -- Chant of Leeching Fangs
  {skillLineVariantID = 2874, categoryID = category, quests = {81014}, spellID = 445341,  points = 1}, -- Authority of the Depths
  {skillLineVariantID = 2874, categoryID = category, quests = {81033}, spellID = 445360,  points = 1}, -- Illusory Adornment: Runes
  {skillLineVariantID = 2874, categoryID = category, quests = {81000}, spellID = 445327,  points = 1}, -- Illusory Adornment: Crystal
  {skillLineVariantID = 2874, categoryID = category, quests = {81010}, spellID = 445337,  points = 1}, -- Illusory Adornment: Shadow
  {skillLineVariantID = 2874, categoryID = category, quests = {81073}, spellID = 445401,  points = 1}, -- Illusory Adornment: Radiance
  {skillLineVariantID = 2874, categoryID = category, quests = {81038}, spellID = 445365,  points = 1}, -- Gleeful Glamour - Pandaren
  {skillLineVariantID = 2874, categoryID = category, quests = {81040}, spellID = 445367,  points = 1}, -- Gleeful Glamour - Blood Elf
  {skillLineVariantID = 2874, categoryID = category, quests = {80992}, spellID = 445319,  points = 1}, -- Gleeful Glamour - Orc
  {skillLineVariantID = 2874, categoryID = category, quests = {81005}, spellID = 445332,  points = 1}, -- Gleeful Glamour - Goblin
  {skillLineVariantID = 2874, categoryID = category, quests = {80999}, spellID = 445326,  points = 1}, -- Gleeful Glamour - Troll
  {skillLineVariantID = 2874, categoryID = category, quests = {81023}, spellID = 445350,  points = 1}, -- Gleeful Glamour - Undead
  {skillLineVariantID = 2874, categoryID = category, quests = {81039}, spellID = 445366,  points = 1}, -- Gleeful Glamour - Tauren
  {skillLineVariantID = 2874, categoryID = category, quests = {81025}, spellID = 445352,  points = 1}, -- Gleeful Glamour - Human
  {skillLineVariantID = 2874, categoryID = category, quests = {81036}, spellID = 445363,  points = 1}, -- Gleeful Glamour - Night Elf
  {skillLineVariantID = 2874, categoryID = category, quests = {81074}, spellID = 445402,  points = 1}, -- Gleeful Glamour - Dwarf
  {skillLineVariantID = 2874, categoryID = category, quests = {81035}, spellID = 445362,  points = 1}, -- Gleeful Glamour - Gnome
  {skillLineVariantID = 2874, categoryID = category, quests = {81063}, spellID = 445391,  points = 1}, -- Gleeful Glamour - Draenei
  {skillLineVariantID = 2874, categoryID = category, quests = {81069}, spellID = 445397,  points = 1}, -- Gleeful Glamour - Worgen
  {skillLineVariantID = 2874, categoryID = category, quests = {81016}, spellID = 445343,  points = 1}, -- Gleeful Glamour - Lightforged Draenei
  {skillLineVariantID = 2874, categoryID = category, quests = {81072}, spellID = 445400,  points = 1}, -- Gleeful Glamour - Dark Iron Dwarf
  {skillLineVariantID = 2874, categoryID = category, quests = {81015}, spellID = 445342,  points = 1}, -- Gleeful Glamour - Kul Tiran
  {skillLineVariantID = 2874, categoryID = category, quests = {81030}, spellID = 445357,  points = 1}, -- Gleeful Glamour - Mechagnome
  {skillLineVariantID = 2874, categoryID = category, quests = {81029}, spellID = 445356,  points = 1}, -- Gleeful Glamour - Void Elf
  {skillLineVariantID = 2874, categoryID = category, quests = {81062}, spellID = 445390,  points = 1}, -- Gleeful Glamour - Nightborne
  {skillLineVariantID = 2874, categoryID = category, quests = {81049}, spellID = 445377,  points = 1}, -- Gleeful Glamour - Highmountain Tauren
  {skillLineVariantID = 2874, categoryID = category, quests = {81042}, spellID = 445370,  points = 1}, -- Gleeful Glamour - Mag'har Orc
  {skillLineVariantID = 2874, categoryID = category, quests = {81018}, spellID = 445345,  points = 1}, -- Gleeful Glamour - Zandalari Troll
  {skillLineVariantID = 2874, categoryID = category, quests = {81002}, spellID = 445329,  points = 1}, -- Gleeful Glamour - Vulpera
  {skillLineVariantID = 2874, categoryID = category, quests = {81054}, spellID = 445382,  points = 1}, -- Gleeful Glamour - Earthen
  {skillLineVariantID = 2874, categoryID = category, quests = {81034}, spellID = 445361,  points = 1}, -- Runed Bismuth Rod
  {skillLineVariantID = 2874, categoryID = category, quests = {81044}, spellID = 445372,  points = 1}, -- Runed Ironclaw Rod
  {skillLineVariantID = 2874, categoryID = category, quests = {80996}, spellID = 445323,  points = 1}, -- Runed Null Stone Rod
  {skillLineVariantID = 2874, categoryID = category, quests = {80997}, spellID = 445324,  points = 1}, -- Enchanted Spearwood Wand
  {skillLineVariantID = 2874, categoryID = category, quests = {81028}, spellID = 445355,  points = 1}, -- Scepter of Radiant Magics
  {skillLineVariantID = 2874, categoryID = category, quests = {92077}, spellID = 1249469, points = 1}, -- Gleeful Glamour - Ethereal
  -- The War Within: Engineering
  {skillLineVariantID = 2875, categoryID = category, quests = {81301}, spellID = 447312,  points = 1}, -- Invent
  {skillLineVariantID = 2875, categoryID = category, quests = {81325}, spellID = 447336,  points = 1}, -- Handful of Bismuth Bolts
  {skillLineVariantID = 2875, categoryID = category, quests = {81326}, spellID = 447337,  points = 1}, -- Whimsical Wiring
  {skillLineVariantID = 2875, categoryID = category, quests = {81327}, spellID = 447338,  points = 1}, -- Gyrating Gear
  {skillLineVariantID = 2875, categoryID = category, quests = {81328}, spellID = 447339,  points = 1}, -- Safety Switch
  {skillLineVariantID = 2875, categoryID = category, quests = {81329}, spellID = 447340,  points = 1}, -- Chaos Circuit
  {skillLineVariantID = 2875, categoryID = category, quests = {81330}, spellID = 447341,  points = 1}, -- Entropy Enhancer
  {skillLineVariantID = 2875, categoryID = category, quests = {84019}, spellID = 459299,  points = 1}, -- Bottled Brilliance
  {skillLineVariantID = 2875, categoryID = category, quests = {81346}, spellID = 447357,  points = 1}, -- Recalibrated Safety Switch
  {skillLineVariantID = 2875, categoryID = category, quests = {81347}, spellID = 447358,  points = 1}, -- Blame Redirection Device
  {skillLineVariantID = 2875, categoryID = category, quests = {81349}, spellID = 447360,  points = 1}, -- Complicated Fuse Box
  {skillLineVariantID = 2875, categoryID = category, quests = {81352}, spellID = 447363,  points = 1}, -- Energy Redistribution Beacon
  {skillLineVariantID = 2875, categoryID = category, quests = {81351}, spellID = 447362,  points = 1}, -- Concealed Chaos Module
  {skillLineVariantID = 2875, categoryID = category, quests = {81350}, spellID = 447361,  points = 1}, -- Pouch of Pocket Grenades
  {skillLineVariantID = 2875, categoryID = category, quests = {81344}, spellID = 447355,  points = 1}, -- Impeccable Cogwheel
  {skillLineVariantID = 2875, categoryID = category, quests = {81345}, spellID = 447356,  points = 1}, -- Adjustable Cogwheel
  {skillLineVariantID = 2875, categoryID = category, quests = {81342}, spellID = 447353,  points = 1}, -- Serrated Cogwheel
  {skillLineVariantID = 2875, categoryID = category, quests = {81343}, spellID = 447354,  points = 1}, -- Overclocked Cogwheel
  {skillLineVariantID = 2875, categoryID = category, quests = {81388}, spellID = 447379,  points = 1}, -- 4UT0-41M3R
  {skillLineVariantID = 2875, categoryID = category, quests = {81365}, spellID = 447376,  points = 1}, -- Spelunker's Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81387}, spellID = 447378,  points = 1}, -- Dredger's Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81364}, spellID = 447375,  points = 1}, -- Acolyte's Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81366}, spellID = 447377,  points = 1}, -- Tracker's Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81341}, spellID = 447352,  points = 1}, -- P.0.W. x2
  {skillLineVariantID = 2875, categoryID = category, quests = {81307}, spellID = 447318,  points = 1}, -- Blasting Bracers
  {skillLineVariantID = 2875, categoryID = category, quests = {81308}, spellID = 447319,  points = 1}, -- Venting Vambraces
  {skillLineVariantID = 2875, categoryID = category, quests = {81309}, spellID = 447320,  points = 1}, -- Whirring Wristwraps
  {skillLineVariantID = 2875, categoryID = category, quests = {81310}, spellID = 447321,  points = 1}, -- Clanking Cuffs
  {skillLineVariantID = 2875, categoryID = category, quests = {81303}, spellID = 447314,  points = 1}, -- Studious Brilliance Expeditor
  {skillLineVariantID = 2875, categoryID = category, quests = {81304}, spellID = 447315,  points = 1}, -- Overclocked Idea Generator
  {skillLineVariantID = 2875, categoryID = category, quests = {81305}, spellID = 447316,  points = 1}, -- Supercharged Thought Enhancer
  {skillLineVariantID = 2875, categoryID = category, quests = {81306}, spellID = 447317,  points = 1}, -- Dangerous Distraction Inhibitor
  {skillLineVariantID = 2875, categoryID = category, quests = {81321}, spellID = 447332,  points = 1}, -- Bismuth Fueled Samophlange
  {skillLineVariantID = 2875, categoryID = category, quests = {81311}, spellID = 447322,  points = 1}, -- Spring-Loaded Bismuth Fabric Cutters
  {skillLineVariantID = 2875, categoryID = category, quests = {81317}, spellID = 447328,  points = 1}, -- Lapidary's Bismuth Clamps
  {skillLineVariantID = 2875, categoryID = category, quests = {81315}, spellID = 447326,  points = 1}, -- Bismuth Fisherfriend
  {skillLineVariantID = 2875, categoryID = category, quests = {81323}, spellID = 447334,  points = 1}, -- Miner's Bismuth Hoard
  {skillLineVariantID = 2875, categoryID = category, quests = {81319}, spellID = 447330,  points = 1}, -- Bismuth Miner's Headgear
  {skillLineVariantID = 2875, categoryID = category, quests = {81313}, spellID = 447324,  points = 1}, -- Bismuth Brainwave Projector
  {skillLineVariantID = 2875, categoryID = category, quests = {81322}, spellID = 447333,  points = 1}, -- Aqirite Fueled Samophlange
  {skillLineVariantID = 2875, categoryID = category, quests = {81318}, spellID = 447329,  points = 1}, -- Lapidary's Aqirite Clamps
  {skillLineVariantID = 2875, categoryID = category, quests = {81312}, spellID = 447323,  points = 1}, -- Spring-Loaded Aqirite Fabric Cutters
  {skillLineVariantID = 2875, categoryID = category, quests = {81316}, spellID = 447327,  points = 1}, -- Aqirite Fisherfriend
  {skillLineVariantID = 2875, categoryID = category, quests = {81324}, spellID = 447335,  points = 1}, -- Miner's Aqirite Hoard
  {skillLineVariantID = 2875, categoryID = category, quests = {81314}, spellID = 447325,  points = 1}, -- Aqirite Brainwave Projector
  {skillLineVariantID = 2875, categoryID = category, quests = {81320}, spellID = 447331,  points = 1}, -- Aqirite Miner's Headgear
  {skillLineVariantID = 2875, categoryID = category, quests = {81332}, spellID = 447343,  points = 1}, -- Potion Bomb of Recovery
  {skillLineVariantID = 2875, categoryID = category, quests = {81333}, spellID = 447344,  points = 1}, -- Potion Bomb of Power
  {skillLineVariantID = 2875, categoryID = category, quests = {81331}, spellID = 447342,  points = 1}, -- Potion Bomb of Speed
  {skillLineVariantID = 2875, categoryID = category, quests = {81363}, spellID = 447374,  points = 1}, -- Box o' Booms
  {skillLineVariantID = 2875, categoryID = category, quests = {81298}, spellID = 443570,  points = 1}, -- Stonebound Lantern
  {skillLineVariantID = 2875, categoryID = category, quests = {81360}, spellID = 447372,  points = 1}, -- Wormhole Generator: Khaz Algar
  {skillLineVariantID = 2875, categoryID = category, quests = {81358}, spellID = 447370,  points = 1}, -- Defective Escape Pod
  {skillLineVariantID = 2875, categoryID = category, quests = {81382}, spellID = 447369,  points = 1}, -- Barrel of Fireworks
  {skillLineVariantID = 2875, categoryID = category, quests = {81359}, spellID = 447371,  points = 1}, -- Filmless Camera
  {skillLineVariantID = 2875, categoryID = category, quests = {81354}, spellID = 447365,  points = 1}, -- Pausing Pylon
  {skillLineVariantID = 2875, categoryID = category, quests = {81355}, spellID = 447366,  points = 1}, -- Convincingly Realistic Jumper Cables
  {skillLineVariantID = 2875, categoryID = category, quests = {81353}, spellID = 447364,  points = 1}, -- Irresistible Red Button
  {skillLineVariantID = 2875, categoryID = category, quests = {81356}, spellID = 447367,  points = 1}, -- Algari Repair Bot 11O
  {skillLineVariantID = 2875, categoryID = category, quests = {81357}, spellID = 447368,  points = 1}, -- Portable Profession Possibility Projector
  {skillLineVariantID = 2875, categoryID = category, quests = {81361}, spellID = 447373,  points = 1}, -- Crowd Pummeler 2-30
  {skillLineVariantID = 2875, categoryID = category, quests = {81340}, spellID = 447351,  points = 1}, -- Tinker: Heartseeking Health Injector
  {skillLineVariantID = 2875, categoryID = category, quests = {81339}, spellID = 447350,  points = 1}, -- Tinker: Earthen Delivery Drill
  {skillLineVariantID = 2875, categoryID = category, quests = {81386}, spellID = 455005,  points = 1}, -- Algari Competitor's Rifle
  {skillLineVariantID = 2875, categoryID = category, quests = {81290}, spellID = 438922,  points = 1}, -- Algari Competitor's Cloth Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81291}, spellID = 438923,  points = 1}, -- Algari Competitor's Leather Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81292}, spellID = 438924,  points = 1}, -- Algari Competitor's Mail Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81293}, spellID = 438925,  points = 1}, -- Algari Competitor's Plate Goggles
  {skillLineVariantID = 2875, categoryID = category, quests = {81294}, spellID = 438926,  points = 1}, -- Algari Competitor's Cloth Bracers
  {skillLineVariantID = 2875, categoryID = category, quests = {81295}, spellID = 438927,  points = 1}, -- Algari Competitor's Leather Bracers
  {skillLineVariantID = 2875, categoryID = category, quests = {81296}, spellID = 438928,  points = 1}, -- Algari Competitor's Mail Bracers
  {skillLineVariantID = 2875, categoryID = category, quests = {81297}, spellID = 438929,  points = 1}, -- Algari Competitor's Plate Bracers
  {skillLineVariantID = 2875, categoryID = category, quests = {86460}, spellID = 1213620, points = 1}, -- 22H Slicks
  -- The War Within: Herbalism
  {skillLineVariantID = 2877, categoryID = category, quests = {79906}, spellID = 435811,  points = 1}, -- Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79907}, spellID = 435812,  points = 1}, -- Lush Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79911}, spellID = 435851,  points = 1}, -- Camouflaged Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79908}, spellID = 435838,  points = 1}, -- Crystallized Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79910}, spellID = 435843,  points = 1}, -- Irradiated Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79912}, spellID = 435850,  points = 1}, -- Sporefused Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79909}, spellID = 435840,  points = 1}, -- Altered Mycobloom
  {skillLineVariantID = 2877, categoryID = category, quests = {79913}, spellID = 435821,  points = 1}, -- Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79914}, spellID = 435829,  points = 1}, -- Lush Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79918}, spellID = 435860,  points = 1}, -- Camouflaged Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79915}, spellID = 435857,  points = 1}, -- Crystallized Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79917}, spellID = 435859,  points = 1}, -- Irradiated Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79919}, spellID = 435861,  points = 1}, -- Sporefused Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79916}, spellID = 435858,  points = 1}, -- Altered Luredrop
  {skillLineVariantID = 2877, categoryID = category, quests = {79920}, spellID = 435822,  points = 1}, -- Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79921}, spellID = 435830,  points = 1}, -- Lush Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79925}, spellID = 435866,  points = 1}, -- Camouflaged Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79922}, spellID = 435862,  points = 1}, -- Crystallized Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79924}, spellID = 435865,  points = 1}, -- Irradiated Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79926}, spellID = 435867,  points = 1}, -- Sporefused Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79923}, spellID = 435864,  points = 1}, -- Altered Orbinid
  {skillLineVariantID = 2877, categoryID = category, quests = {79927}, spellID = 435823,  points = 1}, -- Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79928}, spellID = 435834,  points = 1}, -- Lush Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79931}, spellID = 435872,  points = 1}, -- Camouflaged Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79929}, spellID = 435870,  points = 1}, -- Crystallized Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79930}, spellID = 435871,  points = 1}, -- Irradiated Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79932}, spellID = 435873,  points = 1}, -- Sporefused Blessing Blossom
  {skillLineVariantID = 2877, categoryID = category, quests = {79933}, spellID = 435826,  points = 1}, -- Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79934}, spellID = 435836,  points = 1}, -- Lush Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79937}, spellID = 435879,  points = 1}, -- Camouflaged Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79935}, spellID = 435877,  points = 1}, -- Crystallized Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79936}, spellID = 435878,  points = 1}, -- Irradiated Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {79938}, spellID = 435880,  points = 1}, -- Sporefused Arathor's Spear
  {skillLineVariantID = 2877, categoryID = category, quests = {92132}, spellID = 1250314, points = 1}, -- Phantom Bloom
  {skillLineVariantID = 2877, categoryID = category, quests = {92133}, spellID = 1250317, points = 1}, -- Lush Phantom Bloom
  -- The War Within: Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {80729}, spellID = 444221,  points = 1}, -- Shadow Ink
  {skillLineVariantID = 2878, categoryID = category, quests = {80730}, spellID = 444222,  points = 1}, -- Apricate Ink
  {skillLineVariantID = 2878, categoryID = category, quests = {80700}, spellID = 444191,  points = 1}, -- Boundless Cipher
  {skillLineVariantID = 2878, categoryID = category, quests = {80699}, spellID = 444190,  points = 1}, -- Codified Greenwood
  {skillLineVariantID = 2878, categoryID = category, quests = {80701}, spellID = 444192,  points = 1}, -- Darkmoon Sigil: Ascension
  {skillLineVariantID = 2878, categoryID = category, quests = {80704}, spellID = 444195,  points = 1}, -- Darkmoon Sigil: Vivacity
  {skillLineVariantID = 2878, categoryID = category, quests = {80703}, spellID = 444194,  points = 1}, -- Darkmoon Sigil: Symbiosis
  {skillLineVariantID = 2878, categoryID = category, quests = {80702}, spellID = 444193,  points = 1}, -- Darkmoon Sigil: Radiance
  {skillLineVariantID = 2878, categoryID = category, quests = {80705}, spellID = 444196,  points = 1}, -- Inquisitor's Torch
  {skillLineVariantID = 2878, categoryID = category, quests = {80709}, spellID = 444200,  points = 1}, -- Inquisitor's Crutch
  {skillLineVariantID = 2878, categoryID = category, quests = {80710}, spellID = 444201,  points = 1}, -- Inquisitor's Baton
  {skillLineVariantID = 2878, categoryID = category, quests = {80706}, spellID = 444197,  points = 1}, -- Vagabond's Torch
  {skillLineVariantID = 2878, categoryID = category, quests = {80707}, spellID = 444198,  points = 1}, -- Vagabond's Careful Crutch
  {skillLineVariantID = 2878, categoryID = category, quests = {80708}, spellID = 444199,  points = 1}, -- Vagabond's Bounding Baton
  {skillLineVariantID = 2878, categoryID = category, quests = {80728}, spellID = 444220,  points = 1}, -- Contract: Council of Dornogal
  {skillLineVariantID = 2878, categoryID = category, quests = {80725}, spellID = 444217,  points = 1}, -- Contract: Assembly of the Deeps
  {skillLineVariantID = 2878, categoryID = category, quests = {80726}, spellID = 444218,  points = 1}, -- Contract: Hallowfall Arathi
  {skillLineVariantID = 2878, categoryID = category, quests = {80727}, spellID = 444219,  points = 1}, -- Contract: The Severed Threads
  {skillLineVariantID = 2878, categoryID = category, quests = {80721}, spellID = 444212,  points = 1}, -- Algari Missive of the Fireflash
  {skillLineVariantID = 2878, categoryID = category, quests = {80719}, spellID = 444210,  points = 1}, -- Algari Missive of the Aurora
  {skillLineVariantID = 2878, categoryID = category, quests = {80720}, spellID = 444211,  points = 1}, -- Algari Missive of the Feverflare
  {skillLineVariantID = 2878, categoryID = category, quests = {80722}, spellID = 444213,  points = 1}, -- Algari Missive of the Harmonious
  {skillLineVariantID = 2878, categoryID = category, quests = {80723}, spellID = 444214,  points = 1}, -- Algari Missive of the Peerless
  {skillLineVariantID = 2878, categoryID = category, quests = {80724}, spellID = 444215,  points = 1}, -- Algari Missive of the Quickblade
  {skillLineVariantID = 2878, categoryID = category, quests = {80738}, spellID = 444235,  points = 1}, -- Algari Missive of Deftness
  {skillLineVariantID = 2878, categoryID = category, quests = {80736}, spellID = 444233,  points = 1}, -- Algari Missive of Finesse
  {skillLineVariantID = 2878, categoryID = category, quests = {80733}, spellID = 444230,  points = 1}, -- Algari Missive of Resourcefulness
  {skillLineVariantID = 2878, categoryID = category, quests = {80734}, spellID = 444231,  points = 1}, -- Algari Missive of Multicraft
  {skillLineVariantID = 2878, categoryID = category, quests = {80737}, spellID = 444234,  points = 1}, -- Algari Missive of Perception
  {skillLineVariantID = 2878, categoryID = category, quests = {80732}, spellID = 444229,  points = 1}, -- Algari Missive of Ingenuity
  {skillLineVariantID = 2878, categoryID = category, quests = {80735}, spellID = 444232,  points = 1}, -- Algari Missive of Crafting Speed
  {skillLineVariantID = 2878, categoryID = category, quests = {80713}, spellID = 444204,  points = 1}, -- Lightweight Scribe's Quill
  {skillLineVariantID = 2878, categoryID = category, quests = {80715}, spellID = 444206,  points = 1}, -- Hasty Alchemist's Mixing Rod
  {skillLineVariantID = 2878, categoryID = category, quests = {80717}, spellID = 444208,  points = 1}, -- Burnt Rolling Pin
  {skillLineVariantID = 2878, categoryID = category, quests = {80716}, spellID = 444207,  points = 1}, -- Patient Alchemist's Mixing Rod
  {skillLineVariantID = 2878, categoryID = category, quests = {80714}, spellID = 444205,  points = 1}, -- Silver Tongue's Quill
  {skillLineVariantID = 2878, categoryID = category, quests = {80718}, spellID = 444209,  points = 1}, -- Inscribed Rolling Pin
  {skillLineVariantID = 2878, categoryID = category, quests = {80692}, spellID = 447868,  points = 1}, -- Algari Treatise on Inscription
  {skillLineVariantID = 2878, categoryID = category, quests = {80690}, spellID = 444187,  points = 1}, -- Algari Treatise on Alchemy
  {skillLineVariantID = 2878, categoryID = category, quests = {80695}, spellID = 444189,  points = 1}, -- Algari Treatise on Jewelcrafting
  {skillLineVariantID = 2878, categoryID = category, quests = {80739}, spellID = 444236,  points = 1}, -- Algari Treatise on Skinning
  {skillLineVariantID = 2878, categoryID = category, quests = {80691}, spellID = 444186,  points = 1}, -- Algari Treatise on Tailoring
  {skillLineVariantID = 2878, categoryID = category, quests = {80697}, spellID = 444183,  points = 1}, -- Algari Treatise on Mining
  {skillLineVariantID = 2878, categoryID = category, quests = {80696}, spellID = 444182,  points = 1}, -- Algari Treatise on Herbalism
  {skillLineVariantID = 2878, categoryID = category, quests = {80698}, spellID = 444184,  points = 1}, -- Algari Treatise on Blacksmithing
  {skillLineVariantID = 2878, categoryID = category, quests = {80693}, spellID = 444185,  points = 1}, -- Algari Treatise on Leatherworking
  {skillLineVariantID = 2878, categoryID = category, quests = {80694}, spellID = 444188,  points = 1}, -- Algari Treatise on Enchanting
  {skillLineVariantID = 2878, categoryID = category, quests = {80731}, spellID = 444223,  points = 1}, -- Algari Treatise on Engineering
  {skillLineVariantID = 2878, categoryID = category, quests = {80712}, spellID = 444203,  points = 1}, -- Vantus Rune: Nerub-ar Palace
  {skillLineVariantID = 2878, categoryID = category, quests = {80746}, spellID = 444336,  points = 1}, -- Algari Competitor's Medallion
  {skillLineVariantID = 2878, categoryID = category, quests = {80747}, spellID = 444337,  points = 1}, -- Algari Competitor's Insignia of Alacrity
  {skillLineVariantID = 2878, categoryID = category, quests = {80748}, spellID = 444338,  points = 1}, -- Algari Competitor's Emblem
  {skillLineVariantID = 2878, categoryID = category, quests = {80743}, spellID = 455006,  points = 1}, -- Algari Competitor's Lamp
  {skillLineVariantID = 2878, categoryID = category, quests = {80745}, spellID = 455008,  points = 1}, -- Algari Competitor's Staff
  {skillLineVariantID = 2878, categoryID = category, quests = {80744}, spellID = 455007,  points = 1}, -- Algari Competitor's Pillar
  {skillLineVariantID = 2878, categoryID = category, quests = {86451}, spellID = 1213517, points = 1}, -- Glyph of the Ashvane Pistol Shot
  {skillLineVariantID = 2878, categoryID = category, quests = {86453}, spellID = 1213515, points = 1}, -- Glyph of the Admiral's Pistol Shot
  {skillLineVariantID = 2878, categoryID = category, quests = {86454}, spellID = 1213514, points = 1}, -- Glyph of the Gilded Pistol Shot
  {skillLineVariantID = 2878, categoryID = category, quests = {86455}, spellID = 1213512, points = 1}, -- Glyph of the Twilight Pistol Shot
  {skillLineVariantID = 2878, categoryID = category, quests = {86205}, spellID = 472951,  points = 1}, -- Vantus Rune: Liberation of Undermine
  {skillLineVariantID = 2878, categoryID = category, quests = {85796}, spellID = 471132,  points = 1}, -- Contract: The Cartels of Undermine
  {skillLineVariantID = 2878, categoryID = category, quests = {90784}, spellID = 1234336, points = 1}, -- Glyph of the Strix
  {skillLineVariantID = 2878, categoryID = category, quests = {90941}, spellID = 1236908, points = 1}, -- Vantus Rune: Manaforge Omega
  {skillLineVariantID = 2878, categoryID = category, quests = {90908}, spellID = 1236170, points = 1}, -- Contract: The K'aresh Trust
  {skillLineVariantID = 2878, categoryID = category, quests = {91581}, spellID = 1243994, points = 1}, -- Inspired Writer's Quill
  {skillLineVariantID = 2878, categoryID = category, quests = {92075}, spellID = 1249466, points = 1}, -- Deal: Cartel Ba
  {skillLineVariantID = 2878, categoryID = category, quests = {92076}, spellID = 1249468, points = 1}, -- Deal: Cartel Om
  {skillLineVariantID = 2878, categoryID = category, quests = {92074}, spellID = 1249463, points = 1}, -- Deal: Cartel Zo
  -- The War Within: Jewelcrafting
  {skillLineVariantID = 2879, categoryID = category, quests = {81229}, spellID = 435334,  points = 1}, -- Magnificent Jeweler's Setting
  {skillLineVariantID = 2879, categoryID = category, quests = {81220}, spellID = 435324,  points = 1}, -- Engraved Gemcutter
  {skillLineVariantID = 2879, categoryID = category, quests = {81222}, spellID = 435326,  points = 1}, -- Marbled Stone
  {skillLineVariantID = 2879, categoryID = category, quests = {81221}, spellID = 435325,  points = 1}, -- Decorative Lens
  {skillLineVariantID = 2879, categoryID = category, quests = {81219}, spellID = 435323,  points = 1}, -- Gilded Vial
  {skillLineVariantID = 2879, categoryID = category, quests = {81223}, spellID = 435327,  points = 1}, -- Inverted Prism
  {skillLineVariantID = 2879, categoryID = category, quests = {81228}, spellID = 435333,  points = 1}, -- Captured Starlight
  {skillLineVariantID = 2879, categoryID = category, quests = {81227}, spellID = 435332,  points = 1}, -- Prismatic Null Stone
  {skillLineVariantID = 2879, categoryID = category, quests = {81226}, spellID = 435331,  points = 1}, -- Elemental Focusing Lens
  {skillLineVariantID = 2879, categoryID = category, quests = {81225}, spellID = 435330,  points = 1}, -- Ominous Energy Crystal
  {skillLineVariantID = 2879, categoryID = category, quests = {81224}, spellID = 435329,  points = 1}, -- Sifted Cave Sand
  {skillLineVariantID = 2879, categoryID = category, quests = {81192}, spellID = 434537,  points = 1}, -- Deadly Amber
  {skillLineVariantID = 2879, categoryID = category, quests = {81193}, spellID = 434536,  points = 1}, -- Solid Amber
  {skillLineVariantID = 2879, categoryID = category, quests = {81194}, spellID = 434538,  points = 1}, -- Quick Amber
  {skillLineVariantID = 2879, categoryID = category, quests = {81195}, spellID = 434539,  points = 1}, -- Masterful Amber
  {skillLineVariantID = 2879, categoryID = category, quests = {81196}, spellID = 434540,  points = 1}, -- Versatile Amber
  {skillLineVariantID = 2879, categoryID = category, quests = {81198}, spellID = 434542,  points = 1}, -- Quick Emerald
  {skillLineVariantID = 2879, categoryID = category, quests = {81197}, spellID = 434541,  points = 1}, -- Deadly Emerald
  {skillLineVariantID = 2879, categoryID = category, quests = {81199}, spellID = 434543,  points = 1}, -- Masterful Emerald
  {skillLineVariantID = 2879, categoryID = category, quests = {81200}, spellID = 434544,  points = 1}, -- Versatile Emerald
  {skillLineVariantID = 2879, categoryID = category, quests = {81203}, spellID = 434547,  points = 1}, -- Masterful Onyx
  {skillLineVariantID = 2879, categoryID = category, quests = {81201}, spellID = 434545,  points = 1}, -- Deadly Onyx
  {skillLineVariantID = 2879, categoryID = category, quests = {81204}, spellID = 434548,  points = 1}, -- Versatile Onyx
  {skillLineVariantID = 2879, categoryID = category, quests = {81202}, spellID = 434546,  points = 1}, -- Quick Onyx
  {skillLineVariantID = 2879, categoryID = category, quests = {81205}, spellID = 434549,  points = 1}, -- Deadly Ruby
  {skillLineVariantID = 2879, categoryID = category, quests = {81208}, spellID = 434552,  points = 1}, -- Versatile Ruby
  {skillLineVariantID = 2879, categoryID = category, quests = {81206}, spellID = 434550,  points = 1}, -- Quick Ruby
  {skillLineVariantID = 2879, categoryID = category, quests = {81207}, spellID = 434551,  points = 1}, -- Masterful Ruby
  {skillLineVariantID = 2879, categoryID = category, quests = {81212}, spellID = 434563,  points = 1}, -- Versatile Sapphire
  {skillLineVariantID = 2879, categoryID = category, quests = {81211}, spellID = 434555,  points = 1}, -- Masterful Sapphire
  {skillLineVariantID = 2879, categoryID = category, quests = {81210}, spellID = 434554,  points = 1}, -- Quick Sapphire
  {skillLineVariantID = 2879, categoryID = category, quests = {81209}, spellID = 434553,  points = 1}, -- Deadly Sapphire
  {skillLineVariantID = 2879, categoryID = category, quests = {81258}, spellID = 435392,  points = 1}, -- Cubic Blasphemia
  {skillLineVariantID = 2879, categoryID = category, quests = {81214}, spellID = 435318,  points = 1}, -- Culminating Blasphemite
  {skillLineVariantID = 2879, categoryID = category, quests = {81215}, spellID = 435319,  points = 1}, -- Elusive Blasphemite
  {skillLineVariantID = 2879, categoryID = category, quests = {81213}, spellID = 435230,  points = 1}, -- Insightful Blasphemite
  {skillLineVariantID = 2879, categoryID = category, quests = {81232}, spellID = 435337,  points = 1}, -- Algari Amber Prism
  {skillLineVariantID = 2879, categoryID = category, quests = {81233}, spellID = 435338,  points = 1}, -- Algari Emerald Prism
  {skillLineVariantID = 2879, categoryID = category, quests = {81234}, spellID = 435339,  points = 1}, -- Algari Ruby Prism
  {skillLineVariantID = 2879, categoryID = category, quests = {81235}, spellID = 435369,  points = 1}, -- Algari Onyx Prism
  {skillLineVariantID = 2879, categoryID = category, quests = {81236}, spellID = 435370,  points = 1}, -- Algari Sapphire Prism
  {skillLineVariantID = 2879, categoryID = category, quests = {81245}, spellID = 435379,  points = 1}, -- Malleable Band
  {skillLineVariantID = 2879, categoryID = category, quests = {81246}, spellID = 435380,  points = 1}, -- Malleable Pendant
  {skillLineVariantID = 2879, categoryID = category, quests = {81250}, spellID = 435384,  points = 1}, -- Ring of Earthen Craftsmanship
  {skillLineVariantID = 2879, categoryID = category, quests = {81251}, spellID = 435385,  points = 1}, -- Amulet of Earthen Craftsmanship
  {skillLineVariantID = 2879, categoryID = category, quests = {81248}, spellID = 435382,  points = 1}, -- Binding of Binding
  {skillLineVariantID = 2879, categoryID = category, quests = {81249}, spellID = 435383,  points = 1}, -- Fractured Gemstone Locket
  {skillLineVariantID = 2879, categoryID = category, quests = {81253}, spellID = 435387,  points = 1}, -- Algari Competitor's Amulet
  {skillLineVariantID = 2879, categoryID = category, quests = {81252}, spellID = 435386,  points = 1}, -- Algari Competitor's Signet
  {skillLineVariantID = 2879, categoryID = category, quests = {81216}, spellID = 435320,  points = 1}, -- Enduring Bloodstone
  {skillLineVariantID = 2879, categoryID = category, quests = {81217}, spellID = 435321,  points = 1}, -- Cognitive Bloodstone
  {skillLineVariantID = 2879, categoryID = category, quests = {81218}, spellID = 435322,  points = 1}, -- Determined Bloodstone
  {skillLineVariantID = 2879, categoryID = category, quests = {81237}, spellID = 435371,  points = 1}, -- Radiant Loupes
  {skillLineVariantID = 2879, categoryID = category, quests = {81239}, spellID = 435373,  points = 1}, -- Incanter's Shard
  {skillLineVariantID = 2879, categoryID = category, quests = {81241}, spellID = 435375,  points = 1}, -- Right-Handed Magnifying Glass
  {skillLineVariantID = 2879, categoryID = category, quests = {81243}, spellID = 435377,  points = 1}, -- Storyteller's Glasses
  {skillLineVariantID = 2879, categoryID = category, quests = {81238}, spellID = 435372,  points = 1}, -- Extravagant Loupes
  {skillLineVariantID = 2879, categoryID = category, quests = {81240}, spellID = 435374,  points = 1}, -- Enchanter's Crystal
  {skillLineVariantID = 2879, categoryID = category, quests = {81242}, spellID = 435376,  points = 1}, -- Forger's Font Inspector
  {skillLineVariantID = 2879, categoryID = category, quests = {81244}, spellID = 435378,  points = 1}, -- Novelist's Specs
  {skillLineVariantID = 2879, categoryID = category, quests = {81257}, spellID = 435391,  points = 1}, -- Beautification Iris
  {skillLineVariantID = 2879, categoryID = category, quests = {81255}, spellID = 435389,  points = 1}, -- Remembrance Stone
  {skillLineVariantID = 2879, categoryID = category, quests = {89248}, spellID = 1226650, points = 1}, -- Void-Crystal Panther
  -- The War Within: Leatherworking
  {skillLineVariantID = 2880, categoryID = category, quests = {80944}, spellID = 444086,  points = 1}, -- Chitin Armor Banding
  {skillLineVariantID = 2880, categoryID = category, quests = {80951}, spellID = 444087,  points = 1}, -- Storm-Touched Weapon Wrap
  {skillLineVariantID = 2880, categoryID = category, quests = {80947}, spellID = 444077,  points = 1}, -- Writhing Hide
  {skillLineVariantID = 2880, categoryID = category, quests = {80945}, spellID = 444075,  points = 1}, -- Carapace-Backed Hide
  {skillLineVariantID = 2880, categoryID = category, quests = {80948}, spellID = 444078,  points = 1}, -- Sporecoated Hide
  {skillLineVariantID = 2880, categoryID = category, quests = {80946}, spellID = 444076,  points = 1}, -- Crystalfused Hide
  {skillLineVariantID = 2880, categoryID = category, quests = {80949}, spellID = 444079,  points = 1}, -- Leyfused Hide
  {skillLineVariantID = 2880, categoryID = category, quests = {80952}, spellID = 444122,  points = 1}, -- Thunderous Drums
  {skillLineVariantID = 2880, categoryID = category, quests = {80955}, spellID = 444104,  points = 1}, -- Dual Layered Armor Kit
  {skillLineVariantID = 2880, categoryID = category, quests = {80953}, spellID = 444103,  points = 1}, -- Defender's Armor Kit
  {skillLineVariantID = 2880, categoryID = category, quests = {80954}, spellID = 444102,  points = 1}, -- Stormbound Armor Kit
  {skillLineVariantID = 2880, categoryID = category, quests = {80913}, spellID = 443702,  points = 1}, -- Spelunker's Leather Bands
  {skillLineVariantID = 2880, categoryID = category, quests = {80907}, spellID = 443696,  points = 1}, -- Spelunker's Leather Footpads
  {skillLineVariantID = 2880, categoryID = category, quests = {80906}, spellID = 443695,  points = 1}, -- Spelunker's Leather Jerkin
  {skillLineVariantID = 2880, categoryID = category, quests = {80912}, spellID = 443701,  points = 1}, -- Spelunker's Practiced Sash
  {skillLineVariantID = 2880, categoryID = category, quests = {80908}, spellID = 443697,  points = 1}, -- Spelunker's Practiced Mitts
  {skillLineVariantID = 2880, categoryID = category, quests = {80911}, spellID = 443700,  points = 1}, -- Spelunker's Practiced Shoulders
  {skillLineVariantID = 2880, categoryID = category, quests = {80910}, spellID = 443699,  points = 1}, -- Spelunker's Practiced Britches
  {skillLineVariantID = 2880, categoryID = category, quests = {80909}, spellID = 443698,  points = 1}, -- Spelunker's Practiced Hat
  {skillLineVariantID = 2880, categoryID = category, quests = {80891}, spellID = 441051,  points = 1}, -- Rune-Branded Tunic
  {skillLineVariantID = 2880, categoryID = category, quests = {80890}, spellID = 441052,  points = 1}, -- Rune-Branded Kickers
  {skillLineVariantID = 2880, categoryID = category, quests = {80892}, spellID = 441053,  points = 1}, -- Rune-Branded Grasps
  {skillLineVariantID = 2880, categoryID = category, quests = {80894}, spellID = 441055,  points = 1}, -- Rune-Branded Legwraps
  {skillLineVariantID = 2880, categoryID = category, quests = {80897}, spellID = 441058,  points = 1}, -- Rune-Branded Armbands
  {skillLineVariantID = 2880, categoryID = category, quests = {80893}, spellID = 441054,  points = 1}, -- Rune-Branded Hood
  {skillLineVariantID = 2880, categoryID = category, quests = {80896}, spellID = 441057,  points = 1}, -- Rune-Branded Waistband
  {skillLineVariantID = 2880, categoryID = category, quests = {80895}, spellID = 441056,  points = 1}, -- Rune-Branded Mantle
  {skillLineVariantID = 2880, categoryID = category, quests = {80921}, spellID = 443710,  points = 1}, -- Tracker's Chitin Cuffs
  {skillLineVariantID = 2880, categoryID = category, quests = {80915}, spellID = 443704,  points = 1}, -- Tracker's Chitin Galoshes
  {skillLineVariantID = 2880, categoryID = category, quests = {80914}, spellID = 443703,  points = 1}, -- Tracker's Chitin Hauberk
  {skillLineVariantID = 2880, categoryID = category, quests = {80920}, spellID = 443709,  points = 1}, -- Tracker's Toughened Girdle
  {skillLineVariantID = 2880, categoryID = category, quests = {80916}, spellID = 443705,  points = 1}, -- Tracker's Toughened Handguards
  {skillLineVariantID = 2880, categoryID = category, quests = {80919}, spellID = 443708,  points = 1}, -- Tracker's Toughened Shoulderguards
  {skillLineVariantID = 2880, categoryID = category, quests = {80918}, spellID = 443707,  points = 1}, -- Tracker's Toughened Links
  {skillLineVariantID = 2880, categoryID = category, quests = {80917}, spellID = 443706,  points = 1}, -- Tracker's Toughened Headgear
  {skillLineVariantID = 2880, categoryID = category, quests = {80898}, spellID = 441060,  points = 1}, -- Glyph-Etched Stompers
  {skillLineVariantID = 2880, categoryID = category, quests = {80902}, spellID = 441063,  points = 1}, -- Glyph-Etched Cuisses
  {skillLineVariantID = 2880, categoryID = category, quests = {80900}, spellID = 441061,  points = 1}, -- Glyph-Etched Gauntlets
  {skillLineVariantID = 2880, categoryID = category, quests = {80904}, spellID = 441065,  points = 1}, -- Glyph-Etched Binding
  {skillLineVariantID = 2880, categoryID = category, quests = {80899}, spellID = 441059,  points = 1}, -- Glyph-Etched Breastplate
  {skillLineVariantID = 2880, categoryID = category, quests = {80901}, spellID = 441062,  points = 1}, -- Glyph-Etched Guise
  {skillLineVariantID = 2880, categoryID = category, quests = {80903}, spellID = 441064,  points = 1}, -- Glyph-Etched Epaulets
  {skillLineVariantID = 2880, categoryID = category, quests = {80905}, spellID = 441066,  points = 1}, -- Glyph-Etched Vambraces
  {skillLineVariantID = 2880, categoryID = category, quests = {80922}, spellID = 441460,  points = 1}, -- Blessed Weapon Grip
  {skillLineVariantID = 2880, categoryID = category, quests = {80927}, spellID = 444073,  points = 1}, -- Sanctified Torchbearer's Grips
  {skillLineVariantID = 2880, categoryID = category, quests = {80926}, spellID = 444071,  points = 1}, -- Waders of the Unifying Flame
  {skillLineVariantID = 2880, categoryID = category, quests = {80923}, spellID = 441461,  points = 1}, -- Writhing Armor Banding
  {skillLineVariantID = 2880, categoryID = category, quests = {80925}, spellID = 444070,  points = 1}, -- Adrenal Surge Clasp
  {skillLineVariantID = 2880, categoryID = category, quests = {80924}, spellID = 444068,  points = 1}, -- Vambraces of Deepening Darkness
  {skillLineVariantID = 2880, categoryID = category, quests = {80959}, spellID = 443961,  points = 1}, -- Smoldering Pollen Hauberk
  {skillLineVariantID = 2880, categoryID = category, quests = {80960}, spellID = 443960,  points = 1}, -- Reinforced Setae Flyers
  {skillLineVariantID = 2880, categoryID = category, quests = {80961}, spellID = 443958,  points = 1}, -- Busy Bee's Buckle
  {skillLineVariantID = 2880, categoryID = category, quests = {80957}, spellID = 443951,  points = 1}, -- Weathered Stormfront Vest
  {skillLineVariantID = 2880, categoryID = category, quests = {80958}, spellID = 443949,  points = 1}, -- Rook Feather Wristwraps
  {skillLineVariantID = 2880, categoryID = category, quests = {80956}, spellID = 443950,  points = 1}, -- Roiling Thunderstrike Talons
  {skillLineVariantID = 2880, categoryID = category, quests = {80968}, spellID = 438902,  points = 1}, -- Algari Competitor's Leather Belt
  {skillLineVariantID = 2880, categoryID = category, quests = {80966}, spellID = 438903,  points = 1}, -- Algari Competitor's Leather Trousers
  {skillLineVariantID = 2880, categoryID = category, quests = {80965}, spellID = 438900,  points = 1}, -- Algari Competitor's Leather Mask
  {skillLineVariantID = 2880, categoryID = category, quests = {80963}, spellID = 438899,  points = 1}, -- Algari Competitor's Leather Chestpiece
  {skillLineVariantID = 2880, categoryID = category, quests = {80967}, spellID = 438901,  points = 1}, -- Algari Competitor's Leather Shoulderpads
  {skillLineVariantID = 2880, categoryID = category, quests = {80964}, spellID = 438904,  points = 1}, -- Algari Competitor's Leather Gloves
  {skillLineVariantID = 2880, categoryID = category, quests = {80969}, spellID = 438905,  points = 1}, -- Algari Competitor's Leather Wristwraps
  {skillLineVariantID = 2880, categoryID = category, quests = {80962}, spellID = 438898,  points = 1}, -- Algari Competitor's Leather Boots
  {skillLineVariantID = 2880, categoryID = category, quests = {80971}, spellID = 438907,  points = 1}, -- Algari Competitor's Chain Chainmail
  {skillLineVariantID = 2880, categoryID = category, quests = {80974}, spellID = 438911,  points = 1}, -- Algari Competitor's Chain Leggings
  {skillLineVariantID = 2880, categoryID = category, quests = {80975}, spellID = 438909,  points = 1}, -- Algari Competitor's Chain Epaulets
  {skillLineVariantID = 2880, categoryID = category, quests = {80976}, spellID = 438910,  points = 1}, -- Algari Competitor's Chain Girdle
  {skillLineVariantID = 2880, categoryID = category, quests = {80972}, spellID = 438912,  points = 1}, -- Algari Competitor's Chain Gauntlets
  {skillLineVariantID = 2880, categoryID = category, quests = {80970}, spellID = 438906,  points = 1}, -- Algari Competitor's Chain Treads
  {skillLineVariantID = 2880, categoryID = category, quests = {80973}, spellID = 438908,  points = 1}, -- Algari Competitor's Chain Cowl
  {skillLineVariantID = 2880, categoryID = category, quests = {80977}, spellID = 438913,  points = 1}, -- Algari Competitor's Chain Cuffs
  {skillLineVariantID = 2880, categoryID = category, quests = {80942}, spellID = 444120,  points = 1}, -- Hideseeker's Hat
  {skillLineVariantID = 2880, categoryID = category, quests = {80934}, spellID = 444112,  points = 1}, -- Gardener's Basket
  {skillLineVariantID = 2880, categoryID = category, quests = {80940}, spellID = 444118,  points = 1}, -- Hideseeker's Pack
  {skillLineVariantID = 2880, categoryID = category, quests = {80938}, spellID = 444116,  points = 1}, -- Hideshaper's Cover
  {skillLineVariantID = 2880, categoryID = category, quests = {80936}, spellID = 444114,  points = 1}, -- Gemcutter's Apron
  {skillLineVariantID = 2880, categoryID = category, quests = {80932}, spellID = 444110,  points = 1}, -- Scrapsmith's Gloves
  {skillLineVariantID = 2880, categoryID = category, quests = {80928}, spellID = 444105,  points = 1}, -- Apothecary's Cap
  {skillLineVariantID = 2880, categoryID = category, quests = {80930}, spellID = 444107,  points = 1}, -- Steelsmith's Apron
  {skillLineVariantID = 2880, categoryID = category, quests = {80939}, spellID = 444117,  points = 1}, -- Arathi Leatherworker's Smock
  {skillLineVariantID = 2880, categoryID = category, quests = {80935}, spellID = 444113,  points = 1}, -- Stonebound Herbalist's Pack
  {skillLineVariantID = 2880, categoryID = category, quests = {80931}, spellID = 444108,  points = 1}, -- Earthen Forgemaster's Apron
  {skillLineVariantID = 2880, categoryID = category, quests = {80937}, spellID = 444115,  points = 1}, -- Earthen Jeweler's Cover
  {skillLineVariantID = 2880, categoryID = category, quests = {80933}, spellID = 444111,  points = 1}, -- Charged Scrapmaster's Gauntlets
  {skillLineVariantID = 2880, categoryID = category, quests = {80943}, spellID = 444121,  points = 1}, -- Deep Tracker's Cap
  {skillLineVariantID = 2880, categoryID = category, quests = {80929}, spellID = 444106,  points = 1}, -- Nerubian Alchemist's Hat
  {skillLineVariantID = 2880, categoryID = category, quests = {80941}, spellID = 444119,  points = 1}, -- Deep Tracker's Pack
  {skillLineVariantID = 2880, categoryID = category, quests = {86778}, spellID = 1216520, points = 1}, -- Charged Armor Kit
  -- The War Within: Mining
  {skillLineVariantID = 2881, categoryID = category, quests = {80350}, spellID = 439705,  points = 1}, -- Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80356}, spellID = 439712,  points = 1}, -- Bismuth Seam
  {skillLineVariantID = 2881, categoryID = category, quests = {80353}, spellID = 439709,  points = 1}, -- Rich Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80368}, spellID = 439724,  points = 1}, -- Camouflaged Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80365}, spellID = 439721,  points = 1}, -- EZ-Mine Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80359}, spellID = 439715,  points = 1}, -- Crystallized Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80362}, spellID = 439718,  points = 1}, -- Weeping Bismuth
  {skillLineVariantID = 2881, categoryID = category, quests = {80371}, spellID = 439727,  points = 1}, -- Webbed Bismuth
  -- {skillLineVariantID = 2881, categoryID = category, quests = {}, spellID = 439707,  points = 1},  -- Aqirite (bug - provides no points)
  {skillLineVariantID = 2881, categoryID = category, quests = {80357}, spellID = 439713,  points = 1}, -- Aqirite Seam
  {skillLineVariantID = 2881, categoryID = category, quests = {80354}, spellID = 439710,  points = 1}, -- Rich Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80369}, spellID = 439725,  points = 1}, -- Camouflaged Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80366}, spellID = 439722,  points = 1}, -- EZ-Mine Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80360}, spellID = 439716,  points = 1}, -- Crystallized Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80363}, spellID = 439719,  points = 1}, -- Weeping Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80372}, spellID = 439728,  points = 1}, -- Webbed Aqirite
  {skillLineVariantID = 2881, categoryID = category, quests = {80352}, spellID = 439708,  points = 1}, -- Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80358}, spellID = 439714,  points = 1}, -- Ironclaw Seam
  {skillLineVariantID = 2881, categoryID = category, quests = {80355}, spellID = 439711,  points = 1}, -- Rich Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80370}, spellID = 439726,  points = 1}, -- Camouflaged Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80367}, spellID = 439723,  points = 1}, -- EZ-Mine Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80361}, spellID = 439717,  points = 1}, -- Crystallized Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80364}, spellID = 439720,  points = 1}, -- Weeping Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {80373}, spellID = 439729,  points = 1}, -- Webbed Ironclaw
  {skillLineVariantID = 2881, categoryID = category, quests = {92134}, spellID = 1250351, points = 1}, -- Desolate Deposit
  {skillLineVariantID = 2881, categoryID = category, quests = {92135}, spellID = 1250356, points = 1}, -- Rich Desolate Deposit
  -- The War Within: Tailoring
  {skillLineVariantID = 2883, categoryID = category, quests = {80866}, spellID = 447002,  points = 1}, -- Weavercloth Bandage
  {skillLineVariantID = 2883, categoryID = category, quests = {80802}, spellID = 446929,  points = 1}, -- Weavercloth Bolt
  {skillLineVariantID = 2883, categoryID = category, quests = {80801}, spellID = 446928,  points = 1}, -- Dawnweave Bolt
  {skillLineVariantID = 2883, categoryID = category, quests = {80800}, spellID = 446927,  points = 1}, -- Duskweave Bolt
  {skillLineVariantID = 2883, categoryID = category, quests = {80867}, spellID = 454397,  points = 1}, -- Exquisite Weavercloth Bolt
  {skillLineVariantID = 2883, categoryID = category, quests = {80807}, spellID = 446934,  points = 1}, -- Warm Sunrise Bracers
  {skillLineVariantID = 2883, categoryID = category, quests = {80803}, spellID = 446930,  points = 1}, -- Grips of the Woven Dawn
  {skillLineVariantID = 2883, categoryID = category, quests = {80804}, spellID = 446931,  points = 1}, -- Treads of the Woven Dawn
  {skillLineVariantID = 2883, categoryID = category, quests = {80808}, spellID = 446935,  points = 1}, -- Cool Sunset Bracers
  {skillLineVariantID = 2883, categoryID = category, quests = {80805}, spellID = 446932,  points = 1}, -- Gloves of the Woven Dusk
  {skillLineVariantID = 2883, categoryID = category, quests = {80806}, spellID = 446933,  points = 1}, -- Slippers of the Woven Dusk
  {skillLineVariantID = 2883, categoryID = category, quests = {80820}, spellID = 446956,  points = 1}, -- Pioneer's Cloth Cuffs
  {skillLineVariantID = 2883, categoryID = category, quests = {80819}, spellID = 446955,  points = 1}, -- Pioneer's Cloth Slippers
  {skillLineVariantID = 2883, categoryID = category, quests = {80822}, spellID = 446958,  points = 1}, -- Pioneer's Perfected Cloak
  {skillLineVariantID = 2883, categoryID = category, quests = {80824}, spellID = 446960,  points = 1}, -- Pioneer's Cloth Robe
  {skillLineVariantID = 2883, categoryID = category, quests = {80821}, spellID = 446957,  points = 1}, -- Pioneer's Perfected Cord
  {skillLineVariantID = 2883, categoryID = category, quests = {80823}, spellID = 446959,  points = 1}, -- Pioneer's Perfected Hood
  {skillLineVariantID = 2883, categoryID = category, quests = {80827}, spellID = 446963,  points = 1}, -- Pioneer's Perfected Gloves
  {skillLineVariantID = 2883, categoryID = category, quests = {80826}, spellID = 446962,  points = 1}, -- Pioneer's Perfected Mantle
  {skillLineVariantID = 2883, categoryID = category, quests = {80825}, spellID = 446961,  points = 1}, -- Pioneer's Perfected Leggings
  {skillLineVariantID = 2883, categoryID = category, quests = {80812}, spellID = 446939,  points = 1}, -- Consecrated Cord
  {skillLineVariantID = 2883, categoryID = category, quests = {80813}, spellID = 446940,  points = 1}, -- Consecrated Cloak
  {skillLineVariantID = 2883, categoryID = category, quests = {80814}, spellID = 446941,  points = 1}, -- Consecrated Hood
  {skillLineVariantID = 2883, categoryID = category, quests = {80811}, spellID = 446938,  points = 1}, -- Consecrated Cuffs
  {skillLineVariantID = 2883, categoryID = category, quests = {80815}, spellID = 446942,  points = 1}, -- Consecrated Robe
  {skillLineVariantID = 2883, categoryID = category, quests = {80817}, spellID = 446944,  points = 1}, -- Consecrated Mantle
  {skillLineVariantID = 2883, categoryID = category, quests = {80810}, spellID = 446937,  points = 1}, -- Consecrated Slippers
  {skillLineVariantID = 2883, categoryID = category, quests = {80818}, spellID = 446945,  points = 1}, -- Consecrated Gloves
  {skillLineVariantID = 2883, categoryID = category, quests = {80816}, spellID = 446943,  points = 1}, -- Consecrated Leggings
  {skillLineVariantID = 2883, categoryID = category, quests = {80856}, spellID = 446992,  points = 1}, -- Duskthread Lining
  {skillLineVariantID = 2883, categoryID = category, quests = {80855}, spellID = 446991,  points = 1}, -- Dawnthread Lining
  {skillLineVariantID = 2883, categoryID = category, quests = {80862}, spellID = 446998,  points = 1}, -- Gritty Polishing Cloth
  {skillLineVariantID = 2883, categoryID = category, quests = {80860}, spellID = 446996,  points = 1}, -- Bright Polishing Cloth
  {skillLineVariantID = 2883, categoryID = category, quests = {80859}, spellID = 446995,  points = 1}, -- Preserving Embroidery Thread
  {skillLineVariantID = 2883, categoryID = category, quests = {80861}, spellID = 446997,  points = 1}, -- Weavercloth Embroidery Thread
  {skillLineVariantID = 2883, categoryID = category, quests = {80869}, spellID = 456706,  points = 1}, -- Algari Weaverline
  {skillLineVariantID = 2883, categoryID = category, quests = {80828}, spellID = 446964,  points = 1}, -- Weavercloth Gardening Hat
  {skillLineVariantID = 2883, categoryID = category, quests = {80829}, spellID = 446965,  points = 1}, -- Weavercloth Fishing Cap
  {skillLineVariantID = 2883, categoryID = category, quests = {80833}, spellID = 446969,  points = 1}, -- Weavercloth Chef's Hat
  {skillLineVariantID = 2883, categoryID = category, quests = {80831}, spellID = 446967,  points = 1}, -- Weavercloth Tailor's Coat
  {skillLineVariantID = 2883, categoryID = category, quests = {80832}, spellID = 446968,  points = 1}, -- Weavercloth Alchemist's Robe
  {skillLineVariantID = 2883, categoryID = category, quests = {80830}, spellID = 446966,  points = 1}, -- Weavercloth Enchanter's Hat
  {skillLineVariantID = 2883, categoryID = category, quests = {80838}, spellID = 446974,  points = 1}, -- Artisan Chef's Hat
  {skillLineVariantID = 2883, categoryID = category, quests = {80834}, spellID = 446970,  points = 1}, -- Artisan Gardening Hat
  {skillLineVariantID = 2883, categoryID = category, quests = {80835}, spellID = 446971,  points = 1}, -- Artisan Fishing Cap
  {skillLineVariantID = 2883, categoryID = category, quests = {80836}, spellID = 446972,  points = 1}, -- Artisan Enchanter's Hat
  {skillLineVariantID = 2883, categoryID = category, quests = {80837}, spellID = 446973,  points = 1}, -- Artisan Alchemist's Robe
  {skillLineVariantID = 2883, categoryID = category, quests = {80839}, spellID = 446975,  points = 1}, -- Artisan Tailor's Coat
  {skillLineVariantID = 2883, categoryID = category, quests = {80863}, spellID = 446999,  points = 1}, -- Weavercloth Spellthread
  {skillLineVariantID = 2883, categoryID = category, quests = {80865}, spellID = 447001,  points = 1}, -- Daybreak Spellthread
  {skillLineVariantID = 2883, categoryID = category, quests = {80864}, spellID = 447000,  points = 1}, -- Sunset Spellthread
  {skillLineVariantID = 2883, categoryID = category, quests = {80840}, spellID = 446976,  points = 1}, -- Weavercloth Bag
  {skillLineVariantID = 2883, categoryID = category, quests = {80842}, spellID = 446978,  points = 1}, -- Weavercloth Reagent Bag
  {skillLineVariantID = 2883, categoryID = category, quests = {80841}, spellID = 446977,  points = 1}, -- Dawnweave Reagent Bag
  {skillLineVariantID = 2883, categoryID = category, quests = {80843}, spellID = 446979,  points = 1}, -- Duskweave Bag
  {skillLineVariantID = 2883, categoryID = category, quests = {80868}, spellID = 454431,  points = 1}, -- The Severed Satchel
  {skillLineVariantID = 2883, categoryID = category, quests = {80847}, spellID = 446983,  points = 1}, -- Ignition Satchel
  {skillLineVariantID = 2883, categoryID = category, quests = {80846}, spellID = 446982,  points = 1}, -- Concoctor's Clutch
  {skillLineVariantID = 2883, categoryID = category, quests = {80853}, spellID = 446989,  points = 1}, -- Excavator's Haversack
  {skillLineVariantID = 2883, categoryID = category, quests = {80851}, spellID = 446987,  points = 1}, -- Darkmoon Duffle
  {skillLineVariantID = 2883, categoryID = category, quests = {80850}, spellID = 446986,  points = 1}, -- Prodigy's Toolbox
  {skillLineVariantID = 2883, categoryID = category, quests = {80854}, spellID = 446990,  points = 1}, -- Jeweler's Purse
  {skillLineVariantID = 2883, categoryID = category, quests = {80849}, spellID = 446985,  points = 1}, -- Magically "Infinite" Messenger
  {skillLineVariantID = 2883, categoryID = category, quests = {80852}, spellID = 446988,  points = 1}, -- Gardener's Seed Satchel
  {skillLineVariantID = 2883, categoryID = category, quests = {80848}, spellID = 446984,  points = 1}, -- Hideshaper's Workbag
  {skillLineVariantID = 2883, categoryID = category, quests = {80870}, spellID = 447888,  points = 1}, -- Hideseeker's Tote
  {skillLineVariantID = 2883, categoryID = category, quests = {80797}, spellID = 438895,  points = 1}, -- Algari Competitor's Cloth Tunic
  {skillLineVariantID = 2883, categoryID = category, quests = {80799}, spellID = 438897,  points = 1}, -- Algari Competitor's Cloth Cloak
  {skillLineVariantID = 2883, categoryID = category, quests = {80792}, spellID = 438890,  points = 1}, -- Algari Competitor's Cloth Shoulderpads
  {skillLineVariantID = 2883, categoryID = category, quests = {80793}, spellID = 438891,  points = 1}, -- Algari Competitor's Cloth Treads
  {skillLineVariantID = 2883, categoryID = category, quests = {80795}, spellID = 438893,  points = 1}, -- Algari Competitor's Cloth Hood
  {skillLineVariantID = 2883, categoryID = category, quests = {80794}, spellID = 438892,  points = 1}, -- Algari Competitor's Cloth Bands
  {skillLineVariantID = 2883, categoryID = category, quests = {80796}, spellID = 438894,  points = 1}, -- Algari Competitor's Cloth Gloves
  {skillLineVariantID = 2883, categoryID = category, quests = {80791}, spellID = 438889,  points = 1}, -- Algari Competitor's Cloth Leggings
  {skillLineVariantID = 2883, categoryID = category, quests = {80798}, spellID = 438896,  points = 1}, -- Algari Competitor's Cloth Sash
  {skillLineVariantID = 2883, categoryID = category, quests = {89510}, spellID = 1228344, points = 1}, -- Pure Chronomantic Fiber
  {skillLineVariantID = 2883, categoryID = category, quests = {89511}, spellID = 1228343, points = 1}, -- Pure Dexterous Fiber
  {skillLineVariantID = 2883, categoryID = category, quests = {89512}, spellID = 1228342, points = 1}, -- Pure Precise Fiber
  {skillLineVariantID = 2883, categoryID = category, quests = {89509}, spellID = 1228338, points = 1}, -- Pure Energizing Fiber

  -- Midnight: Alchemy
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230856, points = 1}, -- Wondrous Synergist
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230887, points = 1}, -- Transmute: Mote of Wild Magic
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230888, points = 1}, -- Transmute: Mote of Pure Void
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230889, points = 1}, -- Transmute: Mote of Primal Energy
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230890, points = 1}, -- Transmute: Mote of Light
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230855, points = 1}, -- Composite Flora
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230891, points = 1}, -- Box of Rocks
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230892, points = 1}, -- Bouquet of Herbs
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230893, points = 1}, -- School of Gems
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230854, points = 1}, -- Entropic Extract
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230859, points = 1}, -- Potion of Recklessness
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230864, points = 1}, -- Amani Extract
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230867, points = 1}, -- Void-Shrouded Tincture
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230860, points = 1}, -- Draught of Rampant Abandon
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230862, points = 1}, -- Potion of Devoured Dreams
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230866, points = 1}, -- Silvermoon Health Potion
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230886, points = 1}, -- Enlightenment Tonic
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230868, points = 1}, -- Refreshing Serum
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230858, points = 1}, -- Light's Preservation
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230863, points = 1}, -- Potion of Zealotry
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230865, points = 1}, -- Lightfused Mana Potion
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230869, points = 1}, -- Light's Potential
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230872, points = 1}, -- Haranir Phial of Ingenuity
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230870, points = 1}, -- Haranir Phial of Finesse
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230873, points = 1}, -- Haranir Phial of Perception
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230875, points = 1}, -- Flask of Thalassian Resistance
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230876, points = 1}, -- Flask of the Magisters
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230877, points = 1}, -- Flask of the Blood Knights
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230878, points = 1}, -- Flask of the Shattered Sun
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230861, points = 1}, -- Primal Philosopher's Stone
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230885, points = 1}, -- Magister's Alchemist Stone
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230883, points = 1}, -- Vicious Thalassian Flask of Honor
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230857, points = 1}, -- Voidlight Potion Cauldron
  {skillLineVariantID = 2906, categoryID = category, quests = {},      spellID = 1230874, points = 1}, -- Cauldron of Sin'dorei Flasks
  -- Midnight: Blacksmithing
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230769, points = 1}, -- Sunforged Blacksmith's Hammer
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1262899, points = 1}, -- Sunforged Leatherworker's Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1262905, points = 1}, -- Sunforged Skinning Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1262919, points = 1}, -- Sunforged Pickaxe
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1264644, points = 1}, -- Sunforged Blacksmith's Toolbox
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1264645, points = 1}, -- Sunforged Leatherworker's Toolset
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1264646, points = 1}, -- Sunforged Needle Set
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1264651, points = 1}, -- Sunforged Sickle
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229598, points = 1}, -- Sun-Blessed Blacksmith's Hammer
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229599, points = 1}, -- Sun-Blessed Leatherworker's Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229600, points = 1}, -- Sun-Blessed Skinning Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229601, points = 1}, -- Sun-Blessed Pickaxe
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229602, points = 1}, -- Sun-Blessed Sickle
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229603, points = 1}, -- Sun-Blessed Blacksmith's Toolbox
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229604, points = 1}, -- Sun-Blessed Leatherworker's Toolset
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229605, points = 1}, -- Sun-Blessed Needle Set
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229606, points = 1}, -- Thalassian Blacksmith's Hammer
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229607, points = 1}, -- Thalassian Leatherworker's Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229608, points = 1}, -- Thalassian Skinning Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229609, points = 1}, -- Thalassian Pickaxe
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229610, points = 1}, -- Thalassian Sickle
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229611, points = 1}, -- Thalassian Blacksmith's Toolbox
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229612, points = 1}, -- Thalassian Leatherworker's Toolset
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229613, points = 1}, -- Thalassian Needle Set
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229646, points = 1}, -- Farstrider's Chopper
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229647, points = 1}, -- Magister's Valediction
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229648, points = 1}, -- Blood Knight's Warblade
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229649, points = 1}, -- Bloomforged Claw
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229650, points = 1}, -- Magister's Ritual Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229651, points = 1}, -- Magister's Mana Sword
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229652, points = 1}, -- Blood Knight's Mercy
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229653, points = 1}, -- Blood Knight's Impetus
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229654, points = 1}, -- Magister's Cleaver
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229655, points = 1}, -- Bloomforged Greataxe
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229656, points = 1}, -- Spellbreaker's Ultimatum
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229657, points = 1}, -- Spellbreaker's Warglaive
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229658, points = 1}, -- Spellbreaker's Blade
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229659, points = 1}, -- Farstrider's Mercy
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230768, points = 1}, -- Murder Row Fishhook
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229614, points = 1}, -- Primalforged Heavy Axe
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229615, points = 1}, -- Dawnforged Splitter
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229616, points = 1}, -- Dawnforged War Mace
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229617, points = 1}, -- Primalforged Knuckles
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229618, points = 1}, -- Dawnforged Long Blade
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229619, points = 1}, -- Dawnforged Edge
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229620, points = 1}, -- Dawnforged Ritual Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229660, points = 1}, -- Spellbreaker's Resolve
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229661, points = 1}, -- Spellbreaker's Mantle
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229662, points = 1}, -- Spellbreaker's Bracers
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229663, points = 1}, -- Spellbreaker's Legguards
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229664, points = 1}, -- Spellbreaker's Cover
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229665, points = 1}, -- Spellbreaker's Rebuke
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229666, points = 1}, -- Spellbreaker's Girdle
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229667, points = 1}, -- Spellbreaker's Shelter
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229668, points = 1}, -- Spellbreaker's March
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230766, points = 1}, -- Murder Row Fleet Feet
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230767, points = 1}, -- Knight-Commander's Palisade
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229621, points = 1}, -- Blood-Tempered Gauntlets
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229622, points = 1}, -- Blood-Tempered Pauldrons
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229623, points = 1}, -- Blood-Tempered Bracers
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229624, points = 1}, -- Blood-Tempered Leggings
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229625, points = 1}, -- Blood-Tempered Basinet
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229626, points = 1}, -- Blood-Tempered Bulwark
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229627, points = 1}, -- Blood-Tempered Greatbelt
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229628, points = 1}, -- Blood-Tempered Chestplate
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229629, points = 1}, -- Blood-Tempered Greaves
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229630, points = 1}, -- Thalassian Competitor's Sword
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229631, points = 1}, -- Thalassian Competitor's Greatsword
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229632, points = 1}, -- Thalassian Competitor's Skewer
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229633, points = 1}, -- Thalassian Competitor's Splitter
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229634, points = 1}, -- Thalassian Competitor's Bulwark
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229635, points = 1}, -- Thalassian Competitor's Maxim
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229636, points = 1}, -- Thalassian Competitor's Knife
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229637, points = 1}, -- Thalassian Competitor's Pickaxe
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229638, points = 1}, -- Thalassian Competitor's Plate Armguards
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229639, points = 1}, -- Thalassian Competitor's Plate Waistguard
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229640, points = 1}, -- Thalassian Competitor's Plate Pauldrons
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229641, points = 1}, -- Thalassian Competitor's Plate Helm
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229642, points = 1}, -- Thalassian Competitor's Plate Gauntlets
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229643, points = 1}, -- Thalassian Competitor's Plate Sabatons
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229644, points = 1}, -- Thalassian Competitor's Plate Greaves
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1229645, points = 1}, -- Thalassian Competitor's Plate Breastplate
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230758, points = 1}, -- Refulgent Whetstone
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230759, points = 1}, -- Refulgent Weightstone
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230760, points = 1}, -- Refulgent Razorstone
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230761, points = 1}, -- Refulgent Copper Ingot
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230762, points = 1}, -- Gloaming Alloy
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230763, points = 1}, -- Sterling Alloy
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1230764, points = 1}, -- Refulgent Repair Hammer
  {skillLineVariantID = 2907, categoryID = category, quests = {},      spellID = 1265906, points = 1}, -- Thalassian Skeleton Key
  -- Midnight: Enchanting
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236069, points = 1}, -- Enchant Chest - Mark of the Worldsoul
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236054, points = 1}, -- Enchant Chest - Mark of Nalorakk
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236082, points = 1}, -- Enchant Chest - Mark of the Magister
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236068, points = 1}, -- Enchant Chest - Mark of the Rootwarden
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236070, points = 1}, -- Enchant Helm - Blessing of Speed
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236055, points = 1}, -- Enchant Helm - Hex of Leeching
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236083, points = 1}, -- Enchant Helm - Rune of Avoidance
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236071, points = 1}, -- Enchant Helm - Empowered Blessing of Speed
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236056, points = 1}, -- Enchant Helm - Empowered Hex of Leeching
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236084, points = 1}, -- Enchant Helm - Empowered Rune of Avoidance
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236057, points = 1}, -- Enchant Boots - Lynx's Dexterity
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236072, points = 1}, -- Enchant Boots - Shaladrassil's Roots
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236085, points = 1}, -- Enchant Boots - Farstrider's Hunt
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236058, points = 1}, -- Enchant Ring - Amani Mastery
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236073, points = 1}, -- Enchant Ring - Nature's Wrath
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236087, points = 1}, -- Enchant Ring - Thalassian Versatility
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236086, points = 1}, -- Enchant Ring - Thalassian Haste
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236060, points = 1}, -- Enchant Ring - Zul'jin's Mastery
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236088, points = 1}, -- Enchant Ring - Silvermoon's Alacrity
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236059, points = 1}, -- Enchant Ring - Eyes of the Eagle
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236074, points = 1}, -- Enchant Ring - Nature's Fury
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236089, points = 1}, -- Enchant Ring - Silvermoon's Tenacity
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236090, points = 1}, -- Enchant Shoulders - Thalassian Recovery
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236061, points = 1}, -- Enchant Shoulders - Flight of the Eagle
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236075, points = 1}, -- Enchant Shoulders - Nature's Grace
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236091, points = 1}, -- Enchant Shoulders - Silvermoon's Mending
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236062, points = 1}, -- Enchant Shoulders - Akil'zon's Swiftness
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236076, points = 1}, -- Enchant Shoulders - Amirdrassil's Grace
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236066, points = 1}, -- Enchant Weapon - Jan'alai's Precision
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236080, points = 1}, -- Enchant Weapon - Worldsoul Aegis
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236097, points = 1}, -- Enchant Weapon - Arcane Mastery
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236067, points = 1}, -- Enchant Weapon - Berserker's Rage
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236079, points = 1}, -- Enchant Weapon - Worldsoul Cradle
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236094, points = 1}, -- Enchant Weapon - Flames of the Sin'dorei
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236065, points = 1}, -- Enchant Weapon - Strength of Halazzi
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236081, points = 1}, -- Enchant Weapon - Worldsoul Tenacity
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236095, points = 1}, -- Enchant Weapon - Acuity of the Ren'dorei
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236092, points = 1}, -- Enchant Tool - Sin'dorei Deftness
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236064, points = 1}, -- Enchant Tool - Amani Resourcefulness
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236077, points = 1}, -- Enchant Tool - Haranir Finesse
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236063, points = 1}, -- Enchant Tool - Amani Perception
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236078, points = 1}, -- Enchant Tool - Haranir Multicrafting
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236093, points = 1}, -- Enchant Tool - Ren'dorei Ingenuity
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236098, points = 1}, -- Illusory Adornment - Blooming Light
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236099, points = 1}, -- Illusory Adornment - Nature's Embrace
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236100, points = 1}, -- Illusory Adornment - Voidtouched
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236464, points = 1}, -- Gleeful Glamour - Haranir
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236473, points = 1}, -- Gleeful Glamour - Mag'har Orc
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236474, points = 1}, -- Gleeful Glamour - Mechagnome
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236467, points = 1}, -- Gleeful Glamour - Gnome
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236468, points = 1}, -- Gleeful Glamour - Goblin
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236478, points = 1}, -- Gleeful Glamour - Pandaren
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236480, points = 1}, -- Gleeful Glamour - Troll
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236463, points = 1}, -- Gleeful Glamour - Dark Iron Dwarf
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236469, points = 1}, -- Gleeful Glamour - Highmountain Tauren
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236472, points = 1}, -- Gleeful Glamour - Lightforged Draenei
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236471, points = 1}, -- Gleeful Glamour - Kul Tiran
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236485, points = 1}, -- Gleeful Glamour - Zandalari Troll
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236483, points = 1}, -- Gleeful Glamour - Vulpera
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236484, points = 1}, -- Gleeful Glamour - Worgen
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236482, points = 1}, -- Gleeful Glamour - Void Elf
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236476, points = 1}, -- Gleeful Glamour - Nightborne
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236479, points = 1}, -- Gleeful Glamour - Tauren
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236465, points = 1}, -- Gleeful Glamour - Draenei
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236470, points = 1}, -- Gleeful Glamour - Human
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236477, points = 1}, -- Gleeful Glamour - Orc
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236481, points = 1}, -- Gleeful Glamour - Undead
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236466, points = 1}, -- Gleeful Glamour - Dwarf
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236594, points = 1}, -- Gleeful Glamour - Earthen
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236461, points = 1}, -- Gleeful Glamour - Blood Elf
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236475, points = 1}, -- Gleeful Glamour - Night Elf
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236486, points = 1}, -- Runed Refulgent Copper Rod
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236487, points = 1}, -- Runed Brilliant Silver Rod
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236488, points = 1}, -- Runed Dazzling Thorium Rod
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236489, points = 1}, -- Thalassian Spellweaver's Wand
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236490, points = 1}, -- Magister's Grand Focus
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236491, points = 1}, -- Thalassian Phoenix Oil
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236492, points = 1}, -- Oil of Dawn
  {skillLineVariantID = 2909, categoryID = category, quests = {},      spellID = 1236493, points = 1}, -- Smuggler's Enchanted Edge
  -- Midnight: Engineering
  {skillLineVariantID = 2910, categoryID = category, quests = {90138}, spellID = 1229755, points = 1}, -- Song Gear
  {skillLineVariantID = 2910, categoryID = category, quests = {90229}, spellID = 1229853, points = 1}, -- Soul Sprocket
  {skillLineVariantID = 2910, categoryID = category, quests = {90234}, spellID = 1229856, points = 1}, -- Perfected Cogwheel
  {skillLineVariantID = 2910, categoryID = category, quests = {90233}, spellID = 1229857, points = 1}, -- Greased Cogwheel
  {skillLineVariantID = 2910, categoryID = category, quests = {90235}, spellID = 1229858, points = 1}, -- Consistent Cogwheel
  {skillLineVariantID = 2910, categoryID = category, quests = {90232}, spellID = 1229859, points = 1}, -- Flux Cogwheel
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1282456, points = 1}, -- P.O.W. x3
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1282455, points = 1}, -- Evercore Dome Dinger
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1282457, points = 1}, -- Thalassian Competitor's Rifle
  {skillLineVariantID = 2910, categoryID = category, quests = {90259}, spellID = 1229870, points = 1}, -- Aetherlume Eye Wrap
  {skillLineVariantID = 2910, categoryID = category, quests = {90260}, spellID = 1229871, points = 1}, -- Aetherlume Optics
  {skillLineVariantID = 2910, categoryID = category, quests = {90261}, spellID = 1229872, points = 1}, -- Aetherlume Vision Shroud
  {skillLineVariantID = 2910, categoryID = category, quests = {90262}, spellID = 1229873, points = 1}, -- Aetherlume Sun Guard
  {skillLineVariantID = 2910, categoryID = category, quests = {90263}, spellID = 1229874, points = 1}, -- Aetherlume Silken Cuffs
  {skillLineVariantID = 2910, categoryID = category, quests = {90264}, spellID = 1229875, points = 1}, -- Aetherlume Bands
  {skillLineVariantID = 2910, categoryID = category, quests = {90265}, spellID = 1229876, points = 1}, -- Aetherlume Bracelets
  {skillLineVariantID = 2910, categoryID = category, quests = {90266}, spellID = 1229877, points = 1}, -- Aetherlume Guards
  {skillLineVariantID = 2910, categoryID = category, quests = {90287}, spellID = 1229878, points = 1}, -- Aetherlume Softsteppers
  {skillLineVariantID = 2910, categoryID = category, quests = {90288}, spellID = 1229879, points = 1}, -- Aetherlume Runners
  {skillLineVariantID = 2910, categoryID = category, quests = {90289}, spellID = 1229880, points = 1}, -- Aetherlume Clonkers
  {skillLineVariantID = 2910, categoryID = category, quests = {90290}, spellID = 1229881, points = 1}, -- Aetherlume Stompers
  {skillLineVariantID = 2910, categoryID = category, quests = {90267}, spellID = 1229862, points = 1}, -- Evercore Zoomshroud
  {skillLineVariantID = 2910, categoryID = category, quests = {90268}, spellID = 1229863, points = 1}, -- Evercore Shade
  {skillLineVariantID = 2910, categoryID = category, quests = {90269}, spellID = 1229864, points = 1}, -- Evercore Reconissance
  {skillLineVariantID = 2910, categoryID = category, quests = {90270}, spellID = 1229865, points = 1}, -- Evercore Vision Guard
  {skillLineVariantID = 2910, categoryID = category, quests = {90295}, spellID = 1229866, points = 1}, -- Evercore Wrist Latch
  {skillLineVariantID = 2910, categoryID = category, quests = {90296}, spellID = 1229867, points = 1}, -- Evercore Binding
  {skillLineVariantID = 2910, categoryID = category, quests = {90297}, spellID = 1229868, points = 1}, -- Evercore Chainguards
  {skillLineVariantID = 2910, categoryID = category, quests = {90298}, spellID = 1229869, points = 1}, -- Evercore Gear Weight
  {skillLineVariantID = 2910, categoryID = category, quests = {90291}, spellID = 1229935, points = 1}, -- Evercore Swiftfeet
  {skillLineVariantID = 2910, categoryID = category, quests = {90292}, spellID = 1229936, points = 1}, -- Evercore Stichwraps
  {skillLineVariantID = 2910, categoryID = category, quests = {90293}, spellID = 1229937, points = 1}, -- Evercore Turbochains
  {skillLineVariantID = 2910, categoryID = category, quests = {90294}, spellID = 1229938, points = 1}, -- Evercore Greaseplates
  {skillLineVariantID = 2910, categoryID = category, quests = {90275}, spellID = 1229882, points = 1}, -- Quel'dorei Cloth Goggles
  {skillLineVariantID = 2910, categoryID = category, quests = {90276}, spellID = 1229883, points = 1}, -- Quel'dorei Leather Optics
  {skillLineVariantID = 2910, categoryID = category, quests = {90277}, spellID = 1229884, points = 1}, -- Quel'dorei Mail Shroud
  {skillLineVariantID = 2910, categoryID = category, quests = {90278}, spellID = 1229885, points = 1}, -- Quel'dorei Visor
  {skillLineVariantID = 2910, categoryID = category, quests = {90271}, spellID = 1229886, points = 1}, -- Quel'dorei Silken Cuffs
  {skillLineVariantID = 2910, categoryID = category, quests = {90272}, spellID = 1229887, points = 1}, -- Quel'dorei Bands
  {skillLineVariantID = 2910, categoryID = category, quests = {90273}, spellID = 1229888, points = 1}, -- Quel'dorei Bracelets
  {skillLineVariantID = 2910, categoryID = category, quests = {90274}, spellID = 1229889, points = 1}, -- Quel'dorei Guards
  {skillLineVariantID = 2910, categoryID = category, quests = {90283}, spellID = 1229890, points = 1}, -- Quel'dorei Softsteppers
  {skillLineVariantID = 2910, categoryID = category, quests = {90284}, spellID = 1229891, points = 1}, -- Quel'dorei Runners
  {skillLineVariantID = 2910, categoryID = category, quests = {90285}, spellID = 1229892, points = 1}, -- Quel'dorei Clonkers
  {skillLineVariantID = 2910, categoryID = category, quests = {90286}, spellID = 1229893, points = 1}, -- Quel'dorei Stompers
  {skillLineVariantID = 2910, categoryID = category, quests = {90251}, spellID = 1229908, points = 1}, -- Thalassian Competitor's Cloth Goggles
  {skillLineVariantID = 2910, categoryID = category, quests = {90252}, spellID = 1229909, points = 1}, -- Thalassian Competitor's Leather Optics
  {skillLineVariantID = 2910, categoryID = category, quests = {90253}, spellID = 1229910, points = 1}, -- Thalassian Competitor's Mail Visor
  {skillLineVariantID = 2910, categoryID = category, quests = {90254}, spellID = 1229911, points = 1}, -- Thalassian Competitor's Plate Guard
  {skillLineVariantID = 2910, categoryID = category, quests = {90255}, spellID = 1229912, points = 1}, -- Thalassian Competitor's Cloth Cuffs
  {skillLineVariantID = 2910, categoryID = category, quests = {90256}, spellID = 1229913, points = 1}, -- Thalassian Competitor's Leather Bands
  {skillLineVariantID = 2910, categoryID = category, quests = {90257}, spellID = 1229914, points = 1}, -- Thalassian Competitor's Mail Links
  {skillLineVariantID = 2910, categoryID = category, quests = {90258}, spellID = 1229915, points = 1}, -- Thalassian Competitor's Plate Bindings
  {skillLineVariantID = 2910, categoryID = category, quests = {90258}, spellID = 1261490, points = 1}, -- Thalassian Competitor's Cloth Tip-Toes
  {skillLineVariantID = 2910, categoryID = category, quests = {90258}, spellID = 1261491, points = 1}, -- Thalassian Competitor's Leather Sliders
  {skillLineVariantID = 2910, categoryID = category, quests = {90258}, spellID = 1261492, points = 1}, -- Thalassian Competitor's Mail Footlinks
  {skillLineVariantID = 2910, categoryID = category, quests = {90258}, spellID = 1261493, points = 1}, -- Thalassian Competitor's Plate Dunkers
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264523, points = 1}, -- Head-Mounted Beam Bummer
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264524, points = 1}, -- Rock Bonkin' Hardhat
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264525, points = 1}, -- Heavy-Duty Rock Assister
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264526, points = 1}, -- Self-Sharpening Sin'dorei Snippers
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264527, points = 1}, -- Sin'dorei Reeler's Rod
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264528, points = 1}, -- Giga-Gem Grippers
  {skillLineVariantID = 2910, categoryID = category, quests = {},      spellID = 1264529, points = 1}, -- Turbo-Junker's Multitool v9
  {skillLineVariantID = 2910, categoryID = category, quests = {90240}, spellID = 1229894, points = 1}, -- Sin'dorei Headlamp
  {skillLineVariantID = 2910, categoryID = category, quests = {90246}, spellID = 1229897, points = 1}, -- Sin'dorei Gilded Hardhat
  {skillLineVariantID = 2910, categoryID = category, quests = {90242}, spellID = 1229902, points = 1}, -- Sin'dorei Angler's Rod
  {skillLineVariantID = 2910, categoryID = category, quests = {90248}, spellID = 1229903, points = 1}, -- Turbo-Junker's Multitool
  {skillLineVariantID = 2910, categoryID = category, quests = {90244}, spellID = 1229905, points = 1}, -- Sin'dorei Clampers
  {skillLineVariantID = 2910, categoryID = category, quests = {90238}, spellID = 1229907, points = 1}, -- Sin'dorei Snippers
  {skillLineVariantID = 2910, categoryID = category, quests = {90250}, spellID = 1229906, points = 1}, -- Junker's Big Ol' Bag
  {skillLineVariantID = 2910, categoryID = category, quests = {90241}, spellID = 1229895, points = 1}, -- Farstrider Hobbyist Rod
  {skillLineVariantID = 2910, categoryID = category, quests = {90247}, spellID = 1229896, points = 1}, -- Junker's Multitool
  {skillLineVariantID = 2910, categoryID = category, quests = {90243}, spellID = 1229898, points = 1}, -- Farstrider Clampers
  {skillLineVariantID = 2910, categoryID = category, quests = {90249}, spellID = 1229899, points = 1}, -- Farstrider Rock Satchel
  {skillLineVariantID = 2910, categoryID = category, quests = {90237}, spellID = 1229900, points = 1}, -- Farstrider Fabric Cutters
  {skillLineVariantID = 2910, categoryID = category, quests = {90239}, spellID = 1229901, points = 1}, -- Junker's Junk Visor
  {skillLineVariantID = 2910, categoryID = category, quests = {90245}, spellID = 1229904, points = 1}, -- Farstrider Hardhat
  {skillLineVariantID = 2910, categoryID = category, quests = {90318}, spellID = 1229921, points = 1}, -- HU5H, Nonchalant Pup
  {skillLineVariantID = 2910, categoryID = category, quests = {90308}, spellID = 1229924, points = 1}, -- M3DDY
  {skillLineVariantID = 2910, categoryID = category, quests = {90300}, spellID = 1229917, points = 1}, -- M3DDY, Travel-Sized
  {skillLineVariantID = 2910, categoryID = category, quests = {90307}, spellID = 1229922, points = 1}, -- B1P, Scorcher of Souls
  {skillLineVariantID = 2910, categoryID = category, quests = {93236}, spellID = 1261945, points = 1}, -- B0P, Curator of Booms
  {skillLineVariantID = 2910, categoryID = category, quests = {90302}, spellID = 1229926, points = 1}, -- W-47CH D0G
  {skillLineVariantID = 2910, categoryID = category, quests = {90306}, spellID = 1229916, points = 1}, -- Lucky Keychain
  {skillLineVariantID = 2910, categoryID = category, quests = {90299}, spellID = 1229919, points = 1}, -- Kinetic Ankle Primers
  {skillLineVariantID = 2910, categoryID = category, quests = {90304}, spellID = 1229928, points = 1}, -- Wormhole Generator: Quel'Thalas
  {skillLineVariantID = 2910, categoryID = category, quests = {90311}, spellID = 1229923, points = 1}, -- Emergency Soul Link
  {skillLineVariantID = 2910, categoryID = category, quests = {90303}, spellID = 1229927, points = 1}, -- Curious Red Button
  {skillLineVariantID = 2910, categoryID = category, quests = {93228}, spellID = 1261866, points = 1}, -- Farstrider's Hawkeye
  {skillLineVariantID = 2910, categoryID = category, quests = {93230}, spellID = 1261893, points = 1}, -- Smuggler's Lynxeye
  {skillLineVariantID = 2910, categoryID = category, quests = {93231}, spellID = 1261895, points = 1}, -- Laced Zoomshots
  {skillLineVariantID = 2910, categoryID = category, quests = {93231}, spellID = 1261913, points = 1}, -- Weighted Boomshots
  -- Midnight: Herbalism
  {skillLineVariantID = 2912, categoryID = category, quests = {87729}, spellID = 1223099, points = 1}, -- Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87730}, spellID = 1223148, points = 1}, -- Lush Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87731}, spellID = 1224883, points = 1}, -- Lightfused Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87734}, spellID = 1224898, points = 1}, -- Voidbound Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87733}, spellID = 1224888, points = 1}, -- Primal Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87732}, spellID = 1224893, points = 1}, -- Wild Tranquility Bloom
  {skillLineVariantID = 2912, categoryID = category, quests = {87735}, spellID = 1223135, points = 1}, -- Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87736}, spellID = 1223151, points = 1}, -- Lush Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87737}, spellID = 1224886, points = 1}, -- Lightfused Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87740}, spellID = 1224901, points = 1}, -- Voidbound Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87739}, spellID = 1224891, points = 1}, -- Primal Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87738}, spellID = 1224896, points = 1}, -- Wild Sanguithorn
  {skillLineVariantID = 2912, categoryID = category, quests = {87741}, spellID = 1223137, points = 1}, -- Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87742}, spellID = 1223150, points = 1}, -- Lush Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87743}, spellID = 1224885, points = 1}, -- Lightfused Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87746}, spellID = 1224900, points = 1}, -- Voidbound Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87745}, spellID = 1224890, points = 1}, -- Primal Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87744}, spellID = 1224895, points = 1}, -- Wild Azeroot
  {skillLineVariantID = 2912, categoryID = category, quests = {87747}, spellID = 1223138, points = 1}, -- Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87748}, spellID = 1223146, points = 1}, -- Lush Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87749}, spellID = 1224882, points = 1}, -- Lightfused Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87752}, spellID = 1224897, points = 1}, -- Voidbound Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87751}, spellID = 1224887, points = 1}, -- Primal Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87750}, spellID = 1224892, points = 1}, -- Wild Argentleaf
  {skillLineVariantID = 2912, categoryID = category, quests = {87753}, spellID = 1223139, points = 1}, -- Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87755}, spellID = 1224884, points = 1}, -- Lightfused Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87754}, spellID = 1223149, points = 1}, -- Lush Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87758}, spellID = 1224899, points = 1}, -- Voidbound Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87757}, spellID = 1224889, points = 1}, -- Primal Mana Lily
  {skillLineVariantID = 2912, categoryID = category, quests = {87756}, spellID = 1224894, points = 1}, -- Wild Mana Lily
  -- Midnight: Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {90389}, spellID = 1230016, points = 1}, -- Sienna Ink
  {skillLineVariantID = 2913, categoryID = category, quests = {90390}, spellID = 1230017, points = 1}, -- Munsell Ink
  {skillLineVariantID = 2913, categoryID = category, quests = {90391}, spellID = 1230018, points = 1}, -- Codified Azeroot
  {skillLineVariantID = 2913, categoryID = category, quests = {90392}, spellID = 1230019, points = 1}, -- Soul Cipher
  {skillLineVariantID = 2913, categoryID = category, quests = {90393}, spellID = 1230020, points = 1}, -- Hobbyist Rolling Pin
  {skillLineVariantID = 2913, categoryID = category, quests = {90394}, spellID = 1230021, points = 1}, -- Hobbyist Alchemist's Mixing Rod
  {skillLineVariantID = 2913, categoryID = category, quests = {90395}, spellID = 1230022, points = 1}, -- Hobbyist Scribe's Quill
  {skillLineVariantID = 2913, categoryID = category, quests = {90396}, spellID = 1230023, points = 1}, -- Sin'dorei Rolling Pin
  {skillLineVariantID = 2913, categoryID = category, quests = {90397}, spellID = 1230024, points = 1}, -- Sin'dorei Alchemist's Mixing Rod
  {skillLineVariantID = 2913, categoryID = category, quests = {90398}, spellID = 1230025, points = 1}, -- Sin'dorei Quill
  {skillLineVariantID = 2913, categoryID = category, quests = {},      spellID = 1264550, points = 1}, -- Gilded Alchemist's Mixing Rod
  {skillLineVariantID = 2913, categoryID = category, quests = {},      spellID = 1264551, points = 1}, -- Gilded Sin'dorei Rolling Pin
  {skillLineVariantID = 2913, categoryID = category, quests = {},      spellID = 1264552, points = 1}, -- Gilded Sin'dorei Quill
  {skillLineVariantID = 2913, categoryID = category, quests = {90399}, spellID = 1230026, points = 1}, -- Thalassian Treatise on Blacksmithing
  {skillLineVariantID = 2913, categoryID = category, quests = {90400}, spellID = 1230027, points = 1}, -- Thalassian Treatise on Mining
  {skillLineVariantID = 2913, categoryID = category, quests = {90401}, spellID = 1230028, points = 1}, -- Thalassian Treatise on Herbalism
  {skillLineVariantID = 2913, categoryID = category, quests = {90402}, spellID = 1230029, points = 1}, -- Thalassian Treatise on Jewelcrafting
  {skillLineVariantID = 2913, categoryID = category, quests = {90403}, spellID = 1230030, points = 1}, -- Thalassian Treatise on Enchanting
  {skillLineVariantID = 2913, categoryID = category, quests = {90404}, spellID = 1230031, points = 1}, -- Thalassian Treatise on Leatherworking
  {skillLineVariantID = 2913, categoryID = category, quests = {90405}, spellID = 1230032, points = 1}, -- Thalassian Treatise on Inscription
  {skillLineVariantID = 2913, categoryID = category, quests = {90406}, spellID = 1230033, points = 1}, -- Thalassian Treatise on Tailoring
  {skillLineVariantID = 2913, categoryID = category, quests = {90407}, spellID = 1230034, points = 1}, -- Thalassian Treatise on Alchemy
  {skillLineVariantID = 2913, categoryID = category, quests = {90408}, spellID = 1230035, points = 1}, -- Thalassian Treatise on Skinning
  {skillLineVariantID = 2913, categoryID = category, quests = {90409}, spellID = 1230036, points = 1}, -- Thalassian Treatise on Engineering
  {skillLineVariantID = 2913, categoryID = category, quests = {90410}, spellID = 1230037, points = 1}, -- Thalassian Missive of the Quickblade
  {skillLineVariantID = 2913, categoryID = category, quests = {90411}, spellID = 1230038, points = 1}, -- Thalassian Missive of the Peerless
  {skillLineVariantID = 2913, categoryID = category, quests = {90412}, spellID = 1230039, points = 1}, -- Thalassian Missive of the Harmonious
  {skillLineVariantID = 2913, categoryID = category, quests = {90413}, spellID = 1230040, points = 1}, -- Thalassian Missive of the Fireflash
  {skillLineVariantID = 2913, categoryID = category, quests = {90414}, spellID = 1230041, points = 1}, -- Thalassian Missive of the Feverflare
  {skillLineVariantID = 2913, categoryID = category, quests = {90415}, spellID = 1230042, points = 1}, -- Thalassian Missive of the Aurora
  {skillLineVariantID = 2913, categoryID = category, quests = {90416}, spellID = 1230043, points = 1}, -- Thalassian Missive of Deftness
  {skillLineVariantID = 2913, categoryID = category, quests = {90417}, spellID = 1230044, points = 1}, -- Thalassian Missive of Perception
  {skillLineVariantID = 2913, categoryID = category, quests = {90418}, spellID = 1230045, points = 1}, -- Thalassian Missive of Finesse
  {skillLineVariantID = 2913, categoryID = category, quests = {90419}, spellID = 1230046, points = 1}, -- Thalassian Missive of Crafting Speed
  {skillLineVariantID = 2913, categoryID = category, quests = {90420}, spellID = 1230047, points = 1}, -- Thalassian Missive of Multicraft
  {skillLineVariantID = 2913, categoryID = category, quests = {90421}, spellID = 1230048, points = 1}, -- Thalassian Missive of Resourcefulness
  {skillLineVariantID = 2913, categoryID = category, quests = {90422}, spellID = 1230049, points = 1}, -- Thalassian Missive of Ingenuity
  {skillLineVariantID = 2913, categoryID = category, quests = {90423}, spellID = 1230050, points = 1}, -- Vantus Rune: Radiant
  {skillLineVariantID = 2913, categoryID = category, quests = {90424}, spellID = 1230051, points = 1}, -- Contract: The Silvermoon Court
  {skillLineVariantID = 2913, categoryID = category, quests = {90425}, spellID = 1230052, points = 1}, -- Contract: The Amani Tribe
  {skillLineVariantID = 2913, categoryID = category, quests = {90426}, spellID = 1230053, points = 1}, -- Contract: The Hara'ti
  {skillLineVariantID = 2913, categoryID = category, quests = {90427}, spellID = 1230054, points = 1}, -- Contract: The Singularity
  {skillLineVariantID = 2913, categoryID = category, quests = {90428}, spellID = 1230055, points = 1}, -- Faunatender's Baton
  {skillLineVariantID = 2913, categoryID = category, quests = {90429}, spellID = 1230056, points = 1}, -- Floratender's Crutch
  {skillLineVariantID = 2913, categoryID = category, quests = {90430}, spellID = 1230057, points = 1}, -- Rootwarden's Lamp
  {skillLineVariantID = 2913, categoryID = category, quests = {90431}, spellID = 1230058, points = 1}, -- Faunatender's Trust
  {skillLineVariantID = 2913, categoryID = category, quests = {90432}, spellID = 1230059, points = 1}, -- Aln'hara Pikestaff
  {skillLineVariantID = 2913, categoryID = category, quests = {90433}, spellID = 1230060, points = 1}, -- Aln'hara Cane
  {skillLineVariantID = 2913, categoryID = category, quests = {90434}, spellID = 1230061, points = 1}, -- Aln'hara Lantern
  {skillLineVariantID = 2913, categoryID = category, quests = {90435}, spellID = 1230062, points = 1}, -- Aln'hara Sprigshot
  {skillLineVariantID = 2913, categoryID = category, quests = {90437}, spellID = 1230064, points = 1}, -- Thalassian Competitor's Lamp
  {skillLineVariantID = 2913, categoryID = category, quests = {90438}, spellID = 1230065, points = 1}, -- Thalassian Competitor's Staff
  {skillLineVariantID = 2913, categoryID = category, quests = {90439}, spellID = 1230066, points = 1}, -- Thalassian Competitor's Pillar
  {skillLineVariantID = 2913, categoryID = category, quests = {90440}, spellID = 1230067, points = 1}, -- Thalassian Competitor's Emblem
  {skillLineVariantID = 2913, categoryID = category, quests = {90441}, spellID = 1230068, points = 1}, -- Thalassian Competitor's Insignia of Alacrity
  {skillLineVariantID = 2913, categoryID = category, quests = {90442}, spellID = 1230069, points = 1}, -- Thalassian Competitor's Medallion
  {skillLineVariantID = 2913, categoryID = category, quests = {93124}, spellID = 1260760, points = 1}, -- Thalassian Competitor's Bow
  {skillLineVariantID = 2913, categoryID = category, quests = {90443}, spellID = 1230070, points = 1}, -- Darkmoon Dominion: Blood
  {skillLineVariantID = 2913, categoryID = category, quests = {90444}, spellID = 1230071, points = 1}, -- Darkmoon Dominion: Rot
  {skillLineVariantID = 2913, categoryID = category, quests = {90445}, spellID = 1230072, points = 1}, -- Darkmoon Dominion: Hunt
  {skillLineVariantID = 2913, categoryID = category, quests = {90446}, spellID = 1230073, points = 1}, -- Darkmoon Dominion: Void
  {skillLineVariantID = 2913, categoryID = category, quests = {90447}, spellID = 1230074, points = 1}, -- Darkmoon Sigil: Blood
  {skillLineVariantID = 2913, categoryID = category, quests = {90448}, spellID = 1230075, points = 1}, -- Darkmoon Sigil: Rot
  {skillLineVariantID = 2913, categoryID = category, quests = {90449}, spellID = 1230076, points = 1}, -- Darkmoon Sigil: Hunt
  {skillLineVariantID = 2913, categoryID = category, quests = {90450}, spellID = 1230077, points = 1}, -- Darkmoon Sigil: Void
  -- Midnight: Jewelcrafting
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230474, points = 1}, -- Kaleidoscopic Prism
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230475, points = 1}, -- Sin'dorei Lens
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230476, points = 1}, -- Sunglass Vial
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230477, points = 1}, -- Prismatic Focusing Iris
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230478, points = 1}, -- Stabilizing Gemstone Bandolier
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230437, points = 1}, -- Quick Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230439, points = 1}, -- Deadly Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230440, points = 1}, -- Masterful Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230441, points = 1}, -- Versatile Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230442, points = 1}, -- Flawless Quick Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230443, points = 1}, -- Flawless Deadly Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230444, points = 1}, -- Flawless Masterful Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230445, points = 1}, -- Flawless Versatile Peridot
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230446, points = 1}, -- Quick Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230447, points = 1}, -- Deadly Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230448, points = 1}, -- Masterful Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230449, points = 1}, -- Versatile Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230450, points = 1}, -- Flawless Quick Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230451, points = 1}, -- Flawless Deadly Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230452, points = 1}, -- Flawless Masterful Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230453, points = 1}, -- Flawless Versatile Lapis
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230454, points = 1}, -- Quick Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230455, points = 1}, -- Deadly Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230456, points = 1}, -- Masterful Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230457, points = 1}, -- Versatile Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230458, points = 1}, -- Flawless Quick Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230459, points = 1}, -- Flawless Deadly Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230460, points = 1}, -- Flawless Masterful Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230461, points = 1}, -- Flawless Versatile Amethyst
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230462, points = 1}, -- Quick Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230463, points = 1}, -- Deadly Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230464, points = 1}, -- Masterful Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230465, points = 1}, -- Versatile Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230466, points = 1}, -- Flawless Quick Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230467, points = 1}, -- Flawless Deadly Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230468, points = 1}, -- Flawless Masterful Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230469, points = 1}, -- Flawless Versatile Garnet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230470, points = 1}, -- Powerful Eversong Diamond
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230471, points = 1}, -- Telluric Eversong Diamond
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230472, points = 1}, -- Stoic Eversong Diamond
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230473, points = 1}, -- Indecipherable Eversong Diamond
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230481, points = 1}, -- Harandar Peridot Prism
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230482, points = 1}, -- Amani Lapis Prism
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230483, points = 1}, -- Tenebrous Amethyst Prism
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230484, points = 1}, -- Sanguine Garnet Prism
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230485, points = 1}, -- Masterwork Sin'dorei Band
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230479, points = 1}, -- Loa Worshiper's Band
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230487, points = 1}, -- Signet of Azerothian Blessings
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230489, points = 1}, -- Gleaming Copper Band
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230486, points = 1}, -- Masterwork Sin'dorei Amulet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230488, points = 1}, -- Thalassian Phoenix Torque
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1251983, points = 1}, -- Voidstone Shielding Array
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230490, points = 1}, -- Nocturnal Charm
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230491, points = 1}, -- Silvermoon Focusing Shard
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230492, points = 1}, -- Silvermoon Loupes
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230493, points = 1}, -- Fantastic Font Focuser
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230494, points = 1}, -- Bold Biographer's Bifocals
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230495, points = 1}, -- Sin'dorei Enchanter's Crystal
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230496, points = 1}, -- Sin'dorei Jeweler's Loupes
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230497, points = 1}, -- Improved Right-Handed Magnifying Glass
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230498, points = 1}, -- Sin'dorei Scribe's Spectacles
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1242461, points = 1}, -- Mage-Eye Precision Loupes
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1242462, points = 1}, -- Thalassian Scribe's Crystalline Lens
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1242463, points = 1}, -- Flawless Text Scrutinizers
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1242464, points = 1}, -- Attuned Thalassian Rune-Prism
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230499, points = 1}, -- Monologuer's Chalice
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230500, points = 1}, -- Determined Heliotrope
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230501, points = 1}, -- Cognitive Heliotrope
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230502, points = 1}, -- Enduring Heliotrope
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230503, points = 1}, -- Thalassian Competitor's Signet
  {skillLineVariantID = 2914, categoryID = category, quests = {},      spellID = 1230504, points = 1}, -- Thalassian Competitor's Amulet
  -- Midnight: Leatherworking
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237490, points = 1}, -- Thalassian Competitor's Leather Boots
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237491, points = 1}, -- Thalassian Competitor's Leather Chestpiece
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237492, points = 1}, -- Thalassian Competitor's Leather Gloves
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237493, points = 1}, -- Thalassian Competitor's Leather Mask
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237494, points = 1}, -- Thalassian Competitor's Leather Trousers
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237495, points = 1}, -- Thalassian Competitor's Leather Shoulderpads
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237496, points = 1}, -- Thalassian Competitor's Leather Belt
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237497, points = 1}, -- Thalassian Competitor's Leather Wristwraps
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237499, points = 1}, -- Smuggler's Leather Tunic
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237500, points = 1}, -- Smuggler's Leather Footpads
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237501, points = 1}, -- Smuggler's Reinforced Gloves
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237502, points = 1}, -- Smuggler's Reinforced Hood
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237503, points = 1}, -- Smuggler's Reinforced Pants
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237504, points = 1}, -- Smuggler's Reinforced Shoulderguards
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237505, points = 1}, -- Smuggler's Reinforced Binding
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237506, points = 1}, -- Smuggler's Leather Wristbands
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237507, points = 1}, -- Silvermoon Agent's Coat
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237508, points = 1}, -- Silvermoon Agent's Sneakers
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237509, points = 1}, -- Silvermoon Agent's Handwraps
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237510, points = 1}, -- Silvermoon Agent's Cover
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237511, points = 1}, -- Silvermoon Agent's Leggings
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237512, points = 1}, -- Silvermoon Agent's Mantle
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237513, points = 1}, -- Silvermoon Agent's Utility Belt
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237514, points = 1}, -- Silvermoon Agent's Deflectors
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237486, points = 1}, -- Row Walker's Deflectors
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237487, points = 1}, -- Row Walker's Insurance
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237488, points = 1}, -- Row Walker's Swiftgrips
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237489, points = 1}, -- Hexwoven Strand
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237498, points = 1}, -- World Tree Rootwraps
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237520, points = 1}, -- Thalassian Competitor's Chain Tunic
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237521, points = 1}, -- Thalassian Competitor's Chain Stompers
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237522, points = 1}, -- Thalassian Competitor's Chain Grips
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237523, points = 1}, -- Thalassian Competitor's Chain Cowl
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237524, points = 1}, -- Thalassian Competitor's Chain Leggings
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237525, points = 1}, -- Thalassian Competitor's Chain Epaulets
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237526, points = 1}, -- Thalassian Competitor's Chain Girdle
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237527, points = 1}, -- Thalassian Competitor's Chain Cuffs
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237528, points = 1}, -- Scout's Scaled Vest
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237529, points = 1}, -- Scout's Scaled Boots
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237530, points = 1}, -- Scout's Polished Gauntlets
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237531, points = 1}, -- Scout's Polished Skullcap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237532, points = 1}, -- Scout's Polished Legguards
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237533, points = 1}, -- Scout's Polished Spaulders
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237534, points = 1}, -- Scout's Polished Wrap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237535, points = 1}, -- Scout's Scaled Bracers
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237536, points = 1}, -- Farstrider's Scouting Vest
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237537, points = 1}, -- Farstrider's Razor Talons
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237538, points = 1}, -- Farstrider's Sharpened Claws
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237539, points = 1}, -- Farstrider's Unwavering Visage
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237540, points = 1}, -- Farstrider's Reinforced Faulds
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237541, points = 1}, -- Farstrider's Brilliant Plumes
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237542, points = 1}, -- Farstrider's Trophy Belt
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237543, points = 1}, -- Farstrider's Plated Bracers
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237515, points = 1}, -- Ranger-General's Grips
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237516, points = 1}, -- Axe-Flingin' Bands
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237517, points = 1}, -- World Tender's Trunkplate
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237518, points = 1}, -- World Tender's Rootslippers
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237519, points = 1}, -- World Tender's Barkclasp
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237544, points = 1}, -- Forest Hunter's Armor Kit
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237545, points = 1}, -- Blood Knight's Armor Kit
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237546, points = 1}, -- Thalassian Scout Armor Kit
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237547, points = 1}, -- Void-touched Drums
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237548, points = 1}, -- Chemist's Cap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237549, points = 1}, -- Sin'dorei Alchemist's Hat
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237550, points = 1}, -- Thalassian Alchemist's Mixcap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237551, points = 1}, -- Apprentice Smith's Apron
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237552, points = 1}, -- Sin'dorei Forgemaster's Cover
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237553, points = 1}, -- Thalassian Ironbender's Regalia
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237554, points = 1}, -- Tinker's Handguard
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237555, points = 1}, -- Sin'dorei Engineer's Gloves
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237556, points = 1}, -- Thalassian Scrapmaster's Gauntlets
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237557, points = 1}, -- Eversong Botanist's Satchel
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237558, points = 1}, -- Sin'dorei Herbalist's Backpack
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237559, points = 1}, -- Thalassian Herbtender's Cradle
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237560, points = 1}, -- Apprentice Jeweler's Apron
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237561, points = 1}, -- Sin'dorei Jeweler's Cover
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237562, points = 1}, -- Thalassian Gemshaper's Grand Cover
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237563, points = 1}, -- Hideworker's Cover
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237564, points = 1}, -- Sin'dorei Leathershaper's Smock
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237565, points = 1}, -- Thalassian Hideshaper's Regalia
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237566, points = 1}, -- Skinner's Backpack
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237567, points = 1}, -- Sin'dorei Hunter's Pack
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237568, points = 1}, -- Thalassian Wildseeker's Workbag
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237569, points = 1}, -- Skinner's Cap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237570, points = 1}, -- Eversong Hunter's Headcover
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237571, points = 1}, -- Thalassian Wildseeker's Stridercap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237572, points = 1}, -- Scalewoven Hide
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237573, points = 1}, -- Infused Scalewoven Hide
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237574, points = 1}, -- Sin'dorei Armor Banding
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237575, points = 1}, -- Silvermoon Weapon Wrap
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237577, points = 1}, -- Blessed Pango Charm
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237578, points = 1}, -- Primal Spore Binding
  {skillLineVariantID = 2915, categoryID = category, quests = {},      spellID = 1237579, points = 1}, -- Devouring Banding
  -- Midnight: Mining
  {skillLineVariantID = 2916, categoryID = category, quests = {88475}, spellID = 1225343, points = 1}, -- Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88476}, spellID = 1225349, points = 1}, -- Rich Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88480}, spellID = 1225350, points = 1}, -- Refulgent Copper Seam
  {skillLineVariantID = 2916, categoryID = category, quests = {88479}, spellID = 1225354, points = 1}, -- Primal Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88487}, spellID = 1225351, points = 1}, -- Lightfused Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88486}, spellID = 1225353, points = 1}, -- Wild Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88463}, spellID = 1225352, points = 1}, -- Voidbound Refulgent Copper
  {skillLineVariantID = 2916, categoryID = category, quests = {88477}, spellID = 1225347, points = 1}, -- Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88478}, spellID = 1225365, points = 1}, -- Rich Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88481}, spellID = 1225366, points = 1}, -- Umbral Tin Seam
  {skillLineVariantID = 2916, categoryID = category, quests = {88469}, spellID = 1225369, points = 1}, -- Primal Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88488}, spellID = 1225367, points = 1}, -- Lightfused Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88485}, spellID = 1225368, points = 1}, -- Wild Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88470}, spellID = 1225370, points = 1}, -- Voidbound Umbral Tin
  {skillLineVariantID = 2916, categoryID = category, quests = {88471}, spellID = 1225348, points = 1}, -- Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88491}, spellID = 1225355, points = 1}, -- Rich Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88466}, spellID = 1225357, points = 1}, -- Brilliant Silver Seam
  {skillLineVariantID = 2916, categoryID = category, quests = {88490}, spellID = 1225361, points = 1}, -- Primal Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88484}, spellID = 1225359, points = 1}, -- Lightfused Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88472}, spellID = 1225363, points = 1}, -- Wild Brilliant Silver
  {skillLineVariantID = 2916, categoryID = category, quests = {88465}, spellID = 1225362, points = 1}, -- Voidbound Brilliant Silver
  -- Midnight: Tailoring
  {skillLineVariantID = 2918, categoryID = category, quests = {90082}, spellID = 1227926, points = 1}, -- Arcanoweave Bolt
  {skillLineVariantID = 2918, categoryID = category, quests = {90083}, spellID = 1228060, points = 1}, -- Sunfire Silk Bolt
  {skillLineVariantID = 2918, categoryID = category, quests = {90016}, spellID = 1228939, points = 1}, -- Bright Linen Bolt
  {skillLineVariantID = 2918, categoryID = category, quests = {90017}, spellID = 1228940, points = 1}, -- Imbued Bright Linen Bolt
  {skillLineVariantID = 2918, categoryID = category, quests = {90018}, spellID = 1228941, points = 1}, -- Bright Linen Bandage
  {skillLineVariantID = 2918, categoryID = category, quests = {90058}, spellID = 1228981, points = 1}, -- Sunfire Bracers
  {skillLineVariantID = 2918, categoryID = category, quests = {90059}, spellID = 1228982, points = 1}, -- Sunfire Cloak
  {skillLineVariantID = 2918, categoryID = category, quests = {90060}, spellID = 1228983, points = 1}, -- Sunfire Treads
  {skillLineVariantID = 2918, categoryID = category, quests = {90064}, spellID = 1228987, points = 1}, -- Sunfire Sash
  {skillLineVariantID = 2918, categoryID = category, quests = {90061}, spellID = 1228984, points = 1}, -- Arcanoweave Bracers
  {skillLineVariantID = 2918, categoryID = category, quests = {90062}, spellID = 1228985, points = 1}, -- Arcanoweave Cloak
  {skillLineVariantID = 2918, categoryID = category, quests = {90063}, spellID = 1228986, points = 1}, -- Arcanoweave Treads
  {skillLineVariantID = 2918, categoryID = category, quests = {90065}, spellID = 1228988, points = 1}, -- Arcanoweave Cord
  {skillLineVariantID = 2918, categoryID = category, quests = {90019}, spellID = 1228942, points = 1}, -- Martyr's Crown
  {skillLineVariantID = 2918, categoryID = category, quests = {90020}, spellID = 1228943, points = 1}, -- Martyr's Gloves
  {skillLineVariantID = 2918, categoryID = category, quests = {90021}, spellID = 1228944, points = 1}, -- Martyr's Waistwrap
  {skillLineVariantID = 2918, categoryID = category, quests = {90022}, spellID = 1228945, points = 1}, -- Martyr's Bindings
  {skillLineVariantID = 2918, categoryID = category, quests = {90023}, spellID = 1228946, points = 1}, -- Martyr's Vestments
  {skillLineVariantID = 2918, categoryID = category, quests = {90024}, spellID = 1228947, points = 1}, -- Martyr's Leggings
  {skillLineVariantID = 2918, categoryID = category, quests = {90025}, spellID = 1228948, points = 1}, -- Martyr's Slippers
  {skillLineVariantID = 2918, categoryID = category, quests = {90026}, spellID = 1228949, points = 1}, -- Martyr's Mantle
  {skillLineVariantID = 2918, categoryID = category, quests = {90027}, spellID = 1228950, points = 1}, -- Adherent's Silken Shroud
  {skillLineVariantID = 2918, categoryID = category, quests = {90028}, spellID = 1228951, points = 1}, -- Courtly Helm
  {skillLineVariantID = 2918, categoryID = category, quests = {90029}, spellID = 1228952, points = 1}, -- Courtly Gloves
  {skillLineVariantID = 2918, categoryID = category, quests = {90030}, spellID = 1228953, points = 1}, -- Courtly Belt
  {skillLineVariantID = 2918, categoryID = category, quests = {90031}, spellID = 1228954, points = 1}, -- Courtly Wrists
  {skillLineVariantID = 2918, categoryID = category, quests = {90032}, spellID = 1228955, points = 1}, -- Courtly Robes
  {skillLineVariantID = 2918, categoryID = category, quests = {90033}, spellID = 1228956, points = 1}, -- Courtly Pants
  {skillLineVariantID = 2918, categoryID = category, quests = {90034}, spellID = 1228957, points = 1}, -- Courtly Slippers
  {skillLineVariantID = 2918, categoryID = category, quests = {90035}, spellID = 1228958, points = 1}, -- Courtly Cloak
  {skillLineVariantID = 2918, categoryID = category, quests = {90036}, spellID = 1228959, points = 1}, -- Courtly Shoulders
  {skillLineVariantID = 2918, categoryID = category, quests = {90066}, spellID = 1228989, points = 1}, -- Thalassian Competitor's Cloth Bands
  {skillLineVariantID = 2918, categoryID = category, quests = {90067}, spellID = 1228990, points = 1}, -- Thalassian Competitor's Cloth Cloak
  {skillLineVariantID = 2918, categoryID = category, quests = {90068}, spellID = 1228991, points = 1}, -- Thalassian Competitor's Cloth Gloves
  {skillLineVariantID = 2918, categoryID = category, quests = {90069}, spellID = 1228992, points = 1}, -- Thalassian Competitor's Cloth Hood
  {skillLineVariantID = 2918, categoryID = category, quests = {90070}, spellID = 1228993, points = 1}, -- Thalassian Competitor's Cloth Leggings
  {skillLineVariantID = 2918, categoryID = category, quests = {90071}, spellID = 1228994, points = 1}, -- Thalassian Competitor's Cloth Sash
  {skillLineVariantID = 2918, categoryID = category, quests = {90072}, spellID = 1228995, points = 1}, -- Thalassian Competitor's Cloth Shoulderpads
  {skillLineVariantID = 2918, categoryID = category, quests = {90073}, spellID = 1228996, points = 1}, -- Thalassian Competitor's Cloth Treads
  {skillLineVariantID = 2918, categoryID = category, quests = {90074}, spellID = 1228997, points = 1}, -- Thalassian Competitor's Cloth Tunic
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1280541, points = 1}, -- Smuggler's Cloak
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1280542, points = 1}, -- Silvermoon Agent's Drape
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1280543, points = 1}, -- Scout's Cape
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1280544, points = 1}, -- Farstrider's Embroidered Cover
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1280545, points = 1}, -- Blood-Tempered Cape
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1280546, points = 1}, -- Spellbreaker's Shroud
  {skillLineVariantID = 2918, categoryID = category, quests = {90037}, spellID = 1228960, points = 1}, -- Sunfire Silk Lining
  {skillLineVariantID = 2918, categoryID = category, quests = {90038}, spellID = 1228961, points = 1}, -- Arcanoweave Lining
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1279123, points = 1}, -- Thalassian Alchemy Coveralls
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1279124, points = 1}, -- Thalassian Chef's Chapeau
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1279125, points = 1}, -- Thalassian Enchanter's Bonnet
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1279128, points = 1}, -- Thalassian Herbalist's Cowl
  {skillLineVariantID = 2918, categoryID = category, quests = {},      spellID = 1279129, points = 1}, -- Thalassian Tailor's Threads
  {skillLineVariantID = 2918, categoryID = category, quests = {90039}, spellID = 1228962, points = 1}, -- Elegant Artisan's Alchemy Coveralls
  {skillLineVariantID = 2918, categoryID = category, quests = {90040}, spellID = 1228963, points = 1}, -- Elegant Artisan's Cooking Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90041}, spellID = 1228964, points = 1}, -- Elegant Artisan's Enchanting Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90042}, spellID = 1228965, points = 1}, -- Elegant Artisan's Fishing Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90043}, spellID = 1228966, points = 1}, -- Elegant Artisan's Herbalism Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90044}, spellID = 1228967, points = 1}, -- Elegant Artisan's Tailoring Robe
  {skillLineVariantID = 2918, categoryID = category, quests = {90045}, spellID = 1228968, points = 1}, -- Bright Linen Alchemy Apron
  {skillLineVariantID = 2918, categoryID = category, quests = {90046}, spellID = 1228969, points = 1}, -- Chef's Bright Linen Cooking Chapeau
  {skillLineVariantID = 2918, categoryID = category, quests = {90047}, spellID = 1228970, points = 1}, -- Bright Linen Enchanting Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90048}, spellID = 1228971, points = 1}, -- Bright Linen Fishing Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90049}, spellID = 1228972, points = 1}, -- Bright Linen Herbalism Hat
  {skillLineVariantID = 2918, categoryID = category, quests = {90050}, spellID = 1228973, points = 1}, -- Bright Linen Tailoring Robe
  {skillLineVariantID = 2918, categoryID = category, quests = {90051}, spellID = 1228974, points = 1}, -- Sunfire Silk Spellthread
  {skillLineVariantID = 2918, categoryID = category, quests = {90052}, spellID = 1228975, points = 1}, -- Arcanoweave Spellthread
  {skillLineVariantID = 2918, categoryID = category, quests = {90053}, spellID = 1228976, points = 1}, -- Bright Linen Spellthread
  {skillLineVariantID = 2918, categoryID = category, quests = {90054}, spellID = 1228977, points = 1}, -- Imbued Bright Linen Backpack
  {skillLineVariantID = 2918, categoryID = category, quests = {90055}, spellID = 1228978, points = 1}, -- Bright Linen Reagent Satchel
  {skillLineVariantID = 2918, categoryID = category, quests = {90056}, spellID = 1228979, points = 1}, -- Arcanoweave Reagent Rucksack
  {skillLineVariantID = 2918, categoryID = category, quests = {90057}, spellID = 1228980, points = 1}, -- Sunfire Silk Backpack
}

Data.Objectives = Utils:TableMerge(Data.Objectives, objectives)
