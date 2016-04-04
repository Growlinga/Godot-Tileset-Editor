tool

extends WindowDialog

export(NodePath) var name_path
export(NodePath) var scene_tree_path

# region variables

var shape_name = "" setget set_shape_name,get_shape_name

onready var name_edit = get_node(name_path)
#onready var scene_tree = get_node(scene_tree_path)

# region getters and setters

func set_shape_name(val):
	name_edit.set_text(val)

func get_shape_name():
	return name_edit.get_text()

func import(what):
	self.shape_name = ""
	if what == 1: # Collision
		pass
	if what == 2: # Occluder
		pass
	if what == 3: # Navpoly
		pass
	var scene_tree=get_node("VBoxContainer/scene_tree")
	scene_tree.clear()
#	scene_tree.create_item(
