class World
{
  ArrayList<WorldObject> objects;

  ArrayList<Entity> entities;

  Entity selectedEntity;

  World()
  {
    objects = new ArrayList<WorldObject>();

    entities = new ArrayList<Entity>();
  }

  void addObject( WorldObject aObject )
  {
    objects.add( aObject );
  }

  void addEntity( Entity aEntity )
  {
    entities.add( aEntity );
  }

  void update()
  {
    for ( WorldObject iObject : objects )
    {
      iObject.update();
    }

    for ( Entity iEntity : entities )
    {
      iEntity.update();
    }

    mouseCursor.hoveredEntity = null;
    for ( int i = entities.size() - 1; i >= 0; --i )
    {
      mouseCursor.hoveredEntity = entities.get( i ).getHoveredEntity();
      if ( mouseCursor.hoveredEntity != null )
        break;
    }

    if ( keyBuffer.contains( 'a' ) || keyBuffer.contains( 'A' ) )
    {
      uiModeManager.setModeClean( UIMODE_ADDING );
    }
    else if ( keyBuffer.contains( 'w' ) || keyBuffer.contains( 'W' ) )
    {
      uiModeManager.setModeClean( UIMODE_MOVABLE );
    }
    else if ( keyBuffer.contains( 'r' ) || keyBuffer.contains( 'R' ) )
    {
      uiModeManager.setModeClean( UIMODE_RESIZABLE );
    }
    else if ( keyBuffer.contains( 't' ) || keyBuffer.contains( 'T' ) )
    {
      uiModeManager.setModeClean( UIMODE_PINNABLE );
    }
  }

  void plot()
  {
    for ( Entity iEntity : entities )
    {
      iEntity.plot();
    }
  }

  void plotDebug()
  {
    if ( showDebug )
    {
      if ( debug_world )
      {
        String tDebugText = "World";

        textAlign( LEFT, TOP );
        debugText( tDebugText );

        tDebugText = "selectedEntity = "; 
        if ( selectedEntity == null )
          tDebugText += "null";
        else
        {
          tDebugText += selectedEntity.getClass().getSimpleName();
        }
        debugText( tDebugText );
      }

      for ( Entity iEntity : entities )
      {
        iEntity.plotDebug();
      }
    }
  }
}

class WorldObject
{
  WorldObject()
  {
  }

  void update()
  {
  }
}

class Entity
{
  PVector position;

  ArrayList<Entity> childEntities;
  private Entity parent;

  ArrayList<Entity> childrenToRemove;

  boolean selectable;

  PVector mouseCursorDragOffset;

  Entity()
  {
    super();

    position = new PVector();

    childEntities = new ArrayList<Entity>();
    childrenToRemove = new ArrayList<Entity>();

    selectable = false;
  }

  void update()
  {
    if ( uiModeManager.currentMode == UIMODE_MOVING )
    {    
      if ( mouseCursorDragOffset != null )
      {
        position.set( mouseCursor.position );
        position.sub( mouseCursorDragOffset );
      }
    }
    else
    {
      mouseCursorDragOffset = null;
    }

    for ( Entity iChild : childEntities )
    {
      iChild.update();
    }

    processKeyBuffer( keyBuffer );

    for ( Entity iEntity : childrenToRemove )
    {
      childEntities.remove( iEntity );
    }
    childrenToRemove.clear();
  }

  void plot()
  {
    for ( Entity iChild : childEntities )
    {
      iChild.plot();
    }
  }

  void plotDebug()
  {
    if ( debug_entity )
    {
      PVector tScreenPos = camera.worldToScreen( localToWorld( position ) );

      stroke( color_debug );
      cross( tScreenPos.x, tScreenPos.y, 5 );

      String tDebugDisplayString = this.getClass().getSimpleName();

      fill( color_debug );
      textAlign( LEFT, BOTTOM );
      textFont( font_debug );
      text( tDebugDisplayString, tScreenPos.x + 2, tScreenPos.y );
    }

    for ( Entity iChild : childEntities )
    {
      iChild.plotDebug();
    }
  }

  boolean isMouseInside()
  {
    return false;
  }

  Entity getHoveredEntity()
  {
    Entity tHoveredEntity = null;
    for ( int i = childEntities.size() - 1; i >= 0; --i )
    {
      tHoveredEntity = childEntities.get( i ).getHoveredEntity();
      if ( tHoveredEntity != null )
        break;
    }

    if ( tHoveredEntity == null && isMouseInside() )
    {
      tHoveredEntity = this;
    }

    return tHoveredEntity;
  }

  void addChildEntity( Entity aEntity )
  {
    childEntities.add( aEntity );
    aEntity.setParent( this );
  }

  void onSetParent( Entity aPreviousParent )
  {
    // New parent is just getParent()
  }

  Entity getParent()
  {
    return parent;
  }

  void setParent( Entity aParent )
  {
    PVector tWorldPosition = localToWorld( position ); 
    Entity tPreviousParent = parent; 
    if ( parent != null )
    {
      parent.childEntities.remove( this );
    }

    parent = aParent;
    position.set( worldToLocal( tWorldPosition ) );

    onSetParent( tPreviousParent );
  }

  void processKeyBuffer( KeyBuffer aKeyBuffer )
  {

    for ( KeyBufferCommand iCommand : aKeyBuffer.previousFrameCommandStack )
    {
      if ( iCommand.key == CODED )
      {
        switch( iCommand.keyCode )
        {
        }
      } 
      else
      {
        switch( iCommand.key )
        {
        case KeyEvent.VK_DELETE:
          {
            if (world.selectedEntity == this )
            {
              removeSelf();
            }
          }
          break;
        default:
        }
      }
    }
  }

  void removeSelf()
  {
    world.selectedEntity = null;
    parent.childrenToRemove.add( this );
    if ( mouseCursor.focusedEntity == this )
    {
      mouseCursor.focusLocked = false;
      mouseCursor.focusedEntity = null;
    }
  }

  void processMousePressed()
  {
    if ( uiModeManager.currentMode == UIMODE_MOVABLE )
    {
      mouseCursorDragOffset = mouseCursor.position.get();
      mouseCursorDragOffset.sub( position ); 

      uiModeManager.currentMode = UIMODE_MOVING;
    }
  }

  void processMouseReleased()
  {
    if ( uiModeManager.currentMode == UIMODE_MOVING )
    {
      mouseCursorDragOffset = null;

      uiModeManager.currentMode = UIMODE_MOVABLE;
    }
  }
  
  PVector calcWorldPosition()
  {
    PVector tWorldPosition = position.get();
    if( parent != null )
      tWorldPosition.add( parent.calcWorldPosition() );
      
    return tWorldPosition;
  }
  
  PVector getWorldPosition()
  {
    return calcWorldPosition();
  }
  
  PVector localToWorld( PVector aLocalPosition )
  {
    PVector tWorldPosition = aLocalPosition.get();
    if( parent != null )
      tWorldPosition.add( parent.calcWorldPosition() );
    
    return tWorldPosition;
  }
  
  PVector worldToLocal( PVector aWorldPosition )
  {
    PVector tLocalPosition = aWorldPosition.get();
    if( parent != null )
      tLocalPosition.sub( parent.calcWorldPosition() );
      
    return tLocalPosition;
  }
}

