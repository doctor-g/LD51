extends Node

signal meteor_timer_timeout

var time_to_impact : float setget ,_get_time_to_impact
var score : int
var resources : int
var base_health :int 

onready var _meteor_timer := $MeteorTimer

func reset():
	_meteor_timer.wait_time = 10
	score = 0
	resources = 1000
	base_health = 3


func _get_time_to_impact()->float:
	return 10 - _meteor_timer.time_left


func _on_MeteorTimer_timeout():
	emit_signal("meteor_timer_timeout")
