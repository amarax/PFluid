class TSW_UIControl_AbilityNode extends UIControl
{
  TSW_UIControl_AbilityTree parentTreeControl;
  TSW_AbilityNode linkedNode;

  public float cThickness;
  public float cStartAngle, cEndAngle, cDistanceFromCenter;
  DampingHelper_Float damper_startAngle, damper_endAngle;

  boolean hoveredInPrevFrame;  
  DampingHelper_Float damper_hoverFactor;
  DampingHelper_Float damper_glowFactor;

  color nodeColor;
  Global_Float nodeGapSize;

  public TSW_UIControl_AbilityNode( TSW_AbilityNode aNode )
  {
    super( new Rectangle() );

    linkedNode = aNode;
    nodeColor = linkedNode.getNodeColor();

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
    damper_glowFactor = new DampingHelper_Float( 0.1, 0.0 );

    nodeGapSize = new Global_Float( 0 );
  }

  public void update()
  {
    super.update();

    nodeColor = linkedNode.getNodeColor();


    float tDampingFactor = 0.3;
    if ( parentTreeControl.rotatingByDrag )
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
        damper_hoverFactor.dampingFactor = 0.3;
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
    float tArcThickness = cThickness;

    float tDistanceFromCenter = cDistanceFromCenter;
    float tGapSize = nodeGapSize.value;
    float tStartAngle = damper_startAngle.getValue() + tGapSize / tDistanceFromCenter;
    float tEndAngle = damper_endAngle.getValue() - tGapSize / tDistanceFromCenter;

    // Cull if too thin
    float tArcLength = calcArcLength(); 
    if ( tArcLength > 2.0 )
    {
      noFill();
      strokeCap( SQUARE );
      ellipseMode( RADIUS );

      tRadius = tDistanceFromCenter + tArcThickness / 2;

      if ( damper_glowFactor.getValue() > EPSILON )
      {
        stroke( hue( nodeColor ), saturation( nodeColor ) + ( ( saturation( nodeColor ) > 0 ) ? ( 1 - saturation( nodeColor ) ) * 0.5 * damper_glowFactor.getValue() : 0 ), 1.0, alpha( nodeColor ) * brightness( nodeColor ) * 0.4 * damper_glowFactor.getValue() );

        float tOutline = -4;
        strokeWeight( tArcThickness - tOutline );
        arc( tCenter.x, tCenter.y, tRadius, tRadius, tStartAngle - tOutline / tDistanceFromCenter, tEndAngle + tOutline / tDistanceFromCenter, OPEN );     

        tOutline = -2;
        strokeWeight( tArcThickness - tOutline );
        arc( tCenter.x, tCenter.y, tRadius, tRadius, tStartAngle - tOutline / tDistanceFromCenter, tEndAngle + tOutline / tDistanceFromCenter, OPEN );     

        tOutline = 1;
        strokeWeight( tArcThickness - tOutline );
        arc( tCenter.x, tCenter.y, tRadius, tRadius, tStartAngle - tOutline / tDistanceFromCenter, tEndAngle + tOutline / tDistanceFromCenter, OPEN );     

        tOutline = 2;
        strokeWeight( tArcThickness - tOutline );
        arc( tCenter.x, tCenter.y, tRadius, tRadius, tStartAngle - tOutline / tDistanceFromCenter, tEndAngle + tOutline / tDistanceFromCenter, OPEN );
      }

      color tNodeColor = nodeColor;

      strokeWeight( tArcThickness );
      tNodeColor = color( hue( nodeColor ), saturation( nodeColor ), brightness( nodeColor ), alpha( nodeColor ) );
      stroke( tNodeColor );

      arc( tCenter.x, tCenter.y, tRadius, tRadius, tStartAngle, tEndAngle, OPEN );
    }
    else
    {
      noFill();
      strokeCap( SQUARE );

      float tAlphaFactor = min( 0.4 + tArcLength * 0.4, 1.0 );
      color tNodeColor = color( hue( nodeColor ), saturation( nodeColor ), brightness( nodeColor ), alpha( nodeColor ) * tAlphaFactor );

      strokeWeight( max( tArcLength, 1.0 ) );
      stroke( tNodeColor );

      float tMidAngle = Angle.calcMidAngle( tStartAngle, tEndAngle );
      PVector tStartPoint = new PVector( tCenter.x, tCenter.y );
      PVector tEndPoint = new PVector( tCenter.x, tCenter.y );
      tStartPoint.x += tDistanceFromCenter * cos( tMidAngle );
      tStartPoint.y += tDistanceFromCenter * sin( tMidAngle );
      tEndPoint.x += ( tDistanceFromCenter + tArcThickness ) * cos( tMidAngle );
      tEndPoint.y += ( tDistanceFromCenter + tArcThickness ) * sin( tMidAngle );

      line( tStartPoint.x, tStartPoint.y, tEndPoint.x, tEndPoint.y );
    }
  }



  public boolean isMouseIn()
  {
    // Cull if too thin
    if ( damper_endAngle.getValue() - damper_startAngle.getValue() >= 1 / cDistanceFromCenter )
    {
      PVector tCenter = parentTreeControl.getCenterPos();  

      float tDist = tCenter.dist( new PVector( mouseX, mouseY ) );

      if ( tDist >= cDistanceFromCenter && tDist <= cDistanceFromCenter + cThickness )
      {
        float tRelativeAngle = atan2( mouseY - tCenter.y, mouseX - tCenter.x );
        //        float tOffsetAngle = angleOffset.value;
        //        if ( global_lineMode.value ) { 
        //          tOffsetAngle = -parentTreeControl.getCenterPos().x / parentTreeControl.getSize();
        //        }
        //        while ( tRelativeAngle < 0 + tOffsetAngle ) { 
        //          tRelativeAngle += TWO_PI;
        //        }

        return Angle.isWithinAngles( tRelativeAngle, damper_startAngle.getValue(), damper_endAngle.getValue() );
      }
    }

    return false;
  }

  public PVector calcArcCenter()
  {
    float tMidAngle = Angle.calcMidAngle( damper_startAngle.getValue(), damper_endAngle.getValue() );
    PVector tArcCenter = parentTreeControl.getCenterPos();
    tArcCenter.x += ( cDistanceFromCenter + cThickness / 2 ) * cos( tMidAngle );
    tArcCenter.y += ( cDistanceFromCenter + cThickness / 2 ) * sin( tMidAngle );

    return tArcCenter;
  }

  public float calcArcLength()
  {
    float tArcLength = cDistanceFromCenter * ( damper_endAngle.getValue() ) - cDistanceFromCenter * ( damper_startAngle.getValue() ) - nodeGapSize.value * 2;
    return tArcLength;
  }
}


