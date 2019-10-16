extends Node


var current_scene = null
# 3 minutes per round
# 5 rounds
# Time countdown between rounds
# Time it takes for a player to respawn
export var secondsInRound = 10
export var rounds = 5
export var timeBetweenRounds = 4
export var spawnTime = 3

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
	#Reset control points here (calls function to set owner names to "Nobody" and set new random score value)
	PlayerVariables.resetControlPoints()
	PlayerVariables.player1Points = 0
	PlayerVariables.player2Points = 0
	current_scene.get_node("GUI/Player1Score").reset()
	current_scene.get_node("GUI/Player2Score").reset()
	#Send players back to their spawns
	current_scene.get_node("Player1").position = current_scene.get_node("Player1Spawn").position
	current_scene.get_node("Player2").position = current_scene.get_node("Player2Spawn").position
	
	#Increment round
	current_scene.get_node("GUI/Round").adjust(1)
	currentRound += 1
	
	# Here can put the functionality that pauses the round 
	# and shows a countdown to begin the new round
	print("display round countdown 3,2,1")
	

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
		gameEnd("Player2")
	if PlayerVariables.player1Score > PlayerVariables.player2Score:
		gameEnd("Player1")
	else:
		gameEnd("Draw")

#Shows winner and transition appropriately
func gameEnd(whoWon):
	#Put transition to appropriate game end screen
	#get_tree().change_scene("GameComplete.tscn")
	match whoWon:
		"Player1":
			print("Player 1 wins")
		"Player2":
			print("Player 2 wins")
		_:
			print("Draw")
	pass

#Sends the passed in player back to their spawn point
func playerDeath(player):
	var spawn = str(player, "Spawn")
	
	print(player, " died.")
	
	# Remove the player in the most janky way possible (send to bottom of map to fall until location reset :D)
	current_scene.get_node(player).position = current_scene.get_node("LevelBoundaries/Bottom").position
	# Don't respawn player if time left in round is less than respawn time, to prevent a double spawn after new round starts
	if (int(current_scene.get_node("GUI/TimeLabel").timeLeft) < spawnTime):
		pass
	else:
		yield(get_tree().create_timer(spawnTime), "timeout")
		current_scene.get_node(player).position = current_scene.get_node(spawn).position






