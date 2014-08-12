
static int UIMODE_ENTITYSPECIFIC = 1;

static int UIMODE_RESIZABLE = 10;
static int UIMODE_RESIZING = 11;

static int UIMODE_PINNABLE = 20;
static int UIMODE_PINNING = 21;

static int UIMODE_ADDING = 30;

static int UIMODE_MOVABLE = 40;
static int UIMODE_MOVING = 41;

class UIModeManager
{
  private int currentMode = 10;
  int previousMode = 10;

  void update()
  {
  }
  
  void setMode( int aNewMode )
  {
    if( aNewMode != currentMode )
    {
      previousMode = currentMode;
      currentMode = aNewMode;
    }
  }
  
  void setModeClean( int aNewMode )
  {
    setMode( aNewMode );
    mouseCursor.focusLocked = false;
    mouseCursor.focusedEntity = null;
  }

  void revertMode()
  {
    int tNewMode = previousMode;
    setMode( tNewMode );
  }

  void plotDebug()
  {
    if ( showDebug && debug_uimode )
    {
      PVector tScreenPos = new PVector( 1, 0 ); 
      float tLineSpacingFactor = 1.1;
      String tDebugText = "UIMode = ";
      switch( currentMode )
      {
      case 1:
        tDebugText += "UIMODE_ENTITYSPECIFIC";
        break;
      case 10:
        tDebugText += "UIMODE_RESIZABLE";
        break;
      case 11:
        tDebugText += "UIMODE_RESIZING";
        break;
      case 20:
        tDebugText += "UIMODE_PINNABLE";
        break;
      case 21:
        tDebugText += "UIMODE_PINNING";
        break;
      case 30:
        tDebugText += "UIMODE_ADDING";
        break;
      case 40:
        tDebugText += "UIMODE_MOVABLE";
        break;
      case 41:
        tDebugText += "UIMODE_MOVING";
        break;
      }

      fill( color_debug );
      textAlign( LEFT, BOTTOM );
      textFont( font_debug );
      text( tDebugText, tScreenPos.x, height - 1 );
    }
  }
}

