extends Control

@onready var button = preload("res://UI/menu_button_base.tscn")
@onready var assignment_holder = $background/button_holder/CenterContainer/scrollbox/assignment_holder

func establish_assignments(location : Vector2):
	for xbutton in assignment_holder.get_children():
		xbutton.queue_free()
	var location_flag
	for object in get_tree().get_nodes_in_group("location_flag"):
		if object.global_position == location:
			location_flag = object
	if location_flag: # else: location is player
		for object in get_tree().get_nodes_in_group("interaction_object"):
			if object.overlaps_area(location_flag.get_node("location_area")): # assigning button to each job in flag
				var lButton = button.instantiate()
				lButton.button_text = object.display_name
				assignment_holder.add_child(lButton)
				lButton.button_node.connect("pressed",assign_survivor.bind(object, location))
		# add scavenging in area
		#var lButton = button.instantiate()
		#lButton.button_text = "Scavange Area"
		#assignment_holder.add_child(lButton)
		#lButton.button_node.connect("pressed",assign_survivor.bind(null, location, "scavange"))
		# add guarding area
		var lButton2 = button.instantiate()
		lButton2.button_text = "Guard Area"
		assignment_holder.add_child(lButton2)
		lButton2.button_node.connect("pressed",assign_survivor.bind(null, location, "guard"))
	else:
		var lButton = button.instantiate()
		lButton.button_text = "Follow"
		assignment_holder.add_child(lButton)
		lButton.button_node.connect("pressed",assign_survivor.bind(get_tree().get_first_node_in_group("player")))
	
func assign_survivor(object:Object, location = Vector2.ZERO, assignment = ""): # object is assigned location
	visible = false
	var c_survivor = get_parent().current_survivor
	c_survivor.assigned_location = location
	if object:
		c_survivor.target_assignment = object.get_path()
		object.set_assigned_survivors(c_survivor.get_path(),true)
		GameHandler.get_survivor_data_from_object(c_survivor).target_assignment = c_survivor.target_assignment
		GameHandler.get_survivor_data_from_object(c_survivor).target_usage = c_survivor.target_usage
		if object.is_in_group("player"):
			c_survivor.queue_remark(c_survivor.remark_prompts.FOLLOWING)
	elif assignment == "guard":
		pass
