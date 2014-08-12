
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




class EditableRect extends EditableElement
{
  float top;
  float left;
  float bottom;
  float right;

  ArrayList<Rectangle> cRectArray;

  int edgeBeingEdited;

  ArrayList<EditableRectPin> pinArray;

  EditableRect( PVector aPosition )
  {
    super();
    selectable = true;

    name = "Rect";

    cRectArray = new ArrayList<Rectangle>();

    edgeBeingEdited = 0;

    pinArray = new ArrayList<EditableRectPin>();
    pinArray.add( new EditableRectPinLocalAbsolute( null, PINARRAY_LEFT, 0.0, this ) );
    pinArray.add( new EditableRectPinLocalAbsolute( null, PINARRAY_RIGHT, 0.0, this ) );
    pinArray.add( new EditableRectPinLocalAbsolute( null, PINARRAY_TOP, 0.0, this ) );
    pinArray.add( new EditableRectPinLocalAbsolute( null, PINARRAY_BOTTOM, 0.0, this ) );

    position.set( aPosition );
    pinArray.get( PINARRAY_LEFT ).updateOffset( position.x );
    pinArray.get( PINARRAY_TOP ).updateOffset( position.y );
  }

  void update()
  {
    // If moving, update entity update first because it runs all position updates.
    if ( uiModeManager.currentMode == UIMODE_MOVING )
      super.update();

    for ( int i = PINARRAY_LEFT; i <= PINARRAY_BOTTOM; ++i )
    {
      //if ( !childEntities.contains( pinArray.get( i ).pinnedSource ) )
      setPinnableEdgeValue( i, pinArray.get( i ).calcPinnedEdgePosition() );
    }

    if ( mouseCursor.focusedEntity == this )
    {
      if ( uiModeManager.currentMode == UIMODE_RESIZING )
      {
        PVector tMouseRelativePos = mouseCursor.position;
        //        tMouseRelativePos.set( worldToLocal( tMouseRelativePos ) );
        //        tMouseRelativePos.sub( position );

        switch( edgeBeingEdited % 3 )
        {
        case 0:
          right = tMouseRelativePos.x;
          updatePin( 1 );
          if ( right < left )
          {
            right = left;
            left = tMouseRelativePos.x;
            edgeBeingEdited -= 2;

            swapPins( 1, 0 );
          }
          break;
        case 1:
          left = tMouseRelativePos.x;
          updatePin( 0 );
          if ( left > right )
          {
            left = right;
            right = tMouseRelativePos.x;
            edgeBeingEdited+= 2;

            swapPins( 1, 0 );
          }
          break;
        }

        switch( ( edgeBeingEdited - 1 ) / 3 )
        {
        case 0:
          bottom = tMouseRelativePos.y;
          updatePin( 3 );
          if ( bottom < top )
          {
            bottom = top;
            top = tMouseRelativePos.y;
            edgeBeingEdited += 6;

            swapPins( 2, 3 );
          }
          break;
        case 2:
          top = tMouseRelativePos.y;
          updatePin( 2 );
          if ( top > bottom )
          {
            top = bottom;
            bottom = tMouseRelativePos.y;
            edgeBeingEdited -= 6;

            swapPins( 2, 3 );
          }
          break;
        }
      } 
      else if ( uiModeManager.currentMode == UIMODE_PINNING )
      {
      }
    }

    if ( uiModeManager.currentMode != UIMODE_MOVING )
      super.update();

    calcEdgeRects();
  }

  void swapPins( int iIndexA, int iIndexB )
  {
    EditableRectPin tPin = pinArray.get(iIndexA);
    pinArray.set( iIndexA, pinArray.get(iIndexB) );
    pinArray.set( iIndexB, tPin );
  }

  void setPinnableEdgeValue( int aPinnableEdge, float aValue )
  {
    if ( aPinnableEdge == PINARRAY_LEFT )
    {
      left = aValue;
    }
    if ( aPinnableEdge == PINARRAY_RIGHT )
    {
      right = aValue;
    }
    if ( aPinnableEdge == PINARRAY_TOP )
    {
      top = aValue;
    }
    if ( aPinnableEdge == PINARRAY_BOTTOM )
    {
      bottom = aValue;
    }
  }

  float getPinnedSideValue( int aPinnedSide )
  {
    EditableRectPin tPin = pinArray.get( aPinnedSide );
    //if ( tPin.pinnedSource != null )
    {
      return tPin.calcPinnedEdgePosition();
    }
    // else
    //return getPinnedEdgeValue(aPinnedSide);
  }

