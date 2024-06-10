extends Area2D

# Get references to the main node and LivesLabel in the scene tree
@onready var main = get_node("/root/Main")
@onready var LivesLabel = get_node("/root/Main/HUD/LivesLabel")

# Variable to specify the type of item
var item_type : int # 0: coffee, 1: health, 2: gun

# Preload item textures
var coffee_box := preload("res://assets/tilemaps/tileset/items/coffee_box.png")
var health_box := preload("res://assets/tilemaps/tileset/items/health_box.png")
var gun_box := preload("res://assets/tilemaps/tileset/items/gun_box.png")

# Array to store item textures for easy access
var item_textures := [coffee_box, health_box, gun_box]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the sprite texture based on the item type
	$Sprite2D.texture = item_textures[item_type]

# Called when another body enters this Area2D
func _on_body_entered(body):
	# If item is coffee, boost the body
	if item_type == 0:
		body.boost()
	# If item is health, increase lives and update the LivesLabel
	elif item_type == 1:
		main.lives += 1
		LivesLabel.text = "X " + str(main.lives)
	# If item is gun, enable quick fire on the body
	elif item_type == 2:
		body.quick_fire()

	# Delete the item node
	queue_free()
