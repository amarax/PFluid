

class PIUI
{
  float magnitudeScale;
  
  final color flowColor; 

  PIUI( float aMagnitudeScale )
  {
    magnitudeScale = aMagnitudeScale;

    colorMode( HSB, 360.0, 1.0, 1.0, 1.0 );
    flowColor =  color( 0, 0, 1, 0.3 );
  }
}


class PINode extends Entity implements FlowNodePI
{
  float magnitude = 0;

  DampingHelper_Float magnitudeDamper;

  PIProcess process;

  int defaultTier = -1;

  DampingHelper_Color baseColorDamper;
  DampingHelper_Float highlightAlphaDamper;
  
  final float defaultWidth = 120;
  
  PINode()
  {
    super( "0x" + hex( round( random( 2147483647 ) ) ) );

    magnitudeDamper = new DampingHelper_Float( 0.3, magnitude );
  }

  PINode( PINode aExistingPINode )
  {
    super( aExistingPINode );

    magnitude = aExistingPINode.magnitude;
    process = aExistingPINode.process;
    
    defaultTier = aExistingPINode.defaultTier;
    
    magnitudeDamper = new DampingHelper_Float( 0.3, magnitude );
  }

  void update()
  {
    magnitudeDamper.update( magnitude );
  }

  void plot()
  {
    PVector tPosition = position.toScreen();
    PVector tSize = calcScreenSize();

    // Draw tier text
    String tTierName = "";
    int tTier = defaultTier;
    if ( process != null )
    {
      tTier = process.tier;
    }
    switch( tTier )
    {
    case PITier.R0:
      tTierName = "R0";
      break;
    case PITier.P1:
      tTierName = "P1";
      break;
    case PITier.P2:
      tTierName = "P2";
      break;
    case PITier.P3:
      tTierName = "P3";
      break;
    case PITier.P4:
      tTierName = "P4";
      break;
    case PITier.P_:
      tTierName = "P_";
      break;
    default:
    }

    fill( 0, 0, 0.2 );
    textAlign( RIGHT, BOTTOM );
    textFont( fontNodePITier );
    textSize( 12 * uiCam.getScale() );
    text( tTierName, tPosition.x + tSize.x - 4 * uiCam.getScale(), tPosition.y + tSize.y - 8 * uiCam.getScale() );

    // Draw input/output names
    if ( process != null )
    {
      fill( 0, 0, 0.2 );
      textFont( fontNodePIMaterial );
      textSize( 6 * uiCam.getScale() );

      float tInputMagnitudeOffset = 0;
      for ( int i = 0; i < process.inputs.size(); i++ )
      {
        PIInOutput tInput = process.inputs.get( i );

        textAlign( LEFT, TOP );
        text( tInput.material.name, tPosition.x + 2 * uiCam.getScale(), tPosition.y + ( i == 0 ? 4 : 0 ) * uiCam.getScale() + tInputMagnitudeOffset * piUI.magnitudeScale * uiCam.getScale() );
        
        tInputMagnitudeOffset += tInput.units * tInput.material.volume / process.cycleTime;
      }

      textAlign( RIGHT, BOTTOM );
      text( process.output.material.name, tPosition.x + tSize.x - 2 * uiCam.getScale(), tPosition.y + tSize.y - 2 * uiCam.getScale() );
    }
  }

  void drawDebug()
  {
    super.drawDebug();

    PVector tScreenPos = position.toScreen();
    PVector tScreenSize = calcScreenSize();

    fill ( 0, 0, 1 );
    textFont( fontDebugValue );

    textAlign( RIGHT, BOTTOM );
    text( "Magnitude " + str( magnitude ), tScreenPos.x + tScreenSize.x, tScreenPos.y + tScreenSize.y );

    if ( process != null )
    {
      String tInputDisplay = "";
      for ( int i = 0; i < process.inputs.size(); i++ )
      {
        PIInOutput tInput = process.inputs.get( i );

        textAlign( LEFT, BOTTOM );
        textLeading( 10 );
        tInputDisplay += "\n" + tInput.material.name + "\n" + str( tInput.units * tInput.material.volume / process.cycleTime ) + " m3";
      }
      text( tInputDisplay, tScreenPos.x, tScreenPos.y );

      textAlign( RIGHT, TOP );
      textLeading( 10 );
      String tOutputDisplay = process.output.material.name + "\n" + str( ( process.output.units > -1 ? process.output.units * process.output.material.volume : magnitude ) / process.cycleTime ) + " m3";
      text( tOutputDisplay, tScreenPos.x + tScreenSize.x, tScreenPos.y + tScreenSize.y );
    }
  }

