using Godot;
using System;
using System.Collections.Generic;

public class Player : KinematicBody2D {
	[Export]
	private int WalkSpeed = 200;

	private int SprintSpeed = 500;
	[Export]
	private int Acceleration = 2500;
	[Export]
	private int Friction = 1000;

	enum State {
		Move, Sprint, Attack
	}

	State CurrentState = State.Move;

	private Vector2 velocity = Vector2.Zero;

	private bool isRight = true;
	public override void _Ready() {
		
	}
	public override void _PhysicsProcess(float delta) {
		switch(CurrentState)
		{
			case State.Sprint:
				SprintState(delta);
				break;
			case State.Attack:
				AttackState(delta);
				break;
			default:
				MoveState(delta);
				break;
		}
	}

	public void MoveState(float delta) {
		var input_vector = Vector2.Zero; // The player's movement vector (0,0)
		input_vector.x = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");
		input_vector.y = Input.GetActionStrength("move_down") - Input.GetActionStrength("move_up");
		input_vector = input_vector.Normalized();

		var animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");

		animatedSprite.Play();

		if (input_vector != Vector2.Zero) {
			velocity = velocity.MoveToward(input_vector * WalkSpeed, Acceleration * delta); 
		} else {
			velocity = velocity.MoveToward(Vector2.Zero, Friction * delta);
		}

		if (input_vector.x > 0) {
			isRight = true;
			animatedSprite.Animation = "Move Right";
		} else if (input_vector.x < 0) {
			isRight = false;
			animatedSprite.Animation = "Move Left";
		} else {
			if (isRight) {
				if (input_vector.y != 0) {
					animatedSprite.Animation = "Move Right";
				} else {
					animatedSprite.Animation = "Idle Right";
				}
			} else {
				if (input_vector.y != 0) {
					animatedSprite.Animation = "Move Left";
				} else {
					animatedSprite.Animation = "Idle Left";
				}
			}
			
		}

		velocity = MoveAndSlide(velocity);

		if (Input.IsActionPressed("sprint")) {
			CurrentState = State.Sprint;
		}
	}

	public void SprintState(float delta) {
		var input_vector = Vector2.Zero; // The player's movement vector (0,0)
		input_vector.x = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");
		input_vector.y = Input.GetActionStrength("move_down") - Input.GetActionStrength("move_up");
		input_vector = input_vector.Normalized();

		var animatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");

		animatedSprite.Play();

		if (input_vector != Vector2.Zero) {
			velocity = velocity.MoveToward(input_vector * SprintSpeed, Acceleration * delta); 
		} else {
			velocity = velocity.MoveToward(Vector2.Zero, Friction * delta);
		}

		if (input_vector.x > 0) {
			isRight = true;
			animatedSprite.Animation = "Sprint Right";
		} else if (input_vector.x < 0) {
			isRight = false;
			animatedSprite.Animation = "Sprint Left";
		} else {
			if (isRight) {
				if (input_vector.y != 0) {
					animatedSprite.Animation = "Sprint Right";
				} else {
					animatedSprite.Animation = "Idle Right";
				}
			} else {
				if (input_vector.y != 0) {
					animatedSprite.Animation = "Sprint Left";
				} else {
					animatedSprite.Animation = "Idle Left";
				}
			}
			
		}

		velocity = MoveAndSlide(velocity);

		if (!Input.IsActionPressed("sprint")) {
			CurrentState = State.Move;
		}
	}

	public void AttackState(float delta) {

	}

	public override void _Input(InputEvent @event) {
		if (@event.IsActionPressed("pickup")){
			GetNode<Area2D>("PickupZone").Call("pickup", this);
		}
	}
}
