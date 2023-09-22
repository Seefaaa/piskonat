/datum/ai_controller/zombie
	movement_delay = 0.2 SECONDS

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/zombie_find_target,
		/datum/ai_planning_subtree/zombie_combat,
	)

/datum/ai_controller/zombie/TryPossessPawn(atom/new_pawn)
	if(!iszombie(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	return ..()

/datum/ai_controller/zombie/PossessPawn(atom/new_pawn)
	. = ..()
	var/datum/targetting_datum/basic/targeting_datum = blackboard[BB_TARGETTING_DATUM]
	targeting_datum.stat_attack = SOFT_CRIT

/datum/ai_controller/zombie/able_to_run()
	var/mob/living/living_pawn = pawn

	if(living_pawn.incapacitated(IGNORE_STASIS | IGNORE_GRAB) || living_pawn.stat)
		return FALSE
	return ..()
