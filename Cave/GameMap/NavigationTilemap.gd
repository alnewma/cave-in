extends TileMap

func _ready():
	var tilemap1 = get_parent().get_node("SewerArea")
	var tilemap2 = get_parent().get_node("CaveArea")
	var tilemap3 = get_parent().get_node("Ground")
	var maps = [tilemap1,tilemap2,tilemap3]
	print(NavigationServer2D.get_maps())
	for map in maps:
		set_navigation_map(0,map.get_navigation_map(0))
