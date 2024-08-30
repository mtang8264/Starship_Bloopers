class_name Celestial_Body extends Node

## The width of the body in a given unit.
@export var width: Distance
## The distance from the center of the parent body in a given unit.
@export var distance_from_parent: Distance

func check_all_distance_scales():
	print("Checking all distance scales of " + self.get_name())
	check_width_scale_and_print()
	check_distance_from_parent_scale_and_print()

func check_width_scale_and_print():
	var result = width.is_ideal_scale()
	if result >= 0.5:
		print("Value of " + self.get_name() + "'s width is too large and unit should be increased.")
	if result <= -0.5:
		print("Value of " + self.get_name() + "'s width is too small and unit should be decreased.")
	if result < 0.5 and result > -0.5:
		print("Value of " + self.get_name() + "'s width is appropriate.")

func check_distance_from_parent_scale_and_print():
	var result = distance_from_parent.is_ideal_scale()
	if result >= 0.5:
		print("Value of " + self.get_name() + "'s distance from parent is too large and unit should be increased.")
	if result <= -0.5:
		print("Value of " + self.get_name() + "'s distance from parent is too small and unit should be decreased.")
	if result < 0.5 and result > -0.5:
		print("Value of " + self.get_name() + "'s distance from parent is appropriate.")
