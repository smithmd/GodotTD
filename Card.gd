extends Node2D

# Every card has a name, card GFX (not sprite), number, and type (Unit, Enhancement/Equipment)
var card_name
var GFX
var number
var type

# Cards gain XP and levels... but do they all gain XP and levels?
var level = 0
var XP = 0

func _ready():
	print("Card added! " + card_name)
