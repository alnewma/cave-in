extends Resource
class_name PlayerData

@export var player_character_stats = {
	health = 100,
	thirst = 100,
	global_position = Vector2.ZERO,
	notes = ""
}

@export var map_data = {
	locations = []
}

@export var survivor_data = {
	ida = {
		health = 100,
		thirst = 100,
		global_position = Vector2.ZERO,
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0
	},
	mace = {
		health = 100,
		thirst = 100,
		global_position = Vector2.ZERO,
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0
	},
	wesley = {
		health = 100,
		thirst = 100,
		global_position = Vector2.ZERO,
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0
	},
	kate = {
		health = 100,
		thirst = 100,
		global_position = Vector2.ZERO,
		conversation_point = 0,
		conversation_happiness = 0,
		productivity = 0
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
	"kate_dead" = false,
	"ida_chosen" = false,
	"mace_chosen" = false,
	"wesley_chosen" = false,
	"kate_chosen" = false,
}
