class_name FiniteStateMachine
extends Node

@export var state: State
@onready var activity = $SurvivorActivityState
@onready var rest = $SurvivorRestState
@onready var movement = $SurvivorMovementState
@onready var defense = $SurvivorDefenseState
@onready var death = $SurvivorDeathState
@onready var actor = get_parent()

func _ready():
	change_state(state)

func change_state(new_state : State):
	if state is State and state != death:
		state._exit_state()
		if state == activity:
			if actor.target_assignment:
				get_node(actor.target_assignment).set_assigned_survivors(get_path(),false)
		new_state._enter_state()
		state = new_state
