extends Node

var current_scene = null

# 3 minutes per round
# 5 rounds
# Time countdown between rounds
# Time it takes for a player to respawn
export var secondsInRound = 60
export var rounds = 2
export var timeBetweenRounds = 4
export var spawnTime = 3

#Start at round 1
var currentRound = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


#Need to add to this to actually reset the round
func resolve_round():
	if PlayerVariables.player1Points > PlayerVariables.player2Points:
		PlayerVariables.player1Score += 1
		current_scene.get_node("GUI/Player1Points").adjust(1)
	if PlayerVariables.player2Points > PlayerVariables.player1Points:
		PlayerVariables.player2Score += 1
		current_scene.get_node("GUI/Player2Points").adjust(1)
		
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
	if currentRound < rounds:
		current_scene.get_node("GUI/Round").adjust(1)
	currentRound += 1
	
	# Here can put the functionality that pauses the round 
	# and shows a countdown to begin the new round
	print("display round countdown 3,2,1")
	

#Manages round transitions
func runRounds():
	PlayerVariables.runScoreAccumulator()
	#Start round tracker at 1 
	current_scene.get_node("GUI/Round").adjust(1)
	#Game Loop
	while(currentRound <= rounds):
		#Start the timer that displays remaining time in round
		current_scene.get_node("GUI/TimeLabel/Timer").start(secondsInRound)
		yield(get_tree().create_timer(secondsInRound), "timeout")
		resolve_round()
		#print("Current round: ", currentRound)
	if PlayerVariables.player2Score > PlayerVariables.player1Score:
		gameEnd("Player2")
	elif PlayerVariables.player1Score > PlayerVariables.player2Score:
		gameEnd("Player1")
	else:
		gameEnd("Draw")

#Shows winner and transition appropriately
func gameEnd(whoWon):
	# Reset current round and remove control points from previous game
	currentRound = 1
	PlayerVariables.controlPoints = []
	# Reset player scores after the game ends
	PlayerVariables.player1Score = 0
	PlayerVariables.player2Score = 0
	# Transition to appropriate game end screen
	# Ends the game loop, the yield allows it to end I think. Without it there is a crash w/ socket error 10054
	PlayerVariables.gameNotFinished = false
	yield(get_tree().create_timer(1.0), "timeout")
	goto_scene("res://GameEnd.tscn")
	yield(get_tree().create_timer(1.0), "timeout")
	match whoWon:
		"Player1":
			print("Player 1 wins")
			current_scene.get_node("CenterContainer/Text").set_text("Player 1 wins!")
		"Player2":
			print("Player 2 wins")
			current_scene.get_node("CenterContainer/Text").set_text("Player 2 wins!")
		_:
			print("Draw")
			current_scene.get_node("CenterContainer/Text").set_text("Draw!")

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


# Work in progress for resetting level and all attached logic
func resetLevel():
	PlayerVariables.gameNotFinished = true
	currentRound = 1
	PlayerVariables.controlPoints = []
	PlayerVariables.player1Score = 0
	PlayerVariables.player2Score = 0
	PlayerVariables.resetControlPoints()
	PlayerVariables.player1Points = 0
	PlayerVariables.player2Points = 0
	current_scene.get_node("GUI/Player1Score").reset()
	current_scene.get_node("GUI/Player2Score").reset()

### These from scene Docs ####

func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function in the current scene.
    # Deleting the current scene at this point is
    # a bad idea, because it may still be executing code.
    # This will result in a crash or unexpected behavior.

    # The solution is to defer the load to a later time, when
    # we can be sure that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
    # It is now safe to remove the current scene
    current_scene.free()

    # Load the new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)

    # Optionally, to make it compatible with the SceneTree.change_scene() API.
    #get_tree().set_current_scene(current_scene)



