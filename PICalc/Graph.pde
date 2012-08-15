
class Graph extends Entity
{
  WorldPosition extentsPosition;

  Graph( String aName, WorldPosition aPosition )
  { 
    super( aName );
    position = aPosition;
    extentsPosition = aPosition;
  }

  void init()
  {
  }

  void moveTo( WorldPosition aTargetPosition )
  {
    extentsPosition.sub( position );
    extentsPosition.add( aTargetPosition );

    super.moveTo( aTargetPosition );
  }

  void drawDebug()
  {
    Rectangle tRect = calcScreenRect();

    noFill();
    stroke( 0, 0, 1, 0.2 );
    strokeWeight( 1 );
    rect( tRect.x, tRect.y, tRect.width, tRect.height );
  }

  Rectangle calcScreenRect()
  {
    PVector tScreenPos = this.position.toScreen();
    PVector tScreenExtentsPos = extentsPosition.toScreen();
    Rectangle tRect = new Rectangle( floor( min( tScreenPos.x, tScreenExtentsPos.x ) ), floor( min( tScreenPos.y, tScreenExtentsPos.y ) ), ceil( abs( tScreenExtentsPos.x - tScreenPos.x ) ), ceil( abs( tScreenExtentsPos.y - tScreenPos.y ) ) );
    return tRect;
  }

  boolean contains( PVector aScreenPos )
  {
    return calcScreenRect().contains( aScreenPos.x, aScreenPos.y );
  }
}


class Graph2D extends Graph
{
  GraphAxis hAxis;
  GraphAxis vAxis;

  PVector mousePressedValues;  // Should be handled by the axes themselve

  Graph2D( String aName, WorldPosition aPosition )
  { 
    super( aName, aPosition );

    hAxis = new GraphAxis( this );
    vAxis = new GraphAxis( this );
  }

  void init()
  {
    super.init();

    hAxis.startPos = new PVector( 0.0, 0.0 );
    hAxis.endPos = new PVector( 1, 0.0 );

    vAxis.startPos = new PVector( 0.0, 0.0 );
    vAxis.endPos = new PVector( 0.0, 1 );
  }

