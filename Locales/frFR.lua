local addonName = select(1, ...)
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "frFR")

if not L then
  return
end

-- Bindings and slash commands
L["binding_toggle_checklist"] = "Afficher ou masquer la fenêtre \"À faire\""
L["binding_toggle_main"] = "Afficher ou masquer la fenêtre WeeklyKnowledge"

L["command_drag"] = "Faire glisser"
L["command_hidden"] = "masqué"
L["command_left_click"] = "Clic gauche"
L["command_locked"] = "(verrouillé)"
L["command_minimap_status"] = "Bouton de minicarte %s."
L["command_right_click"] = "Clic droit"
L["command_shown"] = "affiché"
L["command_usage"] = "Utilisation : /wk [checklist | minimap]"

L["prompt_weekly_reset"] = "Réinitialisation hebdomadaire : Bien joué ! La progression de vos personnages a été réinitialisée pour une nouvelle semaine."

-- Common labels and statuses
L["label_categories"] = "Catégories"
L["label_category"] = "Catégorie"
L["label_characters"] = "Personnages"
L["label_checklist"] = "À faire"
L["label_columns"] = "Colonnes"
L["label_completed"] = "Terminé :"
L["label_concentration"] = "Concentration"
L["label_coordinates"] = "Coordonnées :"
L["label_error"] = "Erreur"
L["label_estimated"] = "Estimation"
L["label_expansion"] = "Extension"
L["label_items"] = "Objets :"
L["label_knowledge"] = "Connaissance"
L["label_knowledge_points"] = "Points de savoir"
L["label_last_saved"] = "Dernière sauvegarde"
L["label_loading"] = "Chargement..."
L["label_location"] = "Lieu"
L["label_location_colon"] = "Lieu :"
L["label_locked"] = "Verrouillé"
L["label_max"] = "Maximum :"
L["label_maxed_at"] = "Maximum atteint à :"
L["label_monthly"] = "Mensuel"
L["label_name"] = "Nom"
L["label_no"] = "Non"
L["label_no_data"] = "Aucune donnée"
L["label_objective"] = "Objectif"
L["label_objective_pin"] = "Épingle d'objectif"
L["label_points"] = "Points"
L["label_points_available"] = "Points disponibles :"
L["label_points_earned"] = "Points obtenus :"
L["label_points_spent"] = "Points dépensés :"
L["label_points_unspent"] = "Points non dépensés :"
L["label_profession"] = "Profession"
L["label_progress"] = "Progression"
L["label_quests"] = "Quêtes :"
L["label_realm"] = "Royaume"
L["label_remaining"] = "Restant :"
L["label_repeat"] = "Répétable ?"
L["label_requirements"] = "Conditions :"
L["label_rewards"] = "Récompenses :"
L["label_saved_at"] = "Sauvegardé le :"
L["label_settings"] = "Paramètres"
L["label_skill"] = "Compétence"
L["label_specializations"] = "Spécialisations :"
L["label_time_to_max"] = "Temps jusqu'au maximum :"
L["label_toggle_list"] = "Afficher ou masquer la liste"
L["label_unknown"] = "Inconnu"
L["label_unlock_catch_up"] = "Débloquer le rattrapage cette semaine :"
L["label_weekly"] = "Hebdomadaire"
L["label_window"] = "Fenêtre"
L["label_yes"] = "Oui"

L["status_can_unlock"] = "Peut être débloqué"

-- Buttons and menu options
L["button_background_color"] = "Couleur de fond"
L["button_lock_minimap"] = "Verrouiller le bouton de la minicarte"
L["button_remove_character"] = "Retirer le personnage"
L["button_scaling"] = "Échelle"
L["button_show_border"] = "Afficher la bordure"
L["button_show_full_profession_name"] = "Afficher le nom complet de la profession"
L["button_show_minimap"] = "Afficher le bouton de la minicarte"

L["menu_hide_completed_objectives"] = "Masquer les objectifs terminés"
L["menu_hide_in_combat"] = "Masquer en combat"
L["menu_hide_in_dungeons"] = "Masquer en donjon"
L["menu_hide_low_level_professions"] = "Masquer les professions de bas niveau"

-- Main and checklist window text
L["main_empty_state"] = "Il semble que vous n'ayez aucune profession active.\nAvez-vous peut-être filtré la mauvaise extension ou le mauvais personnage ci-dessus ?\n\nSi vous utilisez cet addon pour la première fois, ouvrez vos professions au moins une fois."
L["checklist_empty_state"] = "Il semble que vous n'ayez aucune profession active.\nAvez-vous peut-être filtré la mauvaise extension ou catégorie ci-dessus ?\n\nSi vous utilisez cet addon pour la première fois, ouvrez vos professions au moins une fois."
L["popup_delete_character"] = "Retirer %s ?\nCette action est irréversible.\nPour rajouter ce personnage, connectez-vous dessus."

