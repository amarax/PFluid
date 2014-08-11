PVector mouseDownPos;

class MouseCursor
{
  PVector position;
  float scrollBufferPreviousFrame;
  float scrollBufferCurrentFrame;

  Entity hoveredEntity;
  Entity focusedEntity;

  MouseCursor()
  {
    position = new PVector( mouseX, mouseY );
    scrollBufferPreviousFrame = 0;
    scrollBufferCurrentFrame = 0;
  }

  void update()
  {
    position = camera.screenToWorld( new PVector( mouseX, mouseY ) );

    if ( keyBuffer.contains( 'r' ) )
    {
      uiModeManager.currentMode = UIMODE_RESIZING;
      EditableRect tNewRect = new EditableRect( new PVector( position.x, position.y ) ); 

      focusedEntity = tNewRect;

      EditableElement tEditableParent = editableElement;
      if ( world.selectedEntity != null )
      {
        if ( world.selectedEntity instanceof EditableElement )
        {
          tEditableParent = (EditableElement)( world.selectedEntity );
        }
      }
      tEditableParent.addEditableChild( (EditableElement)focusedEntity );

      world.selectedEntity = focusedEntity;
      tNewRect.edgeBeingEdited = 3;


      //        GridCell tCell = styleGrid.addCell( 0, styleGrid.getRowCount() );
    }
  }

  void swapBuffers()
  {
    scrollBufferPreviousFrame = scrollBufferCurrentFrame;
    scrollBufferCurrentFrame = 0;
  }

  void plotDebug()
  {
    if ( showDebug && debug_mouseCursor )
    {
      PVector tScreenPos = new PVector( 1, 0 ); 
      float tLineSpacingFactor = 1.1;
      String tDebugText = "MouseCursor";

      fill( color_debug );
      textAlign( LEFT, TOP );
      textFont( font_debug );
      text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

      tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );

      tDebugText = "hoveredEntity = "; 
      if ( hoveredEntity == null )
        tDebugText += "null";
      else
      {
        String[] tClassStrings = split( hoveredEntity.getClass().getCanonicalName(), "." );

        tDebugText += tClassStrings[tClassStrings.length - 1];
      }
      text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

      tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );

      tDebugText = "focusedEntity = "; 
      if ( focusedEntity == null )
        tDebugText += "null";
      else
      {
        String[] tClassStrings = split( focusedEntity.getClass().getCanonicalName(), "." );

        tDebugText += tClassStrings[tClassStrings.length - 1];
      }
      text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );
    }
  }
}


void mousePressed()
{
  mouseDownPos = new PVector( mouseX, mouseY );

  if( mouseCursor.hoveredEntity != null )
  {
    if( mouseCursor.hoveredEntity.selectable )
    {
      world.selectedEntity = mouseCursor.hoveredEntity;
    }
  }
  else
  {
    world.selectedEntity = null;
  }

  if ( !(mouseCursor.hoveredEntity instanceof EditableRect ) && ( uiModeManager.currentMode != UIMODE_PINNING ) )
  {
    mouseCursor.focusedEntity = mouseCursor.hoveredEntity;
    if( mouseCursor.focusedEntity != null )
      mouseCursor.focusedEntity.processMousePressed();
  }
  else
  {
    if ( uiModeManager.currentMode == UIMODE_RESIZING )
    {
      if ( mouseCursor.focusedEntity != null )
      {
        if( mouseCursor.focusedEntity.parent instanceof EditableRect )
        {
          world.selectedEntity = mouseCursor.focusedEntity.parent;
        } 

        mouseCursor.focusedEntity = null;
        uiModeManager.currentMode = UIMODE_RESIZABLE;
        
      }
    } else if ( uiModeManager.currentMode == UIMODE_RESIZABLE )
    {
      mouseCursor.focusedEntity = mouseCursor.hoveredEntity;
      if ( mouseCursor.focusedEntity != null )
      {

          EditableRect tEditableRect = (EditableRect)( mouseCursor.focusedEntity );
          tEditableRect.edgeBeingEdited = tEditableRect.getHoveredEdge();
          uiModeManager.currentMode = UIMODE_RESIZING;
      }
    } else if ( uiModeManager.currentMode == UIMODE_PINNING )
    {
      world.selectedEntity = mouseCursor.focusedEntity;
      if ( mouseCursor.hoveredEntity != null && mouseCursor.hoveredEntity instanceof EditableRect)
      {
        EditableRect tSourceRect = (EditableRect)( mouseCursor.hoveredEntity );
        EditableRect tTargetRect = (EditableRect)( mouseCursor.focusedEntity );
        if ( tSourceRect.isValidPinningTarget() )
        {
          int tPinnedSourceEdge = tSourceRect.getPinnedSourceEdge();
          int tPinnedTargetEdge = tTargetRect.getPinnedTargetEdge();
          
          float tTargetEdgeCurrentValue = tTargetRect.getPinnedEdgeValue( tPinnedTargetEdge );
          EditableRectPin tPin = null;
          if( tPinnedSourceEdge == tPinnedTargetEdge || tPinnedSourceEdge == getOppositePinnedEdgeIndex( tPinnedTargetEdge ) )
          {
            tPin = new EditableRectPinOffset( tSourceRect, tPinnedSourceEdge, tTargetEdgeCurrentValue );
          }
          else
          {
            tPinnedSourceEdge += 2;
            tPinnedSourceEdge = tPinnedSourceEdge % 4;
            tPin = new EditableRectPinRelative( tSourceRect, tPinnedSourceEdge, tTargetEdgeCurrentValue );
          }
          
          tTargetRect.pinArray.set( tPinnedTargetEdge, tPin );
        }
      }
      mouseCursor.focusedEntity = null;
      uiModeManager.currentMode = UIMODE_PINNABLE;
    } else if ( uiModeManager.currentMode == UIMODE_PINNABLE )
    {
      if ( mouseCursor.focusedEntity == null )
      {
        mouseCursor.focusedEntity = mouseCursor.hoveredEntity;

        if ( mouseCursor.focusedEntity != null )
        {
          EditableRect tEditableRect = (EditableRect)( mouseCursor.focusedEntity );
          tEditableRect.edgeBeingEdited = tEditableRect.getHoveredEdge();
          uiModeManager.currentMode = UIMODE_PINNING;
        }
      }
    }
  }
}

void mouseReleased()
{
  mouseDownPos = null;

  if ( !(mouseCursor.focusedEntity instanceof EditableRect) )
  {
    if( mouseCursor.focusedEntity != null )
    {
      mouseCursor.focusedEntity.processMouseReleased();
      mouseCursor.focusedEntity = null;
    }
  }

  if ( uiModeManager.currentMode == UIMODE_RESIZING )
  {
    if ( mouseCursor.focusedEntity != null )
    {
      mouseCursor.focusedEntity = null;
    }

    uiModeManager.currentMode = UIMODE_RESIZABLE;
  }
}

void mouseWheel( MouseEvent event )
{
  mouseCursor.scrollBufferCurrentFrame += event.getAmount();
}

