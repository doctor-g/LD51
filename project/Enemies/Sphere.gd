extends Spatial

signal destroyed(position)

export var max_health := 100
export var points := 100
export var shards := 1
export var color := Color.white
export var speed := 5.0 # Meters (units) per second

var _destroyed := false
var _health := 100


onready var _material :Material = $CSGSphere.material

func _ready():
	_material.set_shader_param("color", Vector3(color.r, color.g, color.b))


func damage(amount:int)->void:
	_health -= amount
	
	# warning-ignore:integer_division
	var pulse_speed :float=  lerp(10.0, 1.0, _health / max_health)
	_material.set_shader_param("pulse_speed", pulse_speed)
	
	# This thing can be damaged more than once per frame,
	# so we have to separately keep track of whether it was
	# already destroyed.
	if _health <= 0 and not _destroyed:
		Global.score += points
		_destroyed = true
		emit_signal("destroyed")
		
		queue_free()
