extends TextureRect
class_name Floor

@export var builders: PackedScene
@export var merchants : PackedScene
@export var masons: PackedScene
@export var shepherds: PackedScene
@export var warriors: PackedScene
@export var theives: PackedScene

@export var floorName : String

var numChars = 0
var maxChars = 5
var hasWarrior = false
var hasThief = false

@onready var rng = RandomNumberGenerator.new()

func _ready():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func change_name(n : String):
	floorName = n
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func thief_appears():
	if(!has_warrior() and rng.randi_range(1,100) <= 5):
		add_character(Thief.new())
		return

func has_warrior() -> bool:
	return hasWarrior

func add_character(key : Character):
	key.reparent($Characters)
	var yPos = 92
	var xPos = key.position.x
	if(key.position.x > 325):
		xPos = 325
	elif(key.position.x < 26):
		xPos = 26
	
	match str(key).to_lower():
		"builder":
			yPos = 86
		"merchant":
			yPos = 86
		"warrior":
			hasWarrior = true
		"thief":
			hasThief = true
			numChars -= 1
	key.position = Vector2(xPos,yPos)
	print(key.position)

func update():
	$Label.text = floorName + ": " + str(numChars) + "/" + str(maxChars)

func is_full():
	return (numChars >= maxChars)

func collect_resources() -> Dictionary:
	var resources := {
		"bricks" : 0,
		"gold" : 0,
		"hubris" : 0,
	}
	for c in $Characters.get_children():
		resources["gold"] += c.get_gold()
		resources["bricks"] += c.get_bricks()
		resources["hubris"] += c.get_hubris()
		if(c is Thief and c.stolen_enough()):
			c.queue_free()
	return resources

func _on_characters_child_order_changed():
	if($Characters != null):
		numChars = $Characters.get_child_count()
		update()
