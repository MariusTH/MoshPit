extends Node

var Players = {}
const win_score = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for id in Players:
		if Players[id].score >= win_score:
			print(Players[id].name, " won!")
			var scene = load("res://winner.tscn").instantiate()
			get_tree().root.add_child(scene)
