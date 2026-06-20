---@class WK_Expansion
---@field id Enum.ExpansionLevel
---@field enabled boolean
---@field abbr string
---@field name string

---@class WK_Faction
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field name string

---@class WK_Currency
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field name string

---@class WK_SkillLine
---@field id integer
---@field name string

---@class WK_SkillLineVariant
---@field id integer
---@field expansionID Enum.ExpansionLevel
---@field skillLineID integer
---@field name string
---@field catchUpCurrencyID integer
---@field catchUpItemID integer
---@field concentrationCurrencyID integer

---@enum Enum.WK_Factions
Enum.WK_Faction = {
  AmaniTribe = 2696,
  TheSingularity = 2699,
  Harati = 2704,
  SilvermoonCity = 2710,
}

---@enum Enum.WK_Currencies
Enum.WK_Currency = {
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

---@enum Enum.WK_Maps
Enum.WK_Map = {
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
