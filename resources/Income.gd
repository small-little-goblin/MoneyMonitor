class_name Income

var id: int
var name: String
var amount: int
var date: Dictionary
var fixed: bool

static var next_id: int = 0
static func new_id() -> int:
	next_id += 1
	return next_id - 1

func _init(p_id: int, p_name: String, p_amount: int, p_date: Dictionary, p_fixed: bool):
	id = p_id
	name = p_name
	amount = p_amount
	date = p_date.duplicate()
	fixed = p_fixed

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"amount": amount,
		"date": date,
		"fixed": fixed
	}

static func from_dict(data: Dictionary) -> Income:
	return Income.new(data.id, data.name, data.amount, data.date, data.fixed)
