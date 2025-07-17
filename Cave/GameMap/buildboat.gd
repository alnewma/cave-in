extends "res://GameMap/interaction_object.gd"

@onready var boat_obstacle = $"../../NavigationNodes/NavigationRegion2D/NavigationObstacle2D"

func completion_routine():
	boat_obstacle.affect_navigation_mesh = true # rebake nav region to avoid boat
	boat_obstacle.carve_navigation_mesh = false # removed because it was too close to boat
	boat_obstacle.get_parent().bake_navigation_polygon()
	var player = get_tree().get_first_node_in_group("player")
	var boat_polygon = $boatSprite/boatPolygon
	if Geometry2D.is_point_in_polygon(player.global_position-boat_polygon.global_position,boat_polygon.polygon):
		_move_people_out_of_way(player)
	for surv in get_tree().get_nodes_in_group("survivor"):
		if Geometry2D.is_point_in_polygon(surv.global_position-boat_polygon.global_position,boat_polygon.polygon):
			_move_people_out_of_way(surv)
	$boatSprite.visible = true

func _move_people_out_of_way(object):
	if object.global_position.x > 853:
		object.global_position.x = 871
	elif object.global_position.y < 333:
		object.global_position.y = 309
	else:
		object.global_position = Vector2(842,352)
