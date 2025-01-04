extends Area2D

@export var depletion_rate : float = 1
var assigned_survivors = []
var using_survivors = []
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
@export var event : GameHandler.events

func _on_completion_status_changed(value):
	completion_status = value
	if completion_status == 100 and not completed:
		completed = true
		GameHandler.events_completed.append(event)
	emit_signal("completion_status_changed")
	ready_status_changed()

func _on_completed(value):
	completed = value
	if value: # assignment has been completed
		emit_signal("object_completed")
		give_item(available_items)
		completion_routine()

func ready_status_changed(): # to be overwritten per object
	pass
func completion_routine(): # to be overwritten per object
	pass

func _ready():
	required_tool = [required_tool1,required_tool2,required_tool3,required_tool4]
	var potential_available_items = [available_item1,available_item2,available_item3,available_item4]
	var ps_used = 0
	for p in potential_available_items: # create list of items produced from assignment
		ps_used += 1
		if ps_used <= available_item_count:
			available_items.append(p)
	if event in GameHandler.events_completed: # event has been completed in save
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

func _on_progression_timer_timeout():
	if assigned_survivors.size() > 0:
		spawn_smoke_if_applicable()
	
	# check if all required tools are provided
	var required_tools_accounted_for = true
	var tools_being_used = []
	for survivor in assigned_survivors:
		if survivor.state_machine.state == survivor.state_machine.activity: # if survivor is currently working
			for item in GameHandler.item_instances:
				if typeof(item[1]) == TYPE_OBJECT and item[1] == survivor:
					tools_being_used.append(item[0])
	for tool in required_tool:
		if tool and not tools_being_used.has(tool): # if a required tool isn't being used
			required_tools_accounted_for = false
	
	for survivor in assigned_survivors:
		if survivor.state_machine.state == survivor.state_machine.activity: # if survivor is currently working
			print(name + " progression: " + str(completion_status))
			if completion_status < 100 and required_tools_accounted_for: # increase progress based on productivity level and tools
				var progress_inc = pow(1.5,GameHandler.get_survivor_data_from_object(survivor).productivity)
				completion_status += progress_inc

@onready var dropped_item_base = preload("res://GameMap/dropped_item.tscn")
func give_item(items : Array):
	for item in items:
		var item_dispensed = false
		for survivor in assigned_survivors:
			# determine items owned by survivor
			var survivor_items = 0
			for i in GameHandler.item_instances:
				if i[1] is Node2D and i[1] == survivor:
					survivor_items += 1
			if survivor_items == 0:
				for item_instance in GameHandler.item_instances:
					if item_instance[0] == item and item_instance[1] == null: #item is available to be given
						if not item_dispensed:
							item_dispensed = true
							item_instance[1] = survivor
		if not item_dispensed:
			item_dispensed = true
			var item_drop = dropped_item_base.instantiate()
			get_tree().current_scene.add_child(item_drop)
			item_drop.global_position = global_position + random_radius()
			item_drop.texture = GameHandler.item_images[item]
			for item_instance in GameHandler.item_instances:
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
			get_tree().current_scene.add_child(smoke_instance)
			@warning_ignore("integer_division")
			smoke_instance.global_position = smoke_positions.pick_random().global_position + Vector2(randi_range(-12/4,12/4),randi_range(-12/4,12/4))
