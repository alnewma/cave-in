class_name SurvivorActivityState
extends State

@export var actor: Survivor
@export var animator: AnimatedSprite2D
@export var vision_cast: RayCast2D
var picking = false

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)

func _exit_state() -> void:
	set_physics_process(false)
	picking = false

func _physics_process(_delta):
	if not picking:
		pick_next_action()
	actor.approach_target()

func pick_next_action():
	picking = true
	await get_tree().create_timer(randf_range(5,20)).timeout
	if randi_range(0,1) == 0:
		actor.navigation_agent.target_position = actor.get_point_in_target_area()
		#print(actor.name + " is actively wandering to " + str(actor.navigation_agent.target_position))
	picking = false
