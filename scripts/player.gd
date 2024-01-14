extends CharacterBody2D
const SELECT_RADIUS = 75;
var players_moves: Array[Vector2] = [];
var players_attacks: Array[Vector2] = [];
var hoverable_move_cancel_index = -1;
var move_speed = 50;
var rotate_speed = 0.001;
var turret_rotate_speed = 0.4;
var my_name;
var _is_selected = false;


@export var MAX_FIRE_RANGE = 360;
@export var MIN_FIRE_RANGE = 0; 
@export var projectile: Node2D=null;;
func _ready():
	pass
func _draw():
	pass
	if _is_selected:
		draw_circle(Vector2(0,0), SELECT_RADIUS,Color(0.3,0.7,0.3,0.5))
		#draw_circle(Vector2(0,0), MAX_FIRE_RANGE,)
		var points = 50;
		if MAX_FIRE_RANGE:
			draw_arc(Vector2(0,0), MAX_FIRE_RANGE, 0, TAU, points, Color(1,0,0))
		if MIN_FIRE_RANGE:
			draw_arc(Vector2(0,0), MIN_FIRE_RANGE, 0, TAU, points, Color(1,0,0))

func select():
	_is_selected=true;
func deselect():
	_is_selected=false;
	
func set_fire_target(pos):
	# make sure the point is in the givven range
	var distance = position.distance_to(pos);
	#print('fire distance: ', distance, 'current pos: ', position, ' target: ', pos);
	if distance > MAX_FIRE_RANGE or distance < MIN_FIRE_RANGE:
		return;
	players_attacks.append(pos);
	players_moves.clear();
	
	pass
#func  update_turret(delta):
func update_turret(delta):
	if players_attacks.size() > 0:
		var attack_pos = players_attacks[0]
		var turret = get_node("turret")
		
		# Calculate the angle from the player to the attack position
		var target_angle = (attack_pos - position).angle()
		target_angle -= rotation;
		# Adjust the target angle by subtracting the player's rotation
		#var player_rotation_radians = deg_to_rad(rotation)
		# Add the player's rotation to the turret's rotation
		#print('player_rotation_radians ',player_rotation_radians,' turret.rotation ',turret.rotation,' target_angle ',target_angle, ' diff ', angle_difference(turret.rotation, target_angle), 'rotatio: ', rotation)
		#target_angle += player_rotation_radians
		# Use lerp_angle to smoothly interpolate between the current turret rotation and the target angle
		turret.rotation = lerp_angle(turret.rotation, target_angle, turret_rotate_speed * delta)

		# Check if the turret is close enough to the target angle, and remove the attack from the list
		if abs(angle_difference(turret.rotation, target_angle)) < 0.1:
			players_attacks.remove_at(0)
			
			# create the projectile and fire it
			

func _physics_process(delta):
	update_position(delta);
	update_turret(delta);
	queue_redraw();


func update_position(delta):
	# if there are moves in the array, move the player to the first move in the array
	# we do it by first rotating the player to face the move, then moving the player towards the move
	if players_moves.size() == 0:
		return;
	var move = players_moves[0];
	# rotate the player to face the move
	var target_angle = (move - position).normalized().angle()
	rotation = lerp_angle(rotation, target_angle, 0.5 * delta)


	if abs(angle_difference(rotation, target_angle)) < 0.1:
		# move the player towards the move
		var move_dir = (move - position).normalized();
		velocity = move_dir * move_speed;
		move_and_slide()
		# if the player is close enough to the move, remove the move from the array
		if (move - position).length() < 10:
			print('I made it to point: ', players_moves[0])
			players_moves.remove_at(0);
			velocity = Vector2(0,0);
