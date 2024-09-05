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
@export var base_node: CelestialBody
var path_to_current_node: Array[int]

func _ready():
	path_label = find_child("path_label")
	
	print("Star chart, " + name + ", is ready.")
	print("Star chart, " + name + "'s, base node is " + base_node.name + ".")
	print("Star chart, " + name + "'s, current node is " + get_current_node().name + ".")
	var path_to_earth = get_path_to_node_by_name("Earth")
	jump_to_path(path_to_earth)
	print("Star chart, " + name + "'s, current node is " + get_current_node().name + ".")
	print(get_current_path_as_names())
	if path_label != null:
		path_label.text = get_current_path_as_names()

func _process(delta):
	pass

## Returns the Celestial_Body object that is the base node of the star chart.
func get_base_node() -> CelestialBody:
	return base_node

## Returns the Celestial_Body object that is the current node of the star chart.
func get_current_node() -> CelestialBody:
	var pointer = base_node
	for n in range(path_to_current_node.size()):
		pointer = pointer.get_child(path_to_current_node[n])
	return pointer

## Returns an Array[int] that is the path to a node given the star chart's base node.
func get_path_to_node_by_name(name_of_node: String) -> Array[int]:
	# Assign a pointer to the target node
	var pointer = base_node.find_child(name_of_node)
	# Check if the pointer is actually assigned
	if pointer == null:
		push_warning("Star chart," + name + ", could not find a node with the name " + name_of_node + ".")
		return Array()
	var path = Array([], TYPE_INT, "", null)
	var loop_counter = 0;
	while pointer != base_node:
		if loop_counter > 50:
			push_warning("Star chart," + name + ", could not find a path to node with the name " + name_of_node + " within 50 loops.")
			return Array()
		var ind = Array([pointer.get_index()], TYPE_INT, "", null)
		ind.append_array(path)
		path = ind.duplicate()
		pointer = pointer.get_parent()
		loop_counter = loop_counter + 1
	return path

## Zooms the star chart in to a node that is the 'index' child of the current pointer.
func zoom_in(index: int):
	var pointer = get_current_node()
	# Check to make sure the node has the appropriate number of children
	if pointer.get_child_count() <= index:
		push_warning("Can not zoom star chart, " + name + ", into index " + str(index) + " because current node, " + pointer.name + " only has " + str(pointer.get_child_count()) + " children.")
		print("The star chart, " + name + ", has failed to zoom in during zoom_in(" + str(index) + "). View warning for more information.")
		return
	# Append the new index to the path array
	path_to_current_node.append(index)
	print("The star chart, " + name + ", has been zoomed in to " + get_current_node().name + ".")

## Zooms the star chart in to a node that is a child of the current node named name_of_child.
func zoom_in_to_name(name_of_child: String):
	var pointer = get_current_node().find_child(name_of_child)
	# Check if there was no child found
	if pointer == null:
		push_warning("Can not zoom star chart, " + name + ", into child, " + name_of_child + ", because the current node, " + get_current_node().name + ", does not have a child of that name.")
		print("The star chart, " + name + ", has failed to zoom in during zoom_in_to_name(" + name_of_child + "). View warning for more information.")
		return
	zoom_in(pointer.get_index())
	pass

## Zooms the star chart out one node.
func zoom_out():
	path_to_current_node.pop_back()
	print("The star chart, " + name + ", has been zoomed out to " + get_current_node().name + ".")

## Returns the Celestial_Body object of a node given a specific path.
func get_node_at_path(path: Array[int]) -> CelestialBody:
	var pointer = base_node
	for n in range(path.size()):
		# Check to make sure an appropriate child exists.
		if pointer.get_child_count() <= path[n]:
			push_warning("Warning on call of get_node_at_path. Path index " + str(n) + " is out of bounds for given node, " + pointer.name + ".")
			return
		pointer = pointer.get_child(path[n])
	return pointer

## Checks if the given path returns a valid node.
func is_valid_path(path: Array[int]) -> bool:
	var pointer = get_node_at_path(path)
	return pointer != null

## Attemps to overwrite the current path with a given one.
func jump_to_path(path: Array[int]):
	# Find the given node being jumped to
	var pointer = get_node_at_path(path)
	# Check if node is valid
	if pointer == null:
		push_warning("Warning on call of jump_to_path. Given path did not return a valid node.")
		return
	path_to_current_node = path.duplicate()
	pass

func get_path_as_names(path: Array[int]) -> String:
	var s = ""
	if !is_valid_path(path):
		return s
	var pointer = base_node
	s = pointer.name
	for n in range(path.size()):
		pointer = pointer.get_child(path[n])
		s = s + ">" + pointer.name
	return s

func get_current_path_as_names() -> String:
	return get_path_as_names(path_to_current_node)
