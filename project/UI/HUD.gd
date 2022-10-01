extends Control

onready var _score_label := find_node("ScoreLabel")
onready var _resources_label := find_node("ResourcesLabel")

func _process(_delta):
	_score_label.text = "Score: %d" % PlayerStats.score
	_resources_label.text = "Resources: %d" % PlayerStats.resources
