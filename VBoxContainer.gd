extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func redraw_player_score():
	for item in get_children():
		item.queue_free()
	for id in GameManager.Players:
		var player = GameManager.Players[id]
		var player_label = Label.new()
		player_label.text = "Player %s - %s" % [str(player.name), str(int(player.score))]
		add_child(player_label)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	redraw_player_score()
	pass
