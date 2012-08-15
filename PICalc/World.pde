import java.io.*;

class World implements XMLizable
{
  ArrayList<Entity> entities;
  FlowManagerPI flowManager;

  World()
  {
    entities = new ArrayList<Entity>();
    flowManager = new FlowManagerPI();
  }

  void update()
  {
    Iterator<Entity> iEntity = entities.iterator();
    while ( iEntity.hasNext () )
    {
      iEntity.next().update();
    }
    
    flowManager.update();
  }

  void plot()
  {
    flowManager.plot();

    Iterator<Entity> iWorldEntity = entities.iterator();
    while ( iWorldEntity.hasNext () )
    {
      iWorldEntity.next().plot();
    }
  }

  void drawDebug()
  {
    stroke ( 0, 0, 1 );
    strokeWeight( 1 );
    noFill();

    float tWorldCrossSize = uiCam.getScale() * 10;
    line ( uiCam.getOffset().x - tWorldCrossSize, uiCam.getOffset().y, uiCam.getOffset().x + tWorldCrossSize, uiCam.getOffset().y );
    line ( uiCam.getOffset().x, uiCam.getOffset().y - tWorldCrossSize, uiCam.getOffset().x, uiCam.getOffset().y + tWorldCrossSize );    

    int tTextLine = 0;

    fill ( 0, 0, 1 );
    textAlign( LEFT, TOP );
    textFont( fontDebugLabel );
    text( "WORLD", uiCam.getOffset().x +3, uiCam.getOffset().y +1 + tTextLine * 10 );

    textFont( fontDebugValue );

    tTextLine++;
    text( "Offset " + str( round( uiCam.getOffset().x * 10 ) / 10.0 ) + ", " + str( round( uiCam.getOffset().y * 10 ) / 10.0 ), uiCam.getOffset().x +3, uiCam.getOffset().y +1 + tTextLine * 10 );
    tTextLine++;
    text( "Scale " + str( round( uiCam.getScale() * 1000 ) / 1000.0 ), uiCam.getOffset().x +3, uiCam.getOffset().y +1 + tTextLine * 10 );
  }

  void addEntity( Entity aEntity )
  {
    entities.add( aEntity );
  }
  
  void removeEntity( Entity aEntity )
  {
    int tIndex = entities.indexOf( aEntity );
    if( tIndex != -1 )
    {
      entities.remove( tIndex );
    }
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    return false;
  }
  
  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "World" );

    for ( int i = 0; i < entities.size(); i++ )
    {
      tElement.addChild( entities.get( i ).toXML() );
    }

    return tElement;
  }
}

class WorldPosition extends PVector implements XMLizable
{
  WorldPosition( float aX, float aY )
  {
    super( aX, aY );
  }

  WorldPosition( PVector aPosition )
  {
    super( aPosition.x, aPosition.y );
  }

  PVector toScreen()
  {
    PVector tPosition = new PVector( x, y );
    tPosition.mult( uiCam.getScale() );
    tPosition.add( uiCam.getOffset() );
    return tPosition;
  }
  
  boolean fromXML( XMLElement aXMLElement )
  {
    return false;
  }
  
  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "WorldPosition" );

    XMLElement tChild;

    tChild = new XMLElement();
    tChild.setName( "x" );
    tChild.setContent( str( x ) );
    tElement.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "y" );
    tChild.setContent( str( y ) );
    tElement.addChild( tChild );

    return tElement;
  }
}

WorldPosition worldPosFromScreen( PVector aScreenPos )
{
  WorldPosition tWorldPosition = new WorldPosition( aScreenPos.x, aScreenPos.y );
  tWorldPosition.sub( uiCam.getOffset() );
  tWorldPosition.div( uiCam.getScale() );
  return tWorldPosition;
}


