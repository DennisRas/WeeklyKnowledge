local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "esES")
if not L then return end

-- Spanish translation by Ghordjan

-- Core strings
L["WeeklyReset"] = "Reinicio semanal: ¡Buen trabajo! El progreso de tus personajes se ha reiniciado para una nueva semana.";

L["TooltipLine1"] = "|cff00ff00Clic Izquierdo|r para abrir WeeklyKnowledge.";
L["TooltipLine2"] = "|cff00ff00Clic Derecho|r para abrir la Lista de Verificación.";
L["TooltipLine3"] = "|cff00ff00Arrastrar|r para mover este icono";
L["TooltipLocked"] = " |cffff0000(bloqueado)|r";

-- Main strings
L["CloseTheWindow"] = "Cerrar la ventana";

L["Settings"] = "Opciones";
L["SettingsDesc"] = "Vamos a personalizar esto un poco";
L["ShowTheMinimapButton"] = "Mostrar el botón del minimap";
L["ShowMinimapIconDesc"] = "A veces esto está muy concurrido.";
L["LockMinimapIcon"] = "Bloquear el botón del minimap";
L["LockMinimapIconDesc"] = "Ya no volveremos a mover el botón accidentalmente!";

L["BackgroundColor"] = "Color de fondo";
L["ShowTheBorder"] = "Mostrar el borde";
L["Window"] = "Ventana";
L["Scaling"] = "Escalado";

L["Characters"] = "Personajes";
L["CharactersDesc"] = "Habilitar/Deshabilitar tus personajes.";

L["Columns"] = "Columnas";
L["ColumnsDesc"] = "Habilitar/Deshabilitar columnas de la tabla.";

L["Checklist"] = "Lista de Verificación";
L["ChecklistDesc"] = "Alternar la ventana de Verificación";

L["Name"] = "Nombre";
L["NameDesc"] = "Tus Personajes";

L["Realm"] = "Reinos";
L["RealmDesc"] = "Nombre de los Reinos.";

L["Profession"] = "Profesión";
L["ProfessionDesc"] = "Tus Profesiones";

L["Skill"] = "Habilidad";
L["SkillDesc"] = "Nivel Actual de Habilidad.";

L["Knowledge"] = "Conocimiento";
L["KnowledgePoints"] = "Puntos de Conocimiento";
L["KnowledgePointsDesc"] = "Conocimiento ganada actualmente";

L["PointsSpentAt"] = "Puntos Gastados:";
L["PointsUnspentAt"] = "Puntos Por Gastar:";
L["CanUnlock"] = "Puede desbloquear";
L["Locked"] = "Bloqueado";
L["CanUnlock"] = "Se puede desbloquear";
L["MaxAt"] = "Máx:";
L["SpecializationsAt"] = "Especializaciones:";

L["Items"] = "Items:";
L["Quests"] = "Misiones:";
L["KnowledgePointsAt"] = "Puntos de Conocimiento:";

L["ItemLinkLoading"] = "Cargando...";

L["Catch-Up"] = "Ponerse al día";
L["Catch-UpDesc"] = "lleva un registro de tu progreso en Puntos de conocimiento y ponte al día con los puntos de las semanas anteriores.\n\nTen en cuenta que los puntos del Tratado no están incluidos en los cálculos de esta semana.";

L["NoData"] = "Sin datos";
L["NoDataDesc"] = "Inicia sesión para obtener los datos de este personaje.";

L["WeeklyPointsAt"] = "Puntos Semanales:";
L["Catch-UpPointsAt"] = "Puntos de puesta al día:";
L["TotalAt"] = "Total:";

L["UnlockCatch-UpDesc"] = "Desbloquea la función de puesta al día esta semana:";
L["fmtPoints"] = "%s Puntos";
L["Catch-UpSpc"] = "Puesta al día ";
L["Gathering"] = "Recogiendo";
L["PatronOrders"] = "Pedidos de Clientes";

-- Data strings
L["Uniques"] = "Únicos";
L["Uniques_Desc"] = "Estos son elementos de puntos de conocimiento de un solo uso que se encuentran en tesoros de todo el mundo y que venden los vendedores Artesanos, de Renombre y Kej.\n\nRepetible: ";

L["Weekly"] = "Semanal";
L["NonRepeatable"] = "No";

L["Treatise"] = "Tratado";
L["Treatise_Desc"] = "Los escribas pueden fabricarlos. Envía una orden de fabricación si no tienes la profesión de inscripción.\n\nRepetible: ";

