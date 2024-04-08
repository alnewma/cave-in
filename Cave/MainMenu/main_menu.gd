extends CanvasLayer

func _ready():
	menu_ready_function()
	container_ready_function()
	GameHandler.save_ready_function()

## Menu Handler ##

@onready var mainC = $background/main_container
@onready var newC = $background/new_container
@onready var loadC = $background/load_container
@onready var settingsC = $background/settings_container
@onready var regex = RegEx.new()
var containers = []

func menu_ready_function():
	containers = [mainC,newC,loadC,settingsC]

func _on_back_pressed():
	switch_container(mainC)

func _on_quit_pressed():
	get_tree().quit()

func switch_container(target_container):
	for container in containers:
		container.visible = false
	target_container.visible = true

## Container Setup ##

const save_button_base = preload("res://MainMenu/save_button_base.tscn")

func container_ready_function():
	# main container
	var save_files = DirAccess.get_files_at(GameHandler.SAVE_DIR)
	if save_files.size() == 0:
		mainC.get_node("load_game").disabled = true
	
	# new container
	regex.compile("[a-zA-Z0-9 ]+")
	
	# load container
	for file in save_files:
		var save_button = save_button_base.instantiate()
		save_button.save_file_name = file
		loadC.add_child(save_button)
		save_button.connect("pressed",load_button_pressed.bind(save_button))

func _on_new_game_pressed():
	switch_container(newC)
func _on_load_game_pressed():
	switch_container(loadC)

func load_button_pressed(button):
	GameHandler.SAVE_FILE_NAME = button.save_file_name
	GameHandler.load_data(GameHandler.SAVE_DIR + GameHandler.SAVE_FILE_NAME)
	load_map()

func _on_name_entry_text_changed(new_text):
	
	# valid characters
	var name_entry = newC.get_node("name_entry")
	var results = []
	for result in regex.search_all(new_text):
		results.push_back(result.get_string())
	new_text = "".join(results)
	name_entry.text = new_text
	name_entry.caret_column = new_text.length()
	
	# name availability
	var name_available = true
	var name_warning = newC.get_node("name_warning")
	var create_button = newC.get_node("create_button")
	for file in DirAccess.get_files_at(GameHandler.SAVE_DIR):
		if file.get_slice(".",0) == new_text:
			name_available = false
	if name_available:
		name_warning.visible = false
		create_button.disabled = false
	else:
		name_warning.visible = true
		create_button.disabled = true

## Game Creation ##

const world_map = preload("res://GameMap/game_map.tscn")

func _on_create_button_pressed():
	var name_entry = newC.get_node("name_entry")
	GameHandler.SAVE_FILE_NAME = name_entry.text + ".save"
	GameHandler.save_data(GameHandler.SAVE_DIR + GameHandler.SAVE_FILE_NAME)
	load_map()

func load_map():
	get_tree().change_scene_to_packed(world_map)
