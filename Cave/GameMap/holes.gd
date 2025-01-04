extends "res://GameMap/interaction_object.gd"

@onready var bat = preload("res://Animals/bat_base.tscn")
@onready var spider = preload("res://Animals/spider_base.tscn")
@onready var rat = preload("res://Animals/rat_base.tscn")

@onready var animals = [bat, spider, rat]

func _on_spawn_timer_timeout() -> void:
	if randi_range(1,100) < 20:
		var animal_spawn = animals.pick_random().instantiate()
		get_tree().current_scene.add_child(animal_spawn)
		animal_spawn.global_position = global_position
