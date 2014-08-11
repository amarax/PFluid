PVector mouseDownPos;

class MouseCursor
{
  PVector position;
  float scrollBufferPreviousFrame;
  float scrollBufferCurrentFrame;

  Entity hoveredEntity;
  Entity focusedEntity;

  boolean focusLocked;
  boolean selectionLocked;

  MouseCursor()
  {
    position = new PVector( mouseX, mouseY );
    scrollBufferPreviousFrame = 0;
    scrollBufferCurrentFrame = 0;

    focusLocked = false;
    selectionLocked = false;
  }

  void update()
  {
    position = camera.screenToWorld( new PVector( mouseX, mouseY ) );
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
      String tDebugText = "MouseCursor";

      textAlign( LEFT, TOP );
      debugText( tDebugText );

      tDebugText = "hoveredEntity = "; 
      if ( hoveredEntity == null )
        tDebugText += "null";
      else
      {
        tDebugText += hoveredEntity.getClass().getSimpleName();
      }
      debugText( tDebugText );

      tDebugText = "focusedEntity = "; 
      if ( focusedEntity == null )
        tDebugText += "null";
      else
      {
        tDebugText += focusedEntity.getClass().getSimpleName();
      }
      if ( focusLocked ) { 
        tDebugText += " [Locked]";
      }
      debugText( tDebugText );
    }
  }
}


void mousePressed()
{
  mouseDownPos = new PVector( mouseX, mouseY );

  if( uiModeManager.currentMode == UIMODE_ADDING )
  {
    ( new Action_AddEditableRect() ).execute();
    return;
  }

  if( !mouseCursor.selectionLocked )
  {
    if ( mouseCursor.hoveredEntity != null )
    {
      if ( mouseCursor.hoveredEntity.selectable )
      {
        world.selectedEntity = mouseCursor.hoveredEntity;
      }
    }
    else
    {
      world.selectedEntity = null;
    }
  }

  if ( !mouseCursor.focusLocked )
  {
    mouseCursor.focusedEntity = mouseCursor.hoveredEntity;
  }

  if ( mouseCursor.focusedEntity != null ) 
    mouseCursor.focusedEntity.processMousePressed();
}

void mouseReleased()
{
  mouseDownPos = null;

  if ( mouseCursor.focusedEntity != null )
  {
    mouseCursor.focusedEntity.processMouseReleased();
    
  }

  if( !mouseCursor.focusLocked )
    mouseCursor.focusedEntity = null;
}

void mouseWheel( MouseEvent event )
{
  mouseCursor.scrollBufferCurrentFrame += event.getAmount();
}

