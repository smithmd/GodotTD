extends Node2D

export (PackedScene) var Enemy
var enemies = []

func _ready():
	randomize()
	spawn_enemy()

func _on_Enemy_Walk_timeout():
	var paths = [$PathNorth/PathFollow, $PathSouth/PathFollow]
	for path in paths:
		path.set_offset(path.get_offset + 10)

func _on_Spawn_timeout():
	pass

func spawn_enemy():
	var paths = [$PathNorth/PathFollow, $PathSouth/PathFollow]
	var path = paths[randi() % paths.size()]
	path.set_offset(0);
	var enemy = Enemy.instance()
	enemy.set_path_follow(path)
	enemies.append(enemy)
	add_child(enemy)
	enemy.position = path.global_position;