extends Control

func _ready():
	set_text()

func set_text(usage_verb = "Use"):
	var aList = InputMap.action_get_events("interact")[0].as_text()
	if "(Physical)" in aList:
		aList = aList.replace("(Physical)","")
	$TextureRect/Label.text = "Press " + str(aList) + "to " + usage_verb
