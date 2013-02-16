

public void pointcross( float aX, float aY, float aSize )
{
  line( aX, aY - aSize, aX, aY + aSize ); 
  line( aX - aSize, aY, aX + aSize, aY ); 
}
