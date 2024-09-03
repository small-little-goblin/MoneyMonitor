extends PopupPanel

@onready var name_edit = $VBoxContainer/NameEdit
@onready var amount_edit = $VBoxContainer/AmountEdit
@onready var fixed_check = $VBoxContainer/HBoxContainer2/FixedCheck
func _ready():
	$VBoxContainer/HBoxContainer/Ok.pressed.connect(_on_OkButton_pressed)
	$VBoxContainer/HBoxContainer/Cancel.pressed.connect(_on_CancelButton_pressed)
	popup_hide.connect(_on_popup_hide)

func _on_OkButton_pressed():
	var income = Income.new(
		Income.new_id(),
		name_edit.text,
		int(amount_edit.text),
		GlobalDate.get_date(),
		fixed_check.button_pressed
	)
	DataManager.add_income(income)
	hide()

func _on_CancelButton_pressed():
	hide()

func _on_popup_hide():
	name_edit.text = ""
	amount_edit.text = ""
	fixed_check.button_pressed = false
