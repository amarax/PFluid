

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
    if( active )
    {
      return aAbility.name.contains( searchString );
    }
    
    return true;
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
    if( active )
    {
      return aAbility.description.contains( searchString );
    }
    
    return true;
  }
}
