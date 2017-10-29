extends Node2D

func _ready():
	set_fixed_process(true)
	pass


func _fixed_process(delta):
	var evils = get_tree().get_nodes_in_group("evil").size()
	if evils <= 0:
		print("Ya win boi!")