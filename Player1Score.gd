tool extends Label

export (int) var paddingLength = 8

var value = 0
var rounds = GameManager.rounds

func _ready():
	update()

func reset():
	value = 0
	update()

func adjust(adjustment):
	value += adjustment
	update()

func update():
	# Show total amount of rounds
	if self.name == "Round":
		$Value.text = ("%0*d /%d" % [paddingLength, value, rounds])
	else:
		$Value.text = ("%0*d" % [paddingLength, value])