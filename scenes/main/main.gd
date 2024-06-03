extends Node2D

var max_enemies : int

# Called when the node enters the scene tree for the first time.
func _ready():
	max_enemies = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	


func _on_enemy_spawner_hit_p():
	print("hit player")
