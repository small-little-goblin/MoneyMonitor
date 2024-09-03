extends Control

@onready var date_display = $VBoxContainer/DateDisplay
@onready var menu = $VBoxContainer/HBoxContainer2/Menu
@onready var stats = $VBoxContainer/Stats
@onready var category_list = $VBoxContainer/HBoxContainer/CategoryList
@onready var expense_list = $VBoxContainer/HBoxContainer/ExpenseList

func _ready():
	GlobalDate.date_changed.connect(_on_date_changed)
	DataManager.data_updated.connect(_on_data_updated)
	category_list.category_selected.connect(_on_category_selected)
	# Initial update
	_on_date_changed()

func _on_date_changed():
	stats.update_stats()
	update_category_list()
	expense_list.update_expenses()
	
	
func _on_data_updated():
	stats.update_stats()
	update_category_list()

func update_category_list():
	var current_date = GlobalDate.get_date()
	var categories_with_expenses = DataManager.get_categories_with_expenses(current_date.year, current_date.month)
	category_list.refresh_categories(categories_with_expenses)


func _on_category_selected(category):
	var current_date = GlobalDate.get_date()
	var category_expenses = DataManager.get_expenses_for_category(category, current_date.year, current_date.month)
	expense_list.update_expenses(category_expenses)
