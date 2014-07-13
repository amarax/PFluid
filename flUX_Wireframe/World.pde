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
        PVector tScreenPos = new PVector( 1, 0 ); 
        float tLineSpacingFactor = 1.1;
        String tDebugText = "World";

        fill( color_debug );
        textAlign( LEFT, TOP );
        textFont( font_debug );
        text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

        tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );

        tDebugText = "selectedEntity = "; 
        if ( selectedEntity == null )
          tDebugText += "null";
        else
        {
          String[] tClassStrings = split( selectedEntity.getClass().getCanonicalName(), "." );

          tDebugText += tClassStrings[tClassStrings.length - 1];
        }
        text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );
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
  Entity parent;

  ArrayList<Entity> childrenToRemove;

  Entity()
  {
    super();

    position = new PVector();

    childEntities = new ArrayList<Entity>();
    childrenToRemove = new ArrayList<Entity>();
  }

  void update()
  {
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
      PVector tScreenPos = camera.worldToScreen( position );

      stroke( color_debug );
      cross( tScreenPos.x, tScreenPos.y, 5 );

      String[] tClassStrings = split( this.getClass().getCanonicalName(), "." );
      String tDebugDisplayString = tClassStrings[tClassStrings.length - 1];

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
    aEntity.parent = this;
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
      } else
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
      mouseCursor.focusedEntity = null;
    }
  }
  
  void processMousePressed()
  {
  }
  
  void processMouseReleased()
  {
  }
}

