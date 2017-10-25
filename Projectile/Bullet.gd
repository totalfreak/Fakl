extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process(true)

func _process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("wall"):
			self.free()