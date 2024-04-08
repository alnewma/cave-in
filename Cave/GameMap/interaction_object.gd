extends Area2D

@export var depletion_rate : float = 1
var assigned_survivors = []
var using_survivors = []
var available_items = []
@export var display_name : String = "Placeholder"
@export var assignment : String = "Placeholder"
@export var has_required_tool = false
@export var required_tool : GameHandler.items
var completion_status = 0 : set = _on_completion_status_changed
@onready var depletion_timer = $depletion_timer
signal completion_status_changed

func _on_completion_status_changed(value):
	completion_status = value
	emit_signal("completion_status_changed")

func _ready():
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
	for survivor in assigned_survivors:
		if survivor.state_machine.state == survivor.state_machine.activity: # if survivor is currently working
			print("progression: " + str(completion_status))
			if completion_status <= 99:
				completion_status += 1

func give_item(items : Array):
	for item in items:
		for survivor in using_survivors:
			if survivor.item.size() == 0:
				for item_instance in GameHandler.item_instances:
					if item_instance[0] == item and item_instance[1] == null: #item is available to be given
						survivor.item.append(item)
						item_instance[1] = survivor
						return
