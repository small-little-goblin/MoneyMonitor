extends Control

@onready var year_spinbox = $VBoxContainer/HBoxContainer/SpinBox
@onready var yearly_report_container = $VBoxContainer/VBoxContainer/VBoxContainer

func _ready() -> void:
	year_spinbox.value = GlobalDate.get_date().year
	year_spinbox.value_changed.connect(display_distribution)
	DataManager.data_updated.connect(display_distribution.bind(year_spinbox.value))
	display_distribution(year_spinbox.value)
	
func display_distribution(spinbox_value: int) -> void:
	var yearly_expenses = DataManager.get_yearly_category_expenses_formatted(spinbox_value)
	for child in yearly_report_container.get_children():
			child.queue_free()
			
	var total_expenses = 0
	for category_expense in yearly_expenses:
		var hbox = HBoxContainer.new()
		var category_label = Label.new()
		var category_pa = Label.new()
		var category_pm = Label.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		category_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		category_pa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		category_pm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		category_label.text = category_expense.category
		category_pa.text = str(category_expense.total)
		category_pm.text = str(category_expense.total/12)
		hbox.add_child(category_label)
		hbox.add_child(category_pa)
		hbox.add_child(category_pm)
		yearly_report_container.add_child(hbox)
		total_expenses += category_expense.total

	var total_label = Label.new()
	total_label.text = "Total Yearly Expenses: %d €" % total_expenses
	yearly_report_container.add_child(total_label)
