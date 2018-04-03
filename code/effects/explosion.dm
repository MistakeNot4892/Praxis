/obj/effect/explosion
	name = "explosion"
	icon = 'icons/effects/gunfire.dmi'
	icon_state = "explosion"

/obj/effect/explosion/New(var/newloc)
	..(newloc)
	spawn(4)
		del(src)
