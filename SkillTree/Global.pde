
class Global_Float
{
  private float value;
  private float prevValue;
  
  public Global_Float( float aValue )
  {
    value = aValue;
    prevValue = aValue;
  }
  
  public float getValue()
  {
    return value;
  }
  
  public void setValue( float aFloat )
  {
    prevValue = value;
    value = aFloat;
  }
  
  public float getPrevValue()
  {
    return prevValue;
  }    
}



class Global_Boolean
{
  boolean value;
  boolean prevValue;
  
  public Global_Boolean( boolean aValue )
  {
    value = aValue;
  }

  public boolean getValue()
  {
    return value;
  }
  
  public void setValue( boolean aFloat )
  {
    prevValue = value;
    value = aFloat;
  }
  
  public boolean getPrevValue()
  {
    return prevValue;
  }    
}
