
class EditableElement extends Entity
{
  String name;

  EditableElement()
  {
    super();

    name = "";
  }

  void addEditableChild( EditableElement aElement )
  {
    addChildEntity( aElement );
  }
}

static int EDGE_TOPLEFT = 7;
static int EDGE_TOP = 8;
static int EDGE_TOPRIGHT = 9;

static int EDGE_LEFT = 4;
static int EDGE_CENTER = 5;
static int EDGE_RIGHT = 6;

static int EDGE_BOTTOMLEFT = 1;
static int EDGE_BOTTOM = 2;
static int EDGE_BOTTOMRIGHT = 3;

static int PINARRAY_LEFT = 0;
static int PINARRAY_RIGHT = 1;
static int PINARRAY_TOP = 2;
static int PINARRAY_BOTTOM = 3;


class EditableRect extends EditableElement
{
  float top;
  float left;
  float bottom;
  float right;

  ArrayList<Rectangle> cRectArray;

  int edgeBeingEdited;

  ArrayList<EditableRectPin> pinArray;

  EditableRect()
  {
    super();

    name = "Rect";

    cRectArray = new ArrayList<Rectangle>();

    edgeBeingEdited = 0;

    pinArray = new ArrayList<EditableRectPin>();
    pinArray.add( new EditableRectPin( null, 0, 0 ) );
    pinArray.add( new EditableRectPin( null, 0, 0 ) );
    pinArray.add( new EditableRectPin( null, 0, 0 ) );
    pinArray.add( new EditableRectPin( null, 0, 0 ) );
  }

  void update()
  {
    super.update();

    calcEdgeRects();

    left = getPinnedSideValue( PINARRAY_LEFT );
    right = getPinnedSideValue( PINARRAY_RIGHT );
    top = getPinnedSideValue( PINARRAY_TOP );
    bottom = getPinnedSideValue( PINARRAY_BOTTOM );

    if ( mouseCursor.focusedEntity == this )
    {
      if ( uiModeManager.currentMode == UIMODE_RESIZING )
      {
        //println( edgeBeingEdited );  // should be debug
        switch( edgeBeingEdited % 3 )
        {
        case 0:
          right = mouseCursor.position.x;
          updateEdgeOffset( 1 );
          if ( right < left )
          {
            right = left;
            left = mouseCursor.position.x;
            edgeBeingEdited -= 2;
            
            swapPins( 1, 0 );
          }
          break;
        case 1:
          left = mouseCursor.position.x;
          updateEdgeOffset( 0 );
          if ( left > right )
          {
            left = right;
            right = mouseCursor.position.x;
            edgeBeingEdited += 2;

            swapPins( 1, 0 );
          }
          break;
        }

        switch( ( edgeBeingEdited - 1 ) / 3 )
        {
        case 0:
          bottom = mouseCursor.position.y;
          updateEdgeOffset( 3 );
          if ( bottom < top )
          {
            bottom = top;
            top = mouseCursor.position.y;
            edgeBeingEdited += 6;

            swapPins( 2, 3 );
          }
          break;
        case 2:
          top = mouseCursor.position.y;
          updateEdgeOffset( 2 );
          if ( top > bottom )
          {
            top = bottom;
            bottom = mouseCursor.position.y;
            edgeBeingEdited -= 6;

            swapPins( 2, 3 );
          }
          break;
        }
      } else if ( uiModeManager.currentMode == UIMODE_PINNING )
      {
      }
    }
  }

  void swapPins( int iIndexA, int iIndexB )
  {
    EditableRectPin tPin = pinArray.get(iIndexA);
    pinArray.set( iIndexA, pinArray.get(iIndexB) );
    pinArray.set( iIndexB, tPin );
  }

  float getPinnedSideSourceValue( int aPinnedSide )
  {
    EditableRectPin tPin = pinArray.get( aPinnedSide );
    if ( tPin.pinnedSource != null )
    {
      float tPinnedSourceValue = 0;
      if ( tPin.pinnedSourceEdge == PINARRAY_LEFT )
      {
        tPinnedSourceValue = tPin.pinnedSource.left;
      }
      if ( tPin.pinnedSourceEdge == PINARRAY_RIGHT )
      {
        tPinnedSourceValue = tPin.pinnedSource.right;
      }
      if ( tPin.pinnedSourceEdge == PINARRAY_TOP )
      {
        tPinnedSourceValue = tPin.pinnedSource.top;
      }
      if ( tPin.pinnedSourceEdge == PINARRAY_BOTTOM )
      {
        tPinnedSourceValue = tPin.pinnedSource.bottom;
      }
      return tPinnedSourceValue;
    }
    return 0;
  }