  void update()
  {
    super.update();

    if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DRAGGINGENTITY && isSelected( this ) )
    {
      Rectangle tGraphScreenHitArea = calcGraphScreenHitArea();
      WorldPosition tMousePos = worldPosFromScreen( new PVector( mouseX, mouseY ) );

      if ( shiftPressed )
      {
        // Not accurate enough, should use value at dragging start
        if ( mousePressedPos.x >= tGraphScreenHitArea.x && mousePressedPos.x <= tGraphScreenHitArea.x + tGraphScreenHitArea.width )
        {
          hAxis.endValue = ( extentsPosition.x - position.x ) * ( mousePressedValues.x - hAxis.startValue ) / ( tMousePos.x - position.x ) + hAxis.startValue;
        }
        if ( mousePressedPos.y >= tGraphScreenHitArea.y && mousePressedPos.y <= tGraphScreenHitArea.y + tGraphScreenHitArea.height )
        {
          vAxis.endValue = ( extentsPosition.y - position.y ) * ( mousePressedValues.y - vAxis.startValue ) / ( tMousePos.y - position.y ) + vAxis.startValue;
        }
      }
      else
      {
        if ( mousePressedPos.x >= tGraphScreenHitArea.x && mousePressedPos.x <= tGraphScreenHitArea.x + tGraphScreenHitArea.width )
        {
          float tScale = ( hAxis.endValue - hAxis.startValue ) / ( extentsPosition.x - position.x );

          hAxis.startValue = mousePressedValues.x + ( position.x - tMousePos.x ) * tScale;
          hAxis.endValue = mousePressedValues.x + ( extentsPosition.x - tMousePos.x ) * tScale;
        }
        if ( mousePressedPos.y >= tGraphScreenHitArea.y && mousePressedPos.y <= tGraphScreenHitArea.y + tGraphScreenHitArea.height )
        {
          float tScale = ( vAxis.endValue - vAxis.startValue ) / ( extentsPosition.y - position.y );

          vAxis.startValue = mousePressedValues.y + ( position.y - tMousePos.y ) * tScale;
          vAxis.endValue = mousePressedValues.y + ( extentsPosition.y - tMousePos.y ) * tScale;
        }
      }
    }
  }

  void plot()
  {
    hAxis.plot();
    vAxis.plot();
  }

  void drawDebug()
  {
    super.drawDebug();

    if ( hoveredEntity == this )
    {
      fill( 0, 0, 1, 0.7 );
      noStroke();
      PVector tValues = calcValuesAtScreenPosition( new PVector( mouseX, mouseY ) );
      textFont( fontDebugValue );
      textAlign( LEFT, BOTTOM );
      text( str( round( tValues.x * 100 ) / 100.0 ) + ", " + str( round( tValues.y * 100 ) / 100.0 ), mouseX, mouseY );
    }
  }

  WorldPosition calcDataPointPosition( float aHValue, float aVValue )
  {
    WorldPosition tGraphStartPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.startPos.x + position.x, ( extentsPosition.y - position.y ) * vAxis.startPos.y + position.y );
    WorldPosition tGraphExtentsPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.endPos.x + position.x, ( extentsPosition.y - position.y ) * vAxis.endPos.y + position.y );

    WorldPosition tDataPointPos = new WorldPosition( tGraphExtentsPosition );
    tDataPointPos.sub( tGraphStartPosition );
    tDataPointPos.x *= hAxis.calcValueRelativePosition( aHValue );
    tDataPointPos.y *= vAxis.calcValueRelativePosition( aVValue );
    tDataPointPos.add( tGraphStartPosition );

    return tDataPointPos;
  }

  PVector calcValuesAtScreenPosition( PVector aScreenPos )
  {
    Rectangle tGraphScreenArea = calcGraphScreenHitArea();

    PVector tValues = new PVector( aScreenPos.x, aScreenPos.y );
    tValues.x = ( tValues.x - tGraphScreenArea.x ) / tGraphScreenArea.width;
    tValues.y = ( tValues.y - tGraphScreenArea.y ) / tGraphScreenArea.height;

    tValues.x = hAxis.calcValueAtRatio( tValues.x );
    tValues.y = vAxis.calcValueAtRatio( tValues.y );
    
    return tValues;
  }

  Rectangle calcGraphScreenHitArea()
  {
    WorldPosition tGraphStartPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.startPos.x + position.x, ( extentsPosition.y - position.y ) * vAxis.startPos.y + position.y );
    WorldPosition tGraphExtentsPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.endPos.x + position.x, ( extentsPosition.y - position.y ) * vAxis.endPos.y + position.y );
    PVector tScreenPos = tGraphStartPosition.toScreen();
    PVector tScreenExtentsPos = tGraphExtentsPosition.toScreen();
    Rectangle tRect = new Rectangle( floor( min( tScreenPos.x, tScreenExtentsPos.x ) ), floor( min( tScreenPos.y, tScreenExtentsPos.y ) ), ceil( abs( tScreenExtentsPos.x - tScreenPos.x ) ), ceil( abs( tScreenExtentsPos.y - tScreenPos.y ) ) );
    return tRect;
  }

  //  void processMouseWheel( int aDelta )
  //  {
  //    Rectangle tGraphScreenArea = calcGraphScreenArea();
  //    float tScaleDifference = - aDelta * 0.05;
  //    if ( mouseX >= tGraphScreenArea.x && mouseX <= tGraphScreenArea.x + tGraphScreenArea.width )
  //    {
  //      float tRange = abs( hAxis.endValue - hAxis.startValue );
  //      float tMouseValue = hAxis.startValue + ( mouseX - tGraphScreenArea.x ) * tRange / tGraphScreenArea.width;
  //      println( tMouseValue );
  //
  //      hAxis.startValue += tScaleDifference * ( tMouseValue - hAxis.startValue );
  //      hAxis.endValue += tScaleDifference * ( tMouseValue - hAxis.endValue );
  //    }
  //    if ( mouseY >= tGraphScreenArea.y && mouseY <= tGraphScreenArea.y + tGraphScreenArea.height )
  //    {
  //      float tRange = abs( vAxis.endValue - vAxis.startValue );
  //      float tMouseValue = vAxis.startValue + ( mouseY - tGraphScreenArea.y ) * tRange / tGraphScreenArea.height;
  //      println( tMouseValue );
  //
  //      vAxis.startValue += tScaleDifference * ( tMouseValue - vAxis.startValue );
  //      vAxis.endValue += tScaleDifference * ( tMouseValue - vAxis.endValue );
  //    }
  //  }

  void processMouseDragStarted()
  {
    mousePressedValues = calcValuesAtScreenPosition( new PVector( mouseX, mouseY ) );
  }

  void processMouseDragStopped()
  {
    mousePressedValues = null;
  }
}

