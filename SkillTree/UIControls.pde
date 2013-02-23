class UIControl
{
  protected boolean visible;
  
  protected Rectangle rect;
  
  protected PVector mousePressedPos;
  
  protected AnimHelper_Float animHelper_hoverFactor;
  
  protected UIControl( Rectangle aRect )
  {
    rect = new Rectangle( aRect );
    
    visible = true;
  }
  
  public void setup() {};
  
  public void update()
  {
    if( animHelper_hoverFactor != null )
    {
      animHelper_hoverFactor.update( this == hoveredControl ? 1.0 : 0.0 );
    }
  }
  
  public void draw() {};
  
  public boolean isMouseIn()
  {
    return false;
  }
  
  public void onMousePressed()
  {
    mousePressedPos = new PVector( mouseX, mouseY );
  }
  
  public void onMouseReleased()
  {
    mousePressedPos = null;
  }
  
  public void onKeyPressed()
  {
  }

  public void onKeyTyped()
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
    value = linkedValue.getValue();
  }
  
  public void update()
  {
    super.update();
    
    if( this == activeControl )
    {
      value = min + ( max - min ) * ( mouseX - valueExtents.x ) / ( valueExtents.width );
      
      if( value < min ) { value = min; }
      if( value > max ) { value = max; }
      
      linkedValue.setValue( value );
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
    
    

    float tValueX =  valueExtents.x + valueExtents.width * ( linkedValue.getValue() - min ) / ( max - min );

    fill( 0, 0, 0.6 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1 ); }
    
    rect( tValueX - 1, valueExtents.y, 2, valueExtents.height );
    

    textFont( font_value );
    textAlign( LEFT, TOP );
    text( linkedValue.getValue(), tValueX, rect.y + rect.height + 2 );
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

  protected String labelOff, labelOn;
  
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
    value = linkedValue.getValue() ? 1.0 : 0.0;
    
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
      value = linkedValue.getValue() ? 1.0 : 0.0;
      
    }
    valueDamper.update( value );

    linkedValue.setValue( valueDamper.getValue() >= 0.5 );
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
    if( !linkedValue.getValue() ) { tBrightness *= 0.5; }
    fill( 0, 0, 1, tBrightness );

    rect( valueExtents.x + valueDamper.getValue() * valueExtents.width, valueExtents.y, rect.width * switchWidth, valueExtents.height, valueExtents.height / 2.0 );
    
    float tMargin = 2;

    fill( 0, 0, 1 );
    textFont( font_value );
    if( labelOff != null )
    {
      textAlign( RIGHT, CENTER );
      text( labelOff, rect.x - tMargin, rect.y + rect.height / 2.0 );
    }
    if( labelOn != null )
    {
      textAlign( LEFT, CENTER );
      text( labelOn, rect.x + rect.width + tMargin, rect.y + rect.height / 2.0 );
    }
  }
  
  
  public boolean isMouseIn()
  {
    return rect.contains( mouseX, mouseY );
  }
  
  
  public void setLabel( String aLabel )
  {
    label = aLabel;
  }
  
  public void setOnOffLabels( String aLabelOff, String aLabelOn )
  {
    labelOff = aLabelOff;
    labelOn = aLabelOn;
  }
}



class UIControl_RadiusGizmo extends UIControl
{
  boolean adjusting;
  
  float mouseDownDistOffset;
  
  protected PVector centerPos;
  
  Global_Float radius;
  
  public UIControl_RadiusGizmo( PVector aCenterPos )
  {
    super( new Rectangle( floor( aCenterPos.x - 1 ), floor( aCenterPos.y - 1 ), ceil( 1 * 2 ), ceil( 1 * 2 ) ) );
    
    adjusting = false;
    mouseDownDistOffset = 0;

    centerPos = new PVector( aCenterPos.x, aCenterPos.y );
  }
  
  public void setup( Global_Float aRadius )
  {
    super.setup();
    
    radius = aRadius;
  }
  
  public void update()
  {
    super.update();
    
    if( mousePressedPos != null )
    {
      if( !adjusting )
      {
        if( mousePressedPos.x != mouseX && mousePressedPos.y != mouseY )
        {
          adjusting = true;
        }
      }
    }
    
    if( adjusting )
    {
      setRadius( centerPos.dist( new PVector( mouseX, mouseY ) ) - mouseDownDistOffset );
      rect = new Rectangle( floor( centerPos.x - getRadius() ), floor( centerPos.y - getRadius() ), ceil( getRadius() * 2 ), ceil( getRadius() * 2 ) );
    }
  }
  
  public void draw()
  {
    super.draw();
    
    float tAlpha = hoveredControl == this ? 1.0 : 0.5;
    
    noFill();
    stroke( 0, 0, 0.8, tAlpha );
    strokeWeight( 2 );
    ellipseMode( RADIUS );
    float tRadius = getRadius();
    ellipse( centerPos.x, centerPos.y, tRadius, tRadius );
  }
  
  public boolean isMouseIn()
  {
    float tMouseDistance = centerPos.dist( new PVector( mouseX, mouseY ) );
    float tTolerance = 5; 
    if( tMouseDistance > getRadius() - tTolerance && tMouseDistance < getRadius() + tTolerance )
    {
      return true;
    } 
    
    return false;
  }
  
  public void onMousePressed()
  {
    super.onMousePressed();
    
    mouseDownDistOffset = centerPos.dist( new PVector( mouseX, mouseY ) ) - getRadius();
  }
  
  public void onMouseReleased()
  {
    super.onMouseReleased();
    
    adjusting = false;
  }

  public void setRadius( float aRadius )
  {
    radius.value = aRadius;
  }
  
  public float getRadius()
  {
    return radius.value;
  }
}
