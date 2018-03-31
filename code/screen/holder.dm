/obj/screen/holder
	plane = GUI_PLANE
	mouse_opacity = 0
	maptext_x = 48
	maptext_y = 28
	maptext_width = 208
	icon_state = "base"

/obj/screen/holder/name
	screen_loc = "1,2"
	icon = 'icons/screen/class_panel.dmi'

/obj/screen/holder/name/proc/UpdateContents(var/mob/soldier/soldier)
	maptext = "[FORMAT_MAPTEXT("'[soldier.nickname]'<br><b>[uppertext(soldier.name)]</b>")]"
	overlays.Cut()
	var/image/I = image(icon = 'icons/screen/class_symbols.dmi', icon_state = soldier.class_icon)
	I.pixel_z = 27
	I.pixel_w = 220
	overlays += I

/obj/screen/holder/weapon
	icon = 'icons/screen/weapon_panel.dmi'
	screen_loc = "EAST-7,2"

/obj/screen/holder/weapon/proc/UpdateWeapon(var/mob/soldier/soldier)

	var/datum/weapon/first_weapon = soldier.class_weapons[1]
	var/datum/weapon/second_weapon = soldier.class_weapons[2]

	overlays.Cut()
	var/list/overlays_to_add = list()

	// Background plate.
	var/image/I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "back")
	I.pixel_w = 32
	I.pixel_z = -16
	overlays_to_add += I
	I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "back")
	I.pixel_w = 144
	I.pixel_z = -16
	overlays_to_add += I

	// First weapon images.
	I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[first_weapon.icon_state]")
	I.pixel_w = 32
	I.pixel_z = -16
	overlays_to_add += I
	I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[first_weapon.icon_state]_[first_weapon.loaded_ammo]")
	I.pixel_w = 32
	I.pixel_z = -16
	overlays_to_add += I

	// Second weapon images.
	I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[second_weapon.icon_state]")
	I.pixel_w = 144
	I.pixel_z = -16
	overlays_to_add += I
	I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "[second_weapon.icon_state]_[second_weapon.loaded_ammo]")
	I.pixel_w = 144
	I.pixel_z = -16
	overlays_to_add += I

	// Selected weapon corner overlay and maptext.
	I = image(icon = 'icons/screen/weapon_icons.dmi', icon_state = "sel")
	if(soldier.selected_weapon == 1)
		maptext = "<right>[FORMAT_MAPTEXT("<b>\[[first_weapon.name]\]</b>")]<br>[FORMAT_MAPTEXT(second_weapon.name)]</right>"
		I.pixel_w = 32
		I.pixel_z = -16
	else
		maptext = "<right>[FORMAT_MAPTEXT(first_weapon.name)]<br>[FORMAT_MAPTEXT("<b>\[[second_weapon.name]\]</b>")]</right>"
		I.pixel_w = 144
		I.pixel_z = -16
	overlays_to_add += I

	overlays = overlays_to_add

/obj/screen/holder/target
	name = "Visible Targets"
	screen_loc = "EAST,4"

/obj/screen/holder/enemy_action
	name = "Enemy Action"
	mouse_opacity = 0
	screen_loc = "CENTER-1,CENTER-4"
	icon = 'icons/screen/enemy_action.dmi'
	alpha = 0
	plane = GUI_PLANE
	layer = 3