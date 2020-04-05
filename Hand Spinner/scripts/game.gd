extends Node2D

var score1 = 0
var score2 = 0

var spinner1 = false
var spinner2 = false
var reloading = false
var time = 0

signal block
signal unblock

func _ready():
	pass
	
func update_score():
	get_node("Control/Player1/Score").set_text(str(score1))
	get_node("Control/Player2/Score").set_text(str(score2))
	
	emit_signal("block")
	spinner1 = false
	spinner2 = false

func _on_Spinner1_limit():
	score1 += 1
	get_node("Control/Player1/Message").set_text("VOCÊ GANHOU")
	get_node("Control/Player2/Message").set_text("VOCÊ PERDEU")
	update_score()

func _on_Spinner2_limit():
	score2 +=1
	get_node("Control/Player2/Message").set_text("VOCÊ GANHOU")
	get_node("Control/Player1/Message").set_text("VOCÊ PERDEU")
	update_score()

func _on_Spinner1_stoped():
	spinner1 = true
	if spinner2:
		reset()

func _on_Spinner2_stoped():
	spinner2 = true
	if spinner1:
		reset()
		
func reset():
	if reloading:
		return
	reloading = true
	time = 7
	get_node("Control/Player2/Message").set_text("")
	get_node("Control/Player1/Message").set_text("")
	get_node("Timer").start()
		
func _on_Timer_timeout():
	time -= 1
	if time > 1:
		get_node("Control/Player2/Message").set_text(str(time - 1))
		get_node("Control/Player1/Message").set_text(str(time - 1))
	if time == 1:
		get_node("Control/Player2/Message").set_text("GO!")
		get_node("Control/Player1/Message").set_text("GO!")
		reloading = false
		emit_signal("unblock")
	if time == 0:
		get_node("Control/Player2/Message").set_text("")
		get_node("Control/Player1/Message").set_text("")
