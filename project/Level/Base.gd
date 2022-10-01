extends Spatial

onready var _base_hit_sound := $BaseHitSound

func _on_Area_body_entered(body):
	Global.base_health -= 1
	_base_hit_sound.play()
	body.queue_free()
	
	if Global.base_health <= 0:
		var loss_control := preload("res://UI/LossControl.tscn").instance()
		add_child(loss_control)
		get_tree().paused = true
