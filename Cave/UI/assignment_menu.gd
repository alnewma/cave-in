extends Control

@onready var location = $background/button_holder/title_holder/TitleBanner/Label
@onready var assignment = $background/button_holder/assignment
@onready var requirements = $background/button_holder/requirements
@onready var output = $background/button_holder/output_title
@onready var output_grid = $background/button_holder/scrollbox/GridContainer

func _ready():
	player_pos = get_tree().get_first_node_in_group("player").global_position
	AudioManager.play_effect(AudioManager.effects.PAPERTAKEOUT)

func _on_button_pressed():
	AudioManager.play_effect(AudioManager.effects.PAPERPUTAWAY)
	queue_free()

var player_pos : Vector2
func _on_timer_timeout():
	if abs(get_tree().get_first_node_in_group("player").global_position - position) > Vector2(80,80):
	# player is far from menu
		if abs(get_tree().get_first_node_in_group("player").global_position - player_pos) > Vector2(30,30):
		# player has moved
			queue_free()
