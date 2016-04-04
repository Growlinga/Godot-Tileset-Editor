
tool

extends EditorPlugin

const editor_script = preload("res://addons/tileset_editor/editor.tscn")

var editor
var file_dialog

var show_editor_btn

#region virtual overrides

func clear(): editor._on_resource_btn(2) # New resource

func handles(object):
	return object extends preload("res://addons/tileset_editor/tileset.gd")

func edit(object):
	if object extends preload("res://addons/tileset_editor/tileset.gd"):
		editor.show()
		editor.reload(object)

# region constructors

func _init():
	show_editor_btn = Button.new()
	editor = editor_script.instance()
	file_dialog = EditorFileDialog.new()
	file_dialog.set_size(Vector2(700,500))

func _ready():
	show_editor_btn.set_text("Tileset Editor...")
	call_deferred("add_child", editor)
	call_deferred("add_child", file_dialog)
	show_editor_btn.connect("pressed", self, "open_editor")
	editor.connect("save_requested", self, "_on_save_requested")
	editor.connect("load_requested", self, "_on_load_requested")
	
	file_dialog.set_access(EditorFileDialog.ACCESS_RESOURCES)
	file_dialog.add_filter("*.res")
	file_dialog.add_filter("*.tres")
	file_dialog.add_filter("*.xml")
	file_dialog.connect("file_selected",self,"_on_file_selected")

func _enter_tree():
	add_control_to_bottom_panel(show_editor_btn,"Tileset")
	add_custom_type("TilesetInfo","Resource",load("res://addons/tileset_editor/tileset.gd"),load("res://addons/tileset_editor/icons/icon_tile_map.png"))

func _exit_tree():
	remove_control_from_bottom_panel(show_editor_btn)
	remove_custom_type("TilesetInfo")

# region functions

func open_editor():
	editor.popup_centered()

func _on_save_requested():
	editor.hide()
	file_dialog.set_title("Save tileset template as...")
	file_dialog.set_mode(EditorFileDialog.MODE_SAVE_FILE)
	file_dialog.popup_centered()

func _on_load_requested():
	editor.hide()
	file_dialog.set_title("Open tileset template from...")
	file_dialog.set_mode(EditorFileDialog.MODE_OPEN_FILE)
	file_dialog.popup_centered()
	
func _on_export_requested():
	print("TODO: export the tileset")

func _on_file_selected(file_path):
	var do_what = file_dialog.get_mode()
	if do_what == EditorFileDialog.MODE_SAVE_FILE:
		editor.tileset.set_path(file_path)
		var result = ResourceSaver.save(file_path, editor.tileset)
		print("File saved at: " + Globals.globalize_path(file_path))
	if do_what == FileDialog.MODE_OPEN_FILE:
		var tileset = load(file_path)
		if tileset extends preload("res://addons/tileset_editor/tileset.gd"):
			editor.reload(tileset)
			print("Open file from: " + Globals.globalize_path(file_path))
	