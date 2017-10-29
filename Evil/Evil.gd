extends KinematicBody2D

var player

var lights = []

var bloodScene

export var speed = 50
onready var nav = get_parent().get_node("nav")
onready var map = get_parent().get_node("nav/TileMap")
var path = []
var goal = Vector2()

onready var moveTimer = Timer.new()
onready var damageTimer = Timer.new()
var canDamage = true

export var health = 3
export var dmgToPlayer = 1

func _ready():
	bloodScene = preload("res://Blood/Blood.tscn")
	player = get_parent().get_node("Player")
	lights.append(get_node("Light2D"))
	lights.append(get_node("Light2D1"))
	update_path()
	
	moveTimer.connect("timeout",self,"update_path")
	moveTimer.set_wait_time(0.1)
	moveTimer.set_timer_process_mode(1)
	moveTimer.set_one_shot(false)
	moveTimer.start()
	add_child(moveTimer)
	damageTimer.connect("timeout", self, "damagePlayer")
	damageTimer.set_wait_time(1.0)
	damageTimer.set_timer_process_mode(0)
	damageTimer.set_one_shot(true)
	set_fixed_process(true)

func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	
	var dist = get_pos().distance_to(player.get_pos())
	if dist < 100:
		goal = player.get_pos()
		path = nav.get_simple_path(get_pos(), goal, false)
		if path.size() == 0:
			die()
	else:
		goal = get_pos()

func _fixed_process(delta):
	var seePlayer = false
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray( get_global_pos(), player.get_global_pos(), [self])
	if (not result.empty() and player.get_pos().distance_to(result.position) < 10):
		evilEyes()
		#print("Result position: " + str(result.position))
		#print("Player position: " + str(player.get_pos()))
		#print(player.get_pos().distance_to(result.position))
		if path.size() > 1:
			var d = get_pos().distance_to(path[0])
			if d > 1:
				set_pos(get_pos().linear_interpolate(path[0], (speed * delta)/d))
			else:
				path.remove(0)
		else:
			damagePlayer()
			#update_path()
		


func evilEyes():
	if(player and !player.is_queued_for_deletion()):
		var dist = get_pos().distance_to(player.get_pos())
		if dist < 80:
			for light in lights:
				light.set_energy(0.5)
		else:
			for light in lights:
				light.set_energy(0.02)

func damage(dmg):
	health-=dmg
	if health <= 0:
		die()

func damagePlayer():
	if canDamage:
		player.damage(dmgToPlayer)
		canDamage = false
		damageTimer.set_wait_time(1.0)
		damageTimer.start()
	else:
		canDamage = true

func die():
	var blood = bloodScene.instance()
	blood.set_pos(self.get_global_pos())
	get_parent().add_child(blood)
	blood.set_emitting(true)
	self.queue_free()