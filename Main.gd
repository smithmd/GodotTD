extends Node2D

export (PackedScene) var Enemy
var enemies = []
var paths = []

func _ready():
	paths = [$PathNorth/PathFollow, $PathSouth/PathFollow]
	randomize()
	spawn_enemy()
	$Spawn.start()

func _on_Enemy_Walk_timeout():
	for path in paths:
	#	print("%: %", path, path.get_unit_offset())
		path.set_unit_offset(path.get_unit_offset() + .01)
		for enemy in enemies:
			enemy.position = path.global_position

func _on_Spawn_timeout():
	print("enemy count: ", enemies.size())
	spawn_enemy()
	#pass

func spawn_enemy():
	var path = paths[randi() % paths.size()]
	var enemy = Enemy.instance()
	enemy.set_path_follow(path)
	enemies.append(enemy)
	add_child(enemy)