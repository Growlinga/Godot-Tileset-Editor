
extends CanvasLayer

const editor_script = preload("editor.tscn")

onready var editor = editor_script.instance()
onready var file_dialog = get_node("file_dialog")

func _ready():
	add_child(editor)
	get_node("Button").connect("pressed", self, "open_editor")
	editor.connect("save_requested", self, "_on_save_requested")
	editor.connect("load_requested", self, "_on_load_requested")
	
	file_dialog.set_access(FileDialog.ACCESS_RESOURCES)
	file_dialog.add_filter("*.res")
	file_dialog.add_filter("*.tres")
	file_dialog.add_filter("*.xml")
	file_dialog.connect("file_selected",self,"_on_file_selected")

func open_editor():
	editor.popup_centered()

func _on_save_requested():
	editor.hide()
	file_dialog.set_title("Save tileset template as...")
	file_dialog.set_mode(FileDialog.MODE_SAVE_FILE)
	file_dialog.show()

func _on_load_requested():
	editor.hide()
	file_dialog.set_title("Open tileset template from...")
	file_dialog.set_mode(FileDialog.MODE_OPEN_FILE)
	file_dialog.show()
	
func _on_export_requested():
	print("TODO: export the tileset")

func _on_file_selected(file_path):
	var do_what = file_dialog.get_mode()
	if do_what == FileDialog.MODE_SAVE_FILE:
		editor.tileset.set_path(file_path)
		var result = ResourceSaver.save(file_path, editor.tileset)
		print("File saved at: " + Globals.globalize_path(file_path))
	if do_what == FileDialog.MODE_OPEN_FILE:
		var tileset = load(file_path)
		if tileset extends preload("tileset.gd"):
			editor.reload(tileset)
			print("Open file from: " + Globals.globalize_path(file_path))
	