L["Artisan"] = "Artesano";
L["ArtisanQuest_Desc"] = "Misión: Kala Clayhoof del Consorcio de Artesanos quiere que cumplas pedidos de fabricación.\n\nRepetible: ";

L["Treasure"] = "Tesoro";
L["Treasure_Desc"] = "Estos se obtienen al azar de tesoros y tierra alrededor del mundo.\n\nRepetible:";

L["Gathering"] = "Recolección";
L["Gathering_Desc"] = "Estos se obtienen al azar de los nodos de recolección en todo el mundo. Es posible que (no confirmado) encuentres aleatoriamente elementos adicionales más allá del límite semanal.\n\nEstos también se obtienen al desencantar.\n\nRepetible: ";

L["Trainer"] = "Entrenador";
L["TrainerQuest_Desc"] = "Misión: Completa una misión en tu entrenador de profesión.\n\nRepetible: ";

L["Darkmoon"] = "Feria de la Luna Negra";
L["DarkmoonQuest_Desc"] = "Misión: Completa una misión en la Feria de la Luna Negra.\n\nRepetible: ";
L["Monthly"] = "Mensual";

-- Data.Professions
L["Alchemy"] = "Alquímia"
L["Blacksmithing"] = "Herrería"
L["Enchanting"] = "Encantamiento"
L["Engineering"] = "Ingeniería"
L["Herbalism"] = "Herbolistería"
L["Inscription"] = "Inscripción"
L["Jewelcrafting"] = "Joyería"
L["Leatherworking"] = "Peletería"
L["Mining"] = "Minería"
L["Skinning"] = "Desueyo"
L["Tailoring"] = "Sastrería"

-- Data.Objectives hints

L["Vendor_Lyrendal_Hint"] = "Este artículo se puede comprar al vendedor Lyrendal en Dornogal."
L["Vendor_Siesbarg_Hint"] = "Este artículo se puede comprar al vendedor Siesbarg en Ciudad de Hilos."
L["Vendor_Auditor_Balwurz_Hint"] = "Este artículo se puede comprar al vendedor Auditor Balwurz en Dornogal."
L["Vendor_Rakka_Hint"] = "Este artículo se puede comprar al vendedor Rakka en Ciudad de Hilos."
L["Vendor_Iliani_Hint"] = "Este artículo se puede comprar al vendedor Iliani en Ciudad de Hilos."
L["Vendor_Rukku_Hint"] = "Este artículo se puede comprar al vendedor Rukku en Ciudad de Hilos."
L["Vendor_Waxmonger_Squick_Hint"] = "Este artículo se puede comprar al vendedor Cerero Squick en Cavernas Resonantes."
L["Vendor_Llyot_hint"] = "Este artículo se puede comprar al vendedor Llyot en Ciudad de Hilos."
L["Vendor_Auralia_Steelstrike_Hint"] = "Este artículo se puede comprar al vendedor Auralia Golpeacero en Hallowfall."
L["Vendor_Nuel_Prill_Hint"] = "Este artículo se puede comprar al vendedor Nuel Prill en Ciudad de Hilos."
L["Vendor_Alvus_Valavulu_Hint"] = "Este artículo se puede comprar al vendedor Alvus Valavulu en Ciudad de Hilos."
L["Vendor_Kama_Hint"] = "Este artículo se puede comprar al vendedor Kama en Ciudad de Hilos."
L["Vendor_Saaria_Hint"] = "Este artículo se puede comprar al vendedor Saaria en Ciudad de Hilos."

L["Crafting_Order_Inscription_Hint"] = "Realiza un pedido de fabricación si no puedes fabricar esto tú mismo con Inscripción."
L["Treasures_And_Dirt_Hint"] = "Estos son saqueados al azar de tesoros y tierra alrededor del mundo."
L["Object_Location_Hint"] = "Este artículo se puede encontrar en un objeto en la ubicación siguiente."

L["Quest_Kala_Clayhoof_Hint"] = "Completa una misión de Kala Pezuñarcilla en el Consorcio de Artesanos."

L["Randomly_Looted_Disenchanting_Hint"] = "Estos se obtienen aleatoriamente al desencantar objetos."
L["Randomly_Looted_Herbs_Hint"] = "Estos se extraen aleatoriamente de hierbas de todo el mundo."
L["Randomly_Looted_Mining_Hint"] = "Estos se obtienen aleatoriamente de los nodos de minería de todo el mundo."
L["Randomly_Looted_Skinning_Hint"] = "Estos se obtienen aleatoriamente de los nodos de desueyo en todo el mundo."

