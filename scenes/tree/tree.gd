extends Area2D

# Unix time when last extinguished
var last_extinguished = 0

# Burning variable
@export var burning: bool:
	# React on change
	set(value):
		burning = value
		update_burning()

# Declares extinguished variable
@export var extinguished := false:
	# React on change
	set(value):
		# If the tree has extinguished, despawn it
		if value and ((Time.get_unix_time_from_system() - last_extinguished) < 0.25):
			perish()
			return

		last_extinguished = Time.get_unix_time_from_system()

		# Trigger audiovisual updates
		extinguished = value
		burning = false
		update_extinguished()

# Signal to external scripts that tree is about to despawn
signal perishing

# Matches fire audiovisuals to burning state
func update_burning():
	$Sprite2D/Fire.visible = burning

	if burning:
		$BurnTimer.start()
		$Sprite2D/Fire.play()

		$FireLightSound.play()
	else:
		$BurnTimer.stop()
		$Sprite2D/Fire.stop()

# Matches water audiovisuals to extinguished state
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

# Displays smoke
func smoke():
	$Sprite2D/Smoke.show()
	$Sprite2D/Smoke.play()

	var timer = get_tree().create_timer(0.15)

	timer.timeout.connect(func():
		$Sprite2D/Smoke.hide()
	)

	return timer

# Despawns tree
func perish():
	perishing.emit()

	burning = false

	# After smoke subsides, animate tree death and despawn it
	smoke().timeout.connect(func():
		var tween = get_tree().create_tween()

		tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.1)
		tween.tween_callback(func():
			queue_free()
		)

		tween.play()
	)

# Runs every frame
func _process(_delta: float) -> void:
	pass

# Runs on initialization
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
