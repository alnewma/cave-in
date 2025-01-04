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
				"notes": GameHandler.player_data.player_character_stats.notes
			},
			"map_data":{
				"locations": GameHandler.player_data.map_data.locations
			},
			"survivor_data":{
				"ida": GameHandler.player_data.survivor_data.ida,
				"mace": GameHandler.player_data.survivor_data.mace,
				"wesley": GameHandler.player_data.survivor_data.wesley,
				"kate": GameHandler.player_data.survivor_data.kate
			},
			"conversation_flags":GameHandler.player_data.conversation_flags
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
		
		GameHandler.player_data.conversation_flags = data.player_data.conversation_flags
		save_data(path)
	else:
		printerr("Cannot open non-existent file at %s!" % [path])

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

enum events {
	NULL_EVENT,
	BLAST_DOOR,
	COMPUTER_UNLOCK,
	ENTRANCE_DOOR
}
var events_completed = []

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
	PROPELLER,
	JERRYCAN,
}
const item_names = {
	items.FLASHLIGHT : "Flashlight",
	items.GASMASK : "Gas Mask",
	items.ID : "ID Card",
	items.KEY : "Key",
	items.KNIFE : "Knife",
	items.MEDKIT : "Medkit",
	items.WELDER : "Welding Set",
	items.TIRE : "Tire",
	items.ENGINE : "Engine",
	items.PROPELLER : "Makeshift Propeller",
	items.JERRYCAN : "Jerrycan"
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
	items.JERRYCAN : preload("res://ArtAssets/Items/gas_can.png"),
}
const item_images_small = {
	items.FLASHLIGHT : preload("res://ArtAssets/Items/flashlight_small.png"),
	items.WELDER : preload("res://ArtAssets/Items/welder_small.png"),
	items.TIRE : preload("res://ArtAssets/Items/tire_small.png"),
	items.ENGINE : preload("res://ArtAssets/Items/engine_small.png"),
	items.PROPELLER : preload("res://ArtAssets/Items/propeller_small.png"),
	items.JERRYCAN : preload("res://ArtAssets/Items/gas_can_small.png"),
}
var item_instances = [ # all items in game. [1] is the survivor it is assigned to
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

func damage_target(origin:CharacterBody2D,target:CharacterBody2D,damage:int):
	if "health" in target:
		target.health -= damage
		target.modulate = Color.RED
		get_tree().create_timer(.25).connect("timeout",_damage_timer_timeout.bind(target))
func _damage_timer_timeout(target):
	target.modulate = Color.WHITE

enum enemies {
	BAT,
	DOG,
	RAT,
	SPIDER
}
var bat_base = preload("res://Animals/bat_base.tscn")
var dog_base = preload("res://Animals/dog_base.tscn")
var rat_base = preload("res://Animals/rat_base.tscn")
var spider_base = preload("res://Animals/spider_base.tscn")
func spawn_enemy(type:enemies,location:Vector2):
	var enemy_instance
	match type:
		enemies.BAT:
			enemy_instance = bat_base.instantiate()
		enemies.DOG:
			enemy_instance = dog_base.instantiate()
		enemies.RAT:
			enemy_instance = rat_base.instantiate()
		enemies.SPIDER:
			enemy_instance = spider_base.instantiate()
	get_tree().get_current_scene().call_deferred("add_child",enemy_instance)
	enemy_instance.global_position = location

func get_survivor_data_from_object(object : Object):
	match object.survivor_type:
		0: return GameHandler.player_data.survivor_data.kate
		1: return null
		2: return GameHandler.player_data.survivor_data.mace
		3: return GameHandler.player_data.survivor_data.ida
		4: return GameHandler.player_data.survivor_data.wesley
