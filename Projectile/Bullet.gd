extends RigidBody2D

const dmg = 2

func _ready():
	set_process(true)

func _process(delta):
	var bodies = get_colliding_bodies()
	
	for body in bodies:
		if body.is_in_group("wall"):
			self.queue_free()
		elif body.is_in_group("evil"):
			body.damage(dmg)
			self.queue_free()