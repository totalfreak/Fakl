extends KinematicBody2D

var left  = Vector2(-1, 0)
var right = Vector2( 1, 0)
var up    = Vector2(0, -1)
var down  = Vector2(0,  1)

var upTorchPos = Vector2(11, -12)
var downTorchPos = Vector2(-12, 11)
var leftTorchPos = Vector2(-12, -11)
var rightTorchPos = Vector2(11, -12)

var shootSpeed = 350
var fuel = 1.0

var hasTorch = false
var hasShot = false
var torchPos
var torchScene
var torch
onready var timer = Timer.new()

const MOVE_SPEED = 40
const RUN_MULT = 2

func _ready():
	set_fixed_process(true)
	#preload the torch
	torchScene = preload("res://Torch/Torch.tscn")
	torchPos = get_node("TorchPos")
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer)
	timer.start()

func _fixed_process(delta):
	
	if hasTorch:
		torch.fuel = fuel
		torch.get_node("Particles2D").set_param(11, fuel/2)
		if fuel < 0.1:
			torch.get_node("Particles2D").set_param(11, 0.0)
			dropTorch()
	#Shooting
	if Input.is_mouse_button_pressed(1) and hasTorch and !hasShot and fuel >= 0.1:
		shoot()
	
	#Reseting velocity
	var velocity = Vector2()
	
	#Moving left and right
	if Input.is_action_pressed("move_left"):
		velocity += left
		torchPos.set_pos(leftTorchPos)
	elif Input.is_action_pressed("move_right"):
		velocity += right
		torchPos.set_pos(rightTorchPos)
	
	#Moving up and down
	if Input.is_action_pressed("move_up"):
		velocity += up
	elif Input.is_action_pressed("move_down"):
		velocity += down
	
	#Running
	if Input.is_action_pressed("move_run"):
		velocity *= RUN_MULT
	
	var motion = (velocity * MOVE_SPEED) * delta
	motion = move(motion)
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)


func pickUpTorch( body ):
	var otherTorch = get_parent().get_node("Torch")
	otherTorch.set_scale(Vector2(0,0))
	otherTorch.queue_free()
	torch = torchScene.instance()
	torch.set_pos(Vector2(0,0))
	torchPos.add_child(torch)
	hasTorch = true


func shoot():
	fuel -= 0.1
	if fuel <= 0:
		dropTorch()
	var bullet = load("res://Projectile/Bullet.tscn").instance()
	bullet.get_node("Particles2D").set_param(11, fuel/2.0)
	#var bi = bullet.instance()
	get_parent().add_child(bullet)
	var bullet_rot = get_angle_to(get_global_mouse_pos()) + bullet.get_rot()
	bullet.set_rot(bullet_rot)
	bullet.set_pos(torchPos.get_global_pos())
	var rigidbody_vector = (get_global_mouse_pos() - torchPos.get_global_pos()).normalized()
	bullet.apply_impulse(bullet.get_pos(), rigidbody_vector*shootSpeed)
	hasShot = true
	timer.set_wait_time( 1 )
	timer.start()

func _on_timer_timeout():
	hasShot = false


func dropTorch():
	torchPos.remove_child(torch)
	self.get_parent().add_child(torch)
	hasTorch = false