extends KinematicBody2D

var direction = -1

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta * direction * 0.3
	
	if direction == 1 and new_offset >= 0.99999:
		direction = -1
		get_parent().set_unit_offset(0.9999)
	elif direction == -1 and new_offset <= 0:
		direction = 1
		get_parent().set_unit_offset(0)
	else:
		get_parent().set_unit_offset(new_offset)