L["Talk_Sylannia_Darkmoon_Quest_29506_Hint"] = "Habla con |cff00ff00Sylannia|r en la Feria de la Luna Negra y completa la misión |cffffff00A Burbujas moradas|r."
L["Talk_Yebb_Neblegear_Darkmoon_Quest_29508_Hint"] = "Habla con |cff00ff00Yebb Neblegear|r en la Feria de la Luna Negra y completa la misión |cffffff00 Peque necesita un par zapatos|r.\n\nPista: hay un yunque detrás de la tienda de reliquias."
L["Talk_Sayge_Darkmoon_Quest_29510_Hint"] = "Habla con |cff00ff00Sayge|r en la Feria de la Luna Negra y completa la misión |cffffff00 Aprovechar la basura|r."
L["Talk_Rinling_Darkmoon_Quest_29511_Hint"] = "Habla con |cff00ff00Rinling|r en la Feria de la Luna Negra y completa la misión |cffffff00 Hablando de tonques|r."
L["Talk_Chronos_Darkmoon_Quest_29514_Hint"] = "Habla con |cff00ff00Chronos|r en la Feria de la Luna Negra y completa la misión |cffffff00 Hierbas sanadoras|r."
L["Talk_Sayge_Darkmoon_Quest_29515_Hint"] = "Habla con |cff00ff00Sayge|r en la Feria de la Luna Negra y completa la misión |cffffff00 Escribiendo el futuro|r."
L["Talk_Chronos_Darkmoon_Quest_29516_Hint"] = "Habla con |cff00ff00Chronos|r en la Feria de la Luna Negra y completa la misión |cffffff00 Que brille la feria|r."
L["Talk_Rinling_Darkmoon_Quest_29517_Hint"] = "Habla con |cff00ff00Rinling|r en la Feria de la Luna Negra y completa la misión |cffffff00 Ojo al premio|r."
L["Talk_Rinling_Darkmoon_Quest_29518_Hint"] = "Habla con |cff00ff00Rinling|r en la Feria de la Luna Negra y completa la misión |cffffff00 Rearma, reutiliza, recicla|r."
L["Talk_Chronos_Darkmoon_Quest_29519_Hint"] = "Habla con |cff00ff00Chronos|r en la Feria de la Luna Negra y completa la misión |cffffff00 Pieles al sol|r."
L["Talk_Selina_Dourman_Darkmoon_Quest_29520_Hint"] = "Habla con |cff00ff00Selina Dourman|r en la Feria de la Luna Negra y completa la misión |cffffff00 Estandartes por doquier!|r."

L["Talk_Enchanting_Trainer_Hint"] = "Habla con tu instructor de encantamiento |cff00ff00Nagad|r y completa la misión."
L["Talk_Herbalism_Trainer_Hint"] = "Habla con tu instructor de herbolistería |cff00ff00Akdan|r y completa la misión."
L["Talk_Mining_Trainer_Hint"] = "Habla con tu instructor de minería |cff00ff00Tarib|r y completa la misión."
L["Talk_Skinning_Trainer_Hint"] = "Habla con tu instructor de desueyo |cff00ff00Ginnad|r y completa la misión."

