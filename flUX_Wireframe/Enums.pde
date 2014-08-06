static int EDGE_TOPLEFT = 7;
static int EDGE_TOP = 8;
static int EDGE_TOPRIGHT = 9;

static int EDGE_LEFT = 4;
static int EDGE_CENTER = 5;
static int EDGE_RIGHT = 6;

static int EDGE_BOTTOMLEFT = 1;
static int EDGE_BOTTOM = 2;
static int EDGE_BOTTOMRIGHT = 3;

static int PINARRAY_LEFT = 0;
static int PINARRAY_RIGHT = 1;
static int PINARRAY_TOP = 2;
static int PINARRAY_BOTTOM = 3;

static int getOppositePinnedEdgeIndex( int aPinnedEdge )
{
  if ( aPinnedEdge == PINARRAY_LEFT )
  {
    return PINARRAY_RIGHT;
  }
  if ( aPinnedEdge == PINARRAY_RIGHT )
  {
    return PINARRAY_LEFT;
  }
  if ( aPinnedEdge == PINARRAY_TOP )
  {
    return PINARRAY_BOTTOM;
  }
  if ( aPinnedEdge == PINARRAY_BOTTOM )
  {
    return PINARRAY_TOP;
  }
  return -1;
}

static int getPinnableEdgeIndex( int aEdgeCorner )
{
  if ( aEdgeCorner == EDGE_LEFT )
  {
    return PINARRAY_LEFT;
  }
  if ( aEdgeCorner == EDGE_RIGHT )
  {
    return PINARRAY_RIGHT;
  }
  if ( aEdgeCorner == EDGE_TOP )
  {
    return PINARRAY_TOP;
  }
  if ( aEdgeCorner == EDGE_BOTTOM )
  {
    return PINARRAY_BOTTOM;
  }
  return -1;
}

static int getEdgeRectIndex( int aPinnableEdge )
{
  if ( aPinnableEdge == PINARRAY_LEFT )
  {
    return EDGE_LEFT;
  }
  if ( aPinnableEdge == PINARRAY_RIGHT )
  {
    return EDGE_RIGHT;
  }
  if ( aPinnableEdge == PINARRAY_TOP )
  {
    return EDGE_TOP;
  }
  if ( aPinnableEdge == PINARRAY_BOTTOM )
  {
    return EDGE_BOTTOM;
  }
  return -1;
}
