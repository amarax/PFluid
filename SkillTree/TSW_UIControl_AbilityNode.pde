class TSW_UIControl_AbilityNode extends UIControl
{
  TSW_UIControl_AbilityTree parentTreeControl;
  TSW_AbilityNode linkedNode;

  public float cThickness;
  public float cStartAngle, cEndAngle, cDistanceFromCenter;
  DampingHelper_Float damper_startAngle, damper_endAngle;

  boolean hoveredInPrevFrame;  
  DampingHelper_Float damper_hoverFactor;

  color nodeColor;

  public TSW_UIControl_AbilityNode( TSW_AbilityNode aNode )
  {
    super( new Rectangle() );

    linkedNode = aNode;
    nodeColor = linkedNode.nodeColor;

    hoveredInPrevFrame = false;
  }

  public void setup( TSW_UIControl_AbilityTree aParentTreeControl )
  {
    super.setup();

    parentTreeControl = aParentTreeControl;

    float tDampingFactor = 0.05;
    
    damper_startAngle = new DampingHelper_Float( tDampingFactor, 0 );
    damper_endAngle = new DampingHelper_Float( tDampingFactor, 0 );

    damper_hoverFactor = new DampingHelper_Float( 0.1, 0.0 );
  }

  public void update()
  {
    super.update();

    float tDampingFactor = 0.05;
    if( parentTreeControl.rotatingByDrag )
    {
      tDampingFactor = 0.3;
    }
    damper_startAngle.setDampingFactor( tDampingFactor );
    damper_endAngle.setDampingFactor( tDampingFactor );
    
    damper_startAngle.update( cStartAngle );
    damper_endAngle.update( cEndAngle );

    if ( hoveredInPrevFrame != ( this == hoveredControl ) )
    {
      if ( hoveredInPrevFrame )
      {
        // Damp out slowly
        damper_hoverFactor.dampingFactor = 0.2;
      }
      else
      {
        // Damp in quickly
        damper_hoverFactor.dampingFactor = 0.5;
      }
    }

    damper_hoverFactor.update( this == hoveredControl ? 1.0 : 0.0 );
    hoveredInPrevFrame = this == hoveredControl;
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
    float tArcLength = calcArcLength(); 
    if ( tArcLength > 0.5 )
    {

      noFill();
      strokeCap( SQUARE );
      ellipseMode( RADIUS );

      tArcThickness = cThickness;
      tRadius = tDistanceFromCenter + tArcThickness / 2;

      if ( parentTreeControl.selectedAbilityBranch != null )
      {
        if ( this == parentTreeControl.selectedAbilityBranch )
        {
          stroke( hue( nodeColor ), saturation( nodeColor ) * 0.2, 1.0, alpha( nodeColor ) * 0.1 );

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

      float tAlphaFactor = 1.0;
      if ( tArcLength < 2 ) { 
        tAlphaFactor = 1.0 * ( tArcLength - 0.5 ) / ( 2.0 - 0.5 );
      }
      color tNodeColor = color( hue( nodeColor ), saturation( nodeColor ), brightness( nodeColor ), alpha( nodeColor ) * tAlphaFactor );

      strokeWeight( tArcThickness );
      stroke( tNodeColor );

      arc( tCenter.x, tCenter.y, tRadius, tRadius, PI + HALF_PI + tStartAngle, PI + HALF_PI + tEndAngle, OPEN );
    }
  }



  public boolean isMouseIn()
  {
    // Cull if too thin
    if ( damper_endAngle.getValue() - damper_startAngle.getValue() >= 1 / cDistanceFromCenter )
    {
      Vector2 tCenter = new Vector2( parentTreeControl.rect.x + parentTreeControl.rect.width / 2.0, parentTreeControl.rect.y + parentTreeControl.rect.height / 2.0 );  

      float tDist = tCenter.distanceTo( mouseX, mouseY );

      if ( tDist >= cDistanceFromCenter && tDist <= cDistanceFromCenter + cThickness )
      {
        float tRelativeAngle = atan2( mouseY - tCenter.y, mouseX - tCenter.x ) + HALF_PI;
        float tOffsetAngle = angleOffset.value;
        if ( global_lineMode.value ) { 
          tOffsetAngle = -parentTreeControl.getCenterPos().x / parentTreeControl.getSize();
        }
        if ( tRelativeAngle < 0 + tOffsetAngle ) { 
          tRelativeAngle += TWO_PI;
        }

        if ( tRelativeAngle >= cStartAngle && tRelativeAngle <= cEndAngle )
        {
          return true;
        }
      }
    }

    return false;
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
    if ( tArcLength >= tStartFadeInLength || damper_hoverFactor.getValue() > EPSILON )
    {
      PVector tArcCenter = calcArcCenter();

      float tAlpha = 0.5;
      if ( tArcLength < tFullAlphaLength && this != hoveredControl )
      {
        tAlpha = 0.5 * ( tArcLength - tStartFadeInLength ) / ( tFullAlphaLength - tStartFadeInLength );
      }
      tAlpha += ( 1 - tAlpha ) * damper_hoverFactor.getValue();

      if ( tAlpha >= EPSILON )
      {
        textAlign( CENTER, CENTER );
        fill( 0, 0, 1, tAlpha );
        text( linkedNode.name, tArcCenter.x, tArcCenter.y );
      }
    }
  }

  public void onMouseReleased()
  {
    if ( parentTreeControl.selectedAbilityBranch != this )
    {
      parentTreeControl.selectedAbilityBranch = this;
    }
    else
    {
      parentTreeControl.selectedAbilityBranch = null;
    }
  }
}

class TSW_UIControl_Ability extends TSW_UIControl_AbilityNode
{
  boolean unlocked;

  public TSW_UIControl_Ability( TSW_Ability aAbility )
  {
    super( aAbility );
  }

  public void update()
  {
    super.update();

    if ( parentTreeControl.isAbilitySelected( this ) )
    {
      cThickness = abilityRingThickness.value * 1.66;
    }
    else
    {
      cThickness = abilityRingThickness.value;
      //cThickness = abilityRingThickness.value * 0.2 + tLinkedAbilityNode.points;
    }
  }

  public void draw()
  {
    super.draw();

    noStroke();
    textFont( font_TSW_AbilityName );

    float tFullAlphaLength = 300;
    float tStartFadeInLength = 75;      

    PVector tArcCenter = calcArcCenter();
    float tArcLength = calcArcLength(); 
    if ( damper_hoverFactor.getValue() > EPSILON )
    {

      float tAlpha = damper_hoverFactor.getValue();

      if ( tAlpha >= EPSILON )
      {
        textAlign( CENTER, CENTER );
        fill( 0, 0, 1, tAlpha );
        text( linkedNode.name, tArcCenter.x, tArcCenter.y );
      }
    }

    if ( parentTreeControl.isAbilitySelected( this ) )
    {
      PVector tTextAttachPoint = new PVector( tArcCenter.x, tArcCenter.y );
      float tMidAngle = PI + HALF_PI + ( damper_startAngle.getValue() + damper_endAngle.getValue() ) / 2.0;
      float tTextDistanceFromArc = cThickness / 2 + 10;

      tTextAttachPoint.x += tTextDistanceFromArc * cos( tMidAngle );
      tTextAttachPoint.y += tTextDistanceFromArc * sin( tMidAngle );

      if( global_debug )
      {
        noFill();
        stroke( 0, 0, 0.3 );
        strokeCap( SQUARE );
        strokeWeight( 1 );
        pointcross( tTextAttachPoint.x, tTextAttachPoint.y, 10 );
      }

      PVector tTextDimensions = new PVector( 150, 70 );

      PVector tTextCenter = new PVector( tTextAttachPoint.x, tTextAttachPoint.y );
      tTextCenter.x += 0.5 * tTextDimensions.x * ( min_abs( sqrt(2) * cos( tMidAngle ), signof( cos( tMidAngle ) ) ) );
      tTextCenter.y += 0.5 * tTextDimensions.y * ( min_abs( sqrt(2) * sin( tMidAngle ), signof( sin( tMidAngle ) ) ) );

      rectMode( CENTER );
      textAlign( LEFT, TOP );
      textFont( font_TSW_AbilityDescription );
      fill( 0, 0, 1, 1.0 );
      text( ( (TSW_Ability)linkedNode ).description, tTextCenter.x, tTextCenter.y, tTextDimensions.x, tTextDimensions.y );

      if( global_debug )
      {
        noFill();
        stroke( 0, 0, 0.3 );
        strokeCap( SQUARE );
        strokeWeight( 1 );
        rect( tTextCenter.x, tTextCenter.y, tTextDimensions.x, tTextDimensions.y );
      }


      rectMode( CORNER );
    }
  }

  public void onMouseReleased()
  {
    if ( !parentTreeControl.isAbilitySelected( this ) )
    {
      parentTreeControl.selectAbility( this );
    }
    else
    {
      parentTreeControl.unselectAbility( this );
    }

    unlocked = !unlocked;

    TSW_Ability tLinkedAbilityNode = ( (TSW_Ability)linkedNode ); 
    nodeColor = unlocked ? tLinkedAbilityNode.nodeUnlockedColor : tLinkedAbilityNode.nodeLockedColor;
  }
}

