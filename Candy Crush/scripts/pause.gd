extends Node2D

func _on_Return_pressed():
	get_node("AnimationPlayer").play("Hide")
	yield(get_node("AnimationPlayer"), "finished")
	
	Transition.clear_above()

func _on_Home_pressed():
	get_node("AnimationPlayer").play("Hide")
	yield(get_node("AnimationPlayer"), "finished")
	
	Transition.fade_to("res://scenes/MainScreen.tscn")
	Transition.clear_above()

func _on_Replay_pressed():
	get_node("AnimationPlayer").play("Hide")
	yield(get_node("AnimationPlayer"), "finished")
	
	Transition.fade_to("res://scenes/LevelScreen.tscn")
	Transition.clear_above()
