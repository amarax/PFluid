
class Camera
{
  PVector offset;
  float scale;

  float dampedScrollBuffer;

  PVector mouseDownOffset;

  DebugValueHistory scrollBufferHistory;
  DebugValueHistory dampedScrollBufferHistory;

  Camera()
  {
    offset = new PVector();
    scale = 1;

    dampedScrollBuffer = 0;

    scrollBufferHistory = new DebugValueHistory( 0 );
    scrollBufferHistory.isHistogram = true;
    scrollBufferHistory.scale = 3;
    dampedScrollBufferHistory = new DebugValueHistory( 0 );
    dampedScrollBufferHistory.scale = 3;
  }

  void update()
  {
    if ( mouseCursor.hoveredEntity == null )
    {
      if ( keyBuffer.contains( ' ' ) )
      {
        offset.set( 0, 0 );
        scale = 1;
        dampedScrollBuffer = 0;
      }
    }

    float tDampingFactor = 0.3;
    dampedScrollBuffer += 0.3 * mouseCursor.scrollBufferPreviousFrame; // Magic number approximation so cumulative scroll is about the same for damped and undamped values.  
    float tScrollAmount = tDampingFactor * dampedScrollBuffer;
    dampedScrollBuffer -= tScrollAmount;

    if ( mouseDownPos != null && mouseDownOffset == null && mouseCursor.hoveredEntity == null && mouseCursor.focusedEntity == null )
    {
      mouseDownOffset = new PVector( offset.x, offset.y );
    }

    if ( tScrollAmount != 0 )
    {
      float tScaleModifier = -tScrollAmount * mouseWheelScalingFactor + 1;
      float tPreviousScale = camera.scale;
      camera.scale *= tScaleModifier;

      PVector tMouseCursorWorldPos = new PVector( mouseX, mouseY );
      offset.sub( tMouseCursorWorldPos );
      offset.mult( tScaleModifier );
      offset.add( tMouseCursorWorldPos );

      if ( mouseDownPos != null && mouseCursor.hoveredEntity == null && mouseCursor.focusedEntity == null )
      {
        mouseDownOffset.sub( mouseDownPos );
        mouseDownOffset.mult( tScaleModifier );
        mouseDownOffset.add( mouseDownPos );
      }
    }

    if ( mouseDownPos != null && mouseCursor.hoveredEntity == null && mouseCursor.focusedEntity == null )
    {
      PVector tNewOffset = new PVector( mouseX, mouseY );
      tNewOffset.sub( mouseDownPos );
      tNewOffset.add( mouseDownOffset );
      offset.set( tNewOffset );
    }
    else
    {
      mouseDownOffset = null;
    }

    translate( offset.x, offset.y );
    scale( scale );
  }

  void plotDebug()
  {
    if ( !debug_camera )
    {
      return;
    }

    PVector tScreenPos = new PVector( 1, 0 ); 
    float tLineSpacingFactor = 1.1;
    String tDebugText = "Camera";

    fill( color_debug );
    textAlign( LEFT, TOP );
    textFont( font_debug );
    text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

    tDebugText = "offset = " + nf( offset.x, 1, 1 ) + ", " +  nf( offset.y, 1, 1 );
    tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );
    text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

    tDebugText = "scale = " + nf( scale, 1, 4 );
    tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );
    text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

    tDebugText = "dampedScrollBuffer = " + nf( dampedScrollBuffer, 1, 4 );
    tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );
    text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

    color tColor = color( hue( color_debug ), saturation( color_debug ), brightness( color_debug ), alpha( color_debug ) * 0.5 );
    stroke( tColor );
    scrollBufferHistory.plotDebug( mouseCursor.scrollBufferPreviousFrame, tScreenPos );

    stroke( color_debug );
    dampedScrollBufferHistory.plotDebug( dampedScrollBuffer, tScreenPos );

    tScreenPos.y += 90 + 2;

    if ( mouseDownOffset != null )
    {
      tDebugText = "mouseDownOffset = " + nf( mouseDownOffset.x, 1, 1 ) + ", " +  nf( mouseDownOffset.y, 1, 1 );
      tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );
      text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );
    }
  }

  PVector worldToScreen( PVector aWorldPosition )
  {
    PVector tScreenPosition = new PVector( aWorldPosition.x, aWorldPosition.y );
    tScreenPosition.mult( scale );
    tScreenPosition.add( offset ); 

    return tScreenPosition;
  }

  PVector screenToWorld( PVector aScreenPosition )
  {
    PVector tWorldPosition = new PVector( aScreenPosition.x, aScreenPosition.y );
    tWorldPosition.sub( offset ); 
    tWorldPosition.div( scale );

    return tWorldPosition;
  }
}

