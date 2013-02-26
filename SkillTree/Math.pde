

class Vector2
{
  float x;
  float y;

  public Vector2( float aX, float aY )
  {
    x = aX;
    y = aY;
  }

  public float distanceTo( float aX, float aY )
  {
    float tSquaredX = x - aX;
    tSquaredX *= tSquaredX;
    float tSquaredY = y - aY;
    tSquaredY *= tSquaredY;

    return sqrt( tSquaredX + tSquaredY );
  }
}


static class Angle
{
  /// Normalizes angles to between 0 to TWO_PI
  static float normalize( float aAngle )
  {
    float tAngle = aAngle % TWO_PI;
    if ( tAngle < 0 ) { 
      tAngle += TWO_PI;
    }
    return tAngle;
  }

  static boolean isWithinAngles( float aAngleToCheck, float aStartAngle, float aEndAngle )
  {
    float tAngleToCheck = Angle.normalize( aAngleToCheck );
    float tStartAngle = Angle.normalize( aStartAngle );
    float tEndAngle = Angle.normalize( aEndAngle );

    if ( tEndAngle < tStartAngle )
    {
      if ( tAngleToCheck >= ( tStartAngle - EPSILON ) && tAngleToCheck <= ( TWO_PI + EPSILON ) )
        return true;

      if ( tAngleToCheck >= ( 0 - EPSILON ) && tAngleToCheck <= ( tEndAngle + EPSILON ) )
        return true;
    }

    if ( tAngleToCheck >= ( tStartAngle - EPSILON ) && tAngleToCheck <= ( tEndAngle + EPSILON ) )
      return true;

    return false;
  }

  static float calcMidAngle( float aStartAngle, float aEndAngle )
  {
    if ( aEndAngle - aStartAngle < EPSILON)
    {
      return aStartAngle;
    }

    float tStartAngle = Angle.normalize( aStartAngle );
    float tEndAngle = Angle.normalize( aEndAngle );

    if ( tStartAngle > tEndAngle )
    {
      return Angle.normalize( ( tStartAngle + tEndAngle + TWO_PI ) / 2.0 );
    }

    return ( ( tStartAngle + tEndAngle ) / 2.0 );
  }
}


public float min_abs( float aValue1, float aValue2 )
{
  if ( abs( aValue1 ) <= abs( aValue2 ) )
  {
    return aValue1;
  }

  return aValue2;
}


public int signof( float aValue1 )
{
  if ( aValue1 < 0 )
  {
    return -1;
  }

  return 1;
}

