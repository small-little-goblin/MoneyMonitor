class_name Expense

var id: int
var name: String
var cost: int
var date: Dictionary
var category_id: int
var fixed: bool

static var next_id: int = 0
static func new_id() -> int:
	next_id += 1
	return next_id - 1

func _init(p_id: int, p_name: String, p_cost: int, p_date: Dictionary, p_category: int, p_fixed: bool):
	id = p_id
	name = p_name
	cost = p_cost
	date = p_date.duplicate()
	category_id = p_category
	fixed = p_fixed

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"cost": cost,
		"date": date,
		"category": category_id,
		"fixed": fixed
	}

static func from_dict(data: Dictionary) -> Expense:
	return Expense.new(data.id, data.name, data.cost, data.date, data.category, data.fixed)
