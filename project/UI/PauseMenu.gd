extends Popup

onready var _music_check := find_node("MusicCheck")
onready var _sfx_check := find_node("SfxCheck")
onready var _music_bus := AudioServer.get_bus_index("Music")
onready var _sfx_bus := AudioServer.get_bus_index("SFX")

func _on_PauseMenu_about_to_show():
	_music_check.pressed = not AudioServer.is_bus_mute(_music_bus)
	_sfx_check.pressed = not AudioServer.is_bus_mute(_sfx_bus)


func _on_MusicCheck_toggled(button_pressed):
	AudioServer.set_bus_mute(_music_bus, not button_pressed)


func _on_SfxCheck_toggled(button_pressed):
	AudioServer.set_bus_mute(_sfx_bus, not button_pressed)


func _on_OKButton_pressed():
	hide()
	get_tree().paused = false
