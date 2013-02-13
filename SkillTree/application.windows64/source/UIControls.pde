class UIControl
{
  protected Rectangle rect;
  
  protected UIControl( Rectangle aRect )
  {
    rect = new Rectangle( aRect );
  }
  
  public void setup() {};
  public void update() {};
  public void draw() {};
  
  public boolean isMouseIn()
  {
    return false;
  }
  
  public void onMouseReleased()
  {
  }
}





class UIControl_Slider extends UIControl
{
  protected String label;
  protected float min, max;
  protected float value;
  
  public Global_Float linkedValue;

  Rectangle valueExtents;
  
  public UIControl_Slider( float aMin, float aMax, Rectangle aRect )
  {
    super( aRect );
    
    min = aMin;
    max = aMax;
    value = min;
    
    valueExtents = new Rectangle( rect.x + rect.height - 1, rect.y - 2, rect.width - 2 * ( rect.height - 1 ), rect.height + 2 * 2 );  
  }
  
  
  
  public void setup( Global_Float aLinkedValue )
  {
    super.setup();
    
    linkedValue = aLinkedValue;
    value = linkedValue.value;
  }
  
  public void update()
  {
    super.update();
    
    if( this == activeControl )
    {
      value = min + ( max - min ) * ( mouseX - valueExtents.x ) / ( valueExtents.width );
      
      if( value < min ) { value = min; }
      if( value > max ) { value = max; }
      
      linkedValue.value = value;
    }
  }

  public void draw()
  {
    super.draw();
    
    noStroke();
    fill( 0, 0, 1, 0.15 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1, 0.3 ); } 
    
    rect( rect.x, rect.y, rect.width, rect.height, rect.height / 2.0 );
    
    fill( 0, 0, 1 );
    textFont( font_label );
    textAlign( LEFT, BOTTOM );
    text( label, rect.x, rect.y - 2 );
    
    

    float tValueX =  valueExtents.x + valueExtents.width * ( linkedValue.value - min ) / ( max - min );

    fill( 0, 0, 0.6 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1 ); }
    
    rect( tValueX - 1, valueExtents.y, 2, valueExtents.height );
    

    textFont( font_value );
    textAlign( LEFT, TOP );
    text( linkedValue.value, tValueX, rect.y + rect.height + 2 );
  }
  
  
  public boolean isMouseIn()
  {
    return rect.contains( mouseX, mouseY );
  }
  
  
  public void setLabel( String aLabel )
  {
    label = aLabel;
  }
}




class UIControl_Switch extends UIControl
{
  protected String label;
  protected float value;
  
  final float switchWidth = 0.55;
  
  public Global_Boolean linkedValue;
  DampingHelper_Float valueDamper;

  Rectangle valueExtents;
  
  public UIControl_Switch( Rectangle aRect )
  {
    super( aRect );
    
    value = 0.0;
    
    int tBorder = 3;
    valueExtents = new Rectangle( rect.x + tBorder, rect.y + tBorder, rect.width - tBorder*2 - round( rect.width * switchWidth ), rect.height - tBorder*2 );  
  }
  
  
  
  public void setup( Global_Boolean aLinkedValue )
  {
    super.setup();
    
    linkedValue = aLinkedValue;
    value = linkedValue.value ? 1.0 : 0.0;
    
    valueDamper = new DampingHelper_Float( 0.3, value );
  }
  
  public void update()
  {
    super.update();
    
    if( this == activeControl )
    {
      value = ( mouseX - rect.width * switchWidth * 0.5 - valueExtents.x ) * 1.0 / valueExtents.width;
      if( value < 0.0 ) { value = 0.0; }
      if( value > 1.0 ) { value = 1.0; }
      
      valueDamper.currentValue = value;
    }
    else
    {
      value = linkedValue.value ? 1.0 : 0.0;
      
    }
    valueDamper.update( value );

    linkedValue.value = valueDamper.getValue() >= 0.5;
  }

  public void draw()
  {
    super.draw();
    
    noStroke();
    fill( 0, 0, 1, 0.15 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1, 0.3 ); } 
    
    rect( rect.x, rect.y, rect.width, rect.height, rect.height / 2.0 );
    
    fill( 0, 0, 1 );
    textFont( font_label );
    textAlign( LEFT, BOTTOM );
    text( label, rect.x, rect.y - 2 );
    
    
    float tBrightness = 0.6;
    if( this == hoveredControl || this == activeControl ) { tBrightness = 1; }
    if( !linkedValue.value ) { tBrightness *= 0.5; }
    fill( 0, 0, 1, tBrightness );

    rect( valueExtents.x + valueDamper.getValue() * valueExtents.width, valueExtents.y, rect.width * switchWidth, valueExtents.height, valueExtents.height / 2.0 );
    

    textFont( font_value );
    textAlign( LEFT, TOP );
    //text( linkedValue.value, tValueX, rect.y + rect.height + 2 );
  }
  
  
  public boolean isMouseIn()
  {
    return rect.contains( mouseX, mouseY );
  }
  
  
  public void setLabel( String aLabel )
  {
    label = aLabel;
  }
}
