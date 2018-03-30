var/list/soldier_nicknames = list(
	"Chirpy",
	"Flange",
	"Pocket Rocket",
	"Doomsday",
	"Bloodsucker",
	"Slugpuppy",
	"Lemon-Lime"
	)

var/list/soldier_names = list(
	"Captain Chirp",
	"Major Marlboro",
	"Sergeant Sluggo",
	"Lieutenant Longboy",
	"Private Plant"
	)

/mob/soldier
	name = "soldier"
	icon = 'icons/mobs/mob.dmi'
	icon_state = "static"
	density = TRUE

	var/list/actions = list(
		/obj/button/action/fire,
		/obj/button/action/overwatch,
		/obj/button/action/defend
	)

	var/mob/controller/owner
	var/mob/controller/controller
	var/walk_distance = 3
	var/sprint_distance = 9
	var/moved_this_turn = 0
	var/list/current_path
	var/list/move_targets
	var/locked = FALSE
	var/image/selected_highlight
	var/class_icon
	var/list/selected_weapon = 1
	var/list/class_weapons
	var/list/target_indicators
	var/list/targets
	var/nickname

	var/health_pips = 8
	var/max_health_pips = 8
	var/dead

	var/image/friendly_health
	var/list/friendly_health_pips
	var/image/enemy_health
	var/image/enemy_health_pips

/mob/soldier/New(var/newloc, var/_controller)

	..(newloc)

	owner = _controller

	if(class_weapons.len)
		var/list/_cwep = class_weapons.Copy()
		class_weapons.Cut()
		for(var/weapontype in _cwep)
			class_weapons += new weapontype

	all_soldiers += src
	name = pick(soldier_names)
	nickname = pick(soldier_nicknames)

	var/_actions = actions.Copy()
	actions.Cut()
	for(var/action in _actions)
		actions += new action(_num = actions.len+1)

	selected_highlight = image(loc = src, icon = 'icons/mobs/mob_selected.dmi', icon_state = "selected_base")
	selected_highlight.layer = layer - 0.001
	selected_highlight.appearance_flags = RESET_TRANSFORM
	var/image/I = image(loc = src, icon = 'icons/mobs/mob_selected.dmi', icon_state = "selected_arrow")
	I.pixel_z = 32
	I.layer = layer + 0.001
	I.appearance_flags = RESET_TRANSFORM
	selected_highlight.overlays += I
	selected_highlight.mouse_opacity = 0
	move_targets = list()
	current_path = list()
	dir = pick(all_directions)

	friendly_health = image(loc = src, icon = 'icons/screen/health_bar.dmi', icon_state = "friendly")
	friendly_health.pixel_w = 24
	friendly_health.pixel_z = 24
	friendly_health.plane = GUI_PLANE
	friendly_health_pips = list()
	friendly_health.layer = 1
	friendly_health.mouse_opacity = 0

	enemy_health = image(loc = src, icon = 'icons/screen/health_bar.dmi', icon_state = "enemy")
	enemy_health.pixel_w = 24
	enemy_health.pixel_z = 24
	enemy_health.plane = GUI_PLANE
	enemy_health_pips = list()
	enemy_health.layer = 1
	enemy_health.mouse_opacity = 0

	targets = list()
	target_indicators = list()

	var/offset_x = 6
	var/offset_y = 0

	for(var/i = 1 to max_health_pips)
		I = image(icon = 'icons/screen/health_pips.dmi', icon_state = "friendly_empty")
		I.plane = GUI_PLANE
		I.pixel_z = offset_y //round(i/4)*6
		I.pixel_w = offset_x //(i * 6)
		friendly_health_pips += I

		I = image(icon = 'icons/screen/health_pips.dmi', icon_state = "enemy_empty")
		I.plane = GUI_PLANE
		I.pixel_z = offset_y
		I.pixel_w = offset_x

		offset_x += 6
		if(offset_x > 24)
			offset_x = 6
			offset_y += 6

		enemy_health_pips += I

	friendly_health.overlays = friendly_health_pips
	enemy_health.overlays = enemy_health_pips

	UpdateHealth()

	Move(loc)

/mob/soldier/proc/TakeDamage(var/dam)
	health_pips -= dam
	if(health_pips < 0)
		health_pips = 0
	UpdateHealth()
	if(health_pips == 0)
		icon_state = "dead"
		dead = TRUE
		UpdateHealth()
		owner.remaining_moves -= src

