extends Node2D

onready var marker = get_node("Marker")

var loading = 1

signal lose

func _ready():
	set_process(true)
	
func _process(delta):
	if loading > 0:
		loading -= 0.1*delta
		marker.set_region_rect(Rect2(0, 0, loading*188, 23))
		marker.set_pos(Vector2(-(1 - loading)*188/2, 0))
	else:
		emit_signal("lose")
		
func add(delta):
	loading += delta
	if loading > 1:
		loading = 1
