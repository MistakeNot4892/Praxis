/obj/button
	icon = 'icons/screen/actions.dmi'
	alpha = 255
	plane = GUI_PLANE
	layer = 2

/obj/button/Click()
	doFunction(usr)

/obj/button/proc/doFunction(var/mob/controller/user)
	if(!istype(user))
		return 0
	if(turn_controller.locked || user.selecting_target || (turn_controller.current_player != user))
		return 0
	return 1

// Sidebar.
/obj/button/switch_weapons
	name = "Switch Weapons"
	screen_loc = "EAST-4:8,1:16"
	icon_state = "switch_weapon"
	maptext_y = -4

/obj/button/switch_weapons/New()
	..()
	maptext = "<center>[FORMAT_MAPTEXT("X")]</center>"

/obj/button/switch_weapons/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		if(user.soldier)
			user.soldier.SwitchWeapons()

/obj/button/end_turn
	name = "End Turn"
	icon_state = "end"
	screen_loc = "2:16,1:20"

/obj/button/end_turn/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.ClearSelectedSoldier()
		turn_controller.EndTurn()

/obj/button/info
	name = "Soldier Info"
	icon_state = "info"
	screen_loc = "3:16,1:20"

/obj/button/last_soldier
	name = "Last Soldier"
	icon_state = "lastsoldier"
	screen_loc = "4:16,1:20"

/obj/button/last_soldier/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.LastSoldier()

/obj/button/next_soldier
	name = "Next Soldier"
	icon_state = "nextsoldier"
	screen_loc = "5:16,1:20"

/obj/button/next_soldier/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.NextSoldier()

/obj/button/camera_left
	name = "Rotate Camera Counter-Clockwise"
	icon_state = "leftcamera"
	screen_loc = "6:16,1:20"

/obj/button/camera_left/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.client.dir = turn(user.client.dir, -90)

/obj/button/camera_right
	name = "Rotate Camera Clockwise"
	icon_state = "rightcamera"
	screen_loc = "7:16,1:20"

/obj/button/camera_right/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.client.dir = turn(user.client.dir, 90)
