extends Node2D

var max_enemies : int
var lives : int

# Called when the node enters the scene tree for the first time.
func _ready():
	max_enemies = 10
	lives = 3
	$HUD/LivesLabel.text = "X " + str(lives)
	$HUD/EnemiesLabel.text = "X " + str(max_enemies)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
	


func _on_enemy_spawner_hit_p():
	print("hit player")
	lives -= 1
	$HUD/LivesLabel.text = "X " + str(lives)
