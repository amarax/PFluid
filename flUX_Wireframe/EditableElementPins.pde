
abstract class EditableRectPin
{
  EditableRect pinnedSource;
  int pinnedSourceEdge;

  EditableRectPin( EditableRect aPinnedSource, int aPinnedSourceEdge )
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

  EditableRectPinLocalAbsolute( EditableRect aPinnedSource, int aPinnedSourceEdge, float aLocalPos )
  {
    super( aPinnedSource, aPinnedSourceEdge );
    updateOffset( aLocalPos );
  }

  void updateOffset( float aCurrentPos )
  {
    localPos = aCurrentPos;
  }

  float calcPinnedEdgePosition()
  {
    return localPos;
  }

  void mirrorOffset()
  {
    // Not working properly
    if ( pinnedSource != null )
    {
      int tMinEdge = min( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
      int tMaxEdge = max( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
      float tRelativePos = 1- ( localPos - pinnedSource.getPinnedEdgeValue( tMinEdge ) ) / ( pinnedSource.getPinnedEdgeValue( tMaxEdge ) - pinnedSource.getPinnedEdgeValue( tMinEdge ) );
      localPos = pinnedSource.getPinnedEdgeValue( tMinEdge ) * (1-tRelativePos) + pinnedSource.getPinnedEdgeValue( tMaxEdge ) * tRelativePos ;
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
    return pinnedSource.getPinnedEdgeValue( pinnedSourceEdge ) + offset;
  }

  void updateOffset( float aCurrentPos )
  {
    offset = aCurrentPos - pinnedSource.getPinnedEdgeValue( pinnedSourceEdge );
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
    return pinnedSource.getPinnedEdgeValue( tMinEdge ) * (1-relativePos) + pinnedSource.getPinnedEdgeValue( tMaxEdge ) * relativePos ;
  }

  void updateOffset( float aCurrentPos )
  {
    int tMinEdge = min( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
    int tMaxEdge = max( pinnedSourceEdge, getOppositePinnedEdgeIndex( pinnedSourceEdge ) );
    relativePos = ( aCurrentPos - pinnedSource.getPinnedEdgeValue( tMinEdge ) ) / ( pinnedSource.getPinnedEdgeValue( tMaxEdge ) - pinnedSource.getPinnedEdgeValue( tMinEdge ) );
  }

  void mirrorOffset()
  {
    relativePos = 1.0 - relativePos;
  }
}

