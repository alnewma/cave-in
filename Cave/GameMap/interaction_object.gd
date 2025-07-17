extends Area2D

@export var depletion_rate : float = 1
var assigned_survivors = []
var using_survivors = []
@export var progress_SFX : AudioManager.effects
@export var available_item_count : int = 0
@export var available_item1 : GameHandler.items
@export var available_item2 : GameHandler.items
@export var available_item3 : GameHandler.items
@export var available_item4 : GameHandler.items
var available_items = []
@export var display_name : String = "Placeholder"
@export var assignment : String = "Placeholder"
@export var required_tools = 0
var required_tool = []
@export var required_tool1 : GameHandler.items
@export var required_tool2 : GameHandler.items
@export var required_tool3 : GameHandler.items
@export var required_tool4 : GameHandler.items
@export var completed = false : set = _on_completed
var completion_status = 0 : set = _on_completion_status_changed
@onready var depletion_timer = $depletion_timer
signal completion_status_changed
signal object_completed
var flags_through_which_player_is_nearby = []

func _on_completion_status_changed(value):
	completion_status = value
	if completion_status == 100 and not completed:
		completed = true
		GameHandler.save_game_instance.events_completed.append(name)
	emit_signal("completion_status_changed")
	ready_status_changed()

var completed_through_save = false # true if already completed, just retriggering through save loading
func _on_completed(value):
	completed = value
	if value: # assignment has been completed
		emit_signal("object_completed")
		if not completed_through_save:
			give_item(available_items)
		completion_routine()

func ready_status_changed(): # to be overwritten per object
	pass
func completion_routine(): # to be overwritten per object
	pass
##
#
# If there's no verify function and survivor is assigned, no crash
# If there is verify function but no survivor is assigned, no crash
# If both exist, there is a crash
# If only ready calls verify, there is a crash (no GameHandler)
# If only setters call verify, no crash
#
func set_assigned_survivors(value,add_or_erase : bool):
	_verify_self_array_existence()
	if add_or_erase: # adding
		if not value in assigned_survivors:
			assigned_survivors.append(value)
	else:
		if value in assigned_survivors:
			assigned_survivors.erase(value)
	GameHandler.save_game_instance.player_data.objective_data[name][0] = assigned_survivors.duplicate()
func set_using_survivors(value,add_or_erase : bool):
	_verify_self_array_existence()
	if add_or_erase: # adding
		if not value in using_survivors:
			using_survivors.append(value)
	else:
		if value in using_survivors:
			using_survivors.erase(value)
	GameHandler.save_game_instance.player_data.objective_data[name][1] = using_survivors.duplicate()

func _verify_self_array_existence():
	GameHandler.save_game_instance.player_data.objective_data.get_or_add(name,[assigned_survivors.duplicate(),using_survivors.duplicate()])

func _ready():
	# save setup
	_verify_self_array_existence()
	assigned_survivors = GameHandler.save_game_instance.player_data.objective_data[name][0].duplicate()
	using_survivors = GameHandler.save_game_instance.player_data.objective_data[name][1].duplicate()
	# other
	required_tool = [required_tool1,required_tool2,required_tool3,required_tool4]
	var potential_available_items = [available_item1,available_item2,available_item3,available_item4]
	var ps_used = 0
	for p in potential_available_items: # create list of items produced from assignment
		ps_used += 1
		if ps_used <= available_item_count:
			available_items.append(p)
	if name in GameHandler.save_game_instance.events_completed: # event has been completed in save
		completed_through_save = true
		self.completion_status = 100
	if depletion_rate > 0:
		depletion_timer.wait_time = depletion_rate

func _on_depletion_timer_timeout():
	if completion_status >= 1:
		completion_status -= 1

func manual_depletion(amount):
	if completion_status >= amount:
		completion_status -= amount
		return true
	else:
		return false

