extends Control

@onready var date_label = $HBoxContainer/Date
@onready var left_arrow = $HBoxContainer/LeftArrow
@onready var right_arrow = $HBoxContainer/RightArrow
@onready var date_picker_popup = $DatePickerPopup
@onready var month_option = $DatePickerPopup/VBoxContainer/HBoxContainer/MonthOptionButton
@onready var year_spinbox = $DatePickerPopup/VBoxContainer/HBoxContainer2/YearSpinbox
@onready var ok_button = $DatePickerPopup/VBoxContainer/HBoxContainer3/Ok
@onready var cancel_button = $DatePickerPopup/VBoxContainer/HBoxContainer3/Cancel

enum Month {
	JANUARY = 1, FEBRUARY, MARCH, APRIL, MAY, JUNE,
	JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER
}

const MONTH_NAMES = {
	Month.JANUARY: "January",
	Month.FEBRUARY: "February",
	Month.MARCH: "March",
	Month.APRIL: "April",
	Month.MAY: "May",
	Month.JUNE: "June",
	Month.JULY: "July",
	Month.AUGUST: "August",
	Month.SEPTEMBER: "September",
	Month.OCTOBER: "October",
	Month.NOVEMBER: "November",
	Month.DECEMBER: "December"
}

func _ready():
	update_date_display()
	left_arrow.pressed.connect(_on_LeftArrow_pressed)
	right_arrow.pressed.connect(_on_RightArrow_pressed)
	date_label.gui_input.connect(_on_Label_gui_input)
	ok_button.pressed.connect(_on_DatePickerPopup_confirmed)
	cancel_button.pressed.connect(_on_DatePickerPopup_canceled)
	GlobalDate.date_changed.connect(update_date_display)


func update_date_display():
	var current_date = GlobalDate.get_date()
	date_label.text = "%s %d" % [MONTH_NAMES[current_date.month], current_date.year]

func _on_LeftArrow_pressed():
	GlobalDate.set_date(GlobalDate.prevMonth())

func _on_RightArrow_pressed():
	GlobalDate.set_date(GlobalDate.nextMonth())

func _on_Label_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		show_date_picker()

func show_date_picker():
	var current_date = GlobalDate.get_date()
	month_option.clear()
	for month in Month.values():
		month_option.add_item(MONTH_NAMES[month], month)
	month_option.select(current_date.month - 1)
	year_spinbox.value = current_date.year
	
	date_picker_popup.popup_centered()

func _on_DatePickerPopup_confirmed():
	var new_date = {"month": month_option.get_selected_id(), "year": year_spinbox.value}
	GlobalDate.set_date(new_date)
	date_picker_popup.hide()

func _on_DatePickerPopup_canceled():
	date_picker_popup.hide()
