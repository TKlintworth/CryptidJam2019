extends Node

#export var pointsToWinRound = 1000
#export var roundSeconds = 180

var current_scene = null
#Points are for within round, score is round score
var player1Points = 0
var player2Points = 0
var player1Score = 0
var player2Score = 0

var controlPoints = []

#Amount of seconds to wait before accumulating points
var tickTime = 3
#Is the game still going
var gameNotFinished = true

#Add points to total points based on control points owned
func scoreAccumulator():
	for point in controlPoints:
		if point.getOwnerName() == "Player1":
			player1Points += point.score
			current_scene.get_node("GUI/Player1Score").adjust(point.score)
		if point.getOwnerName() == "Player2":
			player2Points += point.score
			current_scene.get_node("GUI/Player2Score").adjust(point.score)

	#print("Player 1 points: ", player1Points)
	#print("Player 2 points: ", player2Points)


func _ready():
	#Get current scene
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	
	controlPoints = []
	while(gameNotFinished):
		yield(get_tree().create_timer(tickTime), "timeout")
		scoreAccumulator()
		
	
# Called when the node enters the scene tree for the first time.
#Add all control points in the scene to global list
func addControlPoint(point):
	controlPoints.append(point)
	print(controlPoints)
	
