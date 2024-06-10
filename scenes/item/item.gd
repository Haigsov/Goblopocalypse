extends Area2D


@onready var main = get_node("/root/Main")
@onready var LivesLabel = get_node("/root/Main/HUD/LivesLabel")
var item_type : int #0 coffee, #1 health, #2 gun

var coffee_box := preload("res://assets/tilemaps/tileset/items/coffee_box.png")
var health_box := preload("res://assets/tilemaps/tileset/items/health_box.png")
var gun_box := preload("res://assets/tilemaps/tileset/items/gun_box.png")

var item_textures := [coffee_box, health_box, gun_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = item_textures[item_type]

func _on_body_entered(body):
	#coffee
	if item_type == 0:
		body.boost()
	#health
	elif item_type == 1:
		main.lives += 1
		LivesLabel.text = "X " + str(main.lives)
	#gun
	elif item_type == 2:
		body.quick_fire()

	#delete item
	queue_free()
