class_name Distance extends Resource

# The different types of measurements that can be used
enum distance_unit {METER, KILOMETER, MEGAMETER, GIGAMETER, TERAMETER, AU, LIGHT_YEAR, PARSEC}
const unit_multipliers = [1000, 1000, 1000, 1000, 9460.73, 63241.077088, 3.26156]

@export var value : float
@export var unit : distance_unit

func _init(_value: float =0, _unit: distance_unit =distance_unit.METER):
	value = _value
	unit = _unit
	
static func zero_distance() -> Distance:
	return load("res://Static_Values/Zero_Distance.tres")
	
## Check if a distance is using a good unit for its value.
## Returns 1 if the value is too big and the unit should be increased.
## Returns -1 if the value is too small and the unit should be decreased.
## Returns 0 if the value is appropriate.
func is_ideal_scale() -> int:
	var can_upscale = unit < distance_unit.PARSEC
	var can_downscale = unit > distance_unit.METER
	var downscaled = convert_distance(unit - 1)
	if value < 1 and downscaled.value < 10000 and can_downscale:
		return -1
	if value > 9999 and can_upscale:
		return 1
	return 0

func convert_distance (output_unit: distance_unit, input_distance: Distance = self) -> Distance:
	# Break up the input_distance into its parts
	var input_unit = input_distance.unit
	var input_value = input_distance.value
	# Check to make sure we are not trying to push conversion beyond scale limits
	if output_unit > distance_unit.PARSEC:
		push_warning("Distance.convert_distance attempted to convert to a unit larger than parsecs. Returned as parsecs instead.")
		return convert_distance(distance_unit.PARSEC, input_distance)
	if output_unit < distance_unit.METER:
		push_warning("Distance.convert_distance attempted to convert to a unit smaller than meters. Returned as meters instead.")
		return convert_distance(distance_unit.METER, input_distance)
	# Base case if the input_unit is already the output_unit
	if input_unit == output_unit:
		# print("input_unit is output_unit")
		return Distance.new(input_value, input_unit)
	# Base case if the input_unit is one bigger than the output_unit
	if input_unit == output_unit + 1:
		# print("output_unit is one larger than input_unit")
		return Distance.new(input_value / unit_multipliers[output_unit], output_unit)
	# Base case if the input_unit is one smaller than the output_unit
	if input_unit == output_unit - 1:
		# print("output_unit is one smaller than input_unit")
		return Distance.new(input_value * unit_multipliers[input_unit], output_unit)
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
