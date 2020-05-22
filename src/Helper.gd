extends Node

static func is_pig(name):
	var regex = RegEx.new()
	regex.compile("Pig.*")
	var result = regex.search(name)
	
	if result:
		return true
	else:
		return false
