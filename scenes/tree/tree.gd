extends Area2D

@export var burning: bool:
	set(value):
		burning = value
		update_burning()


func _ready() -> void:
	$BurnTimer.timeout.connect(func():
		perish()
	)


func _process(_delta: float) -> void:
	pass


func update_burning():
	$Sprite2D/Fire.visible = burning
	
	if burning:
		$BurnTimer.start()
		$Sprite2D/Fire.play()
	else:
		$BurnTimer.stop()
		$Sprite2D/Fire.stop()


func smoke():
	$Sprite2D/Smoke.visible = true
	$Sprite2D/Smoke.play()

	return get_tree().create_timer(0.15)


func perish():
	burning = false

	smoke().timeout.connect(func():
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.1)
		tween.tween_callback(func():
			queue_free()
		)
		tween.play()
	)


func extinguish():
	burning = false

	smoke().timeout.connect(func():
		pass
	)
