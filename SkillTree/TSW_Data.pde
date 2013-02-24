
class TSW_CSVParser
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


  TSW_AbilityTree abilityTree;

  TSW_AbilityTree_ColorSet tColorSet;

  TSW_AbilityBranch tMainWheel = null;
  TSW_AbilityBranch tAuxiliaryWheel = null;

  TSW_AbilityBranch tMainMeleeBranch = null;
  TSW_AbilityBranch tMainMagicBranch = null;
  TSW_AbilityBranch tMainRangedBranch = null;

  TSW_AbilityBranch tAuxiliaryMeleeBranch = null;
  TSW_AbilityBranch tAuxiliaryMagicBranch = null;
  TSW_AbilityBranch tAuxiliaryRangedBranch = null;



  TSW_CSVParser()
  {
  }

  public void populate( TSW_AbilityTree aAbilityTree )
  {
    abilityTree = aAbilityTree;

    tMainWheel = abilityTree.addNewBranch( "Main", WHEEL_BRANCH_COLOR, null );
    tAuxiliaryWheel = abilityTree.addNewBranch( "Auxiliary", WHEEL_BRANCH_COLOR, null );

    abilityTree.cLevels = 1;


    CSVReader tReader = new CSVReader( "TSW_Abilities.csv" );
    ArrayList<String> tHeader = new ArrayList<String>();
    ArrayList<String> tSubHeader = new ArrayList<String>();
    ArrayList<String> tEntries = null;

    int i = 0;
    while ( i < 15 )
    {
      tEntries = new ArrayList<String>();

      tHeader = tReader.readCSVLine( false );
      if ( isEmptyLine( tHeader ) ) { 
        tHeader = tReader.readCSVLine( false );
      }

      if ( tHeader.get( 0 ).equals( "Subversion" ) || tHeader.get( 0 ).equals( "Turbulence" ) || tHeader.get( 0 ).equals( "Survivalism" ) )
      {
        tSubHeader = tHeader;
        tHeader = null;
      }
      else if ( tHeader.get( 0 ).equals( "Chainsaw" ) || tHeader.get( 0 ).equals( "Rocket Launcher" ) || tHeader.get( 0 ).equals( "Quantum" ) )
      {
        tSubHeader = tHeader;
        tHeader = null;
      }
      else
      {
        tSubHeader = tReader.readCSVLine( false );
      }

      int tAbilitiesPerMinorBranch = 7;
      int tMinorBranchesPerWeapon = tSubHeader.size();

      for ( int iLineIndex = 0; iLineIndex < 4 * tAbilitiesPerMinorBranch; ++iLineIndex )
      {
        ArrayList<String> tEntriesToAdd = tReader.readCSVLine( false );

        int iIndex = tSubHeader.size();
        while ( iIndex < tEntriesToAdd.size () )
        {
          tEntriesToAdd.remove( iIndex );
        }

        tEntries.addAll( tEntriesToAdd );
      }

      //        for ( String iEntry : tEntries )
      //        {
      //          print(" - " );
      //          println( iEntry );
      //        }

      TSW_AbilityBranch tWeaponBranch = tMainWheel;
      ArrayList<TSW_AbilityBranch> tMinorBranches = new ArrayList<TSW_AbilityBranch>();
      String tWeapon = "";
      if ( tHeader != null )
      {  
        tWeapon = tHeader.get( 0 );
      }
      else
      {
        tWeapon = tSubHeader.get( 0 );
      }
      tWeaponBranch = addBranchForWeapon( tWeapon );

      for ( String iMinorBranchName : tSubHeader )
      {
        if ( trim( iMinorBranchName ).length() == 0 )
          break;

        TSW_AbilityBranch tMinorBranch = abilityTree.addNewBranch( iMinorBranchName, tColorSet.branch, tWeaponBranch );
        tMinorBranches.add( tMinorBranch );
      }

      for ( int iRow = 0; iRow + 4 * tMinorBranchesPerWeapon < tEntries.size(); iRow += 4 * tMinorBranchesPerWeapon )
      {
        int iIndex = 0;
        while ( iIndex < tMinorBranchesPerWeapon )
        {
          String tAbilityName = tEntries.get( iIndex + iRow );
          if ( trim( tAbilityName ).length() == 0 )
            break;

          String tAbilityPointsString = tEntries.get( iIndex + 2 * tMinorBranchesPerWeapon + iRow );
          int tAbilityPoints = int( trim( tAbilityPointsString.substring( 0, tAbilityPointsString.length() - 2 ) ) );

          String tAbilitiesDescription = tEntries.get( iIndex + 3 * tMinorBranchesPerWeapon + iRow );

          TSW_Ability tAbility = abilityTree.addNewAbility( tAbilityName, tAbilityPoints, tColorSet.ability_locked, tColorSet.ability_unlocked, tMinorBranches.get( iIndex ) );
          tAbility.description = tAbilitiesDescription;

          ++iIndex;
        }
      }

      ++i;
    }

    aAbilityTree.cLevels = 4;
  }



  public TSW_AbilityBranch addBranchForWeapon( String aWeapon )
  {
    TSW_AbilityBranch tCurrentBranch = tMainWheel;
    tColorSet = colorSet_default;

    TSW_AbilityBranch tWeaponBranch = null;
    if ( aWeapon.equals( "Chainsaw" ) || aWeapon.equals( "Quantum" ) || aWeapon.equals( "Rocket Launcher" ) )
    {
      tColorSet = colorSet_auxiliary;

      if ( aWeapon.equals( "Chainsaw" ) )
      {
        if ( tAuxiliaryMeleeBranch == null )
        {
          tAuxiliaryMeleeBranch = abilityTree.addNewBranch( "Melee", tColorSet.branch, tAuxiliaryWheel );
        }

        tCurrentBranch = tAuxiliaryMeleeBranch;
      }
      else if ( aWeapon.equals( "Quantum" ) )
      {
        if ( tAuxiliaryMagicBranch == null )
        {
          tAuxiliaryMagicBranch = abilityTree.addNewBranch( "Magic", tColorSet.branch, tAuxiliaryWheel );
        }

        tCurrentBranch = tAuxiliaryMagicBranch;
      }
      else if ( aWeapon.equals( "Rocket Launcher" ) )
      {
        if ( tAuxiliaryRangedBranch == null )
        {
          tAuxiliaryRangedBranch = abilityTree.addNewBranch( "Ranged", tColorSet.branch, tAuxiliaryWheel );
        }

        tCurrentBranch = tAuxiliaryRangedBranch;
      }
      
      return tCurrentBranch;
    }

    if ( aWeapon.equals( "Subversion" ) || aWeapon.equals( "Turbulence" ) || aWeapon.equals( "Survivalism" ) )
    {
      tCurrentBranch = tMainWheel;
      tColorSet = colorSet_misc;
      
      return tCurrentBranch;
    }

    if ( aWeapon.equals( "Blade" ) || aWeapon.equals( "Hammer" ) || aWeapon.equals( "Fists" ) )
    {
      if ( tMainMeleeBranch == null )
      {
        tMainMeleeBranch = abilityTree.addNewBranch( "Melee", colorSet_melee.branch, tMainWheel );
      }

      tCurrentBranch = tMainMeleeBranch;
      tColorSet = colorSet_melee;
    }
    else if ( aWeapon.equals( "Blood Magic" ) || aWeapon.equals( "Chaos" ) || aWeapon.equals( "Elementalism" ) )
    {
      if ( tMainMagicBranch == null )
      {
        tMainMagicBranch = abilityTree.addNewBranch( "Magic", colorSet_magic.branch, tMainWheel );
      }

      tCurrentBranch = tMainMagicBranch;
      tColorSet = colorSet_magic;
    }
    else if ( aWeapon.equals( "Shotgun" ) || aWeapon.equals( "Pistols" ) || aWeapon.equals( "Assault Rifle" ) )
    {
      if ( tMainRangedBranch == null )
      {
        tMainRangedBranch = abilityTree.addNewBranch( "Ranged", colorSet_ranged.branch, tMainWheel );
      }

      tCurrentBranch = tMainRangedBranch;
      tColorSet = colorSet_ranged;
    }
    else
    {
      tCurrentBranch = null;
      tColorSet = colorSet_default;
    }

    tWeaponBranch = abilityTree.addNewBranch( aWeapon, tColorSet.branch, tCurrentBranch );
    return tWeaponBranch;
  }

  public boolean isEmptyLine( ArrayList<String> aStringArray )
  {
    for ( String iString : aStringArray )
    {
      if ( !trim(iString).equals( "" ) )
      {
        return false;
      }
    }

    return true;
  }
}

