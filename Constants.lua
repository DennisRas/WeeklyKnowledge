---@class WK_Addon
local addon = select(2, ...)

---@class WK_Constants
local Constants = {}
addon.Constants = Constants

Constants.prefix = format("<%s> ", addon.name)
Constants.commands = {
  "wk",
}
Constants.TITLEBAR_HEIGHT = 30
Constants.TABLE_ROW_HEIGHT = 24
Constants.TABLE_HEADER_HEIGHT = 32
Constants.TABLE_CELL_PADDING = 8
Constants.MAX_WINDOW_HEIGHT = 500
Constants.currentCharacterNameMarker = "|TInterface\\FriendsFrame\\StatusIcon-Online:12:12:2:-2|t"

---@enum WK_ObjectiveCategoryId
Constants.objectiveCategory = {
  Unique = "Unique",
  FirstCraft = "FirstCraft",
  Treatise = "Treatise",
  ArtisanQuest = "ArtisanQuest",
  Treasure = "Treasure",
  Gathering = "Gathering",
  TrainerQuest = "TrainerQuest",
  DarkmoonQuest = "DarkmoonQuest",
  CatchUp = "CatchUp",
  WeeklyQuest = "WeeklyQuest",
}

---@enum WK_FactionId
Constants.faction = {
  AmaniTribe = 2696,
  TheSingularity = 2699,
  Harati = 2704,
  SilvermoonCity = 2710,
}

---@enum WK_CurrencyId
Constants.currency = {
  VoidlightMarl = 3316,
  ArtisanAlchemistMoxie = 3256,
  ArtisanBlacksmithMoxie = 3257,
  ArtisanEnchanterMoxie = 3258,
  ArtisanEngineerMoxie = 3259,
  ArtisanHerbalistMoxie = 3260,
  ArtisanScribeMoxie = 3261,
  ArtisanJewelcrafterMoxie = 3262,
  ArtisanLeatherworkerMoxie = 3263,
  ArtisanMinerMoxie = 3264,
  ArtisanSkinnerMoxie = 3265,
  ArtisanTailorMoxie = 3266,
  UnalloyedAbundance = 3377,
}

---@enum WK_MapId
Constants.map = {
  AtalAman = 2536,
  AzjKahet = 2255,
  CityOfThreads = 2213,
  DarkmoonIsland = 407,
  Dornogal = 2339,
  EversongWoods = 2395,
  Hallowfall = 2215,
  Harandar = 2413,
  IsleOfDorn = 2248,
  SilvermoonCity = 2393,
  SlayersRise = 2444,
  Tazavesh = 2472,
  TheRingingDeeps = 2214,
  Undermine = 2346,
  Voidstorm = 2405,
  ZulAman = 2437,
}
