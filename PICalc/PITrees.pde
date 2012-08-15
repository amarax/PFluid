class TreeViewPI extends Entity
{
  ArrayList<TreeViewLevelPIProcess> levels;

  WorldPosition collapsedExtentsPosition;

  Rectangle cHitRect;

  TreeViewPI( String aName, WorldPosition aPosition )
  {
    super( aName );
    position = new WorldPosition( aPosition );
    collapsedExtentsPosition = new WorldPosition( aPosition );

    levels = new ArrayList<TreeViewLevelPIProcess>();
  }

  void init()
  {
    for ( int i = 0; i < piData.processes.size(); i++ )
    {
      PIProcess tProcess = piData.processes.get( i );

      TreeViewLevelPIProcess tTreeLevel = null;
      if ( levels.size() - 1 < tProcess.tier )
      {
        tTreeLevel = new TreeViewLevelPIProcess();
        levels.add( tProcess.tier, tTreeLevel );
      }
      else if ( levels.get( tProcess.tier ) == null )
      {
        tTreeLevel = new TreeViewLevelPIProcess();
        levels.add( tProcess.tier, tTreeLevel );
      }
      else
      {
        tTreeLevel = levels.get( tProcess.tier );
      }

      TreeViewNodePIProcess tNode = new TreeViewNodePIProcess( tProcess );
      tTreeLevel.nodes.add( tNode );
    }
  }

  void update()
  {
    super.update();

    HashMap<PIMaterial, Float> tUsedMaterials = new HashMap<PIMaterial, Float>();

    for ( int iLevel = levels.size() - 1; iLevel >= 0; iLevel-- )
    {
      TreeViewLevelPIProcess tLevel = levels.get( iLevel );

      for ( int iNode = 0; iNode < tLevel.nodes.size(); iNode++ )
      {
        TreeViewNodePIProcess tNode = tLevel.nodes.get( iNode );

        tNode.expanded = false;

        if ( tUsedMaterials.containsKey( tNode.process.output.material ) )
        {
          tNode.expanded = true;
          tNode.requiredVolume = tUsedMaterials.get( tNode.process.output.material );

          for ( int iInput = 0; iInput < tNode.process.inputs.size(); iInput++ )
          {
            PIInOutput tInput = tNode.process.inputs.get( iInput );
            
            tUsedMaterials.put( tInput.material, tInput.material.volume * tInput.units * tUsedMaterials.get( tNode.process.output.material ) / ( tNode.process.output.units * tNode.process.output.material.volume ) );
          }
        }
        else if ( tNode.cScreenHitRect.contains( mouseX, mouseY ) || tNode.selected )
        {
          tNode.expanded = true;
          
          int tOutputUnits = tNode.process.output.units >= 0 ? tNode.process.output.units : 1000;
          tNode.requiredVolume = tNode.process.output.material.volume * tOutputUnits / tNode.process.cycleTime;

          for ( int iInput = 0; iInput < tNode.process.inputs.size(); iInput++ )
          {
            PIInOutput tInput = tNode.process.inputs.get( iInput );
            tUsedMaterials.put( tInput.material, tInput.material.volume * tInput.units );
          }
        }

        tNode.update();
      }
    }
  }

  void moveTo( WorldPosition aTargetPosition )
  {
    collapsedExtentsPosition.sub( position );
    collapsedExtentsPosition.add( aTargetPosition );
    
    super.moveTo( aTargetPosition );
  }

  void plot()
  {
    super.plot();

    PVector tCollapsedSize = new PVector( collapsedExtentsPosition.x, collapsedExtentsPosition.y );
    tCollapsedSize.sub( position );
    int tSpacing = 1;

    float tNodeWidth = tCollapsedSize.x / levels.size();

    float tCurrentNodeHeight = 0;
    float tCurrentNodeWidth = 0;
    float tCurrentLevelWidth = 0;
    PVector tTreeDirection = new PVector( tCollapsedSize.x / abs( tCollapsedSize.x ), tCollapsedSize.y / abs( tCollapsedSize.y ) );

    WorldPosition tCurrentNodePosition = new WorldPosition( position.x, position.y );
    for ( int iLevel = levels.size() - 1; iLevel >= 0; iLevel-- )
    {
      TreeViewLevelPIProcess tLevel = levels.get( iLevel );

      tCurrentLevelWidth = 0;

      for ( int iNode = 0; iNode < tLevel.nodes.size(); iNode++ )
      {
        TreeViewNodePIProcess tNode = tLevel.nodes.get( iNode );

        if ( tNode.expanded )
        {
          tCurrentNodeWidth = 150 * tTreeDirection.x;
          tCurrentNodeHeight = tNode.requiredVolume * piUI.magnitudeScale * tTreeDirection.y;
        }
        else
        {
          tCurrentNodeWidth = tNodeWidth;
          tCurrentNodeHeight = tCollapsedSize.y / tLevel.nodes.size();
        }

        float tRectWidth = tCurrentNodeWidth - tSpacing * tTreeDirection.x;
        float tRectHeight = tCurrentNodeHeight - tSpacing * tTreeDirection.y;

        if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_SETEXTENTS && isSelected( this ) )
        {
          tNode.positionDamping.setCurrentValue( tCurrentNodePosition );
          tNode.sizeDamping.setCurrentValue( new PVector( tRectWidth, tRectHeight ) );
        }
        else
        {
          tNode.positionDamping.update( tCurrentNodePosition );
          tNode.sizeDamping.update( new PVector( tRectWidth, tRectHeight ) );
        }

        PVector tNodeDampedPosition = tNode.positionDamping.getValue().toScreen();
        PVector tNodeDampedSize = tNode.sizeDamping.getValue();
        tNodeDampedSize.mult( uiCam.getScale() );

        Rectangle tRect = new Rectangle( floor( tNodeDampedPosition.x + ( tNodeDampedSize.x < 0 ? tNodeDampedSize.x : 0 ) ), floor( tNodeDampedPosition.y + ( tNodeDampedSize.y < 0 ? tNodeDampedSize.y : 0 ) ), ceil( abs( tNodeDampedSize.x ) ), ceil( abs( tNodeDampedSize.y ) ) );
        tNode.cScreenHitRect = tRect;

        fill( 0, 0, 1, 0.3 );
        if ( tNode.selected ) { 
          fill( 0, 0, 1, 0.7 );
        }
        noStroke();
        rect( tNodeDampedPosition.x, tNodeDampedPosition.y, tNodeDampedSize.x, tNodeDampedSize.y ); 

        if ( tNode.expanded )
        {
          fill( 0, 0, 0.2 );

          textFont( fontLabel );
          textSize( 8 * uiCam.getScale() );
          textAlign( tTreeDirection.x < 0 ? RIGHT : LEFT, tTreeDirection.y < 0 ? BOTTOM : TOP );
          text( tNode.process.output.material.name, tNodeDampedPosition.x + 3 * tTreeDirection.x * uiCam.getScale(), tNodeDampedPosition.y + 2 * tTreeDirection.y * uiCam.getScale() );

          textFont( fontValue );
          textSize( 8 * uiCam.getScale() );
          textAlign( tTreeDirection.x < 0 ? RIGHT : LEFT, tTreeDirection.y < 0 ? BOTTOM : TOP );
          text( round( tNode.requiredVolume * 100 ) / 100 + "m3", tNodeDampedPosition.x + 3 * tTreeDirection.x * uiCam.getScale(), tNodeDampedPosition.y + ( 10 + 2 ) * tTreeDirection.y * uiCam.getScale() );
        }

        tCurrentNodePosition.y += tCurrentNodeHeight;

        if ( abs( tCurrentNodeWidth ) > abs( tCurrentLevelWidth ) )
        {
          tCurrentLevelWidth = tCurrentNodeWidth;
        }
      }

      tCurrentNodePosition.x += tCurrentLevelWidth;
      tCurrentNodePosition.y = position.y;
    }
  }

  void drawDebug()
  {
    super.drawDebug();

    stroke( 0, 0, 1, 0.2 );
    strokeWeight( 1 );
    noFill();
    Rectangle tRect = calcScreenRect();
    rect( tRect.x, tRect.y, tRect.width, tRect.height );

    PIProcess tProcess = getProcessAt( new PVector( mouseX, mouseY ) );
    if ( tProcess != null )
    {
      fill( 0, 0, 1, 0.7 );
      noStroke();
      textFont( fontDebugValue );
      textAlign( LEFT, BOTTOM );
      text( tProcess.output.material.name, mouseX, mouseY -2 );
    }
  }

  boolean contains( PVector aScreenPos )
  {
    return getNodeAt( aScreenPos ) != null;
  }

  Rectangle calcScreenRect()
  {
    PVector tScreenPos = this.position.toScreen();
    PVector tScreenExtentsPos = collapsedExtentsPosition.toScreen();
    Rectangle tRect = new Rectangle( floor( min( tScreenPos.x, tScreenExtentsPos.x ) ), floor( min( tScreenPos.y, tScreenExtentsPos.y ) ), ceil( abs( tScreenExtentsPos.x - tScreenPos.x ) ), ceil( abs( tScreenExtentsPos.y - tScreenPos.y ) ) );
    return tRect;
  }

  PIProcess getProcessAt( PVector aScreenPos )
  {
    TreeViewNodePIProcess tNode = getNodeAt( aScreenPos );
    if ( tNode != null )
    {
      return tNode.process;
    }
    return null;
  }

  TreeViewNodePIProcess getNodeAt( PVector aScreenPos )
  {
    for ( int iLevel = levels.size() - 1; iLevel >= 0; iLevel-- )
    {
      TreeViewLevelPIProcess tLevel = levels.get( iLevel );

      for ( int iNode = 0; iNode < tLevel.nodes.size(); iNode++ )
      {
        TreeViewNodePIProcess tNode = tLevel.nodes.get( iNode );

        if ( tNode.cScreenHitRect.contains( aScreenPos.x, aScreenPos.y ) )
        {
          return tNode;
        }
      }
    }
    return null;
  }

  void processMouseReleased()
  {
    TreeViewNodePIProcess tHoveredNode = getNodeAt( new PVector( mouseX, mouseY ) );

    if ( tHoveredNode != null )
    {
      if ( tHoveredNode.selected )
      {
        tHoveredNode.selected = false;
      }
      else
      {
        tHoveredNode.selected = true;
      }
    }
  }
}

class TreeViewLevelPIProcess
{
  ArrayList<TreeViewNodePIProcess> nodes;

  TreeViewLevelPIProcess()
  {
    nodes = new ArrayList<TreeViewNodePIProcess>();
  }
}

class TreeViewNodePIProcess
{
  PIProcess process;

  boolean selected;
  boolean expanded;

  float requiredVolume;

  Rectangle cScreenHitRect;

  DampingHelper_WorldPosition positionDamping;
  DampingHelper_PVector sizeDamping;

  TreeViewNodePIProcess( PIProcess aProcess )
  {
    process = aProcess;
    selected = false;
    expanded = false;

    requiredVolume = 0;

    cScreenHitRect = new Rectangle( 0, 0, 0, 0 );

    positionDamping = new DampingHelper_WorldPosition( 0.5, new PVector( 0, 0 ) );
    sizeDamping = new DampingHelper_PVector( 0.5, new PVector( 0, 0 ) );
  }

  void update()
  {
    //    positionDamping.update();
    //    sizeDamping.update();
  }
}

