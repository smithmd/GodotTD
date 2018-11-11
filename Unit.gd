extends "res://Card.gd"

# This is a unit card, enemy or good... whatever?
var statINT
var statDEX
var statSTR
var unitClass
var primaryStat

# init passing in stats from loaded JSON?
func _init(card):
	self.card_name = card.card_name
	self.GFX = card.GFX
	self.number = card.number
	self.type = card.type
	self.statINT = card.statINT
	self.statDEX = card.statDEX
	self.statSTR = card.statSTR
	self.unitClass = card.unitClass
	self.primaryStat = card.primaryStat

func _ready():
	print("Add unit!")

func attack():
	pass

func defend():
	pass
