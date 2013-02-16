class TSW_WikiParser
{
  final color WHEEL_BRANCH_COLOR = color( 0, 0.0, 0.3, 0.5 );
  TSW_AbilityTree_ColorSet colorSet_default = new TSW_AbilityTree_ColorSet( WHEEL_BRANCH_COLOR, WHEEL_BRANCH_COLOR, WHEEL_BRANCH_COLOR );
  
  final color MELEE_BRANCH_COLOR = color( 30, 0.6, 0.6, 0.5 );
  final color MELEE_ABILITY_LOCKED_COLOR = color( 30, 0.7, 0.4, 0.5 );
  final color MELEE_ABILITY_UNLOCKED_COLOR = color( 30, 0.7, 0.8, 0.5 );
  TSW_AbilityTree_ColorSet colorSet_melee = new TSW_AbilityTree_ColorSet( MELEE_BRANCH_COLOR, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR );
  
  final color MAGIC_BRANCH_COLOR = color( 210, 0.5, 0.75, 0.5 );
  final color MAGIC_ABILITY_LOCKED_COLOR = color( 210, 0.6, 0.5, 0.5 );
  final color MAGIC_ABILITY_UNLOCKED_COLOR = color( 210, 0.6, 0.8, 0.5 );
  TSW_AbilityTree_ColorSet colorSet_magic = new TSW_AbilityTree_ColorSet( MAGIC_BRANCH_COLOR, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR );
  
  final color RANGED_BRANCH_COLOR = color( 5, 0.45, 0.7, 0.5 );
  final color RANGED_ABILITY_LOCKED_COLOR = color( 5, 0.55, 0.5, 0.5 );
  final color RANGED_ABILITY_UNLOCKED_COLOR = color( 5, 0.55, 0.8, 0.5 );
  TSW_AbilityTree_ColorSet colorSet_ranged = new TSW_AbilityTree_ColorSet( RANGED_BRANCH_COLOR, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR );
  
  final color MISC_BRANCH_COLOR = color( 120, 0.35, 0.5, 0.5 );
  final color MISC_ABILITY_COLOR_LOCKED = color( 120, 0.35, 0.5, 0.5 );
  final color MISC_ABILITY_COLOR_UNLOCKED = color( 120, 0.35, 0.8, 0.5 );
  TSW_AbilityTree_ColorSet colorSet_misc = new TSW_AbilityTree_ColorSet( MISC_BRANCH_COLOR, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED );
  
  final color AUX_BRANCH_COLOR = color( 180, 0.3, 0.6, 0.5 );
  final color AUX_ABILITY_COLOR_LOCKED = color( 180, 0.3, 0.33, 0.5 );
  final color AUX_ABILITY_COLOR_UNLOCKED = color( 180, 0.3, 0.8, 0.5 );
  TSW_AbilityTree_ColorSet colorSet_auxiliary = new TSW_AbilityTree_ColorSet( AUX_BRANCH_COLOR, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED );


  TSW_WikiParser()
  {
  }
  
  public void populate( TSW_AbilityTree aAbilityTree )
  {
    TSW_AbilityBranch tMainWheel = aAbilityTree.addNewBranch( "Main", WHEEL_BRANCH_COLOR, null );
    TSW_AbilityBranch tAuxiliaryWheel = aAbilityTree.addNewBranch( "Auxiliary", WHEEL_BRANCH_COLOR, null );

    TSW_AbilityBranch tMainMeleeBranch = null;
    TSW_AbilityBranch tMainMagicBranch = null;
    TSW_AbilityBranch tMainRangedBranch = null;


    aAbilityTree.cLevels = 1;

    
    ArrayList<XML> tFilesToParse = new ArrayList<XML>();
    tFilesToParse.add( loadXML( "Blade abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Hammer abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Fists abilities - The Secret World Wiki (TSWW).htm" ) );

    tFilesToParse.add( loadXML( "Subversion - The Secret World Wiki (TSWW).htm" ) );

    tFilesToParse.add( loadXML( "Blood Magic abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Chaos abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Elementalism abilities - The Secret World Wiki (TSWW).htm" ) );

    tFilesToParse.add( loadXML( "Turbulence - The Secret World Wiki (TSWW).htm" ) );

    tFilesToParse.add( loadXML( "Shotgun abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Pistols abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Assault Rifle abilities - The Secret World Wiki (TSWW).htm" ) );

    tFilesToParse.add( loadXML( "Survivalism - The Secret World Wiki (TSWW).htm" ) );

    tFilesToParse.add( loadXML( "Chainsaw abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Quantum abilities - The Secret World Wiki (TSWW).htm" ) );
    tFilesToParse.add( loadXML( "Rocket Launcher abilities - The Secret World Wiki (TSWW).htm" ) );
    
    TSW_AbilityBranch tCurrentBranch = tMainWheel;
    TSW_AbilityTree_ColorSet tColorSet = colorSet_default;
    for( XML iXML : tFilesToParse )
    {
      if( iXML != null )
      {
        XML tElement = iXML.getChildren( "head" )[0];
        tElement = tElement.getChildren( "title" )[0];
        String tBranchName = trim( tElement.getContent() );

        int tSubStringIndex = tBranchName.indexOf( " abilities" );
        if( tSubStringIndex == -1 ) 
        { 
          tSubStringIndex = tBranchName.indexOf( " - " ); 
        }

        tBranchName = tBranchName.substring( 0, tSubStringIndex );

        if( tBranchName.equals( "Chainsaw" ) || tBranchName.equals( "Quantum" ) || tBranchName.equals( "Rocket Launcher" ) )
        {
          tCurrentBranch = tAuxiliaryWheel;
          tColorSet = colorSet_auxiliary;
        }
        else
        {
          if( tBranchName.equals( "Blade" ) || tBranchName.equals( "Hammer" ) || tBranchName.equals( "Fists" ) )
          {
            if( tMainMeleeBranch == null )
            {
              tMainMeleeBranch = aAbilityTree.addNewBranch( "Melee", colorSet_melee.branch, tMainWheel );
            }
            
            tCurrentBranch = tMainMeleeBranch;
            tColorSet = colorSet_melee;
          }
          else if( tBranchName.equals( "Blood Magic" ) || tBranchName.equals( "Chaos" ) || tBranchName.equals( "Elementalism" ) )
          {
            if( tMainMagicBranch == null )
            {
              tMainMagicBranch = aAbilityTree.addNewBranch( "Magic", colorSet_magic.branch, tMainWheel );
            }
            
            tCurrentBranch = tMainMagicBranch;
            tColorSet = colorSet_magic;
          }
          else if( tBranchName.equals( "Shotgun" ) || tBranchName.equals( "Pistols" ) || tBranchName.equals( "Assault Rifle" ) )
          {
            if( tMainRangedBranch == null )
            {
              tMainRangedBranch = aAbilityTree.addNewBranch( "Ranged", colorSet_ranged.branch, tMainWheel );
            }
            
            tCurrentBranch = tMainRangedBranch;
            tColorSet = colorSet_ranged;
          }
          else if( tBranchName.equals( "Subversion" ) || tBranchName.equals( "Turbulence" ) || tBranchName.equals( "Survivalism" ) )
          {
            tCurrentBranch = tMainWheel;
            tColorSet = colorSet_misc;
          }
          else
          {
            tCurrentBranch = null;
            tColorSet = colorSet_default;
          }
        }

        TSW_AbilityBranch tWeaponBranch = null;
        tWeaponBranch = aAbilityTree.addNewBranch( tBranchName, tColorSet.branch, tCurrentBranch );

        tElement = iXML.getChildren( "body" )[0];
        XML tContentElement = recursiveFindElement( tElement, "div", "id", "mw-content-text" );
        
        XML[] tBranches = tContentElement.getChildren();
        
        TSW_AbilityBranch tMinorBranch = null;
        
        int i = 0;
        while( i < tBranches.length )
        {
          if( tBranches[i].getName().equals( "h3" ) )
          {
            tMinorBranch = aAbilityTree.addNewBranch( trim( tBranches[i].getContent() ), tColorSet.branch, tWeaponBranch );
          }
          else if( tBranches[i].getName().equals( "ul" ) )
          {
            if( tMinorBranch == null )
            {
              tMinorBranch = tWeaponBranch;
            }
            
            int tListItemIndex = 0;
            while( tListItemIndex < tBranches[i].getChildCount() )
            {
              XML tAbilityEntry = tBranches[i].getChildren( "li" )[tListItemIndex];
              String tAbilityName = tAbilityEntry.getChildren( "a" )[0].getContent();
  
              XML tAbilityPointsXML = recursiveFindElement( tAbilityEntry, "span", "style", "color:green" );
  
              if( tAbilityPointsXML != null )
              {
                String tAbilityPointsString = tAbilityPointsXML.getContent();
                int tAbilityPoints = int( trim( tAbilityPointsString.substring( 0, tAbilityPointsString.length() - 2 ) ) );
  
                TSW_Ability tAbility = aAbilityTree.addNewAbility( tAbilityName, tAbilityPoints, tColorSet.ability_locked, tColorSet.ability_unlocked, tMinorBranch );
                
                XML tDescriptionXML = tAbilityEntry.getChildren( "dl" )[0];
                tAbility.description = tDescriptionXML.getContent();
              }
              
              ++tListItemIndex;
            }
          }

          
          ++i;
        }
      }
    }
    
    aAbilityTree.cLevels = 4;
  }
  
  XML recursiveFindElement( XML aElement, String aName, String aAttribute, String aID )
  {
    if( aElement.getName().equals( aName ) )
    {
      if( aElement.getString( aAttribute ).equals( aID ) )
      {
        return aElement;
      }
    }
    
    XML tFoundElement = null;
    
    int i = 0;
    while( i < aElement.getChildCount() && tFoundElement == null )
    {
      tFoundElement = recursiveFindElement( aElement.getChild( i ), aName, aAttribute, aID );
      
      ++i;
    }
    
    return tFoundElement;
  }
}
