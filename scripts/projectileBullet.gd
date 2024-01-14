extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _target != null:
		# Move toward target
		# If target is reached, deal damage and destroy self
		position = position.move_toward(_target.position, _speed * delta)
		# look_at target
		rotation.look_at(_target.position)

		# if we passed the projectile_max_range then destroy self
		if position.distance_to(projectile_starting_position) > projectile_max_range:
			# destroy self
			queue_free()
	else:
		pass


