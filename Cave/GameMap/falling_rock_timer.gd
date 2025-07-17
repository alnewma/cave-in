extends Timer

@onready var rock = preload("res://GameMap/cave_rock.tscn")

func _ready():
	_reset()

var spawn_count_min = 1
var spawn_count_max = 4

func _reset():
	if get_tree().current_scene.name == "GameMap":
		if get_tree().get_first_node_in_group("boat_sprite").visible:
			start(randi_range(3,8))
			spawn_count_min = 3
			spawn_count_max = 6
		else:
			start(randi_range(10,25))
		var player = get_tree().get_first_node_in_group("player")
		if GameHandler.events.GENERATOR in GameHandler.save_game_instance.events_completed: # gen completed
			if player.global_position.y > -111: # player outside
				player.get_node("Camera2D").add_trauma(.35)
				AudioManager.play_effect(AudioManager.effects.DRILLROCKS)
				await get_tree().create_timer(1).timeout
				if get_tree().current_scene.name == "GameMap":
					for surv in get_tree().get_nodes_in_group("survivor"):
						if surv.global_position.y > -111:
							if randi()%3==0:
								surv.queue_remark(surv.remark_prompts.DRILLOUTSIDE)
					for i in randi_range(spawn_count_min,spawn_count_max):
						var rock_inst = rock.instantiate()
						await get_tree().create_timer(randf_range(.1,.5)).timeout
						rock_inst.global_position = player.global_position + Vector2(randi_range(-100,100),randi_range(-50,50))
						get_tree().current_scene.add_child(rock_inst)
				else:
					print("Not in GameMap, not dropping rocks")
	else:
		print("Not in GameMap, not dropping rocks")

func _on_timeout() -> void:
	_reset()
