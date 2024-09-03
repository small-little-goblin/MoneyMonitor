# GlobalDate.gd
extends Node

signal date_changed()

var current_date: Dictionary = {
	"month": Time.get_date_dict_from_system().month,
	"year": Time.get_date_dict_from_system().year
	}

func set_date(date: Dictionary):
	current_date = date
	date_changed.emit()

func get_date() -> Dictionary:
	return current_date

func prevMonth() -> Dictionary:
	if current_date.month == 1:
		return {"month": 12, "year": current_date.year - 1}
	return {"month": current_date.month - 1, "year": current_date.year}
	
func nextMonth() -> Dictionary:
	if current_date.month == 12:
		return {"month": 1, "year": current_date.year + 1}
	return {"month": current_date.month + 1, "year": current_date.year}
