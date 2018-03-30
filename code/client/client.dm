/client/New()
	..()
	if(!turn_controller.current_player)
		turn_controller.SetCurrentPlayer(mob)
	else if(turn_controller.current_player == mob)
		var/mob/controller/controller = mob
		if(controller.soldier)
			controller.SetSelectedSoldier(controller.soldier)
		else
			controller.SetSelectedSoldier(controller.all_soldiers[1])
	UpdateScreen()

/client/proc/UpdateScreen()
	var/mob/controller/controller = mob
	if(istype(controller.soldier))
		images |= controller.soldier.selected_highlight
		for(var/turf/T in controller.soldier.move_targets)
			images |= T.selection_overlay
		screen |= controller.soldier.actions
		for(var/mob/soldier/soldier in all_soldiers)
			if(controller.all_soldiers[soldier])
				images |= soldier.friendly_health
			else
				images |= soldier.enemy_health
	screen |= controller.buttons
	screen |= controller.enemy_turn_indicator
	if(controller.selecting_target)
		screen |= controller.selecting_target.components