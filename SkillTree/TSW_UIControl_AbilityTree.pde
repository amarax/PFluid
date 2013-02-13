

class TSW_UIControl_AbilityTree extends UIControl
{
  TSW_AbilityTree abilityTree;
  
  TSW_AbilityNode selectedAbilityNode = null;
  
  private PVector centerPos;
  float size;
  
  private EasingHelper_PVector easingHelper_centerPos;
  private EasingHelper_Float easingHelper_size;
  
  private boolean cLineModeSwitch_PrevValue;
  
  public TSW_UIControl_AbilityTree( Rectangle aRect )
  {
    super( aRect );
    
    loadAbilityTree();

    centerPos = new PVector( rect.x + rect.width / 2.0, rect.y + rect.height / 2.0 );
    size = 1;
  }
  
  public void setup()
  {
    super.setup();
    
    size = outerRingSize.value;

    createControlsForChildAbilityNodes( abilityTree.rootNode ); 
    
    float tDampingFactor = 0;

    easingHelper_centerPos = new EasingHelper_PVector( centerPos );
    easingHelper_size = new EasingHelper_Float( size );
  }
  
  public void update()
  {
    super.update();
    
    if( global_lineMode.value != cLineModeSwitch_PrevValue )
    {
      float tTransitionTime = 1;
      easingHelper_centerPos.start( easingHelper_centerPos.getValue(), tTransitionTime );
      easingHelper_size.start( easingHelper_size.getValue(), tTransitionTime );
    } 
    cLineModeSwitch_PrevValue = global_lineMode.value;
    
    if( global_lineMode.value )
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
      
      if( outerRingSize != null )
      {
        size = outerRingSize.value;
      }
      else
      {
        size = 100;
      }
    }
    
    easingHelper_centerPos.update( centerPos );
    easingHelper_size.update( size );

    PVector tDampedCenterPos = getCenterPos();
    float tDampedSize = getSize();

    rect.setRect( tDampedCenterPos.x - tDampedSize, tDampedCenterPos.y - tDampedSize, tDampedSize * 2, tDampedSize * 2 );
    
    float tAngleOffset = angleOffset.value;
    float tWheelStartAngle = 0 + tAngleOffset;
    float tWheelEndAngle = TWO_PI + tAngleOffset;
    if( global_lineMode.value )
    {
      tWheelStartAngle = -tDampedCenterPos.x / size;
      tWheelEndAngle = ( width - tDampedCenterPos.x ) / size;
    }
    
    updateChildNodeDimensions( abilityTree.rootNode, 0, tWheelStartAngle, tWheelEndAngle );
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

    boolean tDebug = false;
    if( tDebug )
    {
      noFill();
      stroke( 0, 0, 0.3 );
      strokeCap( SQUARE );
      strokeWeight( 1 );
      
      float tCrossSize = 10;
      line( tCenter.x, tCenter.y - tCrossSize, tCenter.x, tCenter.y + tCrossSize ); 
      line( tCenter.x - tCrossSize, tCenter.y, tCenter.x + tCrossSize, tCenter.y ); 
      
      //if( this == hoveredControl ) { stroke( 0, 0, 0.4 ); }
      
      ellipseMode( RADIUS );
      ellipse( tCenter.x, tCenter.y, rect.width / 2.0, rect.height / 2.0 );    
    }