-- Tooltip text
L["tooltip_categories"] = "Afficher ou masquer les catégories."
L["tooltip_characters"] = "Activer/désactiver vos personnages."
L["tooltip_checklist_button"] = "Afficher ou masquer la fenêtre \"À faire\""
L["tooltip_click_map_pin"] = "<Cliquer pour placer une épingle sur la carte>"
L["tooltip_click_open_profession"] = "<Cliquer pour ouvrir la profession>"
L["tooltip_click_open_recipe"] = "<Cliquer pour ouvrir la recette>"
L["tooltip_close_window"] = "Fermer la fenêtre"
L["tooltip_columns"] = "Activer/désactiver les colonnes du tableau."
L["tooltip_columns_checklist"] = "Afficher ou masquer les colonnes."
L["tooltip_current_concentration"] = "Concentration actuelle."
L["tooltip_current_knowledge"] = "Savoir actuellement obtenu."
L["tooltip_current_skill"] = "Niveaux de compétence actuels.\n\nNote : cette valeur n'est mise à jour que lorsque vous ouvrez la fenêtre de profession ou fabriquez une recette."
L["tooltip_customize"] = "Personnalisons tout ça un peu"
L["tooltip_do_you_know_de_wey"] = "Tu connais da wey ?"
L["tooltip_drag_minimap"] = "pour déplacer cette icône"
L["tooltip_expansion_filter_checklist"] = "Filtrer le tableau par extension."
L["tooltip_expansion_filter_main"] = "Filtrer les lignes selon les extensions sélectionnées."
L["tooltip_expansion_row"] = "Extension de cette ligne de profession."
L["tooltip_hide_low_level_professions"] = "Masquer les professions dont le niveau est inférieur à 25."
L["tooltip_left_click_open"] = "pour ouvrir WeeklyKnowledge."
L["tooltip_link_chat"] = "<Maj-clic pour lier dans le chat>"
L["tooltip_link_map_pin"] = "<Maj-clic pour partager l'épingle dans le chat>"
L["tooltip_log_in_concentration"] = "Connectez-vous sur ce personnage pour récupérer les données de concentration."
L["tooltip_log_in_skill"] = "Connectez-vous sur ce personnage et ouvrez une fois la fenêtre de profession pour récupérer les données de compétence."
L["tooltip_move_minimap_crowded"] = "Ça devient parfois encombré autour de la minicarte."
L["tooltip_no_more_moving_minimap"] = "Fini les déplacements accidentels du bouton !"
L["tooltip_place_tomtom"] = "<Alt-clic pour placer un point TomTom>"
L["tooltip_professions"] = "Vos professions."
L["tooltip_realms"] = "Noms des royaumes."
L["tooltip_right_click_open"] = "pour ouvrir la liste \"À faire\"."
L["tooltip_show_full_profession_name"] = "Afficher le nom complet de la profession avec la variante d'extension."
L["tooltip_toggle_list"] = "Déployer/réduire la liste \"À faire\"."
L["tooltip_your_characters"] = "Vos personnages."

-- Data and objective categories
L["expansion_dragonflight"] = "Dragonflight"
L["expansion_midnight"] = "Midnight"
L["expansion_war_within"] = "The War Within"

L["category_catch_up"] = "Rattrapage"
L["category_darkmoon"] = "Sombrelune"
L["category_first_craft"] = "Premier craft"
L["category_gathering"] = "Récolte"
L["category_treatise"] = "Traité"
L["category_treasure"] = "Trésor"
L["category_uniques"] = "Uniques"
L["category_weekly_quest"] = "Quête hebdomadaire"

