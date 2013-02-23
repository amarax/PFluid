

class TSW_UIOverlay_Filter_AbilityTree extends UIOverlay
{
  TSW_UIControl_AbilityTree abilityTreeToFilter;
  
  boolean mainFilter;
  
  boolean transitingIn;
  boolean prevTransitingIn;
  
  public TSW_UIOverlay_Filter_AbilityTree( Global_Boolean aActivated )
  {
    super( aActivated, new PVector( 0, 0 ) );
  }
  
  public void setup( TSW_UIControl_AbilityTree aAbilityTree, boolean aMainFilter )
  {
    super.setup();
    
    abilityTreeToFilter = aAbilityTree;
    
    mainFilter = aMainFilter;
    
    transitingIn = false;
    prevTransitingIn = false;
  }
  
  public void update()
  {
    super.update();

    if( mainFilter )
    {
      filterEasingFactor.update( 1 ); 
    }
    
    updateTransitionStatus();
  }
  
  public void draw()
  {
    super.draw();
  }

  public boolean isMouseIn()
  {
    if( mainFilter )
    {
      float tDist = PVector.dist( abilityTreeToFilter.getCenterPos(), new PVector( mouseX, mouseY ) );
      float tMinDist = abilityTreeToFilter.outerRingSize.value - abilityTreeToFilter.innerRingSize.value;
      float tMaxDist = getSize();
      return tDist < tMaxDist && tDist > tMinDist;
    }
    
    return false;
  }

  protected void drawObscurer()
  {
    PVector tCenterPos = abilityTreeToFilter.getCenterPos();
    float tRadius = getSize();
    
    float tFactor = filterEasingFactor.getValue();
    //float tFactor = 0;
    float tAlpha = sqrt( 1 - tFactor );
    if( !mainFilter ) { tAlpha = sqrt( tFactor ); }
    tAlpha *= 0.8;
    
    noStroke();
    fill( 0, 0, 0.1, tAlpha );
    ellipse( tCenterPos.x, tCenterPos.y, tRadius, tRadius );
  }
  
  public float getSize()
  {
    return abilityTreeToFilter.outerRingSize.value + 160;
  }
  
  public void updateTransitionStatus()
  {
    prevTransitingIn = transitingIn;
    
    transitingIn = false;
    if( mainFilter )
    {
      if( filterEasingFactor.getRatio() < 0.5 )
        transitingIn = true;
      else
        transitingIn = false;
    }
  }
}




class TSW_UIControl_Filter_AbilityWheel extends UIControl
{
  TSW_Filter_Ability linkedFilter;
  TSW_UIControl_AbilityTree abilityTreeControl;
  
  float cFilterAddRatio, cCarryOverRatio;
  
  DampingHelper_Float dampingHelper_filterAddRatio, dampingHelper_carryOverRatio;
  DampingHelper_Float dampingHelper_textAngle;
  
  Rectangle cHitRect;
  
  public TSW_UIControl_Filter_AbilityWheel()
  {
    super( new Rectangle() );
    
    cHitRect = new Rectangle();
  }
  
  public void setup( TSW_Filter_Ability aLinkedFilter, TSW_UIControl_AbilityTree aAbilityTreeControl )
  {
    super.setup();
    
    linkedFilter = aLinkedFilter;
    abilityTreeControl = aAbilityTreeControl;
    
    cFilterAddRatio = 0.0;
    cCarryOverRatio = 0.0;
    
    float tDampingFactor = 0.2;
    dampingHelper_filterAddRatio = new DampingHelper_Float( tDampingFactor, cFilterAddRatio );
    dampingHelper_carryOverRatio = new DampingHelper_Float( tDampingFactor, cCarryOverRatio );
    
    dampingHelper_textAngle = new DampingHelper_Float( 0.2, calcTextAngle() );
    
    animHelper_hoverFactor = new DampingHelper_Float( 0.2, 0 );
  }
  
