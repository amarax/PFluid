

interface FlowNode
{
}


class FlowPoint
{
  WorldPosition position;
  float flowOrientation;
  float magnitudeOrientationOffset;  // Offset of the magnitude orientation from the flow

  FlowPoint( WorldPosition aPosition, float aFlowOrientation, float aMagnitudeOrientationOffset )
  {
    position = aPosition;
    flowOrientation = aFlowOrientation;
    magnitudeOrientationOffset = aMagnitudeOrientationOffset;
  }
}


class Flow
{
  Flow()
  {
    world.flowManager.flows.add( this );
  }
  
  void update()
  {
  }
  
  void plot()
  {
  }
  
  void drawDebug()
  {
  }
}

class FlowManager
{
  ArrayList<Flow> flows;
  
  FlowManager()
  {
    flows = new ArrayList<Flow>();
  }
  
  void update()
  {
    for( int i = 0; i < flows.size(); i++ )
    {
      ( (Flow)( flows.get( i ) ) ).update();
    }
  }
  
  void plot()
  {
    Iterator<Flow> i = flows.iterator();
    while( i.hasNext() )
    {
      (i.next() ).plot();
    }
  }
  
  void drawDebug()
  {
    Iterator<Flow> i = flows.iterator();
    while( i.hasNext() )
    {
      (i.next() ).drawDebug();
    }
  }
}
