extends Node

#How often to accumulate points from control points
#var tick = tickTimer(tickTime) 

#Points are for within round, score is round score
var player1Points = 0
var player2Points = 0
var player1Score = 0
var player2Score = 0


var ownedByPlayer1 = []
var ownedByPlayer2 = []
var controlPoints = []

#Amount of seconds to wait before accumulating points
var tickTime = 3
#Is the game still going
var gameNotFinished = true

func scoreAccumulator():
	for point in controlPoints:
		if point.getOwnerName() == "Player1":
			player1Points += point.score
		if point.getOwnerName() == "Player2":
			player2Points += point.score

	print("Player 1 points: ", player1Points)
	print("Player 2 points: ", player2Points)


func _ready():
	controlPoints = []
	while(gameNotFinished):
		yield(get_tree().create_timer(tickTime), "timeout")
		scoreAccumulator()
		
	
# Called when the node enters the scene tree for the first time.
#Add all control points in the scene to global list
func addControlPoint(point):
	controlPoints.append(point)
	print(controlPoints)
	

func currentScore():
	pass
