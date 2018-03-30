#define ADD_NEIGHBORS_TO_OPEN_SET(_f, _center, _depth) \
	if(TRUE) { \
		var/list/neighbors; \
		if(!passable_neighbors[_center]) { \
			neighbors = list(); \
			for(var/thing in trange(1, _center)) { \
				var/turf/neighbor = thing; \
				if(neighbor != _center && !neighbor.density && abs(_center.height - neighbor.height) <= 1) { \
					neighbors += neighbor; \
				} \
			} \
			passable_neighbors[_center] = neighbors; \
		} else { \
			neighbors = passable_neighbors[_center]; \
		} \
		for(var/thing in neighbors) { \
			var/turf/neighbor = thing; \
			if(!neighbor.has_dense_atom && !closed_set[neighbor]) { \
				var/turf/T = thing; \
				var/f = _f + (abs(neighbor.x - T.x) + abs(neighbor.y - T.y)) + (get_dir(neighbor, T) in diagonal_directions ? T.move_cost : T.move_cost * 1.5); \
				if(neighbor.height < T.height) f *= 1.5; \
				var/list/last_entry = open_set[neighbor]; \
				if(!last_entry || f < last_entry[1]) { \
					open_set[neighbor] = list(f, _center, _depth); \
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
		var/turf/_s_key
		var/lowest_f_score = 1.#INF
		for(var/thing in open_set)
			var/list/check = open_set[thing]
			if(check[1] <= lowest_f_score)
				_s_key = thing
				lowest_f_score = check[1]
				break
		if(!_s_key) _s_key = open_set[1]
		var/list/_s = open_set[_s_key]
		open_set -= _s_key
		closed_set[_s_key] = _s
		if(target == _s_key)
			var/turf/current = _s_key
			while(current != origin)
				final_path.Insert(1, current)
				var/list/current_data = closed_set[current]
				current = current_data[2]
			finalized_path = TRUE
		else if(_s[1] < max_steps)
			ADD_NEIGHBORS_TO_OPEN_SET(_s[1], _s_key, _s[3])

	return finalized_path ? final_path : null

#undef GET_PASSABLE_NEIGHBORS