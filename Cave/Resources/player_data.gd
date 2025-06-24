extends Resource
class_name PlayerData

@export var player_character_stats = {
	health = 100,
	thirst = 100,
	global_position = Vector2(470,123),
	notes = ""
}

@export var map_data = {
	locations = []
}

@export var objective_data = {}

@export var survivor_data = {
	ida = {
		health = 100,
		thirst = 100,
		global_position = Vector2(814,145),
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0,
		assigned_location = Vector2(814,145),
		target_area = "",
		target_assignment = "",
		target_usage = ""
	},
	mace = {
		health = 100,
		thirst = 100,
		global_position = Vector2(676,67),
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0,
		assigned_location = Vector2(676,67),
		target_area = "",
		target_assignment = "",
		target_usage = ""
	},
	wesley = {
		health = 100,
		thirst = 100,
		global_position = Vector2(205,55),
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0,
		assigned_location = Vector2(205,55),
		target_area = "",
		target_assignment = "",
		target_usage = ""
	},
	kate = {
		health = 100,
		thirst = 100,
		global_position = Vector2(863,237),
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0,
		assigned_location = Vector2(863,237),
		target_area = "",
		target_assignment = "",
		target_usage = ""
	}
}

@export var conversation_flags = {
	"ida" = false,
	"mace" = false,
	"wesley" = false,
	"kate" = false,
	"religion_argument" = false,
	"skepticism" = false,
	"wesley_disagreement" = false,
	"mace_food" = false,
	"stream_conversation" = false,
	"ida_mentioned" = false,
	"through_door" = false,
	"casserole_conversation" = false,
	"second_guessed" = false,
	"plan_conversation" = false,
	"confidence_conversation" = false,
	"nothing_to_be_scared_of_conversation" = false,
	"food_conversation" = false,
	"ida_dead" = false,
	"mace_dead" = false,
	"wesley_dead" = false,
	"kate_dead" = false,
	"ida_chosen" = false,
	"mace_chosen" = false,
	"wesley_chosen" = false,
	"kate_chosen" = false,
}

@export var game_flags = {
	"new_game" = true
}
