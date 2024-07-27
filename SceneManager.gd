extends Node3D

@export var PlayerScene : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		print("spawning player name: ", currentPlayer.name)
		for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
			print("node name: ", spawn.name)
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
				index += 1
				break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
