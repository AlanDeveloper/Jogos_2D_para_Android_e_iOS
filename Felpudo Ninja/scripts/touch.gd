extends Node2D

onready var interval = get_node("Interval")
onready var limit = get_node("Limit")

var pressed = false
var drag = false
var curpos = Vector2(0, 0)
var prepos = Vector2(0, 0)
var gameover = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	
func _fixed_process(delta):
	update()
	if drag and curpos != prepos and prepos != Vector2(0, 0) and not gameover:
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(prepos, curpos)
		
		if not result.empty():
			result.collider.cut()
	
func _input(event):
	event = make_input_local(event)
	if event.type == InputEvent.SCREEN_TOUCH:
		if event.pressed:
			pressed(event.pos)
		else:
			released()
	elif event.type == InputEvent.SCREEN_DRAG:
		drag(event.pos)

func pressed(pos):
	pressed = true
	prepos = pos
	limit.start()
	interval.start()
	
func released():
	pressed = false
	drag = false
	limit.stop()
	interval.stop()
	curpos = Vector2(0, 0)
	prepos = Vector2(0, 0)

func drag(pos):
	curpos = pos
	drag = true
	
func _on_Interval_timeout():
	prepos = curpos

func _on_Limit_timeout():
	released()

func _draw():
	if drag and curpos != prepos and prepos != Vector2(0, 0) and not gameover:
		draw_line(curpos, prepos, Color(1, 0, 0), 5)