/mob/controller

	density = FALSE
	opacity = FALSE
	sight = SEE_MOBS | SEE_TURFS | SEE_OBJS

	var/mob/soldier/soldier
	var/list/all_soldiers
	var/max_soldiers = 3
	var/list/remaining_moves
	var/current_soldier_index = 1

/mob/controller/New()
	turn_controller.all_players += src

	CreateGui()
	CreateDefaultSoldiers()

	..()

	if(turn_controller.current_player == src)
		enemy_turn_indicator.alpha = 0
		for(var/thing in turn_elements)
			var/obj/screen/button = thing
			button.alpha = 255
		if(soldier)
			for(var/thing in soldier.actions)
				var/obj/screen/button = thing
				button.alpha = 255
	else
		enemy_turn_indicator.alpha = 255
		for(var/thing in turn_elements)
			var/obj/screen/button = thing
			button.alpha = 0
		if(soldier)
			for(var/thing in soldier.actions)
				var/obj/screen/button = thing
				button.alpha = 0

	for(var/mob/controller/controller in turn_controller.all_players)
		if(controller == src) continue
		for(var/mob/soldier/sol in controller.all_soldiers)
			AddClientImage(sol.enemy_health)
		for(var/mob/soldier/sol in all_soldiers)
			controller.AddClientImage(sol.enemy_health)

/mob/controller/proc/LastSoldier(var/start_of_turn = FALSE)
	if(remaining_moves.len)
		current_soldier_index--
		if(current_soldier_index < 1) current_soldier_index = remaining_moves.len
		var/mob/soldier/_soldier = remaining_moves[current_soldier_index]
		if(!_soldier || _soldier.dead)
			remaining_moves -= _soldier
			LastSoldier(start_of_turn)
		else
			SetSelectedSoldier(_soldier)
	else if(!start_of_turn)
		ClearSelectedSoldier()
		turn_controller.EndTurn()

/mob/controller/proc/NextSoldier(var/start_of_turn = FALSE)
	if(remaining_moves.len)
		current_soldier_index++
		if(current_soldier_index > remaining_moves.len) current_soldier_index = 1
		var/mob/soldier/_soldier = remaining_moves[current_soldier_index]
		if(!_soldier || _soldier.dead)
			remaining_moves -= _soldier
			NextSoldier(start_of_turn)
		else
			SetSelectedSoldier(_soldier)
	else if(!start_of_turn)
		ClearSelectedSoldier()
		turn_controller.EndTurn()

/mob/controller/proc/SetSelectedSoldier(var/mob/soldier/_soldier)
	ClearSelectedSoldier()
	soldier = _soldier
	if(soldier)
		soldier.controller = src
		AddClientImage(soldier.selected_highlight)
		AddScreenElement(soldier.actions)
		soldier.UpdateMoveTargets()
		name_holder.UpdateContents(soldier)
		weapon_holder.UpdateWeapon(soldier)
		FocusControllersOn(soldier)

/mob/controller/proc/ClearSelectedSoldier()
	if(soldier)
		soldier.locked = FALSE
		if(client)
			RemoveClientImage(soldier.selected_highlight)
			RemoveScreenElement(soldier.actions)
		soldier.ClearMoveTargets()
		soldier.controller = null
		soldier = null
