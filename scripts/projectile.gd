extends Node2D


# set the projectile damage
var projectile_damage = 0;

# set the projectile explosion radius
var projectile_explosion_radius = 0;

# set the projectile speed
var projectile_speed = 0;

# set the projectile lifetime
var projectile_lifetime = 0;

var projectile_max_range = 0;

var projectile_starting_position = Vector2(0,0);

# set the target
var _target = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func fire(target):
	_target = target;

