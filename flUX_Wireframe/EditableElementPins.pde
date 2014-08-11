
abstract class EditableRectPin
{
  Entity pinnedSource;
  int pinnedSourceEdge;

  EditableRectPin( Entity aPinnedSource, int aPinnedSourceEdge )
  {
    pinnedSource = aPinnedSource;
    pinnedSourceEdge = aPinnedSourceEdge;
  }

  float calcPinnedEdgePosition()
  {
    return 0;
  }

  void updateOffset( float aCurrentPos )
  {
  }

  void mirror()
  {
    pinnedSourceEdge = getOppositePinnedEdgeIndex( pinnedSourceEdge );

    mirrorOffset();
  }

  void mirrorOffset()
  {
  }
}

class EditableRectPinLocalAbsolute extends EditableRectPin
{
  float localPos;
  EditableRect pinnedTarget;

  EditableRectPinLocalAbsolute( Entity aPinnedSource, int aPinnedSourceEdge, float aLocalPos, EditableRect aPinnedTarget )
  {
    super( aPinnedSource, aPinnedSourceEdge );

    pinnedTarget = aPinnedTarget;
    updateOffset( aLocalPos );
  }

  void updateOffset( float aCurrentPos )
  {
    PVector tTargetPos = pinnedTarget.localToWorld( pinnedTarget.position );

    if ( pinnedSourceEdge == PINARRAY_LEFT || pinnedSourceEdge == PINARRAY_RIGHT )
    {
      localPos = aCurrentPos - tTargetPos.x;
    }
    else if ( pinnedSourceEdge == PINARRAY_TOP || pinnedSourceEdge == PINARRAY_BOTTOM )
    {
      localPos = aCurrentPos - tTargetPos.y;
    }
    else 
    {
      localPos = aCurrentPos;
    }
  }

  float calcPinnedEdgePosition()
  {
    PVector tTargetPos = pinnedTarget.localToWorld( pinnedTarget.position );

    if ( pinnedSourceEdge == PINARRAY_LEFT || pinnedSourceEdge == PINARRAY_RIGHT )
    {
      return localPos + tTargetPos.x;
    }
    else if ( pinnedSourceEdge == PINARRAY_TOP || pinnedSourceEdge == PINARRAY_BOTTOM )
    {
      return localPos + tTargetPos.y;
    }

    return localPos;
  }

  void mirrorOffset()
  {
    if ( pinnedSource instanceof EditableRect )
    {
       localPos *= -1;
    }
  }
}

class EditableRectPinOffset extends EditableRectPin
{
  float offset;

  EditableRectPinOffset( EditableRect aPinnedSource, int aPinnedSourceEdge, float aCurrentPos )
  {
    super( aPinnedSource, aPinnedSourceEdge );
    updateOffset( aCurrentPos );
  }

  float calcPinnedEdgePosition()
  {
    return ((EditableRect)pinnedSource).getPinnedEdgeValue( pinnedSourceEdge ) + offset;
  }

  void updateOffset( float aCurrentPos )
  {
    if ( pinnedSource == null )
      return;

    offset = aCurrentPos - ((EditableRect)pinnedSource).getPinnedEdgeValue( pinnedSourceEdge );
  }

  void mirrorOffset()
  {
    offset *= -1;
  }
}

class EditableRectPinRelative extends EditableRectPin
{
  float relativePos;

  EditableRectPinRelative( EditableRect aPinnedSource, int aPinnedSourceEdge, float aCurrentPos )
  {
    super( aPinnedSource, aPinnedSourceEdge );
    updateOffset( aCurrentPos );
  }

  float calcPinnedEdgePosition()
  {
    int tMinEdge = min( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
    int tMaxEdge = max( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
    return ((EditableRect)pinnedSource).getPinnedEdgeValue( tMinEdge ) * (1-relativePos) + ((EditableRect)pinnedSource).getPinnedEdgeValue( tMaxEdge ) * relativePos ;
  }

  void updateOffset( float aCurrentPos )
  {
    int tMinEdge = min( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
    int tMaxEdge = max( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
    relativePos = ( aCurrentPos - ((EditableRect)pinnedSource).getPinnedEdgeValue( tMinEdge ) ) / ( ((EditableRect)pinnedSource).getPinnedEdgeValue( tMaxEdge ) - ((EditableRect)pinnedSource).getPinnedEdgeValue( tMinEdge ) );
  }

  void mirrorOffset()
  {
    relativePos = 1.0 - relativePos;
  }
}

