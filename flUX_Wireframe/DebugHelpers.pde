
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