L["objective_desc_catch_up"] = "Suivez vos points de rattrapage.\n\nVous pourrez gagner ces points une fois certains autres objectifs terminés.\n\nRépétable : %s"
L["objective_desc_darkmoon"] = "Accomplissez une quête à la foire de Sombrelune.\n\nRépétable : %s"
L["objective_desc_first_craft"] = "Ce sont vos bonus de premier craft ou de première récolte.\n\nNote : toutes les professions et extensions ne sont pas encore à jour.\n\nRépétable : %s"
L["objective_desc_gathering"] = "Ils sont récupérés aléatoirement sur les points de récolte à travers le monde.\n\nPour l'Enchantement, ils proviennent du désenchantement.\n\nRépétable : %s"
L["objective_desc_treatise"] = "Ils peuvent être fabriqués avec l'Inscription. Envoyez une commande d'artisanat si vous n'avez pas la profession.\n\nRépétable : %s"
L["objective_desc_treasure"] = "Ils sont récupérés aléatoirement dans des trésors à travers le monde.\n\nRépétable : %s"
L["objective_desc_uniques"] = "Ce sont des objets uniques trouvés dans des trésors à travers le monde et vendus par des marchands.\n\nRépétable : %s"
L["objective_desc_weekly_quest"] = "Accomplissez une quête de votre maître de profession ou du Consortium des artisans.\n\nRépétable : %s"

-- Alchemy
L["profession_alchemy"] = "Alchimie"
L["variant_dragon_isles_alchemy"] = "Alchimie des îles aux Dragons"
L["variant_khaz_algar_alchemy"] = "Alchimie de Khaz Algar"
L["variant_midnight_alchemy"] = "Alchimie de Midnight"

-- Blacksmithing
L["profession_blacksmithing"] = "Forge"
L["variant_dragon_isles_blacksmithing"] = "Forge des îles aux Dragons"
L["variant_khaz_algar_blacksmithing"] = "Forge de Khaz Algar"
L["variant_midnight_blacksmithing"] = "Forge de Midnight"

-- Enchanting
L["profession_enchanting"] = "Enchantement"
L["variant_dragon_isles_enchanting"] = "Enchantement des îles aux Dragons"
L["variant_khaz_algar_enchanting"] = "Enchantement de Khaz Algar"
L["variant_midnight_enchanting"] = "Enchantement de Midnight"

-- Engineering
L["profession_engineering"] = "Ingénierie"
L["variant_dragon_isles_engineering"] = "Ingénierie des îles aux Dragons"
L["variant_khaz_algar_engineering"] = "Ingénierie de Khaz Algar"
L["variant_midnight_engineering"] = "Ingénierie de Midnight"

-- Herbalism
L["profession_herbalism"] = "Herboristerie"
L["variant_dragon_isles_herbalism"] = "Herboristerie des îles aux Dragons"
L["variant_khaz_algar_herbalism"] = "Herboristerie de Khaz Algar"
L["variant_midnight_herbalism"] = "Herboristerie de Midnight"

-- Inscription
L["profession_inscription"] = "Calligraphie"
L["variant_dragon_isles_inscription"] = "Calligraphie des îles aux Dragons"
L["variant_khaz_algar_inscription"] = "Calligraphie de Khaz Algar"
L["variant_midnight_inscription"] = "Calligraphie de Midnight"

-- Jewelcrafting
L["profession_jewelcrafting"] = "Joaillerie"
L["variant_dragon_isles_jewelcrafting"] = "Joaillerie des îles aux Dragons"
L["variant_khaz_algar_jewelcrafting"] = "Joaillerie de Khaz Algar"
L["variant_midnight_jewelcrafting"] = "Joaillerie de Midnight"

-- Leatherworking
L["profession_leatherworking"] = "Travail du cuir"
L["variant_dragon_isles_leatherworking"] = "Travail du cuir des îles aux Dragons"
L["variant_khaz_algar_leatherworking"] = "Travail du cuir de Khaz Algar"
L["variant_midnight_leatherworking"] = "Travail du cuir de Midnight"

-- Mining
L["profession_mining"] = "Minage"
L["variant_dragon_isles_mining"] = "Minage des îles aux Dragons"
L["variant_khaz_algar_mining"] = "Minage de Khaz Algar"
L["variant_midnight_mining"] = "Minage de Midnight"

-- Skinning
L["profession_skinning"] = "Dépeçage"
L["variant_dragon_isles_skinning"] = "Dépeçage des îles aux Dragons"
L["variant_khaz_algar_skinning"] = "Dépeçage de Khaz Algar"
L["variant_midnight_skinning"] = "Dépeçage de Midnight"

-- Tailoring
L["profession_tailoring"] = "Couture"
L["variant_dragon_isles_tailoring"] = "Couture des îles aux Dragons"
L["variant_khaz_algar_tailoring"] = "Couture de Khaz Algar"
L["variant_midnight_tailoring"] = "Couture de Midnight"

-- Error and fallback text
L["error_item_not_found"] = "Erreur : ItemID %d introuvable"
L["error_quest_not_found"] = "Erreur : QuestID %d introuvable"
L["error_recipe_not_found"] = "Erreur : RecipeID %d introuvable"
