class FlowManagerPI extends FlowManager
{
  ArrayList<FlowTracker> sortedTrackers;  // Here so we can see the debug if necessary

  FlowManagerPI()
  {
    super();

    sortedTrackers = new ArrayList<FlowTracker>();
  }

  void update()
  {
    sortedTrackers.clear();

    ArrayList<FlowTrackerOutput> tFlowTrackerOuts = new ArrayList<FlowTrackerOutput>();
    ArrayList<FlowTrackerInput> tFlowTrackerIns = new ArrayList<FlowTrackerInput>();

    HashMap<MarketNode, HashMap<PINode, Integer>> tMarketOutputTracker = new HashMap<MarketNode, HashMap<PINode, Integer>>();

    for ( int iFlow = 0; iFlow < flows.size(); iFlow++ )
    {
      if ( flows.get( iFlow ) instanceof FlowPI )
      {
        FlowPI tFlow = (FlowPI)flows.get( iFlow );

        tFlow.cMaterial = null;
        tFlow.setCachedMagnitudes( 0 );
        tFlow.cSourceMagnitudeOffset = 0;
        tFlow.cTargetMagnitudeOffset = 0;

        PIMaterial tSourceMaterial = null;
        int tUnitsProduced = 0;
        if ( tFlow.sourceNode instanceof FlowNodePI )
        {
          tSourceMaterial = tFlow.sourceNode.getMaterialProduced( tFlow );
          tUnitsProduced = tFlow.sourceNode.getUnitsProduced();
        }

        int tUnitsRequired = 0;
        if ( tFlow.targetNode instanceof FlowNodePI )
        {
          // Market nodes will produce whatever material is needed at the target
          if ( tFlow.sourceNode instanceof MarketNode )
          {
            MarketNode tMarketNode = (MarketNode)( tFlow.sourceNode );
            if ( tFlow.targetNode instanceof PINode )
            {
              PINode tTargetPINode = (PINode)( tFlow.targetNode );
              if ( tTargetPINode.process != null )
              {
                int tInputIndex = -1;
                if ( tMarketOutputTracker.containsKey( tMarketNode ) )
                {
                  if ( tMarketOutputTracker.get( tMarketNode ).containsKey( tTargetPINode ) )
                  {
                    tInputIndex = tMarketOutputTracker.get( tMarketNode ).get( tTargetPINode ) + 1;
                    tMarketOutputTracker.get( tMarketNode ).remove( tTargetPINode );
                    tMarketOutputTracker.get( tMarketNode ).put( tTargetPINode, new Integer( tInputIndex ) );
                  }
                  else
                  {
                    tInputIndex = 0;
                    tMarketOutputTracker.get( tMarketNode ).put( tTargetPINode, new Integer( 0 ) );
                  }
                }
                else
                {
                  tInputIndex = 0;
                  HashMap<PINode, Integer> tNodeEntry = new HashMap<PINode, Integer>();
                  tNodeEntry.put( tTargetPINode, new Integer( 0 ) );
                  tMarketOutputTracker.put( tMarketNode, tNodeEntry );
                }

                if ( tInputIndex < tTargetPINode.process.inputs.size() )
                {
                  tSourceMaterial = tTargetPINode.process.inputs.get( tInputIndex ).material;
                }
                else
                {
                  tSourceMaterial = null;
                }
              }
            }
          }

          tUnitsRequired = tFlow.targetNode.getUnitsRequired( tSourceMaterial );
        }

        FlowTrackerInput tFlowTarget = null;
        Iterator<FlowTrackerInput> iFlowInputs = tFlowTrackerIns.iterator();
        while ( iFlowInputs.hasNext () && tFlowTarget == null )
        {
          FlowTrackerInput tFlowInput = iFlowInputs.next();
          if ( tFlowInput.node == tFlow.targetNode && tFlowInput.material == tSourceMaterial )
          {
            tFlowTarget = tFlowInput;
          }
        }
        if ( tFlowTarget == null )
        {
          tFlowTarget = new FlowTrackerInput( tFlow.targetNode, tSourceMaterial, tUnitsRequired );
          tFlowTrackerIns.add( tFlowTarget );

          if ( tUnitsRequired == -1 )
          {
            tFlowTarget.unitsStillRequired = -1;

            if ( tFlow.targetNode instanceof PINodeConsolidated )
            {
              PINodeConsolidated tTargetConsolidatedNode = (PINodeConsolidated)( tFlow.targetNode );

              if ( tSourceMaterial != tTargetConsolidatedNode.material )
              {
                tFlowTarget.unitsStillRequired = 0;
              }
            }
          }
        }

        FlowTrackerOutput tFlowSource = null;
        Iterator<FlowTrackerOutput> iFlowOutputs = tFlowTrackerOuts.iterator();
        while ( iFlowOutputs.hasNext () && tFlowSource == null )
        {
          FlowTrackerOutput tFlowOutput = iFlowOutputs.next();
          if ( tFlowOutput.node == tFlow.sourceNode && tFlowOutput.material == tSourceMaterial )
          {
            tFlowSource = tFlowOutput;
          }
        }

        if ( tFlowSource == null )
        {
          tFlowSource = new FlowTrackerOutput( tFlow.sourceNode, tSourceMaterial, tUnitsProduced );
          tFlowTrackerOuts.add( tFlowSource );
        }

        // Add the source output sorted according to position
        boolean tInserted = false;
        int iSourceIndex = 0;
        while ( iSourceIndex < tFlowTarget.sourceOutputs.size () && !tInserted )
        {
          FlowTrackerOutput tTracker = tFlowTarget.sourceOutputs.get( iSourceIndex );

          float tSourcePosition = tFlowSource.node == null ? mouseY : tFlowSource.node.getWorldPosition().y;
          float tTrackerPosition = tTracker.node == null? mouseY : tTracker.node.getWorldPosition().y;

          if ( tTrackerPosition > tSourcePosition )
          {
            tFlowTarget.sourceOutputs.add( iSourceIndex, tFlowSource );
            tFlowTarget.linkedFlows.add( iSourceIndex, tFlow );
            tInserted = true;
          }

          iSourceIndex++;
        }
        if ( !tInserted )
        {
          tFlowTarget.sourceOutputs.add( tFlowSource );
          tFlowTarget.linkedFlows.add( tFlow );
        }

        tFlow.cMaterial = tSourceMaterial;
      }
    }

    // Link outputs to inputs
    for ( int iOut = 0; iOut < tFlowTrackerOuts.size(); iOut++ )
    {
      FlowTrackerOutput tFlowOutput = tFlowTrackerOuts.get( iOut );

      // Market nodes are special, their inputs are not linked to their outputs
      if ( !( tFlowOutput.node instanceof MarketNode ) )
      {
        for ( int iIn = 0; iIn < tFlowTrackerIns.size(); iIn++ )
        {
          FlowTrackerInput tFlowInput = tFlowTrackerIns.get( iIn );

          if ( tFlowInput.node == tFlowOutput.node )
          {
            tFlowOutput.sourceInputs.add( tFlowInput );
          }
        }
      }
    }

    // Sort trackers by position first
    ArrayList<FlowTracker> tPositionSortedTrackers = new ArrayList<FlowTracker>();
    for ( int iOut = 0; iOut < tFlowTrackerOuts.size(); iOut++ )
    {
      FlowTrackerOutput tFlowOutput = tFlowTrackerOuts.get( iOut );

      boolean tInserted = false;
      int tIndex = 0;
      Iterator<FlowTracker> iPositionSortedTrackers = tPositionSortedTrackers.iterator();
      while ( iPositionSortedTrackers.hasNext () && !tInserted )
      {
        FlowTracker tCurrentTracker = iPositionSortedTrackers.next();

        float tCurrentTrackerPos = tCurrentTracker.node == null ? mouseY : tCurrentTracker.node.getWorldPosition().y;
        float tInsertedTrackerPos = tFlowOutput.node == null ? mouseY : tFlowOutput.node.getWorldPosition().y;
        if ( tCurrentTrackerPos > tInsertedTrackerPos )
        {
          tPositionSortedTrackers.add( tIndex, tFlowOutput );
          tInserted = true;
        }

        tIndex++;
      }

      if ( !tInserted )
      {
        tPositionSortedTrackers.add( tFlowOutput );
      }
    }
    for ( int iIn = 0; iIn < tFlowTrackerIns.size(); iIn++ )
    {
      FlowTrackerInput tFlowInput = tFlowTrackerIns.get( iIn );

      boolean tInserted = false;
      int tIndex = 0;
      Iterator<FlowTracker> iPositionSortedTrackers = tPositionSortedTrackers.iterator();
      while ( iPositionSortedTrackers.hasNext () && !tInserted )
      {
        FlowTracker tCurrentTracker = iPositionSortedTrackers.next();

        float tCurrentTrackerPos = tCurrentTracker.node == null ? mouseY : tCurrentTracker.node.getWorldPosition().y;
        float tInsertedTrackerPos = tFlowInput.node == null ? mouseY : tFlowInput.node.getWorldPosition().y;
        if ( tCurrentTrackerPos > tInsertedTrackerPos )
        {
          tPositionSortedTrackers.add( tIndex, tFlowInput );
          tInserted = true;
        }

        tIndex++;
      }

      if ( !tInserted )
      {
        tPositionSortedTrackers.add( tFlowInput );
      }
    }    

    // Sort trackers by hierarchy next, so we get list sorted by hierarchy then by position
    int tHierarchyLevel = 0;
    int tPositionSortedTrackersPreviousSize = tPositionSortedTrackers.size();
    do 
    {
      tPositionSortedTrackersPreviousSize = tPositionSortedTrackers.size();

      int iTracker = 0;
      while ( iTracker < tPositionSortedTrackers.size () )
      {
        FlowTracker tTracker = tPositionSortedTrackers.get( iTracker );

        if ( tTracker.node != null )
        {

          ArrayList<FlowTracker> tOutstandingSources = null;
          if ( tHierarchyLevel % 2 == 0 && tTracker instanceof FlowTrackerOutput )
          {
            // Only add outputs
            FlowTrackerOutput tCurrentTracker = (FlowTrackerOutput)tTracker;
            tOutstandingSources = new ArrayList<FlowTracker>( tCurrentTracker.sourceInputs );
          }
          else if ( tHierarchyLevel % 2 == 1 && tTracker instanceof FlowTrackerInput )
          {
            // Only add inputs
            FlowTrackerInput tCurrentTracker = (FlowTrackerInput)tTracker;
            tOutstandingSources = new ArrayList<FlowTracker>( tCurrentTracker.sourceOutputs );
          }

          if ( tOutstandingSources != null )
          {
            int iSortedTrackers = sortedTrackers.size() - 1;
            while ( iSortedTrackers >= 0 && tOutstandingSources.size () > 0 )
            {
              FlowTracker tSortedTracker = sortedTrackers.get( iSortedTrackers );

              if ( ( tTracker instanceof FlowTrackerOutput && tSortedTracker instanceof FlowTrackerInput ) || ( tTracker instanceof FlowTrackerInput && tSortedTracker instanceof FlowTrackerOutput ) )
              {
                boolean tSourceFound = false;
                Iterator<FlowTracker> iSourceTrackers = tOutstandingSources.iterator();
                while ( iSourceTrackers.hasNext () && !tSourceFound )
                {
                  FlowTracker tSourceTracker = iSourceTrackers.next();

                  if ( tSourceTracker == tSortedTracker )
                  {
                    tOutstandingSources.remove( tSourceTracker );
                    tSourceFound = true;
                  }
                }
              }

              iSortedTrackers--;
            }

            if ( tOutstandingSources.size() == 0 )
            {
              tTracker.cHierarchy = tHierarchyLevel;

              sortedTrackers.add( tTracker );
              tPositionSortedTrackers.remove( iTracker );
              iTracker--;
            }
          }
        }

        iTracker++;
      }

      tHierarchyLevel++;
    }
    while ( tPositionSortedTrackers.size () != tPositionSortedTrackersPreviousSize );

    // Just add remaining trackers, since they are never fulfilled
    for ( int iTracker = 0; iTracker < tPositionSortedTrackers.size(); iTracker++ )
    {
      FlowTracker tTracker = tPositionSortedTrackers.get( iTracker );
      sortedTrackers.add( tTracker );
      tTracker.cHierarchy = -1;
    }

    // Calculate produced and required amounts for unlimited nodes
    for ( int iTracker = 0; iTracker < sortedTrackers.size(); iTracker++ )
    {
      FlowTracker tTracker = sortedTrackers.get( iTracker );

      if ( tTracker instanceof FlowTrackerOutput )
      {
        FlowTrackerOutput tOutputTracker = (FlowTrackerOutput)tTracker;

        if ( tOutputTracker.unitsProduced == -1 )
        {
          if ( tOutputTracker.node instanceof PINodeConsolidated )
          {
            // Set production to be the same as what was put in
            tOutputTracker.unitsProduced = 0;
            for ( int iSource = 0; iSource < tOutputTracker.sourceInputs.size(); iSource++ )
            {
              FlowTrackerInput tSource = tOutputTracker.sourceInputs.get( iSource );

              float tUnitsStillRequired = 0;
              if ( tSource.unitsStillRequired != -1 )
              {
                tUnitsStillRequired = tSource.unitsStillRequired;
              }

              tOutputTracker.unitsProduced += tUnitsStillRequired;
            }
          }
          else
          {
            // Set production to be whatever is requested when calculating flows
          }

          tOutputTracker.unitsUnused = tOutputTracker.unitsProduced;
        }
      }
      else if ( tTracker instanceof FlowTrackerInput )
      {
        FlowTrackerInput tInputTracker = (FlowTrackerInput)tTracker;

        if ( tInputTracker.unitsStillRequired == -1 )
        {
          tInputTracker.unitsRequired = 0;
          for ( int iSource = 0; iSource < tInputTracker.sourceOutputs.size(); iSource++ )
          {
            FlowTrackerOutput tSource = tInputTracker.sourceOutputs.get( iSource );

            if ( tSource.node != null && tInputTracker.node != null )
            {
              // Only set units required if source is not unlimited; 
              // An unlimited source linked to an unlimited target should never happen
              if ( tSource.unitsUnused != -1 )
              {
                tInputTracker.unitsRequired += tSource.unitsUnused;
              }
            }
          }

          tInputTracker.unitsStillRequired = tInputTracker.unitsRequired;
        }
      }
    }

    // Actually calculate flows now
    for ( int iTracker = 0; iTracker < sortedTrackers.size(); iTracker++ )
    {
      FlowTracker tTracker = sortedTrackers.get( iTracker );

      tTracker.update();
    }

    // Go through all consolidated flow nodes and set their magnitude
    for ( int iTracker = sortedTrackers.size() - 1; iTracker >= 0; iTracker-- )
    {
      FlowTracker tTracker = sortedTrackers.get( iTracker );

      if ( tTracker.node != null )
      {
        if ( tTracker.node instanceof PINodeConsolidated && tTracker.material != null )
        {
          PINodeConsolidated tConsolidatedNode = (PINodeConsolidated)( tTracker.node );
          PIMaterial tMaterial = tConsolidatedNode.material;

          if ( tTracker instanceof FlowTrackerInput )
          {
            FlowTrackerInput tInputTracker = (FlowTrackerInput)tTracker;

            if ( tInputTracker.material == tMaterial )
            {
              tConsolidatedNode.magnitude = ( tInputTracker.unitsRequired - tInputTracker.unitsStillRequired ) * tMaterial.volume;
            }
          }
        }
      }
    }

    // Reset current balances for all market nodes
    for ( int iEntity = 0; iEntity < world.entities.size(); iEntity ++ )
    {
      if ( world.entities.get( iEntity ) instanceof MarketNode )
      {
        MarketNode tMarketNode = (MarketNode)( world.entities.get( iEntity ) );
        tMarketNode.currentBalance = 0;
        tMarketNode.largestNegativeBalance = 0;
      }
    }

    // Go through all market node flows and get them to update their offsets accordingly
    // First go through all trackers flowing out from market (purchases/costs)
    for ( int iFlow = 0; iFlow < flows.size(); iFlow++ )
    {
      if ( flows.get( iFlow ) instanceof FlowPI )
      {
        FlowPI tFlow = (FlowPI)flows.get( iFlow );

        if ( tFlow.sourceNode instanceof MarketNode && tFlow.targetNode != null )
        {
          MarketNode tMarketNode = (MarketNode)( tFlow.sourceNode );

          tFlow.cMagnitudeIn = 0;
          PIMaterial tMaterial = tFlow.cMaterial;

          MarketItemData tMarketData = marketData.getMarketDataFor( tMaterial );
          if ( tMarketData != null )
          {
            int tBoughtUnits = floor( tFlow.cMagnitudeOut / ( tMaterial.volume * piUI.magnitudeScale ) );

            float tTransactionAmount = tBoughtUnits * -tMarketData.priceLowestSell;
            tFlow.cMagnitudeIn = tMarketNode.calcMagnitude( tTransactionAmount );
            tFlow.cSourceMagnitudeOffset = tMarketNode.calcMagnitude( tMarketNode.currentBalance );

            tMarketNode.currentBalance += tTransactionAmount;
            tMarketNode.largestNegativeBalance = min( tMarketNode.currentBalance, tMarketNode.largestNegativeBalance );
          }
        }
      }
    }
    // Next, go through all nodes flowing into market (sales)
    for ( int iFlow = 0; iFlow < flows.size(); iFlow++ )
    {
      if ( flows.get( iFlow ) instanceof FlowPI )
      {
        FlowPI tFlow = (FlowPI)flows.get( iFlow );

        if ( tFlow.targetNode instanceof MarketNode && tFlow.sourceNode != null )
        {
          MarketNode tMarketNode = (MarketNode)( tFlow.targetNode );
          PIMaterial tMaterial = tFlow.sourceNode.getMaterialProduced( tFlow );

          tFlow.cMagnitudeOut = 0;

          MarketItemData tMarketData = marketData.getMarketDataFor( tMaterial );
          if ( tMarketData != null )
          {
            int tSoldUnits = floor( tFlow.cMagnitudeIn / ( tMaterial.volume * piUI.magnitudeScale ) );

            float tTransactionAmount = round( tSoldUnits * tMarketData.priceHighestBuy * ( 1 - currentCharacter.taxRate ) * 100 ) / 100;
            tFlow.cMagnitudeOut = tMarketNode.calcMagnitude( tTransactionAmount );
            tFlow.cTargetMagnitudeOffset = tMarketNode.calcMagnitude( tMarketNode.currentBalance );

            tMarketNode.currentBalance += tTransactionAmount;
          }
        }
      }
    }

    super.update();
  }

