class_name SaveGame
extends Resource

## Save Handler ##

const SAVE_DIR = "user://saves/"
var SAVE_FILE_NAME = "save.tres"

var save_path : String

func write_data() -> void:
	print("saving")
	save_path = SAVE_DIR + SAVE_FILE_NAME
	ResourceSaver.save(self,save_path)

func load_data() -> Resource:
	print("loading")
	save_path = SAVE_DIR + SAVE_FILE_NAME
	if ResourceLoader.exists(save_path):
		var loaded_resource = ResourceLoader.load(save_path, "", ResourceLoader.CACHE_MODE_IGNORE)
		# NOTE: assign every variable in save file with loaded variables
		player_data = loaded_resource.player_data
		events_completed = loaded_resource.events_completed
		item_instances = loaded_resource.item_instances
		death_conversations_given = loaded_resource.death_conversations_given
		return loaded_resource
	return null

## Save Data ##

# Game Handler #
@export var player_data : Resource = PlayerData.new()
@export var events_completed : Array = []
var items = GameHandler.items
@export var item_instances = [ # all items in game. [1] is the survivor it is assigned to
	[items.FLASHLIGHT, null],
	[items.FLASHLIGHT, null],
	[items.FLASHLIGHT, null],
	[items.FLASHLIGHT, null],
	[items.GASMASK, null],
	[items.ID, null],
	[items.KEY, null],
	[items.KNIFE, null],
	[items.KNIFE, null],
	[items.MEDKIT, null],
	[items.MEDKIT, null],
	[items.MEDKIT, null],
	[items.WELDER, null],
	[items.WELDER, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.TIRE, null],
	[items.ENGINE, null],
	[items.PROPELLER, null],
	[items.JERRYCAN, null],
]

@export var death_conversations_given = { # main keys are dead survivor (the topic), subkeys are surv talked to
	"ida" : {"mace":false,"wesley":false,"kate":false},
	"mace" : {"ida":false,"wesley":false,"kate":false},
	"wesley" : {"ida":false,"mace":false,"kate":false},
	"kate" : {"ida":false,"mace":false,"wesley":false}
}
