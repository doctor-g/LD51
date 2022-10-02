extends Control

onready var _pause_popup := $PauseMenu
onready var _level := $Level

func _ready():
	Global.reset()
	

func _process(_delta):
	if _level.is_running and Input.is_action_just_pressed("pause"):
		_pause_popup.popup()
		get_tree().paused = true
