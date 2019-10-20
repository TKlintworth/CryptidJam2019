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
var characterOffset = 64

# Get trap 
var trapScene = preload("res://Trap.tscn")

# Get sprite of player
onready var sprite_node = get_node("Pivot/Body")
# Get node that checks for ability to place a trap
onready var can_place_trap = get_node("Wall/CanPlaceTrap")
var canPlaceTrap = false
var areasInTrapShadow = []
var input_direction = 0
var direction = 1

#Handle player input from both characters
func get_input():
	var friction = false
	
	#velocity = Vector2()
	velocity.y += GRAVITY
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
	
	# Pressing R places a trap for player 1
	if self.name == "Player1":
		if Input.is_action_just_pressed("PlaceTrap"):
			print("Pressed R")
			var trap = trapScene.instance()
			# Add a trap as a child of Level so that Character and Trap are siblings
			get_parent().add_child(trap)
			trap.transform = get_parent().get_node("Player1").transform
			# The character offset is how wide the character is, place trap directly in front of player on X axis
			trap.position += Vector2(characterOffset,0)
	# Pressing Keypad 0 places a trap for player 2
	if self.name == "Player2":
		if Input.is_action_just_pressed("PlaceTrap2"):
			print("Pressed Keypad 0")
			var trap = trapScene.instance()
			# Add a trap as a child of Level so that Character and Trap are siblings
			get_parent().add_child(trap)
			trap.transform = get_parent().get_node("Player2").transform
			# The character offset is how wide the character is, place trap directly in front of player on X axis
			trap.position += Vector2(-characterOffset,0)


	####ADDING COLLIDER FOR TRAP THAT IS IN FRONT OF PLAYER THAT CHECKS FOR RIGHT CONDITIONS
	if Input.is_action_pressed('right_%s' % id):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		#sprite_node.position *= Vector2(-1,0)
	elif Input.is_action_pressed('left_%s' % id):
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		#sprite_node.position *= Vector2(-1,0)
		
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

# Check for the ability to place trap
func _on_TrapShadow_area_entered(area: Area2D):
	if area.name == "CanPlaceTrap":
		areasInTrapShadow.append(area)
		#print("Can place trap : TRUE")
		print(areasInTrapShadow)
		setCanPlaceTrap()
		

func _on_TrapShadow_area_exited(area: Area2D):
	if area.name == "CanPlaceTrap":
		#print("Can place trap : FALSE")
		areasInTrapShadow.pop_front()
		print(areasInTrapShadow)
		setCanPlaceTrap()

func setCanPlaceTrap():
	# Workaround for the situation : leaving one canPlaceTrap zone and immediately entering another : the area exit will
	# fire last even though theyre still in a trapshadow, preventing trap placement when you should be able to
	if(areasInTrapShadow.size() > 0):
		canPlaceTrap = true
		print("Can place trap : TRUE")
	else:
		canPlaceTrap = false
		print("Can place trap : FALSE")