class TSW_UIControl_AbilityBranch extends TSW_UIControl_AbilityNode
{
  public TSW_UIControl_AbilityBranch( TSW_AbilityBranch aBranch )
  {
    super( aBranch );
  }

  public void setup( TSW_UIControl_AbilityTree aParentTreeControl )
  {
    super.setup( aParentTreeControl );

    nodeGapSize = branchGapSize;
  }

  public void update()
  {
    super.update();

    cThickness = ringThickness.value;

    float tGlow = 0.0;
    if ( this == parentTreeControl.selectedAbilityBranch )
    {
      tGlow = 0.667;
    }
    if ( this == hoveredControl )
    {
      tGlow = 1.0;
    }

    damper_glowFactor.update( tGlow );
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
        //        textAlign( CENTER, CENTER );
        //        fill( 0, 0, 1, tAlpha );
        //        text( linkedNode.name, tArcCenter.x, tArcCenter.y );

        UIOverlay_TextLayer_TextEntry tTextEntry = new UIOverlay_TextLayer_TextEntry();
        tTextEntry.displayString = linkedNode.name;
        tTextEntry.displayFont = font_TSW_AbilityTree;
        tTextEntry.displayColor = color( 0, 0, 1, tAlpha );
        tTextEntry.anchorPos = tArcCenter;
        textLayer_FrontMost.addTextEntry( tTextEntry );
      }
    }
  }

  public void onMouseReleased()
  {
    super.onMouseReleased();

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

  public void setup( TSW_UIControl_AbilityTree aParentTreeControl )
  {
    super.setup( aParentTreeControl );

    nodeGapSize = abilityGapSize;
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

    if ( parentTreeControl.isAbilitySelected( this ) || damper_hoverFactor.getValue() > EPSILON )
    {
      PVector tTextAttachPoint = new PVector( tArcCenter.x, tArcCenter.y );
      float tMidAngle = ( damper_startAngle.getValue() + damper_endAngle.getValue() ) / 2.0;
      float tTextDistanceFromArc = cThickness / 2 + 10;

      tTextAttachPoint.x += tTextDistanceFromArc * cos( tMidAngle );
      tTextAttachPoint.y += tTextDistanceFromArc * sin( tMidAngle );

      if ( global_debug )
      {
        noFill();
        stroke( 0, 0, 0.3 );
        strokeCap( SQUARE );
        strokeWeight( 1 );
        pointcross( tTextAttachPoint.x, tTextAttachPoint.y, 10 );
      }

      textFont( font_TSW_AbilityName );
      PVector tTextDimensions = new PVector( textWidth( ( (TSW_Ability)linkedNode ).name ) + EPSILON, textAscent() + textDescent() + EPSILON   );

      //      PVector tTextCenter = new PVector( tTextAttachPoint.x, tTextAttachPoint.y );
      //      tTextCenter.x += 0.5 * tTextDimensions.x * ( min_abs( sqrt(2) * cos( tMidAngle ), signof( cos( tMidAngle ) ) ) );
      //      tTextCenter.y += 0.5 * tTextDimensions.y * ( min_abs( sqrt(2) * sin( tMidAngle ), signof( sin( tMidAngle ) ) ) );

      float tAlpha = damper_hoverFactor.getValue();
      if ( parentTreeControl.isAbilitySelected( this ) ) { 
        float tMinAlpha = 0.1;
        tAlpha = tMinAlpha + (1.0 - tMinAlpha) * tAlpha;
      }

      //      rectMode( CENTER );
      //      textAlign( LEFT, TOP );
      //      fill( 0, 0, 1, tAlpha );
      //      text( ( (TSW_Ability)linkedNode ).name, tTextCenter.x, tTextCenter.y, tTextDimensions.x, tTextDimensions.y );

      UIOverlay_TextLayer_TextEntry tTextEntry = new UIOverlay_TextLayer_TextEntry();
      tTextEntry.displayString = linkedNode.name;
      tTextEntry.displayFont = font_TSW_AbilityName;
      tTextEntry.displayColor = color( 0, 0, 1, tAlpha );
      tTextEntry.anchorType = UIOverlay_TextLayer_TextEntry.ANCHORTYPE_CIRCULAR_SNAP;
      tTextEntry.anchorPos = tTextAttachPoint;
      tTextEntry.anchorAngle = tMidAngle;
      tTextEntry.hAlign = LEFT;
      tTextEntry.vAlign = TOP;
      textLayer_FrontMost.addTextEntry( tTextEntry );

      float tMinArcLength = 3;
      if ( tArcLength > tMinArcLength || damper_hoverFactor.getValue() > EPSILON )
      {
        float tMargin = 3;
        PVector tDescriptionAttachPoint = new PVector( tTextAttachPoint.x, tTextAttachPoint.y );
        tDescriptionAttachPoint.x += tTextDimensions.x * ( min_abs( sqrt(2) * cos( tMidAngle ), signof( cos( tMidAngle ) ) ) ) + signof( cos( tMidAngle ) ) * tMargin;
        tDescriptionAttachPoint.y += tTextDimensions.y * ( min_abs( sqrt(2) * sin( tMidAngle ), signof( sin( tMidAngle ) ) ) ) + signof( sin( tMidAngle ) ) * tMargin;

        if ( global_debug )
        {
          noFill();
          stroke( 0, 0, 0.3 );
          strokeCap( SQUARE );
          strokeWeight( 1 );
          pointcross( tDescriptionAttachPoint.x, tDescriptionAttachPoint.y, 10 );
        }

        PVector tDescriptionDimensions = new PVector( 150, 150 );

        int tTextHAlign = LEFT;
        int tTextVAlign = CENTER;

        textFont( font_TSW_AbilityDescription );
        float tTextLeading = textAscent() + textDescent() + 3;
        textLeading( tTextLeading );
        ArrayList<String> tDescriptionStrings = wrapTextForDisplay( ( (TSW_Ability)linkedNode ).description, tDescriptionDimensions.x );
        float tCalculatedHeight = tDescriptionStrings.size() * tTextLeading;
        tDescriptionDimensions.y = tCalculatedHeight;

        PVector tDescriptionCenter = new PVector( tDescriptionAttachPoint.x, tDescriptionAttachPoint.y );
        tDescriptionCenter.x += 0.5 * tDescriptionDimensions.x * ( min_abs( sqrt(2) * cos( tMidAngle ), signof( cos( tMidAngle ) ) ) );
        tDescriptionCenter.y += 0.5 * tDescriptionDimensions.y * ( min_abs( sqrt(2) * sin( tMidAngle ), signof( sin( tMidAngle ) ) ) );

        tAlpha *= max( min( ( tArcLength - tMinArcLength ) / 3.0, 1.0 ), 0.0 );
        tAlpha = max( tAlpha, damper_hoverFactor.getValue() );
          
        fill( 0, 0, 1, tAlpha );
        rectMode( CENTER );
        textAlign( tTextHAlign, tTextVAlign );
        text( ( (TSW_Ability)linkedNode ).description, tDescriptionCenter.x, tDescriptionCenter.y, tDescriptionDimensions.x, tDescriptionDimensions.y );

        if ( global_debug )
        {
          noFill();
          stroke( 0, 0, 0.3 );
          strokeCap( SQUARE );
          strokeWeight( 1 );
          rect( tDescriptionCenter.x, tDescriptionCenter.y, tDescriptionDimensions.x, tCalculatedHeight );
        }
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
  }
}