    if( selectedAbilityNode != null )
    {
//      float tGlowRadius = outerRingSize.value - ringThickness.value * 6;
//      strokeWeight( ringThickness.value * 15 );
//      stroke( hue( selectedAbilityNode.nodeColor ), 0.1, 0.3, 0.1 );
//      arc( tCenter.x, tCenter.y, tGlowRadius, tGlowRadius, PI + HALF_PI + selectedAbilityNode.linkedControl.damper_startAngle.getValue(), PI + HALF_PI + selectedAbilityNode.linkedControl.damper_endAngle.getValue(), OPEN );     
    }
  }
  
  
  
  public boolean isMouseIn()
  {
    float tXDiff = mouseX - ( rect.x + rect.width / 2.0 );
    float tYDiff = mouseY - ( rect.y + rect.height / 2.0 );
    float tSquaredLength = ( tXDiff * tXDiff ) + ( tYDiff * tYDiff );
    float tRectRadius = ( rect.width / 2.0 ) * ( rect.width / 2.0 );
    
    if( tSquaredLength <= tRectRadius ) { return true; }
    return false;
  }
  
  public void onMouseReleased()
  {
    selectedAbilityNode = null;
  }
  
  
  
  private void loadAbilityTree()
  {
    // HACK Create an ability tree
    // HACK should load from XML
    TSW_AbilityTree_Generated tGeneratedTree = new TSW_AbilityTree_Generated(); 
    tGeneratedTree.populate();
    abilityTree = tGeneratedTree;
  }
  
  
  private void createControlsForChildAbilityNodes( TSW_AbilityNode aNode )
  {
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.createAssociatedUIControl();
      uiControls.add( tControl );
      
      tControl.setup( this );
      
      if( iNode.getChildNodes().size() > 0 )
      {
          createControlsForChildAbilityNodes( iNode );
      }
    }
  }
  
  int tGrandTotalSize = 1;
  private void updateChildNodeDimensions( TSW_AbilityNode aNode, int aLevel, float aStartAngle, float aEndAngle )
  {
    HashMap<TSW_AbilityNode, Integer> tNodeToRelativeSize = new HashMap<TSW_AbilityNode, Integer>(); 
    int tTotalSize = 0;
    
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      int tRelativeSize = getNodeRelativeSize( iNode );
      tNodeToRelativeSize.put( iNode, tRelativeSize );
      tTotalSize += tRelativeSize;
    }

    float tSize = getSize();

    float tOuterRingRadius = tSize - ringThickness.value;
    float tInnerRingRadius = tOuterRingRadius - innerRingSize.value;
    if( global_lineMode.value )
    {
    }

    float tCurrentAngle = aStartAngle;
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.linkedControl;
      
      tControl.cDistanceFromCenter = ( aLevel * 1.0 / abilityTree.cLevels ) * ( tOuterRingRadius - tInnerRingRadius ) + tInnerRingRadius;

      if( tControl instanceof TSW_UIControl_Ability ) { tControl.cDistanceFromCenter -= ( tOuterRingRadius - tInnerRingRadius ) / abilityTree.cLevels - ringThickness.value - gapSize.value * 2; }

      float tGapSize = gapSize.value;
      if( tControl instanceof TSW_UIControl_Ability ) { tGapSize = abilityGapSize.value; }
      else if( !showAuxWheel.value && iNode.name.equals( "Main" ) ) { tGapSize = 0; }

      tControl.cStartAngle = tCurrentAngle + tGapSize / tControl.cDistanceFromCenter;
      tCurrentAngle = tCurrentAngle + ( aEndAngle - aStartAngle ) * tNodeToRelativeSize.get( iNode ) / tTotalSize;
      tControl.cEndAngle = tCurrentAngle - tGapSize / tControl.cDistanceFromCenter;
      
      if( iNode.getChildNodes().size() > 0 )
      {
          updateChildNodeDimensions( iNode, aLevel + 1, tControl.cStartAngle, tControl.cEndAngle );
      }
    }
  }
  
  private int getNodeRelativeSize( TSW_AbilityNode aNode )
  {
    int tRelativeSize = 0;

    if( aNode.getChildNodes().size() > 0 )
    {
      for( TSW_AbilityNode iNode : aNode.getChildNodes() )
      {
        tRelativeSize += getNodeRelativeSize( iNode );
      }
    }
    else
    {
      tRelativeSize = aNode.getRelativeSize();
    }
    
    if( selectedAbilityNode == aNode )
    {
      tRelativeSize = sizeByPoints.value ? round( 11025 / ( 1 - selectedNodeRatio.value ) ) : round( ( 525 + 6 ) / ( 1 - selectedNodeRatio.value ) );
    }
    
    if( aNode.name.equals( "Auxiliary" ) && !showAuxWheel.value )
    {
      tRelativeSize = 0;
    }

    return tRelativeSize;
  }
  
  
  public PVector getCenterPos()
  {
    PVector tCenterPos = easingHelper_centerPos.getValue();
    return tCenterPos;
  }
  
  public float getSize()
  {
    return easingHelper_size.getValue();
  }
}


class TSW_UIControl_AbilityNode extends UIControl
{
  TSW_UIControl_AbilityTree parentTreeControl;
  TSW_AbilityNode linkedNode;
  
  public float cThickness;
  public float cStartAngle, cEndAngle, cDistanceFromCenter;
  DampingHelper_Float damper_startAngle, damper_endAngle;
  
  public TSW_UIControl_AbilityNode( TSW_AbilityNode aNode )
  {
    super( new Rectangle() );
    
    linkedNode = aNode;
  }
  
  public void setup( TSW_UIControl_AbilityTree aParentTreeControl )
  {
    super.setup();
    
    parentTreeControl = aParentTreeControl;
    
    float tDampingFactor = 0.05;
    damper_startAngle = new DampingHelper_Float( tDampingFactor, 0 );
    damper_endAngle = new DampingHelper_Float( tDampingFactor, 0 );
  }
  
  public void update()
  {
    super.update();

    damper_startAngle.update( cStartAngle );
    damper_endAngle.update( cEndAngle );
  }
  
