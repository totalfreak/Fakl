extends Area2D

var player

func _ready():
	connect("body_enter", self, "pickUp")
	player = get_parent().get_node("Player")

func pickUp(body):
	if body.get_name() == "Player" and player.hasTorch:
		player.torch.fuel += 0.2
		queue_free()
