class UIOverlay_TextLayer extends UIOverlay
{
  ArrayList<UIOverlay_TextLayer_TextEntry> cTextEntries;

  public UIOverlay_TextLayer( Global_Boolean aActivated, PVector aPosition )
  {
    super( aActivated, aPosition );

    cTextEntries = new ArrayList<UIOverlay_TextLayer_TextEntry>();
  }

  public void flushCache()
  {
    int iIndex = 0;
    while ( iIndex < cTextEntries.size () )
    {
      if ( !cTextEntries.get( iIndex ).persistent )
      {
        cTextEntries.remove( iIndex );
      }
      else
      {
        ++iIndex;
      }
    }
  }

  public void update()
  {
    super.update();

    for ( UIOverlay_TextLayer_TextEntry iTextEntry : cTextEntries )
    {
      iTextEntry.update();
    }
  }

  public void draw()
  {
    super.draw();

    for ( UIOverlay_TextLayer_TextEntry iTextEntry : cTextEntries )
    {
      iTextEntry.draw();
    }
  }

  public boolean isMouseIn()
  {
    return false;
  }

  protected void drawObscurer()
  {
  }


  public void addTextEntry( UIOverlay_TextLayer_TextEntry aTextEntry )
  {
    cTextEntries.add( aTextEntry );
  }
}


class UIOverlay_TextLayer_TextEntry
{
  final int ANCHORTYPE_NORMAL_ALIGN = 1;
  final int ANCHORTYPE_CIRCULAR_SNAP = 256;

  String displayString;

  PFont displayFont;

  color displayColor;

  int anchorType;
  PVector anchorPos;

  int hAlign;
  int vAlign;

  boolean persistent;

  public UIOverlay_TextLayer_TextEntry()
  {
    displayString = "";
    displayFont = null;
    displayColor = color( 0, 1, 0 );

    anchorType = 1;
    anchorPos = new PVector( 0, 0 );

    hAlign = CENTER;
    vAlign = CENTER;

    persistent = false;
  }

  public void update()
  {
  }

  public void draw()
  {
    noStroke();
    fill( displayColor );
    textFont( displayFont );
    textAlign( hAlign, vAlign );

    switch( anchorType )
    {
    case ANCHORTYPE_NORMAL_ALIGN:
      {
        text( displayString, anchorPos.x, anchorPos.y );
      }
      break;
    case ANCHORTYPE_CIRCULAR_SNAP:
      {
      }
      break;
    default:
    }
  }
}

