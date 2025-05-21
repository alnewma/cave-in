extends Area2D

@onready var sprite = $button_icon
@onready var assignment_menu = preload("res://UI/assignment_menu.tscn")

func _on_mouse_entered():
	if check_if_near_flag():
		if not self in GameHandler.prompts_hovered:
			GameHandler.prompts_hovered.append(self)
		var tween = get_tree().create_tween()
		tween.tween_property(sprite,"scale",Vector2(1,1),.2)

func _on_mouse_exited():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite,"scale",Vector2(0,0),.2)
	if self in GameHandler.prompts_hovered:
		GameHandler.prompts_hovered.erase(self)

func check_if_near_flag() -> bool:
	for flag in get_tree().get_nodes_in_group("location_flag"):
		if global_position.distance_to(flag.global_position) < flag.get_node("location_area/CollisionShape2D").shape.radius:
			return true
	return false

func _on_input_event(viewport, event, _shape_idx):
	viewport.set_input_as_handled()
	if event.is_action_pressed("object_select"):
		var menu_instance = assignment_menu.instantiate()
		get_tree().get_root().add_child(menu_instance)
		menu_instance.position = global_position + Vector2(5,-251*.1-3.5)
		var location = get_parent()
		menu_instance.location.text = location.display_name
		menu_instance.assignment.text = "Assignment: " + location.assignment
		refresh_assignment_menu_tool_text(location,menu_instance)
		menu_instance.get_node("p_move_timer").timeout.connect(refresh_assignment_menu_tool_text.bind(location,menu_instance))
		for item in location.available_items:
			var item_sprite = TextureRect.new()
			item_sprite.custom_minimum_size = Vector2(95,95)
			item_sprite.texture = GameHandler.item_images[item]
			menu_instance.output_grid.add_child(item_sprite)
			# add items to available output of assignment in assignment menu

func refresh_assignment_menu_tool_text(location,menu_instance):
	if location.required_tools and location.required_tools > 0:
		menu_instance.requirements.text = "Tool Requirements: "
		for tool in range(location.required_tools):
			menu_instance.requirements.text += GameHandler.items.keys()[location.required_tool[tool]].capitalize()
			# add checks and exes
			var tools_being_used = location.get_tools_being_used()
			if location.required_tool[tool] in tools_being_used:
				menu_instance.requirements.text += "[✓]"
			else:
				menu_instance.requirements.text += "[X]"
			if location.required_tools != 1 and tool != location.required_tools-1:
				menu_instance.requirements.text += ", "
