extends Control

@onready var tree_holder = $TextureRect/ScrollContainer
@onready var update_holder = get_parent().get_node("update_holder")

var ida00 = preload("res://Resources/dialogue_trees/ida_00.tscn")
var ida0 = preload("res://Resources/dialogue_trees/ida_0.tscn")
var ida1 = preload("res://Resources/dialogue_trees/ida_1.tscn")
var ida2 = preload("res://Resources/dialogue_trees/ida_2.tscn")
var ida3 = preload("res://Resources/dialogue_trees/ida_3.tscn")
var mace00 = preload("res://Resources/dialogue_trees/mace_00.tscn")
var mace0 = preload("res://Resources/dialogue_trees/mace_0.tscn")
var mace1 = preload("res://Resources/dialogue_trees/mace_1.tscn")
var mace2 = preload("res://Resources/dialogue_trees/mace_2.tscn")
var mace3 = preload("res://Resources/dialogue_trees/mace_3.tscn")
var wesley00 = preload("res://Resources/dialogue_trees/wesley_00.tscn")
var wesley0 = preload("res://Resources/dialogue_trees/wesley_0.tscn")
var wesley1 = preload("res://Resources/dialogue_trees/wesley_1.tscn")
var wesley2 = preload("res://Resources/dialogue_trees/wesley_2.tscn")
var wesley3 = preload("res://Resources/dialogue_trees/wesley_3.tscn")
var kate00 = preload("res://Resources/dialogue_trees/kate_00.tscn")
var kate0 = preload("res://Resources/dialogue_trees/kate_0.tscn")
var kate1 = preload("res://Resources/dialogue_trees/kate_1.tscn")
var kate2 = preload("res://Resources/dialogue_trees/kate_2.tscn")
var kate3 = preload("res://Resources/dialogue_trees/kate_3.tscn")

@onready var ui_label = preload("res://UI/ui_label.tscn")

var survivors_talked_to_during_end = []

func _on_visibility_changed() -> void:
	if visible:
		if get_parent().current_survivor:
			show_clean_update_holder()
			for child in tree_holder.get_children(): # clear any old conversations
				child.queue_free()
			var ida_pts = GameHandler.player_data.survivor_data.ida.conversation_point
			var mace_pts = GameHandler.player_data.survivor_data.mace.conversation_point
			var wesley_pts = GameHandler.player_data.survivor_data.wesley.conversation_point
			var kate_pts = GameHandler.player_data.survivor_data.kate.conversation_point
			var total_convo_points = ida_pts + mace_pts + wesley_pts + kate_pts
			match get_parent().current_survivor.survivor_type:
				0: # Kate
					if get_parent().tunnel_scene:
						if get_parent().reached_tunnel_end:
							if not "Kate" in survivors_talked_to_during_end: # tunnel scene
								tree_holder.add_child(kate0.instantiate())
								survivors_talked_to_during_end.append("Kate")
							else:
								tree_holder.add_child(kate00.instantiate())
					elif total_convo_points >= 0 and kate_pts == 0:
						tree_holder.add_child(kate1.instantiate())
					elif total_convo_points >= 2 and kate_pts == 1:
						tree_holder.add_child(kate2.instantiate())
					elif total_convo_points >= 4 and kate_pts == 2:
						tree_holder.add_child(kate3.instantiate())
					else: # not ready to talk
						var holder = ui_label.instantiate()
						tree_holder.add_child(holder)
						if GameHandler.player_data.survivor_data.kate.conversation_happiness < 0: # unhappy
							holder.text = "Kate: " + kate_busy_unhappy.pick_random()
						else:
							holder.text = "Kate: " + kate_busy_neutral.pick_random()
				1: # None
					pass
				2: # Mace
					if get_parent().tunnel_scene:
						if get_parent().reached_tunnel_end:
							if not "Mace" in survivors_talked_to_during_end: # tunnel scene
								tree_holder.add_child(mace0.instantiate())
								survivors_talked_to_during_end.append("Mace")
							else:
								tree_holder.add_child(mace00.instantiate())
					elif total_convo_points >= 0 and mace_pts == 0:
						tree_holder.add_child(mace1.instantiate())
					elif total_convo_points >= 2 and mace_pts == 1:
						tree_holder.add_child(mace2.instantiate())
					elif total_convo_points >= 4 and mace_pts == 2:
						tree_holder.add_child(mace3.instantiate())
					else: # not ready to talk
						var holder = ui_label.instantiate()
						tree_holder.add_child(holder)
						if GameHandler.player_data.survivor_data.mace.conversation_happiness < 0: # unhappy
							holder.text = "Mace: " + mace_busy_unhappy.pick_random()
						else:
							holder.text = "Mace: " + mace_busy_neutral.pick_random()
				3: # Ida
					if get_parent().tunnel_scene:
						if get_parent().reached_tunnel_end:
							if not "Ida" in survivors_talked_to_during_end: # tunnel scene
								tree_holder.add_child(ida0.instantiate())
								survivors_talked_to_during_end.append("Ida")
							else:
								tree_holder.add_child(ida00.instantiate())
					elif total_convo_points >= 0 and ida_pts == 0:
						tree_holder.add_child(ida1.instantiate())
					elif total_convo_points >= 2 and ida_pts == 1:
						tree_holder.add_child(ida2.instantiate())
					elif total_convo_points >= 4 and ida_pts == 2:
						tree_holder.add_child(ida3.instantiate())
					else: # not ready to talk
						var holder = ui_label.instantiate()
						tree_holder.add_child(holder)
						if GameHandler.player_data.survivor_data.ida.conversation_happiness < 0: # unhappy
							holder.text = "Ida: " + ida_busy_unhappy.pick_random()
						else:
							holder.text = "Ida: " + ida_busy_neutral.pick_random()
				4: # Wesley
					if get_parent().tunnel_scene:
						if get_parent().reached_tunnel_end:
							if not "Wesley" in survivors_talked_to_during_end: # tunnel scene
								tree_holder.add_child(wesley0.instantiate())
								survivors_talked_to_during_end.append("Wesley")
							else:
								tree_holder.add_child(wesley00.instantiate())
					elif total_convo_points >= 0 and wesley_pts == 0:
						tree_holder.add_child(wesley1.instantiate())
					elif total_convo_points >= 2 and wesley_pts == 1:
						tree_holder.add_child(wesley2.instantiate())
					elif total_convo_points >= 4 and wesley_pts == 2:
						tree_holder.add_child(wesley3.instantiate())
					else: # not ready to talk
						var holder = ui_label.instantiate()
						tree_holder.add_child(holder)
						if GameHandler.player_data.survivor_data.wesley.conversation_happiness < 0: # unhappy
							holder.text = "Wesley: " + wesley_busy_unhappy.pick_random()
						else:
							holder.text = "Wesley: " + wesley_busy_neutral.pick_random()
	elif update_holder: # if not visible
		update_holder.hide()

