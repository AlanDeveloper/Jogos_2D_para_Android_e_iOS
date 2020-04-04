extends Node2D

func _ready():
	pass

func destruction(direction):
	if direction == -1:
		get_node("AnimationPlayer").play("right")
	else:
		get_node("AnimationPlayer").play("left")