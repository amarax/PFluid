

public void pointcross( float aX, float aY, float aSize )
{
  line( aX, aY - aSize, aX, aY + aSize ); 
  line( aX - aSize, aY, aX + aSize, aY );
}



public PVector calcArcAnchoredTextCenter( PVector aTextDimensions, PVector aAnchorPos, float aAnchorAngle )
{
  PVector tTextCenter = new PVector( aAnchorPos.x, aAnchorPos.y );
  tTextCenter.x += 0.5 * aTextDimensions.x * ( min_abs( sqrt(2) * cos( aAnchorAngle ), signof( cos( aAnchorAngle ) ) ) );
  tTextCenter.y += 0.5 * aTextDimensions.y * ( min_abs( sqrt(2) * sin( aAnchorAngle ), signof( sin( aAnchorAngle ) ) ) );

  return tTextCenter;
}

public ArrayList<String> wrapTextForDisplay( String aTextString, float aTextMaxWidth )
{
  ArrayList<String> tDisplayStrings = new ArrayList<String>();

  String[] tLines = split( aTextString, "\n" );

  for ( int iLineIndex = 0; iLineIndex < tLines.length; ++iLineIndex )
  {
    String[] tWords = split( tLines[iLineIndex], " " ); 

    String tCurrentString = tWords[0];
    for ( int iWordIndex = 1; iWordIndex < tWords.length; ++iWordIndex )
    {
      String tWidthTestString = tCurrentString + " " + tWords[iWordIndex]; 
      float tWidth = textWidth( tWidthTestString );
      if ( textWidth( tCurrentString ) > aTextMaxWidth )
      {
        tDisplayStrings.add( tCurrentString );
        tCurrentString = new String( tWords[iWordIndex] );
      }
      else if ( tWidth > aTextMaxWidth )
      {
        tDisplayStrings.add( tCurrentString );
        tCurrentString = new String( tWords[iWordIndex] );
      }
      else
      {
        tCurrentString = tWidthTestString;
      }
    }
    tDisplayStrings.add( tCurrentString );
  }

  return tDisplayStrings;
}

