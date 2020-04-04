extends RigidBody2D

onready var shape = get_node("Shape")
onready var sprite0 = get_node("Sprite")
onready var body1 = get_node("Body 1")
onready var body2 = get_node("Body 2")
onready var sprite1 =  get_node("Body 1/Sprite")
onready var sprite2 = body2.get_node("Sprite")

var cuting = false

signal score
signal life

func _ready():
	randomize()
	set_process(true)
	
func _process(delta):
	if get_pos().y > 800:
		emit_signal("life")
		queue_free()
	
	if body1.get_pos().y > 800 and body2.get_pos().y > 800:
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
	emit_signal("score")
	
	set_mode(MODE_KINEMATIC)
	sprite0.queue_free()
	shape.queue_free()
	
	body1.set_mode(MODE_RIGID)
	body1.apply_impulse(Vector2(0, 0), Vector2(-100, 0).rotated(get_rot()))
	body1.set_angular_velocity(get_angular_velocity())
	body2.set_mode(MODE_RIGID)
	body2.apply_impulse(Vector2(0, 0), Vector2(100, 0).rotated(get_rot()))
	body2.set_angular_velocity(get_angular_velocity())