extends Area2D

var pickedUp = false

func _ready():
	rand_seed(1337)
	set_fixed_process(true)

func _fixed_process(delta):
	var rand = rand_range(1, 10)
	rand = round(rand)
	if rand == 3:
		get_node("Light2D").set_texture_scale(0.73)
		get_node("Light2D").set_energy(1)
	elif rand == 6:
		get_node("Light2D").set_texture_scale(0.72)
		get_node("Light2D").set_energy(0.90)