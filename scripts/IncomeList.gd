extends PopupPanel

@onready var income_list = $VBoxContainer/ScrollContainer/Incomes
@onready var list_entry = $ListEntry
@onready var mod_popup = $ModPopup
@onready var income_name_edit = mod_popup.get_node("VBoxContainer/NameChangeEdit")
@onready var income_amount_edit = mod_popup.get_node("VBoxContainer/AmountChangeEdit")
@onready var income_fix_check = mod_popup.get_node("VBoxContainer/HBoxContainer2/FixedCheck")
@onready var income_delete_check = mod_popup.get_node("VBoxContainer/HBoxContainer3/DeleteCheck")
var selected_id: int = -1

func _ready() -> void:
	$ModPopup/VBoxContainer/HBoxContainer/Ok.pressed.connect(_on_OkButton_pressed)
	$ModPopup/VBoxContainer/HBoxContainer/Cancel.pressed.connect(mod_popup.hide)

func refresh_incomes():
	# Clear existing items
	for child in income_list.get_children():
		child.queue_free()
	
	for income in DataManager.incomes:
		var item = create_income_item(income)
		income_list.add_child(item)

func create_income_item(income_entry: Income):
	var entry = list_entry.duplicate()
	var name_label = entry.get_node("HBoxContainer/Name")
	var amount_label = entry.get_node("HBoxContainer/Amount")
	
	name_label.text = income_entry.name
	amount_label.text = str(income_entry.amount) + " €"
	
	entry.pressed.connect(_on_income_selected.bind(income_entry.id))
	entry.show()
	return entry

func _on_income_selected(income_id: int):
	var income: Income = DataManager.get_income_by_id(income_id)
	income_name_edit.text = income.name
	income_amount_edit.text = str(income.amount)
	income_fix_check.button_pressed = income.fixed
	selected_id = income_id
	mod_popup.show()
	
	
func _on_OkButton_pressed():
	if income_delete_check.button_pressed:
		DataManager.delete_income(selected_id)
	else:
		DataManager.update_income(
			selected_id,
			income_name_edit.text,
			int(income_amount_edit.text),
			income_fix_check.button_pressed
			)
	mod_popup.hide()
	refresh_incomes()
