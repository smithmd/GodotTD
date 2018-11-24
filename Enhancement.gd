extends "res://Card.gd"

# This is an enhancement card
var modify_int
var modify_dex
var modify_str
var modify_attack_speed
var modify_attack_range
var modify_movement_speed
var modify_armor
var modify_type # make us better or bad guys worse?

# init passing in stats from loaded JSON?
func _init(card):
	self.card_name = card.card_name
	self.GFX = card.GFX
	self.number = card.number
	self.type = card.type
	self.modify_int = card.modify_int
	self.modify_dex = card.modify_dex
	self.modify_str = card.modify_str
	self.modify_movement_speed = card.modify_movement_speed
	self.modify_attack_speed = card.modify_attack_speed
	self.modify_attack_range = card.modify_attack_range
	self.modify_armor = card.modify_armor
	self.modify_type = card.modify_type
	
func _ready():
	print("Add enhancement!")

func ability():
	print("Do ability!")