extends Node2D

export (PackedScene) var Enemy
var enemies = []

func _ready():
	randomize()
	spawn_enemy()
	$Spawn.start()

func _on_Enemy_Walk_timeout():
	#for path in paths:
	#	print("%: %", path, path.get_unit_offset())
	#	path.set_unit_offset(path.get_unit_offset() + .01)
		
	for enemy in enemies:
		enemy.get_parent().set_offset(enemy.get_parent().get_offset() + 5)

func _on_Spawn_timeout():
	print("enemy count: ", enemies.size())
	spawn_enemy()
	#pass

func spawn_enemy():
	var paths = [$PathNorth, $PathSouth]
	var path = paths[randi() % paths.size()]
	
	# create a new PathFollow2D
	var pf = PathFollow2D.new()
	path.add_child(pf)
	pf.set_name("PathFollow")
	pf.set_offset(0)
	print(path.get_children())
	
	# create a new Enemy and add it to the PathFollow2D
	var enemy = Enemy.instance()
	enemy.set_path_follow(pf)
	enemies.append(enemy)
	pf.add_child(enemy)