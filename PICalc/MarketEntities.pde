

class MarketUI
{
  float iskMagnitudeScale;
  
  MarketUI( float aISKMagnitudeScale )
  {
    iskMagnitudeScale = aISKMagnitudeScale;
  }
}

class MarketNode extends Graph implements FlowNodePI
{
  float currentBalance;
  float largestNegativeBalance;
  
  GraphAxis hAxis;
  
  DampingHelper_Float currentBalanceDamper;
  DampingHelper_Float largestNegativeBalanceDamper;
  
  MarketNode( String aName, WorldPosition aPosition )
  {
    super( aName, aPosition );
    
    currentBalance = 0;
    largestNegativeBalance = 0;
    
    hAxis = new GraphAxis( this );
    
    currentBalanceDamper = new DampingHelper_Float( 0.1, currentBalance );
    largestNegativeBalanceDamper = new DampingHelper_Float( 0.1, largestNegativeBalance );
  }
  
  void init()
  {
    super.init();

    hAxis.startPos = new PVector( 0.0, 0.0 );
    hAxis.endPos = new PVector( 1, 0.0 );

    hAxis.startValue = -1;
    hAxis.endValue = 2;
  }
  
  PIMaterial getMaterialProduced( FlowPI aFlow )
  {
    return null;
  }

  int getUnitsProduced()
  {
    return -1;
  }

  int getUnitsRequired( PIMaterial aMaterial )
  {
    return -1;
  }

  float getInputWorldOffset( PIMaterial aMaterial )
  {
    return 0;
  }
  
  PIProcess getProcess()
  {
    return null;
  }
  
  WorldPosition getWorldPosition()
  {
    return position;
  }
  
  FlowPoint getOutputPoint()
  {
    float tFlowOrientation = HALF_PI * ( position.y < extentsPosition.y ? 1 : -1 );
    float tMagnitudeOrientationOffset = HALF_PI * ( position.y < extentsPosition.y ? -1 : 1 );
    return new FlowPoint( calcDataPointPosition( 0 ), tFlowOrientation, tMagnitudeOrientationOffset );
  }
  
  FlowPoint getInputPoint( PIMaterial aMaterial )
  {
    float tFlowOrientation = HALF_PI * ( position.y < extentsPosition.y ? -1 : 1 );
    float tMagnitudeOrientationOffset = HALF_PI * ( position.y < extentsPosition.y ? 1 : -1 );
    return new FlowPoint( calcDataPointPosition( 0 ), tFlowOrientation, tMagnitudeOrientationOffset );
  }
  
  void plot()
  {
    super.plot();
    
    hAxis.plot();

    currentBalanceDamper.update( currentBalance );
    largestNegativeBalanceDamper.update( largestNegativeBalance );

    plotMark( 0, 5, color( 0, 0, 0.8, 0.5 ), color( 0, 0, 1, 0.5 ) );
    plotMark( pow( 10, 6 ), 5, color( 0, 0, 0.8, 0.5 ), color( 0, 0, 1, 0.5 ) );
    plotMark( currentBalanceDamper.getValue(), 15, color( 0, 0, 0.8 ), color( 0, 0, 1 ) );
    if( largestNegativeBalanceDamper.getValue() < -EPSILON )
    {
      plotMark( largestNegativeBalanceDamper.getValue(), 5, color( 0, 0, 0.8 ), color( 0, 0, 1 ) );
    }
  }
  
  void plotMark( float aValue, float aMarkLength, color aMarkColor, color aTextColor )
  {
    Rectangle tGraphScreenArea = calcGraphScreenArea();

    // Expand area by one pixel to catch rounding errors
    tGraphScreenArea.x -= 1;
    tGraphScreenArea.y -= 1;
    tGraphScreenArea.width += 2;
    tGraphScreenArea.height += 2;

    float tMarkLength = aMarkLength * uiCam.getScale();
    PVector tMarkPosition = calcDataPointPosition( aValue ).toScreen();
    
    if ( tGraphScreenArea.contains( tMarkPosition.x, tMarkPosition.y  ) )
    {
      stroke( aMarkColor );
      strokeWeight( 1 );
      noFill();
      line( tMarkPosition.x, tMarkPosition.y, tMarkPosition.x, tMarkPosition.y + tMarkLength * ( this.position.y > this.extentsPosition.y ? 1 : -1 ) );

      fill( aTextColor );
      noStroke();
      textFont( fontValue );
      float tTextSize = 8 * uiCam.getScale();
      textSize( tTextSize );
      textAlign( RIGHT, this.position.y > this.extentsPosition.y ? TOP : BOTTOM );
      text( nfc( aValue, 2 ), tMarkPosition.x, tMarkPosition.y + ( tMarkLength ) * ( this.position.y > this.extentsPosition.y ? 1.4 : -1 ) );
    }
  }

