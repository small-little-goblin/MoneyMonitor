extends Control

@onready var add_income_button = $HBoxContainer/AddIncomeButton
@onready var add_expense_button = $HBoxContainer/AddExpenseButton
@onready var add_category_button = $HBoxContainer/AddCategoryButton
@onready var show_incomes_button = $HBoxContainer/ShowIncomesButton

@onready var income_popup = $IncomePopup
@onready var expense_popup = $ExpensePopup
@onready var category_popup = $CategoryPopup
@onready var income_list = $IncomeList

func _ready():
	add_income_button.pressed.connect(_on_AddIncome_pressed)
	add_expense_button.pressed.connect(_on_AddExpense_pressed)
	add_category_button.pressed.connect(_on_AddCategory_pressed)
	show_incomes_button.pressed.connect(_on_show_incomes_pressed)
	
func _on_AddIncome_pressed():
	income_popup.popup_centered()

func _on_AddExpense_pressed():
	expense_popup.popup_centered()

func _on_AddCategory_pressed():
	category_popup.popup_centered()

func _on_show_incomes_pressed():
	income_list.refresh_incomes()
	income_list.show()
