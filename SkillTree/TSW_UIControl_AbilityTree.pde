class TSW_UIControl_AbilityTree extends UIControl
{
  TSW_AbilityTree abilityTree;

  TSW_UIControl_AbilityBranch selectedAbilityBranch;
  private ArrayList<TSW_UIControl_Ability> selectedAbilities;  

  ArrayList<TSW_Filter_Ability> abilityFilters;

  private PVector centerPos;
  float size;

  Global_Float outerRingSize;
  Global_Float innerRingSize;


  int tGrandTotalSize = 1;


  boolean rotatingByDrag;
  float mouseDownAngleOffset;
  float mousePressedAngle;


  private EasingHelper_PVector easingHelper_topPos;
  private EasingHelper_Float easingHelper_size;

  private boolean cLineModeSwitch_PrevValue;

  private DampingHelper_Float dampingHelper_unlockedRatio;

  public TSW_UIControl_AbilityTree( TSW_AbilityTree aAbilityTree, Rectangle aRect )
  {
    super( aRect );

    abilityTree = aAbilityTree;

    selectedAbilityBranch = null;
    selectedAbilities = new ArrayList<TSW_UIControl_Ability>();

    centerPos = new PVector( rect.x + rect.width / 2.0, rect.y + rect.height / 2.0 );
    size = 1;

    rotatingByDrag = false;
    mouseDownAngleOffset = 0;
    mousePressedAngle = 0;
  }

  public void setup()
  {
    super.setup();

    outerRingSize = global_outerRingSize;
    innerRingSize = global_innerRingSize;

    size = outerRingSize.value;

    createControlsForChildAbilityNodes( abilityTree.rootNode ); 

    abilityFilters = new ArrayList<TSW_Filter_Ability>();


    easingHelper_topPos = new EasingHelper_PVector( new PVector( centerPos.x, centerPos.y - size ) );
    easingHelper_size = new EasingHelper_Float( pow( size, 2 ) );

    dampingHelper_unlockedRatio = new DampingHelper_Float( 0.1, 0 );
  }

  public void update()
  {
    super.update();

    if ( global_lineMode.value != cLineModeSwitch_PrevValue )
    {
      float tTransitionTime = 2;
      easingHelper_topPos.start( easingHelper_topPos.getValue(), tTransitionTime );
      easingHelper_size.start( easingHelper_size.getValue(), tTransitionTime );
    } 
    cLineModeSwitch_PrevValue = global_lineMode.value;

    if ( global_lineMode.value )
    {
      size = 10000;

      centerPos.x = height / 2 + 100;
      //centerPos.x = 200;
      centerPos.y = height * 0.65 + size;
    }
    else
    {
      centerPos.x = height / 2 + 100;
      centerPos.y = height / 2;

      size = outerRingSize.value;

      easingHelper_size.currentValue = pow( size, 2 );
    }

    easingHelper_size.update( pow( size, 2 ) );
    easingHelper_topPos.update( new PVector( centerPos.x, centerPos.y - size ) );

    PVector tDampedCenterPos = getCenterPos();
    float tDampedSize = getSize();

    rect.setRect( tDampedCenterPos.x - tDampedSize, tDampedCenterPos.y - tDampedSize, tDampedSize * 2, tDampedSize * 2 );

    if ( mousePressedPos != null )
    {
      if ( !rotatingByDrag )
      {
        if ( mousePressedPos.x != mouseX && mousePressedPos.y != mouseY )
        {
          rotatingByDrag = true;
        }
      }
    }

    if ( rotatingByDrag )
    {
      float tCurrentMouseDownAngle = atan2( mouseY - centerPos.y, mouseX - centerPos.x ) + TWO_PI;

      float tNewAngleOffset = mouseDownAngleOffset + ( tCurrentMouseDownAngle - mousePressedAngle );
      while ( tNewAngleOffset > angleOffset.value + PI )
      {
        tNewAngleOffset -= TWO_PI;
      }
      while ( tNewAngleOffset < angleOffset.value - PI )
      {
        tNewAngleOffset += TWO_PI;
      }
      angleOffset.value = tNewAngleOffset;
    }

    float tAngleOffset = angleOffset.value;
    float tWheelStartAngle = 0 + tAngleOffset;
    float tWheelEndAngle = TWO_PI + tAngleOffset;

    if ( global_lineMode.value )
    {
      tWheelStartAngle = -tDampedCenterPos.x / tDampedSize - HALF_PI;
      tWheelEndAngle = ( width - tDampedCenterPos.x ) / tDampedSize - HALF_PI;
    }


    updateUnlockedAbilities();

    updateChildNodeDimensions( abilityTree.rootNode, 0, tWheelStartAngle, tWheelEndAngle );


    float tUnlockedRatio = 1.0 * calcUnlockedAbilityCount() / calcTotalAbilityCount();
    if ( sizeByPoints.value )
    {
      tUnlockedRatio = 1.0 * calcUnlockedAbilityPoints() / calcTotalAbilityPoints();
    }
    dampingHelper_unlockedRatio.update( tUnlockedRatio );
  }

  public void draw()
  {
    super.draw();

    PVector tCenter = getCenterPos();

    fill( 0, 0, 0.7 );
    noStroke();

    textAlign( CENTER, BOTTOM );
    textFont( font_TSW_Title );
    text( "THE SECRET WORLD", tCenter.x, tCenter.y - 30 );

    textFont( font_TSW_Subtitle );
    text( "ABILITY WHEEL", tCenter.x, tCenter.y - 5 );

    fill( 0, 0, 0.3 );
    textAlign( CENTER, TOP );
    textFont( font_TSW_Subtitle );
    text( "Visualisation Test", tCenter.x, tCenter.y + 5 );

    if ( global_debug )
    {
      noFill();
      stroke( 0, 0, 0.3 );
      strokeCap( SQUARE );
      strokeWeight( 1 );

      float tCrossSize = 10;
      pointcross( tCenter.x, tCenter.y, tCrossSize );

      //if( this == hoveredControl ) { stroke( 0, 0, 0.4 ); }

      ellipseMode( RADIUS );
      ellipse( tCenter.x, tCenter.y, rect.width / 2.0, rect.height / 2.0 );
    }

    if ( selectedAbilityBranch != null )
    {
      //      float tGlowRadius = outerRingSize.value - ringThickness.value * 6;
      //      strokeWeight( ringThickness.value * 15 );
      //      stroke( hue( selectedAbilityNode.nodeColor ), 0.1, 0.3, 0.1 );
      //      arc( tCenter.x, tCenter.y, tGlowRadius, tGlowRadius, PI + HALF_PI + selectedAbilityNode.linkedControl.damper_startAngle.getValue(), PI + HALF_PI + selectedAbilityNode.linkedControl.damper_endAngle.getValue(), OPEN );
    }


    // Draw unlocked arc
    {
      noFill();
      strokeCap( SQUARE );
      ellipseMode( RADIUS );
      strokeWeight( 20 );
      stroke( 0, 0, 0.3, 0.5 );

      float tStartAngle = -HALF_PI;
      float tEndAngle = dampingHelper_unlockedRatio.getValue() * TWO_PI + tStartAngle;

      float tRadius = outerRingSize.value + abilityRingThickness.value;
      arc( tCenter.x, tCenter.y, tRadius, tRadius, tStartAngle, tEndAngle, OPEN );
    }
  }



  public boolean isMouseIn()
  {
    float tXDiff = mouseX - ( rect.x + rect.width / 2.0 );
    float tYDiff = mouseY - ( rect.y + rect.height / 2.0 );
    float tSquaredLength = ( tXDiff * tXDiff ) + ( tYDiff * tYDiff );
    float tRectRadius = ( rect.width / 2.0 ) * ( rect.width / 2.0 );

    if ( tSquaredLength <= tRectRadius ) { 
      return true;
    }
    return false;
  }

  public void onMousePressed()
  {
    super.onMousePressed();

    mousePressedAngle = atan2( mouseY - centerPos.y, mouseX - centerPos.x ) + TWO_PI;
    mouseDownAngleOffset = angleOffset.value;
  }

  public void onMouseReleased()
  {
    super.onMouseReleased();

    //angleOffset.value = Angle.normalize( angleOffset.value );
    //normalizeAngles( abilityTree.rootNode );

    if ( !rotatingByDrag )
    {
      selectedAbilityBranch = null;
    }

    rotatingByDrag = false;
  }



  private void loadAbilityTree( TSW_AbilityTree aAbilityTree )
  {
    abilityTree = aAbilityTree;
  }


  private void createControlsForChildAbilityNodes( TSW_AbilityNode aNode )
  {
    for ( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.createAssociatedUIControl();
      uiControls.add( tControl );

      tControl.setup( this );

      if ( iNode.getChildNodes().size() > 0 )
      {
        createControlsForChildAbilityNodes( iNode );
      }
    }
  }



  public void selectAbility( TSW_UIControl_Ability aAbility )
  {
    if ( !isAbilitySelected( aAbility ) )
    {
      selectedAbilities.add( aAbility );
    }
  }

  public void unselectAbility( TSW_UIControl_Ability aAbility )
  {
    selectedAbilities.remove( aAbility );
  } 

  public boolean isAbilitySelected( TSW_UIControl_Ability aAbility )
  {
    if ( selectedAbilities.indexOf( aAbility ) > -1 )
    {
      return true;
    }

    return false;
  }


  private void updateChildNodeDimensions( TSW_AbilityNode aNode, int aLevel, float aStartAngle, float aEndAngle )
  {
    HashMap<TSW_AbilityNode, Integer> tNodeToRelativeSize = new HashMap<TSW_AbilityNode, Integer>(); 
    int tTotalSize = 0;

    for ( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      int tRelativeSize = getNodeRelativeSize( iNode.linkedControl );
      tNodeToRelativeSize.put( iNode, tRelativeSize );
      tTotalSize += tRelativeSize;
    }

    float tSize = getSize();

    float tOuterRingRadius = tSize - ringThickness.value;
    float tInnerRingRadius = tOuterRingRadius - innerRingSize.value;
    if ( global_lineMode.value )
    {
    }

    float tCurrentAngle = aStartAngle;
    for ( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.linkedControl;

      tControl.cDistanceFromCenter = ( aLevel * 1.0 / abilityTree.cLevels ) * ( tOuterRingRadius - tInnerRingRadius ) + tInnerRingRadius;

      if ( tControl instanceof TSW_UIControl_Ability ) { 
        tControl.cDistanceFromCenter -= ( tOuterRingRadius - tInnerRingRadius ) / abilityTree.cLevels - ringThickness.value - abilityGapSize.value;
      }

      float tGapSize = branchGapSize.value;
      if ( aNode == abilityTree.rootNode ) { 
        tGapSize = 0;
      }
      if ( !showAuxWheel.value && iNode.name.equals( "Main" ) ) { 
        tGapSize = 0;
      }
      tGapSize /= tControl.cDistanceFromCenter;

      //      tControl.cStartAngle = tCurrentAngle + tGapSize / tControl.cDistanceFromCenter;
      //      tCurrentAngle = tCurrentAngle + ( aEndAngle - aStartAngle ) * tNodeToRelativeSize.get( iNode ) / tTotalSize;
      //      tControl.cEndAngle = tCurrentAngle - tGapSize / tControl.cDistanceFromCenter;

      tControl.cStartAngle = tCurrentAngle;
      tCurrentAngle = tCurrentAngle + ( aEndAngle - aStartAngle ) * tNodeToRelativeSize.get( iNode ) / tTotalSize;
      tControl.cEndAngle = tCurrentAngle;

      if ( iNode.getChildNodes().size() > 0 )
      {
        updateChildNodeDimensions( iNode, aLevel + 1, tControl.cStartAngle + tGapSize, tControl.cEndAngle - tGapSize );
      }
    }
  }

  private int getNodeRelativeSize( TSW_UIControl_AbilityNode aNode )
  {
    int tRelativeSize = 0;

    if ( selectedAbilityBranch == aNode )
    {
      tRelativeSize = sizeByPoints.value ? round( calcTotalAbilityPoints() / ( 1 - selectedNodeRatio.value ) ) : round( calcTotalAbilityCount() / ( 1 - selectedNodeRatio.value ) );
    }

    if ( aNode.linkedNode.getChildNodes().size() > 0 )
    {
      for ( TSW_AbilityNode iNode : aNode.linkedNode.getChildNodes() )
      {
        tRelativeSize += getNodeRelativeSize( iNode.linkedControl );
      }
    }
    else
    {
      tRelativeSize = 1;
      if ( aNode instanceof TSW_UIControl_Ability )
      {
        TSW_Ability tLinkedAbility = (TSW_Ability)( aNode.linkedNode );
        if ( sizeByPoints.value )
        {
          tRelativeSize = tLinkedAbility.points;
        }

        // check filters
        for ( TSW_Filter_Ability iFilter : abilityFilters )
        {
          if ( iFilter.doesAbilityPass( tLinkedAbility ) && iFilter.active )
          {
            tRelativeSize *= 200;
            break;
          }
        }
      }
    }

    if ( aNode.linkedNode.name.equals( "Auxiliary" ) && !showAuxWheel.value )
    {
      tRelativeSize = 0;
    }

    return tRelativeSize;
  }


  public PVector getCenterPos()
  {
    PVector tCenterPos = easingHelper_topPos.getValue();
    tCenterPos.y += getSize(); 
    return tCenterPos;
  }

  public float getSize()
  {
    return sqrt( easingHelper_size.getValue() );
  }



  public void normalizeAngles( TSW_AbilityNode aNode )
  {
    TSW_UIControl_AbilityNode tControl = aNode.linkedControl;
    if ( tControl != null )
    {
      tControl.damper_startAngle.currentValue += Angle.normalize( tControl.cStartAngle ) - tControl.cStartAngle;
      tControl.damper_endAngle.currentValue += Angle.normalize( tControl.cEndAngle ) - tControl.cEndAngle;
      tControl.cStartAngle = Angle.normalize( tControl.cStartAngle );
      tControl.cEndAngle = Angle.normalize( tControl.cEndAngle );
    }

    for ( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      normalizeAngles( iNode );
    }
  }


  public void addFilter( TSW_Filter_Ability aFilter )
  {
    abilityFilters.add( aFilter );
  }


  public void updateUnlockedAbilities()
  {
    for ( TSW_Ability iAbility : abilityTree.abilities )
    {
      if ( iAbility.linkedControl != null )
      {
        TSW_UIControl_Ability tControl = (TSW_UIControl_Ability)iAbility.linkedControl;
        tControl.unlocked = false;
      }
    }

    for ( TSW_UIControl_Ability iAbilityControl : selectedAbilities )
    {
      iAbilityControl.unlocked = true;

      if ( iAbilityControl.linkedNode != null )
      {
        TSW_AbilityNode tBranch = iAbilityControl.linkedNode.parentNode;

        // Unlock all prior branch siblings
        for ( TSW_AbilityNode iAbility : tBranch.childNodes )
        {
          if ( iAbility == iAbilityControl.linkedNode )
          {
            break;
          }

          if ( iAbility instanceof TSW_Ability && iAbility.linkedControl != null )
          {
            TSW_UIControl_Ability tSiblingNode = (TSW_UIControl_Ability)iAbility.linkedControl;
            tSiblingNode.unlocked = true;
          }
        }

        // Unlock prerequisite tier branches
        TSW_AbilityNode tBranchParent = tBranch.parentNode;
        String[] tBranchesWithPrerequisiteBranches = { 
          "Blade", "Hammer", "Fists", "Blood Magic", "Chaos", "Elementalism", "Shotgun", "Pistols", "Assault Rifle"
        };

        boolean tFound = false;
        int iListIndex = 0;
        while ( iListIndex < tBranchesWithPrerequisiteBranches.length && !tFound ) 
        {
          if ( tBranchParent.name.equals( tBranchesWithPrerequisiteBranches[ iListIndex ] ) )
            tFound = true;

          ++iListIndex;
        }

        if ( tFound && tBranchParent.childNodes.indexOf( tBranch ) >= 2 )
        {
          int iIndex = 0;
          while ( iIndex < 2 )
          {
            TSW_AbilityNode iBranch = tBranchParent.childNodes.get( iIndex );

            for ( TSW_AbilityNode iAbility : iBranch.childNodes )
            {
              if ( iAbility instanceof TSW_Ability && iAbility.linkedControl != null )
              {
                TSW_UIControl_Ability tSiblingNode = (TSW_UIControl_Ability)iAbility.linkedControl;
                tSiblingNode.unlocked = true;
              }
            }

            ++iIndex;
          }
        }
      }
    }
  }

  public int calcTotalAbilityCount()
  {
    return abilityTree.abilities.size();
  }

  public int calcUnlockedAbilityCount()
  {
    int tCount = 0;
    for ( TSW_Ability iAbility : abilityTree.abilities )
    {
      if ( iAbility.linkedControl != null )
      {
        TSW_UIControl_Ability tControl = (TSW_UIControl_Ability)iAbility.linkedControl;
        if ( tControl.unlocked )
          ++tCount;
      }
    }

    return tCount;
  }


  public int calcTotalAbilityPoints()
  {
    int tCount = 0;
    for ( TSW_Ability iAbility : abilityTree.abilities )
    {
      tCount += iAbility.points;
    }

    return tCount;
  }

  public int calcUnlockedAbilityPoints()
  {
    int tCount = 0;
    for ( TSW_Ability iAbility : abilityTree.abilities )
    {
      if ( iAbility.linkedControl != null )
      {
        TSW_UIControl_Ability tControl = (TSW_UIControl_Ability)iAbility.linkedControl;
        if ( tControl.unlocked )
          tCount += iAbility.points;
      }
    }

    return tCount;
  }
}


class TSW_AbilityTree_ColorSet
{
  color branch;
  color ability_locked;
  color ability_unlocked;

  public TSW_AbilityTree_ColorSet( color aBranch, color aAbility_Locked, color aAbility_Unlocked )
  {
    branch = aBranch;
    ability_locked = aAbility_Locked;
    ability_unlocked = aAbility_Unlocked;
  }
}


