// Combat actions.
/obj/button/action
	maptext_y = -38

/obj/button/action/New(var/newloc, var/_num)
	..(newloc)
	maptext = "<center>[FORMAT_MAPTEXT(_num)]</center>"
	var/image/I = image(icon, "hotkey")
	I.pixel_y = -32
	underlays += I

/obj/button/action/fire
	name = "Fire"
	icon_state = "fire"
	screen_loc = "CENTER-1,2"

/obj/button/action/fire/doFunction(var/mob/controller/user)
	. = ..()
	if(. && user.soldier.targets.len)
		user.selecting_target = new(user.soldier.targets, user.soldier.class_weapons[user.soldier.selected_weapon], user.soldier)
		if(user.client)
			user.client.screen += user.selecting_target.components

/obj/button/action/overwatch
	name = "Overwatch"
	icon_state = "overwatch"
	screen_loc = "CENTER,2"

/obj/button/action/defend
	name = "Hunker Down"
	icon_state = "defend"
	screen_loc = "CENTER+1,2"
