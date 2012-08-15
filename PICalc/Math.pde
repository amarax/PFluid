static class PIMath
{
  static float roundTo( float aFloat, int aDecimalDigits )
  {
    float tFloat = round( aFloat * pow( 10, aDecimalDigits ) ) / pow( 10, aDecimalDigits );
    return tFloat;
  }
}

static class PVectorMath
{
  static PVector rotateVector( PVector aVector, float aAngle )
  {
    PVector v1 = new PVector( aVector.x, aVector.y );
    PVector v2 = new PVector();
    v2.x = v1.x * cos( aAngle ) - v1.y * sin( aAngle );
    v2.y = v1.x * sin( aAngle ) + v1.y * cos( aAngle );

    return v2;
  }

  static PVector vectorFromAngleMagnitude( float aAngle, float aMagnitude )
  {
    PVector v1 = new PVector( aMagnitude, 0 );
    v1 = rotateVector( v1, aAngle );
    return v1;
  }
  
  static float calcScalarProjection( PVector aProjectedVector, PVector aOntoVector )
  {
    return aProjectedVector.dot( aOntoVector ) / aOntoVector.mag();
  }
}

static class GeometryMath
{
  // Taken from http://paulbourke.net/geometry/lineline2d/
  static boolean linesIntersect( PVector aLine1Start, PVector aLine1End, PVector aLine2Start, PVector aLine2End )
  {
    float muA, muB;
    float denominator, numeratorA, numeratorB;
    
    denominator = ( aLine2End.y - aLine2Start.y ) * ( aLine1End.x - aLine1Start.x ) - ( aLine2End.x - aLine2Start.x ) * ( aLine1End.y - aLine1Start. y );
    numeratorA = ( aLine2End.x - aLine2Start.x ) * ( aLine1Start.y - aLine2Start.y ) - ( aLine2End.y - aLine2Start.y ) * ( aLine1Start.x - aLine2Start.x );
    numeratorB = ( aLine1End.x - aLine1Start.x ) * ( aLine1Start.y - aLine2Start.y ) - ( aLine1End.y - aLine1Start.y ) * ( aLine1Start.x - aLine2Start.x );
 
    if( abs( denominator ) < EPSILON )
    {
      // Lines are parallel
      return false;
    }
    
    if( abs( numeratorA ) < EPSILON && abs( numeratorB ) < EPSILON && abs( denominator ) < EPSILON )
    {
      // Lines are co-incident
      return true;
    }
    
    muA = numeratorA / denominator;
    muB = numeratorB / denominator;
    if( muA < 0 || muA > 1 || muB < 0 || muB > 1 )
    {
      // Lines do not intersect along segments
      return false;
    }
    
    return true;
  }
}
