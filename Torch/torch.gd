extends Area2D

var pickedUp = false

var fuel = 1.0
var player

func _ready():
	player = get_parent().get_node("Player")
	rand_seed(1337)
	set_fixed_process(true)

func _fixed_process(delta):
	
	if pickedUp:
		set_pos(player.get_node("TorchPos").get_global_pos())
		set_z(1)
	else:
		set_z(-1)
	
	if(fuel > 0.5):
		var rand = rand_range(1, 10)
		rand = round(rand)
		get_node("Particles2D").set_param(11, fuel/2)
		get_node("Particles2D").set_lifetime(fuel)
		if rand == 3:
			get_node("Light2D").set_texture_scale(fuel+0.17)
			get_node("Light2D").set_energy(fuel+0.1)
		elif rand == 6:
			get_node("Light2D").set_texture_scale(fuel+0.18)
			get_node("Light2D").set_energy(fuel)
	else:
		get_node("Particles2D").set_param(11, 0.0)
		get_node("Light2D").set_texture_scale(fuel-0.17)
		get_node("Light2D").set_energy(fuel+0.1)