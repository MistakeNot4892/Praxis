// Combat actions.
/obj/screen/button/action
	maptext_y = -38
	use_sound = 'sounds/lrsf-soundpack/beep.wav'

/obj/screen/button/action/New(var/newloc,  var/_num, var/_final)
	..(null)
	var/list/underlays_to_add = list()
	maptext = "<center>[FORMAT_MAPTEXT(_num)]</center>"
	var/image/I = image(icon, "hotkey")
	I.pixel_y = -32
	underlays_to_add += I
	if(_num == 1)
		underlays_to_add += "first"
	else if(_final)
		underlays_to_add += "last"
	else
		underlays_to_add += "middle"
	underlays = underlays_to_add

/obj/screen/button/action/fire
	name = "Fire"
	icon_state = "fire"
	screen_loc = "CENTER-2:16,2"

/obj/screen/button/action/fire/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier.targets.len)
		user.selecting_target.Begin(user.soldier.targets, user.soldier.class_weapons[user.soldier.selected_weapon], user.soldier)

/obj/screen/button/action/overwatch
	name = "Overwatch"
	icon_state = "overwatch"
	screen_loc = "CENTER-1:16,2"

/obj/screen/button/action/overwatch/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier)
		new /obj/effect/floater/large(user.soldier.loc, FORMAT_MAPTEXT("OVERWATCH"))
		user.remaining_moves -= user.soldier
		user.soldier.moved_this_turn = 2
		user.NextSoldier()

/obj/screen/button/action/defend
	name = "Hunker Down"
	icon_state = "defend"
	screen_loc = "CENTER:16,2"

/obj/screen/button/action/defend/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier)
		new /obj/effect/floater/large(user.soldier.loc, FORMAT_MAPTEXT("HUNKER DOWN"))
		user.soldier.hunkering_down = TRUE
		user.remaining_moves -= user.soldier
		user.soldier.moved_this_turn = 2
		user.NextSoldier()

/obj/screen/button/action/reload
	name = "reload"
	icon_state = "reload"
	screen_loc = "CENTER+1:16,2"

/obj/screen/button/action/reload/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier)
		var/datum/weapon/firing = user.soldier.class_weapons[user.soldier.selected_weapon]
		if(firing.loaded_ammo < firing.max_ammo)
			new /obj/effect/floater/large(user.soldier.loc, FORMAT_MAPTEXT("RELOADED"))
			firing.loaded_ammo = firing.max_ammo
			user.remaining_moves -= user.soldier
			user.soldier.moved_this_turn = 2
			user.NextSoldier()
