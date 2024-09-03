extends Control

signal category_selected(category)

@onready var category_list = $VBoxContainer/ScrollContainer/Categories
@onready var list_entry = $ListEntry

func refresh_categories(categories: Array[Dictionary] = []):
	# Clear existing items
	for child in category_list.get_children():
		child.queue_free()
	
	# Add categories to the list
	for category in categories:
		var item = create_category_item(category)
		category_list.add_child(item)

func create_category_item(category_entry: Dictionary):
	var entry = list_entry.duplicate()
	var name_label = entry.get_node("HBoxContainer/Name")
	var sum_label = entry.get_node("HBoxContainer/Sum")
	
	name_label.text = category_entry["category"].name
	sum_label.text = str(category_entry["total_expenses"]) + " €"
	
	entry.pressed.connect(category_selected.emit.bind(category_entry["category"].id))
	entry.show()
	return entry
