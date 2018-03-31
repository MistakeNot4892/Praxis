/datum/weapon
	var/name
	var/icon_state
	var/max_ammo =          3
	var/loaded_ammo =       0
	var/min_damage =        3
	var/max_damage =        5
	var/min_crit_damage =   6
	var/max_crit_damage =   8
	var/base_crit_chance  = 0
	var/single_use =        FALSE
	var/can_crit =          FALSE
	var/base_accuracy =     50
	var/burst = 1
	var/burst_delay = 5
	var/fire_overlay = "gunfire"
	var/hit_overlay = "gunhit"
	var/gunfire_x_jitter = 3
	var/gunfire_y_jitter = 3
	var/fire_cost = 2

/datum/weapon/New()
	..()
	loaded_ammo = max_ammo

/datum/weapon/proc/GetRawHitChance(var/dist)
	return base_accuracy

/datum/weapon/proc/GetHitChance(var/dist, var/cover)
	var/hit = GetRawHitChance(dist)
	if(cover <= 0)
		hit *= 1.5
	else
		hit -= cover * 10
	if(hit > 100) hit = 100
	else if(hit < 0) hit = 0
	return hit

/datum/weapon/proc/OnHit(var/mob/soldier/user, var/mob/soldier/target)

	set waitfor = 0

	new /obj/effect/floater/enormous(user.loc, FORMAT_MAPTEXT(name))
	if(!prob(GetHitChance(get_dist(user, target), target.GetCover())))
		new /obj/effect/floater(target.loc, FORMAT_MAPTEXT("<font color='#fe3b1e'><B>MISS</B></font>"))
		return
	if(can_crit && prob(base_crit_chance))
		var/dam = rand(min_crit_damage, max_crit_damage)
		target.TakeDamage(dam)
		new /obj/effect/floater(target.loc, FORMAT_MAPTEXT("<font color='#f7aa30'><B>CRIT -[dam]</B></font>"))
	else
		var/dam = rand(min_damage, max_damage)
		target.TakeDamage(dam)
		new /obj/effect/floater/small(target.loc, FORMAT_MAPTEXT("<font color='#fe3b1e'><B>-[dam]</B></font>"))

	for(var/i = 1 to burst)
		DoFireAnim(user, target)
		sleep(burst_delay)

/datum/weapon/proc/DoFireAnim(var/mob/soldier/user, var/mob/soldier/target)

	var/image/I
	var/image/J
	if(fire_overlay)
		I = image(icon = 'icons/effects/gunfire.dmi', icon_state = fire_overlay, dir = user.dir)
		if(gunfire_x_jitter) I.pixel_w = rand(-(gunfire_x_jitter), gunfire_x_jitter)
		if(gunfire_y_jitter) I.pixel_z = rand(-(gunfire_y_jitter), gunfire_y_jitter)
		user.overlays += I
	if(hit_overlay)
		J = image(icon = 'icons/effects/gunfire.dmi', icon_state = hit_overlay, dir = user.dir)
		if(gunfire_x_jitter) J.pixel_w = rand(-(gunfire_x_jitter), gunfire_x_jitter)
		if(gunfire_y_jitter) J.pixel_z = rand(-(gunfire_y_jitter), gunfire_y_jitter)
		target.overlays += J

	spawn(burst_delay)
		if(I) user.overlays -= I
		if(J) target.overlays -= J

/datum/weapon/shotgun
	name = "Shotgun"
	icon_state = "shotgun"
	base_crit_chance = 20

/datum/weapon/shotgun/GetRawHitChance(var/dist)
	var/hit = ..()
	if(dist <= 10)
		hit += 50/(dist/10)
	else
		hit -= 29 - (29/((dist-10)/5))
	return hit

/datum/weapon/pistol
	name = "Pistol"
	icon_state = "pistol"
	max_ammo = -1
	min_damage = 1
	max_damage = 2
	min_crit_damage = 2
	max_crit_damage = 4
	base_crit_chance = 0

/datum/weapon/lmg
	name = "Light Machine Gun"
	icon_state = "lmg"
	base_crit_chance = 0
	burst = 8
	burst_delay = 3
	fire_cost = 1

/datum/weapon/lmg/GetRawHitChance(var/dist)
	var/hit = ..()
	if(dist <= 10)
		hit += 37.5/(dist/10)
	return hit

/datum/weapon/sniper
	name = "Sniper Rifle"
	icon_state = "sniper"
	base_crit_chance = 25

/datum/weapon/sniper/GetRawHitChance(var/dist)
	var/hit = ..()
	if(dist <= 10)
		hit -= 24.5/(dist/10)
	return hit

/datum/weapon/assault
	name = "Assault Rifle"
	icon_state = "assault"
	burst = 3
	max_ammo = 5
	min_damage = 2
	max_damage = 4
	min_crit_damage = 5
	max_crit_damage = 7
	base_crit_chance = 10

/datum/weapon/assault/GetRawHitChance(var/dist)
	var/hit = ..()
	if(dist <= 10)
		hit += 37.5/(dist/10)
	return hit

/datum/weapon/rocket
	name = "Rocket Launcher"
	icon_state = "rocket"
	max_ammo = 1
	single_use = TRUE
	min_damage = 6
	max_damage = 6
	can_crit = FALSE

/datum/weapon/rocket/GetRawHitChance(var/dist)
	return 100