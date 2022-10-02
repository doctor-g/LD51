extends Spatial

signal destroyed

onready var _base_hit_sound := $BaseHitSound
onready var _anim_player := $AnimationPlayer

func _on_Area_body_entered(body):
	Global.base_health -= 1
	_base_hit_sound.play()
	_anim_player.play("Hit")
	body.queue_free()
	
	if Global.base_health <= 0:
		emit_signal("destroyed")
