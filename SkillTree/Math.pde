

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
