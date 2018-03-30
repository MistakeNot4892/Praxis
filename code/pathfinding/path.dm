#define _H (abs(neighbor.x - T.x) + abs(neighbor.y - T.y))

#define ADD_NEIGHBORS_TO_OPEN_SET(_f, _centre, _depth) \
	if(_depth < max_steps) { \
		var/list/neighbors; \
		if(!passable_neighbors[_centre]) { \
			neighbors = list(); \
			for(var/checkdir in cardinal_directions) { \
				var/turf/neighbor = get_step(_centre, checkdir); \
				if(istype(neighbor) && neighbor != _centre && !neighbor.density && abs(_centre.height - neighbor.height) <= 1) { \
					neighbors += neighbor; \
				} \
			} \
			passable_neighbors[_centre] = neighbors; \
		} else { \
			neighbors = passable_neighbors[_centre]; \
		} \
		for(var/thing in neighbors) { \
			var/turf/neighbor = thing; \
			if(!neighbor.has_dense_atom && !closed_set[neighbor]) { \
				var/turf/T = thing; \
				var/f = _f + _H + T.move_cost; \
				if(neighbor.height < T.height) f *= 1.5; \
				var/list/adding = list(neighbor, f, _centre, _depth+1); \
				open_set.Add(list(adding)); \
				var/ind = open_set.len;\
				if(ind >= 2) { \
					var/par = round(ind * 0.5); \
					var/list/comparing = open_set[par]; \
					while(par >= 1 && (comparing && comparing[2] > f)) { \
						open_set.Swap(ind, par); \
						ind = par; \
						par = round(ind * 0.5); \
						if(par >= 1) comparing = open_set[par]; \
					} \
				} \
			} \
		} \
	}

/proc/GetPathBetween(var/turf/origin, var/turf/target, var/max_steps)

	if(max_steps <= 0 || target == origin)
		return list()

	var/list/final_path = list()
	var/list/closed_set = list(origin = TRUE)
	var/list/open_set = list()
	var/finalized_path

	ADD_NEIGHBORS_TO_OPEN_SET(1, origin, 0)

	while(open_set.len)
		var/list/_s = open_set[1]
		open_set.Cut(1,2)
		var/turf/_s_key = _s[1]
		closed_set[_s_key] = _s

		if(target == _s_key)
			var/turf/current = _s_key
			while(current != origin)
				final_path.Insert(1, current)
				var/list/current_data = closed_set[current]
				current = current_data[3]
			finalized_path = TRUE
			break
		ADD_NEIGHBORS_TO_OPEN_SET(_s[2], _s_key, _s[4])

	return finalized_path ? final_path : list()

#undef _H
#undef ADD_NEIGHBORS_TO_OPEN_SET
