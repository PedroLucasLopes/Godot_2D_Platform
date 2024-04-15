extends Area2D



func _on_body_entered(body):
	if body.name == "player":
		body.velocity.y = body.JUMP_VELOCITY + 150
		owner.SPEED = 0
		owner.anim.play("hurt")
