extends Node2D

var felpudo

var pontos = 0
var estado = 1

const jogando = 1
const perdendo = 2

func _ready():
	felpudo = get_node("Felpudo")
	pass

func kill():
	felpudo.apply_impulse(Vector2(0, 0), Vector2(-1000, 0))
	get_node("Fundo").stop()
	estado = 2
	
	get_node("TimeToReplay").start()
	get_node("Hit").play()

func _on_TimeToReplay_timeout():
	get_tree().reload_current_scene()
	
func pontuar():
	pontos += 1
	
	get_node("Texto/Control/Label").set_text(str(pontos))
	get_node("Score").play()
