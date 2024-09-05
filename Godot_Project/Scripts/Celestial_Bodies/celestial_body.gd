class_name CelestialBody extends Node
## A parent class for all other celestial bodies.
##
## Contains the basic information all celestial bodies should posses. The enum
## CBType can be used to confirm or compare what kind of celestial bodyan object
## is. Contains the width and distance_from_parent values, and contains methods
## to verify that they are appropriately scaled.

enum CBType {
	GALAXY,
	STAR_SYSTEM,
	STAR,
	PLANET,
	SATELLITE,
	}

## The width of the body in a given unit.
@export var width: Distance
## The distance from the center of the parent body in a given unit.
@export var distance_from_parent: Distance

var debugging_test_all_distances = false

func test_width_unit():
	print("Testing the width of " + self.get_name() + ".")
	width.test_adjacent_units()
	return

func test_distance_from_parent_unit():
	print("Testing the distance_from_parent of " + self.get_name() + ".")
	distance_from_parent.test_adjacent_units()
	return

func test_all_distances():
	test_width_unit()
	test_distance_from_parent_unit()
	print("")
