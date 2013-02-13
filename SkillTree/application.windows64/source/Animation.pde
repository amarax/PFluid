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
