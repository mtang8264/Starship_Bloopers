class_name Celestial_Body extends Node

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
