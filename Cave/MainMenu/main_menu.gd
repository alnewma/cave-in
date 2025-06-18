extends Node2D

@onready var SaveGameInstance = GameHandler.save_game_instance
func _ready():
	menu_intro_cutscene()
	menu_ready_function()
	container_ready_function()
	#GameHandler.save_ready_function()

## Menu Handler ##

@onready var mainC = $menu_canvas/background/main_container
@onready var newC = $menu_canvas/background/new_container
@onready var loadC = $menu_canvas/background/load_container
@onready var settingsC = $menu_canvas/background/settings_container
@onready var tutorialC = $menu_canvas/tutorialContainer

@onready var load_scroll_container = $menu_canvas/background/load_container/ScrollContainer
@onready var load_button_container = $menu_canvas/background/load_container/ScrollContainer/VBoxContainer

@onready var regex = RegEx.new()
var containers = []

func menu_ready_function():
	containers = [mainC,newC,loadC,settingsC,tutorialC]

func _on_back_pressed():
	switch_container(mainC)

func _on_quit_pressed():
	get_tree().quit()

func switch_container(target_container):
	AudioManager.play_effect(AudioManager.effects.CLICK)
	for container in containers:
		container.visible = false
	target_container.visible = true

## Container Setup ##

const save_button_base = preload("res://MainMenu/save_button_base.tscn")

func container_ready_function():
	#load_scroll_container.get_v_scroll_bar().custom_minimum_size = load_scroll_container.get_v_scroll_bar().size*4
	# main container
	var save_files = DirAccess.get_files_at(SaveGameInstance.SAVE_DIR)
	if save_files.size() == 0:
		mainC.get_node("load_game").disabled = true
	
	# new container
	regex.compile("[a-zA-Z0-9 ]+")
	
	# load container
	for child in load_button_container.get_children():
		child.queue_free()
	for file in save_files:
		var save_button = save_button_base.instantiate()
		save_button.save_file_name = file
		load_button_container.add_child(save_button)
		save_button.connect("pressed",load_button_pressed.bind(save_button))

func _on_new_game_pressed():
	switch_container(newC)
func _on_load_game_pressed():
	switch_container(loadC)

func load_button_pressed(button):
	SaveGameInstance.SAVE_FILE_NAME = button.save_file_name
	SaveGameInstance.load_data()
	load_map()

func _on_tutorial_pressed() -> void:
	switch_container(tutorialC)

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
	for file in DirAccess.get_files_at(SaveGame.SAVE_DIR):
		if file.get_slice(".",0) == new_text:
			name_available = false
	if name_available:
		name_warning.visible = false
		create_button.disabled = false
	else:
		name_warning.visible = true
		create_button.disabled = true

@onready var intro_logos = preload("res://UI/cutscene_start.tscn")
func menu_intro_cutscene():
	AudioManager.stop_all_effects()
	if GameHandler.game_just_opened:
		GameHandler.game_just_opened = false
		var intro_instance = intro_logos.instantiate()
		get_tree().current_scene.add_child(intro_instance)
		intro_instance.connect("start_music",_play_menu_music)
		await intro_instance.get_node("AnimationPlayer").animation_finished
		intro_instance.queue_free()
	else:
		_play_menu_music()

func _play_menu_music():
	AudioManager.play_audio(AudioManager.songs.LULLABY)

## Game Creation ##

const world_map = preload("res://GameMap/game_map.tscn")

func _on_create_button_pressed():
	var name_entry = newC.get_node("name_entry")
	SaveGameInstance.SAVE_FILE_NAME = name_entry.text + ".tres"
	print("name set to: " + name_entry.text + ".tres")
	SaveGameInstance.write_data()
	load_map()

func load_map():
	get_tree().change_scene_to_packed(world_map)

func _on_close_button_pressed() -> void:
	switch_container(mainC)
