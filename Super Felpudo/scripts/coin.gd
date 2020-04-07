extends Area2D

func _on_Coin_body_enter( body ):
	body.coin()
	get_node("AnimationPlayer").play("Get_coin")
	get_node("CollisionShape2D").queue_free()
	
	yield(
		get_node("AnimationPlayer"), "finished"
	)
	queue_free()
