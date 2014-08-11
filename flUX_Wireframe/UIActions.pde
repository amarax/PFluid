interface I_UIAction
{
  void execute();
}




class Action_MirrorSelection implements I_UIAction
{
  Action_MirrorSelection()
  {
  }

  void execute()
  {
    if ( world.selectedEntity instanceof EditableRect )
    {
      ( (EditableRect)( world.selectedEntity ) ).mirrorChildren();
    }
  }
}

class Action_ToggleShowPins implements I_UIAction
{
  Action_ToggleShowPins()
  {
  }

  void execute()
  {
    showPins = !showPins;
  }
}

class Action_AddEditableRect implements I_UIAction
{
  Action_AddEditableRect()
  {
  }

  void execute()
  {
    uiModeManager.currentMode = UIMODE_RESIZING;
    EditableRect tNewRect = new EditableRect( new PVector( mouseCursor.position.x, mouseCursor.position.y ) ); 

    EditableElement tParent = editableElement;
    if ( world.selectedEntity instanceof EditableRect )
    {
      tParent = (EditableRect)( world.selectedEntity );
    }
    tParent.addEditableChild( tNewRect );
    
    tNewRect.edgeBeingEdited = 3;

    mouseCursor.focusedEntity = tNewRect;
  }
}

