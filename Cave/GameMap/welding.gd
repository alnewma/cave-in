extends "res://GameMap/interaction_object.gd"

@onready var boxSprite = $"../../InsideFurniture/Box"

func completion_routine():
	boxSprite.frame = 1
	var smoke_instance1 = smoke.instantiate()
	smoke_instance1.global_position = $Marker2D.global_position
	smoke_instance1.wait_duration = 0
	var smoke_instance2 = smoke.instantiate()
	smoke_instance2.global_position = $Marker2D2.global_position
	smoke_instance2.wait_duration = 0
	get_tree().current_scene.add_child(smoke_instance1)
	get_tree().current_scene.add_child(smoke_instance2)
	AudioManager.play_effect(AudioManager.effects.CRATEBREAK,0,0,0,boxSprite.global_position)