  void plot()
  {
    super.plot();
  }

  void drawDebug()
  {
    super.drawDebug();

    for ( int iTracker = 0; iTracker < sortedTrackers.size(); iTracker++ )
    {
      FlowTracker tTracker = sortedTrackers.get( iTracker );

      PVector tTrackerScreenPos = new PVector( mouseX, mouseY );
      if ( tTracker.node != null )
      {
        tTrackerScreenPos = tTracker.node.getWorldPosition().toScreen();
      }

      int tIconRadius = 5;
      PVector tIconPosition = new PVector( ( iTracker + 1 ) * ( float( width ) / ( sortedTrackers.size() + 1 ) ), 40 + 20 * tTracker.cHierarchy );
      noFill();
      stroke( 0, 0, 1, 0.2 );
      line( tIconPosition.x, tIconPosition.y, tIconPosition.x, 199 );
      line( tIconPosition.x, 200, tTrackerScreenPos.x, tTrackerScreenPos.y );

      Rectangle tRect = new Rectangle( floor( tIconPosition.x - tIconRadius ), floor( tIconPosition.y - tIconRadius ), tIconRadius * 2, tIconRadius * 2 );
      if ( tTracker instanceof FlowTrackerOutput )
      {
        rect( tIconPosition.x - tIconRadius, tIconPosition.y - tIconRadius, tIconRadius * 2, tIconRadius * 2 );

        if ( tRect.contains( mouseX, mouseY ) )
        {
          for ( int iSource = 0; iSource < ( (FlowTrackerOutput)tTracker ).sourceInputs.size(); iSource++ )
          {
            FlowTracker tSourceTracker = ( (FlowTrackerOutput)tTracker ).sourceInputs.get( iSource );
            PVector tSourceTrackerPosition = tSourceTracker.node.getWorldPosition().toScreen();

            line( tIconPosition.x, tIconPosition.y, tSourceTrackerPosition.x, tSourceTrackerPosition.y );
          }

          fill( 0, 0, 1, 0.3 );
          textFont( fontDebugValue );
          textAlign( LEFT, TOP );
          text( tTracker.material == null ? "NULL" : tTracker.material.name, tIconPosition.x, tIconPosition.y + 10 );
        }
      }
      else if (  tTracker instanceof FlowTrackerInput )
      {
        ellipseMode( CORNER );
        ellipse( tIconPosition.x - tIconRadius, tIconPosition.y - tIconRadius, tIconRadius * 2, tIconRadius * 2 );

        if ( tRect.contains( mouseX, mouseY ) )
        {
          for ( int iSource = 0; iSource < ( (FlowTrackerInput)tTracker ).sourceOutputs.size(); iSource++ )
          {
            FlowTracker tSourceTracker = ( (FlowTrackerInput)tTracker ).sourceOutputs.get( iSource );
            PVector tSourceTrackerPosition = tSourceTracker.node.getWorldPosition().toScreen();

            line( tIconPosition.x, tIconPosition.y, tSourceTrackerPosition.x, tSourceTrackerPosition.y );
          }

          fill( 0, 0, 1, 0.3 );
          textFont( fontDebugValue );
          textAlign( LEFT, TOP );
          text( tTracker.material == null ? "NULL" : tTracker.material.name, tIconPosition.x + tIconRadius + 2, tIconPosition.y );
        }
      }
    }
  }

