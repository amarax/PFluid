

void cross( float aCenterX, float aCenterY, float aSize )
{
  line( aCenterX, aCenterY - aSize, aCenterX, aCenterY + aSize );
  line( aCenterX - aSize, aCenterY, aCenterX + aSize, aCenterY );
}

void pinTriangle( float aPinX, float aPinY, float aPinTargetX, float aPinTargetY, float aSize )
{
  PVector tVector = new PVector( aPinX, aPinY );
  PVector tHeading = new PVector( aPinTargetX, aPinTargetY );
  float tAngle = tHeading.heading();
  
  PVector tTop = new PVector( -1, -0.5 );
  PVector tBottom = new PVector( -1, 0.5 );

  tTop.mult( aSize );
  tTop.rotate( tAngle );
  tTop.add( tVector );
  
  tBottom.mult( aSize );
  tBottom.rotate( tAngle );
  tBottom.add( tVector );
  
  triangle( aPinX, aPinY, tTop.x, tTop.y, tBottom.x, tBottom.y );
}

void pinArc( float aPinX, float aPinY, float aPinTargetX, float aPinTargetY, float aSize )
{
  PVector tVector = new PVector( aPinX, aPinY );
  PVector tHeading = new PVector( aPinTargetX, aPinTargetY );
  float tAngle = tHeading.heading();
  
  arc( aPinX, aPinY, aSize, aSize, tAngle - PI / 2.0, tAngle + PI / 2.0, OPEN ); 
}
