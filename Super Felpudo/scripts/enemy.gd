extends KinematicBody2D

var direction = -1
var life = true

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta * direction * 0.3
	
	if direction == 1 and new_offset >= 0.99999:
		direction = -1
		get_parent().set_unit_offset(0.9999)
		get_node("Sprite").set_flip_h(true)
	elif direction == -1 and new_offset <= 0:
		direction = 1
		get_parent().set_unit_offset(0)
		get_node("Sprite").set_flip_h(false)
	else:
		get_parent().set_unit_offset(new_offset)

func smash():
	if not life:
		return
	life = false
	get_node("AnimationPlayer").stop()
	get_node("Sprite").set_texture(load("res://assets/Inimigo/slimeDead.png"))
	get_node("Sprite").set_offset(Vector2(0, 8))
	get_node("CollisionShape2D").queue_free()
	set_fixed_process(false)