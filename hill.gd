extends Node3D

var Players = {}
var score_tick = 10
var gm_player_ind = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Players.keys().size() == 1:
		var p = GameManager.Players[GameManager.Players.keys()[gm_player_ind]]
		p.score += score_tick * delta

func get_gm_player_ind_key():
	if Players.keys().size() == 1:
		var p = Players[Players.keys()[0]]
		for i in GameManager.Players.keys().size():
			var p_gm = GameManager.Players[GameManager.Players.keys()[i]]
			if p.name == str(p_gm.id):
				gm_player_ind = i
				break

func _on_area_3d_body_entered(body):
	print(body.get_groups())
	if body.is_in_group("Player"):
		Players[body.name] = body
	get_gm_player_ind_key()

func _on_area_3d_body_exited(body):
	print(body.get_groups())
	if body.is_in_group("Player"):
		Players.erase(body.name)
	get_gm_player_ind_key()