  float calcMagnitude( float aValue )
  {
    float tMagnitude = aValue * ( ( extentsPosition.x - position.x ) * ( hAxis.endPos.x - hAxis.startPos.x ) ) / ( hAxis.endValue - hAxis.startValue );
    
    return tMagnitude;
  }

  WorldPosition calcDataPointPosition( float aValue )
  {
    WorldPosition tGraphStartPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.startPos.x + position.x, ( extentsPosition.y - position.y ) * hAxis.startPos.y + position.y );
    WorldPosition tGraphExtentsPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.endPos.x + position.x, ( extentsPosition.y - position.y ) * hAxis.endPos.y + position.y );

    WorldPosition tDataPointPos = new WorldPosition( tGraphExtentsPosition );
    tDataPointPos.sub( tGraphStartPosition );
    tDataPointPos.x *= hAxis.calcValueRelativePosition( aValue );
    tDataPointPos.add( tGraphStartPosition );

    return tDataPointPos;
  }

  Rectangle calcScreenRect()
  {
    PVector tOffset = new PVector( 0, -30 );
    tOffset.mult( uiCam.getScale() );
    if ( this.position.x > this.extentsPosition.x ) { 
      tOffset.x *= -1;
    }
    if ( this.position.y > this.extentsPosition.y ) { 
      tOffset.y *= -1;
    }
    PVector tScreenPos = this.position.toScreen();
    tScreenPos.add( tOffset );
    PVector tScreenExtentsPos = extentsPosition.toScreen();
    Rectangle tRect = new Rectangle( floor( min( tScreenPos.x, tScreenExtentsPos.x ) ), floor( min( tScreenPos.y, tScreenExtentsPos.y ) ), ceil( abs( tScreenExtentsPos.x - tScreenPos.x ) ), ceil( abs( tScreenExtentsPos.y - tScreenPos.y ) ) );
    return tRect;
  }
  
  Rectangle calcGraphScreenArea()
  {
    WorldPosition tGraphStartPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.startPos.x + position.x, min( extentsPosition.y, position.y ) );
    WorldPosition tGraphExtentsPosition = new WorldPosition( ( extentsPosition.x - position.x ) * hAxis.endPos.x + position.x, max( extentsPosition.y, position.y ) );
    PVector tScreenPos = tGraphStartPosition.toScreen();
    PVector tScreenExtentsPos = tGraphExtentsPosition.toScreen();
    Rectangle tRect = new Rectangle( floor( min( tScreenPos.x, tScreenExtentsPos.x ) ), floor( min( tScreenPos.y, tScreenExtentsPos.y ) ), ceil( abs( tScreenExtentsPos.x - tScreenPos.x ) ), ceil( abs( tScreenExtentsPos.y - tScreenPos.y ) ) );
    return tRect;
  }

  float calcValueAtScreenPosition( PVector aScreenPos )
  {
    WorldPosition tScreenToWorldPos = worldPosFromScreen( aScreenPos );
    
    float tValue = tScreenToWorldPos.x;
    tValue = ( tValue - position.x ) / ( extentsPosition.x - position.x );
    
    tValue = hAxis.calcValueAtRatio( tValue );
            
    return tValue;
  }


  void drawDebug()
  {
    super.drawDebug();

    if ( hoveredEntity == this )
    {
      fill( 0, 0, 1, 0.7 );
      noStroke();
      float tValue = calcValueAtScreenPosition( new PVector( mouseX, mouseY ) );
      textFont( fontDebugValue );
      textAlign( LEFT, BOTTOM );
      text( str( round( tValue * 100 ) / 100.0 ), mouseX, mouseY );
    }
  }

  void removeFromWorld()
  {
    world.flowManager.removeFlowsToEntity( this );
    
    super.removeFromWorld();
  }
}
