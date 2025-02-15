class_name SurvivorDeathState
extends State

@export var actor: Survivor

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	survivor_death()

func _exit_state() -> void:
	set_physics_process(false)

var died = false
signal death
func survivor_death():
	if not died:
		died = true
		emit_signal("death")
		actor.animator.play("death")
		actor.set_collision_layer_value(3,false)
