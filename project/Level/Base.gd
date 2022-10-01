extends Spatial

func _on_Area_body_entered(body):
	PlayerStats.base_health -= 1
	body.queue_free()
