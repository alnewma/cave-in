extends Control

@onready var like_image = preload("res://ArtAssets/UI/CULiked.png")
@onready var dislike_image = preload("res://ArtAssets/UI/CUDisliked.png")
@onready var produp_image = preload("res://ArtAssets/UI/CUProdUp.png")
@onready var proddown_image = preload("res://ArtAssets/UI/CUProdDown.png")

@onready var effect_image = $background/effect_image
@onready var effect_label = $background/Label

enum update_types {
	LIKE,
	DISLIKE,
	PRODUP,
	PRODDOWN
}

@export var update_type : update_types
@export var survivor_name : String

func _ready():
	match update_type:
		update_types.LIKE:
			effect_image.texture = like_image
			effect_label.text = survivor_name + " liked that"
		update_types.DISLIKE:
			effect_image.texture = dislike_image
			effect_label.text = survivor_name + " disliked that"
		update_types.PRODUP:
			effect_image.texture = produp_image
			effect_label.text = survivor_name + "'s productivity increased"
		update_types.PRODDOWN:
			effect_image.texture = proddown_image
			effect_label.text = survivor_name + "'s productivity decreased"

func _on_timer_timeout() -> void:
	queue_free()
