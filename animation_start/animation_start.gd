extends Node2D

@export var speed := 180.0

@onready var cat: AnimatedSprite2D = $AnimatedSprite2D2
@onready var ghost: AnimatedSprite2D = $AnimatedSprite2D3


func _ready():
	cat.play("default")
	ghost.play("default")

func _process(delta):
	cat.position.x += speed * delta
	ghost.position.x += speed * delta

	if ghost.position.x > get_viewport_rect().size.x + 100:
		get_tree().change_scene_to_file("res://Main/main.tscn")
