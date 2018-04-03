var/spawn_tick = rand(1,8)
var/spawn_bound = 10

/mob/controller/proc/CreateDefaultSoldiers()
	remaining_moves = list()
	owned_soldiers = list()
	for(var/soldiertype in list(
		/mob/soldier/assault,
		/mob/soldier/heavy,
		/mob/soldier/sniper,
		/mob/soldier/support
		))

		var/x11 = 1
		var/x12 = spawn_bound
		var/x21 = round(world.maxx*0.5)-round(spawn_bound * 0.5)
		var/x22 = x21+spawn_bound
		var/x31 = world.maxx-spawn_bound
		var/x32 = world.maxx

		var/y11 = 1
		var/y12 = spawn_bound
		var/y21 = round(world.maxy*0.5)-round(spawn_bound * 0.5)
		var/y22 = y21+spawn_bound
		var/y31 = world.maxy-spawn_bound
		var/y32 = world.maxy

		var/turf/placing
		while(!placing || placing.density == TRUE || placing.has_dense_atom)
			switch(spawn_tick)
				if(1) placing = locate(rand(x11,x12),rand(y11,y12),1)
				if(2) placing = locate(rand(x11,x12),rand(y21,y22),1)
				if(3) placing = locate(rand(x11,x12),rand(y31,y32),1)
				if(4) placing = locate(rand(x21,x22),rand(y31,y32),1)
				if(5) placing = locate(rand(x21,x22),rand(y11,y12),1)
				if(6) placing = locate(rand(x31,x32),rand(y11,y12),1)
				if(7) placing = locate(rand(x31,x32),rand(y21,y22),1)
				if(8) placing = locate(rand(x31,x32),rand(y31,y32),1)
		var/mob/soldier/new_soldier = new soldiertype(placing, src)
		owned_soldiers[new_soldier] = new_soldier
		remaining_moves += new_soldier
	spawn_tick++
	if(spawn_tick > 8)
		spawn_tick = 1
