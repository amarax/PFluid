

class TSW_UIControl_AbilityTree extends UIControl
{
  TSW_AbilityTree abilityTree;
  
  TSW_AbilityNode selectedAbilityNode = null;
  
  float size;
  
  public TSW_UIControl_AbilityTree( Rectangle aRect )
  {
    super( aRect );
    
    loadAbilityTree();

    size = 100;
  }
  
  public void setup()
  {
    super.setup();
    
    createControlsForChildAbilityNodes( abilityTree.rootNode ); 
  }
  
  public void update()
  {
    super.update();
    
    if( outerRingSize != null )
    {
      size = outerRingSize.value;
    }
    else
    {
      size = 100;
    }
    
    float tCenterX = rect.x + rect.width / 2.0;
    float tCenterY = rect.y + rect.height / 2.0;  

    rect.setRect( tCenterX - size, tCenterY - size, size * 2, size * 2 );
    
    float tAngleOffset = angleOffset.value;
    updateChildNodeDimensions( abilityTree.rootNode, 0, 0 + tAngleOffset, TWO_PI + tAngleOffset );
  }
  
  public void draw()
  {
    super.draw();
    
    float tCenterX = rect.x + rect.width / 2.0;
    float tCenterY = rect.y + rect.height / 2.0;  

    fill( 0, 0, 0.7 );
    noStroke();
    
    textAlign( CENTER, BOTTOM );
    textFont( font_TSW_Title );
    text( "THE SECRET WORLD", tCenterX, tCenterY - 30 );

    textFont( font_TSW_Subtitle );
    text( "ABILITY WHEEL", tCenterX, tCenterY - 5 );

    fill( 0, 0, 0.3 );
    textAlign( CENTER, TOP );
    textFont( font_TSW_Subtitle );
    text( "Visualisation Test", tCenterX, tCenterY + 5 );

    if( false ) // For debugging
    {
      noFill();
      stroke( 0, 0, 0.3 );
      strokeCap( SQUARE );
      strokeWeight( 1 );
      
      float tCrossSize = 10;
      line( tCenterX, tCenterY - tCrossSize, tCenterX, tCenterY + tCrossSize ); 
      line( tCenterX - tCrossSize, tCenterY, tCenterX + tCrossSize, tCenterY ); 
      
      //if( this == hoveredControl ) { stroke( 0, 0, 0.4 ); }
      
      ellipseMode( RADIUS );
      ellipse( tCenterX, tCenterY, rect.width / 2.0, rect.height / 2.0 );    
    }

    if( selectedAbilityNode != null )
    {
//      float tGlowRadius = outerRingSize.value - ringThickness.value * 6;
//      strokeWeight( ringThickness.value * 15 );
//      stroke( hue( selectedAbilityNode.nodeColor ), 0.1, 0.3, 0.1 );
//      arc( tCenterX, tCenterY, tGlowRadius, tGlowRadius, PI + HALF_PI + selectedAbilityNode.linkedControl.damper_startAngle.getValue(), PI + HALF_PI + selectedAbilityNode.linkedControl.damper_endAngle.getValue(), OPEN );     
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

    float tCurrentAngle = aStartAngle; 
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.linkedControl;
      
      tControl.cDistanceFromCenter = ( aLevel * 1.0 / abilityTree.cLevels ) * ( outerRingSize.value - ringThickness.value - innerRingSize.value ) + innerRingSize.value;

      if( tControl instanceof TSW_UIControl_Ability ) { tControl.cDistanceFromCenter -= ( outerRingSize.value - ringThickness.value - innerRingSize.value ) / abilityTree.cLevels - ringThickness.value - gapSize.value * 2; }

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
    
    damper_startAngle = new DampingHelper_Float( 0.05, 0 );
    damper_endAngle = new DampingHelper_Float( 0.05, 0 );
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

    float tCenterX = parentTreeControl.rect.x + parentTreeControl.rect.width / 2.0;
    float tCenterY = parentTreeControl.rect.y + parentTreeControl.rect.height / 2.0;  
 
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
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     

          tOutline = -1;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     
    
          tOutline = 1;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     
    
          tOutline = 2;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );
        }     
      }
  
      strokeWeight( tArcThickness );
      stroke( linkedNode.nodeColor );
  
      arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle, PI + HALF_PI + tEndAngle, OPEN );
  
      
      if( this == hoveredControl )
      {
        noStroke();
        fill( 0, 0, 1 );
        textFont( font_TSW_AbilityTree );
        textAlign( RIGHT, BOTTOM );
        
        text( linkedNode.name, mouseX, mouseY );
      }
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
    parentTreeControl.selectedAbilityNode = this.linkedNode;
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
