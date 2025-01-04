extends "res://UI/interaction_base.gd"

var placeholder : AnimatedSprite2D
@onready var regex = RegEx.new()
@onready var name_entry = $background/button_holder/CenterContainer/NinePatchRect/name_entry

func _ready():
	visible = false
	regex.compile("[a-zA-Z0-9 ]+")

func _on_button_pressed(source_text):
	match source_text:
		"Confirm":
			if placeholder:
				placeholder.self_modulate.a = 1
				placeholder.flag_placed = true
				placeholder.flag_name = name_entry.text
				placeholder.peri.visible = false
				GameHandler.player_data.map_data.locations.append({"position":placeholder.position,"name":name_entry.text})
			visible = false
		"Close":
			if placeholder:
				placeholder.queue_free()
			visible = false

func _on_name_entry_text_changed(new_text):

	# valid characters
	var results = []
	for result in regex.search_all(new_text):
		results.push_back(result.get_string())
	new_text = "".join(results)
	name_entry.text = new_text
	name_entry.caret_column = new_text.length()
	
	# name availability
	var name_available = true
	var create_button = $background/button_holder/confirm_button/NinePatchRect/Button
	for location in GameHandler.player_data.map_data.locations:
		if location["name"] == new_text:
			name_available = false
	if name_available and new_text != "":
		create_button.disabled = false
	else:
		create_button.disabled = true

func creation_process(flag_placeholder : AnimatedSprite2D):
	visible = true
	placeholder = flag_placeholder
	get_parent().get_parent().add_child(flag_placeholder)
	placeholder.peri.visible = true
