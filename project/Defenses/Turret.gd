extends Spatial

export var dps := 20.0

var _tracked_enemy : Spatial
var _random_generator := RandomNumberGenerator.new()


onready var _particles := $CPUParticles
onready var _shoot_sound := $ShootSound
onready var _shoot_sound_timer := $ShootSoundTimer


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
	_play_shooting_sound()
	

func _on_Area_body_exited(body):
	if body==_tracked_enemy:
		_tracked_enemy = null
		_particles.emitting = false


func _on_ShootSoundTimer_timeout():
	_play_shooting_sound()


func _play_shooting_sound():
	if _particles.emitting:
		_shoot_sound.pitch_scale = _random_generator.randfn(1, 0.1)
		_shoot_sound.play()
		_shoot_sound_timer.start(1.0/8.0)
