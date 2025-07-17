extends Node

var config = ConfigFile.new()

const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready():
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("audio","music_volume",1.0)
		config.set_value("audio","sfx_volume",1.0)
		
		config.set_value("visual_effects","screen_shake",true)
		
		config.set_value("display","window",true)
		config.set_value("display","resolution",true)
		config.set_value("display","brightness",100)
		
		config.set_value("controls","move_right","D")
		config.set_value("controls","move_left","A")
		config.set_value("controls","move_up","W")
		config.set_value("controls","move_down","S")
		config.set_value("controls","interact","E")
		config.set_value("controls","object_select","mouse_1")
		config.set_value("controls","attack","mouse_2")
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
	

func save_audio_settings(key : String, value):
	config.set_value("audio",key,value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_settings():
	var settings = {}
	for key in config.get_section_keys("audio"):
		settings[key] = config.get_value("audio",key)
	return settings

func save_visual_effects_settings(key : String, value):
	config.set_value("visual_effects",key,value)
	config.save(SETTINGS_FILE_PATH)

func load_visual_effects_settings():
	var settings = {}
	for key in config.get_section_keys("visual_effects"):
		settings[key] = config.get_value("visual_effects",key)
	return settings
	
func save_display_settings(key : String, value):
	config.set_value("display",key,value)
	config.save(SETTINGS_FILE_PATH)

func load_display_settings():
	var settings = {}
	for key in config.get_section_keys("display"):
		settings[key] = config.get_value("display",key)
	return settings

func save_controls(action : StringName, event : InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
	
	config.set_value("controls",action,event_str)
	config.save(SETTINGS_FILE_PATH)

func load_controls():
	var keybindings = {}
	var keys = config.get_section_keys("controls")
	for key in keys:
		var input_event
		var event_str = config.get_value("controls",key)
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
		keybindings[key] = input_event
	return keybindings
