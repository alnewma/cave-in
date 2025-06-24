extends Sprite2D

@export var player_prompt : Control
var player_inside = false
var completed = false

func _ready():
	if GameHandler.events.GENERATOR in GameHandler.save_game_instance.events_completed:
		_completion_process()

func _physics_process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		_completion_process()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not completed:
		player_prompt.visible = true
		player_inside = true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_prompt.visible = false
	player_inside = false

@onready var genRun = $generatorRunning
func _completion_process():
	completed = true
	player_prompt.visible = false
	player_inside = false
	if not GameHandler.events.GENERATOR in GameHandler.save_game_instance.events_completed:
		GameHandler.save_game_instance.events_completed.append(GameHandler.events.GENERATOR)
	genRun.show()
	genRun.play("default")
	$generator_audio.play()

@onready var drill_t = $drill_audio_timer
func _on_drill_audio_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if completed and player.global_position.y < -111: # player's inside
		AudioManager.play_effect(AudioManager.effects.DRILL)
		await get_tree().create_timer(4).timeout
		player.get_node("Camera2D").add_trauma(.35)
		AudioManager.play_effect(AudioManager.effects.DRILLROCKS)
		for surv in get_tree().get_nodes_in_group("survivor"):
			if surv.global_position.y < -111:
				if randi()%3==0:
					surv.queue_remark(surv.remark_prompts.DRILLINSIDE)
	drill_t.start(randi_range(10,25))
	
