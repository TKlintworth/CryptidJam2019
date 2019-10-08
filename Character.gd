extends KinematicBody2D

const UP = Vector2(0,-1)
const ACCELERATION = 100
const GRAVITY = 30
const JUMP_HEIGHT = -600
const MAX_SPEED = 300
const MAX_FALL_SPEED = 1200
#allow double jump
const MAX_JUMP_COUNT = 2

export var id = 0

var jump_count = 0
var velocity = Vector2()

#Handle player input from both characters
func get_input():
	var friction = false
	
	#velocity = Vector2()
	velocity.y += GRAVITY
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
		
	
	if Input.is_action_pressed('right_%s' % id):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
	elif Input.is_action_pressed('left_%s' % id):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
	else:
		friction = true
	
	#If you're on the floor, set jump count to 0, otherwise allow up to 2 jumps
	#Seems to handle a double jump alright
	#TODO clean this code up
	if is_on_floor():
		jump_count = 0
		if Input.is_action_just_pressed('up_%s' % id) and jump_count < MAX_JUMP_COUNT:
			velocity.y = JUMP_HEIGHT
			jump_count += 1
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.2)
	else:
		if Input.is_action_just_pressed('up_%s' % id) and jump_count < MAX_JUMP_COUNT:
			velocity.y = JUMP_HEIGHT
			jump_count += 1
		if friction == true:
			velocity.x = lerp(velocity.x, 0, 0.05)
	
	velocity = move_and_slide(velocity, UP)


func _physics_process(delta):
	get_input()
	#velocity = move_and_slide(velocity, UP)