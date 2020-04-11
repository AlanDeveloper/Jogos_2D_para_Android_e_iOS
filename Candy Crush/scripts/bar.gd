extends Sprite

export(String, FILE) var starOn

var points = 0

var p3 = 200
var p1 = (151.0/408)*p3
var p2 = (p1 + p3) / 2

func _ready():
	starOn = load(starOn)

func set_max(pmax):
	p3 = pmax
	p1 = (151.0/408)*p3
	p2 = (p1 + p3) / 2

func _on_Candies_add_points( p ):
	points += p
	if points > p3: points = p3
	get_node("Green").set_region_rect(Rect2(0, 0, 408 * points/p3, 42))
	
	if points >= p3:
		Global.stars = 3
		get_node("Star3").set_texture(starOn)
	elif points >= p2:
		Global.stars = 2
		get_node("Star2").set_texture(starOn)
	elif points >= p1:
		Global.stars = 1
		get_node("Star1").set_texture(starOn)

func win():
	return points >= p1

func rmax():
	return points >= p3