  float calcMagnitude()
  {
    if ( process != null )
    {
      float tInputMagnitude = 0;
      Iterator<PIInOutput> iInput = process.inputs.iterator();
      while ( iInput.hasNext () )
      {
        PIInOutput tInput = iInput.next();

        tInputMagnitude += tInput.units * tInput.material.volume / process.cycleTime;
      }
      float tOutputMagnitude = process.output.units * process.output.material.volume / process.cycleTime;
      return max( tInputMagnitude, tOutputMagnitude );
    }
    return 0;
  }

  PVector calcScreenSize()
  {
    return new PVector( defaultWidth * uiCam.getScale(), ( magnitudeDamper.getValue() * piUI.magnitudeScale + 27 ) * uiCam.getScale() );
  }

  Rectangle calcHitRect()
  {
    PVector tScreenPos = this.position.toScreen();
    Rectangle tRect = new Rectangle( floor( tScreenPos.x ), floor( tScreenPos.y ), ceil( defaultWidth * uiCam.getScale() ), ceil( ( magnitudeDamper.getValue() * piUI.magnitudeScale + 27 ) * uiCam.getScale() ) );
    return tRect;
  }

  boolean contains( PVector aScreenPos )
  {
    return calcHitRect().contains( aScreenPos.x, aScreenPos.y );
  }

  void removeFromWorld()
  {
    world.flowManager.removeFlowsToEntity( this );

    if( uiCursor.cursorNode == this )
    {
       uiCursor.cursorNode = null;
    }

    super.removeFromWorld();
  }
  
  PIMaterial getMaterialProduced( FlowPI aFlow ) { return null; }
  int getUnitsProduced() { return 0; }
  int getUnitsRequired( PIMaterial aMaterial ) { return 0; }
  float getInputWorldOffset( PIMaterial aMaterial ) { return 0; }
  
  PIProcess getProcess()
  {
    return process;
  }

  WorldPosition getWorldPosition()
  {
    return position;
  }

  FlowPoint getOutputPoint()
  {
    WorldPosition tOutputPosition = new WorldPosition( position );
    tOutputPosition.x += defaultWidth;
    return new FlowPoint( tOutputPosition, 0, HALF_PI );
  }
  
  FlowPoint getInputPoint( PIMaterial aMaterial )
  {
    return new FlowPoint( position, 0, HALF_PI );
  }
}


class PINodeExtractor extends PINode
{
  PINodeExtractor()
  {
    super();

    magnitude = 0;
    defaultTier = PITier.R0;
    
    baseColorDamper = new DampingHelper_Color( 0.5, color( 180, 1, 0.7 ) );
    highlightAlphaDamper = new DampingHelper_Float( 0.45, 1.0 );
  }
  
  PINodeExtractor( PINodeExtractor aExistingExtractor )
  {
    super( aExistingExtractor );

    baseColorDamper = new DampingHelper_Color( 0.5, color( 180, 1, 0.7 ) );
    highlightAlphaDamper = new DampingHelper_Float( 0.45, 1.0 );
  }

  void plot()
  {
    color tBaseColor = color( 180, 1, 0.7 );
    float tHighlightAlpha = 0.0;
    if( hoveredEntity == this )
    {
      tBaseColor = color( 180, 1, 0.8 );
    }
    if( isSelected( this ) )
    {
      tHighlightAlpha = 1.0;
    }
    baseColorDamper.update( tBaseColor );
    highlightAlphaDamper.update( tHighlightAlpha );
    
    PVector tScreenPos = position.toScreen();
    PVector tScreenSize = calcScreenSize();

    noStroke();
    fill( baseColorDamper.getValue() );
    rect( tScreenPos.x, tScreenPos.y, tScreenSize.x, tScreenSize.y );
    
    if( highlightAlphaDamper.getValue() > 0.001 )
    {
      fill( 180, 1, 1, highlightAlphaDamper.getValue() );
      float tHighlightHeight = 27 * uiCam.getScale();
      rect( tScreenPos.x, max( tScreenPos.y, tScreenPos.y + tScreenSize.y - tHighlightHeight ), tScreenSize.x, min( tScreenSize.y, tHighlightHeight ) );
    }
    
    if ( process != null )
    {
      float tInOutputIndicatorWidth = piUI.magnitudeScale * uiCam.getScale();
      
      fill( baseColorDamper.getValue() );
      rect( tScreenPos.x + tScreenSize.x - 1, tScreenPos.y, tInOutputIndicatorWidth + 1, uiCam.getScale() * piUI.magnitudeScale * magnitude );
    }

    super.plot();
  }

