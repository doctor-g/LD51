extends Spatial

var _tracked_enemy : Spatial

onready var _particles := $CPUParticles


func _physics_process(_delta):
	if _tracked_enemy:
		var target := _tracked_enemy.global_translation
		var source := global_translation
		# This will turn to face the target, only turning on the y axis.
		global_rotation.y = lerp_angle(global_rotation.y, atan2(source.x - target.x, source.z - target.z), 1)


func _on_Area_body_entered(body):
	_tracked_enemy = body
	_particles.emitting = true


func _on_Area_body_exited(body):
	if body==_tracked_enemy:
		_tracked_enemy = null
		_particles.emitting = false
