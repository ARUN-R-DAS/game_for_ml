extends CharacterBody2D

@export var speed: float = 50

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	var direction = Vector2.ZERO
	
	z_index = int(global_position.y)
	z_as_relative = false
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	
	if direction:
		anim.play("walk")
	else:
		anim.play("idle")
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
