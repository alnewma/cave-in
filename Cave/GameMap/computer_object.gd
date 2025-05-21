extends "res://GameMap/interaction_object.gd"

func completion_routine():
	if not is_node_ready():
		await ready
	get_tree().get_first_node_in_group("computer_ui").locked = false