  ArrayList<FlowPI> getFlowsConnectedTo( FlowNodePI aFlowNode )
  {
    ArrayList<FlowPI> tConnectedFlows = new ArrayList<FlowPI>();
    for ( int iFlow = 0; iFlow < flows.size(); iFlow++ )
    {
      if ( flows.get( iFlow ) instanceof FlowPI )
      {
        FlowPI tFlow = (FlowPI)flows.get( iFlow );

        if ( tFlow.sourceNode == aFlowNode || tFlow.targetNode == aFlowNode )
        {
          tConnectedFlows.add( tFlow );
        }
      }
    }

    return tConnectedFlows;
  }

  void removeFlowsToEntity( FlowNodePI aFlowNode )
  {
    ArrayList<FlowPI> tFlowsToRemove = getFlowsConnectedTo( aFlowNode );

    for ( int iFlow = 0; iFlow < tFlowsToRemove.size(); iFlow++ )
    {
      flows.remove( tFlowsToRemove.get( iFlow ) );
    }
  }

  ArrayList<FlowTrackerInput> getInputTrackersFor( FlowNodePI aNode )
  {
    ArrayList<FlowTrackerInput> tTrackersFound = new ArrayList<FlowTrackerInput>();
    for ( int iTracker = 0; iTracker < sortedTrackers.size(); iTracker++ )
    {
      FlowTracker tTracker = sortedTrackers.get( iTracker );

      if ( tTracker.node == aNode && tTracker instanceof FlowTrackerInput )
      {
        tTrackersFound.add( (FlowTrackerInput)tTracker );
      }
    }
    return tTrackersFound;
  }

