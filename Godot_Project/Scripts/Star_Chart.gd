class_name StarChart extends Node
## A class that controls a star chart screen.

enum Scale {
	GALAXY,
	SYSTEM,
	STAR,
	PLANET,
	SATELLITE}
var current_scale : Scale

var path_label: Label

## The node that is the highest element in the star chart.
@export var origin_body: CelestialBody
var path_to_current_body: Array[int]

func _ready():
	path_label = find_child("Path_Label")
	print("Star chart, " + name + ", is ready.")
	print("Star chart, " + name + "'s, base node is " + origin_body.get_name() + ".")
	print(origin_body.find_child("earth").resource_path)
	var path_to_earth = get_path_to_body_by_name("earth")
	print(path_to_earth)
	jump_to_path(path_to_earth)

func _process(delta):
	update_path_label()

## Returns the Celestial_Body object that is the base node of the star chart.
func get_origin_body() -> CelestialBody:
	return origin_body

## Returns the Celestial_Body object that is the current node of the star chart.
func get_current_body() -> CelestialBody:
	var pointer = origin_body
	for n in range(path_to_current_body.size()):
		pointer = pointer.orbiting_bodies[path_to_current_body[n]]
	return pointer

## Zooms the star chart in to a node that is the 'index' child of the current pointer.
func zoom_in(index: int):
	var current_body = get_current_body()
	if current_body.orbiting_bodies.size() > index:
		path_to_current_body.append(index)

## Zooms the star chart in to a node that is a child of the current node named name_of_child.
func zoom_in_to_name(name_of_child: String):
	var current_body = get_current_body()
	for n in range(current_body.orbiting_bodies.size()):
		if current_body.orbiting_bodies[n].resource_name == name_of_child:
			path_to_current_body.append(n)

## Zooms the star chart out one node.
func zoom_out():
	if path_to_current_body.size() > 0:
		path_to_current_body.pop_back()

## Returns the Celestial_Body object of a node given a specific path.
func get_node_at_path(path: Array[int]) -> CelestialBody:
	var pointer = origin_body
	for n in range(path.size()):
		if pointer.orbiting_bodies.size() <= path[n]:
			return null
		pointer = pointer.orbiting_bodies[path[n]]
	return pointer

## Checks if the given path returns a valid node.
func is_valid_path(path: Array[int]) -> bool:
	var pointer = origin_body
	for n in range(path.size()):
		if pointer.orbiting_bodies.size() <= path[n]:
			return false
		pointer = pointer.orbiting_bodies[path[n]]
	return true

## Attemps to overwrite the current path with a given one.
func jump_to_path(path: Array[int]):
	if is_valid_path(path):
		path_to_current_body = path
		return
	push_warning("Attempted to overwrite the path of star chart " + name + ". Path was not a valid path.")

func get_path_as_names(path: Array[int]) -> String:
	if is_valid_path(path) == false:
		push_warning("Attempt to run get_path_as_names from " + name + "was not a valid path.")
		return ""
	var pointer = origin_body
	var p_string = pointer.resource_name
	for n in range(path.size()):
		pointer = pointer.orbiting_bodies[path[n]]
		p_string = p_string + ">" + pointer.get_name()
	return p_string

func get_current_path_as_names() -> String:
	return get_path_as_names(path_to_current_body)

## Returns an Array[int] that is the path to a node given the star chart's base node.
func get_path_to_body_by_name(name_of_body: String) -> Array[int]:
	var pointer = origin_body.find_child(name_of_body)
	if pointer == null:
		push_warning("Star chart, " + name + ", could not find a path to the child " + name_of_body + ".")
		return Array()
	var path = Array([],TYPE_INT, "", null)
	var loop_counter = 0
	while pointer != origin_body:
		if loop_counter > 50:
			push_warning("Couldn't find a path to " + name_of_body + " within 50 loops.")
			return Array()
		var ind = Array([pointer.get_index()], TYPE_INT, "", null)
		ind.append_array(path)
		path = ind.duplicate()
		pointer = pointer.get_parent()
		loop_counter = loop_counter + 1
	return path
	
func update_path_label():
	path_label.text = get_current_path_as_names()
