extends CharacterBody2D

const SPEED = 300.0
var target_area : NodePath
var state = activities.REST

enum activities {
	REST,
	WALK,
	CUSTOM
}

func _physics_process(_delta):

	match state:
		activities.REST:
			pass
		activities.WALK:
			pass
		activities.CUSTOM:
			pass
	move_and_slide()
