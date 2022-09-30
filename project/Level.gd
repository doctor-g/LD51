extends Spatial

onready var _path:Path= $Path
onready var _path_follow:PathFollow = $Path/PathFollow

func _ready():
	_path.curve.clear_points()
	_path.curve.add_point(Vector3.ZERO)
	_path.curve.add_point(Vector3(10,0,0))
	var tween := get_tree().create_tween()
	var _ignored := tween.tween_property(_path_follow, 'unit_offset', 1.0, 1.0)
	
