
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

  void plot( PVector aPinAnchorPosition, color aWireframeColor, boolean aIsPinnedToChild )
  {
    plotDebug( aPinAnchorPosition );
  }

  void plotDebug( PVector aPinAnchorPosition )
  {
    if ( debug_editableRect_pins )
    {
      textAlign( LEFT, TOP );
      String tDebugDisplayString = this.getClass().getSimpleName();
      debugText( tDebugDisplayString, aPinAnchorPosition.x, aPinAnchorPosition.y );
    }
  }
}

class EditableRectPinLocalAbsolute extends EditableRectPin
{
  float localPos;
  EditableRect pinnedTarget;

  EditableRectPinLocalAbsolute( EditableRect aPinnedTarget, int aPinnedEdge )
  {
    super( aPinnedTarget.getParent(), aPinnedEdge );

    pinnedTarget = aPinnedTarget;
    updateOffset( pinnedTarget.getPinnedEdgeValue( aPinnedEdge ) );
  }

  EditableRectPinLocalAbsolute( EditableRect aPinnedTarget, int aPinnedEdge, float aLocalPos )
  {
    super( aPinnedTarget.getParent(), aPinnedEdge );

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
    if ( pinnedSource == null )
      return offset;

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

  void plot( PVector aPinAnchorPosition, color aWireframeColor, boolean aIsPinnedToChild )
  {
    PVector tOffset = new PVector( 0, 0 );
    if ( pinnedSourceEdge == PINARRAY_LEFT || pinnedSourceEdge == PINARRAY_RIGHT )
    {
      tOffset.x = offset;
    } 
    else
    {
      tOffset.y = offset;
    }

    if ( isPinFilled() )
    {
      fill( aWireframeColor );
    }
    else
    {
      noFill();
    }
    stroke( aWireframeColor );
    strokeWeight( 1 );

    if ( aIsPinnedToChild )
    {
      pinArc( aPinAnchorPosition.x, aPinAnchorPosition.y, tOffset.x, tOffset.y, pinArcSize );
    } 
    else
    {
      pinTriangle( aPinAnchorPosition.x, aPinAnchorPosition.y, -tOffset.x, -tOffset.y, pinTriangleSize );
    }

    plotDebug( aPinAnchorPosition );
  }

  void plotDebug( PVector aPinAnchorPosition )
  {
    super.plotDebug( aPinAnchorPosition );
    if ( debug_editableRect_pins )
    {
      String tDebugDisplayString = "Offset=";
      tDebugDisplayString += offset;
      debugText( tDebugDisplayString );
    }
  }

  boolean isPinFilled()
  {
    return false;
  }
}

class EditableRectPinGlobalOffset extends EditableRectPinOffset
{
  Global_Float globalOffsetValue;

  EditableRectPinGlobalOffset( EditableRectPinOffset aExistingPin, Global_Float aGlobalOffsetValue )
  {
    super( (EditableRect)( aExistingPin.pinnedSource ), aExistingPin.pinnedSourceEdge, aExistingPin.calcPinnedEdgePosition() );
    setGlobalValue( aGlobalOffsetValue );
  }

  EditableRectPinGlobalOffset( EditableRect aPinnedSource, int aPinnedSourceEdge, float aCurrentPos, Global_Float aGlobalOffsetValue )
  {
    super( aPinnedSource, aPinnedSourceEdge, aCurrentPos );
    setGlobalValue( aGlobalOffsetValue );
  }

  float calcPinnedEdgePosition()
  {
    if ( pinnedSource == null )
      return globalOffsetValue.getValue() * ( offset / abs( offset ) );

    return ((EditableRect)pinnedSource).getPinnedEdgeValue( pinnedSourceEdge ) + globalOffsetValue.getValue() * ( offset / abs( offset ) );
  }

  void setGlobalValue( Global_Float aGlobalOffsetValue )
  {
    globalOffsetValue = aGlobalOffsetValue;
  }

  boolean isPinFilled()
  {
    return true;
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

  void plot( PVector aPinAnchorPosition, color aWireframeColor, boolean aIsPinnedToChild )
  {
    PVector tOffset = new PVector( 0, 0 );
    if ( pinnedSourceEdge == PINARRAY_LEFT || pinnedSourceEdge == PINARRAY_RIGHT )
    {
      tOffset.x = 1.0;
    } 
    else
    {
      tOffset.y = 1.0;
    }

    noFill();
    stroke( aWireframeColor );
    strokeWeight( 1 );
    pinTriangle( aPinAnchorPosition.x, aPinAnchorPosition.y, -tOffset.x, -tOffset.y, pinTriangleSize );
    pinTriangle( aPinAnchorPosition.x, aPinAnchorPosition.y, tOffset.x, tOffset.y, pinTriangleSize );

    plotDebug( aPinAnchorPosition );
  }
}