  void processKey()
  {
    if ( key != CODED )
    {
      switch( key )
      {
      case '2':
        this.process = piData.getProcess( "Carbon Compounds" );
        break;
      case '0':
        this.process = piData.getProcess( "Noble Metals" );
        break;
      }
    }
  }

  PIMaterial getMaterialProduced( FlowPI aFlow )
  {
    if ( process != null )
    {
      return process.output.material;
    }
    return null;
  }

  int getUnitsProduced()
  {
    int tUnitsProduced = 0;
    if ( process != null )
    {
      tUnitsProduced = floor( magnitude / process.output.material.volume );
    }
    return tUnitsProduced;
  }
}

class PINodeFactory extends PINode
{
  PINodeFactory()
  {
    super();

    magnitude = 40;
    defaultTier = PITier.P_;

    baseColorDamper = new DampingHelper_Color( 0.5, color( 40, 1, 0.8 ) );
    highlightAlphaDamper = new DampingHelper_Float( 0.45, 1.0 );
  }
  
  PINodeFactory( PINodeFactory aExistingFactory )
  {
    super( aExistingFactory );
    
    baseColorDamper = new DampingHelper_Color( 0.5, color( 40, 1, 0.8 ) );
    highlightAlphaDamper = new DampingHelper_Float( 0.45, 1.0 );
  }

  void plot()
  {
    if ( process != null )
    {
      magnitude = calcMagnitude();
    }

    color tBaseColor = color( 40, 1, 0.8 );
    float tHighlightAlpha = 0.0;
    if( hoveredEntity == this )
    {
      tBaseColor = color( 40, 1, 0.9 );
    }
    if( isSelected( this ) )
    {
      tHighlightAlpha = 1.0;
    }
    baseColorDamper.update( tBaseColor );
    highlightAlphaDamper.update( tHighlightAlpha );

    PVector tScreenPos = position.toScreen();
    PVector tScreenSize = calcScreenSize();

    noStroke();
    fill( baseColorDamper.getValue() );
    rect( tScreenPos.x, tScreenPos.y, tScreenSize.x, tScreenSize.y );

    float tHighlightHeight = 27 * uiCam.getScale();

    if( highlightAlphaDamper.getValue() > 0.001 )
    {
      fill( 40, 1, 1, highlightAlphaDamper.getValue() );
      rect( tScreenPos.x, max( tScreenPos.y, tScreenPos.y + tScreenSize.y - tHighlightHeight ), tScreenSize.x, min( tScreenSize.y, tHighlightHeight ) );
    }

    if ( process != null )
    {
      float tInOutputIndicatorWidth = piUI.magnitudeScale * uiCam.getScale();
      
      fill( baseColorDamper.getValue() );
      //rect( tScreenPos.x + tScreenSize.x - 1, tScreenPos.y, tInOutputIndicatorWidth + 1, uiCam.getScale() * piUI.magnitudeScale * process.output.units * process.output.material.volume / process.cycleTime );
      
      float tTotalInputMagnitude= 0;
      for ( int i = 0; i < process.inputs.size(); i++ )
      {
        PIInOutput tInput = process.inputs.get( i );
        
        tTotalInputMagnitude += tInput.units * tInput.material.volume / process.cycleTime;
      }

      rect( tScreenPos.x - tInOutputIndicatorWidth, tScreenPos.y, tInOutputIndicatorWidth + 1, tTotalInputMagnitude * piUI.magnitudeScale * uiCam.getScale() );
    }

    super.plot();
  }

  void processKey()
  {
    if ( key != CODED )
    {
      switch(key)
      {
      case '1':
        this.process = piData.getProcess( "Biocells" );
        break;
      case '2':
        this.process = piData.getProcess( "Biofuels" );
        break;
      case '0':
        this.process = piData.getProcess( "Precious Metals" );
        break;
      }
    }
  }

