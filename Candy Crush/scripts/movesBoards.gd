extends Sprite

var moves = 05

func _ready():
	update_number()
	
func set_moves(number):
	moves = number
	update_number()

func update_number():
	get_node("Number1").set_texture(load("res://Shary the fairy/files/png/gui/Group_" + str(moves/10) + ".png"))
	get_node("Number2").set_texture(load("res://Shary the fairy/files/png/gui/Group_" + str(moves%10) + ".png"))

func _on_Candies_played():
	moves -= 1
	update_number()