L["Item_226265_Hint"] = "Este objeto es un barril que se encuentra detrás de los pilares, junto a la puerta."
L["Item_226266_Hint"] = "Este objeto es un marco de metal que se encuentra encima de un gran cofre."
L["Item_226267_Hint"] = "Este objeto es una botella que se encuentra en la mesa dentro del edificio, en el piso inferior."
L["Item_226268_Hint"] = "Este objeto es una varilla que se encuentra junto a la forja dentro del edificio, en el piso inferior."
L["Item_226269_Hint"] = "Este objeto es una botella que se encuentra en la mesa cerca de la fuente."
L["Item_226270_Hint"] = "Este objeto es un mortero que se encuentra en la mesa dentro del edificio del orfanato."
L["Item_226271_Hint"] = "Este objeto es una botella que se encuentra en el escritorio dentro del edificio."
L["Item_226272_Hint"] = "Este objeto es un frasco que se encuentra en la mesa rota del edificio."
L["Item_226276_Hint"] = "Este objeto es un yunque que se encuentra dentro del edificio."
L["Item_226277_Hint"] = "Este objeto es un martillo que se encuentra en un cubo."
L["Item_226278_Hint"] = "Este objeto es un tornillo de banco para martillo que se encuentra junto a la forja."
L["Item_226279_Hint"] = "Este objeto es un cincel que se encuentra en el suelo junto a la forja."
L["Item_226280_Hint"] = "Este objeto es un yunque que se encuentra en la mesa."
L["Item_226281_Hint"] = "Este objeto es un par de tenazas que se encuentran en la mesa."
L["Item_226282_Hint"] = "Este objeto es una caja que se encuentra en el suelo."
L["Item_226283_Hint"] = "Este objeto es un pincel que se encuentra en la mesa dentro del edificio."
L["Item_226284_Hint"] = "Este objeto es una botella que se encuentra en una mesa."
L["Item_226285_Hint"] = "Este objeto está apoyado contra un pilar de madera junto a la secretaria Gretal."
L["Item_226286_Hint"] = "Este objeto es un orbe que se encuentra en el suelo."
L["Item_226287_Hint"] = "Este objeto es una botella que se encuentra en una mesa dentro del edificio."
L["Item_226288_Hint"] = "Este objeto es una vela que se encuentra en una caja dentro del edificio."
L["Item_226289_Hint"] = "Este objeto es un pergamino que se encuentra en una mesa dentro del edificio."
L["Item_226290_Hint"] = "Este objeto es un libro que se encuentra en una mesa."
L["Item_226291_Hint"] = "Este objeto es un fragmento morado que se encuentra en la mesa de la izquierda."
L["Item_226292_Hint"] = "Este objeto es una llave inglesa que se encuentra en la mesa del edificio."
L["Item_226293_Hint"] = "Este objeto se puede encontrar en la mesa detrás de Madam Goya."
L["Item_226294_Hint"] = "Este objeto es una bomba que se encuentra en una caja junto a los raíles."
L["Item_226295_Hint"] = "Este objeto es un pergamino que se encuentra en el suelo detrás de la mesa dentro del edificio."
L["Item_226296_Hint"] = "Este objeto es una bolsa que se encuentra en la parte superior de las escaleras."
L["Item_226297_Hint"] = "Este objeto es una caja que se encuentra en la aeronave detrás de la entrada de la mazmorra."
L["Item_226298_Hint"] = "Este objeto es una araña mecánica que se encuentra en la mesa en la parte trasera de la posada."
L["Item_226299_Hint"] = "Este objeto es un bote que se encuentra en el suelo junto al arpón."
L["Item_226300_Hint"] = "Este objeto es una flor que se encuentra en un macizo de flores."
L["Item_226301_Hint"] = "Este objeto es una guadaña que se encuentra en la parte inferior del árbol."
L["Item_226302_Hint"] = "Este objeto es un tenedor que se encuentra en la mesa dentro del edificio."
L["Item_226303_Hint"] = "Este objeto es un cuchillo que se encuentra en el suelo."
L["Item_226304_Hint"] = "Este objeto es una paleta que se encuentra en el suelo."
L["Item_226305_Hint"] = "Este objeto es unas tenazas que se encuentran junto a las escaleras."
L["Item_226306_Hint"] = "Este objeto es una flor que se encuentra en el suelo, debajo de la estatua."
L["Item_226307_Hint"] = "Este objeto es una pala que se encuentra en el escritorio."
L["Item_226308_Hint"] = "Este objeto es una pluma que se encuentra en el estante de la parte trasera de la casa de subastas."
L["Item_226309_Hint"] = "Este objeto es un bolígrafo que se encuentra en el estante del edificio."
L["Item_226310_Hint"] = "Este objeto es un pergamino que se encuentra en la mesa dentro del edificio."
L["Item_226311_Hint"] = "Este objeto es una olla que se encuentra en la mesa dentro del edificio."
L["Item_226312_Hint"] = "Este objeto es una pluma que se encuentra en la mesa en la parte superior de las escaleras."
L["Item_226313_Hint"] = "Este objeto es un cincel que se encuentra en la mesa en el piso superior dentro del edificio."
L["Item_226314_Hint"] = "Este objeto es un pergamino que se encuentra en el piso de la plataforma principal central."
L["Item_226315_Hint"] = "Este objeto es un tintero que se encuentra en el escritorio dentro del edificio."
L["Item_226324_Hint"] = "Este objeto es una herramienta que se encuentra en el estante dentro del edificio."
L["Item_226325_Hint"] = "Este objeto es un cuchillo que se encontró en un fardo de heno dentro del edificio."
L["Item_226326_Hint"] = "Este objeto es una botella que se encontró en el estante dentro del edificio."
L["Item_226327_Hint"] = "Este objeto es una herramienta que se encontró en la mesa dentro del edificio."
L["Item_226328_Hint"] = "Este objeto es un par de tenazas que se encontraron en la mesa dentro del edificio."
L["Item_226329_Hint"] = "Este objeto es una herramienta que se encontró en un barril."
L["Item_226330_Hint"] = "Este objeto es un mazo que se encontró en la mesa dentro del edificio."
L["Item_226331_Hint"] = "Este objeto es un cuchillo que se encontró en el escritorio."
L["Item_226332_Hint"] = "Este objeto es un mazo que se encuentra en la mesa."
L["Item_226333_Hint"] = "Este objeto es un cincel que se encuentra en la estatua de cristal."
L["Item_226334_Hint"] = "Este objeto es una pala que se encuentra en el suelo."
L["Item_226335_Hint"] = "Este objeto es un mineral que se encuentra en el suelo."
L["Item_226336_Hint"] = "Este objeto es un taladro que se encuentra en la mesa debajo del edificio."
L["Item_226337_Hint"] = "Este objeto es una herramienta que se encuentra en la mesa detrás del entrenador de minería."
L["Item_226338_Hint"] = "Este objeto es una trituradora que se encuentra en el escritorio cerca de la forja."
L["Item_226339_Hint"] = "Este objeto es un carro que se encuentra en el suelo entre las flores y las raíces."
L["Item_226348_Hint"] = "Este objeto es un cuchillo que se encuentra en la mesa en la parte trasera del edificio."
L["Item_226349_Hint"] = "Este objeto es una cinta métrica que se encuentra en la mesa."
L["Item_226350_Hint"] = "Este objeto es un alfiler que se encuentra en el estante de la habitación trasera derecha de la posada."
L["Item_226351_Hint"] = "Este objeto es unas tijeras que se encuentran en la mesa."
L["Item_226352_Hint"] = "Este objeto es un cutter que se encuentra en la mesa."
L["Item_226353_Hint"] = "Este objeto es un transportador que se encuentra en una caja dentro del edificio."
L["Item_226354_Hint"] = "Este objeto es una colcha que se encuentra dentro del edificio a la izquierda."
L["Item_226355_Hint"] = "Este objeto es un alfiletero que se encuentra en el escritorio."

