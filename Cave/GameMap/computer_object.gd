extends "res://GameMap/interaction_object.gd"

func completion_routine():
	get_tree().get_first_node_in_group("computer_ui").locked = false
