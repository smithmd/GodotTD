extends RigidBody2D

func _on_Area2D_body_entered(body):
	print(body, " entered")
	pass

func _on_Area2D_body_exited(body):
	print(body, " exited")
	pass