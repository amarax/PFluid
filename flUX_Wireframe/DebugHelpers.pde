
class DebugValueHistory
{
  float[] history;
  float scale = 1;

  boolean isHistogram = false;

  DebugValueHistory( float aInitialValue )
  {
    history = new float[100];

    for ( int i = 0; i < history.length; ++i )
      history[i] = aInitialValue;
  }

  void plotDebug( float aNewValue, PVector aScreenPos )
  {
    noSmooth();
    for ( int i = 0; i < history.length - 1; ++i  )
    {
      history[i] = history[i + 1];
      if ( isHistogram )
        line( aScreenPos.x + i, aScreenPos.y + history.length / 2.0 - history[i] * scale, aScreenPos.x + i, aScreenPos.y + history.length / 2.0 );
      else
        point( aScreenPos.x + i, aScreenPos.y + history.length / 2.0 - history[i] * scale );
    }
    int i = history.length - 1;
    history[ i ] = aNewValue;
    if ( isHistogram )
      line( aScreenPos.x + i, aScreenPos.y + history.length / 2.0 - history[i] * scale, aScreenPos.x + i, aScreenPos.y + history.length / 2.0 );
    else
      point( aScreenPos.x + i, aScreenPos.y + history.length / 2.0 - history[i] * scale );
    smooth();
  }
}

void debugText( String aDebugString, float aX, float aY )
{
  fill( color_debug );
  textFont( font_debug );
  text( aDebugString, aX, aY );
  debugPos.set( aX, aY );
  incrementDebugPos();
}

void debugText( String aDebugString )
{
  debugText( aDebugString, debugPos.x, debugPos.y );
}

void incrementDebugPos()
{
  float tLineSpacingFactor = 1.1;
  debugPos.add( new PVector( 0, ceil( textAscent() + textDescent() ) * tLineSpacingFactor ) );
}

