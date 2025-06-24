extends "res://UI/interaction_base.gd"

var removal_flag

func _ready():
	visible = false

@onready var title = $background/button_holder/title_holder/TitleBanner/Label
func _on_button_pressed(source_text):
	match source_text:
		"Confirm":
			if removal_flag:
				GameHandler.save_game_instance.player_data.map_data.locations.erase({"position":removal_flag.position,"name":removal_flag.flag_name})
				removal_flag.queue_free()
			visible = false
		"Close":
			visible = false
			removal_flag.peri.visible = false
			removal_flag.being_interacted_with = false

func removal_process(flag):
	removal_flag = flag
	title.text = removal_flag.flag_name
	visible = true
	removal_flag.being_interacted_with = true
