extends Spatial

export var preview := false

# radians per second
export var preview_rotation_speed := 1.5

export(Material) var preview_material 

onready var _box := $CSGBox

func _ready():
	if preview:
		_box.material = preview_material
		
		# Start with random rotation
		var random_rotation = rand_range(0,TAU)
		rotation = Vector3(0, random_rotation, 0)


func _process(delta:float)->void:
	if preview:
		rotate(Vector3.UP, preview_rotation_speed * delta)
