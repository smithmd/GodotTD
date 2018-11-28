extends Node2D

export (PackedScene) var Enemy
var enemies = []
var unit_cards = []
var card_dictionary = {}
var enemy_cards = []
var player_deck = []

func _init():
	load_cards()
	load_deck()

func _ready():
	randomize()
	spawn_enemy()
	$Spawn.start()
	ground_battle(enemy_cards[0],player_deck[0])
	save_deck()

func _on_Enemy_Walk_timeout():
	for enemy in enemies:
		enemy.get_parent().set_offset(enemy.get_parent().get_offset() + 5)
		
		# Deletes the enemy and it's PathFollow2D from the game
		if (enemy.get_parent().get_unit_offset() >= 1.0):
			# handle_damage()
			remove_enemy(enemy)

func _on_Spawn_timeout():
	print("enemy count: ", enemies.size())
	spawn_enemy()

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
	enemies.append(enemy)
	pf.add_child(enemy)

func remove_enemy(enemy):
	enemy.get_parent().queue_free() # deletes the PathFollow2D that is this enemy's parent node
	enemies.erase(enemy)
	enemy.queue_free()

func load_cards():
	var card_file = File.new()
	if card_file.file_exists("res://cards.json"):
		card_file.open("cards.json", File.READ)
		var card_data = parse_json(card_file.get_as_text())
		card_file.close()
	
		for card in card_data:
			card_dictionary[int(card.number)] = add_unit_card(card)
			if card.type == "unit":
				unit_cards.append(add_unit_card(card))
			elif card.type == "enemy":
				enemy_cards.append(add_unit_card(card))
			else:
				print("Opps! Not a card type: " + card.type)

func add_unit_card(card):
	print("Adding unit card: " + card.card_name)
	var unit = load("res://Unit.gd").new(card)
	return unit

# Should this take a list of everyone on both sides?
func ground_battle(enemy, unit):
	# this is all temporary, need to add armor, speed, hitpoints, turns stuff like that...
	var unit_attack = unit.attack()
	var unit_defend = unit.defend()
	var enemy_attack = enemy.attack()
	var enemy_defend = enemy.defend()
	print(unit.card_name + " Attack " + String(unit_attack) + " Defend " + String(unit_defend))
	print(enemy.card_name + " Attack " + String(enemy_attack) + " Defend " + String(enemy_defend))
	
	if unit_attack > enemy_defend:
		print(unit.card_name + " Wins!")
		unit.XP += 10 # XP for winning, really will only happen when they kill a unit
	else:
		print(unit.card_name + " Didn't win right away, so " + enemy.card_name + " gets to attack!")
		if enemy_attack > unit_defend:
			print(enemy.card_name + " Wins!")
		else:
			ground_battle(enemy, unit)

func save_deck():
	var deck_file = File.new()
	var index = 0 # There's probably a better way to do this?
	deck_file.open("deck.json", File.WRITE)
	deck_file.store_line("[")
	for card in player_deck:
		index += 1
		var card_info = {
			"number" : card.number,
			"XP" : card.XP,
			"level" : card.level
		}
		if index < player_deck.size(): # There's also probably a better way to do this?
			deck_file.store_line(to_json(card_info) + ",")
		else:
			deck_file.store_line(to_json(card_info))
	deck_file.store_line("]")
	deck_file.close()

func load_deck():
	print("Loading deck!")
	var deck_file = File.new()
	deck_file.open("deck.json", File.READ_WRITE)
	var deck = parse_json(deck_file.get_as_text())
	for card in deck:
		var this_card = load("res://Unit.gd").new(card_dictionary[int(card.number)])
		this_card.XP = card.XP
		this_card.level = card.level
		player_deck.append(this_card)
	deck_file.close()
