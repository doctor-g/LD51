extends Control


func _on_PlayAgainButton_pressed():
	get_tree().paused = false
	var result := get_tree().change_scene("res://UI/MainMenuScreen.tscn")
	if result!=OK:
		print('Error changing scene! %s' % str(result))
