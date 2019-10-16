extends Label

var timeLeft = 0

func _process(delta: float):
	#TODO potentially remove this +1 as i think its a sloppy workaround
	#ex: counter was starting at 2,1,0... this allows 3,2,1...
	timeLeft = str(int($Timer.get_time_left()+1))
	#print(timeLeft)
	set_text(timeLeft)

func getTimeLeft():
	return timeLeft