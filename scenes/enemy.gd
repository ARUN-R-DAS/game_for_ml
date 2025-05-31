extends CharacterBody2D

var speed = 10
var player_position
@export var player : CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

enum State { CHASE, ORBIT, ATTACK }
var state = State.CHASE

var orbit_radius = 20
var stop_distance = orbit_radius - 10.0
var orbit_speed = 2.0
var target_angle = 0.0
var attack_position = Vector2.ZERO

func _physics_process(delta):
	
	z_index = int(global_position.y)
	z_as_relative = false
	
	var player_pos = player.global_position
	var to_player = global_position.direction_to(player_pos)
	var distance = global_position.distance_to(player_pos)

	match state:
		State.CHASE:
			if distance > stop_distance:
				velocity = to_player * speed
				anim.play("walk")
			else:
				state = State.ORBIT
				target_angle = randf() * TAU  # Random angle on the circle
			move_and_slide()
		
		State.ORBIT:
			var angle_step = orbit_speed * delta
			target_angle += angle_step

			# Calculate new orbit position
			attack_position = player_pos + Vector2(cos(target_angle), sin(target_angle)) * orbit_radius
			var dir_to_target = global_position.direction_to(attack_position)
			
			if global_position.distance_to(attack_position) > 5:
				velocity = dir_to_target * speed
				anim.play("walk")
			else:
				velocity = Vector2.ZERO
				state = State.ATTACK
				anim.play("attack")
			move_and_slide()

		State.ATTACK:
			velocity = Vector2.ZERO
			if distance > stop_distance:
				state = State.CHASE
