extends Node


var current_scene = null
# 3 minutes per round
# 5 rounds
export var secondsInRound = 60
export var rounds = 5

#Start at round 1
var currentRound = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get current scene
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	#Start round tracker at 1
	current_scene.get_node("GUI/Round").adjust(1)
	#Call function that runs rounds
	runRounds()
	

#Need to add to this to actually reset the round
#TODO
func resolve_round():
	if PlayerVariables.player1Points > PlayerVariables.player2Points:
		PlayerVariables.player1Score += 1
	if PlayerVariables.player2Score > PlayerVariables.player1Points:
		PlayerVariables.player2Score += 1
		
	#All this could go in a resetLevel function or something
	#Reset control points here
	PlayerVariables.controlPoints = []
	PlayerVariables.player1Points = 0
	PlayerVariables.player2Points = 0
	#Send players back to their spawns
	current_scene.get_node("Player1").position = current_scene.get_node("Player1Spawn").position
	current_scene.get_node("Player2").position = current_scene.get_node("Player2Spawn").position
	
	#Increment round
	current_scene.get_node("GUI/Round").adjust(1)
	currentRound += 1
	

#Manages round transitions 
func runRounds():
	#Game Loop
	while(currentRound < rounds):
		#Start the timer that displays remaining time in round
		current_scene.get_node("GUI/TimeLabel/Timer").start(secondsInRound)
		yield(get_tree().create_timer(secondsInRound), "timeout")
		resolve_round()
		print("Current round: ", currentRound)
	if PlayerVariables.player2Score > PlayerVariables.player1Score:
		print("Player 2 wins")
		gameEnd("Player2")
	if PlayerVariables.player1Score > PlayerVariables.player2Score:
		print("Player 1 wins")
		gameEnd("Player1")
	else:
		print("Draw")
		gameEnd("Draw")

func gameEnd(whoWon):
	#Put transition to appropriate game end screen
	#get_tree().change_scene("GameComplete.tscn")
	pass

