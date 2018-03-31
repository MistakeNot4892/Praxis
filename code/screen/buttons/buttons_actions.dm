// Combat actions.
/obj/screen/button/action
	maptext_y = -38

/obj/screen/button/action/New(var/newloc,  var/_num)
	..(null)
	maptext = "<center>[FORMAT_MAPTEXT(_num)]</center>"
	var/image/I = image(icon, "hotkey")
	I.pixel_y = -32
	underlays += I

/obj/screen/button/action/fire
	name = "Fire"
	icon_state = "fire"
	screen_loc = "CENTER-1,2"

/obj/screen/button/action/fire/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier.targets.len)
		user.selecting_target.Begin(user.soldier.targets, user.soldier.class_weapons[user.soldier.selected_weapon], user.soldier)

/obj/screen/button/action/overwatch
	name = "Overwatch"
	icon_state = "overwatch"
	screen_loc = "CENTER,2"

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
	screen_loc = "CENTER+1,2"

/obj/screen/button/action/defend/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier)
		new /obj/effect/floater/large(user.soldier.loc, FORMAT_MAPTEXT("HUNKER DOWN"))
		user.soldier.hunkering_down = TRUE
		user.remaining_moves -= user.soldier
		user.soldier.moved_this_turn = 2
		user.NextSoldier()
