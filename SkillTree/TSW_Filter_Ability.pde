

class TSW_Filter_Ability
{
  boolean active;

  protected TSW_Filter_Ability()
  {
    active = true;
  }

  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    return true;
  }

  public TSW_UIControl_Filter_AbilityWheel createNewLinkedControl()
  {
    return new TSW_UIControl_Filter_AbilityWheel();
  }
}


class TSW_Filter_Ability_SearchString extends TSW_Filter_Ability
{
  String searchString;

  protected TSW_Filter_Ability_SearchString( String aSearchString )
  {
    searchString = aSearchString;
  }
}


class TSW_Filter_Ability_Name extends TSW_Filter_Ability_SearchString
{
  public TSW_Filter_Ability_Name( String aSearchString )
  {
    super( aSearchString );
  }


  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    return aAbility.name.toLowerCase().contains( searchString.toLowerCase() );
  }

  public TSW_UIControl_Filter_AbilityWheel createNewLinkedControl()
  {
    return new TSW_UIOverlay_Filter_Ability_Name();
  }
}


class TSW_Filter_Ability_Description extends TSW_Filter_Ability_SearchString
{
  public TSW_Filter_Ability_Description( String aSearchString )
  {
    super( aSearchString );
  }


  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    return aAbility.description.toLowerCase().contains( searchString.toLowerCase() );
  }


  public TSW_UIControl_Filter_AbilityWheel createNewLinkedControl()
  {
    return new TSW_UIOverlay_Filter_Ability_Description();
  }
}

class TSW_Filter_Ability_Unlocked extends TSW_Filter_Ability
{
  boolean unlocked;

  public TSW_Filter_Ability_Unlocked( boolean aUnlocked )
  {
    unlocked = aUnlocked;
  }

  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    if ( aAbility.linkedControl != null )
    {
      return ( (TSW_UIControl_Ability)aAbility.linkedControl ).unlocked == unlocked;
    }

    return false;
  }


  public TSW_UIControl_Filter_AbilityWheel createNewLinkedControl()
  {
    return new TSW_UIOverlay_Filter_Ability_Unlocked();
  }
}

class TSW_Filter_Ability_Selected extends TSW_Filter_Ability
{
  boolean selected;

  public TSW_Filter_Ability_Selected( boolean aSelected )
  {
    selected = aSelected;
  }

  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    if ( aAbility.linkedControl != null )
    {
      return abilityTreeWidget.isAbilitySelected( (TSW_UIControl_Ability)aAbility.linkedControl ) == selected;
    }

    return false;
  }


  public TSW_UIControl_Filter_AbilityWheel createNewLinkedControl()
  {
    return new TSW_UIOverlay_Filter_Ability_Selected();
  }
}

