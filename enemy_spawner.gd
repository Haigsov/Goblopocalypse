extends Node2D

@onready var main = get_node("/root/Main")
#preloads the goblin scene in the scene
var goblin_scene := preload("res://scenes/goblin/goblin.tscn")
#an empty to store all the spawn points later
var spawn_points : Array[Marker2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#looping through all the children in EnemySpawner scene
	for i in get_children():
		#puts the enemy spawn points one by one
		if i is Marker2D:
			spawn_points.append(i)



func _on_timer_timeout():
	#picks a random spawn point from the array
	var spawn := spawn_points[randi() % spawn_points.size()]
	#spawns goblin in
	var goblin := goblin_scene.instantiate()
	#puts it at the same position of the spawn point
	goblin.position = spawn.position
	#adds goblin to main
	main.add_child(goblin)
