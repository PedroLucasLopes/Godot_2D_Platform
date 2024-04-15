extends AnimatableBody2D

@onready var anim := $animation_platform as AnimationPlayer
@onready var respawn_timer := $respawn_timer as Timer
@onready var respawn_position := global_position

@export var respawn_velocity := 3.0

var velocity := Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_triggered := false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity * delta
	position += velocity * delta

func has_collided_with(collision: KinematicCollision2D, collider: CharacterBody2D):
	if !is_triggered:
		is_triggered = true
		anim.play("shake")
		velocity = Vector2.ZERO


func _on_animation_platform_animation_finished(anim_name):
	set_physics_process(true)
	respawn_timer.start(respawn_velocity)


func _on_respawn_timer_timeout():
	set_physics_process(false)
	global_position = respawn_position
	if is_triggered:
		var spawn_tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
		spawn_tween.tween_property($texture, "scale", Vector2(1,1), 0.2).from(Vector2(0,0))
	is_triggered = false
