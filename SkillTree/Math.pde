

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


class Angle
{
}


public float min_abs( float aValue1, float aValue2 )
{
  if( abs( aValue1 ) <= abs( aValue2 ) )
  {
    return aValue1;
  }
  
  return aValue2;
}


public int signof( float aValue1 )
{
  if( aValue1 < 0 )
  {
    return -1;
  }
  
  return 1;
}
