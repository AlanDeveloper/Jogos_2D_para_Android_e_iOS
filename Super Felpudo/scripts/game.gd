extends Node

var coins = 0
var lifes = 3

onready var character = get_node("Character")
onready var camDeath = get_node("Death")

func _ready():
	pass

func change_camera():
	camDeath.set_global_pos(character.get_node("Camera2D").get_camera_pos())
	camDeath.make_current()

func _on_Character_dead():
	lifes -= 1
	change_camera()
	
	get_node("Spawn_Timer").set_wait_time(1.5)
	get_node("Spawn_Timer").start()
	
	if lifes == 2:
		get_node("CanvasLayer/Panel/TextureFrame").set_texture(load("res://assets/hud_heartEmpty.png"))
	elif lifes == 1:
		get_node("CanvasLayer/Panel/TextureFrame1").set_texture(load("res://assets/hud_heartEmpty.png"))
	elif lifes == 0:
		get_node("CanvasLayer/Panel/TextureFrame2").set_texture(load("res://assets/hud_heartEmpty.png"))
func _on_Spawn_Timer_timeout():
	if lifes > 0:
		spawn()
	else:
		Transition.fade_to("res://scenes/Menu.tscn")

func spawn():
	character.set_pos(get_node("Spawn_Point").get_pos())
	character.spawn()

func _on_Character_end():
	change_camera()
	
	get_node("Spawn_Timer").set_wait_time(3)
	get_node("Spawn_Timer").start()

func _on_Character_coin():
	coins += 1
	get_node("CanvasLayer/Panel/Label").set_text(str(coins))

func _on_Game_Timer_timeout():
	var timer = get_node("CanvasLayer/Panel/Label 2")
	timer.set_text(
		str(
			int(timer.get_text()) - 1
		)
	)
	if int(timer.get_text()) == 0:
		get_node("Game_Timer").stop()
		character.dead()
