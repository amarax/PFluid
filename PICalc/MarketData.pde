class MarketItemData implements XMLizable
{
  String name;  // Match by name for now

  float priceHighestBuy;
  float priceLowestSell;

  MarketItemData( String aName )
  {
    name = aName;

    priceHighestBuy = 0;
    priceLowestSell = 0;
  }

  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "MarketItem" );

    XMLElement tChild;

    tChild = new XMLElement();
    tChild.setName( "Name" );
    tChild.setContent( name );
    tElement.addChild( tChild );

    XMLElement tPrices = new XMLElement();
    tPrices.setName( "Prices" );
    tElement.addChild( tPrices );

    tChild = new XMLElement();
    tChild.setName( "HighestBuy" );
    tChild.setContent( str( priceHighestBuy ) );
    tPrices.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "LowestSell" );
    tChild.setContent( str( priceLowestSell ) );
    tPrices.addChild( tChild );

    return tElement;
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    XMLElement[] tDataEntries = aXMLElement.getChildren();
    for ( int i = 0; i < tDataEntries.length; i++ )
    {
      XMLElement tDataEntry = tDataEntries[i];
      if ( tDataEntry.getName().equals( "Name" ) )
      {
        name = tDataEntry.getContent();
      }
      else if ( tDataEntry.getName().equals( "Prices" ) )
      {
        XMLElement[] tPrices = tDataEntry.getChildren();
        for ( int iPrices = 0; iPrices < tPrices.length; iPrices++ )
        {
          XMLElement tPriceEntry = tPrices[iPrices];
          if ( tPriceEntry.getName().equals( "HighestBuy" ) )
          {
            priceHighestBuy = float( tPriceEntry.getContent() );
          }
          else if ( tPriceEntry.getName().equals( "LowestSell" ) )
          {
            priceLowestSell = float( tPriceEntry.getContent() );
          }
        }
      }
    }
    return true;
  }
}

class MarketData
{
  HashMap<EVEItem, MarketItemData> marketItemDataMap;

  MarketData()
  {
    marketItemDataMap = new HashMap<EVEItem, MarketItemData>();
  }

  boolean loadData( XMLElement aRootElement )
  {
    if ( aRootElement.getName().equals( "MarketData" ) )
    {
      XMLElement[] tDataEntries = aRootElement.getChildren();
      // Add all materials before processes
      for ( int i = 0; i < tDataEntries.length; i++ )
      {
        XMLElement tDataEntry = tDataEntries[i];
        if ( tDataEntry.getName().equals( "MarketItem" ) )
        {
          MarketItemData tMarketData = new MarketItemData( "" );
          if ( tMarketData.fromXML( tDataEntry ) )
          {
            PIMaterial tMaterial = piData.getMaterial( tMarketData.name );
            if ( tMaterial != null )
              marketItemDataMap.put( tMaterial, tMarketData );
          }
        }
      }

      if ( marketItemDataMap.size() == 0 )
      {
        for ( int i = 0; i < piData.materials.size(); i++ )
        {
          PIMaterial tMaterial = piData.materials.get( i );
          MarketItemData tMarketData = new MarketItemData( tMaterial.name );
          marketItemDataMap.put( tMaterial, tMarketData );
        }
      }

      println( "MARKETDATA> " + str( marketItemDataMap.size() ) + " market items loaded." );
      return true;
    }
    return false;
  }

  void saveData( String aFilename )
  {
    // Somehow it's not easy to clear the XMLElement of all its children
    int tTotalChildren = marketDataXML.getChildCount(); 
    for ( int i = 0; i < tTotalChildren; i++ )
    {
      marketDataXML.removeChild( 0 );
    }

    Collection<MarketItemData> tMarketItemDatas = marketItemDataMap.values();
    Iterator<MarketItemData> iMarketItemDatas = tMarketItemDatas.iterator();
    while ( iMarketItemDatas.hasNext () )
    {
      MarketItemData tMarketItemData = iMarketItemDatas.next();
      marketDataXML.addChild( tMarketItemData.toXML() );
    }

    try
    {
      marketDataXML.save( aFilename );
    }
    catch( Exception e )
    {
      println( e );
    }

    println( "MARKETDATA> " + str( marketDataXML.getChildren().length ) + " market items saved." );
  }
  
  MarketItemData getMarketDataFor( EVEItem aItem )
  {
    if( marketItemDataMap.containsKey( aItem ) )
    {
      return marketItemDataMap.get( aItem );
    }
    return null;
  }
}

