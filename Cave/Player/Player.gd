extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta):
	movement(delta)


func movement(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity += Vector2(0,1)
	if Input.is_action_pressed("move_left"):
		velocity += Vector2(-1,0)
	if Input.is_action_pressed("move_right"):
		velocity += Vector2(1,0)
	if Input.is_action_pressed("move_up"):
		velocity += Vector2(0,-1)
	if velocity != Vector2.ZERO:
		velocity = SPEED * velocity.normalized()

	move_and_slide()
