extends Control

@onready var expense_list = $VBoxContainer/ScrollContainer/Expenses
@onready var mod_popup = $ModPopup
@onready var expense_name_edit = mod_popup.get_node("VBoxContainer/NameChangeEdit")
@onready var expense_cost_edit = mod_popup.get_node("VBoxContainer/CostChangeEdit")
@onready var expense_fix_check = mod_popup.get_node("VBoxContainer/HBoxContainer2/FixedCheck")
@onready var expense_delete_check = mod_popup.get_node("VBoxContainer/HBoxContainer3/DeleteCheck")
var selected_id: int = -1
var expenses = []

func _ready():
	$ModPopup/VBoxContainer/HBoxContainer/Ok.pressed.connect(_on_OkButton_pressed)
	$ModPopup/VBoxContainer/HBoxContainer/Cancel.pressed.connect(mod_popup.hide)
	

func update_expenses(new_expenses: Array = []):
	expenses = new_expenses
	refresh_list()

func refresh_list():
	# Clear existing items
	for child in expense_list.get_children():
		child.queue_free()
	
	# Add expenses to the list
	for expense in expenses:
		var item = create_expense_item(expense)
		expense_list.add_child(item)

func create_expense_item(expense: Expense):
	var item = Button.new()
	item.set_custom_minimum_size(Vector2(0, 30))
	var hbox = HBoxContainer.new()
	var name_label = Label.new()
	name_label.text = expense.name
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var amount_label = Label.new()
	amount_label.text = str(expense.cost) + " €"
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	item.add_child(hbox)
	hbox.add_child(name_label)
	hbox.add_child(amount_label)
	item.pressed.connect(_on_expense_selected.bind(expense.id))
	return item
	
func _on_expense_selected(expense_id: int):
	var expense: Expense = DataManager.get_expense_by_id(expense_id)
	expense_name_edit.text = expense.name
	expense_cost_edit.text = str(expense.cost)
	expense_fix_check.button_pressed = expense.fixed
	selected_id = expense_id
	mod_popup.show()
	
	
func _on_OkButton_pressed():
	if expense_delete_check.button_pressed:
		DataManager.delete_expense(selected_id)
	else:
		DataManager.update_expense(
			selected_id,
			expense_name_edit.text,
			int(expense_cost_edit.text),
			expense_fix_check.button_pressed
			)
	mod_popup.hide()
	update_expenses()
