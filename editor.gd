
extends WindowDialog

const tileset_script = preload("tileset.gd")

# region export variables

export(NodePath) var texture_list_path
export(NodePath) var texture_view_path

export(NodePath) var tool_layout_path
export(NodePath) var tool_collision_path
export(NodePath) var tool_occluder_path
export(NodePath) var tool_navpoly_path

export(NodePath) var layout_toolbox_path
export(NodePath) var shape_toolbox_path
export(NodePath) var shape_list_path

export(NodePath) var layout_x_off_path
export(NodePath) var layout_y_off_path
export(NodePath) var layout_w_path
export(NodePath) var layout_h_path
export(NodePath) var layout_x_sep_path
export(NodePath) var layout_y_Sep_path

export(NodePath) var save_path
export(NodePath) var load_path
export(NodePath) var new_path
export(NodePath) var export_path

export(NodePath) var add_texture_path
export(NodePath) var del_texture_path

# region control variables

onready var mode_buttons = [
get_node(tool_layout_path),
get_node(tool_collision_path),
get_node(tool_occluder_path),
get_node(tool_navpoly_path)
]

onready var resource_buttons = [
get_node(save_path),
get_node(load_path),
get_node(new_path),
get_node(export_path)
]

onready var texture_buttons = [
get_node(add_texture_path),
get_node(del_texture_path)
]

onready var layout_spinboxes = [
get_node(layout_x_off_path),
get_node(layout_y_off_path),
get_node(layout_w_path),
get_node(layout_h_path),
get_node(layout_x_sep_path),
get_node(layout_y_Sep_path)
]

onready var texture_list = get_node(texture_list_path)
onready var texture_view = get_node(texture_view_path)

onready var layout_toolbox = get_node(layout_toolbox_path)
onready var shape_toolbox = get_node(shape_toolbox_path)

onready var shape_list = get_node(shape_list_path)

# region signals

signal save_requested()
signal load_requested()
signal export_requested()

#region variables

var current_mode = -1
var current_tex_id = -1
var changing_texture = false
onready var tileset = tileset_script.new()
onready var texture_dialog = FileDialog.new()

#region constructors

func _ready():
	for i in range(mode_buttons.size()):
		mode_buttons[i].connect("pressed", self, "_on_change_mode", [i])
	for i in range(resource_buttons.size()):
		resource_buttons[i].connect("pressed", self, "_on_resource_btn", [i])
	for i in range(texture_buttons.size()):
		texture_buttons[i].connect("pressed", self, "_on_texture_btn", [i])
	for i in layout_spinboxes:
		i.connect("value_changed", self, "_layout_changed")
	
	texture_dialog.set_access(FileDialog.ACCESS_RESOURCES)
	texture_dialog.add_filter("*.atex")
	texture_dialog.add_filter("*.cube")
	texture_dialog.add_filter("*.dds")
	texture_dialog.add_filter("*.jpeg")
	texture_dialog.add_filter("*.jpg")
	texture_dialog.add_filter("*.ltex")
	texture_dialog.add_filter("*.png")
	texture_dialog.add_filter("*.pvr")
	texture_dialog.add_filter("*.res")
	texture_dialog.add_filter("*.tex")
	texture_dialog.add_filter("*.tres")
	texture_dialog.add_filter("*.webp")
	texture_dialog.add_filter("*.watex")
	texture_dialog.add_filter("*.xltex")
	texture_dialog.add_filter("*.xml")
	texture_dialog.add_filter("*.xtex")
	texture_dialog.connect("file_selected",self,"_on_texture_added")
	get_parent().add_child(texture_dialog)
	texture_dialog.set_size(Vector2(700,500))
	
	texture_list.connect("item_selected",self,"_on_texture_selected")
	
	_on_change_mode(0)

# region functions

func update_editor():
	texture_list.clear()
	var idx = 0
	for tex in tileset.tileset_data:
		texture_list.add_item(tex.texture.get_name(),tex.texture)
		var w = min(64, tex.texture.get_width())
		var h = min(64, tex.texture.get_height())
		texture_list.set_item_icon_region(idx,Rect2(0,0,w,h))
		idx += 1
	pass

func _on_change_mode(mode):
	for i in range(mode_buttons.size()):
		mode_buttons[i].set_pressed(mode==i)
	if mode == current_mode && !changing_texture:
		return
	current_mode = mode
	if (mode==0):
		layout_toolbox.show()
		shape_toolbox.hide()
	else:
		layout_toolbox.hide()
		shape_toolbox.show()
		shape_toolbox.get_node("title/label").set_text(mode_buttons[mode].get_text())
		shape_toolbox.get_node("title/icon").set_texture(mode_buttons[mode].get_button_icon())
#	update_editor()

func _on_resource_btn(wich):
	if wich == 0: # Save
		emit_signal("save_requested")
	if wich == 1: # Load
		emit_signal("load_requested")
	if wich == 2: # New
		tileset = tileset_script.new()
		current_tex_id=-1
		texture_list.clear()
		shape_list.clear()
		texture_view.set_texture(null)
	if wich == 3: # Load
		emit_signal("export_requested")
	

func _on_texture_btn(wich):
	if wich == 0: # Add
		hide()
		texture_dialog.set_title("Save tileset template as...")
		texture_dialog.set_mode(FileDialog.MODE_OPEN_FILE)
		texture_dialog.popup_centered()
	if wich == 1: # Remove
		pass

func _layout_changed(val):
	if !changing_texture:
		if current_tex_id >= 0 and current_tex_id < tileset.tileset_data.size():
			tileset.tileset_data[current_tex_id].x_off = layout_spinboxes[0].get_value()
			tileset.tileset_data[current_tex_id].y_off = layout_spinboxes[1].get_value()
			tileset.tileset_data[current_tex_id].w = layout_spinboxes[2].get_value()
			tileset.tileset_data[current_tex_id].h = layout_spinboxes[3].get_value()
			tileset.tileset_data[current_tex_id].x_sep = layout_spinboxes[4].get_value()
			tileset.tileset_data[current_tex_id].y_sep = layout_spinboxes[5].get_value()

func _on_texture_added(file_path):
	var res = load(file_path)
	if !res extends Texture:
		print("ERROR: El recurso no era una textura!!")
		show()
		return
	var tex = tileset_script.TextureProperties.new()
	tileset.tileset_data.push_back(tex)
	tex.texture=res
	texture_list.add_item(tex.texture.get_name(),tex.texture)
	var w = min(64, tex.texture.get_width())
	var h = min(64, tex.texture.get_height())
	texture_list.set_item_icon_region(tileset.tileset_data.size()-1,Rect2(0,0,w,h))
	show()
	print(str(tileset.tileset_data.size()))

func _on_texture_selected(id):
	changing_texture = true
	current_tex_id = id
	var tex = tileset.tileset_data[id]
	texture_view.set_texture(tex.texture)
	var values = [tex.x_off,tex.y_off,tex.w,tex.h,tex.x_sep,tex.y_sep]
	for i in range(values.size()):
		layout_spinboxes[i].set_value(values[i])
	_on_change_mode(current_mode)
	changing_texture = false

func reload(res):
	tileset=res
	texture_list.clear()
	shape_list.clear()
	texture_view.set_texture(null)
	current_tex_id=-1
	for i in range(res.tileset_data.size()):
		var tex = res.tileset_data[i]
		texture_list.add_item(tex.texture.get_name(),tex.texture)
		var w = min(64, tex.texture.get_width())
		var h = min(64, tex.texture.get_height())
		texture_list.set_item_icon_region(tileset.tileset_data.size()-1,Rect2(0,0,w,h))
		show()
