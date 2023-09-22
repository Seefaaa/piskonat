/datum/ai_planning_subtree/zombie_find_target/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	controller.queue_behavior(/datum/ai_behavior/find_potential_targets/nearest, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

/datum/ai_planning_subtree/zombie_combat/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if((HAS_TRAIT(controller.pawn, TRAIT_PACIFISM)))
		return SUBTREE_RETURN_FINISH_PLANNING

	if(!controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET])
		return SUBTREE_RETURN_FINISH_PLANNING

	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(QDELETED(target))
		return SUBTREE_RETURN_FINISH_PLANNING

	controller.queue_behavior(/datum/ai_behavior/zombie_attack_mob, BB_BASIC_MOB_CURRENT_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING
