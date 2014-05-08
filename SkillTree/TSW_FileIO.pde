String abilityTreeSaveDataFile = "data/abilityTreeState.json";


void saveAbilityTreeWidgetState( TSW_UIControl_AbilityTree aAbilityTreeControl )
{
  JSONArray tAbilityTreeSaveData = new JSONArray();

  JSONArray tSelectedAbilitiesList = new JSONArray();
  tSelectedAbilitiesList.append( "Selected Abilities" );
  for ( TSW_UIControl_Ability iAbilityControl : aAbilityTreeControl.getSelectedAbilities() )
  {
    tSelectedAbilitiesList.append( iAbilityControl.linkedNode.name );
  }

  tAbilityTreeSaveData.append( tSelectedAbilitiesList );

  saveJSONArray( tAbilityTreeSaveData, abilityTreeSaveDataFile );
}

void restoreAbilityTreeWidgetState( TSW_UIControl_AbilityTree aAbilityTreeControl )
{
  JSONArray tAbilityTreeSaveData = loadJSONArray( abilityTreeSaveDataFile );

  JSONArray tSelectedAbilitiesList = null;

  for ( int iRootArrayIndex = 0; iRootArrayIndex < tAbilityTreeSaveData.size(); ++iRootArrayIndex )
  {
    JSONArray tArray = tAbilityTreeSaveData.getJSONArray( iRootArrayIndex );

    if ( tArray.getString( 0 ).equals( "Selected Abilities" ) )
    {
      tSelectedAbilitiesList = tArray;
    }
  }
  
  if( tSelectedAbilitiesList != null )
  {
    aAbilityTreeControl.clearSelectedAbilities();
    
    String[] tSelectedAbilityNames = tSelectedAbilitiesList.getStringArray();
    
    for( int iListIndex = 1; iListIndex < tSelectedAbilitiesList.size(); ++iListIndex )
    {
      for( TSW_Ability iAbility : aAbilityTreeControl.abilityTree.abilities )
      {
        if( iAbility.name.equals( tSelectedAbilityNames[ iListIndex ] ) )
        {
          aAbilityTreeControl.selectAbility( (TSW_UIControl_Ability)( iAbility.linkedControl ) );
          break;
        }
      }
    }
  }
}

