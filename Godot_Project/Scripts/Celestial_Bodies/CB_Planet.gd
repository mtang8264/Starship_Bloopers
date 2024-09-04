class_name CB_Planet extends Celestial_Body

const cb_type = CB_Type.PLANET

# Called when the node enters the scene tree for the first time.
func _ready():
	if debugging_test_all_distances:
		test_all_distances()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
