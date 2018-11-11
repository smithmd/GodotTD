extends "res://Card.gd"

# This is a unit card, enemy or good... whatever?
var stat_int
var stat_dex
var stat_str
var hitpoints
var unit_class
var primary_stat

# init passing in stats from loaded JSON?
func _init(card):
	self.card_name = card.card_name
	self.GFX = card.GFX
	self.number = card.number
	self.type = card.type
	self.stat_int = card.stat_int
	self.stat_dex = card.stat_dex
	self.stat_str = card.stat_str
	self.unit_class = card.unit_class
	self.primary_stat = card.primary_stat
	self.hitpoints = card.hitpoints

func _ready():
	print("Add unit!")

func attack():
	var attack_power
	match primary_stat:
		"STR":
			attack_power = stat_str
		"INT":
			attack_power = stat_int
		"DEX":
			attack_power = stat_dex
	return attack_power

func defend():
	var stat_defense = int(stat_str + stat_dex)
	var defense = randi() % stat_defense
	return defense
