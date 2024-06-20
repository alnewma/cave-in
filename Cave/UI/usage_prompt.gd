extends Control

func _ready():
	var aList = InputMap.action_get_events("interact")[0].as_text()
	if "(Physical)" in aList:
		aList = aList.replace("(Physical)","")
	$TextureRect/Label.text = "Press " + str(aList) + "to Use"
