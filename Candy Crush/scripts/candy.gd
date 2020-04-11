extends Area2D

var color
var special = false
var select = false

var x
var y

var destx
var desty
var posx
var posy

signal selected(obj, b)

func _ready():
	randomize()
	color = int(rand_range(0, 6))
	
	if rand_range(0, 1)  > 0.99:
		special = true
	
	if special:
		get_node("AnimatedSprite").set_animation("shine" + get_color(color))
	else:
		get_node("AnimatedSprite").set_animation("normal" + get_color(color))
		
	set_process(true)

func _process(delta):
	if destx == null or desty == null or (destx == x and desty == y):
		return
	
	var delx = posx - get_pos().x
	var dely = posy - get_pos().y
	
	var speed = Vector2(0, 0)
	if abs(delx) > 20:
		speed.x = 300*(destx - x)
	else:
		set_pos(Vector2(posx, get_pos().y))
		x = destx
	if abs(dely) > 20:
		speed.y = 300*(desty - y)
	else:
		set_pos(Vector2(get_pos().x, posy))
		y = desty
		
	set_pos(get_pos() + speed * delta)
		
func get_color(number):
	if number == 0:
		return "Blue"
	elif number == 1:
		return "Orange"
	elif number == 2:
		return "Yellow" 
	elif number == 3:
		return "Pink" 
	elif number == 4:
		return "Purple" 
	elif number == 5:
		return "Green" 

func _on_Candy_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed:
		if select:
			deselect()
			emit_signal("selected", self, false)
		else:
			select()
			emit_signal("selected", self, true)

func deselect():
	select = false
	get_node("Sprite").hide()
	
func select():
	select = true
	get_node("Sprite").show()

func set_data(x, y):
	self.x = x
	self.y = y
	
	set_pos(Vector2(62 + x * 75 + 75/2, 290 + y * 75 + 75/2))
	
func move_to(gx, gy):
	destx = gx
	desty = gy
	
	posx = get_pos().x + (gx - x) * 75
	posy = get_pos().y + (gy - y) * 75
