extends Control

@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	for id in GameManager.Players:
		var p = GameManager.Players[id]
		if p.score >= GameManager.win_score:
			label.text = "Winner is %s" %[p.name]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
