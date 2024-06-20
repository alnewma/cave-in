extends Node2D

@export var pos1 : Marker2D
@export var pos2 : Marker2D
@export var pos3 : Marker2D
@export var pos4 : Marker2D

var s1_triggered = false
var s2_triggered = false
var s3_triggered = false
var s4_triggered = false

func _on_spawn_1_body_entered(_body):
	if not s1_triggered:
		s1_triggered = true
		GameHandler.spawn_enemy(GameHandler.enemies.DOG,pos1.global_position)
		GameHandler.spawn_enemy(GameHandler.enemies.RAT,pos1.global_position)

func _on_spawn_2_body_entered(_body):
	if not s2_triggered:
		s2_triggered = true
		GameHandler.spawn_enemy(GameHandler.enemies.DOG,pos2.global_position)

func _on_spawn_3_body_entered(_body):
	if not s3_triggered:
		s3_triggered = true
		GameHandler.spawn_enemy(GameHandler.enemies.SPIDER,pos3.global_position)
		GameHandler.spawn_enemy(GameHandler.enemies.SPIDER,pos3.global_position)
		GameHandler.spawn_enemy(GameHandler.enemies.SPIDER,pos3.global_position)

func _on_spawn_4_body_entered(_body):
	if not s4_triggered:
		s4_triggered = true
		GameHandler.spawn_enemy(GameHandler.enemies.RAT,pos4.global_position)
		GameHandler.spawn_enemy(GameHandler.enemies.RAT,pos4.global_position)
		GameHandler.spawn_enemy(GameHandler.enemies.RAT,pos3.global_position)
		GameHandler.spawn_enemy(GameHandler.enemies.DOG,pos4.global_position)