  ArrayList<FlowTrackerOutput> getOutputTrackersFor( FlowNodePI aNode )
  {
    ArrayList<FlowTrackerOutput> tTrackersFound = new ArrayList<FlowTrackerOutput>();
    for ( int iTracker = 0; iTracker < sortedTrackers.size(); iTracker++ )
    {
      FlowTracker tTracker = sortedTrackers.get( iTracker );

      if ( tTracker.node == aNode && tTracker instanceof FlowTrackerOutput )
      {
        tTrackersFound.add( (FlowTrackerOutput)tTracker );
      }
    }
    return tTrackersFound;
  }
}

class FlowTracker
{
  final FlowNodePI node;
  final PIMaterial material;

  float capacity;

  int cHierarchy;

  FlowTracker( FlowNodePI aNode, PIMaterial aMaterial )
  {
    node = aNode;
    material = aMaterial;

    capacity = 0;

    cHierarchy = 0;
  }

  void update()
  {
  }
}

class FlowTrackerOutput extends FlowTracker
{
  ArrayList<FlowTrackerInput> sourceInputs;
  float unitsProduced;
  float unitsUnused;

  FlowTrackerOutput( FlowNodePI aNode, PIMaterial aMaterial, int aUnitsProduced )
  {
    super( aNode, aMaterial );
    unitsProduced = aUnitsProduced;
    unitsUnused = aUnitsProduced;

    sourceInputs = new ArrayList<FlowTrackerInput>();
  }

