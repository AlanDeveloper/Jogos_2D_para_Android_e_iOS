extends RigidBody2D

onready var shape = get_node("Shape")
onready var sprite = get_node("Sprite")
onready var animation = get_node("AnimationPlayer")

signal life

var cuting = false

func _ready():
	set_process(true)
	randomize()
	
func _process(delta):
	if get_pos().y > 800:
		queue_free()
	
func born(pos):
	set_pos(pos)
	var vel = Vector2(0, rand_range(-1000, -800))
	
	if pos.x < 640:
		vel = vel.rotated(deg2rad(rand_range(0, -30)))
	else:
		vel = vel.rotated(deg2rad(rand_range(0, 30)))
		
	set_linear_velocity(vel)
	set_angular_velocity(rand_range(-10, 10))

func cut():
	if cuting:
		return
	cuting = true
	emit_signal("life")
	set_mode(MODE_KINEMATIC)
	animation.play("Explode")
