class TSW_UIOverlay_AbilityDescriptions extends UIOverlay
{
  TSW_UIControl_AbilityTree abilityTree;

  public TSW_UIOverlay_AbilityDescriptions( Global_Boolean aActivated )
  {
    super( aActivated, new PVector( 0, 0 ) );
  }

  public void setup( TSW_UIControl_AbilityTree aAbilityTree )
  {
    super.setup();

    abilityTree = aAbilityTree;
  }

  public void update()
  {
    controls.clear();

    for( TSW_UIControl_Ability iAbilityWidget : abilityTree.selectedAbilities )
    {
      // create a new ability widget
      //println( iAbilityWidget.linkedNode );
    } 

    super.update();
  }

  public boolean isMouseIn()
  {
    return false;
  }

  protected void drawObscurer()
  {
  }
}



class TSW_UIControl_AbilityDescription extends UIControl
{
  float textWidth;
  
  String displayString_wordWrapped;
  int displayString_lines;
  
  float textLeading;
  
  public TSW_UIControl_AbilityDescription()
  {
    super( new Rectangle() );
    
    textWidth = 200;
    
    displayString_wordWrapped = "";
    displayString_lines = 0;
  }
  
  public void update()
  {
    super.update();
  }
  
  public void draw()
  {
    super.draw();
    
    noStroke();
    //fill( displayColor );
    //textFont( displayFont );
    textAlign( CENTER, CENTER );

    //PVector tTextDimensions = calcTextDimensions();
    //PVector tTextCenter = calcArcAnchoredTextCenter( tTextDimensions );

    rectMode( CENTER );
    //text( displayString, tTextCenter.x, tTextCenter.y, tTextDimensions.x, tTextDimensions.y );

    if ( global_debug )
    {
      noFill();
      stroke( 0, 0, 0.3 );
      strokeCap( SQUARE );
      strokeWeight( 1 );
      //rect( tTextCenter.x, tTextCenter.y, tTextDimensions.x, tTextDimensions.y );
    }

    rectMode( CORNER );
  }
  
  
}
