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
		/obj/screen/button/action/fire,
		/obj/screen/button/action/overwatch,
		/obj/screen/button/action/defend
	)

	var/mob/controller/owner
	var/mob/controller/controller
	var/walk_distance = 4
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
	Move(loc)

	spawn
		UpdateHealth()

/mob/soldier/proc/GetCover()
	var/cover = 0
	var/turf/current = loc
	if(istype(current))
		for(var/thing in trange(1,loc)-loc)
			var/turf/T = thing
			if(T.density)
				cover += 2
			else
				if(current.height < T.height)
					cover += T.height - current.height
	return cover

/mob/soldier/proc/TakeDamage(var/dam)
	health_pips -= dam
	if(health_pips < 0)
		health_pips = 0
	UpdateHealth()
	if(health_pips == 0)
		icon_state = "dead"
		dead = TRUE
		density = FALSE
		var/turf/T = loc
		T.has_dense_atom = FALSE
		for(var/atom/movable/AM in T.contents)
			if(AM.density)
				T.has_dense_atom = TRUE
				break
		UpdateHealth()
		if(owner) owner.remaining_moves -= src

/mob/soldier/proc/FireAt(var/mob/soldier/target)
	dir = get_dir(src, target)
	target.dir = get_dir(target, src)
	var/datum/weapon/firing = class_weapons[selected_weapon]
	if(controller)
		ClearMoveTargets()
		for(var/thing in (controller.turn_elements|actions))
			var/obj/screen/button = thing
			animate(button, alpha = 0, time = 3)
		moved_this_turn += firing.fire_cost
		controller.remaining_moves -= src
	firing.OnHit(src, target)
	if(controller)
		if(moved_this_turn >= 2)
			controller.NextSoldier()
		else
			UpdateMoveTargets()

/mob/soldier/proc/SwitchWeapons()
	if(selected_weapon == 1)
		selected_weapon = 2
	else
		selected_weapon = 1
	if(controller)
		controller.weapon_holder.UpdateWeapon(src)

/mob/soldier/proc/UpdateHealth()

	for(var/mob/controller/controller in turn_controller.all_players)
		if(controller.all_soldiers[src])
			controller.RemoveClientImage(friendly_health)
		else
			controller.RemoveClientImage(enemy_health)

	for(var/i = 1 to max_health_pips)
		var/image/I = friendly_health_pips[i]
		I.icon_state = (i <= health_pips) ? "friendly" : "friendly_empty"
		I = enemy_health_pips[i]
		I.icon_state = (i <= health_pips) ? "enemy" : "enemy_empty"
	friendly_health.overlays = friendly_health_pips
	enemy_health.overlays = enemy_health_pips

	for(var/mob/controller/controller in turn_controller.all_players)
		if(controller.all_soldiers[src])
			controller.AddClientImage(friendly_health)
		else
			controller.AddClientImage(enemy_health)

/mob/soldier/Click(location,control,params)
	if(!turn_controller.locked && turn_controller.current_player == usr)
		var/mob/controller/clicker = usr
		if(!dead && istype(clicker) && !clicker.selecting_target.active && clicker.soldier != src && !controller && clicker.all_soldiers[src] && (src in clicker.remaining_moves) && !(clicker.soldier && clicker.soldier.locked))
			clicker.SetSelectedSoldier(src)

