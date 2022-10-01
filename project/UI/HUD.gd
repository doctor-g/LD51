extends Control

onready var _score_label := find_node("ScoreLabel")
onready var _resources_label := find_node("ResourcesLabel")
onready var _base_health_label := find_node("BaseHealthLabel")
onready var _meteor_bar := find_node("MeteorProgressBar")

func _process(_delta):
	_score_label.text = "Score: %d" % PlayerStats.score
	_resources_label.text = "Resources: %d" % PlayerStats.resources
	_base_health_label.text = "Base Health: %d" % PlayerStats.base_health
	_meteor_bar.value = Global.time_to_impact