  PIMaterial getMaterialProduced( FlowPI aFlow )
  {
    if ( process != null )
    {
      return process.output.material;
    }
    return null;
  }

  int getUnitsProduced()
  {
    int tUnitsProduced = 0;
    if ( process != null )
    {
      tUnitsProduced = round( process.output.units / process.cycleTime );
    }
    return tUnitsProduced;
  }

  int getUnitsRequired( PIMaterial aMaterial )
  {
    int tUnitsRequired = 0;
    if ( process != null )
    {
      boolean tFound = false;
      Iterator<PIInOutput> iInput = process.inputs.iterator();
      while ( iInput.hasNext () && !tFound )
      {
        PIInOutput tInput = iInput.next();

        if ( tInput.material == aMaterial )
        {
          tUnitsRequired = round( tInput.units / process.cycleTime );
          tFound = true;
        }
      }
    }
    return tUnitsRequired;
  }

  float getInputWorldOffset( PIMaterial aMaterial )
  {
    float tOffset = 0;
    return tOffset;
  }
  
  FlowPoint getInputPoint( PIMaterial aMaterial )
  {
    float tOffset = 0;
    boolean tInputFound = false;
    if( process != null && aMaterial != null )
    {
      Iterator<PIInOutput> iInputs = process.inputs.iterator();
      while ( iInputs.hasNext () && !tInputFound )
      {
        PIInOutput tInput = iInputs.next();
  
        if ( tInput.material == aMaterial )
        {
          tInputFound = true;
        }
        else
        {
          tOffset += piUI.magnitudeScale * tInput.material.volume * tInput.units / process.cycleTime;
        }
      }
    }
    
    WorldPosition tInputPoint = new WorldPosition( position );
    tInputPoint.add( new PVector( 0, tOffset ) );
    
    return new FlowPoint( tInputPoint, 0, HALF_PI );
  }
}


class PINodeConsolidated extends PINode
{
  PIMaterial material;
  
  PINodeConsolidated( PIMaterial aMaterial )
  {
    super();

    material = aMaterial;
    
    magnitudeDamper.dampingFactor = 0.1;
  }

  PINodeConsolidated( PINodeConsolidated aExistingNode )
  {
    super( aExistingNode );
    
    material = aExistingNode.material;
    
    magnitudeDamper.dampingFactor = 0.1;
  }

  void update()
  {
    super.update();
  }

  void plot()
  {
    PVector tScreenPos = position.toScreen();
    PVector tScreenSize = calcScreenSize();

    noStroke();
    fill( piUI.flowColor );
    rect( tScreenPos.x, tScreenPos.y, tScreenSize.x, tScreenSize.y );
  }

  void drawDebug()
  {
    super.drawDebug();

    PVector tScreenPos = this.position.toScreen();

    fill ( 0, 0, 1 );
    textFont( fontDebugValue );

    String tMaterialName = "No material";
    if( material != null ) { tMaterialName = material.name; }

    textAlign( LEFT, TOP );
    text( tMaterialName, tScreenPos.x, tScreenPos.y + 20 * uiCam.getScale() );
  }

  float calcMagnitude()
  {
    return -1;
  }

  PVector calcScreenSize()
  {
    return new PVector( max( magnitudeDamper.getValue() * piUI.magnitudeScale * uiCam.getScale() / 2, 1 ), max( magnitudeDamper.getValue() * piUI.magnitudeScale * uiCam.getScale(), 1 ) );
  }

  Rectangle calcHitRect()
  {
    PVector tScreenPos = this.position.toScreen();
    Rectangle tRect = new Rectangle( floor( tScreenPos.x ), floor( tScreenPos.y ), ceil( max( magnitudeDamper.getValue() * piUI.magnitudeScale * uiCam.getScale() / 2, 1 ) ), ceil( max( magnitudeDamper.getValue() * piUI.magnitudeScale * uiCam.getScale(), 1 ) ) );
    return tRect;
  }

  boolean contains( PVector aScreenPos )
  {
    return calcHitRect().contains( aScreenPos.x, aScreenPos.y );
  }

  PIMaterial getMaterialProduced( FlowPI tFlow )
  {
    return material;
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

  FlowPoint getOutputPoint()
  {
    WorldPosition tOutputPosition = new WorldPosition( position );
    tOutputPosition.x += calcScreenSize().x / uiCam.getScale();
    return new FlowPoint( tOutputPosition, 0, HALF_PI );
  }
  
}
