extends Spatial

signal destroyed(position)

export var max_health := 100.0
export var health := 100.0
export var points := 100
export var resources := 100

var _destroyed := false


func damage(amount:float)->void:
	health -= amount
	
	var pulse_speed :float=  lerp(10.0, 1.0, health / max_health)
	$CSGSphere.material.set_shader_param("pulse_speed", pulse_speed)
	
	# This thing can be damaged more than once per frame,
	# so we have to separately keep track of whether it was
	# already destroyed.
	if health <= 0 and not _destroyed:
		Global.score += points
		Global.resources += resources
		_destroyed = true
		emit_signal("destroyed")
		
		queue_free()