func get_tools_being_used() -> Array:
	var tools_being_used = []
	# check tools survivors are providing
	for survivorPath in assigned_survivors:
		var survivor = get_node(survivorPath)
		if survivor.state_machine.state == survivor.state_machine.activity: # if survivor is currently working
			for item in GameHandler.save_game_instance.item_instances:
				if typeof(item[1]) == TYPE_STRING_NAME and item[1] == survivor.name:
					tools_being_used.append(item[0])
					#print(name + ": " + item[1].name + " is using item")
	# check tools player is providing
	var player = get_tree().get_first_node_in_group("player")
	if flags_through_which_player_is_nearby.size() > 0: # player is nearby
		for item in GameHandler.save_game_instance.item_instances:
			if typeof(item[1]) == TYPE_STRING_NAME and item[1] == player.name:
				tools_being_used.append(item[0])
				#print("player is using item")
	return tools_being_used

func _on_progression_timer_timeout():

	# check if all required tools are provided
	var required_tools_accounted_for = true
	var tools_being_used = get_tools_being_used()

	for tool in required_tool:
		if tool and not tools_being_used.has(tool): # if a required tool isn't being used
			required_tools_accounted_for = false
	
	for survivorPath in assigned_survivors:
		var survivor = get_node(survivorPath)
		if survivor.state_machine.state == survivor.state_machine.activity: # if survivor is currently working
			if survivor.thirst > 0 or display_name == "Fire Hydrant": # if survivor not too thirsty to work or is pumping water
				#print(name + " progression: " + str(completion_status))
				if completion_status < 100 and required_tools_accounted_for: # increase progress based on productivity level and tools
					var progress_inc = pow(1.5,GameHandler.get_survivor_data_from_object(survivor).productivity)
					completion_status += progress_inc
					if not spawn_smoke_if_applicable() and progress_SFX: # if no smoke but object has sound
						AudioManager.play_effect(progress_SFX,0,0,0,global_position)
			else:
				if randi()%4==0:
					survivor.queue_remark(survivor.remark_prompts.WORKTHIRST)

@onready var dropped_item_base = preload("res://GameMap/dropped_item.tscn")
func give_item(items : Array):
	for item in items:
		var item_dispensed = false
		for survivor in assigned_survivors:
			# determine items owned by survivor
			var survivor_items = 0
			for i in GameHandler.save_game_instance.item_instances:
				if i[1] is StringName and i[1] == get_node(survivor).name:
					survivor_items += 1
			if survivor_items == 0:
				for item_instance in GameHandler.save_game_instance.item_instances:
					if item_instance[0] == item and item_instance[1] == null: #item is available to be given
						if not item_dispensed:
							item_dispensed = true
							item_instance[1] = get_node(survivor).name
							get_node(survivor).queue_remark(get_node(survivor).remark_prompts.TOOL,GameHandler.item_names[item_instance[0]])
		if not item_dispensed:
			item_dispensed = true
			var item_drop = dropped_item_base.instantiate()
			get_tree().current_scene.add_child.call_deferred(item_drop)
			item_drop.global_position = global_position + random_radius()
			item_drop.texture = GameHandler.item_images[item]
			for item_instance in GameHandler.save_game_instance.item_instances:
				if item_instance[0] == item and item_instance[1] == null:
					item_instance[1] = item_drop.global_position
					break

func random_radius():
	var radius = randf_range(1,15)
	var angle = randf_range(0,2*PI)
	return Vector2(int(cos(angle)*radius),int(sin(angle)*radius))

@onready var smoke = preload("res://GameMap/smoke_puff.tscn")
func spawn_smoke_if_applicable():
	if completion_status != 100:
		var smoke_positions = []
		for child in get_children():
			if "smoke" in child.name:
				smoke_positions.append(child)
		if smoke_positions.size() > 0:
			var smoke_instance = smoke.instantiate()
			if progress_SFX:
				smoke_instance.effect_to_play = progress_SFX
			get_tree().current_scene.add_child(smoke_instance)
			@warning_ignore("integer_division")
			smoke_instance.global_position = smoke_positions.pick_random().global_position + Vector2(randi_range(-12/4,12/4),randi_range(-12/4,12/4))
			return true
	return false