class GraphAxis
{
  Graph parentGraph;

  // Positions are proportions to parent graph extents
  PVector startPos;
  PVector endPos;

  float startValue;
  float endValue;

  float valueStep; // 0 means continuous

  float logScale = 1; // 1 means linear, >1 means a log scale with that as the base

  GraphAxis( Graph aGraph )
  {
    parentGraph = aGraph;

    startPos = new PVector( 0, 0 );
    endPos = new PVector( 0, 0 );

    startValue = 0;
    endValue = 0;

    valueStep = 0;
  }

  void plot()
  {
    stroke( 0, 0, 1, 0.8 );
    strokeWeight( 1 );
    noFill();

    WorldPosition tWorldStartPos = new WorldPosition( parentGraph.extentsPosition );
    tWorldStartPos.sub( parentGraph.position );
    tWorldStartPos.x *= startPos.x;
    tWorldStartPos.y *= startPos.y;
    tWorldStartPos.add( parentGraph.position );
    PVector tScreenStartPos = tWorldStartPos.toScreen();

    WorldPosition tWorldEndPos = new WorldPosition( parentGraph.extentsPosition );
    tWorldEndPos.sub( parentGraph.position );
    tWorldEndPos.x *= endPos.x;
    tWorldEndPos.y *= endPos.y;
    tWorldEndPos.add( parentGraph.position );
    PVector tScreenEndPos = tWorldEndPos.toScreen();

    line( tScreenStartPos.x, tScreenStartPos.y, tScreenEndPos.x, tScreenEndPos.y );
  }

  float calcValueRelativePosition( float aValue )
  {
    float tValue = aValue;
    float tStartValue = startValue;
    float tEndValue = endValue;
    if( logScale > 1 )
    {
      tValue = max( tValue, 1 );
      tStartValue = max( tStartValue, 1 );
      tEndValue = max( tEndValue, 1 );
      
      tValue = log( tValue ) / log( logScale );
      tStartValue = log( tStartValue ) / log( logScale );
      tEndValue = log( tEndValue ) / log( logScale );
    }
    float tRatio = ( tValue - tStartValue ) / ( tEndValue - tStartValue );

    return tRatio;
  }

  float calcValueAtRatio( float aRatio )
  {
    float tStartValue = startValue;
    float tEndValue = endValue;
    if( logScale > 1 )
    {
      tStartValue = max( tStartValue, 1 );
      tEndValue = max( tEndValue, 1 );
      
      tStartValue = log( tStartValue ) / log( logScale );
      tEndValue = log( tEndValue ) / log( logScale );
    }

    float tValue = aRatio * ( tEndValue - tStartValue ) + tStartValue;
    if( logScale > 1 )
    {
      tValue = pow( logScale, tValue );
    }

    if ( valueStep > 0 )
    {
      if ( tValue % valueStep < valueStep / 2 )
      {
        tValue -= tValue % valueStep;
      }
      else
      {
        tValue += valueStep - tValue % valueStep;
      }
    }
    return tValue;
  }
}

