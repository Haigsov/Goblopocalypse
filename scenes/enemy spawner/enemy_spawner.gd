extends Node2D

# Get a reference to the main node in the scene tree
@onready var main = get_node("/root/Main")

# Define a signal to emit when a hit occurs
signal hit_p

# Preload the goblin scene for instantiation
var goblin_scene := preload("res://scenes/goblin/goblin.tscn")

# Array to store all the spawn points
var spawn_points : Array[Marker2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Loop through all children of the EnemySpawner node
	for i in get_children():
		# Add any Marker2D nodes to the spawn_points array
		if i is Marker2D:
			spawn_points.append(i)

# Called when the timer times out
func _on_timer_timeout():
	# Get a list of all nodes in the 'enemies' group
	var enemies = get_tree().get_nodes_in_group("enemies")
	# Check if the number of enemies is less than the maximum allowed
	if enemies.size() < get_parent().max_enemies:
		# Pick a random spawn point from the spawn_points array
		var spawn := spawn_points[randi() % spawn_points.size()]
		# Instantiate a new goblin from the preloaded scene
		var goblin := goblin_scene.instantiate()
		# Set the goblin's position to the spawn point's position
		goblin.position = spawn.position
		# Connect the goblin's hit_player signal to the hit function
		goblin.hit_player.connect(hit)
		# Add the goblin to the main node
		main.add_child(goblin)
		# Add the goblin to the 'enemies' group
		goblin.add_to_group("enemies")

# Function to handle hit events
func hit():
	# Emit the hit_p signal
	hit_p.emit()
