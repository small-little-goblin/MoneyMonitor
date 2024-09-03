extends PopupPanel

@onready var name_edit = $VBoxContainer/NameEdit

func _ready():
	$VBoxContainer/HBoxContainer/Ok.pressed.connect(_on_OkButton_pressed)
	$VBoxContainer/HBoxContainer/Cancel.pressed.connect(_on_CancelButton_pressed)
	popup_hide.connect(_on_popup_hide)

func _on_OkButton_pressed():
	var category: Category = Category.new(
		Category.new_id(),
		name_edit.text
		)
	DataManager.add_category(category)
	hide()

func _on_CancelButton_pressed():
	hide()

func _on_popup_hide():
	name_edit.text = ""
