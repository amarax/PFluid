
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

  private ArrayList<EditableRectPin> pinArray;

  EditableRect( PVector aPosition )
  {
    super();
    selectable = true;

    name = "Rect";

    cRectArray = new ArrayList<Rectangle>();

    edgeBeingEdited = 0;

    pinArray = new ArrayList<EditableRectPin>();
    pinArray.add( new EditableRectPinLocalAbsolute( this, PinEdge.PINEDGE_LEFT ) );
    pinArray.add( new EditableRectPinLocalAbsolute( this, PinEdge.PINEDGE_RIGHT ) );
    pinArray.add( new EditableRectPinLocalAbsolute( this, PinEdge.PINEDGE_TOP ) );
    pinArray.add( new EditableRectPinLocalAbsolute( this, PinEdge.PINEDGE_BOTTOM ) );

    position.set( aPosition );
    getPin( PinEdge.PINEDGE_LEFT ).updateOffset( position.x );
    getPin( PinEdge.PINEDGE_TOP ).updateOffset( position.y );
  }

  void update()
  {
    // If moving, update entity update first because it runs all position updates. 
    if ( mouseCursor.focusedEntity == this && uiModeManager.currentMode == UIMODE_MOVING )
      super.update();

    if ( mouseCursor.focusedEntity == this )
    {
      if ( uiModeManager.currentMode == UIMODE_RESIZING )
      {
        PVector tMouseRelativePos = mouseCursor.position;

        switch( edgeBeingEdited % 3 )
        {
        case 0:
          getPin( PinEdge.PINEDGE_RIGHT ).updateOffset( tMouseRelativePos.x );
          break;
        case 1:
          getPin( PinEdge.PINEDGE_LEFT ).updateOffset( tMouseRelativePos.x );
          break;
        }

        switch( ( edgeBeingEdited - 1 ) / 3 )
        {
        case 0:
          getPin( PinEdge.PINEDGE_BOTTOM ).updateOffset( tMouseRelativePos.y );
          break;
        case 2:
          getPin( PinEdge.PINEDGE_TOP ).updateOffset( tMouseRelativePos.y );
          break;
        }

        // Swap if necessary
        if ( getPin( PinEdge.PINEDGE_RIGHT ).calcPinnedEdgePosition() < getPin( PinEdge.PINEDGE_LEFT ).calcPinnedEdgePosition() )
        {
          // Swap horizontally
          swapPins( PinEdge.PINEDGE_LEFT, PinEdge.PINEDGE_RIGHT );
          edgeBeingEdited = getHorizontallyOppositeEdgeIndex( edgeBeingEdited );
        }

        if ( getPin( PinEdge.PINEDGE_BOTTOM ).calcPinnedEdgePosition() < getPin( PinEdge.PINEDGE_TOP ).calcPinnedEdgePosition() )
        {
          // Swap vertically
          swapPins( PinEdge.PINEDGE_TOP, PinEdge.PINEDGE_BOTTOM );
          edgeBeingEdited = getVerticallyOppositeEdgeIndex( edgeBeingEdited );
        }
      }
    }

    // FK pass
    for ( EditableRectPin iPin : pinArray )
    {
      if ( !childEntities.contains( iPin.pinnedSource ) )
        iPin.updateTarget();
    }

    super.update();

    // IK pass
    for ( EditableRectPin iPin : pinArray )
    {
      if ( childEntities.contains( iPin.pinnedSource ) )
        iPin.updateTarget();
    }

    calcEdgeRects();
  }

  void swapPins( PinEdge aEdgeA, PinEdge aEdgeB )
  {
    if ( aEdgeA.arrayIndex < 0 || aEdgeA.arrayIndex >= pinArray.size() )
      return;
    if ( aEdgeB.arrayIndex < 0 || aEdgeB.arrayIndex >= pinArray.size() )
      return;

    EditableRectPin tPinA = getPin( aEdgeA );
    EditableRectPin tPinB = getPin( aEdgeB );

    pinArray.set( aEdgeA.arrayIndex, tPinB );
    pinArray.set( aEdgeB.arrayIndex, tPinA );
  }

  float getPinnedSideValue( PinEdge aPinnedSide )
  {
    if ( aPinnedSide.arrayIndex < 0 || aPinnedSide.arrayIndex >= pinArray.size() )
      return 0;

    EditableRectPin tPin = getPin( aPinnedSide );
    return tPin.calcPinnedEdgePosition();
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
      PinEdge tPinnedEdge = PinEdge.PINEDGE_INVALID;
      if ( mouseCursor.focusedEntity != null )
      {
        if ( mouseCursor.focusedEntity instanceof EditableRect )
        {
          tPinnedRect = (EditableRect)( mouseCursor.focusedEntity );
          tPinnedEdge = getPinEdge( tPinnedRect.edgeBeingEdited );
        }
      } 
      else if ( mouseCursor.hoveredEntity != null )
      {
        if ( mouseCursor.hoveredEntity instanceof EditableRect )
        {
          tPinnedRect = (EditableRect)( mouseCursor.hoveredEntity );
          tPinnedEdge = getPinEdge( tPinnedRect.getHoveredEdge() );
        }
      }

      if ( tPinnedRect != null )
      {
        if ( tPinnedEdge != PinEdge.PINEDGE_INVALID )
        {
          EditableRectPin tFocusedPin = tPinnedRect.getPin( tPinnedEdge );
          if ( tFocusedPin.pinnedSource == this && !(tFocusedPin instanceof EditableRectPinLocalAbsolute) )
          {
            tEdgeRectIndex = getEdgeRectIndex( tFocusedPin.sourcePinEdge ) - 1;
            tEdgeFillColor = color_pinSourceEdgeFill;
            plotEdgeRect( tEdgeRectIndex, tEdgeFillColor, tEdgeStrokeColor );

            if ( tFocusedPin instanceof EditableRectPinRelative )
            {
              tEdgeRectIndex = getEdgeRectIndex( getOppositePinEdge( tFocusedPin.sourcePinEdge ) ) - 1;
              plotEdgeRect( tEdgeRectIndex, tEdgeFillColor, tEdgeStrokeColor );
            }
          }
        }
      }
    }

    if ( showPins )
    {
      PVector tWorldTopLeft = new PVector( left, top );
      PVector tWorldBottomRight = new PVector( right, bottom );
      PVector tWorldMiddle = new PVector( (tWorldTopLeft.x + tWorldBottomRight.x)/2.0, (tWorldTopLeft.y + tWorldBottomRight.y)/2.0 );

      int iIndex = 0;
      for ( EditableRectPin iPin : pinArray )
      {
        PVector tPinPosition = tWorldMiddle.get();

        switch( iPin.targetEdge )
        {
        case PINEDGE_LEFT:
          tPinPosition.x = tWorldTopLeft.x;
          break;
        case PINEDGE_RIGHT:
          tPinPosition.x = tWorldBottomRight.x;
          break;
        case PINEDGE_TOP:
          tPinPosition.y = tWorldTopLeft.y;
          break;
        case PINEDGE_BOTTOM:
          tPinPosition.y = tWorldBottomRight.y;
          break;
        }

        iPin.plot( tPinPosition, tWireframeColor, childEntities.contains( iPin.pinnedSource ) );

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

    if ( aRectIndex == 4 )
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

  //  PinEdge getPinnedTargetEdge()
  //  {
  //    return getPinnableEdgeIndex( edgeBeingEdited );
  //  }
  //
  //  PinEdge getsourcePinEdge()
  //  {
  //    return getPinnableEdgeIndex( getHoveredEdge() );
  //  }
  //
  //  float getPinnedEdgeValue( int aPinnedEdge )
  //  {
  //    if ( aPinnedEdge == PINARRAY_LEFT )
  //    {
  //      return left;
  //    }
  //    if ( aPinnedEdge == PINARRAY_RIGHT )
  //    {
  //      return right;
  //    }
  //    if ( aPinnedEdge == PINARRAY_TOP )
  //    {
  //      return top;
  //    }
  //    if ( aPinnedEdge == PINARRAY_BOTTOM )
  //    {
  //      return bottom;
  //    }
  //    return 0;
  //  }

  float getPinnedEdgeValue( PinEdge aEdge )
  {
    switch( aEdge )
    {
    case PINEDGE_LEFT:
      return left;
    case PINEDGE_RIGHT:
      return right;
    case PINEDGE_TOP:
      return top;
    case PINEDGE_BOTTOM:
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

    if ( this == mouseCursor.focusedEntity )
    {
      // Only allow pinning to opposite edge
      return getHoveredEdge() == getOppositeEdgeIndex( edgeBeingEdited );
    }

    return false;
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
    swapPins( PinEdge.PINEDGE_LEFT, PinEdge.PINEDGE_RIGHT );
    getPin( PinEdge.PINEDGE_LEFT ).mirror();
    getPin( PinEdge.PINEDGE_RIGHT ).mirror();

    float tNewXPos = position.x; 

    if ( getParent() instanceof EditableRect && getParent() == aMirroredEntity )
    {
      EditableRect tParentRect = (EditableRect)getParent();
      float tRelativePos = 1 - ( localToWorld( position ).x - tParentRect.getPinnedEdgeValue( PinEdge.PINEDGE_LEFT ) ) / ( tParentRect.getPinnedEdgeValue( PinEdge.PINEDGE_RIGHT ) - tParentRect.getPinnedEdgeValue( PinEdge.PINEDGE_LEFT ) );
      tNewXPos = worldToLocal( new PVector( tParentRect.getPinnedEdgeValue( PinEdge.PINEDGE_LEFT ) * (1-tRelativePos) + tParentRect.getPinnedEdgeValue( PinEdge.PINEDGE_RIGHT ) * tRelativePos, 0 ) ).x;
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
      pinOnMousePressed();

      uiModeManager.currentMode = UIMODE_PINNABLE;
      mouseCursor.focusLocked = false;
    } 
    else if ( uiModeManager.currentMode == UIMODE_RESIZABLE )
    {
      edgeBeingEdited = getHoveredEdge();
      uiModeManager.currentMode = UIMODE_RESIZING;
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

  void pinOnMousePressed()
  {
    if ( mouseButton == LEFT )
    {
      PinEdge tPinnedTargetEdge = getPinEdge( edgeBeingEdited );

      EditableRectPin tPin = null;

      if ( mouseCursor.hoveredEntity instanceof EditableSlider )
      {
        EditableSlider tHoveredSlider = (EditableSlider)( mouseCursor.hoveredEntity );
        if ( tHoveredSlider.isHoveringOverSlider() && canEditedPinBeGlobal() )
        {
          EditableRectPinOffset tCurrentPin = (EditableRectPinOffset)( getPin( tPinnedTargetEdge ) );
          tPin = new EditableRectPinGlobalOffset( tCurrentPin, tHoveredSlider.linkedGlobalVariable );
        }
      }

      if ( mouseCursor.hoveredEntity instanceof EditableRect && tPin == null )
      {
        EditableRect tSourceRect = (EditableRect)( mouseCursor.hoveredEntity );
        if ( tSourceRect.isValidPinningTarget() )
        {
          PinEdge tSourcePinEdge = getPinEdge( tSourceRect.getHoveredEdge() );

          float tTargetEdgeCurrentValue = getPinnedEdgeValue( tPinnedTargetEdge );
          if ( tSourcePinEdge == tPinnedTargetEdge || tSourcePinEdge == getOppositePinEdge( tPinnedTargetEdge ) )
          {
            tPin = new EditableRectPinOffset( this, tPinnedTargetEdge, tSourceRect, tSourcePinEdge, tTargetEdgeCurrentValue );
          }
          else
          {
            tSourcePinEdge = getDiagonalPinEdge( tSourcePinEdge );

            tPin = new EditableRectPinRelative( this, tPinnedTargetEdge, tSourceRect, tSourcePinEdge, tTargetEdgeCurrentValue );
          }
        }
      }

      if ( tPin == null )
      {
        tPin = new EditableRectPinLocalAbsolute( this, tPinnedTargetEdge );
      }


      pinArray.set( tPinnedTargetEdge.arrayIndex, tPin );
    }
  }

  boolean canEditedPinBeGlobal()
  {
    return getPin( getPinEdge( edgeBeingEdited ) ) instanceof EditableRectPinOffset;
  }

  EditableRectPin getPin( PinEdge aEdge )
  {
    int tIndex = aEdge.arrayIndex;
    if ( tIndex < 0 || tIndex >= pinArray.size() )
      return null;

    return pinArray.get( tIndex );
  }

  EditableRectPin setPin( PinEdge aEdge, EditableRectPin aPin )
  {
    return pinArray.set( aEdge.arrayIndex, aPin );
  }
}

