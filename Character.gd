extends KinematicBody2D

const UP = Vector2(0,-1)
const ACCELERATION = 50
const GRAVITY = 30
const JUMP_HEIGHT = -400
const MAX_SPEED = 200

export var id = 0

var velocity = Vector2()

func get_input():
	var friction = false
	#velocity = Vector2()
	velocity.y += GRAVITY
	
	if Input.is_action_pressed('right_%s' % id):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed('left_%s' % id):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
	else:
		friction = true
	
	if is_on_floor():
		if Input.is_action_just_pressed('up_%s' % id):
			velocity.y = JUMP_HEIGHT
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.05)
	
	print(velocity)
	velocity = move_and_slide(velocity, UP)


func _physics_process(delta):
	get_input()
	#velocity = move_and_slide(velocity, UP)