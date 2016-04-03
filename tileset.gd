tool

extends Resource

class TextureProperties:
	var texture = null
	var x_off = 0
	var y_off = 0
	var w = 64
	var h = 64
	var x_sep = 0
	var y_sep = 0
	var collisions_cache = []
	var occluder_cache = []
	var navpoly_cache = []
	var data = {}

var tileset_data = [] #array of TextureProperties

func _get_property_list():
	var d = {}
	var properties = []
	
	d["name"] = "texture_count"
	d["type"] = TYPE_INT
	d["hint"] = "Amount of textures used in this tileset"
	properties.push_back(d)
	
	for i in range(tileset_data.size()):
		var basename = "texture_"+str(i)+"/"
		
		d["name"] = basename+"texture"
		d["type"] = TYPE_OBJECT
		d["hint"] = "Texture"
		properties.push_back(d)
		
		d["name"] = basename+"x_off"
		d["type"] = TYPE_INT
		d["hint"] = "0,99999,1"
		properties.push_back(d)
		
		d["name"] = basename+"w"
		d["hint"] = "1,99999,1"
		properties.push_back(d)
		
		d["name"] = basename+"h"
		properties.push_back(d)
		
		d["name"] = basename+"x_sep"
		d["hint"] = "0,99999,1"
		properties.push_back(d)
		
		d["name"] = basename+"y_sep"
		d["hint"] = "0,99999,1"
		properties.push_back(d)
		
		d["name"] = basename+"collisions_cache"
		d["type"] = TYPE_ARRAY
		d["hint"] = ""
		properties.push_back(d)
		
		d["name"] = basename+"occluder_cache"
		properties.push_back(d)
		
		d["name"] = basename+"navpoly_cache"
		properties.push_back(d)
		
		d["name"] = basename+"data"
		d["type"] = TYPE_DICTIONARY
		properties.push_back(d)
	
	return properties

func _get(property):
	if property=="texture_count":
		return tileset_data.size()
	elif property.begins_with("texture_"):
		var id = int(property.split("/")[0].split("_")[1])
		var data = tileset_data[id]
		property=property.split("/")[1]
		if property == "texture":
			return data.texture
		if property == "x_off":
			return data.x_off
		if property == "y_off":
			return data.y_off
		if property == "w":
			return data.w
		if property == "h":
			return data.h
		if property == "x_sep":
			return data.x_sep
		if property == "y_sep":
			return data.y_sep
		if property == "collisions_cache":
			return data.collisions_cache
		if property == "occluder_cache":
			return data.occluder_cache
		if property == "navpoly_cache":
			return data.navpoly_cache
		if property == "data":
			return data.data
	return null

func _set(property, value):
	if property=="texture_count":
		tileset_data.resize(value)
	elif property.begins_with("texture_"):
		var id = int(property.split("/")[0].split("_")[1])
		var data = tileset_data[id]
		property=property.split("/")[1]
		if property == "texture":
			data.texture = value
		if property == "x_off":
			data.x_off = value
		if property == "y_off":
			data.y_off = value
		if property == "w":
			data.w = value
		if property == "h":
			data.h = value
		if property == "x_sep":
			data.x_sep = value
		if property == "y_sep":
			data.y_sep = value
		if property == "collisions_cache":
			data.collisions_cache = value
		if property == "occluder_cache":
			data.occluder_cache = value
		if property == "navpoly_cache":
			data.navpoly_cache = value
		if property == "data":
			data.data = value



