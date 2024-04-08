extends "res://UI/interaction_base.gd"

var removal_flag

func _ready():
	visible = false

@onready var title = $background/button_holder/title_holder/TitleBanner/Label
func _on_button_pressed(source_text):
	match source_text:
		"Confirm":
			if removal_flag:
				removal_flag.queue_free()
			visible = false
		"Close":
			visible = false
			removal_flag.peri.visible = false

func removal_process(flag):
	removal_flag = flag
	title.text = removal_flag.flag_name
	visible = true
