var/datum/turn/turn_controller = new
var/list/all_soldiers = list()
var/list/passable_neighbors = list()
var/list/diagonal_directions = list(NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST)
var/list/cardinal_directions = list(NORTH, SOUTH, EAST, WEST)
var/list/all_directions = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST)
