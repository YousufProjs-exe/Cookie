
extends Node2D

@export var round_duration := 30.0
@export var ghost_speed := 160.0
@export var player_speed := 260.0
@export var gravity := 1200.0
@export var jump_velocity := -680.0
@export var start_grace := 2.0
@export var next_scene: PackedScene = preload("res://Game_2.tscn")

@onready var daven: CharacterBody2D = $Daven
@onready var ghost: CharacterBody2D = $Ghost
@onready var ghost_sprite: Sprite2D = $Ghost/NewGhostOg
@onready var detection_area: Area2D = $Daven/DetectionArea

var time_left := 30.0
var grace_left := 2.0
var game_running := true
var was_jumping := false

var timer_label: Label


func _ready() -> void:
	time_left = round_duration
	grace_left = start_grace

	daven.collision_layer = 2
	daven.collision_mask = 1

	ghost.collision_layer = 2
	ghost.collision_mask = 1

	detection_area.monitoring = true
	detection_area.collision_mask = 2
	detection_area.body_entered.connect(_on_body_entered)

	var canvas := CanvasLayer.new()
	add_child(canvas)

	timer_label = Label.new()
	timer_label.position = Vector2(20, 20)
	timer_label.add_theme_font_size_override("font_size", 30)
	canvas.add_child(timer_label)

	update_timer()


func _physics_process(delta: float) -> void:
	if not game_running:
		return

	move_ghost()
	move_daven(delta)

	if grace_left > 0:
		grace_left = maxf(grace_left - delta, 0.0)

	time_left = maxf(time_left - delta, 0.0)
	update_timer()

	if time_left <= 0:
		finish_game(true)


func _on_body_entered(body: Node2D) -> void:
	if body == ghost and game_running and grace_left <= 0:
		finish_game(false)


func move_ghost() -> void:
	var direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_key_pressed(KEY_S):
		direction.y += 1

	direction = direction.normalized()

	var intangible := Input.is_key_pressed(KEY_SHIFT)
	ghost.set_collision_mask_value(1, not intangible)

	ghost_sprite.modulate = Color(1, 1, 1, 0.4) if intangible else Color.WHITE

	ghost.velocity = direction * ghost_speed
	ghost.move_and_slide()


func move_daven(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	daven.velocity.x = direction * player_speed

	if not daven.is_on_floor():
		daven.velocity.y += gravity * delta

	if daven.is_on_floor():
		if Input.is_key_pressed(KEY_SPACE) and not was_jumping:
			daven.velocity.y = jump_velocity
			was_jumping = true
	else:
		was_jumping = false

	daven.move_and_slide()


func update_timer() -> void:
	timer_label.text = "TIME: %02d" % int(ceil(time_left))


func finish_game(won: bool) -> void:
	game_running = false

	if won:
		timer_label.text = "YOU WIN!"
		get_tree().change_scene_to_packed(next_scene)
	else:
		timer_label.text = "GAME OVER"
		get_tree().reload_current_scene()