-- Interface strings

-- Checklist strings
L["Checklist"] = "Lista de Verificación"

L["Profession"] = "Profesión"
L["Category"] = "Categoría"
L["Location"] = "Ubicación"
L["Progress"] = "Progreso"
L["Points"] = "Puntos"
L["Objective"] = "Objetivo"

L["HideInCombat"] = "Ocultar en combate";
L["HideInDungeons"] = "Ocultar en mazmorras";
L["HideCompletedObjectives"] = "Ocultar objetivos completados";
L["HideAllUniques"] = "Ocultar todos los únicos";
L["HideAllUniquesDesc"] = "Ocultar todos los únicos por categoría";
L["HideVendorUniques"] = "Ocultar los únicos de vendedor";
L["HideVendorUniquesDesc"] = "Ocultar los únicos comprados a un vendedor.";

L["ToggleObjectives"] = "Alternar objetivos";
L["ToggleObjectivesDesc"] = "Expandir/Colapsar la lista.";

L["ZeroProfCount"] = "No parece que tengas ninguna profesión de TWW.";
L["LookPatronOrders"] = "Buen trabajo! Lo conseguiste :-)\nAsegúrate de echar un vistazo a tus pedidos de clientes!";

L["ShiftClickToLinkToChat"] = "<Mayúsculas Clic para Enlazar en el Chat>";

L["DoYouKnowTheWay"] = "¿Conoces el camino?";
L["LocationAt"] = "Ubicación:";
L["CoordinatesAt"] = "Coordenadas:";
L["RequirementsA"] = "Requisitos:";

L["ClickToPlaceAPinOnTheMap"] = "<Clic para colocar una marca en el mapa>";
L["ShiftClickToShareAPinInChat"] = "<Mayúsculas Clic para compartir la marca en el chat>";
L["AltClickToPlaceAWaypoint"] = "<Alt Clic para colocar un punto de ruta de TomTom>";

-- Types strings
