
class Button extends Entity
{
  String label;
  PVector size;

  boolean inEffect; 

  Button( String aLabel, float aWidth, float aHeight )
  {
    label = aLabel;
    size = new PVector( aWidth, aHeight );
  }

  void update()
  {
    super.update();
  }

  void plot()
  {
    super.plot();

    color tBackground = calcBackgroundColor();
    noStroke();
    fill( tBackground );
    rect( position.x, position.y, size.x, size.y );

    fill( color_buttonText );
    textAlign( CENTER, CENTER );
    textFont( font_default );
    text( label, position.x + size.x / 2.0, position.y + size.y / 2.0 );
  }

  boolean isMouseInside()
  {
    Rectangle tBounds = new Rectangle( floor( position.x ), floor( position.y ), ceil( size.x ), ceil( size.y ) );
    return tBounds.contains( mouseCursor.position.x, mouseCursor.position.y );
  }

  color calcBackgroundColor()
  {
    if ( mouseCursor.focusedEntity == this )
    {
      return color_buttonBg_pressed;
    } 
    else if ( mouseCursor.hoveredEntity == this )
    {
      return color_buttonBg_hover;
    }
    return color_buttonBg_default;
  }
}

class UIModeButton extends Button
{
  int associatedUIMode;

  UIModeButton( String aLabel, float aWidth, float aHeight, int aUIMode )
  {
    super( aLabel, aWidth, aHeight );
    associatedUIMode = aUIMode;
  }

  void processMousePressed()
  {
    super.processMousePressed();

    uiModeManager.setModeClean( associatedUIMode );
  }

  color calcBackgroundColor()
  {
    if ( mouseCursor.hoveredEntity != this && mouseCursor.focusedEntity != this &&  abs( uiModeManager.currentMode - associatedUIMode ) < 5 )
    {
      return color_buttonBg_inEffect;
    }
    return super.calcBackgroundColor();
  }
}

class UIActionButton extends Button
{
  I_UIAction uiAction;

  UIActionButton( String aLabel, float aWidth, float aHeight, I_UIAction aUIAction )
  {
    super( aLabel, aWidth, aHeight );
    uiAction = aUIAction;
  }

  void processMousePressed()
  {
    super.processMousePressed();

    uiAction.execute();
    mouseCursor.focusLocked = false;
  }
}

