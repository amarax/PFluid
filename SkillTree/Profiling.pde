
class UIOverlay_Profiling extends UIOverlay
{
  public UIOverlay_Profiling( Global_Boolean aActivated )
  {
    super( aActivated, new PVector( 0, 0 ) );
  }

  public void draw()
  {
    super.draw();

    float tFrameBudget = 1000.0 / 30;
    float tUpdateCycle = ( prevProfilingTimes[1] - prevProfilingTimes[0] ) * 1.0;
    float tDrawCycle = ( prevProfilingTimes[2] - prevProfilingTimes[0] ) * 1.0 - tUpdateCycle;

    float tMargin = 10;
    float tHeight = 10;

    noStroke();

    fill( 0, 0, 0.5, 0.5 );
    rect( tMargin, height - tMargin - tHeight, ( width - tMargin * 2 ) * tUpdateCycle / ( tFrameBudget * 2 ), tHeight );

    fill( 0, 0, 0.8, 0.5 );
    rect( tMargin + ( width - tMargin * 2 ) * tUpdateCycle / ( tFrameBudget * 2 ) + 1, height - tMargin - tHeight, ( width - tMargin * 2 ) * tDrawCycle / ( tFrameBudget * 2 ), tHeight );

    noFill();
    stroke( 0, 0, 0.8, 0.5 );
    strokeWeight( 1 );
    line( width / 2, height - 25, width / 2, height - 5 );
  }

  protected void drawObscurer()
  {
    //    noStroke();
    //    fill( 0, 0, 0.05, 0.4 );
    //    rect( 0, 0, width, height );
  }

  public boolean isMouseIn()
  {
    return false;
  }
}

