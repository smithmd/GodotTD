extends RigidBody2D

export (int) var min_speed
export (int) var max_speed
var mob_types = ["truck", "tank", "roller"]
var path_follow

func set_path_follow(pf):
	path_follow = pf

func _fixed_process(delta):
	pass