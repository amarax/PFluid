enum PinEdge
{
  PINEDGE_INVALID(-1),
  
  PINEDGE_LEFT(0), 
  PINEDGE_RIGHT(1), 
  PINEDGE_TOP(2), 
  PINEDGE_BOTTOM(3);

  final int arrayIndex;

  PinEdge( int aIndex )
  {
    arrayIndex = aIndex;
  }
}

//switch( edge )
//{
//  case PINEDGE_LEFT:
//  case PINEDGE_RIGHT:
//  case PINEDGE_TOP:
//  case PINEDGE_BOTTOM:
//}

