extends Node

const fireball = preload("res://scenes/fireball/fireball.tscn")

var game_active = false
var game_started = null
var level = 0
var fireball_instance


func _process(_delta: float):
  if is_instance_valid(fireball_instance):
    fireball_instance.speed = 1 + ((Time.get_unix_time_from_system() - game_started) / 25)

  if Input.is_action_just_pressed("start_game"):
    if not game_active:
      start_game()


func start_game():
  game_active = true
  game_started = Time.get_unix_time_from_system()
  level = 0

  new_level()


func end_game():
  game_active = false
  fireball_instance.queue_free()

  for tree in $Map.get_trees():
    tree.queue_free()


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

    var pure_trees = $Map.get_trees(func(child):
      return not child.burning and not child.extinguished and (child != target)  
    )
    var extinguished_trees = $Map.get_trees(func(child):
      return child.extinguished == true
    )
    
    if pure_trees.size() >= 1:
      var new_target = pure_trees.pick_random()
      fireball_instance.target = new_target
    elif extinguished_trees.size() >= 1:
      for tree in extinguished_trees:
        tree.extinguished = false
    else:
      end_game()
  )

  fireball_instance.target = $Map.get_trees().pick_random()
