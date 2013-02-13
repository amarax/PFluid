class TSW_AbilityTree_Generated extends TSW_AbilityTree
{
  public TSW_AbilityTree_Generated()
  {
    super();
    
    
  }
  
  public void populate()
  {
    cLevels = 4;
    
    TSW_AbilityBranch tSuperBranch = null;
    TSW_AbilityBranch tMainBranch = null;
    TSW_AbilityBranch tWeaponBranch = null;
    TSW_AbilityBranch tMinorBranch = null;
    TSW_Ability tAbility = null;
    
    tSuperBranch = addNewBranch( "Main", WHEEL_BRANCH_COLOR, null );
    {
      tMainBranch = addNewBranch( "Melee", MELEE_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "Blades", MELEE_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Method", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "Delicate Strike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Delicate Precision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Balanced Blade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Expose Weakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Dancing Blade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Sharp Blades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Stunning Swirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Technique", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "Immortal Spirit", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Blade Torrent", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Perfect Storm", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Martial Discipline", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Regeneration", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Surging Blades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Fluid Defence", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Wind through Grass", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "Grass Cutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Twist the Knife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Chop Shop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Seven and a Half Samurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny Fulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Four Seasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Tearing of Sky", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Crossing River's Edge", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Running of the Jagged", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sharpening the Senses", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Cutting Artist", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Hammers", MELEE_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Brawn", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Grit", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          
          tMinorBranch = addNewBranch( "Industrial Action", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Brute Force", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Excessive Damage", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sledge Factory", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Battering Works", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Hammer Pit", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Fists", MELEE_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Feral", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Primal", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "The Wilderness", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Outback", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Streets", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Warming Up", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Heat of Battle", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Play with Fire", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }
      }
      
      tMainBranch = addNewBranch( "Turbulence", MISC_BRANCH_COLOR, tSuperBranch );
      {
        tAbility = addNewAbility( "SleightofHand", 9, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "UnfairAdvantage", 12, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "TurntheTables", 16, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Cannonball", 21, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "SpeedFreak", 27, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Tenacity", 34, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "LastResort", 50, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
      }

      tMainBranch = addNewBranch( "Magic", MAGIC_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "Blood Magic", MAGIC_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Profane", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sacred", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Malediction", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Transmission", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Possession", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Wetwork", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chirurgia", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Venamancy", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Chaos", MAGIC_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Theory", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chance", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Teorema", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Value of x", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Collapse", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Building Blocks", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Shell Game", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Fourth Wall", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Elementalism", MAGIC_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Spark", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "React", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Zero Crossing", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Altered States", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Mortality Curve", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Resonance", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Disturbance", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Tempest", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }
      }
      
      tMainBranch = addNewBranch( "Subversion", MISC_BRANCH_COLOR, tSuperBranch );
      {
        tAbility = addNewAbility( "SleightofHand", 9, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "UnfairAdvantage", 12, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "TurntheTables", 16, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Cannonball", 21, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "SpeedFreak", 27, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Tenacity", 34, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "LastResort", 50, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
      }

      tMainBranch = addNewBranch( "Ranged", RANGED_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "Shotgun", RANGED_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Enforce", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Control", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Crackdown", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Restricted Access", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Close Encounters", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Securing the Perimeter", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Hunkering Down", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Tactical Surprise", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Pistols", RANGED_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Profane", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sacred", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Malediction", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Transmission", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Possession", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Wetwork", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chirurgia", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Venamancy", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Assault Rifles", RANGED_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Profane", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sacred", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Malediction", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Transmission", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Possession", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Wetwork", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chirurgia", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Venamancy", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }
      }

      tMainBranch = addNewBranch( "Survivalism", MISC_BRANCH_COLOR, tSuperBranch );
      {
        tAbility = addNewAbility( "Sleight of Hand", 9, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Unfair Advantage", 12, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Turn the Tables", 16, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Cannonball", 21, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Speed Freak", 27, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Tenacity", 34, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Last Resort", 50, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
      }
    }
    
    
    tSuperBranch = addNewBranch( "Auxiliary", WHEEL_BRANCH_COLOR, null );
    {
      tMainBranch = addNewBranch( "Melee", AUX_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
        tWeaponBranch = addNewBranch( "Chainsaw", AUX_BRANCH_COLOR, tMainBranch );
        {
          tAbility = addNewAbility( "PopShot", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rangefinder", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Clusterstruck", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "RocketScience", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "DeathFromAbove", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Warhead", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Biged Button", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
        }
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
      }

      tMainBranch = addNewBranch( "Magic", AUX_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
        tWeaponBranch = addNewBranch( "Quantum", AUX_BRANCH_COLOR, tMainBranch );
        {
          tAbility = addNewAbility( "PopShot", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rangefinder", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Clusterstruck", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "RocketScience", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "DeathFromAbove", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Warhead", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "BigRedButton", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
        }
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
      }

      tMainBranch = addNewBranch( "Ranged", AUX_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
        tWeaponBranch = addNewBranch( "Rocket Launcher", AUX_BRANCH_COLOR, tMainBranch );
        {
          tAbility = addNewAbility( "Pop Shot", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rangefinder", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Clusterstruck", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rocket Science", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Death From Above", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Warhead", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Big Red Button", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
        }
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
      }
    }
  }
  
  protected TSW_AbilityBranch addNewBranch( String aName, color aColor, TSW_AbilityBranch aParentBranch )
  {
    TSW_AbilityBranch tNewBranch = new TSW_AbilityBranch( aName );
    tNewBranch.nodeColor = aColor;
    this.attachBranch( tNewBranch, aParentBranch );
    
    return tNewBranch;
  }
  
  protected TSW_Ability addNewAbility( String aName, int aPoints, color aLockedColor, color aUnlockedColor, TSW_AbilityBranch aParentBranch )
  {
    TSW_Ability tNewAbility = new TSW_Ability( aName, aPoints );
    tNewAbility.nodeLockedColor = aLockedColor;
    tNewAbility.nodeUnlockedColor = aUnlockedColor;
    tNewAbility.nodeColor = aLockedColor;
    this.attachAbility( tNewAbility, aParentBranch );
    
    return tNewAbility;
  }
}
