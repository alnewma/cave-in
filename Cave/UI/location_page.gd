extends "res://UI/interaction_base.gd"

@onready var button_base = preload("res://UI/menu_button_base.tscn")
@onready var button_holder = $background/button_holder/CenterContainer/scrollbox/location_holder

func _ready():
	initiate()

func create_assignment(assignment_name : String, assignment_position = Vector2.ZERO):
	var assignment = button_base.instantiate()
	if assignment_position is String:
		assignment_position = str_to_var("Vector2" + assignment_position)
	assignment.button_text = assignment_name
	button_holder.add_child(assignment)
	assignment.get_node("NinePatchRect/Button").connect("pressed",location_pressed.bind(assignment_position))

func location_pressed(l_position):
	get_parent().change_page(get_parent().assignment_page)
	get_parent().assignment_page.establish_assignments(l_position)

func initiate():
	for button in button_holder.get_children():
		if button.is_in_group("menu_button"):
			button.queue_free()
	create_assignment("You")
	var locations = GameHandler.player_data.map_data.locations
	for location in locations:
		create_assignment(location["name"],location["position"])

func _on_visibility_changed():
	if visible:
		initiate()
