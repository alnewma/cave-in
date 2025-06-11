extends Node2D

@onready var interaction_menu = $interaction_UI_handler
@onready var flag_creation_menu = $map_menu/establish_location
@onready var flag_edit_menu = $map_menu/edit_location
@onready var location_flag = preload("res://GameMap/location_flag.tscn")

@export var cutscene_disabled = false

var spectator_mode = true

func _ready():
	AudioManager.stop_audio()
	setup_map()
	if not cutscene_disabled and GameHandler.save_game_instance.player_data.game_flags["new_game"]:
		GameHandler.save_game_instance.player_data.game_flags["new_game"] = false
		cutscene()
	else:
		AudioManager.play_effect(AudioManager.effects.WIND,true,.5)
		cutscene_finished(1)

func _on_child_entered_tree(node):
	if node.is_in_group("survivor"):
		node.survivor_clicked.connect(create_interaction_menu)
		node.survivor_mouse_entered.connect(survivor_mouse_entered)
		node.survivor_mouse_exited.connect(survivor_mouse_exited)
	elif node.is_in_group("location_flag"):
		node.flag_clicked.connect(create_removal_menu)
		node.flag_mouse_entered.connect(flag_mouse_entered)
		node.flag_mouse_exited.connect(flag_mouse_exited)

var survivors_within_mouse = []
func survivor_mouse_entered(survivor):
	survivors_within_mouse.append(survivor)
func survivor_mouse_exited(survivor):
	survivors_within_mouse.erase(survivor)

var flags_within_mouse = []
func flag_mouse_entered(flag):
	flags_within_mouse.append(flag)
func flag_mouse_exited(flag):
	flags_within_mouse.erase(flag)

func create_interaction_menu(survivor):
	if not spectator_mode:
		interaction_menu.current_survivor = survivor
		interaction_menu.change_page(interaction_menu.start_page,true)
func create_removal_menu(flag):
	if not spectator_mode:
		flag_edit_menu.removal_process(flag)

func _unhandled_input(event):
	if not spectator_mode and GameHandler.prompts_hovered.size() == 0:
		if event.is_action_pressed("object_select") and survivors_within_mouse.size() == 0 and flags_within_mouse.size() == 0 and not flag_creation_menu.visible:
			var flag = location_flag.instantiate()
			flag.global_position = NavigationServer2D.map_get_closest_point(get_tree().get_first_node_in_group("navigation_region").get_navigation_map(),get_global_mouse_position())
			flag_creation_menu.creation_process(flag)
			flag.self_modulate.a = .5

## Map Setup ##

func setup_map():
	create_locations()

func create_locations():
	var flag_list = GameHandler.save_game_instance.player_data.map_data.locations
	for location in flag_list:
		var flag = location_flag.instantiate()
		flag.flag_placed = true
		flag.flag_name = location["name"]
		flag.global_position = str_to_var("Vector2" + str(location["position"])) # convert from string to vector2
		add_child(flag)

@onready var cutcam = $cutscene_camera
@onready var playercam = $Player.get_node("Camera2D")
@onready var side_rocks = $SideRockLayer
@onready var black_canvas = $CanvasModulate
@onready var news_text = $player_ui/news_margin
@onready var intro_logos = preload("res://UI/cutscene_start.tscn")
func cutscene():
	black_canvas.show()
	side_rocks.scroll_scale = Vector2(1,1)
	playercam.enabled = false
	playerlight.hide()
	#var intro_instance = intro_logos.instantiate()
	#get_tree().current_scene.add_child(intro_instance)
	#await intro_instance.get_node("AnimationPlayer").animation_finished
	#print("cutscene ended")
	#intro_instance.queue_free()
	news_text.start_displaying()
	var tween = get_tree().create_tween()
	tween.connect("step_finished",cutscene_finished)
	tween.tween_property(cutcam,"global_position",Vector2(122,104),12)
	tween.tween_property(cutcam,"global_position",$Player.global_position,8)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.parallel().tween_property(cutcam,"zoom",Vector2(4,4),8)
	tween.parallel().tween_property(cutcam.get_node("PointLight2D"),"color:a",.576,2)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.parallel().tween_property(news_text,"modulate:a",0,2)
	#tween.parallel().tween_property(side_rocks,"scroll_scale",Vector2(1.1,1.1),2)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(cutcam.get_node("PointLight2D"),"texture_scale",1,8)

func cutscene_finished(index):
	match index:
		0:
			AudioManager.play_effect(AudioManager.effects.WIND,true,.5)
		1:
			black_canvas.show()
			playercam.enabled = true
			cutcam.enabled = false
			cutcam.hide()
			playerlight.show()
			side_rocks.scroll_scale = Vector2(1.1,1.1)
			spectator_mode = false

# Game Ending Effect #
enum ending_types {SURVIVORS_DEAD, PLAYER_DEAD}
@onready var playerlight = $Player.get_node("light")
@onready var ending_text = $player_ui/ending_holder

func trigger_ending(ending_type : ending_types):
	spectator_mode = true
	match ending_type:
		ending_types.SURVIVORS_DEAD:
			var tween = get_tree().create_tween()
			tween.tween_property(playerlight,"texture_scale",.3,5)
			ending_text.add_text("Everyone else died.")
			ending_text.add_text("All on your own, you aren't able to escape before starvation sets in.",true)
		ending_types.PLAYER_DEAD:
			var tween = get_tree().create_tween()
			tween.tween_property(playerlight,"texture_scale",.3,5)
			ending_text.add_text("You died.")
			ending_text.add_text("Without your leadership, no one escapes the cave before starvation.",true)
