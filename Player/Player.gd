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
var fuel

var hasTorch = false
var hasShot = false
var torchPos
var torchScene
var torch
onready var timer = Timer.new()

const MOVE_SPEED = 40
const RUN_MULT = 2
var health = 10

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	torch = get_parent().get_node("Torch")
	torchPos = get_node("TorchPos")
	timer.connect("timeout",self,"_on_timer_timeout")
	add_child(timer)
	timer.start()

func _fixed_process(delta):
	
	if hasTorch:
		fuel = torch.fuel
	
	#Shooting
	if Input.is_action_pressed("shoot") and hasTorch and !hasShot and fuel >= 0.5:
		shoot()
	
	#Reseting velocity
	var velocity = Vector2()
	
	#Moving left and right
	if Input.is_action_pressed("move_left"):
		velocity += left
		torchPos.set_pos(leftTorchPos/2)
	elif Input.is_action_pressed("move_right"):
		velocity += right
		torchPos.set_pos(rightTorchPos/2)
	
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


func _input(event):
	if event.type == InputEvent.KEY and event.is_pressed() and Input.is_action_pressed("torch_toggle"):
		if hasTorch:
			dropTorch()
		elif get_pos().distance_to(torch.get_pos()) < 15:
			pickUpTorch()


func shoot():
	torch.fuel -= 0.1
	var bullet = load("res://Projectile/Bullet.tscn").instance()
	bullet.get_node("Particles2D").set_param(11, fuel/2.0)
	#var bi = bullet.instance()
	get_parent().add_child(bullet)
	var bullet_rot = get_angle_to(get_global_mouse_pos()) + bullet.get_rot()
	bullet.set_rot(bullet_rot)
	bullet.set_pos(torchPos.get_global_pos())
	var rigidbody_vector = (get_global_mouse_pos() - torchPos.get_global_pos()).normalized()
	bullet.apply_impulse(bullet.get_pos(), rigidbody_vector*shootSpeed)
	torch.get_node("audio").play("fire")
	hasShot = true
	timer.set_wait_time( 0.5 )
	timer.start()

func _on_timer_timeout():
	hasShot = false

func pickUpTorch():
	get_node("Light2D").set_texture_scale(0)
	torch.pickedUp = true
	hasTorch = true

func dropTorch():
	get_node("Light2D").set_texture_scale(0.4)
	torch.pickedUp = false
	hasTorch = false

func damage(dmg):
	health-=dmg
	if health <= 0:
		die()

func die():
	#self.queue_free()
	pass