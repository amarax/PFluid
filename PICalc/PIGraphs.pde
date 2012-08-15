class GraphPIDataMaterials extends Graph2D
{
  PIMaterial editedMaterial;

  GraphPIDataMaterials( String aName, WorldPosition aPosition )
  {
    super( aName, aPosition );

    editedMaterial = null;
  }

  void init()
  {
    super.init();

    hAxis.startValue = 0;
    hAxis.endValue = 1000000 + 1;

    vAxis.startValue = -1;
    vAxis.endValue = piData.materials.size() + 1;
    vAxis.valueStep = 1;
  }

  PIMaterial getMaterialAt( PVector aScreenPos )
  {
    if ( calcScreenRect().contains( aScreenPos.x, aScreenPos.y ) )
    {
      PVector tValues = this.calcValuesAtScreenPosition( aScreenPos );

      if ( tValues.y >= 0 && tValues.y < piData.materials.size() )
      {
        return piData.materials.get( round( tValues.y ) );
      }
    }

    return null;
  }

  void update()
  {
    super.update();

    MarketItemData tMarketData = marketData.getMarketDataFor( editedMaterial );
    if ( tMarketData != null )
    {
      switch( currentUIContext )
      {
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_START:
        {
          tMarketData.priceHighestBuy = round( calcValuesAtScreenPosition( new PVector( mouseX, mouseY ) ).x * 100.0 ) / 100.0;
          if ( tMarketData.priceHighestBuy < 0 )
          {
            tMarketData.priceHighestBuy = 0;
          }
          if ( tMarketData.priceHighestBuy > tMarketData.priceLowestSell )
          {
            tMarketData.priceLowestSell = tMarketData.priceHighestBuy;
          }
        }
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_END:
        {
          tMarketData.priceLowestSell = round( calcValuesAtScreenPosition( new PVector( mouseX, mouseY ) ).x * 100.0 ) / 100.0;
          if ( tMarketData.priceLowestSell < tMarketData.priceHighestBuy )
          {
            tMarketData.priceHighestBuy = tMarketData.priceLowestSell;
          }
        }
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SHIFTINGVALUES:
      }
    }
  }

  void plot()
  {
    super.plot();

    Rectangle tGraphScreenArea = this.calcGraphScreenHitArea();

    float tMarkLength = 5 * uiCam.getScale();

    // Draw scale
    float tRange = abs( hAxis.endValue - hAxis.startValue );
    float tMarkUnit = pow( 10, ceil( log( tRange ) / log( 10 ) - 1 ) );
    float tStartValue = min( hAxis.startValue, hAxis.endValue );
    tStartValue = round( tStartValue / tMarkUnit ) * tMarkUnit;
    float tFadeFactor = min( ( ( log( tRange ) / log( 10 ) - 1 ) * 2 ) % 2, 1 );
    for ( float i = tStartValue; i < max( hAxis.startValue, hAxis.endValue ); i = i + tMarkUnit )
    {
      plotHMark( i, 5, color( 0, 0, 0.8, 0.2 * tFadeFactor ), color( 0, 0, 1, 0.3 * tFadeFactor ) );
    }
    tMarkUnit = pow( 10, floor( log( tRange ) / log( 10 ) - 1 ) );
    tStartValue = min( hAxis.startValue, hAxis.endValue );
    tStartValue = round( tStartValue / tMarkUnit ) * tMarkUnit;
    tFadeFactor = 1 - tFadeFactor;
    for ( float i = tStartValue; i < max( hAxis.startValue, hAxis.endValue ); i = i + tMarkUnit )
    {
      plotHMark( i, 5, color( 0, 0, 0.8, 0.2 * tFadeFactor ), color( 0, 0, 1, 0.3 * tFadeFactor ) );
    }

    for ( int i = 0; i < piData.materials.size(); i++ )
    {
      PIMaterial tMaterial = piData.materials.get( i );

      MarketItemData tMarketData = marketData.getMarketDataFor( tMaterial );

      float tBarThickness = 0.5;

      WorldPosition tDataPointStart = this.calcDataPointPosition( tMarketData.priceHighestBuy, i - tBarThickness / 2 );
      PVector tScreenPos = tDataPointStart.toScreen();

      WorldPosition tDataPointEnd = this.calcDataPointPosition( tMarketData.priceLowestSell, i + tBarThickness / 2 );
      PVector tScreenPosEnd = tDataPointEnd.toScreen();

      if ( tGraphScreenArea.contains( tScreenPos.x, tScreenPos.y ) && tGraphScreenArea.contains( tScreenPosEnd.x, tScreenPosEnd.y ) )
      {
        noStroke();
        fill( 0, 0, 1, 0.5 );
        rect( tScreenPos.x, tScreenPos.y, max( tScreenPosEnd.x - tScreenPos.x, 1 ), max( tScreenPosEnd.y - tScreenPos.y, 1 ) );

      }

      if ( tGraphScreenArea.y < tScreenPos.y && tGraphScreenArea.y + tGraphScreenArea.height > tScreenPosEnd.y )
      {
        PVector tMarkPos = this.calcDataPointPosition( hAxis.startValue, i ).toScreen();
  
        stroke( 0, 0, 1, 0.8 );
        strokeWeight( 1 );
        noFill();
        line( tMarkPos.x, tMarkPos.y, tMarkPos.x - tMarkLength, tMarkPos.y );
  
        fill( 0, 0, 1 );
        noStroke();
        textFont( fontValue );
        float tTextSize = 8 * uiCam.getScale();
        textSize( tTextSize );
        textAlign( RIGHT, BOTTOM );
        text( tMaterial.name, tMarkPos.x - tMarkLength - 2 * uiCam.getScale(), tMarkPos.y + tTextSize / 2 );
      }

      if ( editedMaterial == tMaterial )
      {
        if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_START || currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SHIFTINGVALUES )
        {
          stroke( 0, 0, 1, 0.8 );
          strokeWeight( 1 );
          noFill();
          line( tScreenPos.x, tScreenPos.y, tScreenPos.x, tScreenPosEnd.y );

          fill( 0, 0, 1 );
          noStroke();
          textFont( fontValue );
          float tTextSize = 8 * uiCam.getScale();
          textSize( tTextSize );
          textAlign( RIGHT, BOTTOM );
          text( nfc( tMarketData.priceHighestBuy, 2 ), tScreenPos.x - 2 * uiCam.getScale(), tScreenPosEnd.y );
        }
        if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_END || currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SHIFTINGVALUES )
        {
          stroke( 0, 0, 1, 0.8 );
          strokeWeight( 1 );
          noFill();
          line( tScreenPosEnd.x, tScreenPos.y, tScreenPosEnd.x, tScreenPosEnd.y );

          fill( 0, 0, 1 );
          noStroke();
          textFont( fontValue );
          float tTextSize = 8 * uiCam.getScale();
          textSize( tTextSize );
          textAlign( LEFT, BOTTOM );
          text( nfc( tMarketData.priceLowestSell, 2 ), tScreenPosEnd.x + 2 * uiCam.getScale(), tScreenPosEnd.y );
        }
      }
    }
  }

  void plotHMark( float aValue, float aMarkLength, color aMarkColor, color aTextColor )
  {
    Rectangle tGraphScreenArea = calcGraphScreenHitArea();

    // Expand area by one pixel to catch rounding errors
    tGraphScreenArea.x -= 1;
    tGraphScreenArea.y -= 1;
    tGraphScreenArea.width += 2;
    tGraphScreenArea.height += 2;

    float tMarkLength = aMarkLength * uiCam.getScale();
    PVector tMarkPosition = calcDataPointPosition( aValue, vAxis.startValue ).toScreen();
    
    if ( tGraphScreenArea.contains( tMarkPosition.x, tMarkPosition.y ) )
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

  void drawDebug()
  {
    super.drawDebug();

    Rectangle tGraphScreenArea = calcGraphScreenHitArea();
    float tMarkLength = 5 * uiCam.getScale();

    PVector tVZeroPos = this.calcDataPointPosition( hAxis.startValue, 0 ).toScreen();
    if ( tGraphScreenArea.contains( tVZeroPos.x, tVZeroPos.y ) )
    {
      stroke( 0, 0, 1, 0.2 );
      strokeWeight( 1 );
      noFill();
      line( tVZeroPos.x, tVZeroPos.y, tVZeroPos.x - tMarkLength * 3, tVZeroPos.y );
    }
    PVector tHZeroPos = this.calcDataPointPosition( 0, vAxis.startValue ).toScreen();
    if ( tGraphScreenArea.contains( tHZeroPos.x, tHZeroPos.y ) )
    {
      stroke( 0, 0, 1, 0.2 );
      strokeWeight( 1 );
      noFill();
      line( tHZeroPos.x, tHZeroPos.y, tHZeroPos.x, tHZeroPos.y - tMarkLength * 3 );
    }
    

    PIMaterial tMaterial = getMaterialAt( new PVector( mouseX, mouseY ) );
    if ( tMaterial != null )
    {
      fill( 0, 0, 1, 0.7 );
      noStroke();
      PVector tValues = calcValuesAtScreenPosition( new PVector( mouseX, mouseY ) );
      textFont( fontDebugValue );
      textAlign( LEFT, BOTTOM );
      text( tMaterial.name, mouseX, mouseY - 10 );
    }
  }

  Rectangle calcScreenRect()
  {
    PVector tOffset = new PVector( -100, -30 );
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

  void processMouseReleased()
  {
    switch( currentUIContext )
    {
    case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
      {
        PVector tScreenPos = new PVector( mouseX, mouseY );
        PIMaterial tMaterial = getMaterialAt( tScreenPos );
        if ( tMaterial != null )
        {
          editedMaterial = tMaterial;

          MarketItemData tMarketData = marketData.getMarketDataFor( tMaterial );
          if ( tMarketData != null )
          {
            int tHighestBuyScreenX = floor( calcDataPointPosition( tMarketData.priceHighestBuy, 0 ).toScreen().x );
            int tLowestSellScreenX = ceil( calcDataPointPosition( tMarketData.priceLowestSell, 0 ).toScreen().x );

            int tTolerance = 5;
            if ( tScreenPos.x >= tHighestBuyScreenX - tTolerance && tScreenPos.x <= tHighestBuyScreenX + tTolerance )
            {
              currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_START;
            }
            else if ( tScreenPos.x >= tLowestSellScreenX - tTolerance && tScreenPos.x <= tLowestSellScreenX + tTolerance )
            {
              currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_END;
            }
          }
        }
      }
      break;
    case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_START:
    case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_END:
    case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SHIFTINGVALUES:
      {  
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
        editedMaterial = null;
      }
      break;
    default:
    }
  }
}