  void plot()
  {
    color tWireframeColor = color_defaultEditableElementRect;
    if ( this == world.selectedEntity )
    {
      tWireframeColor = color_selectedEditableElementRect;
    }
    else if ( getParent() == world.selectedEntity && getParent() instanceof EditableRect )
    {
      tWireframeColor = color_selectedEditableElementRectChild;
    } 
    else
    {
      boolean tIsChildSelected = false;
      for ( Entity iChild : childEntities )
      {
        if ( iChild instanceof EditableRect )
        {
          EditableRect tRectChild = (EditableRect)iChild;
          if ( tRectChild == world.selectedEntity )
          {
            tIsChildSelected = true;
            break;
          }
        }
      }

      if (tIsChildSelected) 
      {
        tWireframeColor = color_selectedEditableElementRectParent;
      }
    }
    if ( uiModeManager.currentMode == UIMODE_PINNING && mouseCursor.focusedEntity != this )
      tWireframeColor = isValidPinningTarget() ? tWireframeColor : color_greyedEditableElementRect;

    noFill();
    stroke( tWireframeColor );
    strokeWeight( 1 );

    PVector tWorldPos = new PVector( left, top );
    //    tWorldPos.add( position );
    //    tWorldPos.set( localToWorld( tWorldPos ) );
    rect( tWorldPos.x, tWorldPos.y, right-left, bottom-top );

    int tEdgeRectIndex = -1;
    color tEdgeFillColor = color( 0, 0, 0, 0 );
    color tEdgeStrokeColor = color( 0, 0, 0, 0 );

    if ( this == mouseCursor.focusedEntity )
    {
      tEdgeRectIndex = edgeBeingEdited - 1;
      tEdgeFillColor = color_editedEdgeFill;
      plotEdgeRect( tEdgeRectIndex, tEdgeFillColor, tEdgeStrokeColor );
    }

    tEdgeRectIndex = -1;
    tEdgeFillColor = color( 0, 0, 0, 0 );
    if ( this == mouseCursor.hoveredEntity )
    {
      if ( uiModeManager.currentMode == UIMODE_PINNING )
      {
        if ( isValidPinningTarget() )
        {
          tEdgeRectIndex = getHoveredEdge() - 1;
          tEdgeStrokeColor = color_hoveredEdgeStroke;
        }
      } 
      else
      {
        tEdgeRectIndex = getHoveredEdge() - 1;
        tEdgeStrokeColor = color_hoveredEdgeStroke;
      }
    }
    plotEdgeRect( tEdgeRectIndex, tEdgeFillColor, tEdgeStrokeColor );

    if ( debug_editableRect_pinnedEdge && showPins )
    {
      tEdgeRectIndex = -1;
      tEdgeFillColor = color( 0, 0, 0, 0 );
      tEdgeStrokeColor = color( 0, 0, 0, 0 );
      EditableRect tPinnedRect = null;
      int tPinnableEdgeIndex = -1;
      if ( mouseCursor.focusedEntity != null )
      {
        if ( mouseCursor.focusedEntity instanceof EditableRect )
        {
          tPinnedRect = (EditableRect)( mouseCursor.focusedEntity );
          tPinnableEdgeIndex = getPinnableEdgeIndex( tPinnedRect.edgeBeingEdited );
        }
      } 
      else if ( mouseCursor.hoveredEntity != null )
      {
        if ( mouseCursor.hoveredEntity instanceof EditableRect )
        {
          tPinnedRect = (EditableRect)( mouseCursor.hoveredEntity );
          tPinnableEdgeIndex = getPinnableEdgeIndex( tPinnedRect.getHoveredEdge() );
        }
      }

      if ( tPinnedRect != null )
      {
        if ( tPinnableEdgeIndex >= 0 )
        {
          EditableRectPin tFocusedPin = tPinnedRect.pinArray.get( tPinnableEdgeIndex );
          if ( tFocusedPin.pinnedSource == this )
          {
            tEdgeRectIndex = getEdgeRectIndex( tFocusedPin.pinnedSourceEdge ) - 1;
            tEdgeFillColor = color_pinSourceEdgeFill;
            plotEdgeRect( tEdgeRectIndex, tEdgeFillColor, tEdgeStrokeColor );

            if ( tFocusedPin instanceof EditableRectPinRelative )
            {
              tEdgeRectIndex = getEdgeRectIndex( getOppositePinnedEdgeIndex( tFocusedPin.pinnedSourceEdge ) ) - 1;
              plotEdgeRect( tEdgeRectIndex, tEdgeFillColor, tEdgeStrokeColor );
            }
          }
        }
      }
    }


    if ( showPins )
    {
      int iIndex = 0;
      for ( EditableRectPin iPin : pinArray )
      {
        if ( !(iPin instanceof EditableRectPinLocalAbsolute ) )
        {
          PVector tWorldTopLeft = new PVector( left, top );
          //          tWorldTopLeft.add( position );
          //          tWorldTopLeft.set( localToWorld( tWorldTopLeft ) );

          PVector tWorldBottomRight = new PVector( right, bottom );
          //          tWorldBottomRight.add( position );
          //          tWorldBottomRight.set( localToWorld( tWorldBottomRight ) );

          PVector tPinPosition = new PVector( (tWorldTopLeft.x + tWorldBottomRight.x)/2.0, (tWorldTopLeft.y + tWorldBottomRight.y)/2.0 );
          if ( iIndex == PINARRAY_LEFT )
          {
            tPinPosition.x = tWorldTopLeft.x;
          } 
          else if ( iIndex == PINARRAY_RIGHT )
          {
            tPinPosition.x = tWorldBottomRight.x;
          } 
          else if ( iIndex == PINARRAY_TOP )
          {
            tPinPosition.y = tWorldTopLeft.y;
          } 
          else if ( iIndex == PINARRAY_BOTTOM )
          {
            tPinPosition.y = tWorldBottomRight.y;
          }

          PVector tOffset = new PVector( 0, 0 );
          float tPinTriangleSize = 6;
          float tPinArcSize = tPinTriangleSize * 1.5;
          if ( iPin instanceof EditableRectPinOffset )
          {
            EditableRectPinOffset tOffsetPin = (EditableRectPinOffset)iPin;

            if ( iIndex == PINARRAY_LEFT || iIndex == PINARRAY_RIGHT )
            {
              tOffset.x = tOffsetPin.offset;
            } 
            else
            {
              tOffset.y = tOffsetPin.offset;
            }

            if ( iPin instanceof EditableRectPinGlobalOffset )
              fill( tWireframeColor );
            else
              noFill();
              
            stroke( tWireframeColor );
            strokeWeight( 1 );

            if ( childEntities.contains( tOffsetPin.pinnedSource ) )
            {
              pinArc( tPinPosition.x, tPinPosition.y, tOffset.x, tOffset.y, tPinArcSize );
            } 
            else
            {
              pinTriangle( tPinPosition.x, tPinPosition.y, -tOffset.x, -tOffset.y, tPinTriangleSize );
            }
          } 
          else if ( iPin instanceof EditableRectPinRelative )
          {
            EditableRectPinRelative tOffsetPin = (EditableRectPinRelative)iPin;

            if ( iIndex == PINARRAY_LEFT || iIndex == PINARRAY_RIGHT )
            {
              tOffset.x = 1.0;
            } 
            else
            {
              tOffset.y = 1.0;
            }

            noFill();
            stroke( tWireframeColor );
            strokeWeight( 1 );
            pinTriangle( tPinPosition.x, tPinPosition.y, -tOffset.x, -tOffset.y, tPinTriangleSize );
            pinTriangle( tPinPosition.x, tPinPosition.y, tOffset.x, tOffset.y, tPinTriangleSize );
          }

          if ( debug_editableRect_pins )
          {
            textAlign( LEFT, TOP );
            String[] tClassStrings = split( iPin.getClass().getCanonicalName(), "." );
            String tDebugDisplayString = tClassStrings[tClassStrings.length - 1];
            debugText( tDebugDisplayString, tPinPosition.x, tPinPosition.y );
            if ( iPin instanceof EditableRectPinOffset )
            {
              tDebugDisplayString = "Offset=";
              tDebugDisplayString += ((EditableRectPinOffset)iPin).offset;
              debugText( tDebugDisplayString );
            }
          }
        }


        ++iIndex;
      }
    }
    super.plot();
  }