  float getPinnedSideValue( int aPinnedSide )
  {
    EditableRectPin tPin = pinArray.get( aPinnedSide );
    if ( tPin.pinnedSource != null )
    {
      float tPinnedSourceValue = 0;
      if ( tPin.pinnedSourceEdge == PINARRAY_LEFT )
      {
        tPinnedSourceValue = tPin.pinnedSource.left;
      }
      if ( tPin.pinnedSourceEdge == PINARRAY_RIGHT )
      {
        tPinnedSourceValue = tPin.pinnedSource.right;
      }
      if ( tPin.pinnedSourceEdge == PINARRAY_TOP )
      {
        tPinnedSourceValue = tPin.pinnedSource.top;
      }
      if ( tPin.pinnedSourceEdge == PINARRAY_BOTTOM )
      {
        tPinnedSourceValue = tPin.pinnedSource.bottom;
      }
      return tPinnedSourceValue + tPin.offset;
    }
    return getPinnedEdgeValue(aPinnedSide);
  }

  void plot()
  {
    super.plot();

    color tWireframeColor = this == world.selectedEntity ? color_selectedEditableElementRect : color_defaultEditableElementRect;
    if ( uiModeManager.currentMode == UIMODE_PINNING && mouseCursor.focusedEntity != this )
      tWireframeColor = isValidPinningTarget() ? tWireframeColor : color_greyedEditableElementRect;

    noFill();
    stroke( tWireframeColor );
    strokeWeight( 1 );
    rect( left, top, right-left, bottom-top );


    if ( this == mouseCursor.focusedEntity )
    {
      Rectangle tRect = cRectArray.get( edgeBeingEdited - 1 );
      noFill();
      stroke( color_editingEditableElement );
      strokeWeight( 1 );
      rect( tRect.x, tRect.y, tRect.width, tRect.height );
    } else if ( this == mouseCursor.hoveredEntity )
    {
      if ( uiModeManager.currentMode == UIMODE_PINNING && !isValidPinningTarget() )
      {
      } else
      {
        Rectangle tRect = cRectArray.get( getHoveredEdge() - 1 );
        noFill();
        stroke( color_editingEditableElement );
        strokeWeight( 1 );
        rect( tRect.x, tRect.y, tRect.width, tRect.height );
      }
    }

    int iIndex = 0;
    for ( EditableRectPin iPin : pinArray )
    {
      if ( iPin.pinnedSource != null )
      {
        PVector tOffset = new PVector( 0, 0 );
        PVector tPinPosition = new PVector( (left + right)/2.0, (top+bottom)/2.0 );
        if ( iIndex == PINARRAY_LEFT || iIndex == PINARRAY_RIGHT )
        {
          tOffset.x = iPin.offset;
        } else
        {
          tOffset.y = iPin.offset;
        }

        if ( iIndex == PINARRAY_LEFT )
        {
          tPinPosition.x = left;
        } else if ( iIndex == PINARRAY_RIGHT )
        {
          tPinPosition.x = right;
        } else if ( iIndex == PINARRAY_TOP )
        {
          tPinPosition.y = top;
        } else if ( iIndex == PINARRAY_BOTTOM )
        {
          tPinPosition.y = bottom;
        }

        noFill();
        stroke( tWireframeColor );
        strokeWeight( 1 );
        pinTriangle( tPinPosition.x, tPinPosition.y, -tOffset.x, -tOffset.y, 10 );
      }

      ++iIndex;
    }
  }

  boolean isMouseInside()
  {
    int tHoveredEdge = getHoveredEdge(); 
    return tHoveredEdge != 5 && tHoveredEdge != 0;
  }

