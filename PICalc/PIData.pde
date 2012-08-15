
class EVEItem implements XMLizable
{
  int itemID;
  String name;

  float volume;

  EVEItem( String aName )
  {
    itemID = -1;
    name = aName;

    volume = 0;
  }

  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "Item" );

    XMLElement tChild;

    tChild = new XMLElement();
    tChild.setName( "ItemID" );
    tChild.setContent( name );
    tElement.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "Name" );
    tChild.setContent( name );
    tElement.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "Volume" );
    tChild.setContent( str( volume ) );
    tElement.addChild( tChild );

    return tElement;
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    XMLElement[] tDataEntries = aXMLElement.getChildren();
    for ( int i = 0; i < tDataEntries.length; i++ )
    {
      XMLElement tDataEntry = tDataEntries[i];
      if ( tDataEntry.getName().equals( "ItemID" ) )
      {
        itemID = int( tDataEntry.getContent() );
      }
      else if ( tDataEntry.getName().equals( "Name" ) )
      {
        name = tDataEntry.getContent();
      }
      else if ( tDataEntry.getName().equals( "Volume" ) )
      {
        volume = float( tDataEntry.getContent() );
      }
    }
    return true;
  }
}




class PIMaterial extends EVEItem
{
  PIMaterial( String aName, float aVolume )
  {
    super( aName );

    volume = aVolume;
  }

  XMLElement toXML()
  {
    XMLElement tElement = super.toXML();
    tElement.setName( "Material" );
    return tElement;
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    return super.fromXML( aXMLElement );
  }
}

class PIInOutput implements XMLizable
{
  PIMaterial material;
  int units;

  PIInOutput( PIMaterial aMaterial, int aUnits )
  {
    material = aMaterial;
    units = aUnits;
  }

  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "InOutput" );

    XMLElement tChild;

    tChild = new XMLElement();
    tChild.setName( "Material" );
    tChild.setContent( material.name ); // Should be some ID instead
    tElement.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "Units" );
    tChild.setContent( str( units ) );
    tElement.addChild( tChild );

    return tElement;
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    XMLElement[] tDataEntries = aXMLElement.getChildren();
    for ( int i = 0; i < tDataEntries.length; i++ )
    {
      XMLElement tDataEntry = tDataEntries[i];
      if ( tDataEntry.getName().equals( "Material" ) )
      {
        PIMaterial tMaterial = piData.getMaterial( tDataEntry.getContent() );
        material = tMaterial;
      }
      else if ( tDataEntry.getName().equals( "Units" ) )
      {
        units = int( tDataEntry.getContent() );
      }
    }
    return true;
  }
}

class PIProcess implements XMLizable
{
  ArrayList<PIInOutput> inputs;
  PIInOutput output;
  float cycleTime;  // in hours

  int tier;

  float installCost;

  PIProcess( int aTier )
  {
    inputs = new ArrayList<PIInOutput>();
    installCost = 0;

    setTier( aTier );
  }

  void setTier( int aTier )
  {
    tier = aTier;

    if ( aTier == PITier.P1 )
    {
      cycleTime = 0.5;
    }
    else
    {
      cycleTime = 1;
    }
  }

  PIInOutput getInput( PIMaterial aMaterial )
  {
    for ( int i = 0; i < inputs.size(); i++ )
    {
      PIInOutput tInput = inputs.get( i );
      if ( tInput.material == aMaterial )
      {
        return tInput;
      }
    }
    return null;
  }

  int getInputIndex( PIMaterial aMaterial )
  {
    for ( int i = 0; i < inputs.size(); i++ )
    {
      PIInOutput tInput = inputs.get( i );
      if ( tInput.material == aMaterial )
      {
        return i;
      }
    }
    return -1;
  }

  XMLElement toXML()
  {
    XMLElement tElement = new XMLElement();
    tElement.setName( "Process" );

    XMLElement tChild;

    tChild = new XMLElement();
    tChild.setName( "Tier" );
    tChild.setContent( str( tier ) );
    tElement.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "CycleTime" );
    tChild.setContent( str( cycleTime ) );
    tElement.addChild( tChild );

    tChild = new XMLElement();
    tChild.setName( "InstallCost" );
    tChild.setContent( str( installCost ) );
    tElement.addChild( tChild );

    XMLElement tOutput = output.toXML();
    tOutput.setName( "Output" );
    tElement.addChild( tOutput );

    for ( int i = 0; i < inputs.size(); i++ )
    {
      XMLElement tInput = inputs.get( i ).toXML();
      tInput.setName( "Input" );
      tElement.addChild( tInput );
    }

