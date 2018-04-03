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
	var/fire_cost = 1
	var/end_turn_on_use = TRUE
	var/fire_sound = 'sounds/lrsf-soundpack/pistol.wav'
	var/can_reload = TRUE

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

/datum/weapon/proc/OnMiss(var/mob/soldier/user, var/mob/soldier/target)
	new /obj/effect/floater(target.loc, FORMAT_MAPTEXT("<font color='#fe3b1e'><B>MISS</B></font>"))

/datum/weapon/proc/OnHit(var/mob/soldier/user, var/mob/soldier/target)

	set waitfor = 0

	new /obj/effect/floater/enormous(user.loc, FORMAT_MAPTEXT(name))
	if(prob(GetHitChance(get_dist(user, target), target.GetCover())))
		if(can_crit && prob(base_crit_chance))
			var/dam = rand(min_crit_damage, max_crit_damage)
			target.TakeDamage(dam)
		else
			var/dam = rand(min_damage, max_damage)
			target.TakeDamage(dam)
		loaded_ammo--
	else
		OnMiss(user, target)

	for(var/i = 1 to burst)
		PlaySound(fire_sound, user.loc, 75)
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
	fire_sound = 'sounds/lrsf-soundpack/shotgun.wav'
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
	name = "Machine Gun"
	icon_state = "lmg"
	base_crit_chance = 0
	burst = 8
	burst_delay = 3
	fire_cost = 1
	fire_sound = 'sounds/lrsf-soundpack/lmg.wav'
	end_turn_on_use = FALSE

/datum/weapon/lmg/GetRawHitChance(var/dist)
	var/hit = ..()
	if(dist <= 10)
		hit += 37.5/(dist/10)
	return hit

/datum/weapon/sniper
	name = "Sniper Rifle"
	icon_state = "sniper"
	base_crit_chance = 25
	fire_cost = 2

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
	can_reload = FALSE
	max_ammo = 1
	single_use = TRUE
	min_damage = 6
	max_damage = 6
	can_crit = FALSE
	hit_overlay = null
	burst_delay = 0
	fire_cost = 2
	fire_sound = 'sounds/jamastram-soundpack/explosion.wav'

/datum/weapon/rocket/GetHitChance(var/dist, var/cover)
	return 90

/datum/weapon/rocket/OnHit(var/mob/soldier/user, var/mob/soldier/target)
	loaded_ammo--
	PlaySound(fire_sound, target.loc, 100)
	if(!prob(GetHitChance()))
		target = pick(trange(3, target))
	for(var/turf/T in trange(1, target))
		new /obj/effect/explosion(T)
		for(var/mob/soldier/soldier in T.contents)
			soldier.TakeDamage(6)