  public void draw()
  {
    super.draw();

    PVector tCenter = parentTreeControl.getCenterPos();
    float tSize = parentTreeControl.size;
 
    float tRadius = 0;
    float tArcThickness = 0;
    
    float tStartAngle = damper_startAngle.getValue();
    float tEndAngle = damper_endAngle.getValue();
    float tDistanceFromCenter = cDistanceFromCenter;
    
    // Cull if too thin
    if( tEndAngle - tStartAngle >= 1 / tDistanceFromCenter )
    {
    
      noFill();
      strokeCap( SQUARE );
      ellipseMode( RADIUS );
  
      tArcThickness = cThickness;
      tRadius = tDistanceFromCenter + tArcThickness / 2;
  
      if( parentTreeControl.selectedAbilityNode != null )
      {
        if( this == parentTreeControl.selectedAbilityNode.linkedControl )
        {
          stroke( hue( linkedNode.nodeColor ), saturation( linkedNode.nodeColor ) * 0.2, 1.0, alpha( linkedNode.nodeColor ) * 0.1 );
    
          float tOutline = -2;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenter.x, tCenter.y, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     

          tOutline = -1;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenter.x, tCenter.y, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     
    
          tOutline = 1;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenter.x, tCenter.y, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     
    
          tOutline = 2;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenter.x, tCenter.y, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );
        }     
      }
  
      strokeWeight( tArcThickness );
      stroke( linkedNode.nodeColor );
  
      arc( tCenter.x, tCenter.y, tRadius, tRadius, PI + HALF_PI + tStartAngle, PI + HALF_PI + tEndAngle, OPEN );

    }
  }
  
  
  
  public boolean isMouseIn()
  {
    // Cull if too thin
    if( damper_endAngle.getValue() - damper_startAngle.getValue() >= 1 / cDistanceFromCenter )
    {
      Vector2 tCenter = new Vector2( parentTreeControl.rect.x + parentTreeControl.rect.width / 2.0, parentTreeControl.rect.y + parentTreeControl.rect.height / 2.0 );  
  
      float tDist = tCenter.distanceTo( mouseX, mouseY );
  
      if( tDist >= cDistanceFromCenter && tDist <= cDistanceFromCenter + cThickness )
      {
        float tRelativeAngle = atan2( mouseY - tCenter.y, mouseX - tCenter.x ) + HALF_PI;
        float tOffsetAngle = angleOffset.value;
        if( global_lineMode.value ) { tOffsetAngle = -parentTreeControl.getCenterPos().x / parentTreeControl.getSize(); }
        if( tRelativeAngle < 0 + tOffsetAngle ) { tRelativeAngle += TWO_PI; }
  
        if( tRelativeAngle >= cStartAngle && tRelativeAngle <= cEndAngle )
        {
          return true;
        }
      }
    }

    return false;
  }
  
  public void onMouseReleased()
  {
    if( parentTreeControl.selectedAbilityNode != this.linkedNode )
    {
      parentTreeControl.selectedAbilityNode = this.linkedNode;
    }
    else
    {
      parentTreeControl.selectedAbilityNode = null;
    }
  }
  
  public PVector calcArcCenter()
  {
    float tMidAngle = ( ( PI + HALF_PI + damper_endAngle.getValue() ) + ( PI + HALF_PI + damper_startAngle.getValue() ) ) / 2;
    PVector tArcCenter = parentTreeControl.getCenterPos();
    tArcCenter.x += ( cDistanceFromCenter + cThickness / 2 ) * cos( tMidAngle );
    tArcCenter.y += ( cDistanceFromCenter + cThickness / 2 ) * sin( tMidAngle );
    
    return tArcCenter;
  }
  
  public float calcArcLength()
  {
    float tArcLength = cDistanceFromCenter * ( PI + HALF_PI + damper_endAngle.getValue() ) - cDistanceFromCenter * ( PI + HALF_PI + damper_startAngle.getValue() );
    return tArcLength;
  }
}


class TSW_UIControl_AbilityBranch extends TSW_UIControl_AbilityNode
{
  public TSW_UIControl_AbilityBranch( TSW_AbilityBranch aBranch )
  {
    super( aBranch );
  }
  

  public void update()
  {
    super.update();
    
    cThickness = ringThickness.value;
  }
  
  public void draw()
  {
    super.draw();

    noStroke();
    textFont( font_TSW_AbilityTree );
      
    float tFullAlphaLength = 300;
    float tStartFadeInLength = 75;      
    
    float tArcLength = calcArcLength(); 
    if( tArcLength >= tStartFadeInLength || this == hoveredControl )
    {
      PVector tArcCenter = calcArcCenter();

      float tAlpha = 0.7;
      if( tArcLength < tFullAlphaLength && this != hoveredControl )
      {
        tAlpha = 0.7 * ( tArcLength - tStartFadeInLength ) / ( tFullAlphaLength - tStartFadeInLength );
      }
      else if( this == hoveredControl )
      {
        tAlpha = 1.0;
      }

      textAlign( CENTER, CENTER );
      fill( 0, 0, 1, tAlpha );
      text( linkedNode.name, tArcCenter.x, tArcCenter.y );
    }
  }
}

class TSW_UIControl_Ability extends TSW_UIControl_AbilityNode
{
  public TSW_UIControl_Ability( TSW_Ability aAbility )
  {
    super( aAbility );
  }

  public void update()
  {
    super.update();
    
    cThickness = abilityRingThickness.value;
  }
  
  public void draw()
  {
    super.draw();
  }

  public void onMouseReleased()
  {
    TSW_Ability tLinkedAbilityNode = ( (TSW_Ability)linkedNode ); 
    tLinkedAbilityNode.setUnlocked( !tLinkedAbilityNode.getUnlocked() );
  }
}