  public void update()
  {
    super.update();

    cFilterAddRatio = 0.0;
    cCarryOverRatio = 0.0;

    // Calculate carry over and current
    ArrayList<TSW_Ability> tFilteredAbilities = new ArrayList<TSW_Ability>();

    int tIndex = abilityTreeControl.abilityFilters.indexOf( linkedFilter );

    if( abilityTreeControl.filterModeExclusive.value )
    {
      boolean tActualActive = linkedFilter.active;
      linkedFilter.active = true;
      
      tFilteredAbilities = abilityTreeControl.evaluateFilters( abilityTreeControl.abilityTree.abilities, 0, tIndex );
      int tCurrentFilteredCumulative = tFilteredAbilities.size();
      
      linkedFilter.active = tActualActive;
      
      
      int tTotal = abilityTreeControl.abilityTree.abilities.size();
      
      cFilterAddRatio = 1.0 * tCurrentFilteredCumulative / tTotal;
    }
    else
    {
      // Calculate the first active filter
      int iIndex = 0;
      while( iIndex < abilityTreeControl.abilityFilters.size() && !abilityTreeControl.abilityFilters.get( iIndex ).active )
      {
        ++iIndex;
      }
      
      int tPreviousFilteredCumulative = 0;
      if( iIndex < tIndex && tIndex > 0 )
      {
        tFilteredAbilities = abilityTreeControl.evaluateFilters( abilityTreeControl.abilityTree.abilities, 0, tIndex-1 );
        tPreviousFilteredCumulative = tFilteredAbilities.size();
      }
      
      
      boolean tActualActive = linkedFilter.active;
      linkedFilter.active = true;
      
      tFilteredAbilities = abilityTreeControl.evaluateFilters( tFilteredAbilities, tIndex, tIndex );
      int tCurrentFilteredCumulative = tFilteredAbilities.size();
      
      linkedFilter.active = tActualActive;
      
      
      int tTotal = abilityTreeControl.abilityTree.abilities.size();
      
      cCarryOverRatio = 1.0 * tPreviousFilteredCumulative / tTotal;
      cFilterAddRatio = 1.0 * ( tCurrentFilteredCumulative - tPreviousFilteredCumulative ) / tTotal;
    }
    
    dampingHelper_filterAddRatio.update( cFilterAddRatio );
    dampingHelper_carryOverRatio.update( cCarryOverRatio );

    dampingHelper_textAngle.update( calcTextAngle() );    

    PVector tTextDimensions = new PVector( 150, 16 );

    PVector tAnchorPos = calcTextAnchorPoint();
    cHitRect.setRect( floor( tAnchorPos.x ), floor( tAnchorPos.y - tTextDimensions.y / 2 ), ceil( tTextDimensions.x ), ceil( tTextDimensions.y ) );
  }
  
  public void draw()
  {
    super.draw();
    
    PVector tCenterPos = abilityTreeControl.getCenterPos();
    float tRadius = calcRadius();
    final float CHECKBOX_SIZE = 16;
    PVector tAnchorPos = new PVector( 0, -calcRadius() );
    //tAnchorPos.rotate( ( dampingHelper_carryOverRatio.getValue() * TWO_PI + dampingHelper_filterAddRatio.getValue() * TWO_PI ) / 2 );
    tAnchorPos.rotate( PI/15 );
    tAnchorPos.add( tCenterPos );
    tAnchorPos.x += 4;
    
    final float BACKGROUND_ALPHA = 0.05;
    final float FOREGROUND_ALPHA_ACTIVE = 0.8;
    final float FOREGROUND_ALPHA_INACTIVE = 0.2;
    final float FOREGROUND_ALPHA_CARRYOVER = 0.5;

    
    float tStrokeWeight = 3;
    
    noFill();
    stroke( 0, 0, 0.8, BACKGROUND_ALPHA );
    strokeWeight( tStrokeWeight );
    ellipseMode( RADIUS );
    ellipse( tCenterPos.x, tCenterPos.y, tRadius, tRadius );
    
    float tLineLength = 5 - 2.5 + 10 * abilityTreeControl.abilityFilters.size();
    PVector tLineEnd = calcTextAnchorPoint();
    PVector tLineStart = new PVector( tLineEnd.x, tLineEnd.y );
    tLineStart.sub( tCenterPos );
    tLineStart.mult( -tLineLength / tLineStart.mag() );
    tLineStart.add( tLineEnd );
    line( tLineStart.x, tLineStart.y, tLineEnd.x, tLineEnd.y );
    
    tAnchorPos = tLineEnd;
    
//    noStroke();
//    fill( 0, 0, 1, 0.15 );
//    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1, 0.3 ); } 
//    rect( tAnchorPos.x, tAnchorPos.y - CHECKBOX_SIZE / 2, CHECKBOX_SIZE, CHECKBOX_SIZE, 4 );
//    
//    if( linkedFilter.active )
//    {
//      float tMargin = 3;
//      fill( 0, 0, 1, 0.3 );
//      if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1, 0.6 ); }
//      rect( tAnchorPos.x + tMargin, tAnchorPos.y - CHECKBOX_SIZE / 2 + tMargin, CHECKBOX_SIZE - tMargin * 2, CHECKBOX_SIZE - tMargin * 2, 2 );
//    }
    
    noFill();
    
    //float tStartAngle = ( dampingHelper_carryOverRatio.getValue() * TWO_PI + dampingHelper_filterAddRatio.getValue() * TWO_PI ) / 2 - HALF_PI, tEndAngle = 0, tAlpha = 0;
    //float tStartAngle = - HALF_PI, tEndAngle = 0, tAlpha = 0;
    //float tStartAngle = -HALF_PI + PI/15
    float tEndAngle = 0, tAlpha = 0;
    //float tStartAngle = -HALF_PI / 4.0 - 0.2;
    float tStartAngle = dampingHelper_textAngle.getValue();
//    float tStartAngle = -HALF_PI / 4.0; 
//    tStartAngle -= abilityTreeControl.abilityFilters.size() * -0.08;
//    tStartAngle += ( abilityTreeControl.abilityFilters.size() - abilityTreeControl.abilityFilters.indexOf( linkedFilter ) ) * -0.08;;
    
    if( dampingHelper_carryOverRatio.getValue() > 0 + EPSILON )
    {
      tEndAngle = tStartAngle;
      tStartAngle = tEndAngle - dampingHelper_carryOverRatio.getValue() * TWO_PI;
  
      tAlpha = FOREGROUND_ALPHA_CARRYOVER;
  
      stroke( 0, 0, 0.8, tAlpha );
      arc( tCenterPos.x, tCenterPos.y, tRadius, tRadius, tStartAngle, tEndAngle );
    }


    tEndAngle = tStartAngle;
    tStartAngle = tEndAngle - dampingHelper_filterAddRatio.getValue() * TWO_PI;

    tAlpha = linkedFilter.active ? FOREGROUND_ALPHA_ACTIVE : FOREGROUND_ALPHA_INACTIVE;

    stroke( 0, 0, 0.8, tAlpha );
    arc( tCenterPos.x, tCenterPos.y, tRadius, tRadius, tStartAngle, tEndAngle );
    
        
    
    tAlpha = 0.4;
    if( linkedFilter.active ) { tAlpha = 0.8; }
    if( this == hoveredControl || this == activeControl ) { tAlpha = ( 1.0 - tAlpha ) * animHelper_hoverFactor.getValue() + tAlpha; }
    fill( 0, 0, 0.8, tAlpha );
    textAlign( LEFT, CENTER );
    
    textFont( font_FilterName );
    text( getFilterName(), tAnchorPos.x + 4, tAnchorPos.y - 1 );
    float tNameWidth = textWidth( getFilterName() );
    
    textFont( font_FilterDetail );
    text( getFilterDetail(), tAnchorPos.x + 4 + tNameWidth, tAnchorPos.y - 1 );
  }
  
  
  public boolean isMouseIn()
  {
    Rectangle tRect = cHitRect;
    
    return tRect.contains( mouseX, mouseY );
  }
  
