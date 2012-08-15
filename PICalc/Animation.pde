class DampingHelper_Float
{
  float currentValue;
  float dampingFactor;
  
  DampingHelper_Float( float aDampingFactor, float aStartValue )
  {
    dampingFactor = aDampingFactor;
    currentValue = aStartValue;
  }
  
  void update( float aActualValue )
  {
    currentValue += ( aActualValue - currentValue ) * dampingFactor;
  }
  
  float getValue()
  {
    return currentValue;
  }
}

class DampingHelper_PVector
{
  DampingHelper_Float xDamper;
  DampingHelper_Float yDamper;
  
  DampingHelper_PVector( float aDampingFactor, PVector aStartValue )
  {
     xDamper = new DampingHelper_Float( aDampingFactor, aStartValue.x );
     yDamper = new DampingHelper_Float( aDampingFactor, aStartValue.y );
  }
  
  void update( PVector aActualValue )
  {
    xDamper.update( aActualValue.x );
    yDamper.update( aActualValue.y );
  }
  
  PVector getValue()
  {
    return new PVector( xDamper.getValue(), yDamper.getValue() );
  }
  
  void setCurrentValue( PVector aCurrentValue )
  {
    xDamper.currentValue = aCurrentValue.x;
    yDamper.currentValue = aCurrentValue.y;
  }
}

class DampingHelper_WorldPosition extends DampingHelper_PVector
{
  DampingHelper_WorldPosition( float aDampingFactor, PVector aStartValue )
  {
    super( aDampingFactor, aStartValue );
  }
  
  WorldPosition getValue()
  {
    return new WorldPosition( xDamper.getValue(), yDamper.getValue() );
  }
}

class DampingHelper_Color
{
  color currentValue;
  float dampingFactor;
  
  DampingHelper_Color( float aDampingFactor, color aStartValue )
  {
    currentValue = aStartValue;
    dampingFactor = aDampingFactor;
  }
  
  void update( color aValue )
  {
    currentValue = lerpColor( currentValue, aValue, dampingFactor );
  }
  
  color getValue()
  {
    return currentValue;
  }
}
