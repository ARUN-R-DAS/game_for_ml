extends CharacterBody2D

var speed = 30
var player_position
@export var player : CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

enum State { CHASE, ORBIT, ATTACK }
var state = State.CHASE

var orbit_radius = 10
var stop_distance = orbit_radius - 2
var orbit_speed = 2.0
var target_angle = 0.0
var attack_position = Vector2.ZERO

func _draw():
	if attack_position != Vector2.ZERO:
		draw_circle(attack_position - global_position, 5, Color.RED)

func _physics_process(delta):
	
	queue_redraw()
	
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
			if attack_position == Vector2.ZERO:
				# Pick a fixed orbit point once
				target_angle = randf() * TAU
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
			if distance > 20:
				state = State.CHASE
				attack_position = Vector2.ZERO  # Clear it

				
	#flipping based on velocity---------------------
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
