extends Node2D

@export var speed := 180.0

@onready var brown = $AnimatedSprite2D2
@onready var ghost = $AnimatedSprite2D3

@onready var brown_player: AnimationPlayer = $AnimatedSprite2D2/AnimationPlayer
@onready var ghost_player: AnimationPlayer = $AnimatedSprite2D3/AnimationPlayer


func _ready():
	play_animation(brown_player)
	play_animation(ghost_player)


func play_animation(player: AnimationPlayer):
	for anim in player.get_animation_list():
		if anim != "RESET":
			player.play(anim)
			return


func _process(delta):
	brown.position.x += speed * delta
	ghost.position.x += speed * delta

	if ghost.global_position.x > get_viewport_rect().size.x + 100:
		get_tree().change_scene_to_file("res://Main/main.tscn")
