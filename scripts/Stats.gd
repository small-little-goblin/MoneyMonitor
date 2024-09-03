extends Control

@onready var total_income_label = $VBoxContainer/TotalIncome
@onready var remaining_budget_label = $VBoxContainer/RemainingBudget

var total_income: int = 0
var remaining_budget: int = 0

func _ready():
	GlobalDate.date_changed.connect(update_stats)

func update_stats(stats: Dictionary = {}):
	if not stats.is_empty():
		total_income = stats.get("total_income", 0)
		remaining_budget = total_income
	
	total_income_label.text = "Total Income: $" + str(total_income)
	remaining_budget_label.text = "Remaining Budget: $" + str(remaining_budget)
	
	# Change color of remaining budget based on value
	if remaining_budget < 0:
		remaining_budget_label.add_theme_color_override("font_color", Color.RED)
	else:
		remaining_budget_label.add_theme_color_override("font_color", Color.GREEN)
