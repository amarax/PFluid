interface AnimHelper_Float
{
  float getValue();
  
  void update( float aNewValue );
}


class DampingHelper_Float implements AnimHelper_Float
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

  void setDampingFactor( float aDampingFactor )
  {
    dampingFactor = aDampingFactor;
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
  
  void setDampingFactor( float aDampingFactor )
  {
    xDamper.setDampingFactor( aDampingFactor );
    yDamper.setDampingFactor( aDampingFactor );
  }
}




class EasingHelper_Float implements AnimHelper_Float
{
  float startValue; 
  float transitionTime;  // in seconds
  
  float currentValue;
  protected int startTime;
  
  EasingHelper_Float( float aInitialValue )
  {
    startValue = aInitialValue;
    currentValue = aInitialValue;
    transitionTime = 0;
    startTime = 0;
  }
  
  void start( float aStartValue, float aTransitionTime )
  {
    startValue = aStartValue;
    transitionTime = aTransitionTime;
    
    currentValue = startValue;
    startTime = millis();
  }
  
  void update( float aActualValue )
  {
    float tCurrentTime = ( millis() - startTime ) / 1000.0;
    
    float tFactor = sin( -HALF_PI + PI * ( tCurrentTime / transitionTime ) );
    tFactor = 0.5 * tFactor + 0.5;
    tFactor = pow( tFactor, 1 );
   
    if( tCurrentTime < transitionTime )
    {
      currentValue = ( 1 - tFactor ) * startValue + tFactor * aActualValue;
    }
    else
    {
      currentValue = aActualValue;
    }
  }
  
  float getValue()
  {
    return currentValue;
  }
}

class EasingHelper_PVector
{
  EasingHelper_Float xEaser;
  EasingHelper_Float yEaser;
  
  EasingHelper_PVector( PVector aInitialValue )
  {
    xEaser = new EasingHelper_Float( aInitialValue.x );
    yEaser = new EasingHelper_Float( aInitialValue.y );
  }
  
  void start( PVector aStartValue, float aTransitionTime )
  {
    xEaser.start( aStartValue.x, aTransitionTime );
    yEaser.start( aStartValue.y, aTransitionTime );
  }
  
  void update( PVector aActualValue )
  {
    xEaser.update( aActualValue.x );
    yEaser.update( aActualValue.y );
  }
  
  PVector getValue()
  {
    return new PVector( xEaser.getValue(), yEaser.getValue() );
  }
  
  boolean getCompleted()
  {
    return ( ( millis() - xEaser.startTime ) / 1000.0 ) < xEaser.transitionTime && ( ( millis() - yEaser.startTime ) / 1000.0 ) < yEaser.transitionTime; 
  }
}


// Special class
class EasingHelper_Float_InOutIn extends EasingHelper_Float
{
  EasingHelper_Float_InOutIn( float aInitialValue )
  {
    super( aInitialValue );
  }
  
  void start( float aTransitionTime )
  {
    super.start( currentValue, aTransitionTime );
  }
  
  void update( float aActualValue )
  {
    float tCurrentTime = ( millis() - startTime ) / 1000.0;
    
    float tFactor = sin( -HALF_PI + TWO_PI * ( tCurrentTime / transitionTime ) );
    tFactor = 0.5 * tFactor + 0.5;
    tFactor = pow( tFactor, 1 );
   
    if( tCurrentTime < transitionTime )
    {
      float tNewStartValue = startValue * ( 1 - tCurrentTime / transitionTime );
      currentValue = ( 1 - tFactor ) * tNewStartValue + tFactor * aActualValue;
    }
    else
    {
      currentValue = 0;
      startValue = 0;
    }
  }
  
  float getRatio()
  {
    return min( ( millis() - startTime ) / ( 1000.0 * transitionTime ), 1 );
  }
}
