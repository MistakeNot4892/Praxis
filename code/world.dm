/world
	fps = 25
	icon_size = 32
	view = "30x20"
	mob = /mob/controller
	map_format = ISOMETRIC_MAP

/world/New()
	..()
	bgm = sound('sounds/xcom-music/07_tactical_section.ogg', TRUE)
	bgm.wait = 0
	bgm.channel = BGM_CHANNEL
	bgm.volume = 50
	bgm.environment = -1

/mob
	glide_size = 4

/atom
	plane = MASTER_PLANE