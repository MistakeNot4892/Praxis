/obj/holder
	plane = GUI_PLANE
	mouse_opacity = 0
	maptext_x = 48
	maptext_y = 28
	maptext_width = 208
	icon_state = "base"

/obj/holder/name
	screen_loc = "1,2"
	icon = 'icons/screen/class_panel.dmi'

/obj/holder/name/proc/UpdateContents(var/mob/soldier/soldier)
	maptext = "[FORMAT_MAPTEXT("'[soldier.nickname]'<br><b>[uppertext(soldier.name)]</b>")]"
	overlays.Cut()
	var/image/I = image(icon = 'icons/screen/class_symbols.dmi', icon_state = soldier.class_icon)
	I.pixel_z = 27
	I.pixel_w = 220
	overlays += I

/obj/holder/weapon
	icon = 'icons/screen/weapon_panel.dmi'
	screen_loc = "EAST-7,2"

/obj/holder/weapon/proc/UpdateWeapon(var/mob/soldier/soldier)

	var/datum/weapon/first_weapon = soldier.class_weapons[1]
	var/datum/weapon/second_weapon = soldier.class_weapons[2]

	overlays.Cut()
	var/list/overlays_to_add = list()
	if(soldier.selected_weapon == 1)
		maptext = "<right>[FORMAT_MAPTEXT("<b>\[[first_weapon.name]\]</b>")]<br>[FORMAT_MAPTEXT(second_weapon.name)]</right>"
		var/image/I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[first_weapon.icon_state]_sel")
		I.pixel_w = 32
		I.pixel_z = -16
		overlays_to_add += I
		I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[second_weapon.icon_state]")
		I.pixel_w = 144
		I.pixel_z = -16
		overlays_to_add += I
	else
		maptext = "<right>[FORMAT_MAPTEXT(first_weapon.name)]<br>[FORMAT_MAPTEXT("<b>\[[second_weapon.name]\]</b>")]</right>"
		var/image/I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[first_weapon.icon_state]")
		I.pixel_w = 32
		I.pixel_z = -16
		overlays_to_add += I
		I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[second_weapon.icon_state]_sel")
		I.pixel_w = 144
		I.pixel_z = -16
		overlays_to_add += I

	overlays = overlays_to_add