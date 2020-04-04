extends Node

var barrel = preload("res://scenes/Barrel.tscn")
var barrelRight = preload("res://scenes/BarrelRight.tscn")
var barrelLeft = preload("res://scenes/BarrelLeft.tscn")

var lastenemy

onready var felpudo = get_node("Felpudo")
onready var camera = get_node("Camera2D")
onready var barrels = get_node("Barrels")
onready var barrelsDestruction = get_node("BarrelsDestruction")
onready var bar = get_node("Bar")
onready var labelpoints = get_node("Control/Points")

var points = 0
var state = playing

const playing = 1
const losing = 2

func _ready():
	randomize()
	set_process_input(true)
	
	begin()
	
	bar.connect("lose", self, "lose")
	
func _input(event):
	event = camera.make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and state == playing:
		
		if event.pos.x < 360:
			felpudo.left()
		else:
			felpudo.right()
			
		if !attack():
			felpudo.hit()
			var first = barrels.get_children()[0]
			barrels.remove_child(first)
			barrelsDestruction.add_child(first)
			first.destruction(felpudo.direction)
			
			randomBarrels(Vector2(360, 1090 - 10*172))
			down()
			
			bar.add(0.014)
			
			points += 1
			labelpoints.set_text(str(points))
			
			if attack():
				lose()
		else:
			lose()
		
func randomBarrels(position):
	var number = rand_range(0, 3)
	if lastenemy:
		number = 0
	makeBarrels(int(number), position)

func makeBarrels(type, position):
	var new
	if type == 0:
		new = barrel.instance()
		lastenemy = false
	elif type == 1:
		new = barrelRight.instance()
		new.add_to_group("right")
		lastenemy = true
	else:
		new = barrelLeft.instance()
		new.add_to_group("left")
		lastenemy = true
		
	new.set_pos(position)
	barrels.add_child(new)

func begin():
	for i in range(0, 3):
		makeBarrels(0, Vector2(360, 1090 - i*172))
	for i in range(3, 10):
		randomBarrels(Vector2(360, 1090 - i*172))
		
func attack():
	var direction = felpudo.direction
	var first = barrels.get_children()[0]
	
	if direction == felpudo.leftValue and first.is_in_group("left") or direction == felpudo.rightValue and first.is_in_group("right"):
		return true
	else:
		return false
		
func down():
	for b in barrels.get_children():
		b.set_pos(b.get_pos() + Vector2(0, 172))

func lose():
	state = losing
	felpudo.dead()
	bar.set_process(false)
	
	get_node("Timer").start()

func _on_Timer_timeout():
	get_tree().reload_current_scene()
