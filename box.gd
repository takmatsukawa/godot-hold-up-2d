extends Area2D

@export var opened_texture: Texture2D
@export var item_scene: PackedScene

var opened = false

func open() -> Node:
	if opened:
		return
		
	opened = true
	$Sprite2D.texture = opened_texture
	
	var item_instance = item_scene.instantiate()
	return item_instance
