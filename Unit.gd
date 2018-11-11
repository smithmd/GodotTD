extends "res://Card.gd"

# This is a unit card, enemy or good... whatever?
var base_int
var base_dex
var base_str
var base_attack_speed
var base_attack_range
var base_movement_speed
var base_armor
var armor_type
var hitpoints
var unit_class
var primary_stat

# init passing in stats from loaded JSON?
func _init(card):
	self.card_name = card.card_name
	self.GFX = card.GFX
	self.number = card.number
	self.type = card.type
	self.base_int = card.base_int
	self.base_dex = card.base_dex
	self.base_str = card.base_str
	self.base_movement_speed = card.base_movement_speed
	self.base_attack_speed = card.base_attack_speed
	self.base_attack_range = card.base_attack_range
	self.base_armor = card.base_armor
	self.armor_type = card.armor_type
	self.unit_class = card.unit_class
	self.primary_stat = card.primary_stat
	self.hitpoints = card.hitpoints

func _ready():
	print("Add unit!")

func attack():
	var attack_power
	match primary_stat:
		"STR":
			attack_power = base_str
		"INT":
			attack_power = base_int
		"DEX":
			attack_power = base_dex
	return attack_power

func defend():
	var base_defense = int(base_str + base_dex)
	var defense = randi() % base_defense
	return defense
