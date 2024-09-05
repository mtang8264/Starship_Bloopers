class_name Distance extends Resource
## A class which handles measurements of great distance by converting internall to other units.
##
## Extends CelestialBody.

# The different types of measurements that can be used
enum DistanceUnit {
	METER,
	KILOMETER,
	MEGAMETER,
	GIGAMETER,
	AU,
	LIGHT_YEAR,
	PARSEC,
	}
const UNIT_MULTIPLIERS = [1000, 1000, 1000, 149.6, 63241.1, 3.26]

@export var value : float
@export var unit : DistanceUnit

func _init(_value:float =0.0, _unit:DistanceUnit =DistanceUnit.METER):
	value = _value
	unit = _unit
	
static func zero_distance() -> Distance:
	return load("res://Static_Values/Zero_Distance.tres")

static func unit_to_string(dist_unit: DistanceUnit) -> String:
	match dist_unit:
		DistanceUnit.METER:
			return "Meter"
		DistanceUnit.KILOMETER:
			return "Kilometer"
		DistanceUnit.MEGAMETER:
			return "Megameter"
		DistanceUnit.GIGAMETER:
			return "Gigameter"
		DistanceUnit.AU:
			return "AU"
		DistanceUnit.LIGHT_YEAR:
			return "Light Year"
		DistanceUnit.PARSEC:
			return "Parsec"
	return ""

func test_adjacent_units():
	# Print the current distance in the current unit
	print("Current distance is " + str(value) + " " + unit_to_string(unit))
	# Check if you can scale down
	if unit <= DistanceUnit.METER:
		print("Can not conver to a smaller unit.")
	else:
		var s = convert_distance(unit - 1)
		print("With a smaller unit the current distance is " + str(s.value) + " " + unit_to_string(s.unit))
	# Check if you can scale up
	if unit >= DistanceUnit.PARSEC:
		print("Can not conver to a larger unit.")
	else:
		var s = convert_distance(unit + 1)
		print("With a larger unit the current distance is " + str(s.value) + " " + unit_to_string(s.unit))
	return

func convert_distance (output_unit: DistanceUnit, input_distance: Distance = self) -> Distance:
	# Break up the input_distance into its parts
	var input_unit = input_distance.unit
	var input_value = input_distance.value
	
	# print("Input distance for conversion is " + str(input_value) + ", input unit is " + unit_to_string(input_unit) + ", and output unit is " + unit_to_string(output_unit) + ".")
	
	# Check to make sure we are not trying to push conversion beyond scale limits
	if output_unit > DistanceUnit.PARSEC:
		push_warning("Distance.convert_distance attempted to convert to a unit larger than parsecs. Returned as parsecs instead.")
		return convert_distance(DistanceUnit.PARSEC, input_distance)
	if output_unit < DistanceUnit.METER:
		push_warning("Distance.convert_distance attempted to convert to a unit smaller than meters. Returned as meters instead.")
		return convert_distance(DistanceUnit.METER, input_distance)
		
	# Base case if the input_unit is already the output_unit
	if input_unit == output_unit:
		# print("input_unit is output_unit")
		return Distance.new(input_value, input_unit)
	# Base case if we are trying to decrease unit by 1
	if input_unit -1 == output_unit:
		return Distance.new(input_value * UNIT_MULTIPLIERS[output_unit], output_unit)
	# Base case if we are trying to increase unit by 1
	if input_unit + 1 == output_unit:
		return Distance.new(input_value / UNIT_MULTIPLIERS[input_unit], output_unit)
		
	# Recursive case if input_unit is bigger than the output_unit
	if input_unit > output_unit + 1:
		# print("output_unit is more than one  smaller than input_unit")
		var stepped_down_distance = convert_distance(input_unit - 1, input_distance)
		return convert_distance(output_unit, stepped_down_distance)
	# Recursive case if input_unit is smaller than input_unit
	if input_unit < output_unit -1:
		# print("output_unit is more than one larger than input_unit")
		var stepped_up_distance = convert_distance(input_unit + 1, input_distance)
		return convert_distance(output_unit, stepped_up_distance)
	return null
