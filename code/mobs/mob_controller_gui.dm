/mob/controller
	var/list/screen_elements
	var/list/image_elements
	var/list/turn_elements
	var/obj/screen/holder/enemy_action/enemy_turn_indicator
	var/obj/screen/holder/name/name_holder
	var/obj/screen/holder/weapon/weapon_holder
	var/obj/screen/holder/target/target_holder
	var/obj/screen/target_selector/panel/selecting_target

/mob/controller/proc/CreateGui()

	screen_elements = list()
	image_elements = list()
	turn_elements = list(
		new /obj/screen/button/end_turn(src),
		new /obj/screen/button/info(src),
		new /obj/screen/button/last_soldier(src),
		new /obj/screen/button/next_soldier(src),
		new /obj/screen/button/camera_left(src),
		new /obj/screen/button/camera_right(src),
		new /obj/screen/button/switch_weapons(src)
	)
	target_holder =        new(src)
	name_holder =          new(src)
	weapon_holder =        new(src)
	enemy_turn_indicator = new(src)
	selecting_target =     new(src)

	turn_elements += target_holder
	turn_elements += name_holder
	turn_elements += weapon_holder

/mob/controller/proc/AddClientImage(var/image/_adding)
	image_elements |= _adding
	if(client) client.images |= _adding

/mob/controller/proc/RemoveClientImage(var/image/_removing)
	image_elements -= _removing
	if(client) client.images -= _removing

/mob/controller/proc/AddScreenElement(var/_element)
	if(istype(_element, /list))
		for(var/thing in _element)
			AddScreenElement(thing)
		return
	screen_elements |= _element
	if(client) client.screen |= _element

/mob/controller/proc/RemoveScreenElement(var/_element)
	if(istype(_element, /list))
		for(var/thing in _element)
			RemoveScreenElement(thing)
		return
	screen_elements -= _element
	if(client) client.screen -= _element