/mob/soldier/proc/FireAt(var/mob/soldier/target)
	dir = get_dir(src, target)
	target.dir = get_dir(target, src)
	var/datum/weapon/firing = class_weapons[selected_weapon]
	firing.OnHit(src, target)
	if(controller)
		controller.remaining_moves -= src
		controller.NextSoldier()

/mob/soldier/proc/SwitchWeapons()
	if(selected_weapon == 1)
		selected_weapon = 2
	else
		selected_weapon = 1
	if(controller)
		controller.weapon_holder.UpdateWeapon(src)

/mob/soldier/proc/UpdateHealth()
	for(var/i = 1 to max_health_pips)
		var/image/I = friendly_health_pips[i]
		I.icon_state = (i <= health_pips) ? "friendly" : "friendly_empty"
		I = enemy_health_pips[i]
		I.icon_state = (i <= health_pips) ? "enemy" : "enemy_empty"

	friendly_health.overlays = friendly_health_pips
	enemy_health.overlays = enemy_health_pips

/mob/soldier/Click(location,control,params)
	if(!turn_controller.locked && turn_controller.current_player == usr)
		var/mob/controller/clicker = usr
		if(!dead && istype(clicker) && !clicker.selecting_target && clicker.soldier != src && !controller && clicker.all_soldiers[src] && (src in clicker.remaining_moves) && !(clicker.soldier && clicker.soldier.locked))
			clicker.SetSelectedSoldier(src)

/mob/soldier/proc/SetPath(var/list/new_path)
	turn_controller.locked = TRUE
	for(var/turf/T in current_path)
		T.SetHighlight()
	ClearMoveTargets()
	current_path = new_path
	for(var/turf/T in current_path)
		T.SetHighlight("pathing")
		if(controller && controller.client)
			controller.client.images |= T.selection_overlay
	var/pathref = "\ref[current_path]"
	for(var/thing in (controller.buttons|actions))
		var/obj/button = thing
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
			controller.client.images -= T.selection_overlay
		T.SetHighlight("")
	move_targets.Cut()
	if(controller && controller.client)
		for(var/thing in target_indicators)
			controller.client.images -= thing
	targets.Cut()
	target_indicators.Cut()

/mob/soldier/proc/UpdateMoveTargets()

	locked = FALSE
	turn_controller.locked = FALSE
	ClearMoveTargets()

	for(var/thing in (controller.buttons|actions))
		var/obj/button = thing
		animate(button, alpha = 255, time = 3)

	var/_dist = moved_this_turn > 0 ? walk_distance : sprint_distance
	for(var/turf/T in range(_dist,loc))
		if(!T.density && !move_targets[T])
			var/list/path = GetPathBetween(loc, T, _dist)
			if(istype(path, /list) && path.len)
				var/setting_state = (!moved_this_turn && path.len <= walk_distance) ? "close" : "far"
				for(var/turf/stepalong in path)
					if(controller && controller.client)
						controller.client.images |= T.selection_overlay
					T.SetHighlight(setting_state)
				move_targets |= path

	if(controller)
		for(var/mob/soldier/soldier in viewers(14, src)-src)
			if(!controller.all_soldiers[soldier])
				var/image/I = image(loc = controller.target_holder, icon = 'icons/screen/target_indicator.dmi', icon_state = "target")
				I.plane = GUI_PLANE
				I.pixel_w = -(22 * target_indicators.len)
				targets += soldier
				target_indicators += I
				if(controller.client)
					controller.client.images |= I


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
	if(.)
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
				controller.client.images -= currentloc.selection_overlay
			if(pixel_z != currentloc.standing_offset)
				animate(src, pixel_z = currentloc.standing_offset, time = 3)

/mob/soldier/assault
	class_icon = "assault"
	class_weapons = list(
		/datum/weapon/shotgun,
		/datum/weapon/pistol
	)

/mob/soldier/heavy
	class_icon = "heavy"
	class_weapons = list(
		/datum/weapon/lmg,
		/datum/weapon/rocket
	)

/mob/soldier/sniper
	class_icon = "sniper"
	class_weapons = list(
		/datum/weapon/sniper,
		/datum/weapon/pistol
	)

/mob/soldier/support
	class_icon = "support"
	class_weapons = list(
		/datum/weapon/assault,
		/datum/weapon/pistol
	)