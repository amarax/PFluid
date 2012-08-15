
PVector mousePressedPos = null;

void keyPressed()
{
  if ( key == CODED )
  {
    switch( keyCode )
    {
    case KeyEvent.VK_HOME:
      uiCam.screenOffset = new PVector( 0, 0 );

      uiCam.screenScale = 1;
      break;
    case KeyEvent.VK_F1:
      piData.saveData( "data/PIData.xml" );
      break;
    case KeyEvent.VK_F2:
      marketData.saveData( "data/MarketData.xml" );
      break;
    case KeyEvent.VK_F3:
      saveCanvas( "data/CanvasHistory.xml" );
      break;
    case KeyEvent.VK_SHIFT:
      shiftPressed = true;
      break;
    default:
    }
  }
  else
  {
    for ( int i = 0; i < selectedEntities.size(); i++ )
    {
      selectedEntities.get( i ).processKey();
    }

    switch( key )
    {
    case ' ':
      switch( currentUIContext )
      {
      case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
        if ( selectedEntities.size() > 0 )
        {
          ArrayList<FlowNodePI> tSelectedFlows = new ArrayList<FlowNodePI>();

          for ( int iSelectedEntity = 0; iSelectedEntity < selectedEntities.size(); iSelectedEntity++ )
          {
            Entity tSelectedEntity = selectedEntities.get( iSelectedEntity );
            if ( tSelectedEntity instanceof FlowNodePI )
            {
              FlowNodePI tSelectedNode = (FlowNodePI)tSelectedEntity;
              tSelectedFlows.add( tSelectedNode );
            }
          }

          if ( tSelectedFlows.size() == 1 )
          {
            FlowPI tFlow = new FlowPI();
            tFlow.sourceNode = tSelectedFlows.get( 0 );
            uiCursor.cursorFlow = tFlow;

            currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING;
          }
          else if ( tSelectedFlows.size() > 0 )
          {
            PINodeConsolidated tConsolidatedNode = new PINodeConsolidated( tSelectedFlows.get( 0 ).getMaterialProduced( null ) );
            world.addEntity( tConsolidatedNode );
            tConsolidatedNode.position = worldPosFromScreen( new PVector( mouseX, mouseY ) );
            uiCursor.cursorNode = tConsolidatedNode;

            for ( int iSelectedEntity = 0; iSelectedEntity < selectedEntities.size(); iSelectedEntity++ )
            {
              if ( selectedEntities.get( iSelectedEntity ) instanceof PINode )
              {
                FlowNodePI tFlowNode = tSelectedFlows.get( iSelectedEntity );

                FlowPI tFlow = new FlowPI();
                tFlow.sourceNode = tFlowNode;
                tFlow.targetNode = tConsolidatedNode;

                currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_CONSOLIDATING;
              }
            }
          }
        }
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING:
        {
          world.flowManager.flows.remove( world.flowManager.flows.indexOf( uiCursor.cursorFlow ) );
          uiCursor.cursorFlow = null;
          currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
        }
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_CONSOLIDATING:
        {
          world.flowManager.removeFlowsToEntity( uiCursor.cursorNode );
          world.removeEntity( uiCursor.cursorNode );
          uiCursor.cursorNode = null;
          currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
        }
        break;
      default:
      }
      break;
    case 'D':
    case 'd':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        if ( selectedEntities.size() > 0 )
        {
          ArrayList<Entity> tNewEntities = new ArrayList<Entity>();

          HashMap<FlowNodePI, FlowNodePI> tExistingFlowNodes = new HashMap<FlowNodePI, FlowNodePI>();  // Map for old (left) to new (right) nodes

          for ( int i = 0; i < selectedEntities.size(); i++ )
          {
            if ( selectedEntities.get( i ) instanceof PINodeFactory )
            {
              PINodeFactory tNewEntity = new PINodeFactory( (PINodeFactory)( selectedEntities.get( i ) ) );
              world.addEntity( tNewEntity );
              tNewEntities.add( tNewEntity );

              tExistingFlowNodes.put( (PINodeFactory)( selectedEntities.get( i ) ), tNewEntity );
            }
            else if ( selectedEntities.get( i ) instanceof PINodeExtractor )
            {
              PINodeExtractor tNewEntity = new PINodeExtractor( (PINodeExtractor)( selectedEntities.get( i ) ) );
              world.addEntity( tNewEntity );
              tNewEntities.add( tNewEntity );

              tExistingFlowNodes.put( (PINodeExtractor)( selectedEntities.get( i ) ), tNewEntity );
            }
          }

          // Add consolidated nodes if both sides have at least one copied node
          for ( int iEntity = 0; iEntity < world.entities.size(); iEntity++ )
          {
            if ( world.entities.get( iEntity ) instanceof PINodeConsolidated )
            {
              PINodeConsolidated tConsolidatedNode = (PINodeConsolidated)( world.entities.get( iEntity ) );
              ArrayList<FlowPI> tFlows = world.flowManager.getFlowsConnectedTo( tConsolidatedNode );

              boolean tSourceNodeCopied = false;
              boolean tTargetNodeCopied = false;
              Iterator<FlowPI> iFlows = tFlows.iterator();
              while ( iFlows.hasNext () && ( !tSourceNodeCopied || !tTargetNodeCopied ) )
              {
                FlowPI tFlow = iFlows.next();
                if ( tExistingFlowNodes.containsKey( tFlow.sourceNode ) )
                {
                  tSourceNodeCopied = true;
                }                  
                if ( tExistingFlowNodes.containsKey( tFlow.targetNode ) )
                {
                  tTargetNodeCopied = true;
                }
              }

              if ( tSourceNodeCopied && tTargetNodeCopied )
              {
                PINodeConsolidated tNewEntity = new PINodeConsolidated( tConsolidatedNode );
                world.addEntity( tNewEntity );
                tNewEntities.add( tNewEntity );

                tExistingFlowNodes.put( tConsolidatedNode, tNewEntity );
              }
            }
          }

          if ( tNewEntities.size() > 0 )
          {
            // Link flows that flow between any of the old entities
            for ( int iFlow = 0; iFlow < world.flowManager.flows.size(); iFlow++ )
            {
              if ( world.flowManager.flows.get( iFlow ) instanceof FlowPI )
              {
                FlowPI tFlow = (FlowPI)( world.flowManager.flows.get( iFlow ) );

                if ( tExistingFlowNodes.containsKey( tFlow.sourceNode ) && tExistingFlowNodes.containsKey( tFlow.targetNode ) )
                {
                  FlowPI tNewFlow = new FlowPI();
                  tNewFlow.sourceNode = tExistingFlowNodes.get( tFlow.sourceNode );
                  tNewFlow.targetNode = tExistingFlowNodes.get( tFlow.targetNode );
                }
              }
            }

            // Select and move the new entities
            selectedEntities = tNewEntities;
            for ( int i = 0; i < selectedEntities.size(); i ++ )
            {
              Entity tSelectedEntity = selectedEntities.get( i );

              PVector tOffset = worldPosFromScreen( new PVector( mouseX, mouseY ) );
              tOffset.sub( tSelectedEntity.position );
              uiCursor.cursorOffsets.put( tSelectedEntity, tOffset );

              currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_MOVINGENTITY;
            }
          }
        }
      }
      break;
    case 'E':
    case 'e':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_EXTRACTOR;
      }
      break;
    case 'F':
    case 'f':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_FACTORY;
      }
      break;
    case 'G':
    case 'g':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_ADDING;
      }
      break;
    case 'M':
    case 'm':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_ADDING;
      }
      break;
    case 'T':
    case 't':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_ADDING;
      }
      break;

    case KeyEvent.VK_DELETE:
      ArrayList<Entity> tSelectedEntities = new ArrayList<Entity>( selectedEntities );
      for ( int i = 0; i < tSelectedEntities.size(); i++ )
      {
        tSelectedEntities.get( i ).removeFromWorld();  // This also causes the entity to remove itself from the list of selected entities
      }
      selectedEntities.clear();
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
      break;
    case 'W':
    case 'w':
      if ( currentUIContext == UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT )
      {
        for ( int i = 0; i < selectedEntities.size(); i ++ )
        {
          Entity tSelectedEntity = selectedEntities.get( i );

          PVector tOffset = worldPosFromScreen( new PVector( mouseX, mouseY ) );
          tOffset.sub( tSelectedEntity.position );
          uiCursor.cursorOffsets.put( tSelectedEntity, tOffset );

          currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_MOVINGENTITY;
        }
      }
      break;

    case '`':
      debugOverlay.enabled = !debugOverlay.enabled;
      break;
    default:
    }
  }
}

