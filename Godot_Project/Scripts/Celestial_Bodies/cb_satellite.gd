class_name CBSatellite_DEP extends CelestialBody_DEP
## A class to define the values of a satellite.
##
## Extends CelestialBody.

const cb_type = CBType.SATELLITE

# Called when the node enters the scene tree for the first time.
func _ready():
	if debugging_test_all_distances:
		test_all_distances()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
