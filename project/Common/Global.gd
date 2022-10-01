extends Node

signal meteor_timer_timeout

var time_to_impact : float setget ,_get_time_to_impact
var score := 0 
var resources := 1000
var base_health := 3

onready var _meteor_timer := $MeteorTimer

func _get_time_to_impact()->float:
	return 10 - _meteor_timer.time_left


func _on_MeteorTimer_timeout():
	emit_signal("meteor_timer_timeout")
