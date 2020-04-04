extends Node2D

onready var idle = get_node("Idle")
onready var hit = get_node("Hit")
onready var grave = get_node("Grave")
onready var anim = get_node("AnimationPlayer")

var direction

const leftValue = -1
const rightValue = 1

func _ready():
	pass

func left():
	set_pos(Vector2(220, 1070))
	idle.set_flip_h(false)
	hit.set_flip_h(false)
	
	grave.set_pos(Vector2(-44, 41))
	grave.set_flip_h(true)
	
	direction = leftValue

func right():
	set_pos(Vector2(500, 1070))
	idle.set_flip_h(true)
	hit.set_flip_h(true)
	
	grave.set_pos(Vector2(28, 41))
	grave.set_flip_h(false)
	
	direction = rightValue
	
func hit():
	anim.play("AnimationHit")
	
func dead():
	anim.stop()
	idle.hide()
	hit.hide()
	grave.show()