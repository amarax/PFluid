static int EDGE_TOPLEFT = 7;
static int EDGE_TOP = 8;
static int EDGE_TOPRIGHT = 9;

static int EDGE_LEFT = 4;
static int EDGE_CENTER = 5;
static int EDGE_RIGHT = 6;

static int EDGE_BOTTOMLEFT = 1;
static int EDGE_BOTTOM = 2;
static int EDGE_BOTTOMRIGHT = 3;

//static int getOppositePinnedEdgeIndex( int aPinnedEdge )
//{
//  if ( aPinnedEdge == PINARRAY_LEFT )
//  {
//    return PINARRAY_RIGHT;
//  }
//  if ( aPinnedEdge == PINARRAY_RIGHT )
//  {
//    return PINARRAY_LEFT;
//  }
//  if ( aPinnedEdge == PINARRAY_TOP )
//  {
//    return PINARRAY_BOTTOM;
//  }
//  if ( aPinnedEdge == PINARRAY_BOTTOM )
//  {
//    return PINARRAY_TOP;
//  }
//  return -1;
//}

static int getOppositeEdgeIndex( int aEdge )
{
  int tOppositeEdge = aEdge;
  tOppositeEdge = getHorizontallyOppositeEdgeIndex( tOppositeEdge );
  tOppositeEdge = getVerticallyOppositeEdgeIndex( tOppositeEdge );
  return tOppositeEdge;
}

static int getHorizontallyOppositeEdgeIndex( int aEdge )
{
  int tOppositeEdge = aEdge;
  switch( tOppositeEdge % 3 )
  {
  case 0:
    tOppositeEdge -= 2;
    break;
  case 1:
    tOppositeEdge+= 2;
    break;
  }
  return tOppositeEdge;
}

static int getVerticallyOppositeEdgeIndex( int aEdge )
{
  int tOppositeEdge = aEdge;
  switch( ( tOppositeEdge - 1 ) / 3 )
  {
  case 0:
    tOppositeEdge += 6;
    break;
  case 2:
    tOppositeEdge -= 6;
    break;
  }
  return tOppositeEdge;
}

PinEdge getOppositePinEdge( PinEdge aPinnedEdge )
{
  switch( aPinnedEdge )
  {
  case PINEDGE_LEFT:
    return PinEdge.PINEDGE_RIGHT;
  case PINEDGE_RIGHT:
    return PinEdge.PINEDGE_LEFT;
  case PINEDGE_TOP:
    return PinEdge.PINEDGE_BOTTOM;
  case PINEDGE_BOTTOM:
    return PinEdge.PINEDGE_TOP;
  }
  return PinEdge.PINEDGE_INVALID;
}

PinEdge getDiagonalPinEdge( PinEdge aPinnedEdge )
{
  switch( aPinnedEdge )
  {
  case PINEDGE_LEFT:
    return PinEdge.PINEDGE_TOP;
  case PINEDGE_RIGHT:
    return PinEdge.PINEDGE_BOTTOM;
  case PINEDGE_TOP:
    return PinEdge.PINEDGE_LEFT;
  case PINEDGE_BOTTOM:
    return PinEdge.PINEDGE_RIGHT;
  }
  return PinEdge.PINEDGE_INVALID;
}

int getEdgeRectIndex( PinEdge aPinnableEdge )
{
  switch( aPinnableEdge )
  {
  case PINEDGE_LEFT:
    return EDGE_LEFT;
  case PINEDGE_RIGHT:
    return EDGE_RIGHT;
  case PINEDGE_TOP:
    return EDGE_TOP;
  case PINEDGE_BOTTOM:
    return EDGE_BOTTOM;
  }
  return -1;
}

PinEdge getPinEdge( int aEdgeCorner )
{
  if ( aEdgeCorner == EDGE_LEFT )
  {
    return PinEdge.PINEDGE_LEFT;
  }
  if ( aEdgeCorner == EDGE_RIGHT )
  {
    return PinEdge.PINEDGE_RIGHT;
  }
  if ( aEdgeCorner == EDGE_TOP )
  {
    return PinEdge.PINEDGE_TOP;
  }
  if ( aEdgeCorner == EDGE_BOTTOM )
  {
    return PinEdge.PINEDGE_BOTTOM;
  }
  return PinEdge.PINEDGE_INVALID;
}

PinEdge getMinEdge( PinEdge aEdge )
{
  switch( aEdge )
  {
  case PINEDGE_LEFT:
  case PINEDGE_RIGHT:
    return PinEdge.PINEDGE_LEFT;
  case PINEDGE_TOP:
  case PINEDGE_BOTTOM:
    return PinEdge.PINEDGE_TOP;
  }
  return PinEdge.PINEDGE_INVALID;
}

PinEdge getMaxEdge( PinEdge aEdge )
{
  switch( aEdge )
  {
  case PINEDGE_LEFT:
  case PINEDGE_RIGHT:
    return PinEdge.PINEDGE_RIGHT;
  case PINEDGE_TOP:
  case PINEDGE_BOTTOM:
    return PinEdge.PINEDGE_BOTTOM;
  }
  return PinEdge.PINEDGE_INVALID;
}

