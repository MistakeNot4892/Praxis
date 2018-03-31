/obj/screen/button
	icon = 'icons/screen/actions.dmi'
	alpha = 255
	plane = GUI_PLANE
	layer = 2
	var/use_sound = 'sounds/lrsf-soundpack/boop.wav'

/obj/screen/button/Click()
	doFunction(usr)

/obj/screen/button/proc/doFunction(var/mob/controller/user)
	if(!istype(user))
		return 0
	if(turn_controller.locked || user.selecting_target.active || (turn_controller.current_player != user))
		return 0
	PlaySound(use_sound, user.client, 75)
	return 1

// Sidebar.
/obj/screen/button/switch_weapons
	name = "Switch Weapons"
	screen_loc = "EAST-4:8,1:16"
	icon_state = "switch_weapon"
	maptext_y = -4

/obj/screen/button/switch_weapons/New(var/mob/controller/owner)
	..(owner)
	maptext = "<center>[FORMAT_MAPTEXT("X")]</center>"

/obj/screen/button/switch_weapons/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		if(user.soldier)
			user.soldier.SwitchWeapons()

/obj/screen/button/end_turn
	name = "End Turn"
	icon_state = "end"
	screen_loc = "2:16,1:20"

/obj/screen/button/end_turn/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.remaining_moves -= user.soldier
		user.soldier.moved_this_turn = 2
		user.NextSoldier()

/obj/screen/button/info
	name = "Soldier Info"
	icon_state = "info"
	screen_loc = "3:16,1:20"

/obj/screen/button/last_soldier
	name = "Last Soldier"
	icon_state = "lastsoldier"
	screen_loc = "4:16,1:20"

/obj/screen/button/last_soldier/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.LastSoldier()

/obj/screen/button/next_soldier
	name = "Next Soldier"
	icon_state = "nextsoldier"
	screen_loc = "5:16,1:20"

/obj/screen/button/next_soldier/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.NextSoldier()

/obj/screen/button/camera_left
	name = "Rotate Camera Counter-Clockwise"
	icon_state = "leftcamera"
	screen_loc = "6:16,1:20"

/obj/screen/button/camera_left/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.client.dir = turn(user.client.dir, -90)

/obj/screen/button/camera_right
	name = "Rotate Camera Clockwise"
	icon_state = "rightcamera"
	screen_loc = "7:16,1:20"

/obj/screen/button/camera_right/doFunction(var/mob/controller/user)
	. = ..()
	if(.)
		user.client.dir = turn(user.client.dir, 90)

// Volume controls.
/obj/screen/button/music
	name = "Music On/Off"
	screen_loc = "EAST,NORTH"
	icon_state = "music"

/obj/screen/button/music/doFunction(var/mob/controller/user)
	..()
	user.music_muted = !user.music_muted
	icon_state = user.music_muted ? "musicoff" : "music"
	PlaySound(use_sound, user.client, 75)
	sleep(1)
	if(user.music_muted)
		user << sound(null, BGM_CHANNEL)
	else if(bgm)
		user << bgm

/obj/screen/button/sounds
	name = "Sound Effects On/Off"
	screen_loc = "EAST-1,NORTH"
	icon_state = "sound"

/obj/screen/button/sounds/doFunction(var/mob/controller/user)
	..()
	user.sound_muted = !user.sound_muted
	icon_state = user.sound_muted ? "soundoff" : "sound"
	PlaySound(use_sound, user.client, 75)