  void update()
  {
    capacity = 1;
    for ( int iSource = 0; iSource < sourceInputs.size(); iSource++ )
    {
      FlowTrackerInput tSource = sourceInputs.get( iSource );

      capacity = min( tSource.capacity, capacity );
    }

    unitsUnused = capacity * unitsProduced;
  }
}

class FlowTrackerInput extends FlowTracker
{
  ArrayList<FlowTrackerOutput> sourceOutputs; 
  ArrayList<FlowPI> linkedFlows;
  int unitsRequired;
  float unitsStillRequired;

  FlowTrackerInput( FlowNodePI aNode, PIMaterial aMaterial, int aUnitsRequired )
  {
    super( aNode, aMaterial );
    unitsRequired = aUnitsRequired;
    unitsStillRequired = aUnitsRequired;

    sourceOutputs = new ArrayList<FlowTrackerOutput>();
    linkedFlows = new ArrayList<FlowPI>();
  }

  void update()
  {
    for ( int iSource = 0; iSource < sourceOutputs.size(); iSource++ )
    {
      FlowTrackerOutput tSource = sourceOutputs.get( iSource );

      float tUnitsTransferred = 0;

      float tUnitsUnused = 0;
      float tUnitsStillRequired = 0;
      if ( tSource.node != null )
      {
        //if ( tSource.node.process != null )
        {
          tUnitsUnused = tSource.unitsUnused;
        }
      }
      if ( node != null )
      {
        //if ( tInputTracker.node.process != null )
        {
          tUnitsStillRequired = unitsStillRequired;
        }
      }

      if ( tSource.node != null && node != null )
      {
        if ( tUnitsUnused >= 0 )
        {
          tUnitsTransferred = min( tUnitsUnused, tUnitsStillRequired );
        }
        else
        {
          // Unlimited node, pull as much as still required
          tUnitsTransferred  = tUnitsStillRequired;
        }
      }
      else
      {
        tUnitsTransferred = tUnitsUnused;
      }

      if ( tSource.material != null )
      {
        linkedFlows.get( iSource ).setCachedMagnitudes( tUnitsTransferred * tSource.material.volume * piUI.magnitudeScale );
        linkedFlows.get( iSource ).cSourceMagnitudeOffset = ( tSource.unitsProduced * tSource.capacity - tUnitsUnused ) * tSource.material.volume * piUI.magnitudeScale;
        linkedFlows.get( iSource ).cTargetMagnitudeOffset = ( unitsRequired - tUnitsStillRequired ) * tSource.material.volume * piUI.magnitudeScale;
      }

      if ( tSource.node != null && node != null )
      {
        tSource.unitsUnused -= tUnitsTransferred;

        unitsStillRequired -= tUnitsTransferred;
      }
    }

    if ( unitsStillRequired >= 0 )
    {
      capacity = 1 - unitsStillRequired / unitsRequired;
    }
    else
    {
      capacity = 1;
    }
  }
}



class FlowPI extends Flow
{
  FlowNodePI sourceNode, targetNode;

  // Cached values
  PIMaterial cMaterial;
  float cMagnitudeIn, cMagnitudeOut;
  float cSourceMagnitudeOffset, cTargetMagnitudeOffset;

  DampingHelper_Float magnitudeInDampener, magnitudeOutDampener;
  DampingHelper_Float sourceMagnitudeOffsetDampener, targetMagnitudeOffsetDampener;

  int dTime = 0;

  FlowPI()
  {
    cMaterial = null;

    cMagnitudeIn = 0;
    cMagnitudeOut = 0;

    magnitudeInDampener = new DampingHelper_Float( 0.1, 1 );
    magnitudeOutDampener = new DampingHelper_Float( 0.1, 1 );
    sourceMagnitudeOffsetDampener = new DampingHelper_Float( 0.2, 0 );
    targetMagnitudeOffsetDampener = new DampingHelper_Float( 0.2, 0 );
  }

  void setCachedMagnitudes( float aMagnitude )
  {
    cMagnitudeIn = aMagnitude;
    cMagnitudeOut = aMagnitude;
  }

