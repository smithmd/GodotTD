extends Node2D

export (PackedScene) var Enemy
var player_health = 20
var enemies = [] 
var unit_cards = [] # Possible unit cards
var enhancement_cards = [] # Possible enhancement cards
var card_dictionary = {} # All possible cards
var enemy_cards = [] # Possible enemy unit cards
var player_deck = [] # Player's current cards
var levels = {} # All the levels
var current_enemy_deck = []
var current_enemy
var current_level # This will probably load off the save or be changed when they pick a level?
var current_story
var current_objective
var current_time_limit
var current_time

func _ready():
	randomize()
	load_cards()
	load_levels()
	load_current_level()
	load_deck()
	update_gui()
#	spawn_enemy()
	$Spawn.start()
	ground_battle(enemy_cards[0],player_deck[0])
	save_deck()

func _on_Enemy_Walk_timeout():
	for enemy in enemies:
		enemy.get_parent().set_offset(enemy.get_parent().get_offset() + 5)
		
		# Deletes the enemy and it's PathFollow2D from the game
		if (enemy.get_parent().get_unit_offset() >= 1.0):
			player_hit()
			remove_enemy(enemy)

func _on_Spawn_timeout():
	print("enemy count: ", enemies.size())
	if current_enemy < current_enemy_deck.size():
		spawn_enemy(current_enemy_deck[current_enemy])
		current_enemy = current_enemy + 1

func spawn_enemy(enemy_card):
	print("Spawning enemy: " + enemy_card.card_name)
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
	enemy.set_card(enemy_card)
	enemies.append(enemy)
	pf.add_child(enemy)

func remove_enemy(enemy):
	enemy.get_parent().queue_free() # deletes the PathFollow2D that is this enemy's parent node
	enemies.erase(enemy)
	enemy.queue_free()

func player_hit():
	player_health = player_health - 1
	update_gui()

func update_gui():
	$HealthCounter.text = str(player_health)

func load_levels():
	var level_file = File.new()
	if level_file.file_exists("res://levels.json"):
		level_file.open("levels.json", File.READ)
		var level_data = parse_json(level_file.get_as_text())
		level_file.close()
		
		for level in level_data:
			levels[int(level.number)] = add_level(level)
		
		print("Done loading levels: " + String(levels))

func load_current_level():
	if current_level == null || current_level > levels.size(): # Might be a better way to handle unknown level
		current_level = 1
	current_time_limit = levels[current_level].time
	current_story = levels[current_level].story
	current_objective = levels[current_level].objective
	current_enemy_deck = levels[current_level].enemy_deck
	current_enemy = 0 # Start with the first card in the enemy deck

func load_cards():
	var card_file = File.new()
	if card_file.file_exists("res://cards.json"):
		card_file.open("cards.json", File.READ)
		var card_data = parse_json(card_file.get_as_text())
		card_file.close()
	
		for card in card_data:
			if card.type == "unit":
				card_dictionary[int(card.number)] = add_unit_card(card)
				unit_cards.append(add_unit_card(card))
			elif card.type == "enemy":
				card_dictionary[int(card.number)] = add_unit_card(card)
				enemy_cards.append(add_unit_card(card))
			elif card.type == "enhancement":
				card_dictionary[int(card.number)] = add_enhancement_card(card)
				enhancement_cards.append(add_enhancement_card(card))
			else:
				print("Opps! Not a card type: " + card.type)

func add_level(level):
	print("Adding level: " + String(level.number))
	var new_level = {}
	new_level.story = level.story
	new_level.objective = level.objective
	new_level.number = level.number
	new_level.time = level.time
	var deck = []
	for card in level.enemy_deck:
		print("loading enemy card: " + String(card.number) + " level " + String(card.level))
		var this_card = load("res://Unit.gd").new(card_dictionary[int(card.number)])
		this_card.level = card.level
		deck.append(this_card)
	new_level.enemy_deck = deck
	return new_level

func add_unit_card(card):
	print("Adding unit card: " + card.card_name)
	var unit = load("res://Unit.gd").new(card)
	return unit

func add_enhancement_card(card):
	print("Adding enhancement card: " + card.card_name)
	var enhancement = load("res://Enhancement.gd").new(card)
	return enhancement

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
