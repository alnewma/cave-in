extends Area2D

var overlapping_soft_collision_bodies = []
var colliding = false

var lastPushVector = Vector2.ZERO

func get_soft_collisions_push_vector(_delta) -> Vector2:
	if overlapping_soft_collision_bodies.size() > 1:
		var push_vector = overlapping_soft_collision_bodies[1].global_position.direction_to(global_position)
		push_vector = push_vector.normalized()*pow((20/global_position.distance_squared_to(overlapping_soft_collision_bodies[1].global_position)),2)
		#return clamp(push_vector,Vector2(-10,-10),Vector2(10,10))
		lastPushVector = clamp(push_vector,Vector2(-1,-1),Vector2(1,1))*30
		return lastPushVector
	else:
		return Vector2.ZERO #lerp(lastPushVector,Vector2.ZERO,delta*100)

func _on_body_entered(body: Node2D) -> void:
	if not overlapping_soft_collision_bodies.has(body):
		overlapping_soft_collision_bodies.append(body)
		if overlapping_soft_collision_bodies.size() > 1:
			colliding = true

func _on_body_exited(body: Node2D) -> void:
	overlapping_soft_collision_bodies.erase(body)
	if overlapping_soft_collision_bodies.size() == 1:
		colliding = false