  void update()
  {
    dTime++;
  }

  void plot()
  {
    magnitudeInDampener.update( cMagnitudeIn );
    magnitudeOutDampener.update( cMagnitudeOut );
    sourceMagnitudeOffsetDampener.update( cSourceMagnitudeOffset );
    targetMagnitudeOffsetDampener.update( cTargetMagnitudeOffset );

    ArrayList<FlowVertex> tFlowVertices = new ArrayList<FlowVertex>();

    // By default, the FlowVertices are assumed to be in the order of source, target, target magnitude, source magnitude
    tFlowVertices.add( new FlowVertex( new PVector( mouseX, mouseY ), 0, 1 ) );
    tFlowVertices.add( new FlowVertex( new PVector( mouseX, mouseY ), PI, 1 ) );
    tFlowVertices.add( new FlowVertex( new PVector( mouseX, mouseY ), PI, 1 ) );
    tFlowVertices.add( new FlowVertex( new PVector( mouseX, mouseY ), 0, 1 ) );

    float tSourceMagnitudeAngle = HALF_PI;
    float tTargetMagnitudeAngle = HALF_PI;
    if ( sourceNode != null )
    {
      FlowPoint tSourceOutputPoint = sourceNode.getOutputPoint();
      tSourceMagnitudeAngle = tSourceOutputPoint.flowOrientation + tSourceOutputPoint.magnitudeOrientationOffset;

      tFlowVertices.get( 0 ).screenPosition = PVectorMath.vectorFromAngleMagnitude( tSourceMagnitudeAngle, sourceMagnitudeOffsetDampener.getValue() * uiCam.getScale() );
      tFlowVertices.get( 0 ).screenPosition.add( tSourceOutputPoint.position.toScreen() );
      tFlowVertices.get( 0 ).orientation = tSourceOutputPoint.flowOrientation;
    }
    if ( targetNode != null )
    {
      FlowPoint tTargetInputPoint = targetNode.getInputPoint( cMaterial );
      tTargetMagnitudeAngle = tTargetInputPoint.flowOrientation + tTargetInputPoint.magnitudeOrientationOffset;

      tFlowVertices.get( 1 ).screenPosition = PVectorMath.vectorFromAngleMagnitude( tTargetMagnitudeAngle, targetMagnitudeOffsetDampener.getValue() * uiCam.getScale() );
      tFlowVertices.get( 1 ).screenPosition.add( tTargetInputPoint.position.toScreen() );
      tFlowVertices.get( 1 ).orientation = tTargetInputPoint.flowOrientation + PI; // Reverse target orientation (flowing in)
    }

    float tMagnitudeOut = magnitudeOutDampener.getValue() * uiCam.getScale();
    if ( abs( tMagnitudeOut ) < 1 ) { 
      tMagnitudeOut = 1;
    }
    float tMagnitudeIn = magnitudeInDampener.getValue() * uiCam.getScale();
    if ( abs( tMagnitudeIn ) < 1 ) { 
      tMagnitudeIn = 1;
    }

    tFlowVertices.get( 2 ).screenPosition = PVectorMath.vectorFromAngleMagnitude( tTargetMagnitudeAngle, tMagnitudeOut );
    tFlowVertices.get( 2 ).screenPosition.add( tFlowVertices.get( 1 ).screenPosition );
    tFlowVertices.get( 2 ).orientation = tFlowVertices.get( 1 ).orientation;
    tFlowVertices.get( 3 ).screenPosition = PVectorMath.vectorFromAngleMagnitude( tSourceMagnitudeAngle, tMagnitudeIn );
    tFlowVertices.get( 3 ).screenPosition.add( tFlowVertices.get( 0 ).screenPosition );
    tFlowVertices.get( 3 ).orientation = tFlowVertices.get( 0 ).orientation;

    // Unwind the nodes
    // Use a very hacky and naiive check for now
    boolean tSwapVertices = false;
    if ( targetNode != null )
    {
      if ( targetNode.getInputPoint( cMaterial ).flowOrientation != 0 && targetNode.getInputPoint( cMaterial ).magnitudeOrientationOffset == -HALF_PI )
      {
        tSwapVertices = true;
      }
    }
    if ( sourceNode != null )
    {
      if ( sourceNode.getOutputPoint().flowOrientation != 0 && sourceNode.getOutputPoint().magnitudeOrientationOffset == HALF_PI )
      {
        tSwapVertices = true;
      }
    }
    if ( tSwapVertices )
    {
      // Swap nodes 1 and 2
      Collections.swap( tFlowVertices, 1, 2 );
    }

    // Determine which vertices are supposed to be convex
    for ( int i = 1; i < tFlowVertices.size(); i++ )
    {
      FlowVertex tPrevVertex = tFlowVertices.get( i - 1 );
      FlowVertex tVertex = tFlowVertices.get( i );

      float tPrevVertexMagnitudeOrientation = tSourceMagnitudeAngle;
      float tVertexMagnitudeOrientation = tTargetMagnitudeAngle;
      if ( i == 3 )
      {
        tPrevVertexMagnitudeOrientation = tTargetMagnitudeAngle - PI;
        tVertexMagnitudeOrientation = tSourceMagnitudeAngle - PI;
      }

      if ( i % 2 == 1 )
      {
        PVector tPrevVertexDirection = new PVector();
        tPrevVertexDirection.set( tFlowVertices.get( 3 - ( i - 1 ) ).screenPosition );
        tPrevVertexDirection.sub( tPrevVertex.screenPosition );
        PVector tPrevVertexToVertex = new PVector();
        tPrevVertexToVertex.set( tVertex.screenPosition );
        tPrevVertexToVertex.sub( tPrevVertex.screenPosition );
        tPrevVertex.convex = PVectorMath.calcScalarProjection( tPrevVertexToVertex, tPrevVertexDirection ) >= 0;

        PVector tVertexDirection =  new PVector( );
        tVertexDirection.set( tFlowVertices.get( 3 - i ).screenPosition );
        tVertexDirection.sub( tVertex.screenPosition );
        PVector tVertexToPrevVertex = new PVector();
        tVertexToPrevVertex.set( tPrevVertex.screenPosition );
        tVertexToPrevVertex.sub( tVertex.screenPosition );
        tVertex.convex = PVectorMath.calcScalarProjection( tVertexToPrevVertex, tVertexDirection ) >= 0;
      }
    }

    // Increase the minimum bezier weight based on the magnitude of the flow
    // Probably shouldn't be linear
    float tMagnitudeWeightPower = 2;

    // Calculate Bezier weights
    for ( int i = 1; i < tFlowVertices.size(); i++ )
    {
      FlowVertex tPrevVertex = tFlowVertices.get( i - 1 );
      FlowVertex tVertex = tFlowVertices.get( i );

      if ( i % 2 == 1 )
      {
        float tPrevVertexMagnitude = tMagnitudeIn;
        float tVertexMagnitude = tMagnitudeOut;
        if ( i == 3 )
        {
          tPrevVertexMagnitude = tMagnitudeOut;
          tVertexMagnitude = tMagnitudeIn;
        }

        PVector tPrevVertexToVertex = new PVector();
        tPrevVertexToVertex.set( tVertex.screenPosition );
        tPrevVertexToVertex.sub( tPrevVertex.screenPosition );
        float tPrevVertexToVertexProjectedDist = PVectorMath.calcScalarProjection( tPrevVertexToVertex, PVectorMath.vectorFromAngleMagnitude( tPrevVertex.orientation, 1 ) );

        float tPrevVertexBezierWeight = abs( atan2( tPrevVertexToVertex.y, tPrevVertexToVertex.x ) / PI );
        if ( i == 3 ) { 
          tPrevVertexBezierWeight = 1 - tPrevVertexBezierWeight;
        }
        //if( tPrevVertex.convex )
        {
          tPrevVertexBezierWeight *= abs( tPrevVertexToVertexProjectedDist );
          tPrevVertexBezierWeight += tPrevVertexMagnitude;
        }

        PVector tVertexToPrevVertex = new PVector();
        tVertexToPrevVertex.set( tPrevVertex.screenPosition );
        tVertexToPrevVertex.sub( tVertex.screenPosition );
        float tVertexToVertexProjectedDist = PVectorMath.calcScalarProjection( tVertexToPrevVertex, PVectorMath.vectorFromAngleMagnitude( tVertex.orientation, 1 ) );

        float tVertexBezierWeight = abs( atan2( tVertexToPrevVertex.y, tVertexToPrevVertex.x ) / PI );
        if ( i == 1 ) { 
          tVertexBezierWeight = 1 - tVertexBezierWeight;
        }
        //if( tVertex.convex )
        { 
          tVertexBezierWeight *= abs( tVertexToVertexProjectedDist );
          tVertexBezierWeight += tVertexMagnitude;
        }

        tPrevVertex.bezierWeight = tPrevVertexBezierWeight;
        tVertex.bezierWeight = tVertexBezierWeight;
      }
    }

    if ( debugOverlay.enabled )
    {
      Collections.swap( tFlowVertices, 2, 3 );
      // Draw flow debug
      for ( int i = 0; i < tFlowVertices.size(); i++ )
      {
        FlowVertex tVertex = tFlowVertices.get( i );
        PVector tVertexOrientationPoint = PVectorMath.vectorFromAngleMagnitude( tVertex.orientation, tVertex.bezierWeight );
        tVertexOrientationPoint.add( tVertex.screenPosition );

        stroke( 0, 0, 1, 0.5 );
        if ( tVertex.convex ) { 
          stroke( 0, 0, 1, 1 );
        }
        strokeWeight( 1 );
        noFill();
        debug_cross( tVertex.screenPosition, 10 );
        line( tVertex.screenPosition.x, tVertex.screenPosition.y, tVertexOrientationPoint.x, tVertexOrientationPoint.y );

        if ( i % 2 == 0 )
        {
          stroke( 0, 0, 1, 0.25 );
          float tTimeFactor = abs( 1 - float( dTime % 2000 ) / 1000 );

          FlowVertex tNextVertex = tFlowVertices.get( i + 1 );
          PVector tNextVertexOrientationPoint = PVectorMath.vectorFromAngleMagnitude( tNextVertex.orientation, tNextVertex.bezierWeight );
          tNextVertexOrientationPoint.add( tNextVertex.screenPosition );

          PVector tQ0 = new PVector( tVertexOrientationPoint.x - tVertex.screenPosition.x, tVertexOrientationPoint.y - tVertex.screenPosition.y );
          tQ0.mult( tTimeFactor );
          tQ0.add( tVertex.screenPosition );

          PVector tQ1 = new PVector( tNextVertexOrientationPoint.x - tVertexOrientationPoint.x, tNextVertexOrientationPoint.y - tVertexOrientationPoint.y );
          tQ1.mult( tTimeFactor );
          tQ1.add( tVertexOrientationPoint );

          PVector tQ2 = new PVector( tNextVertex.screenPosition.x - tNextVertexOrientationPoint.x, tNextVertex.screenPosition.y - tNextVertexOrientationPoint.y );
          tQ2.mult( tTimeFactor );
          tQ2.add( tNextVertexOrientationPoint );

          line( tQ0.x, tQ0.y, tQ1.x, tQ1.y );
          line( tQ1.x, tQ1.y, tQ2.x, tQ2.y );

          PVector tR0 = new PVector( tQ1.x - tQ0.x, tQ1.y - tQ0.y );
          tR0.mult( tTimeFactor );
          tR0.add( tQ0 );

          PVector tR1 = new PVector( tQ2.x - tQ1.x, tQ2.y - tQ1.y );
          tR1.mult( tTimeFactor );
          tR1.add( tQ1 );

          line( tR0.x, tR0.y, tR1.x, tR1.y );

          PVector tS0 = new PVector( tR1.x - tR0.x, tR1.y - tR0.y );
          tS0.mult( tTimeFactor );
          tS0.add( tR0 );

          debug_cross( tS0, 5 );
        }

        fill( 0, 0, 1, 0.7 );
        textFont( fontDebugValue );
        textAlign( LEFT, BOTTOM );
        text( i, tVertex.screenPosition.x, tVertex.screenPosition.y );
      }
      Collections.swap( tFlowVertices, 2, 3 );
    }

    if ( sourceNode != null || targetNode != null )
    {
      PVector tVertexPos;
      PVector tPrevVertexPos;

      noStroke();
      fill( piUI.flowColor );

      beginShape();

      FlowVertex tFirstVertex = tFlowVertices.get( 0 );
      vertex( tFirstVertex.screenPosition.x, tFirstVertex.screenPosition.y );

      for ( int i = 1; i < tFlowVertices.size(); i++ )
      {
        FlowVertex tPrevVertex = tFlowVertices.get( i - 1 );
        FlowVertex tVertex = tFlowVertices.get( i );

        if ( i % 2 == 1 )
        {
          //          PVector tPrevVertexDirection = PVectorMath.vectorFromAngleMagnitude( tPrevVertex.orientation, 1 );
          //          PVector tPrevVertexToVertex = new PVector( tVertex.screenPosition.x, tVertex.screenPosition.y );
          //          tPrevVertexToVertex.sub( tPrevVertex.screenPosition );
          //          float tPrevVertexBezierWeight = tPrevVertexToVertex.dot( tPrevVertexDirection ) / 1;
          //          tPrevVertexBezierWeight = max( tPrevVertexBezierWeight* 0.5, pow( tPrevVertexMagnitude, tMagnitudeWeightPower ) * tMinBezierWeightFactor );
          //
          //          PVector tVertexDirection = PVectorMath.vectorFromAngleMagnitude( tVertex.orientation, 1 );
          //          PVector tVertexToPrevVertex = new PVector( tPrevVertex.screenPosition.x, tPrevVertex.screenPosition.y );
          //          tVertexToPrevVertex.sub( tVertex.screenPosition );
          //          float tVertexBezierWeight = tVertexToPrevVertex.dot( tVertexDirection ) / 1;
          //          tVertexBezierWeight = max( tVertexBezierWeight* 0.5, pow( tVertexMagnitude, tMagnitudeWeightPower ) * tMinBezierWeightFactor );


          PVector tPrevVertexBezierPoint = PVectorMath.vectorFromAngleMagnitude( tPrevVertex.orientation, tPrevVertex.bezierWeight );
          tPrevVertexBezierPoint.add( tPrevVertex.screenPosition );
          PVector tVertexBezierPoint = PVectorMath.vectorFromAngleMagnitude( tVertex.orientation, tVertex.bezierWeight );
          tVertexBezierPoint.add( tVertex.screenPosition );

          bezierVertex( tPrevVertexBezierPoint.x, tPrevVertexBezierPoint.y, tVertexBezierPoint.x, tVertexBezierPoint.y, tVertex.screenPosition.x, tVertex.screenPosition.y );
        }
        else
        {
          vertex( tVertex.screenPosition.x, tVertex.screenPosition.y );
        }
      }


      endShape();
    }
  }

