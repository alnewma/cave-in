extends Sprite2D

func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("object_select"):
		if mouse_inside:
			get_viewport().set_input_as_handled()
			for item in GameHandler.save_game_instance.item_instances:
				if item[1] is Vector2 and item[1] == global_position: # switch item to player inventory
					item[1] = get_tree().get_first_node_in_group("player")
					queue_free()

var mouse_inside = false
func _on_area_2d_mouse_entered():
	mouse_inside = true
func _on_area_2d_mouse_exited():
	mouse_inside = false
