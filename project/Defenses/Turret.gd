extends Spatial

export var dps := 20.0

var _tracked_enemy : Spatial

onready var _particles := $CPUParticles


func _physics_process(delta):
	if _tracked_enemy:
		var target := _tracked_enemy.global_translation
		var source := global_translation
		# This will turn to face the target, only turning on the y axis.
		global_rotation.y = lerp_angle(global_rotation.y, atan2(source.x - target.x, source.z - target.z), 1)
		
		_tracked_enemy.damage(dps * delta)


func _on_Area_body_entered(body):
	_tracked_enemy = body
	_particles.emitting = true


func _on_Area_body_exited(body):
	if body==_tracked_enemy:
		_tracked_enemy = null
		_particles.emitting = false
