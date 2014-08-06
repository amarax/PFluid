
static int UIMODE_RESIZABLE = 10;
static int UIMODE_RESIZING = 11;

static int UIMODE_PINNABLE = 20;
static int UIMODE_PINNING = 21;

class UIModeManager
{
  int currentMode = 10;

  void update()
  {
    if ( keyBuffer.contains( 'p' ) )
    {
      currentMode = UIMODE_PINNABLE;
    }
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
      }

      fill( color_debug );
      textAlign( LEFT, BOTTOM );
      textFont( font_debug );
      text( tDebugText, tScreenPos.x, height - 1 );
    }
  }
}