  void plotEdgeRect( int aRectIndex, color aStrokeColor )
  {
    plotEdgeRect( aRectIndex, color( 0, 0, 0, 0 ), aStrokeColor );
  }

  void plotEdgeRect( int aRectIndex, color aFillColor, color aStrokeColor )
  {
    if ( aRectIndex < 0 || aRectIndex >= cRectArray.size() )
      return;

    if( aRectIndex == 4 )
    {
      return;
    }
      
    Rectangle tRect = cRectArray.get( aRectIndex );

    if ( alpha( aFillColor ) > EPSILON )
    {
      fill( aFillColor );
    } 
    else
    {
      noFill();
    }

    if ( alpha( aStrokeColor ) > EPSILON )
    {
      stroke( aStrokeColor );
      strokeWeight( 1 );
    } 
    else
    {
      noStroke();
    }
    rect( tRect.x, tRect.y, tRect.width, tRect.height );
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
    //    tPosition.add( position );
    //    tPosition.set( localToWorld( tPosition ) );
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
      return false;

    if ( this == mouseCursor.focusedEntity.parent )
      return true;

    if ( getParent() == mouseCursor.focusedEntity.getParent() && this != mouseCursor.focusedEntity )
      return true;

    if ( getParent() == mouseCursor.focusedEntity )
      return true;

    if( this == mouseCursor.focusedEntity )
      return true;

    return false;
  }

