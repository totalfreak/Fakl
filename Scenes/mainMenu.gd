extends Control

onready var level1 = "res://Scenes/Level1.tscn"

func _ready():
	
	pass


func play():
	get_tree().change_scene(level1)

func quit():
	get_tree().quit()
