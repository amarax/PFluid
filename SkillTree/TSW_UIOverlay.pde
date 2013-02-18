class TSW_UIOverlay_SizeAdjust_AbilityTree extends UIOverlay
{
  TSW_UIControl_AbilityTree abilityTreeToAdjust;
  
  public TSW_UIOverlay_SizeAdjust_AbilityTree( Global_Boolean aActivated )
  {
    super( aActivated, new PVector( 0, 0 ) );
  }
  
  public void setup( TSW_UIControl_AbilityTree aAbilityTree )
  {
    super.setup();
    
    abilityTreeToAdjust = aAbilityTree;
  }
  
  public void update()
  {
    super.update();
    
  }
  
  public void draw()
  {
    super.draw();
    
    if( activated.value )
    {
    }
  }
}


class TSW_UIControl_RadiusGizmo_InnerRing extends UIControl_RadiusGizmo
{
  Global_Float outerRingSize;
  
  public TSW_UIControl_RadiusGizmo_InnerRing( PVector aCenterPos )
  {
    super( aCenterPos );
  }
  
  public void setup( Global_Float aInnerRingSize, Global_Float aOuterRingSize )
  {
    super.setup( aInnerRingSize );
    
    outerRingSize = aOuterRingSize;
  }
  
  public void update()
  {
    super.update();
  }
  
  public void setRadius( float aRadius )
  {
    radius.value = outerRingSize.value - aRadius;
  }
  
  public float getRadius()
  {
    return outerRingSize.value - radius.value;
  }
}
