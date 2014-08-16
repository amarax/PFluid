
abstract class EditableRectPin
{
  Entity pinnedSource;
  PinEdge sourcePinEdge;

  EditableRect target;
  PinEdge targetEdge;

  EditableRectPin( EditableRect aTarget, PinEdge aTargetEdge, Entity aPinnedSource, PinEdge aSourcePinEdge )
  {
    pinnedSource = aPinnedSource;
    sourcePinEdge = aSourcePinEdge;
    
    target = aTarget;
    targetEdge = aTargetEdge;
  }

  float calcPinnedEdgePosition()
  {
    return 0;
  }

  void updateOffset( float aCurrentPos )
  {
  }

  void updateTarget()
  {
    float tValue = calcPinnedEdgePosition();
    switch( targetEdge )
    {
    case PINEDGE_LEFT:
      target.left = tValue;
      break;
    case PINEDGE_RIGHT:
      target.right = tValue;
      break;
    case PINEDGE_TOP:
      target.top = tValue;
      break;
    case PINEDGE_BOTTOM:
      target.bottom = tValue;
      break;
    default:
    }
  }

  void mirror()
  {
    sourcePinEdge = getOppositePinEdge( sourcePinEdge );

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

  EditableRectPinLocalAbsolute( EditableRect aPinnedTarget, PinEdge aPinnedEdge )
  {
    super( aPinnedTarget, aPinnedEdge, aPinnedTarget.getParent(), aPinnedEdge );

    updateOffset( target.getPinnedEdgeValue( aPinnedEdge ) );
  }

  EditableRectPinLocalAbsolute( EditableRect aPinnedTarget, PinEdge aPinnedEdge, float aLocalPos )
  {
    super( aPinnedTarget, aPinnedEdge, aPinnedTarget.getParent(), aPinnedEdge );

    updateOffset( aLocalPos );
  }

  void updateOffset( float aCurrentPos )
  {
    PVector tTargetPos = target.localToWorld( target.position );

    switch( sourcePinEdge )
    {
    case PINEDGE_LEFT:
    case PINEDGE_RIGHT:
      localPos = aCurrentPos - tTargetPos.x;
      break;
    case PINEDGE_TOP:
    case PINEDGE_BOTTOM:
      localPos = aCurrentPos - tTargetPos.y;
      break;
    default:
      localPos = aCurrentPos;
    }
  }

  float calcPinnedEdgePosition()
  {
    PVector tTargetPos = target.localToWorld( target.position );

    switch( sourcePinEdge )
    {
    case PINEDGE_LEFT:
    case PINEDGE_RIGHT:
      return localPos + tTargetPos.x;
    case PINEDGE_TOP:
    case PINEDGE_BOTTOM:
      return localPos + tTargetPos.y;
    default:
      return localPos;
    }
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

  EditableRectPinOffset( EditableRect aTarget, PinEdge aTargetEdge, EditableRect aPinnedSource, PinEdge aSourcePinEdge, float aCurrentPos )
  {
    super( aTarget, aTargetEdge, aPinnedSource, aSourcePinEdge );
    updateOffset( aCurrentPos );
  }

  float calcPinnedEdgePosition()
  {
    if ( pinnedSource == null )
      return offset;

    return ((EditableRect)pinnedSource).getPinnedEdgeValue( sourcePinEdge ) + offset;
  }

  void updateOffset( float aCurrentPos )
  {
    if ( pinnedSource == null )
      return;

    offset = aCurrentPos - ((EditableRect)pinnedSource).getPinnedEdgeValue( sourcePinEdge );
  }

  void mirrorOffset()
  {
    offset *= -1;
  }

  void plot( PVector aPinAnchorPosition, color aWireframeColor, boolean aIsPinnedToChild )
  {
    PVector tOffset = new PVector( 0, 0 );

    switch( sourcePinEdge )
    {
    case PINEDGE_LEFT:
    case PINEDGE_RIGHT:
      tOffset.x = offset;
      break;
    case PINEDGE_TOP:
    case PINEDGE_BOTTOM:
      tOffset.y = offset;
      break;
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
    super( aExistingPin.target, aExistingPin.targetEdge, (EditableRect)( aExistingPin.pinnedSource ), aExistingPin.sourcePinEdge, aExistingPin.calcPinnedEdgePosition() );
    setGlobalValue( aGlobalOffsetValue );
  }

  EditableRectPinGlobalOffset( EditableRect aTarget, PinEdge aTargetEdge, EditableRect aPinnedSource, PinEdge aSourcePinEdge, float aCurrentPos, Global_Float aGlobalOffsetValue )
  {
    super( aTarget, aTargetEdge, aPinnedSource, aSourcePinEdge, aCurrentPos );
    setGlobalValue( aGlobalOffsetValue );
  }

  float calcPinnedEdgePosition()
  {
    if ( pinnedSource == null )
      return globalOffsetValue.getValue() * ( offset / abs( offset ) );

    return ((EditableRect)pinnedSource).getPinnedEdgeValue( sourcePinEdge ) + globalOffsetValue.getValue() * ( offset / abs( offset ) );
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

  EditableRectPinRelative( EditableRect aTarget, PinEdge aTargetEdge, EditableRect aPinnedSource, PinEdge asourcePinEdge, float aCurrentPos )
  {
    super( aTarget, aTargetEdge, aPinnedSource, asourcePinEdge );
    updateOffset( aCurrentPos );
  }

  float calcPinnedEdgePosition()
  {
    PinEdge tMinEdge = getMinEdge( sourcePinEdge );
    PinEdge tMaxEdge = getMaxEdge( sourcePinEdge );
    return ((EditableRect)pinnedSource).getPinnedEdgeValue( tMinEdge ) * (1-relativePos) + ((EditableRect)pinnedSource).getPinnedEdgeValue( tMaxEdge ) * relativePos ;
  }

  void updateOffset( float aCurrentPos )
  {
    PinEdge tMinEdge = getMinEdge( sourcePinEdge );
    PinEdge tMaxEdge = getMaxEdge( sourcePinEdge );
    relativePos = ( aCurrentPos - ((EditableRect)pinnedSource).getPinnedEdgeValue( tMinEdge ) ) / ( ((EditableRect)pinnedSource).getPinnedEdgeValue( tMaxEdge ) - ((EditableRect)pinnedSource).getPinnedEdgeValue( tMinEdge ) );
  }

  void mirrorOffset()
  {
    relativePos = 1.0 - relativePos;
  }

  void plot( PVector aPinAnchorPosition, color aWireframeColor, boolean aIsPinnedToChild )
  {
    PVector tOffset = new PVector( 0, 0 );
    switch( sourcePinEdge )
    {
    case PINEDGE_LEFT:
    case PINEDGE_RIGHT:
      tOffset.x = 1.0;
      break;
    case PINEDGE_TOP:
    case PINEDGE_BOTTOM:
      tOffset.y = 1.0;
      break;
    }

    noFill();
    stroke( aWireframeColor );
    strokeWeight( 1 );
    pinTriangle( aPinAnchorPosition.x, aPinAnchorPosition.y, -tOffset.x, -tOffset.y, pinTriangleSize );
    pinTriangle( aPinAnchorPosition.x, aPinAnchorPosition.y, tOffset.x, tOffset.y, pinTriangleSize );

    plotDebug( aPinAnchorPosition );
  }
}

