extends Control

@onready var total_income_label = $VBoxContainer/TotalIncome
@onready var remaining_budget_label = $VBoxContainer/RemainingBudget

func update_stats():
	var date = GlobalDate.get_date()
	var stats = DataManager.get_monthly_stats(date)
	var remain_percentage: int = float(stats.remaining_budget) / float(stats.total_income) * 100
	if stats.total_income == 0:
		remain_percentage = 0
	total_income_label.text = "Total Income: " + str(stats.total_income) + " €"
	remaining_budget_label.text = "Remaining Budget: " + str(stats.remaining_budget) + " € (" + str(remain_percentage) + "%)"
	
	# Change color of remaining budget based on value
	if stats.remaining_budget < 0:
		remaining_budget_label.add_theme_color_override("font_color", Color.RED)
	else:
		remaining_budget_label.add_theme_color_override("font_color", Color.GREEN)
