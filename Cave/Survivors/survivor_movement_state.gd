class_name SurvivorMovementState
extends State

@export var actor: Survivor
@export var animator: AnimatedSprite2D

signal actor_reached_target

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta):
	var target_reached = actor.approach_target()
	emit_signal("actor_reached_target")
	if target_reached and actor.assigned_location != Vector2.ZERO and not actor.status_break and get_parent().state != get_parent().activity:
		get_parent().change_state(get_parent().activity)
		if actor.target_assignment:
			if not get_node(actor.target_assignment).assigned_survivors.has(actor):
				get_node(actor.target_assignment).assigned_survivors.append(actor)
