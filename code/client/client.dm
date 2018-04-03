/client/New()
	..()
	turn_controller.HandleLogin(src)
	var/mob/controller/controller = mob
	if(bgm && !controller.music_muted) src << bgm

	for(var/turf/T in world)
		if(!(T in controller.visible_turfs))
			controller.AddClientImage(T.concealment_overlay)
	images |= controller.image_elements
	screen |= controller.screen_elements

/proc/FocusControllersOn(var/atom/target)
	for(var/thing in turn_controller.all_players)
		var/mob/controller/player = thing
		if(target.loc in player.visible_turfs)
			player.loc = target.loc