extends Control

onready var _score_label := find_node("ScoreLabel")

func _process(_delta):
	_score_label.text = "Score: %d" % PlayerStats.score
