#define is_infected(carbon) carbon.get_organ_slot(ORGAN_SLOT_ZOMBIE) ? TRUE : FALSE

/datum/ai_behavior/zombie_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/zombie_attack_mob/setup(datum/ai_controller/controller, target_key)
	. = ..()
	set_movement_target(controller, controller.blackboard[target_key])

/datum/ai_behavior/zombie_attack_mob/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()

	var/atom/target = controller.blackboard[target_key]
	var/mob/living/living_pawn = controller.pawn

	if(!target || !isturf(target.loc) || living_pawn.incapacitated(IGNORE_STASIS | IGNORE_GRAB) || living_pawn.stat)
		finish_action(controller, FALSE)
		return

	var/infectious = FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if(human_target.stat && !is_infected(human_target))
			infectious = TRUE

	zombie_attack(controller, target, seconds_per_tick, infectious)
	finish_action(controller, TRUE)

/datum/ai_behavior/zombie_attack_mob/finish_action(datum/ai_controller/controller, succeeded, target_key)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	SSmove_manager.stop_looping(living_pawn)
	controller.clear_blackboard_key(target_key)

/datum/ai_behavior/zombie_attack_mob/proc/zombie_attack(datum/ai_controller/controller, atom/target, seconds_per_tick, infectious = FALSE)
	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return

	living_pawn.changeNext_move(CLICK_CD_MELEE)

	var/obj/item/zombie_hand = locate(/obj/item/mutant_hand/zombie) in living_pawn.held_items

	living_pawn.face_atom(target)
	living_pawn.set_combat_mode(TRUE)

	if(living_pawn.CanReach(target))
		if(zombie_hand)
			if(!zombie_hand.melee_attack_chain(living_pawn, target) && infectious)
				var/mob/living/carbon/human/human_target = target
				try_to_zombie_infect(human_target)
				if(is_infected(human_target))
					playsound(target, 'sound/effects/wounds/crack2.ogg', 70)
		else
			living_pawn.UnarmedAttack(target, null, list())
