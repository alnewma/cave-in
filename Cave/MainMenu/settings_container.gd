extends CenterContainer

@onready var music_slider = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/musicSlider
@onready var sfx_slider = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/sfxSlider

@onready var screen_shake_button = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/shakeContainer/shakeButton

@onready var window_button = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/windowContainer/windowButton
@onready var resolution_button = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/resolutionContainer/resolutionButton
@onready var brightness_slider = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/brightnessSlider

func _ready():
	var audio_settings = ConfigFileHandler.load_audio_settings()
	music_slider.value = min(audio_settings.music_volume,1.0) * 100
	_enact_music_value(audio_settings.music_volume)
	sfx_slider.value = min(audio_settings.sfx_volume,1.0) * 100
	_enact_sfx_value(audio_settings.sfx_volume)
	
	var visual_effects_settings = ConfigFileHandler.load_visual_effects_settings()
	screen_shake_button.button_pressed = visual_effects_settings.screen_shake
	_enact_shake_value(visual_effects_settings.screen_shake)
	
	var display_settings = ConfigFileHandler.load_display_settings()
	window_button.selected = display_settings.window
	_enact_window_value(display_settings.window)
	brightness_slider.value = min(display_settings.brightness,1.0) * 100
	_enact_brightness_value(display_settings.brightness)
	
	_load_controls_from_settings()
	_create_controls_list()

func _load_controls_from_settings():
	var keybindings = ConfigFileHandler.load_controls()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action,keybindings[action])

var input_actions = {
	"move_up" : "Move Up",
	"move_left" : "Move Left",
	"move_down" : "Move Down",
	"move_right" : "Move Right",
	"interact" : "Interact",
	"object_select" : "Select Object",
	"attack" : "Attack",
}

@onready var control_button_scene = preload("res://UI/control_button.tscn")
@onready var action_holder = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/controlsVBox
var is_remapping = false
var action_to_remap = null
var remapping_button = null

func _create_controls_list():
	for item in action_holder.get_children():
		item.queue_free()
	for action in input_actions:
		var button = control_button_scene.instantiate()
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("ControlLabel")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_holder.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button,action))

func _on_input_button_pressed(button,action):
	if not is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("ControlLabel").text = "Press key to bind..."

func _input(event: InputEvent) -> void:
	if is_remapping:
		if event is InputEventKey or (event is InputEventMouseButton and event.pressed):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap,event)
			ConfigFileHandler.save_controls(action_to_remap,event)
			_update_action_list(remapping_button,event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(button,event):
	button.find_child("ControlLabel").text = event.as_text().trim_suffix(" (Physical)")
	

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("music_volume",music_slider.value / 100)
		_enact_music_value(music_slider.value / 100)
func _enact_music_value(value):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music_Bus"), value)

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_settings("sfx_volume",sfx_slider.value / 100)
		_enact_sfx_value(sfx_slider.value / 100)
func _enact_sfx_value(value):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX_Bus"), value)

func _on_shake_button_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_visual_effects_settings("screen_shake",toggled_on)
	_enact_shake_value(toggled_on)
func _enact_shake_value(value):
	GameHandler.screen_shake_enabled = value

func _on_window_button_item_selected(index: int) -> void:
	ConfigFileHandler.save_display_settings("window",index)
	_enact_window_value(index)
@onready var window_title = $settingsRect/ScrollContainer/CenterContainer/VBoxContainer/windowContainer/windowSubTitle
func _enact_window_value(value):
	match value:
		0: # fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1: # window borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
		2: # window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
	await get_tree().process_frame
	window_title.custom_minimum_size.x = window_button.size.x

func _on_resolution_button_item_selected(_index: int) -> void: # removed
	pass # Replace with function body.

func _on_brightness_slider_drag_ended(value_changed: bool) -> void: # removed
	if value_changed:
		ConfigFileHandler.save_display_settings("brightness",brightness_slider.value / 100)
func _enact_brightness_value(_value):
	pass

func _on_control_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_controls(action,events[0])
	_create_controls_list()

func _on_visibility_changed() -> void:
	await get_tree().process_frame
	window_title.custom_minimum_size.x = window_button.size.x
