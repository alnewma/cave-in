extends Control

@onready var lineT = $line
@onready var response1T = $response1
@onready var response2T = $response2
@onready var response3T = $response3

@export var line : String
@export var line_requirement : String
@export var line_alt : String

@export_group("Responses")
@export var response1 : String
@export var response1_requirement : String
@export var response1_alt : String # alts show up if req is met
@export var response2 : String
@export var response2_requirement : String
@export var response2_alt : String
@export var response3 : String
@export var response3_requirement : String
@export var response3_alt : String


enum characters_to_react {
	NONE,
	IDA,
	MACE,
	WESLEY,
	KATE
}

@export_group("Character Likes & Dislikes")
@export var reacting_character1 : characters_to_react
@export var likes_1 : bool
@export var reacting_character4 : characters_to_react
@export var dislikes_1 : bool

@export var reacting_character2 : characters_to_react
@export var likes_2 : bool
@export var reacting_character5 : characters_to_react
@export var dislikes_2 : bool

@export var reacting_character3 : characters_to_react
@export var likes_3 : bool
@export var reacting_character6 : characters_to_react
@export var dislikes_3 : bool

@export_group("Character Prod Ups & Downs")
@export var reacting_character7 : characters_to_react
@export var prod_up1 : bool
@export var reacting_character10 : characters_to_react
@export var prod_down1 : bool

@export var reacting_character8 : characters_to_react
@export var prod_up2 : bool
@export var reacting_character11 : characters_to_react
@export var prod_down2 : bool

@export var reacting_character9 : characters_to_react
@export var prod_up3 : bool
@export var reacting_character12 : characters_to_react
@export var prod_down3 : bool

@export_group("Requirement Events Fulfilled")
@export var response1_fulfilled_req : String
@export var response2_fulfilled_req : String
@export var response3_fulfilled_req : String

var destination1 : Node
var destination2 : Node
var destination3 : Node

var responses
var response_requirements = [response1_requirement,response2_requirement,response3_requirement]

var initialized = false
func _ready() -> void:
	if visible and not initialized:
		initialized = true
		initialization()

# only bother to initialise if node was made visible
func _on_visibility_changed() -> void:
	if visible and is_node_ready() and not initialized:
		initialized = true
		initialization()

var current_survivor_string : String
func initialization():
	print("initializing")
	responses = [response1T,response2T,response3T]
	for node in get_children(): # find response nodes
		if node.name.ends_with("1"):
			destination1 = node
		elif node.name.ends_with("2"):
			destination2 = node
		elif node.name.ends_with("3"):
			destination3 = node
	match get_tree().get_first_node_in_group("interaction_UI_handler").current_survivor.survivor_type:
		0: # Kate
			current_survivor_string = "Kate"
		1: # None
			current_survivor_string = "No Name"
		2: # Mace
			current_survivor_string = "Mace"
		3: # Ida
			current_survivor_string = "Ida"
		4: # Wesley
			current_survivor_string = "Wesley"
	var current_survivor = get_tree().get_first_node_in_group("interaction_UI_handler").current_survivor
	lineT.text = current_survivor_string + ": " + line
	if line_requirement == "happy": # if line has happiness requirement
		if GameHandler.player_data.survivor_data[current_survivor_string.to_lower()].conversation_happiness >= 0:
			lineT.text = current_survivor_string + ": " + line_alt
	elif line_requirement != "": # if line has other requirement
		if GameHandler.player_data.conversation_flags[line_requirement]:
			lineT.text = current_survivor_string + ": "+ line_alt
	if lineT.text == "": # hide entire node if line is blank
		hide()
	if response1 != "":
		if response1_requirement == "": # check if response doesn't have req
			response1T.text = "You: " + response1
		elif response1_requirement == "happy": # unique requirement code that checks if survivor happiness >= 0
			if GameHandler.player_data.survivor_data[current_survivor_string.to_lower()].conversation_happiness >= 0:
				response1T.text = "You: " + response1_alt # survivor is happy
			else:
				response1T.text = "You: " + response1 # survivor is not happy
		elif GameHandler.player_data.conversation_flags[response1_requirement]: # check if reponse req is met
			response1T.text = "You: " + response1_alt
		if response1T.text == "":
			response1T.hide()
	else:
		response1T.hide()
	if response2 != "":
		if response2_requirement == "": # check if response doesn't have req
			response2T.text = "You: " + response2
		elif response2_requirement == "happy": # unique requirement code that checks if survivor happiness >= 0
			if GameHandler.player_data.survivor_data[current_survivor_string.to_lower()].conversation_happiness >= 0:
				response2T.text = "You: " + response2_alt # survivor is happy
			else:
				response2T.text = "You: " + response2 # survivor is not happy
		elif GameHandler.player_data.conversation_flags[response2_requirement]: # check if reponse req is met
			response2T.text = "You: " + response2_alt
		if response2T.text == "":
			response2T.hide()
	else:
		response2T.hide()
	if response3 != "":
		if response3_requirement == "": # check if response doesn't have req
			response3T.text = "You: " + response3
		elif response3_requirement == "happy": # unique requirement code that checks if survivor happiness >= 0
			if GameHandler.player_data.survivor_data[current_survivor_string.to_lower()].conversation_happiness >= 0:
				response3T.text = "You: " + response3_alt # survivor is happy
			else:
				response3T.text = "You: " + response3 # survivor is not happy
		elif GameHandler.player_data.conversation_flags[response3_requirement]: # check if reponse req is met
			response3T.text = "You: " + response3_alt
		if response3T.text == "":
			response3T.hide()
	else:
		response3T.hide()
		
		
	response1T.connect("pressed",travel_destination.bind(response1T))
	response2T.connect("pressed",travel_destination.bind(response2T))
	response3T.connect("pressed",travel_destination.bind(response3T))
	var size_required = lineT.size.y
	for response in responses:
		if response:
			size_required += response.size.y
	custom_minimum_size.y = size_required
	await get_tree().process_frame
	lineT.clip_text = true
	lineT.clip_text = false
	response1T.clip_text = true
	response1T.clip_text = false
	response2T.clip_text = true
	response2T.clip_text = false
	response3T.clip_text = true
	response3T.clip_text = false

