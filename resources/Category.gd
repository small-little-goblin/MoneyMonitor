class_name Category

var id: int
var name: String

static var next_id: int = 0 
static func new_id() -> int:
	next_id += 1
	return next_id - 1


func _init(p_id: int, p_name: String):
	id = p_id
	name = p_name

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name
	}

static func from_dict(data: Dictionary) -> Category:
	return Category.new(data.id, data.name)
