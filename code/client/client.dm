/client/New()
	..()
	turn_controller.HandleLogin(src)
	var/mob/controller/controller = mob
	if(bgm && !controller.music_muted) src << bgm
	images |= controller.image_elements
	screen |= controller.screen_elements

/proc/FocusControllersOn(var/atom/target)
	for(var/thing in turn_controller.all_players)
		var/mob/player = thing
		player.loc = target.loc