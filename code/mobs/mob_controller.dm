/mob/controller
	density = FALSE
	opacity = FALSE
	sight = SEE_MOBS | SEE_TURFS | SEE_OBJS

	var/obj/target_selector/panel/selecting_target
	var/mob/soldier/soldier
	var/list/all_soldiers
	var/max_soldiers = 3
	var/list/remaining_moves
	var/current_soldier_index = 1
	var/list/buttons
	var/obj/enemy_action/enemy_turn_indicator
	var/obj/holder/name/name_holder
	var/obj/holder/weapon/weapon_holder
	var/obj/target_holder

/mob/controller/proc/ConfirmTargetSelection(var/mob/soldier/target)
	CancelTargetSelection()
	if(target && soldier) soldier.FireAt(target)

/mob/controller/proc/CancelTargetSelection()
	if(selecting_target)
		if(client) client.screen -= selecting_target.components
		for(var/thing in selecting_target.components)
			del(thing)
		if(selecting_target)
			del(selecting_target)
		selecting_target = null

/mob/controller/New()

	buttons = list(
		new /obj/button/end_turn(),
		new /obj/button/info(),
		new /obj/button/last_soldier(),
		new /obj/button/next_soldier(),
		new /obj/button/camera_left(),
		new /obj/button/camera_right(),
		new /obj/button/switch_weapons()
	)

	target_holder = new()
	buttons += target_holder
	target_holder.screen_loc = "EAST,4"

	all_soldiers = list()
	remaining_moves = list()

	turn_controller.all_players += src

	for(var/soldiertype in list(
		/mob/soldier/assault,
		/mob/soldier/heavy,
		/mob/soldier/sniper,
		/mob/soldier/support
		))
		var/mob/soldier/new_soldier = new soldiertype(locate(rand(1,20),rand(1,20),1), src)
		all_soldiers[new_soldier] = new_soldier
		remaining_moves += new_soldier

	soldier = pick(all_soldiers)

	name_holder = new
	weapon_holder = new
	buttons += name_holder
	buttons += weapon_holder
	enemy_turn_indicator = new
	remaining_moves = list()

	..()

	spawn
		if(turn_controller.current_player == src)
			enemy_turn_indicator.alpha = 0
			for(var/thing in buttons)
				var/obj/button = thing
				button.alpha = 255
			if(soldier)
				for(var/thing in soldier.actions)
					var/obj/button = thing
					button.alpha = 255
		else
			enemy_turn_indicator.alpha = 255
			for(var/thing in buttons)
				var/obj/button = thing
				button.alpha = 0
			if(soldier)
				for(var/thing in soldier.actions)
					var/obj/button = thing
					button.alpha = 0

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
		if(client)
			client.images |= soldier.selected_highlight
			client.screen |= soldier.actions
		soldier.UpdateMoveTargets()
		name_holder.UpdateContents(soldier)
		weapon_holder.UpdateWeapon(soldier)
		loc = soldier.loc

/mob/controller/proc/ClearSelectedSoldier()
	if(soldier)
		soldier.locked = FALSE
		if(client)
			client.images -= soldier.selected_highlight
			client.screen -= soldier.actions
		soldier.ClearMoveTargets()
		soldier.controller = null
		soldier = null
