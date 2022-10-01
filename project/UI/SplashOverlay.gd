extends Control

var _triggered := false

onready var _splash := $ColorRect
onready var _main_menu := $MainMenu


func _on_AnimationPlayer_animation_finished(_anim_name):
	_main_menu.play_music()
	_splash.queue_free()


func _input(event):
	if not _triggered and (event is InputEventMouseButton or event is InputEventKey):
		$AnimationPlayer.play("FadeOut")
		_triggered = true
