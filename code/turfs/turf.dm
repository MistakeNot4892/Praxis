/turf
	name = "floor"
	icon = 'icons/turfs/turf.dmi'
	icon_state = "floor"

	var/image/selection_overlay
	var/height = 0
	var/move_cost = 1
	var/standing_offset = 0
	var/tmp/has_dense_atom

/turf/New()
	..()
	selection_overlay = new(loc = src, icon = 'icons/turfs/turf_highlight.dmi', icon_state = "")
	selection_overlay.layer = TURF_LAYER + 0.01
	selection_overlay.alpha = 0
	selection_overlay.pixel_z = standing_offset

/turf/proc/SetHighlight(var/_state)
	selection_overlay.icon_state = "[_state]"
	if(!selection_overlay.icon_state || selection_overlay.icon_state == "")
		if(selection_overlay.alpha != 0) animate(selection_overlay, alpha = 0, time = 2)
	else
		if(selection_overlay.alpha == 0) animate(selection_overlay, alpha = 255, time = 2)

/turf/lowwall
	height = 1
	standing_offset = 5
	icon_state = "lowwall"

/turf/halfwall
	height = 2
	standing_offset = 10
	icon_state = "highwall"

/turf/wall
	name = "wall"
	icon_state = "fullwall"
	density = TRUE
	move_cost = 1.#INF
	opacity = TRUE

/turf/Click(location,control,params)
	if(turn_controller.locked)
		return
	if(density) return ..()
	var/mob/controller/clicker = usr
	if(istype(clicker) && istype(clicker.soldier) && (src in clicker.soldier.move_targets))
		var/list/path = GetPathBetween(clicker.soldier.loc, src, 30)
		if(path.len <= clicker.soldier.walk_distance)
			clicker.soldier.moved_this_turn++
		else
			clicker.soldier.moved_this_turn = 2
		clicker.soldier.SetPath(path)