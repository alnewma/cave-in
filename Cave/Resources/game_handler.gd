extends Node

@export var player_data = PlayerData.new()

## Save Handler ##

const SAVE_DIR = "user://saves/"
var SAVE_FILE_NAME = "save.save"
const SECURITY_KEY = "J82HDI2"

func save_ready_function():
	verify_save_directory(SAVE_DIR)

func save_data(path : String = SAVE_DIR + SAVE_FILE_NAME):
	var file = FileAccess.open(path,FileAccess.WRITE)#FileAccess.open_encrypted_with_pass(path,FileAccess.WRITE,SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	var data = {
		"player_data":{
			"player_character_stats":{
				"health": GameHandler.player_data.player_character_stats.health,
				"thirst": GameHandler.player_data.player_character_stats.thirst,
				"global_position": {
					"x": GameHandler.player_data.player_character_stats.global_position.x,
					"y": GameHandler.player_data.player_character_stats.global_position.y
				},
				"notes": GameHandler.player_data.player_character_stats.notes,
				"inventory" : GameHandler.player_data.player_character_stats.inventory
			},
			"map_data":{
				"locations": GameHandler.player_data.map_data.locations
			},
			"survivor_data":{
				
			}
		}
	}
	var json_string = JSON.stringify(data,"\t")
	file.store_string(json_string)
	file.close()

func load_data(path : String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)#FileAccess.open_encrypted_with_pass(path,FileAccess.READ,SECURITY_KEY)
		if file == null:
			printerr(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as json_string: (%s)" % [path,content])
			return
		
		# create data object
		GameHandler.player_data = PlayerData.new()
		
		# sync player data
		GameHandler.player_data.player_character_stats = data.player_data.player_character_stats
		# sync map data
		GameHandler.player_data.map_data = data.player_data.map_data
		# sync survivor data
		GameHandler.player_data.survivor_data = data.player_data.survivor_data
		save_data(path)
	else:
		printerr("Cannot open non-existent file at %s!" % [path])

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

@export var prompts_hovered = []

enum items {
	FLASHLIGHT,
	GASMASK,
	ID,
	KEY,
	KNIFE,
	MEDKIT,
	WELDER,
	TIRE,
	ENGINE,
	PROPELLER
}
const item_images = {
	items.FLASHLIGHT : preload("res://ArtAssets/Items/Flashlight.png"),
	items.GASMASK : preload("res://ArtAssets/Items/GasMask.png"),
	items.ID : preload("res://ArtAssets/Items/ID.png"),
	items.KEY : preload("res://ArtAssets/Items/Key.png"),
	items.KNIFE : preload("res://ArtAssets/Knife.png"),
	items.MEDKIT : preload("res://ArtAssets/Items/MedKit.png"),
	items.WELDER : preload("res://ArtAssets/Welder.png"),
	items.TIRE : preload("res://ArtAssets/Tire.png"),
	items.ENGINE : preload("res://ArtAssets/Engine.png"),
	items.PROPELLER : preload("res://ArtAssets/Propeller.png"),
}
var item_instances = [
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
	[items.TIRE, null]
]

func damage_target(origin:CharacterBody2D,target:CharacterBody2D,damage:int):
	if "health" in target:
		target.health -= damage
		target.modulate = Color.RED
		get_tree().create_timer(.25).connect("timeout",_damage_timer_timeout.bind(target))
func _damage_timer_timeout(target):
	target.modulate = Color.WHITE
