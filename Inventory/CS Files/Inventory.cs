using Godot;
using System;

public class Inventory : Node2D
{
    GridContainer invSlots = null;
    Item holdingItem = null;
    public override void _Ready()
    {
        GD.Load("res://Inventory/CS Files/Slot.cs");
        invSlots = GetNode<GridContainer>("GridContainer");
        foreach(Panel slot in invSlots.GetChildren()) {
            slot.Connect("gui_input", this, "slot_gui_input", new Godot.Collections.Array() {slot});
        }
    }

    public void slot_gui_input(InputEvent @event, Slot slot){
        if (@event is InputEventMouseButton && @event.IsActionPressed("left_click")) {
            if (holdingItem != null) {
                if (slot.item != null) {
                    slot.putIntoSlot(holdingItem);
                    holdingItem = null;
                } else { //swap
                    var temp = slot.item;
                    slot.pickedFromSlot();
                    InputEventMouseButton mouseEvent = (InputEventMouseButton)@event;
                    temp.GlobalPosition = mouseEvent.GlobalPosition;
                    slot.putIntoSlot(holdingItem);
                    holdingItem = temp;
                }
            } else if (slot.item != null) {
                holdingItem = slot.item;
                slot.pickedFromSlot();
                holdingItem.GlobalPosition = GetGlobalMousePosition();
            }
        }
    }
    public override void _Input(InputEvent @event)
    {
        if(holdingItem != null) {
            holdingItem.GlobalPosition = GetGlobalMousePosition();
        } 
    }
}

