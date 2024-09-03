extends Node

signal data_updated

const SAVE_PATH = "user://finance_data.json"

var incomes: Array[Income] = []
var expenses: Array[Expense] = []
var categories: Array[Category] = []

var last_open: Dictionary = {}

func _ready():
	load_state()
	is_new_month()

func save_state():
	var save_data = {
		"last_open": last_open,
		"income_idx": Income.next_id,
		"category_idx": Category.next_id,
		"expense_idx": Expense.next_id,
		"incomes": incomes.map(func(income): return income.to_dict()),
		"expenses": expenses.map(func(expense): return expense.to_dict()),
		"categories": categories.map(func(category): return category.to_dict())
	}
	
	var json = JSON.stringify(save_data)
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	save_file.store_string(json)
	save_file.close()

func load_state():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = save_file.get_as_text()
	save_file.close()
	
	var parse_result = JSON.parse_string(json)
	last_open = parse_result.get("last_open", {})
	Income.next_id = parse_result["income_idx"]
	Category.next_id = parse_result["category_idx"]
	Expense.next_id = parse_result["expense_idx"]
	categories.assign(parse_result["categories"].map(func(cat_dict): return Category.from_dict(cat_dict)))
	incomes.assign(parse_result["incomes"].map(func(inc_dict): return Income.from_dict(inc_dict)))
	expenses.assign(parse_result["expenses"].map(func(exp_dict): return Expense.from_dict(exp_dict)))

func process_fixed_items(date: Dictionary):
	copy_fixed_items(date)
	last_open = date
	save_state()

func process_overflow(date: Dictionary):
	var last_month_stats: Dictionary = get_monthly_stats(GlobalDate.prevMonth())
	var overflow_amount: int = last_month_stats.remaining_budget
	var new_income = Income.new(
		Income.new_id(), "Overflow last month",
		overflow_amount, date, false)
	add_income(new_income)
	
func is_new_month():
	var date = GlobalDate.get_date().duplicate()
	if last_open.is_empty():
		last_open = date
		save_state()
	if date.year > last_open.year or (
		date.year == last_open.year and date.month > last_open.month
	):
		process_fixed_items(date)
		process_overflow(date)
		
func copy_fixed_items(current_date: Dictionary):
	var incomes_to_copy: Array = []
	var expenses_to_copy: Array = []
	for income in incomes:
		if income.fixed:
			income.fixed = false
			var new_income = Income.new(Income.new_id(), income.name, income.amount, current_date, true)
			incomes_to_copy.append(new_income)
			
	for expense in expenses:
		if expense.fixed:
			expense.fixed = false
			var new_expense = Expense.new(Expense.new_id(), expense.name, expense.cost, current_date, expense.category_id, true)
			expenses_to_copy.append(new_expense)
	
	for income in incomes_to_copy:
		add_income(income)
	for expense in expenses_to_copy:
		add_expense(expense)

func get_category_by_name(ctg_name: String) -> Category:
	for category in categories:
		if category.name == ctg_name:
			return category
	return null

func get_category_by_id(ctg_id: int) -> Category:
	for category in categories:
		if category.id == ctg_id:
			return category
	return null

func get_income_by_id(income_id: int) -> Income:
	for income in incomes:
		if income.id == income_id:
			return income
	return null

func get_expense_by_id(expense_id: int) -> Expense:
	for expense in expenses:
		if expense.id == expense_id:
			return expense
	return null

func add_income(income: Income):
	incomes.append(income)
	save_state()
	data_updated.emit()

func add_expense(expense: Expense):
	expenses.append(expense)
	save_state()
	data_updated.emit()

func add_category(category: Category):
	categories.append(category)
	save_state()
	data_updated.emit()

func delete_income(id: int):
	for i in range(incomes.size()):
		if incomes[i].id == id:
			incomes.remove_at(i)
			save_state()
			data_updated.emit()
			return

func update_income(id: int, name: String, amount: int, fixed: bool):
	for income in incomes:
		if income.id == id:
			income.name = name
			income.amount = amount
			income.fixed = fixed
			save_state()
			data_updated.emit()
			return

func delete_expense(id: int):
	for i in range(expenses.size()):
		if expenses[i].id == id:
			expenses.remove_at(i)
			save_state()
			data_updated.emit()
			return

func update_expense(id: int, name: String, cost: int, fixed: bool):
	for expense in expenses:
		if expense.id == id:
			expense.name = name
			expense.cost = cost
			expense.fixed = fixed
			save_state()
			data_updated.emit()
			return
			
func get_monthly_stats(date: Dictionary) -> Dictionary:
	var total_income = 0
	var total_expenses = 0
	
	for income in incomes:
		if income.date.year == date.year and income.date.month == date.month:
			total_income += income.amount
	
	for expense in expenses:
		if expense.date.year == date.year and expense.date.month == date.month:
				total_expenses += expense.cost
	
	return {
		"total_income": total_income,
		"remaining_budget": total_income - total_expenses
	}

func get_yearly_category_expenses(year: int) -> Dictionary:
	var category_totals = {}
	for category in categories:
		category_totals[category.name] = 0
	for expense in expenses:
		if expense.date.year == year:
			category_totals[get_category_by_id(expense.category_id).name] += expense.cost
	return category_totals
	
func get_yearly_category_expenses_formatted(year: int) -> Array:
	var category_totals = get_yearly_category_expenses(year)
	var formatted_results = []

	for category_name in category_totals.keys():
		formatted_results.append({
			"category": category_name,
			"total": category_totals[category_name]
			})

	formatted_results.sort_custom(func(a, b): return a.total > b.total)
	return formatted_results

func get_categories_with_expenses(year: int, month: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for category in categories:
		var total_expenses = 0
		for expense in expenses:
			if expense.category_id == category.id and expense.date.year == year and expense.date.month == month:
				total_expenses += expense.cost
		result.append({
			"category": category,
			"total_expenses": total_expenses
		})
	return result

func get_expenses_for_category(category_id: int, year: int, month: int) -> Array:
	return expenses.filter(func(expense): 
		return expense.category_id == category_id and expense.date.year == year and expense.date.month == month
	)
