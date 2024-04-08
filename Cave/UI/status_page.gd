extends "res://UI/interaction_base.gd"

@onready var health_bar = $background/button_holder/status_holder2/VBoxContainer/health_status
@onready var thirst_bar = $background/button_holder/status_holder1/VBoxContainer/thirst_status
@onready var item_image = $background/button_holder/item_holder/MarginContainer/item_image
@onready var handler = get_parent()

func _on_visibility_changed():
	if handler != null:
		health_bar.value = handler.current_survivor.health
		thirst_bar.value = handler.current_survivor.thirst
		if handler.current_survivor.item.size() > 0:
			item_image.texture = GameHandler.item_images[handler.current_survivor.item[0]]
