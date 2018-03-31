/mob/soldier/proc/SetPath(var/list/new_path)
	turn_controller.locked = TRUE
	for(var/turf/T in current_path)
		T.SetHighlight()
	ClearMoveTargets()
	current_path = new_path
	for(var/turf/T in current_path)
		T.SetHighlight("pathing")
		if(controller && controller.client)
			controller.AddClientImage(T.selection_overlay)
	var/pathref = "\ref[current_path]"
	for(var/thing in (controller.turn_elements|actions))
		var/obj/screen/button = thing
		animate(button, alpha = 0, time = 3)
	StepAlongPath(pathref)
	if(controller)
		if(moved_this_turn >= 2)
			controller.remaining_moves -= src
			controller.NextSoldier()
		else
			UpdateMoveTargets()

/mob/soldier/proc/ClearMoveTargets()
	for(var/turf/T in move_targets)
		if(controller && controller.client)
			controller.RemoveClientImage(T.selection_overlay)
		T.SetHighlight("")
	move_targets.Cut()
	if(controller && controller.client)
		for(var/thing in target_indicators)
			controller.RemoveClientImage(thing)
	targets.Cut()
	target_indicators.Cut()

/mob/soldier/proc/UpdateMoveTargets()

	locked = FALSE
	turn_controller.locked = FALSE
	ClearMoveTargets()

	for(var/thing in (controller.turn_elements|actions))
		var/obj/screen/button = thing
		animate(button, alpha = 255, time = 3)

	var/dist = (moved_this_turn ? walk_distance : sprint_distance)
	for(var/thing in trange(dist, loc))
		if(thing in move_targets)
			continue
		var/turf/T = thing
		var/list/path = GetPathBetween(loc, T, dist)
		for(var/i = 1 to path.len)
			move_targets[path[i]] = i

	for(var/thing in move_targets)
		var/turf/T = thing
		if(moved_this_turn)
			T.SetHighlight("far")
		else
			T.SetHighlight(move_targets[thing] <= walk_distance ? "close" : "far")
		if(controller && controller.client)
			controller.AddClientImage(T.selection_overlay)

	if(controller)
		for(var/mob/soldier/soldier in viewers(10, src)-src)
			if(!controller.all_soldiers[soldier] && !soldier.dead)
				var/image/I = image(loc = controller.target_holder, icon = 'icons/screen/target_indicator.dmi', icon_state = "target")
				I.plane = GUI_PLANE
				I.pixel_w = -(22 * target_indicators.len)
				targets += soldier
				target_indicators += I
				if(controller.client)
					controller.AddClientImage(I)

/mob/soldier/proc/StepAlongPath(var/pathref)
	while(current_path && current_path.len)
		locked = TRUE
		if(pathref != "\ref[current_path]") return
		Move(current_path[1])
		current_path -= current_path[1]
		sleep(3)

/mob/soldier/Move()
	var/turf/lastloc = loc
	. = ..()
	if(. && loc)
		FocusControllersOn(src)
		PlaySound('sounds/lrsf-soundpack/footstep.wav', loc, 30)
		if(istype(lastloc))
			lastloc.has_dense_atom = FALSE
			for(var/atom/movable/AM in lastloc.contents)
				if(AM.density)
					lastloc.has_dense_atom = TRUE
					break
		var/turf/currentloc = loc
		if(istype(currentloc))
			currentloc.has_dense_atom = TRUE
			currentloc.SetHighlight()
			if(controller && controller.client)
				controller.RemoveClientImage(currentloc.selection_overlay)
			if(pixel_z != currentloc.standing_offset)
				animate(src, pixel_z = currentloc.standing_offset, time = 3)
