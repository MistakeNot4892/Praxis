/obj/target_selector
	plane = GUI_PLANE
	icon = 'icons/screen/target_selector.dmi'

/obj/target_selector/panel
	name = "Target Selection Window"
	icon = 'icons/screen/target_panel.dmi'
	screen_loc = "CENTER-4:16,CENTER-4"
	maptext_x = 16
	maptext_y = 68
	maptext_height = 144
	maptext_width = 224

	var/mob/soldier/firer
	var/datum/weapon/firing
	var/current_choice = 1
	var/list/components
	var/list/choices

/obj/target_selector/panel/New(var/list/_choices, var/datum/weapon/_firing, var/mob/soldier/_firer)

	components = list(
		src,
		new /obj/target_selector/component/arrow_left(src),
		new /obj/target_selector/component/arrow_right(src),
		new /obj/target_selector/component/confirm(src),
		new /obj/target_selector/component/cancel(src)
	)

	firer = _firer
	firing = _firing
	choices = _choices
	Update(_firer.owner)

/obj/target_selector/panel/proc/GetSignal(var/signal, var/mob/controller/user)
	switch(signal)
		if("previous")
			current_choice--
		if("next")
			current_choice++
		if("confirm")
			user.ConfirmTargetSelection(choices[current_choice])
			return
		if("cancel")
			user.CancelTargetSelection()
			return
	if(current_choice < 1) current_choice = choices.len
	if(current_choice > choices.len) current_choice = 1
	Update(user)

/obj/target_selector/panel/proc/Update(var/mob/controller/user)
	var/atom/movable/target = choices[current_choice]
	var/hit_chance = firing.GetHitChance(get_dist(firer, choices[current_choice]))
	if(hit_chance < 0) hit_chance = 0
	else if(hit_chance > 100) hit_chance = 100
	maptext = "<center>[FORMAT_MAPTEXT("<b>Fire \the [firing]</b> - [firing.min_damage] to [firing.max_damage] damage ([firing.base_crit_chance]% critical chance) at <b>\the [target] - [hit_chance]%</b> chance to hit.")]</center>"
	if(user)
		user.Move(target.loc)

/obj/target_selector/component
	var/obj/target_selector/panel/panel
	var/signal

/obj/target_selector/component/New(var/obj/target_selector/_panel)
	panel = _panel

/obj/target_selector/component/Click()
	ReportToPanel(signal, usr)

/obj/target_selector/component/proc/ReportToPanel(var/signal, var/mob/controller/user)
	panel.GetSignal(signal, user)

/obj/target_selector/component/arrow_left
	name = "Previous Target"
	icon_state = "left"
	signal = "previous"
	screen_loc = "CENTER-2,CENTER-3"

/obj/target_selector/component/arrow_right
	name = "Previous Target"
	icon_state = "right"
	signal = "next"
	screen_loc = "CENTER+2,CENTER-3"

/obj/target_selector/component/confirm
	name = "Confirm"
	icon = 'icons/screen/target_selector_confirm.dmi'
	screen_loc = "CENTER-1,CENTER-3"
	maptext_y = -2
	maptext_x = 16
	maptext_width = 64
	signal = "confirm"

/obj/target_selector/component/confirm/New()
	..()
	maptext = "<center>[FORMAT_MAPTEXT("CONFIRM")]</center>"


/obj/target_selector/component/cancel
	name = "Cancel"
	icon = 'icons/screen/target_selector_confirm.dmi'
	screen_loc = "CENTER-1,CENTER-4"
	maptext_y = -2
	maptext_x = 16
	maptext_width = 64
	signal = "cancel"

/obj/target_selector/component/cancel/New()
	..()
	maptext = "<center>[FORMAT_MAPTEXT("CANCEL")]</center>"