  public void onMousePressed()
  {
    super.onMousePressed();
    
    linkedFilter.active = !linkedFilter.active;

//    filterEasingFactor.start( 0.3 );
  }
  
  
  public float calcRadius()
  {
    float tOffset = 10 * ( abilityTreeControl.abilityFilters.size() - abilityTreeControl.abilityFilters.indexOf( linkedFilter ) );
    return abilityTreeControl.outerRingSize.value + 50 + tOffset;
  }
  
  public PVector calcTextAnchorPoint()
  {
    PVector tLineEnd = new PVector( calcRadius() + 5 + abilityTreeControl.abilityFilters.size() * 10, 0 );
    tLineEnd.rotate( dampingHelper_textAngle.getValue() );
    tLineEnd.add( abilityTreeControl.getCenterPos() );
    
    return tLineEnd;
  }
  
  public float calcTextAngle()
  {
    float tTextAngle = HALF_PI / 4.0;
    if( linkedFilter.active ) { tTextAngle *= -1; tTextAngle -= abilityTreeControl.abilityFilters.size() * -0.08; }
    tTextAngle += ( abilityTreeControl.abilityFilters.size() - abilityTreeControl.abilityFilters.indexOf( linkedFilter ) ) * -0.08;
    return tTextAngle;
  }
  
  public String getFilterName()
  {
    return "Empty Filter";
  }
  
  public String getFilterDetail()
  {
    return "";
  }
}



class TSW_UIOverlay_Filter_Ability_Name extends TSW_UIControl_Filter_AbilityWheel
{
  public String getFilterName()
  {
    return "Filter by name";
  }

  public String getFilterDetail()
  {
    return " " + ( (TSW_Filter_Ability_Name)linkedFilter ).searchString;
  }
}

class TSW_UIOverlay_Filter_Ability_Description extends TSW_UIControl_Filter_AbilityWheel
{
  public String getFilterName()
  {
    return "Filter by description";
  }

  public String getFilterDetail()
  {
    return " " + ( (TSW_Filter_Ability_Description)linkedFilter ).searchString;
  }
}

class TSW_UIOverlay_Filter_Ability_Unlocked extends TSW_UIControl_Filter_AbilityWheel
{
  public String getFilterName()
  {
    return "Filter unlocked abilities";
  }
}

class TSW_UIOverlay_Filter_Ability_Selected extends TSW_UIControl_Filter_AbilityWheel
{
  public String getFilterName()
  {
    return "Filter selected abilities";
  }
}
