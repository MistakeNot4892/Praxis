/obj/screen
	alpha = 0

/obj/screen/New(var/mob/controller/owner)
	..()
	if(owner)
		owner.screen_elements += src
		if(owner.client) owner.client.screen += src
