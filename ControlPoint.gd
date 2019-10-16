extends Area2D


export var score = 10
export var lower = 3
export var upper = 15

var ownerName = "Nobody"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Tell global script this control node exists
	PlayerVariables.addControlPoint(self)
	#When first entering, pick score between lower and upper and set the control point label to this value
	set_score(pick_score(lower, upper))

#Pick a score from a range given
func pick_score(lower, upper):
	#Have to call this function before getting a new random number (not super clear on why but it works)
	randomize()
	score = range(lower,upper)[randi()%range(lower,upper).size()]
	return score

func set_score(score):
	print("Setting score as ", score)
	#Have to cast the randomly generated score to a string from an integer
	$CollisionShape2D/ScoreAmount.text = str(score)

func _on_ControlPoint_body_shape_entered(body_id: int, body: PhysicsBody2D, body_shape: int, area_shape: int) -> void:
	#Sends the intersecting physics bodys name to capture function to determine if the control point should
	#transfer ownership
	capture_point(body.name)
	$CollisionShape2D/TextureProgress.value = 100

#Takes a parameter capturerName that either becomes the new owner of the control point or just passes through
func capture_point(capturerName):
	if capturerName != ownerName:
		#Call singleton to change ownership here
		#Set color to team color here or team sprite or whatever
		ownerName = capturerName
		print("new owner: ", ownerName)
	else:
		pass

func getOwnerName():
	return ownerName

#Resets name and score value
func reset():
	ownerName = "Nobody"
	set_score(pick_score(lower, upper))