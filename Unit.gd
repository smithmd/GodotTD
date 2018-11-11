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
	pass

func defend():
	pass
