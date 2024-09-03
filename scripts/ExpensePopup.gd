extends PopupPanel

@onready var name_edit = $VBoxContainer/NameEdit
@onready var amount_edit = $VBoxContainer/AmountEdit
@onready var category_option = $VBoxContainer/CategoryOption
@onready var fixed_check = $VBoxContainer/HBoxContainer2/FixedCheck
func _ready():
	$VBoxContainer/HBoxContainer/Ok.pressed.connect(_on_OkButton_pressed)
	$VBoxContainer/HBoxContainer/Cancel.pressed.connect(_on_CancelButton_pressed)
	DataManager.data_updated.connect(update_category_options)
	popup_hide.connect(_on_popup_hide)
	update_category_options()


func update_category_options():
	category_option.clear()
	for category in DataManager.categories:
		category_option.add_item(category.name)

func _on_OkButton_pressed():

	var expense = Expense.new(
		Expense.new_id(),
		name_edit.text,
		int(amount_edit.text),
		GlobalDate.get_date(),
		category_option.selected,
		fixed_check.button_pressed
	)
	DataManager.add_expense(expense)
	hide()

func _on_CancelButton_pressed():
	hide()

func _on_popup_hide():
	name_edit.text = ""
	amount_edit.text = ""
	category_option.selected = -1
	fixed_check.button_pressed = false
