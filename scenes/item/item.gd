extends Area2D

var item_type : int #0 coffee, #1 health, #2 gun

var coffee_box := preload("res://assets/tilemaps/tileset 3/items/coffee_box.png")
var health_box := preload("res://assets/tilemaps/tileset 3/items/health_box.png")
var gun_box := preload("res://assets/tilemaps/tileset 3/items/gun_box.png")

var item_textures := [health_box, gun_box, coffee_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = item_textures[item_type]

func _on_body_entered(body):
	pass # Replace with function body.
