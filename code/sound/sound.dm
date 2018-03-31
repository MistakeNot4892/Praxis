var/sound/bgm

/proc/PlaySound(var/soundfile, var/play_at, var/volume = 100, var/channel = 1, var/loop)

	if(!soundfile || !play_at) return

	var/sound/play_sound = sound(soundfile, loop)
	play_sound.wait = 0
	play_sound.channel = channel ? channel : 0
	play_sound.volume = volume
	play_sound.environment = -1

	if(play_at)
		if(istype(play_at, /client))
			var/client/player = play_at
			if(!player.mob.sound_muted)
				play_at << play_sound
		else
			for(var/mob/listener in range(world.view, play_at))
				if(!listener.sound_muted && listener.client)
					listener << play_sound
	else
		for(var/thing in turn_controller.all_players)
			var/mob/controller/player = thing
			if(!player.sound_muted && player.client)
				player << play_sound