  void drawDebug()
  {
    if ( sourceNode != null && targetNode != null )
    {
      PVector tSourceNodePos = sourceNode.getWorldPosition().toScreen();
      PVector tTargetNodePos = targetNode.getWorldPosition().toScreen();

      stroke( 0, 0, 1, 0.5 );
      strokeWeight( 1 );
      noFill();
      line( tSourceNodePos.x, tSourceNodePos.y, tTargetNodePos.x, tTargetNodePos.y );

      PVector tMidPos = new PVector( tTargetNodePos.x, tTargetNodePos.y );
      tMidPos.sub( tSourceNodePos );
      tMidPos.mult( 0.5 );
      tMidPos.add( tSourceNodePos );

      textFont( fontDebugValue );
      textAlign( LEFT, BOTTOM );
      text( "Magnitude\n" + str( cMagnitudeIn ), tMidPos.x, tMidPos.y );

      tMidPos = new PVector( tTargetNodePos.x, tTargetNodePos.y );
      tMidPos.sub( tSourceNodePos );
      tMidPos.mult( 0.2 );
      tMidPos.add( tSourceNodePos );

      textFont( fontDebugValue );
      textAlign( LEFT, TOP );
      text( str( cSourceMagnitudeOffset ), tMidPos.x, tMidPos.y );

      textFont( fontDebugValue );
      textAlign( RIGHT, BOTTOM );
      text( str( cTargetMagnitudeOffset ), tTargetNodePos.x, tTargetNodePos.y );
    }
  }
}

class FlowVertex  // Helper class for drawing flows
{
  PVector screenPosition;
  float orientation;
  float bezierWeight;
  boolean convex;

  FlowVertex( PVector aScreenPosition, float aOrientation, float aBezierWeight )
  {
    screenPosition = aScreenPosition;
    orientation = aOrientation;
    bezierWeight = aBezierWeight;
    convex = false;
  }
}


interface FlowNodePI extends FlowNode
{
  PIMaterial getMaterialProduced( FlowPI aFlow );

  /// Returns units produced per unit time (1hr)
  int getUnitsProduced();

  /// Returns units required for a specified material per unit time (1hr)
  int getUnitsRequired( PIMaterial aMaterial );

  float getInputWorldOffset( PIMaterial aMaterial );

  PIProcess getProcess();

  WorldPosition getWorldPosition();

  FlowPoint getOutputPoint();
  FlowPoint getInputPoint( PIMaterial aMaterial );
}

// Currently unused
//class FlowPointPI extends FlowPoint
//{
//  
//}

