extends Spatial

var _tracked_enemy : Spatial


func _physics_process(_delta):
	if _tracked_enemy:
		look_at(_tracked_enemy.global_translation, Vector3.UP)


func _on_Area_body_entered(body):
	_tracked_enemy = body
	

func _on_Area_body_exited(body):
	if body==_tracked_enemy:
		_tracked_enemy = null
