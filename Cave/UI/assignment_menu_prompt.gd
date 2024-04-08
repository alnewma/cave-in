extends Area2D

@onready var sprite = $button_icon
@onready var assignment_menu = preload("res://UI/assignment_menu.tscn")

func _on_mouse_entered():
	if not self in GameHandler.prompts_hovered:
		GameHandler.prompts_hovered.append(self)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite,"scale",Vector2(1,1),.2)

func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite,"scale",Vector2(0,0),.2)
	if self in GameHandler.prompts_hovered:
		GameHandler.prompts_hovered.erase(self)

func _on_input_event(viewport, event, _shape_idx):
	viewport.set_input_as_handled()
	if event.is_action_pressed("object_select"):
		print("clicked")
		var menu_instance = assignment_menu.instantiate()
		get_tree().get_root().add_child(menu_instance)
		menu_instance.position = global_position + Vector2(5,-251*.1-3.5)
		var location = get_parent()
		menu_instance.location.text = location.display_name
		menu_instance.assignment.text = "Assignment: " + location.assignment
		if location.has_required_tool:
			menu_instance.requirements.text = "Tool Requirements: " + GameHandler.items.keys()[location.required_tool].capitalize()
		for item in location.available_items:
			pass
			# add items
