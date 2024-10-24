extends Character
class_name Thief

var numSteals := 0
var maxSteals := 5
func get_hubris() -> int:
	if(!get_parent().get_parent().has_warrior()):
		return rng.randi_range(-10,-1)
	queue_free()
	return 0

func get_gold() -> int:
	if(!get_parent().get_parent().has_warrior()):
		numSteals += 1
		return rng.randi_range(-10,-1)
	queue_free()
	return 0

func stolen_enough() -> bool:
	return (numSteals >= maxSteals)

func _to_string():
	return "thief"
