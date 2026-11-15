extends Node2D

@export var follow_speed: float = 120.0
@export var move_speed: float = 200.0
@export var game_scene: PackedScene = preload("res://Game.tscn")

var time_left: float = 10.0

@onready var ghost: Sprite2D = $NewGhostOg
@onready var cat: Sprite2D = $Cat


func _process(delta: float) -> void:
	# Cat movement
	var input_dir := Input.get_vector(
		"ui_left", "ui_right",
		"ui_up", "ui_down"
	)

	cat.global_position += input_dir * move_speed * delta

	# Ghost follows Cat
	var direction := (cat.global_position - ghost.global_position).normalized()
	ghost.global_position += direction * follow_speed * delta

	# 10-second timer
	time_left -= delta

	if time_left <= 0.0:
		get_tree().change_scene_to_packed(game_scene)