void keyReleased()
{
  if ( key == CODED )
  {
    switch( keyCode )
    {
    case KeyEvent.VK_SHIFT:
      shiftPressed = false;
      break;
    default:
    }
  }
}

void mousePressed()
{
  mousePressedPos = new PVector( mouseX, mouseY );

  switch( currentUIContext )
  {
  case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
    //if ( mouseButton == LEFT )
    {
      if ( hoveredEntity != null )
      {
        if ( shiftPressed )
        {
          if ( !selectedEntities.contains( hoveredEntity ) )
          {
            select( hoveredEntity );
          }
        }
        else
        {
          selectedEntities.clear();
          select( hoveredEntity );
        }
      }
    }
    break;

  case UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING:
    //if ( mouseButton == LEFT )
    {
      FlowNodePI tOldSourceNode = uiCursor.cursorFlow.sourceNode;
      if ( uiCursor.cursorFlow.sourceNode == null || uiCursor.cursorFlow.targetNode == null )
      {
        world.flowManager.flows.remove( world.flowManager.flows.indexOf( uiCursor.cursorFlow ) );

        uiCursor.cursorFlow = null;
        currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
      }
      else
      {
        FlowPI tFlow = new FlowPI();
        tFlow.sourceNode = tOldSourceNode;
        uiCursor.cursorFlow = tFlow;
      }
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_CONSOLIDATING:
    {
      FlowPI tFlow = new FlowPI();
      tFlow.sourceNode = uiCursor.cursorNode;
      uiCursor.cursorFlow = tFlow;

      selectedEntities.clear();
      select( uiCursor.cursorNode );

      uiCursor.cursorNode = null;

      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING;
    }
    break;

  case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_ADDING:
    Graph2D tGraph = new GraphPIDataMaterials( "PI Materials", worldPosFromScreen( new PVector( mouseX, mouseY ) ) );
    world.addEntity( tGraph );
    tGraph.init();

    selectedEntities.clear();
    select( tGraph );
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGEXTENTS;
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGEXTENTS:
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_ADDING:
    TreeViewPI tTreeView = new TreeViewPI( "PI Processes", worldPosFromScreen( new PVector( mouseX, mouseY ) ) );
    world.addEntity( tTreeView );
    tTreeView.init();

    selectedEntities.clear();
    select( tTreeView );
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_SETEXTENTS;
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_SETEXTENTS:
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    break;

  case UI_CONTEXT_ENUMS.UI_CONTEXT_MOVINGENTITY:
    uiCursor.cursorOffsets.clear();
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    break;

  case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_ADDING:
    MarketNode tMarketNode = new MarketNode( "Market", worldPosFromScreen( new PVector( mouseX, mouseY ) ) );
    world.addEntity( tMarketNode );
    tMarketNode.init();

    selectedEntities.clear();
    select( tMarketNode );
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_SETTINGEXTENTS;
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_SETTINGEXTENTS:
    currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    break;
  default:
  }
}

void mouseReleased()
{
  switch( currentUIContext )
  {

  case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
    //if ( mouseButton == LEFT )
    {
      if ( hoveredEntity == null )
      {
        selectedEntities.clear();
      }
      for ( int i = 0; i < selectedEntities.size(); i++ )
      {
        selectedEntities.get( i ).processMouseReleased();
      }
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_PANNING:
    //if ( mouseButton == LEFT )
    {
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_DRAGGINGENTITY:
    //if ( mouseButton == LEFT )
    {
      for ( int i = 0; i < selectedEntities.size(); i++ )
      {
        selectedEntities.get( i ).processMouseDragStopped();
      }
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    }
    break;

  case UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_EXTRACTOR:
    //if ( mouseButton == LEFT )
    {
      PINodeExtractor tNewEntity = new PINodeExtractor();
      world.addEntity( tNewEntity );

      tNewEntity.position = worldPosFromScreen( mousePressedPos );

      selectedEntities.clear();
      select( tNewEntity );
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_EXTRACTOR_YIELD;
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_EXTRACTOR_YIELD:
    //if ( mouseButton == LEFT )
    {

      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    }
    break;

  case UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_FACTORY:
    //if ( mouseButton == LEFT )
    {
      PINodeFactory tNewEntity = new PINodeFactory();
      world.addEntity( tNewEntity );

      tNewEntity.position = worldPosFromScreen( mousePressedPos );

      selectedEntities.clear();
      select( tNewEntity );
      //currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_FACTORY_TIER;
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_FACTORY_TIER:
    //if ( mouseButton == LEFT )
    {
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_START:
  case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_END:
  case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SHIFTINGVALUES:
    {
      if ( selectedEntities.size() == 1 )
      {
        if ( selectedEntities.get( 0 ) instanceof Graph2D )
        {
          selectedEntities.get( 0 ).processMouseReleased();
        }
      }
    }
    break;
  default:
  }

  mousePressedPos = null;
}

void mouseDragged()
{
  switch( currentUIContext )
  {
  case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
    if ( hoveredEntity != null )
    {
      if ( selectedEntities.contains( hoveredEntity ) )
      {
        // Just drag selected entities
      }
      else
      {
        selectedEntities.clear();
        select( hoveredEntity );
      }

      for ( int i = 0; i < selectedEntities.size(); i++ )
      {
        selectedEntities.get( i ).processMouseDragStarted();
      }

      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DRAGGINGENTITY;
    }
    else
    {
      currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_PANNING;
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_PANNING:
    //if ( mouseButton == LEFT )
    {
      uiCam.screenOffset.x += mouseX - pmouseX;
      uiCam.screenOffset.y += mouseY - pmouseY;
      uiCam.screenOffsetDamping.xDamper.currentValue += mouseX - pmouseX;
      uiCam.screenOffsetDamping.yDamper.currentValue += mouseY - pmouseY;
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_DRAGGINGENTITY:
    break;
  default:
  }
}

void mouseMoved()
{
  switch( currentUIContext )
  {
  case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
    if ( hoveredEntity instanceof TreeViewPI )
    {
      TreeViewPI tProcessesTree = (TreeViewPI)hoveredEntity;
      PIProcess tProcess = tProcessesTree.getProcessAt( new PVector( mouseX, mouseY ) );

      if ( tProcess != null )
      {

        for ( int iSelectedEntities = 0; iSelectedEntities < selectedEntities.size(); iSelectedEntities++ )
        {
          Entity tSelectedEntity = selectedEntities.get( iSelectedEntities );

          if ( tSelectedEntity instanceof PINode )
          {
            PINode tPINode = (PINode)tSelectedEntity;

            if ( tSelectedEntity instanceof PINodeExtractor && tProcess.tier == 0 )
            {
              tPINode.process = tProcess;
            }
            else if ( tSelectedEntity instanceof PINodeFactory && tProcess.tier >= 1 )
            {
              tPINode.process = tProcess;
            }
          }
        }
      }
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_EXTRACTOR_YIELD:
    if ( selectedEntities.size() == 1 )
    { 
      if ( selectedEntities.get( 0 ) instanceof PINodeExtractor )
      {
        PINodeExtractor tEntity = (PINodeExtractor)( selectedEntities.get( 0 ) );
        tEntity.magnitude = max( worldPosFromScreen( new PVector( mouseX, mouseY ) ).y - tEntity.position.y, 0 ) / piUI.magnitudeScale;
      }
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING:
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGEXTENTS:
    if ( selectedEntities.size() == 1 )
    { 
      if ( selectedEntities.get( 0 ) instanceof Graph )
      {
        Graph tEntity = (Graph)( selectedEntities.get( 0 ) );
        tEntity.extentsPosition = worldPosFromScreen( new PVector( mouseX, mouseY ) );
      }
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_SETEXTENTS:
    if ( selectedEntities.size() == 1 )
    { 
      if ( selectedEntities.get( 0 ) instanceof TreeViewPI )
      {
        TreeViewPI tEntity = (TreeViewPI)( selectedEntities.get( 0 ) );
        tEntity.collapsedExtentsPosition = worldPosFromScreen( new PVector( mouseX, mouseY ) );
      }
    }
    break;
  case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_SETTINGEXTENTS:
    if ( selectedEntities.size() == 1 )
    { 
      if ( selectedEntities.get( 0 ) instanceof MarketNode )
      {
        MarketNode tEntity = (MarketNode)( selectedEntities.get( 0 ) );
        tEntity.extentsPosition = worldPosFromScreen( new PVector( mouseX, mouseY ) );

        float tISKRange = marketUI.iskMagnitudeScale * abs( tEntity.extentsPosition.x - tEntity.position.x );
        tEntity.hAxis.startValue = - tISKRange * 2 / 3;
        tEntity.hAxis.endValue = tISKRange / 3;
      }
    }
    break;
  default:
  }
}

void mouseWheel(int delta) 
{
  //  if( hoveredEntity instanceof Graph2D )
  //  {
  //    ( (Graph2D)hoveredEntity ).processMouseWheel( delta );
  //  }
  //  else
  {
    PVector tMousePos = new PVector( mouseX, mouseY );

    PVector tVector = new PVector( tMousePos.x, tMousePos.y );
    tVector.sub( uiCam.screenOffset );
    //tVector.normalize();
    tVector.mult( delta * 0.1 );
    uiCam.screenOffset.add( tVector );

    //  screenOffset.x = mouseX - ( mouseX - screenOffset.x ) * tScaleMultipler;
    //  screenOffset.y = mouseY - ( mouseY - screenOffset.y ) * tScaleMultipler;

    uiCam.screenScale *= 1 - delta * 0.1;
  }
}

