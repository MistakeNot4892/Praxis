/datum/turn
	var/locked
	var/mob/controller/current_player
	var/player_index = 1
	var/list/all_players = list()

/datum/turn/proc/HandleLogin(var/client/player)
	if(!current_player)
		SetCurrentPlayer(player.mob)
	else if(current_player == player.mob)
		var/mob/controller/controller = player.mob
		if(controller.soldier)
			controller.SetSelectedSoldier(controller.soldier)
		else
			controller.SetSelectedSoldier(controller.all_soldiers[1])


/datum/turn/proc/SetCurrentPlayer(var/mob/controller/player)
	locked = FALSE
	if(current_player)
		current_player.remaining_moves.Cut()
		current_player.ClearSelectedSoldier()
	current_player = player
	if(istype(current_player))
		current_player.remaining_moves.Cut()
		for(var/mob/soldier/soldier in current_player.all_soldiers)
			if(!soldier.dead)
				current_player.remaining_moves += soldier
				soldier.moved_this_turn = 0
				soldier.hunkering_down = FALSE
		current_player.NextSoldier(start_of_turn = TRUE)

	for(var/mob/controller/other_player in all_players)
		if(other_player == current_player)
			animate(other_player.enemy_turn_indicator, alpha = 0, time = 5)
		else
			animate(other_player.enemy_turn_indicator, alpha = 255, time = 5)

/datum/turn/proc/EndTurn()
	if(current_player)
		for(var/thing in current_player.turn_elements)
			var/obj/screen/button = thing
			animate(button, alpha = 0, time = 3)
		if(current_player.soldier)
			for(var/thing in current_player.soldier.actions)
				var/obj/screen/button = thing
				animate(button, alpha = 0, time = 3)

	player_index++
	if(player_index > all_players.len)
		player_index = 1
	var/mob/controller/player = all_players[player_index]
	if(!player.client)
		spawn EndTurn()
	else
		SetCurrentPlayer(player)
		if(!player.remaining_moves.len)
			spawn EndTurn()
