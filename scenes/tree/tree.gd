extends Area2D

@export var burning: bool:
	set(value):
		burning = value
		update_burning()

@export var extinguished := false:
	set(value):
		extinguished = value
		burning = false
		update_extinguished()


signal perishing


func _ready() -> void:
	$BurnTimer.timeout.connect(func():
		perish()
	)

	mouse_entered.connect(func():
		if burning:
			extinguished = true
	)

	$Sprite2D/Water.animation_finished.connect(func():
		$Sprite2D/Water.hide()
	)


func _process(_delta: float) -> void:
	pass


func update_burning():
	$Sprite2D/Fire.visible = burning
	
	if burning:
		$BurnTimer.start()
		$Sprite2D/Fire.play()

		$FireLightSound.play()
	else:
		$BurnTimer.stop()
		$Sprite2D/Fire.stop()


func update_extinguished():
	if extinguished:
		$SizzleSound.play()

		$Sprite2D/Water.show()
		$Sprite2D/Water.play()

		smoke().timeout.connect(func():
			$Sprite2D/Smoke.stop()

			get_tree().create_timer(0.15).timeout.connect(func():
				extinguished = false
			)
		)
	else:
		$Sprite2D/Water.stop()
		$Sprite2D/Water.hide()


func smoke():
	$Sprite2D/Smoke.show()
	$Sprite2D/Smoke.play()

	var timer = get_tree().create_timer(0.15)

	timer.timeout.connect(func():
		$Sprite2D/Smoke.hide()	
	)

	return timer


func perish():
	perishing.emit()

	burning = false

	smoke().timeout.connect(func():
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.1)
		tween.tween_callback(func():
			queue_free()
		)
		tween.play()
	)

