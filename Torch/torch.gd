extends Area2D

var pickedUp = false

var fuel = 1.0

func _ready():
	rand_seed(1337)
	set_fixed_process(true)

func _fixed_process(delta):
	var rand = rand_range(1, 10)
	rand = round(rand)
	if rand == 3:
		get_node("Light2D").set_texture_scale(fuel-0.27)
		get_node("Light2D").set_energy(fuel)
	elif rand == 6:
		get_node("Light2D").set_texture_scale(fuel-0.28)
		get_node("Light2D").set_energy(fuel-0.10)