extends Node

const fireball = preload("res://scenes/fireball/fireball.tscn")

var game_active = false
var level = 0
var fireball_instance


func _process(_delta: float):
  if Input.is_action_just_pressed("start_game"):
    if not game_active:
      start_game()


func start_game():
  game_active = true
  level = 0

  new_level()


func end_game():
  game_active = false
  fireball_instance.queue_free()


func new_level():
  level += 1

  $Map.despawn_trees()
  $Map.spawn_trees()

  if is_instance_valid(fireball_instance):
    fireball_instance.queue_free()

  fireball_instance = fireball.instantiate()

  add_child(fireball_instance)

  fireball_instance.hit_target.connect(func(target):
    if !is_instance_valid(target):
      target = null

    if target:
      target.burning = true

    var trees = $Map.get_trees(target)
    
    if trees.size() >= 1:
      var new_target = trees.pick_random()
      fireball_instance.target = new_target
    else:
      end_game()
  )

  fireball_instance.target = $Map.get_trees().pick_random()
