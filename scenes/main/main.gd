extends Node2D

var max_enemies : int
var lives : int

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	$GameOver/Button.pressed.connect(new_game)

func new_game():
	max_enemies = 10
	lives = 3
	$Player.reset()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("items", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	$HUD/LivesLabel.text = "X " + str(lives)
	$HUD/EnemiesLabel.text = "X " + str(max_enemies)
	$GameOver.hide()
	get_tree().paused = true
	$RestartTimer.start()



func _on_enemy_spawner_hit_p():
	print("hit player")
	lives -= 1
	$HUD/LivesLabel.text = "X " + str(lives)
	if lives <= 0:
		get_tree().paused = true
		$GameOver.show()


func _on_restart_timer_timeout():
	get_tree().paused = false
