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

/datum/weapon/New()
	..()
	loaded_ammo = max_ammo

/datum/weapon/proc/GetHitChance(var/dist, var/cover)
	return base_accuracy

/datum/weapon/proc/OnHit(var/mob/soldier/user, var/mob/soldier/target)
	if(!prob(GetHitChance(get_dist(user, target))))
		return
	if(can_crit && prob(base_crit_chance))
		target.TakeDamage(rand(min_crit_damage, max_crit_damage))
	else
		target.TakeDamage(rand(min_damage, max_damage))

/datum/weapon/shotgun
	name = "Shotgun"
	icon_state = "shotgun"
	base_crit_chance = 20

/datum/weapon/shotgun/GetHitChance(var/dist, var/cover)
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

/datum/weapon/lmg/GetHitChance(var/dist, var/cover)
	var/hit = ..()
	if(dist <= 10)
		hit += 37.5/(dist/10)
	return hit

/datum/weapon/sniper
	name = "Sniper Rifle"
	icon_state = "sniper"
	base_crit_chance = 25

/datum/weapon/sniper/GetHitChance(var/dist, var/cover)
	var/hit = ..()
	if(dist <= 10)
		hit -= 24.5/(dist/10)
	return hit

/datum/weapon/assault
	name = "Assault Rifle"
	icon_state = "assault"
	max_ammo = 5
	min_damage = 2
	max_damage = 4
	min_crit_damage = 5
	max_crit_damage = 7
	base_crit_chance = 10

/datum/weapon/assault/GetHitChance(var/dist, var/cover)
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

/datum/weapon/rocket/GetHitChance(var/dist, var/cover)
	return 100