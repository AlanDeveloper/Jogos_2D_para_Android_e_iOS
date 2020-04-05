extends Node2D

var velocity = 0
var acceleration = -2

var block = false

signal speed(valor)
signal limit
signal stoped

func _ready():
	set_process(true)

func _process(delta):
	if velocity > 1:
		velocity += acceleration * delta
	else:
		velocity = 0
		acceleration = -2
		if block:
			emit_signal("stoped")
	
	var body = get_node("Body")
	body.set_rot(body.get_rot() + delta*velocity)
	emit_signal("speed", velocity/50)

func _on_Area2D_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and not block:
		velocity += 5
		
		if velocity > 50:
			velocity = 50
			emit_signal("limit")
			
func _on_BtnBlack_pressed():
	get_node("Body/Sprite").set_texture(load("res://assets/black_ready.png"))

func _on_BtnRed_pressed():
	get_node("Body/Sprite").set_texture(load("res://assets/red_ready.png"))

func _on_BtnYellow_pressed():
	get_node("Body/Sprite").set_texture(load("res://assets/yellow_ready.png"))

func _on_Game_block():
	block = true
	acceleration = -10

func _on_Game_unblock():
	block = false
