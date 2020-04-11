extends Area2D

export(int) var level = 0
export(String, FILE) var marker_unlock
export(String, FILE) var star_one
export(String, FILE) var star_two
export(String, FILE) var star_three

var stars

func _ready():
	stars = Global.savedata["level" + str(level)]
	
	if stars != -1:
		get_node("Lock").set_texture(load(marker_unlock))
		
		if stars != 0:
			get_node("Stars").show()
		if stars == 1:
			get_node("Stars").set_texture(load(star_one))
		elif stars == 2:
			get_node("Stars").set_texture(load(star_two))
		elif stars == 3:
			get_node("Stars").set_texture(load(star_three))
	
	get_node("Number").set_texture(load("res://Shary the fairy/files/png/gui/Group_" + str(level) + ".png"))

func _on_Level_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and stars != -1:
		Global.curLevel = level
		Transition.fade_to("res://scenes/LevelScreen.tscn")
