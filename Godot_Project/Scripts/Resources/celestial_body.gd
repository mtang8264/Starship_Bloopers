class_name CelestialBody extends Resource

enum CBType {
	GALAXY,
	STAR_SYSTEM,
	STAR,
	PLANET,
	SATELLITE,
	}

@export var width: Distance
@export var distance_from_parent: Distance
@export var orbiting_bodies: Array[CelestialBody]

func find_child(name_of_child: String) -> CelestialBody:
	for n in range(orbiting_bodies.size()):
		if orbiting_bodies[n].resource_name == name_of_child:
			return orbiting_bodies[n]
	for n in range(orbiting_bodies.size()):
		var child_search = orbiting_bodies[n].find_child(name_of_child)
		if child_search != null:
			return child_search
	return null

func get_parent() -> CelestialBody:
	var p = resource_path.split("/")
	if p.size() > 2:
		p.resize(p.size()-2)
	var pp = p[0]
	for n in range(1, p.size()):
		pp = pp + "/" + p[n]
	pp = pp + "/" + p[p.size()-1].to_lower() + ".tres"
	if FileAccess.file_exists(pp):
		return load(pp)
	return null

func get_index() -> int:
	var par = get_parent()
	for n in range(par.orbiting_bodies.size()):
		if par.orbiting_bodies[n] == self:
			return n
	return -1
