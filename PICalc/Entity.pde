class Entity implements Serializable, XMLizable
{
  String name;
  WorldPosition position;

  Entity( String aName )
  {
    name = aName;
  }

  Entity( Entity aExistingEntity )
  {
    name = aExistingEntity.name;
    position = new WorldPosition( aExistingEntity.position );
  }

  void update()
  {
  }

  void plot()
  {
  }
  
  void processKey()
  {
  }

  void processMousePressed()
  {
  }

  void processMouseReleased()
  {
  }
  
  void processMouseDragStarted()
  {
  }
  
  void processMouseDragStopped()
  {
  }

  void moveTo( WorldPosition aTargetPosition )
  {
    position = aTargetPosition;
  }

  void drawDebug()
  {
    if ( position != null )
    {
      PVector tScreenPos = position.toScreen();
      stroke ( 0, 0, 1 );
      strokeWeight( 1 );
      noFill();

      float tCrossSize = 2;
      line ( tScreenPos.x - tCrossSize, tScreenPos.y, tScreenPos.x + tCrossSize, tScreenPos.y );
      line ( tScreenPos.x, tScreenPos.y - tCrossSize, tScreenPos.x, tScreenPos.y + tCrossSize );

      int tTextLine = 0;

      fill ( 0, 0, 1 );
      textAlign( LEFT, TOP );
      textFont( fontDebugLabel );
      text( name, tScreenPos.x +3, tScreenPos.y +1 + tTextLine * 10 );

      textFont( fontDebugValue );

      tTextLine++;
      text( "Posiiton " + str( round( position.x * 10 ) / 10.0 ) + ", " + str( round( position.y * 10 ) / 10.0 ), tScreenPos.x +3, tScreenPos.y +1 + tTextLine * 10 );
    }
    else
    {
      fill ( 0, 0, 1 );
      textAlign( RIGHT, TOP );
      textFont( fontDebugLabel );
      text( name, width - 20, 10 + 10 * positionlessEntityCount );

      positionlessEntityCount++;
    }
  }

  boolean contains( PVector aScreenPos )
  {
    return false;
  }
  
  void removeFromWorld()
  {
    if( isSelected( this ) )
    {
      selectedEntities.remove( this );
    }
    
    world.entities.remove( this );
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    return false;
  }
  
  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "Entity" );

    XMLElement tChild;

    tChild = new XMLElement();
    tChild.setName( "Name" );
    tChild.setContent( name );
    tElement.addChild( tChild );

    tElement.addChild( position.toXML() );

    return tElement;
  }
}

