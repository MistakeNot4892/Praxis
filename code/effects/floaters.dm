/obj/effect/floater
	pixel_w = -16
	maptext_y = -11
	maptext_width = 64
	icon_state = "64"
	pixel_z = 64

/obj/effect/floater/New(var/newloc, var/_maptext)
	..(newloc)
	maptext = "<center><b>[_maptext]</b></center>"

	spawn
		animate(src, pixel_z = 78, time = 20)
		sleep(20)
		animate(src, pixel_z = 94, alpha = 0, time = 20)
		sleep(20)
		del(src)

/obj/effect/floater/small
	maptext_x = 0
	pixel_w = 0
	maptext_width = 32
	icon_state = "32"

/obj/effect/floater/large
	maptext_x = 0
	pixel_w = -32
	maptext_width = 96
	icon_state = "96"

/obj/effect/floater/enormous
	maptext_x = 0
	pixel_w = -48
	maptext_width = 128
	icon_state = "128"