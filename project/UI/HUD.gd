extends Control

export var lerp_weight := 0.2

var _displayed_score : float
var _displayed_resources : float

onready var _score_label := find_node("ScoreLabel")
onready var _resources_label := find_node("ResourcesLabel")
onready var _base_health_label := find_node("BaseHealthLabel")
onready var _countdown := find_node("Countdown")

func _ready():
	_displayed_score = 0
	_displayed_resources = Global.DEFAULT_RESOURCES

func _process(_delta):
	_displayed_score = lerp(_displayed_score, Global.score, lerp_weight)
	_displayed_resources = lerp(_displayed_resources, Global.resources, lerp_weight)

	if Global.resources < 300:
		_resources_label.add_color_override("font_color", Color.darkslateblue)
	else:
		_resources_label.remove_color_override("font_color")
	
	_score_label.text = "Score: %d" % ceil(_displayed_score)
	_resources_label.text = "Resources: %d" % round(_displayed_resources)
	_base_health_label.text = "Base Health: %d" % Global.base_health
	
	_countdown.text = "Next Meteor: %d" % (10-Global.time_to_impact)
