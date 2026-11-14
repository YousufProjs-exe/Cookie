extends Sprite2D

@export var target: Node2D
var speed: float = 120.0

func _process(delta: float) -> void:
	if target == null:
		return
	
	var direction := (target.global_position - global_position).normalized()
	
	global_position += direction * speed * delta
	
