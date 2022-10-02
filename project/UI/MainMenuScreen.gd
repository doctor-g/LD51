extends Control

export var autoplay := true

onready var _music := $Music
onready var _pause_menu :Popup = $PauseMenu

func _ready():
	if autoplay:
		_music.play()


func play_music():
	_music.play()


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World.tscn")



func _on_OptionsButton_pressed():
	_pause_menu.popup()
