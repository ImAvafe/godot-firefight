extends Area2D

@export var target: Node2D:
	set(value):
		target = value
		chase_target()

signal hit_target


func _ready():
	area_entered.connect(func(area):
		if area == target:
			get_tree().create_timer(0.5).timeout.connect(func():
				area.queue_free()
				hit_target.emit()
			)
	)


func _enter_tree():
	$AnimatedSprite2D.play()


func chase_target():
	if !target:
		pass

	var tree_size = target.find_child("Sprite2D").get_rect().size
	var target_position = target.position - Vector2(0, tree_size.y)

	var tween = create_tween()
	tween.tween_property($".", "position", target_position, (target_position - position).length() / 500)
	tween.play()
