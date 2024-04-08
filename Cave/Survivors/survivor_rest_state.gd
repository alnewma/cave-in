class_name SurvivorRestState
extends State

@export var animator: AnimatedSprite2D
var playing = false

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta):
	if not playing:
		pick_next_animation()

func pick_next_animation():
	playing = true
	#if randi_range(0,3) == 0:
		#animator.stop()
		#animator.play("special")
		#await animator.animation_finished
	animator.play("idle")
	await animator.animation_looped
	playing = false
