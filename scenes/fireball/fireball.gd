extends RigidBody2D

@export var target: Node2D:
	set(value):
		target = value
		chase_target()

signal hit_target


func _on_body_entered(body):
	print(body)
	if body == target:
		body.queue_free()
		hit_target.emit()


func _enter_tree():
	$AnimatedSprite2D.play()


func chase_target():
	var tree_size = target.find_child("Sprite2D").get_rect().size
	var target_position = target.position - Vector2(0, tree_size.y)

	var tween = create_tween()
	tween.tween_property($".", "position", target_position, 2)
	tween.play()