  // Edge/corner based on numeric keypad, i.e. return 5 if no edge/corner is hovered 
  void calcEdgeRects()
  {
    cRectArray.clear();

    PVector tPosition = new PVector( left, top );
    PVector tSize = new PVector( right-left, bottom-top );

    if ( tSize.x < 0 )
    {
      tPosition.x += tSize.x;
      tSize.x *= -1;
    }
    if ( tSize.y < 0 )
    {
      tPosition.y += tSize.y;
      tSize.y *= -1;
    }

    PVector tInnerPosition = tPosition.get();
    PVector tInnerSize = tSize.get();

    tPosition.x -= wireframeSelectionMargin;
    tPosition.y -= wireframeSelectionMargin;
    tSize.x += wireframeSelectionMargin * 2;
    tSize.y += wireframeSelectionMargin * 2;

    tInnerPosition.x += wireframeSelectionMargin;
    tInnerPosition.y += wireframeSelectionMargin;
    tInnerSize.x -= wireframeSelectionMargin * 2;
    tInnerSize.y -= wireframeSelectionMargin * 2;

    int tXPos1 = floor( tPosition.x );
    int tXSize1 = ceil( tInnerPosition.x - tPosition.x );
    int tXPos2 = floor( tInnerPosition.x );
    int tXSize2 = ceil( tInnerSize.x );
    int tXPos3 = floor( tInnerPosition.x + tInnerSize.x );
    int tXSize3 = ceil( ( tPosition.x + tSize.x ) - ( tInnerPosition.x + tInnerSize.x ) );

    int tYPos = floor( tInnerPosition.y + tInnerSize.y );
    int tYSize = ceil( ( tPosition.y + tSize.y ) - ( tInnerPosition.y + tInnerSize.y ) );
    cRectArray.add( new Rectangle( tXPos1, tYPos, tXSize1, tYSize ) );
    cRectArray.add( new Rectangle( tXPos2, tYPos, tXSize2, tYSize ) );
    cRectArray.add( new Rectangle( tXPos3, tYPos, tXSize3, tYSize ) );

    tYPos = floor( tInnerPosition.y );
    tYSize = ceil( tInnerSize.y );
    cRectArray.add( new Rectangle( tXPos1, tYPos, tXSize1, tYSize ) );
    cRectArray.add( new Rectangle( tXPos2, tYPos, tXSize2, tYSize ) );
    cRectArray.add( new Rectangle( tXPos3, tYPos, tXSize3, tYSize ) );

    tYPos = floor( tPosition.y );
    tYSize = ceil( tInnerPosition.y - tPosition.y );
    cRectArray.add( new Rectangle( tXPos1, tYPos, tXSize1, tYSize ) );
    cRectArray.add( new Rectangle( tXPos2, tYPos, tXSize2, tYSize ) );
    cRectArray.add( new Rectangle( tXPos3, tYPos, tXSize3, tYSize ) );
  }

  int getHoveredEdge()
  {
    int tHoveredEdge = 1;
    for ( Rectangle iRect : cRectArray )
    {
      if ( iRect.contains( mouseCursor.position.x, mouseCursor.position.y ) )
      {
        return tHoveredEdge;
      }

      ++tHoveredEdge;
    }

    return 0;
  }

  int getPinnableEdgeIndex( int aEdgeCorner )
  {
    if ( aEdgeCorner == EDGE_LEFT )
    {
      return PINARRAY_LEFT;
    }
    if ( aEdgeCorner == EDGE_RIGHT )
    {
      return PINARRAY_RIGHT;
    }
    if ( aEdgeCorner == EDGE_TOP )
    {
      return PINARRAY_TOP;
    }
    if ( aEdgeCorner == EDGE_BOTTOM )
    {
      return PINARRAY_BOTTOM;
    }
    return 0;
  }

  int getPinnedTargetEdge()
  {
    return getPinnableEdgeIndex( edgeBeingEdited );
  }

  int getPinnedSourceEdge()
  {
    return getPinnableEdgeIndex( getHoveredEdge() );
  }

  float getPinnedEdgeValue( int aPinnedEdge )
  {
    if ( aPinnedEdge == PINARRAY_LEFT )
    {
      return left;
    }
    if ( aPinnedEdge == PINARRAY_RIGHT )
    {
      return right;
    }
    if ( aPinnedEdge == PINARRAY_TOP )
    {
      return top;
    }
    if ( aPinnedEdge == PINARRAY_BOTTOM )
    {
      return bottom;
    }
    return 0;
  }

  boolean isValidPinningTarget()
  {
    if ( mouseCursor.focusedEntity == null )
    {
      return false;
    }

    if ( this == mouseCursor.focusedEntity.parent )
    {
      return true;
    }

    return false;
  }

  void updateEdgeOffset( int aPinArrayIndex )
  {
    EditableRectPin tPin = pinArray.get( aPinArrayIndex );
    if ( tPin.pinnedSource != null )
    {
      tPin.offset = getPinnedEdgeValue( aPinArrayIndex ) - getPinnedSideSourceValue( aPinArrayIndex ) ;
    }
  }
}


class EditableRectPin
{
  EditableRect pinnedSource;
  int pinnedSourceEdge;
  float offset;

  EditableRectPin( EditableRect aPinnedSource, int aPinnedSourceEdge, float aOffset )
  {
    pinnedSource = aPinnedSource;
    pinnedSourceEdge = aPinnedSourceEdge;
    offset = aOffset;
  }
}