    return tElement;
  }

  boolean fromXML( XMLElement aXMLElement )
  {
    XMLElement[] tDataEntries = aXMLElement.getChildren();
    for ( int i = 0; i < tDataEntries.length; i++ )
    {
      XMLElement tDataEntry = tDataEntries[i];
      if ( tDataEntry.getName().equals( "Tier" ) )
      {
        setTier( int( tDataEntry.getContent() ) );
      }
      else if ( tDataEntry.getName().equals( "CycleTime" ) )
      {
        cycleTime = float( tDataEntry.getContent() );
      }
      else if ( tDataEntry.getName().equals( "InstallCost" ) )
      {
        installCost = float( tDataEntry.getContent() );
      }
      else if ( tDataEntry.getName().equals( "Output" ) )
      {
        PIInOutput tOutput = new PIInOutput( null, -1 );
        tOutput.fromXML( tDataEntry );
        output = tOutput;
      }
      else if ( tDataEntry.getName().equals( "Input" ) )
      {
        PIInOutput tInput = new PIInOutput( null, -1 );
        tInput.fromXML( tDataEntry );
        inputs.add( tInput );
      }
    }
    return true;
  }
}





class PIData
{
  ArrayList<PIMaterial> materials;
  ArrayList<PIProcess> processes;

  PIData()
  {
    materials = new ArrayList<PIMaterial>();
    processes = new ArrayList<PIProcess>();
  }

  PIMaterial getMaterial( String aName )
  {
    Iterator<PIMaterial> iMaterials = materials.iterator();
    while ( iMaterials.hasNext () )
    {
      PIMaterial tMaterial = iMaterials.next();
      if ( tMaterial.name.equals( aName ) )
      {
        return tMaterial;
      }
    }
    return null;
  }

  PIProcess getProcess( PIMaterial aOutputMaterial )
  {
    Iterator<PIProcess> iProcess = processes.iterator();
    while ( iProcess.hasNext () )
    {
      PIProcess tProcess = iProcess.next();
      if ( tProcess.output.material == aOutputMaterial )
      {
        return tProcess;
      }
    }
    return null;
  }

  PIProcess getProcess( String aOutputMaterialName )
  {
    Iterator<PIProcess> iProcess = processes.iterator();
    while ( iProcess.hasNext () )
    {
      PIProcess tProcess = iProcess.next();
      if ( tProcess.output.material.name.equals( aOutputMaterialName ) )
      {
        return tProcess;
      }
    }
    return null;
  }

  boolean loadData( XMLElement aXMLElement )
  {
    if ( aXMLElement.getName().equals( "PIData" ) )
    {
      XMLElement[] tDataEntries = aXMLElement.getChildren();

      // Add all materials before processes
      int tMaterialsAdded = 0;
      for ( int i = 0; i < tDataEntries.length; i++ )
      {
        XMLElement tDataEntry = tDataEntries[i];
        if ( tDataEntry.getName().equals( "Material" ) )
        {
          PIMaterial tMaterial = new PIMaterial( "", 0 );
          if ( tMaterial.fromXML( tDataEntry ) )
          {
            materials.add( tMaterial );
            tMaterialsAdded++;
          }
        }
      }
      println( "PIDATA> " + str( tMaterialsAdded ) + " materials loaded." );
      
      int tProcessesAdded = 0;
      for ( int i = 0; i < tDataEntries.length; i++ )
      {
        XMLElement tDataEntry = tDataEntries[i];
        if ( tDataEntry.getName().equals( "Process" ) )
        {
          PIProcess tProcess = new PIProcess( -1 );
          if ( tProcess.fromXML( tDataEntry ) )
          {
            processes.add( tProcess );
            tProcessesAdded++;
          }
        }
      }
      println( "PIDATA> " + str( tProcessesAdded ) + " processes loaded." );

      return true;
    }
    return false;
  }

  void saveData( String aFilename )
  {
    // Somehow it's not easy to clear the XMLElement of all its children
    int tTotalChildren = piDataXML.getChildCount(); 
    for ( int i = 0; i < tTotalChildren; i++ )
    {
      piDataXML.removeChild( 0 );
    }

    int tMaterialsSaved = 0;
    for ( int i = 0; i < materials.size(); i++ )
    {
      piDataXML.addChild( materials.get( i ).toXML() );
      tMaterialsSaved++;
    }
    println( "PIDATA> " + str( tMaterialsSaved ) + " materials saved." );

    int tProcessesSaved = 0;
    for ( int i = 0; i < processes.size(); i++ )
    {
      piDataXML.addChild( processes.get( i ).toXML() );
      tProcessesSaved++;
    }
    println( "PIDATA> " + str( tProcessesSaved ) + " processes saved." );

    try
    {
      piDataXML.save( aFilename );
    }
    catch( Exception e )
    {
      println( e );
    }
  }
}


static class PITier
{
  final static int R0 = 0;
  final static int P1 = 1;
  final static int P2 = 2;
  final static int P3 = 3;
  final static int P4 = 4;
  final static int P_ = 10;
}

