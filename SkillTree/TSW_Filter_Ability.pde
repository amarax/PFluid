

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
}


class TSW_Filter_Ability_Name extends TSW_Filter_Ability
{
  String searchString;
  
  public TSW_Filter_Ability_Name( String aSearchString )
  {
    searchString = aSearchString;
  }

  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    return aAbility.name.contains( searchString );
  }
}


class TSW_Filter_Ability_Description extends TSW_Filter_Ability
{
  String searchString;
  
  public TSW_Filter_Ability_Description( String aSearchString )
  {
    searchString = aSearchString;
  }

  public boolean doesAbilityPass( TSW_Ability aAbility )
  {
    return aAbility.description.contains( searchString );
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
    if( aAbility.linkedControl != null )
    {
      return ( (TSW_UIControl_Ability)aAbility.linkedControl ).unlocked == unlocked;
    }
    
    return false;
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
    if( aAbility.linkedControl != null )
    {
      return abilityTreeWidget.isAbilitySelected( (TSW_UIControl_Ability)aAbility.linkedControl ) == selected;
    }

    return false;
  }
}
