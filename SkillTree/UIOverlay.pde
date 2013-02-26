

class UIOverlay extends UIControl
{
  Global_Boolean activated;

  PVector position;

  HashMap<UIControl, PVector> controls;

  public UIOverlay( Global_Boolean aActivated, PVector aPosition )
  {
    super( new Rectangle( 0, 0, width, height ) );

    activated = aActivated;

    position = aPosition;

    controls = new HashMap<UIControl, PVector>();
  }

  public void addControl( UIControl aControl )
  {
    controls.put( aControl, new PVector( aControl.rect.x - position.x, aControl.rect.y - position.y ) );
  }

  public void update()
  {
    super.update();

    visible = activated.value;
    for ( UIControl iControl : controls.keySet() )
    {
      iControl.visible = activated.value;
    }
  }

  public void draw()
  {
    super.draw();

    drawObscurer();
  }

  public boolean isMouseIn()
  {
    return true;
  }

  protected void drawObscurer()
  {
    noStroke();
    fill( 0, 0, 0.05, 0.4 );
    rect( 0, 0, width, height );
  }
}




