/obj/screen/target_selector
	plane = GUI_PLANE
	icon = 'icons/screen/target_selector.dmi'
	alpha = 0
	mouse_opacity = 0

/obj/screen/target_selector/panel
	name = "Target Selection Window"
	icon = 'icons/screen/target_panel.dmi'
	screen_loc = "CENTER-4:16,CENTER-4"
	maptext_x = 16
	maptext_y = 68
	maptext_height = 144
	maptext_width = 224

	var/active
	var/mob/soldier/firer
	var/datum/weapon/firing
	var/current_choice = 1
	var/list/components
	var/list/choices

/obj/screen/target_selector/panel/New(var/mob/controller/owner)
	components = list(
		src,
		new /obj/screen/target_selector/component/arrow_left(src),
		new /obj/screen/target_selector/component/arrow_right(src),
		new /obj/screen/target_selector/component/confirm(src),
		new /obj/screen/target_selector/component/cancel(src)
	)
	if(owner)
		owner.screen_elements += components
		if(owner.client) owner.client.screen += components

/obj/screen/target_selector/panel/proc/Begin(var/list/_choices, var/datum/weapon/_firing, var/mob/soldier/_firer)
	if(!active)
		active = TRUE
		for(var/thing in components)
			var/atom/component = thing
			animate(component, alpha = 255, time = 3)
			component.mouse_opacity = 1
		current_choice = 1
		firer = _firer
		firing = _firing
		choices = _choices
		Update(_firer.owner)

/obj/screen/target_selector/panel/proc/End()
	if(active)
		active = FALSE
		for(var/thing in components)
			var/atom/component = thing
			animate(component, alpha = 0, time = 3)
			component.mouse_opacity = 0
		firer = null
		firing = null
		choices = null

/obj/screen/target_selector/panel/proc/GetSignal(var/signal, var/mob/controller/user)
	if(active)
		switch(signal)
			if("previous")
				current_choice--
			if("next")
				current_choice++
			if("confirm")
				var/mob/soldier/target = choices[current_choice]
				End()
				if(target && user.soldier) user.soldier.FireAt(target)
				return
			if("cancel")
				user.selecting_target.End()
				return
		if(current_choice < 1) current_choice = choices.len
		if(current_choice > choices.len) current_choice = 1
		Update(user)

/obj/screen/target_selector/panel/proc/Update(var/mob/controller/user)
	var/mob/soldier/target = choices[current_choice]
	var/hit_chance = firing.GetHitChance(get_dist(firer, target), target.GetCover())
	maptext = "<center>[FORMAT_MAPTEXT("<b>Fire \the [firing]</b> - [firing.min_damage] to [firing.max_damage] damage ([firing.base_crit_chance]% critical chance) at <b>\the [target] - [hit_chance]%</b> chance to hit.")]</center>"
	if(user)
		user.Move(target.loc)

/obj/screen/target_selector/component
	var/obj/screen/target_selector/panel/panel
	var/signal

/obj/screen/target_selector/component/New(var/obj/screen/target_selector/_panel)
	panel = _panel

/obj/screen/target_selector/component/Click()
	ReportToPanel(signal, usr)

/obj/screen/target_selector/component/proc/ReportToPanel(var/signal, var/mob/controller/user)
	panel.GetSignal(signal, user)

/obj/screen/target_selector/component/arrow_left
	name = "Previous Target"
	icon_state = "left"
	signal = "previous"
	screen_loc = "CENTER-2,CENTER-3"

/obj/screen/target_selector/component/arrow_right
	name = "Previous Target"
	icon_state = "right"
	signal = "next"
	screen_loc = "CENTER+2,CENTER-3"

/obj/screen/target_selector/component/confirm
	name = "Confirm"
	icon = 'icons/screen/target_selector_confirm.dmi'
	screen_loc = "CENTER-1,CENTER-3"
	maptext_y = -2
	maptext_x = 16
	maptext_width = 64
	signal = "confirm"

/obj/screen/target_selector/component/confirm/New(var/mob/controller/owner)
	..(owner)
	maptext = "<center>[FORMAT_MAPTEXT("CONFIRM")]</center>"

/obj/screen/target_selector/component/cancel
	name = "Cancel"
	icon = 'icons/screen/target_selector_confirm.dmi'
	screen_loc = "CENTER-1,CENTER-4"
	maptext_y = -2
	maptext_x = 16
	maptext_width = 64
	signal = "cancel"

/obj/screen/target_selector/component/cancel/New(var/mob/controller/owner)
	..(owner)
	maptext = "<center>[FORMAT_MAPTEXT("CANCEL")]</center>"