@onready var update_node = preload("res://UI/conversation_update.tscn")

func travel_destination(destination_button): # once reponse button is clicked
	
	# delete response nodes not chosen
	for response in responses:
		if response != destination_button:
			response.hide()
		else:
			response.disabled = true
	# get container for conversation update
	var c_holder = get_tree().get_first_node_in_group("interaction_UI_handler").get_children()
	var holder : Node
	for child in c_holder:
		if child.name == "update_holder":
			holder = child
	# make next dialogue path visible
	match destination_button:
		response1T:
			if response1_fulfilled_req:
				GameHandler.player_data.conversation_flags[response1_fulfilled_req] = true
			if dislikes_1:
				print(characters_to_react.keys()[reacting_character4].capitalize() + "dislikes")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.DISLIKE
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character4].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character4].to_lower()].conversation_happiness -= 1
			if likes_1:
				print(characters_to_react.keys()[reacting_character1].capitalize() + "likes")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.LIKE
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character1].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character1].to_lower()].conversation_happiness += 1
				
			if prod_down1:
				print(characters_to_react.keys()[reacting_character10].capitalize() + "prod decreased")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.PRODDOWN
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character10].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character10].to_lower()].productivity -= 1
			if prod_up1:
				print(characters_to_react.keys()[reacting_character7].capitalize() + "prod increased")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.PRODUP
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character7].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character7].to_lower()].productivity += 1
				
			destination1.show()
			update_if_end(destination1)
		response2T:
			if response2_fulfilled_req:
				GameHandler.player_data.conversation_flags[response2_fulfilled_req] = true
			if dislikes_2:
				print(characters_to_react.keys()[reacting_character5].capitalize() + "dislikes")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.DISLIKE
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character5].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character5].to_lower()].conversation_happiness -= 1
			if likes_2:
				print(characters_to_react.keys()[reacting_character2].capitalize() + "likes")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.LIKE
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character2].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character2].to_lower()].conversation_happiness += 1
				
			if prod_down2:
				print(characters_to_react.keys()[reacting_character11].capitalize() + "prod decreased")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.PRODDOWN
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character11].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character11].to_lower()].productivity -= 1
			if prod_up2:
				print(characters_to_react.keys()[reacting_character8].capitalize() + "prod increased")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.PRODUP
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character8].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character8].to_lower()].productivity += 1
				
			destination2.show()
			update_if_end(destination2)
		response3T:
			if response3_fulfilled_req:
				GameHandler.player_data.conversation_flags[response3_fulfilled_req] = true
			if dislikes_3:
				print(characters_to_react.keys()[reacting_character6].capitalize() + "dislikes")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.DISLIKE
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character6].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character6]].conversation_happiness -= 1
			if likes_3:
				print(characters_to_react.keys()[reacting_character3].capitalize() + "likes")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.LIKE
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character3].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character3]].conversation_happiness += 1
				
			if prod_down3:
				print(characters_to_react.keys()[reacting_character12].capitalize() + "prod decreased")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.PRODDOWN
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character12].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character12]].productivity -= 1
			if prod_up3:
				print(characters_to_react.keys()[reacting_character9].capitalize() + "prod increased")
				var temp_updater = update_node.instantiate()
				temp_updater.update_type = temp_updater.update_types.PRODUP
				temp_updater.survivor_name = characters_to_react.keys()[reacting_character9].capitalize()
				holder.add_child(temp_updater)
				GameHandler.player_data.survivor_data[characters_to_react.keys()[reacting_character9]].productivity += 1
				
			destination3.show()
			update_if_end(destination3)
	await get_tree().process_frame
	get_tree().get_first_node_in_group("dialogue_scroll_container").scroll_to_bottom()

func update_if_end(destination):
	await get_tree().process_frame
	print("checking destination")
	# if there are no more conversation nodes, register end of conversation
	var visible_children = 0
	for child in destination.get_children():
		if child.visible:
			visible_children += 1
	if visible_children <= 1: # if only visible line is line, no more responses
		GameHandler.player_data.survivor_data[current_survivor_string.to_lower()].conversation_point += 1