@onready var scroll_container = $TextureRect/ScrollContainer
func scroll_to_bottom() -> void:
	if scroll_container:
		pass
		#print("moving")
		#var max_scroll = scroll_container.get_v_scroll_bar().max_value
		#scroll_container.scroll_vertical = max_scroll

func show_clean_update_holder():
	if update_holder:
		for child in update_holder.get_children():
			child.queue_free()
		update_holder.show()

var ida_busy_neutral = ["Not now hun, I’m a little busy.",
"I don’t have it in me to chat right now. I can’t just jump around with what I’m doing like that. Guess I’ve got a one-track mind.",
"I’ll talk to ya in a bit if that’s alright.",
"I’m taking a little pause for fellowship, but I’ll be with you in a jiffy!"]
var ida_busy_unhappy = ["I’m not really in the mood to talk.",
"I think we have better things to be doing than just chatting away right now."]
var mace_busy_neutral = ["I’m trying to contribute to the escape a little more - I think that means less talking for now.",
"I don’t feel like talking. Sometimes I just want to get lost in my thoughts.",
"I’ve spent my whole life talking to people. Normally not happy people either. Maybe I’ll just spend my final moments to myself.",
"Hey. I’m working on something right now, but maybe we can chat later?"]
var mace_busy_unhappy = ["I’m not sure I want to speak to you right now.",
"No. Just no."]
var wesley_busy_neutral = ["Time is a resource, just like water and meals. We have to ration it out just the same. What I’m saying is, let’s save the talking for later.",
"Listen, you don’t need to entertain me. Maybe save the conversations for someone who needs the camaraderie.",
"I enjoyed our conversation but now we need to work.",
"Unless it’s a matter of life or death, let’s focus on the more important matters at hand."]
var wesley_busy_unhappy = ["Maybe keep this one to yourself.",
"You need to figure out when it’s time for work and when it’s time for play."]
var kate_busy_neutral = ["I don’t wanna talk right now.",
"Wesley said to tell you to get back to work if you tried talking to me.",
"I’m nervous and scared! What if the tunnel falls down again? Or an army of dogs comes out of the dark! I hear them barking all the time… We can’t just stand here. We need to get out! Please!",
"Can we talk another time? I just want some quiet for a while."]
var kate_busy_unhappy = ["Can you just - do something? Talking to you isn’t helping.",
"Go talk to someone else. I’m doing important stuff."]