  void updatePin( int aPinArrayIndex )
  {
    EditableRectPin tPin = pinArray.get( aPinArrayIndex );
    tPin.updateOffset( getPinnedEdgeValue(aPinArrayIndex) );
  }

  void mirrorChildren( Entity aMirroredEntity )
  {
    for ( Entity iChild : childEntities )
    {
      if ( iChild instanceof EditableRect )
      {
        ( (EditableRect)iChild ).mirror( aMirroredEntity );
      }
    }
  }

  void mirror( Entity aMirroredEntity )
  {
    swapPins( 1, 0 );
    pinArray.get( PINARRAY_LEFT ).mirror();
    pinArray.get( PINARRAY_RIGHT ).mirror();

    float tNewXPos = position.x; 

    if ( getParent() instanceof EditableRect && getParent() == aMirroredEntity )
    {
      EditableRect tParentRect = (EditableRect)getParent();
      float tRelativePos = 1 - ( localToWorld( position ).x - tParentRect.getPinnedEdgeValue( PINARRAY_LEFT ) ) / ( tParentRect.getPinnedEdgeValue( PINARRAY_RIGHT ) - tParentRect.getPinnedEdgeValue( PINARRAY_LEFT ) );
      tNewXPos = worldToLocal( new PVector( tParentRect.getPinnedEdgeValue( PINARRAY_LEFT ) * (1-tRelativePos) + tParentRect.getPinnedEdgeValue( PINARRAY_RIGHT ) * tRelativePos, 0 ) ).x;
    }
    else
    {
      tNewXPos *= -1;
    }

    mirrorChildren( aMirroredEntity );
    
    position.x = tNewXPos;
  }

  void onSetParent( Entity aPreviousParent )
  {
    for ( EditableRectPin iPin : pinArray )
    {
      if ( iPin instanceof EditableRectPinLocalAbsolute )
      {
        ( (EditableRectPinLocalAbsolute)iPin ).pinnedSource = getParent();
      }

      //iPin.updateOffset( getPinnedEdgeValue( pinArray.indexOf( iPin ) ) );
    }
  }

  void processMousePressed()
  {
    super.processMousePressed();

    if ( uiModeManager.currentMode == UIMODE_RESIZING )
    {
      if ( getParent() instanceof EditableRect )
      {
        world.selectedEntity = getParent();
      } 

      uiModeManager.currentMode = UIMODE_RESIZABLE;
    }
    else if ( uiModeManager.currentMode == UIMODE_PINNING )
    {
      if ( mouseCursor.hoveredEntity instanceof EditableRect )
      {
        EditableRect tSourceRect = (EditableRect)( mouseCursor.hoveredEntity );
        EditableRect tTargetRect = this;
        if ( tSourceRect.isValidPinningTarget() )
        {
          int tPinnedSourceEdge = tSourceRect.getPinnedSourceEdge();
          int tPinnedTargetEdge = tTargetRect.getPinnedTargetEdge();

          float tTargetEdgeCurrentValue = tTargetRect.getPinnedEdgeValue( tPinnedTargetEdge );
          EditableRectPin tPin = null;
          if ( tPinnedSourceEdge == tPinnedTargetEdge || tPinnedSourceEdge == getOppositePinnedEdgeIndex( tPinnedTargetEdge ) )
          {
            tPin = new EditableRectPinOffset( tSourceRect, tPinnedSourceEdge, tTargetEdgeCurrentValue );
          }
          else
          {
            // Get diagonal edge
            tPinnedSourceEdge += 2;
            tPinnedSourceEdge = tPinnedSourceEdge % 4;

            tPin = new EditableRectPinRelative( tSourceRect, tPinnedSourceEdge, tTargetEdgeCurrentValue );
          }

          tTargetRect.pinArray.set( tPinnedTargetEdge, tPin );
        }
      }

      uiModeManager.currentMode = UIMODE_PINNABLE;
      mouseCursor.focusLocked = false;
    } 
    else if ( uiModeManager.currentMode == UIMODE_RESIZABLE )
    {
      edgeBeingEdited = getHoveredEdge();
      uiModeManager.currentMode = UIMODE_RESIZING;

      mouseCursor.focusLocked = true;
    } 
    else if ( uiModeManager.currentMode == UIMODE_PINNABLE )
    {
      edgeBeingEdited = getHoveredEdge();
      uiModeManager.currentMode = UIMODE_PINNING;

      mouseCursor.focusLocked = true;
    }
  }

  void processMouseReleased()
  {
    super.processMouseReleased();

    if ( uiModeManager.currentMode == UIMODE_RESIZING )
    {
      uiModeManager.currentMode = UIMODE_RESIZABLE;
      mouseCursor.focusLocked = false;

      if ( world.selectedEntity == null )
      {
        world.selectedEntity = this;
      }
    }
  }
}

