extends StaticBody2D

func destruct():
	get_node("Sprite").queue_free()
	get_node("CollisionShape2D").queue_free()
	get_node("Particles2D").set_emitting(true)