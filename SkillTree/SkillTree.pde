import java.awt.*;


PFont font_label;
PFont font_value;

PFont font_TSW_Title;
PFont font_TSW_Subtitle;
PFont font_TSW_AbilityTree;
PFont font_TSW_AbilityName;
PFont font_TSW_AbilityDescription;


TSW_AbilityTree abilityTreeData;
TSW_WikiParser wikiParser;

TSW_UIControl_AbilityTree abilityTreeWidget;


ArrayList<UIControl> uiControls = new ArrayList();
UIControl hoveredControl = null;
UIControl activeControl = null;

Global_Boolean global_lineMode = new Global_Boolean( false );

Global_Boolean global_adjustSizeMode = new Global_Boolean( false );

Global_Float outerRingSize = new Global_Float( 250 );
Global_Float innerRingSize = new Global_Float( 80 );
Global_Float ringThickness = new Global_Float( 10 );
Global_Float abilityRingThickness = new Global_Float( 30 );
Global_Float branchGapSize = new Global_Float( 1 );
Global_Float abilityGapSize = new Global_Float( 0.5 );
Global_Float angleOffset = new Global_Float( 0 );
Global_Float selectedNodeRatio = new Global_Float( 0.8 );
Global_Boolean showAuxWheel = new Global_Boolean( true );
Global_Boolean sizeByPoints = new Global_Boolean( false );

boolean global_debug = false;


void setup()
{




  size( 1440, 810 );
  smooth();
  colorMode( HSB, 360.0, 1.0, 1.0, 1.0 );

  frameRate( 60 );

  font_label = loadFont( "HelveticaNeue-Bold-8.vlw" );
  font_value = loadFont( "HelveticaNeue-8.vlw" );

  font_TSW_Title = loadFont( "Futura-CondensedExtraBold-18.vlw" );
  font_TSW_Subtitle = loadFont( "Futura-Medium-18.vlw" );
  font_TSW_AbilityTree = loadFont( "Futura-Medium-12.vlw" );
  font_TSW_AbilityName = loadFont( "Futura-Medium-10.vlw" );
  font_TSW_AbilityDescription = loadFont( "CenturyGothic-9.vlw" );

  abilityTreeData = new TSW_AbilityTree();
  wikiParser = new TSW_WikiParser();
  wikiParser.populate( abilityTreeData ); 

  int tSize = 400;
  abilityTreeWidget = new TSW_UIControl_AbilityTree( abilityTreeData, new Rectangle( height / 2 - tSize + 100, height / 2 - tSize, tSize * 2, tSize * 2 ) );
  uiControls.add( abilityTreeWidget );


  int tYPos = 50;
  int tOffset = 50;

  tSize = 40;
  UIControl_Switch tModeSwitch = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tModeSwitch.setLabel( "Circle / Line" );
  uiControls.add( tModeSwitch );
  tYPos += tOffset + 25;

  tSize = 215;
  UIControl_Slider tInnerSizeSlider = new UIControl_Slider( 20, tSize * 2 + 20, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tInnerSizeSlider.setLabel( "Inner Ring Distance from Outer Ring" );
  uiControls.add( tInnerSizeSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tArcThicknessSlider = new UIControl_Slider( 0, tSize/2, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tArcThicknessSlider.setLabel( "Branch Ring Thickness" );
  uiControls.add( tArcThicknessSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tAbilityArcThicknessSlider = new UIControl_Slider( 0, tSize/2, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tAbilityArcThicknessSlider.setLabel( "Ability Ring Thickness" );
  uiControls.add( tAbilityArcThicknessSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tGapSizeSlider = new UIControl_Slider( 0, 5, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tGapSizeSlider.setLabel( "Gap between Branches" );
  uiControls.add( tGapSizeSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tAbilityGapSizeSlider = new UIControl_Slider( 0, 2, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tAbilityGapSizeSlider.setLabel( "Gap between Abilities" );
  uiControls.add( tAbilityGapSizeSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tSelectionSizeSlider = new UIControl_Slider( 0, 0.9999, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tSelectionSizeSlider.setLabel( "Selected Node Ratio (Size)" );
  uiControls.add( tSelectionSizeSlider );
  tYPos += tOffset;

  tSize = 40;
  UIControl_Switch tShowAuxWheel = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tShowAuxWheel.setLabel( "Aux Wheel" );
  uiControls.add( tShowAuxWheel );
  tYPos += tOffset;

  tSize = 40;
  UIControl_Switch tSizeByPoints = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tSizeByPoints.setLabel( "AP Width" );
  uiControls.add( tSizeByPoints );

//  tSize = 40;
//  UIControl_Switch tLengthByPoints = new UIControl_Switch( new Rectangle( width - tSize - 100, tYPos, tSize, 20 ) );
//  tLengthByPoints.setLabel( "AP Length" );
//  uiControls.add( tLengthByPoints );
  tYPos += tOffset;

  tSize = 215;
  UIControl_Slider tSizeSlider = new UIControl_Slider( 20, tSize * 2 + 20, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tSizeSlider.setLabel( "Outer Ring Size" );
  uiControls.add( tSizeSlider );
  tYPos += tOffset;

//  tSize = 400;
//  UIControl_Slider tAngleOffsetSlider = new UIControl_Slider( -PI, PI, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
//  tAngleOffsetSlider.setLabel( "Angle Offset" );
//  uiControls.add( tAngleOffsetSlider );
//  tYPos += tOffset;

  tModeSwitch.setup( global_lineMode );

  tSizeSlider.setup( outerRingSize );
  tInnerSizeSlider.setup( innerRingSize );
  tArcThicknessSlider.setup( ringThickness );
  tAbilityArcThicknessSlider.setup( abilityRingThickness );
  tGapSizeSlider.setup( branchGapSize );
  tAbilityGapSizeSlider.setup( abilityGapSize );
  tSelectionSizeSlider.setup( selectedNodeRatio );
  tShowAuxWheel.setup( showAuxWheel );
  tSizeByPoints.setup( sizeByPoints );
//  tAngleOffsetSlider.setup( angleOffset );

  abilityTreeWidget.setup();
}


void draw()
{


  background( 0, 0, 0.15 );

  hoveredControl = null;
  for ( UIControl iUIControl : uiControls )
  {
    if ( iUIControl.isMouseIn() )
    {
      hoveredControl = iUIControl;
    }
  }

  // UPDATE LOOP
  for ( UIControl iUIControl : uiControls )
  {
    iUIControl.update();
  }


  // DRAW LOOP
  for ( UIControl iUIControl : uiControls )
  {
    iUIControl.draw();
  }
}

void mousePressed()
{
  activeControl = hoveredControl;
  
  if( activeControl != null )
  {
    activeControl.onMousePressed();
  }
}

void mouseReleased()
{
  if( activeControl == hoveredControl && activeControl != null )
  {
    activeControl.onMouseReleased();
  }

  activeControl = null;
}

