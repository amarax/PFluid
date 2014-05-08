

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

    if ( mainFilter )
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
    if ( mainFilter )
    {
      float tDist = PVector.dist( abilityTreeToFilter.getCenterPos(), new PVector( mouseX, mouseY ) );
      float tMinDist = abilityTreeToFilter.getSize() - abilityTreeToFilter.innerRingSize.value;
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
    if ( !mainFilter ) { 
      tAlpha = sqrt( tFactor );
    }
    tAlpha *= 0.8;

    if ( tAlpha > EPSILON )
    {
      noStroke();
      fill( 0, 0, 0.1, tAlpha );
      ellipse( tCenterPos.x, tCenterPos.y, tRadius, tRadius );
    }
  }

  public float getSize()
  {
    return abilityTreeToFilter.getSize() + 160;
  }

  public void updateTransitionStatus()
  {
    prevTransitingIn = transitingIn;

    transitingIn = false;
    if ( mainFilter )
    {
      if ( filterEasingFactor.getRatio() < 0.5 )
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

  boolean editMode;

  float cFilterAddRatio, cCarryOverRatio;

  DampingHelper_Float dampingHelper_filterAddRatio, dampingHelper_carryOverRatio;
  DampingHelper_Float dampingHelper_textAngle;

  boolean dragging;

  Rectangle cHitRect;
  
  protected PVector cDescriptionMiddleLeft;

  public TSW_UIControl_Filter_AbilityWheel()
  {
    super( new Rectangle() );

    cHitRect = new Rectangle();

    editMode = false;
    
    dragging = false;
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
    
    if( mousePressedPos != null )
    {
      if( !dragging )
      {
        if( mouseX != mousePressedPos.x || mouseY != mousePressedPos.y )
        {
          dragging = true;
        }
      }
    }
    
    // editMode = !dragging;

    if( dragging )
    {
      animHelper_hoverFactor.update( 1 );
      
      dampingHelper_textAngle.setDampingFactor( 1 );
    }
    else
    {
      dampingHelper_textAngle.setDampingFactor( 0.2 );
    }
    
    linkedFilter.active = dampingHelper_textAngle.getValue() < 0;
    

    // TODO Should update extents rect 
    rect = new Rectangle();

    if( activeControl == null )
    {
      editMode = this == hoveredControl;
    }
    else
    {
      editMode = this == activeControl;
    }

    cFilterAddRatio = 0.0;
    cCarryOverRatio = 0.0;

    // Calculate carry over and current
    ArrayList<TSW_Ability> tFilteredAbilities = new ArrayList<TSW_Ability>();

    int tIndex = abilityTreeControl.abilityFilters.indexOf( linkedFilter );

    if ( abilityTreeControl.filterModeExclusive.value )
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
      while ( iIndex < abilityTreeControl.abilityFilters.size () && !abilityTreeControl.abilityFilters.get( iIndex ).active )
      {
        ++iIndex;
      }

      int tPreviousFilteredCumulative = 0;
      if ( iIndex < tIndex && tIndex > 0 )
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
    int tMargin = 10;
    cHitRect.setRect( floor( tAnchorPos.x ) - tMargin, floor( tAnchorPos.y - tTextDimensions.y / 2 ) - tMargin, ceil( tTextDimensions.x ) + 2 * tMargin, ceil( tTextDimensions.y ) + 2 * tMargin );
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

    float tEndAngle = 0, tAlpha = 0;
    float tStartAngle = dampingHelper_textAngle.getValue() + 1.0 / tRadius;

    if ( dampingHelper_carryOverRatio.getValue() > 0 + EPSILON )
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


    tAlpha = BACKGROUND_ALPHA;

    tAnchorPos = calcTextAnchorPoint();

    float tLineLength = 5 - 2 + 10 * abilityTreeControl.abilityFilters.size() - 4;
    PVector tLineEnd = new PVector( tAnchorPos.x, tAnchorPos.y );
    tLineEnd.sub( tCenterPos );
    tLineEnd.mult( ( tLineEnd.mag() - 4 ) / tLineEnd.mag() );
    tLineEnd.add( tCenterPos ); 
    PVector tLineStart = new PVector( tLineEnd.x, tLineEnd.y );
    tLineStart.sub( tCenterPos );
    tLineStart.mult( -tLineLength / tLineStart.mag() );
    tLineStart.add( tLineEnd );

    stroke( 0, 0, 0.8, tAlpha );
    line( tLineStart.x, tLineStart.y, tLineEnd.x, tLineEnd.y );


    tAlpha = 0.4;
    if ( linkedFilter.active ) { 
      tAlpha = 0.8;
    }
    if ( this == hoveredControl || this == activeControl || animHelper_hoverFactor.getValue() > EPSILON ) { 
      tAlpha = ( 1.0 - tAlpha ) * animHelper_hoverFactor.getValue() + tAlpha;
    }

    String tDisplayText = getFilterName();

    fill( 0, 0, 0.8, tAlpha );
    textAlign( LEFT, CENTER );

    textFont( font_FilterName );
    float tTextHeight = textAscent() + textDescent(); 
    PVector tTextDimensions = new PVector( textWidth( tDisplayText ) + EPSILON, tTextHeight );
    PVector tTextCenter = calcArcAnchoredTextCenter( tTextDimensions, tAnchorPos, dampingHelper_textAngle.getValue() );

    rectMode( CENTER );
    text( tDisplayText, tTextCenter.x, tTextCenter.y, tTextDimensions.x, tTextDimensions.y );
    rectMode( CORNER );
    
    cDescriptionMiddleLeft = new PVector( tTextCenter.x + tTextDimensions.x / 2, tTextCenter.y );
  }


  public boolean isMouseIn()
  {
    Rectangle tRect = cHitRect;

    return tRect.contains( mouseX, mouseY );
  }

  public void onMousePressed()
  {
    super.onMousePressed();

    //linkedFilter.active = !linkedFilter.active;

    //    filterEasingFactor.start( 0.3 );
  }
  
  public void onMouseReleased()
  {
    super.onMouseReleased();
    
    dragging = false;
  }

  public void onMouseReleasedOutside()
  {
    super.onMouseReleasedOutside();
    
    dragging = false;
  }


  public float calcRadius()
  {
    float tOffset = 10 * ( abilityTreeControl.abilityFilters.size() - abilityTreeControl.abilityFilters.indexOf( linkedFilter ) );
    return abilityTreeControl.getSize() + 50 + tOffset;
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
    int tDisplayIndex = 0;

    int iIndex = 0;
    while ( iIndex < abilityTreeControl.abilityFilters.indexOf ( linkedFilter ) )
    {
      if ( abilityTreeControl.abilityFilters.get( iIndex ).active == linkedFilter.active )
      {
        ++tDisplayIndex;
      }

      ++iIndex;
    }

    int tTotalFilters = abilityTreeControl.abilityFilters.size();
    if ( linkedFilter.active )
    {
      tTotalFilters = 0;
      for ( TSW_Filter_Ability iFilter : abilityTreeControl.abilityFilters )
      {
        if ( iFilter.active )
        {
          ++tTotalFilters;
        }
      }
    }

    float tAngleMargin = 0.08;
    float tInactiveAngle = HALF_PI / 3.0;
    float tActiveAngle = tInactiveAngle;
    tInactiveAngle += ( tTotalFilters - tDisplayIndex ) * -tAngleMargin;
    tActiveAngle *= -1; 
    tActiveAngle -= abilityTreeControl.abilityFilters.size() * -tAngleMargin;
    tActiveAngle += ( tTotalFilters - tDisplayIndex ) * -tAngleMargin;

    if( dragging )
    {
      float tDraggedAngle = atan2( mouseY - abilityTreeControl.getCenterPos().y, mouseX - abilityTreeControl.getCenterPos().x );
      //return max( min( tDraggedAngle, tInactiveAngle ), tActiveAngle );
      return tDraggedAngle;
    }

    if( linkedFilter.active )
    {
      return tActiveAngle;
    }
    
    return tInactiveAngle;
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


class TSW_UIOverlay_Filter_Ability_EditableString extends TSW_UIControl_Filter_AbilityWheel
{
  int caretPos;

  protected TSW_UIOverlay_Filter_Ability_EditableString()
  {
    super();
  }

  public void setup( TSW_Filter_Ability aLinkedFilter, TSW_UIControl_AbilityTree aAbilityTreeControl )
  {
    super.setup( aLinkedFilter, aAbilityTreeControl );

    if ( linkedFilter instanceof TSW_Filter_Ability_SearchString )
    {
      caretPos = getSearchString().length();
    }
  }

  public void update()
  {
    super.update();

    if ( !editMode && animHelper_hoverFactor.getValue() < EPSILON )
    {
      caretPos = getSearchString().length();
    }
  }

  public void draw()
  {
    super.draw();

    PVector tTextAnchorPoint = new PVector( cDescriptionMiddleLeft.x, cDescriptionMiddleLeft.y );
    tTextAnchorPoint.x += 3;

    textFont( font_FilterDetail );

    float tAlpha = 0.4;
    if ( linkedFilter.active ) { 
      tAlpha = 0.8;
    }
    if ( this == hoveredControl || this == activeControl || animHelper_hoverFactor.getValue() > EPSILON ) { 
      tAlpha = ( 1.0 - tAlpha ) * animHelper_hoverFactor.getValue() + tAlpha;
    }

    if ( ( this == activeControl || editMode ) && animHelper_hoverFactor.getValue() > EPSILON )
    {
      float tCaretXPos = calcCaretXPos();
      float tTextHeight = textAscent() + textDescent();
      float tMargin = 2;
      PVector tCaretTopLeft = new PVector( tTextAnchorPoint.x + tCaretXPos, tTextAnchorPoint.y - tTextHeight / 2.0 - tMargin );
      
      float tFactor = editMode ? 1 : animHelper_hoverFactor.getValue();

      noStroke();
      fill( 0, 0, 0.8, 0.3 * tAlpha * animHelper_hoverFactor.getValue() );
      rect( tTextAnchorPoint.x - 0.5 + tCaretXPos * tFactor, tCaretTopLeft.y, 1 + textWidth( getSearchString() ) * ( 1 - tFactor ), tTextHeight + 2 * tMargin );
    }

    fill( 0, 0, 0.8, tAlpha );
    //text( getFilterDetail(), tTextAnchorPoint.x + 4 + tNameWidth, tTextAnchorPoint.y );
    text( getSearchString(), tTextAnchorPoint.x, tTextAnchorPoint.y );
  }

  public void onKeyPressed()
  {
    super.onKeyPressed();

    if ( !editMode ) { 
      return;
    }

    if ( linkedFilter instanceof TSW_Filter_Ability_SearchString )
    {
      String tSearchString = getSearchString();   // NOTE copies the string, is not an object reference

      if ( key == CODED )
      {
        switch( keyCode )
        {
        case LEFT:
          {
            --caretPos;
            break;
          }
        case RIGHT:
          {
            ++caretPos;
            break;
          }
        }

        if ( caretPos < 0 ) { 
          caretPos = 0;
        }
        if ( caretPos > getSearchString().length() ) { 
          caretPos = getSearchString().length();
        }
      }
    }
  }

  public void onKeyTyped()
  {
    super.onKeyTyped();

    if ( !editMode ) { 
      return;
    }

    if ( linkedFilter instanceof TSW_Filter_Ability_SearchString )
    {
      String tSearchString = getSearchString();   // NOTE copies the string, is not an object reference

      String tStringBefore = "", tStringAfter = "";
      if ( caretPos >= 0 )
      {
        if ( caretPos <= tSearchString.length() ) { 
          tStringBefore = tSearchString.substring( 0, caretPos );
        }
        tStringAfter = tSearchString.substring( caretPos );
      }

      if ( key != CODED )
      {
        switch( key )
        {
        case ENTER:
        case RETURN:
        case ESC:
          break;
        case BACKSPACE:
          {
            if ( tStringBefore.length() > 0 )
            {
              tSearchString = tStringBefore.substring( 0, tStringBefore.length() - 1 ) + tStringAfter;
              --caretPos;
            }
            break;
          }
        case DELETE:
          {
            if ( tStringAfter.length() > 0 )
            {
              tSearchString = tStringBefore + tStringAfter.substring( 1, tStringAfter.length() );
            }
            break;
          }
        default:
          {
            tSearchString = tStringBefore + key + tStringAfter;
            ++caretPos;
          }
        }
      }

      ( (TSW_Filter_Ability_SearchString)linkedFilter ).searchString = tSearchString;
    }
  }

  public float calcCaretXPos()
  {
    String tSearchString = getSearchString();

    return textWidth( tSearchString.substring( 0, caretPos ) );
  }

  protected String getSearchString()
  {
    return getFilterDetail();
  }
}



class TSW_UIOverlay_Filter_Ability_Name extends TSW_UIOverlay_Filter_Ability_EditableString
{
  public String getFilterName()
  {
    return "Filter by name";
  }

  public String getFilterDetail()
  {
    return ( (TSW_Filter_Ability_Name)linkedFilter ).searchString;
  }
}

class TSW_UIOverlay_Filter_Ability_Description extends TSW_UIOverlay_Filter_Ability_EditableString
{
  public String getFilterName()
  {
    return "Filter by description";
  }

  public String getFilterDetail()
  {
    return ( (TSW_Filter_Ability_Description)linkedFilter ).searchString;
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

