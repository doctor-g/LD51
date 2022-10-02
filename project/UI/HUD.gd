extends Control

export var lerp_weight := 0.2

onready var _score_label := find_node("ScoreLabel")
onready var _resources_label := find_node("ResourcesLabel")
onready var _base_health_label := find_node("BaseHealthLabel")
onready var _meteor_bar := find_node("MeteorProgressBar")

var _displayed_score : float
var _displayed_resources : float

func _ready():
	_displayed_score = Global.score
	_displayed_resources = Global.resources


func _process(_delta):
	_displayed_score = lerp(_displayed_score, Global.score, lerp_weight)
	_displayed_resources = lerp(_displayed_resources, Global.resources, lerp_weight)
	
	_score_label.text = "Score: %d" % ceil(_displayed_score)
	_resources_label.text = "Resources: %d" % round(_displayed_resources)
	_base_health_label.text = "Base Health: %d" % Global.base_health
	_meteor_bar.value = Global.time_to_impact
