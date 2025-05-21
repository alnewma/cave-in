extends "res://UI/interaction_base.gd"

@onready var handler = get_parent()
@onready var title = $background/button_holder/title_holder/TitleBanner/Label

func _ready() -> void:
	if get_parent().tunnel_scene:
		$background/button_holder/assign_button.hide()

func _on_visibility_changed() -> void:
	if visible and handler != null:
		var survivor_name : String
		match handler.current_survivor.survivor_type:
			0: survivor_name = "Kate"
			1: pass # No survivor
			2: survivor_name = "Mace"
			3: survivor_name = "Ida"
			4: survivor_name = "Wesley"
		title.text = survivor_name + " Interactions"
