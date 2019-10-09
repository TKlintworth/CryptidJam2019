extends Node

# 3 minutes per round
# 5 rounds
export var secondsInRound = 3
export var rounds = 5

#Start at round 1 
var currentRound = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Call function that runs rounds
	runRounds()
	

#Need to add to this to actually reset the round
#TODO
func resolve_round():
	if PlayerVariables.player1Points > PlayerVariables.player2Points:
		PlayerVariables.player1Score += 1
	if PlayerVariables.player2Score > PlayerVariables.player1Points:
		PlayerVariables.player2Score += 1
	#Reset control points here
	PlayerVariables.controlPoints = []
	
	#Reset player locations #TODO temporary reloading scene
	get_tree().reload_current_scene()
	
	#Increment round
	currentRound += 1

#Manages round transitions 
func runRounds():
	#Game Loop
	while(currentRound < rounds):
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

