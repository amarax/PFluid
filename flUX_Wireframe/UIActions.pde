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
    if( world.selectedEntity instanceof EditableRect )
    {
      ( (EditableRect)( world.selectedEntity ) ).mirrorChildrensPins();
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
