extends Node2D

onready var fruits = get_node("Fruits")

var orange = preload("res://scenes/orange.tscn")
var tomato = preload("res://scenes/tomato.tscn")
var pear = preload("res://scenes/pear.tscn")
var bomb = preload("res://scenes/bomb.tscn")

var score = 0
var lifes = 3

func _ready():
	randomize()

func _on_Generator_timeout():
	if lifes <= 0: 
		return
	for i in range(0, rand_range(1, 4)):
		var type = int(rand_range(0, 4))
		var obj
		
		if type == 0:
			obj = orange.instance()
		elif type == 1:
			obj = tomato.instance()
		elif type == 2:
			obj = pear.instance()
		elif type == 3:
			obj = bomb.instance()
		obj.born(Vector2(rand_range(200, 1080), 800))
		
		obj.connect("life", self, "dec_life")
		if type != 4:
			obj.connect("score", self, "inc_score")
		
		fruits.add_child(obj)

func dec_life():
	lifes -= 1
	if lifes == 0:
		get_node("GameOver").start()
		get_node("Input").gameover = true
		get_node("Control/TextureFrame 4").set_modulate(Color(1, 0, 0))
	if lifes == 1:
		get_node("Control/TextureFrame 3").set_modulate(Color(1, 0, 0))
	if lifes == 2:
		get_node("Control/TextureFrame 2").set_modulate(Color(1, 0, 0))
		
func inc_score():
	if lifes == 0:
		return
	score += 1
	get_node("Control/Label").set_text(str(score))