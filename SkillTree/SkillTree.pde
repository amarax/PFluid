import java.awt.*;


PFont font_label;
PFont font_value;

PFont font_TSW_Title;
PFont font_TSW_Subtitle;
PFont font_TSW_AbilityTree;
PFont font_TSW_AbilityName;
PFont font_TSW_AbilityDescription;

PFont font_FilterName;
PFont font_FilterDetail;

TSW_AbilityTree abilityTreeData;
TSW_WikiParser wikiParser;

TSW_UIControl_AbilityTree abilityTreeWidget;


ArrayList<UIControl> uiControls = new ArrayList();
UIControl hoveredControl = null;
UIControl activeControl = null;

Global_Boolean global_lineMode = new Global_Boolean( false );

Global_Boolean global_filterModeExclusive = new Global_Boolean( false );

Global_Boolean global_adjustSizeMode = new Global_Boolean( false );
Global_Boolean global_editFilterMode = new Global_Boolean( false );

Global_Float global_outerRingSize = new Global_Float( 250 );
Global_Float global_innerRingSize = new Global_Float( 80 );
Global_Float ringThickness = new Global_Float( 10 );
Global_Float abilityRingThickness = new Global_Float( 30 );
Global_Float branchGapSize = new Global_Float( 1 );
Global_Float abilityGapSize = new Global_Float( 0.5 );
Global_Float angleOffset = new Global_Float( 0 );
Global_Float selectedNodeRatio = new Global_Float( 0.8 );
Global_Boolean showAuxWheel = new Global_Boolean( true );
Global_Boolean sizeByPoints = new Global_Boolean( false );

boolean global_debug = false;


TSW_UIOverlay_Filter_AbilityTree filterOverlay;


void setup()
{




  size( 1440, 810 );
  //size( 1600, 900 );
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

  font_FilterName = loadFont( "HelveticaNeue-Bold-10.vlw" );
  font_FilterDetail = loadFont( "HelveticaNeue-10.vlw" );

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

  tSize = 40;
  UIControl_Switch tShowAuxWheel = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tShowAuxWheel.setLabel( "Aux Wheel" );
  uiControls.add( tShowAuxWheel );
  tYPos += tOffset;

  tSize = 40;
  UIControl_Switch tSizeByPoints = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tSizeByPoints.setLabel( "AP Width" );
  uiControls.add( tSizeByPoints );
  tYPos += tOffset + 25;

//  tSize = 40;
//  UIControl_Switch tLengthByPoints = new UIControl_Switch( new Rectangle( width - tSize - 100, tYPos, tSize, 20 ) );
//  tLengthByPoints.setLabel( "AP Length" );
//  uiControls.add( tLengthByPoints );

//  tSize = 400;
//  UIControl_Slider tAngleOffsetSlider = new UIControl_Slider( -PI, PI, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
//  tAngleOffsetSlider.setLabel( "Angle Offset" );
//  uiControls.add( tAngleOffsetSlider );
//  tYPos += tOffset;

  tModeSwitch.setup( global_lineMode );


  tShowAuxWheel.setup( showAuxWheel );
  tSizeByPoints.setup( sizeByPoints );

  abilityTreeWidget.setup();


  filterOverlay = new TSW_UIOverlay_Filter_AbilityTree( global_editFilterMode );
  uiControls.add( filterOverlay );
  filterOverlay.setup( abilityTreeWidget );

  tSize = 40;
  UIControl_Switch tSwitch_FilterModeExclusive = new UIControl_Switch( new Rectangle( width - tSize - 50 - 25, tYPos, tSize, 20 ) );
  tSwitch_FilterModeExclusive.setLabel( "Filter Mode" );
  tSwitch_FilterModeExclusive.setOnOffLabels( "Inclusive", "Exclusive" );
  uiControls.add( tSwitch_FilterModeExclusive );
  filterOverlay.addControl( tSwitch_FilterModeExclusive );
  tYPos += tOffset;

  tSwitch_FilterModeExclusive.setup( global_filterModeExclusive );

  TSW_Filter_Ability tFilter;

  tFilter = new TSW_Filter_Ability_Description( "afflict" );
  tFilter.active = false;
  abilityTreeWidget.addFilter( tFilter );

  tFilter = new TSW_Filter_Ability_Description( "glanc" );
  tFilter.active = false;
  abilityTreeWidget.addFilter( tFilter );

  tFilter = new TSW_Filter_Ability_Unlocked( true );
  tFilter.active = false;
  abilityTreeWidget.addFilter( tFilter );

  tFilter = new TSW_Filter_Ability_Selected( true );
  tFilter.active = false;
  abilityTreeWidget.addFilter( tFilter );

  //tFilter = new TSW_Filter_Ability_Name( "Ability)" );
  //tFilter.active = false;
  //abilityTreeWidget.addFilter( tFilter );


  TSW_UIOverlay_SizeAdjust_AbilityTree tAdjustSizeOverlay = new TSW_UIOverlay_SizeAdjust_AbilityTree( global_adjustSizeMode );
  uiControls.add( tAdjustSizeOverlay );
  tAdjustSizeOverlay.setup( abilityTreeWidget );

  tSize = 215;
  UIControl_Slider tSizeSlider = new UIControl_Slider( 20, tSize * 2 + 20, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tSizeSlider.setLabel( "Outer Ring Size" );
  uiControls.add( tSizeSlider );
  tAdjustSizeOverlay.addControl( tSizeSlider );
  tYPos += tOffset;

  UIControl_RadiusGizmo tOuterRingSizeRadius = new UIControl_RadiusGizmo( abilityTreeWidget.centerPos );
  tOuterRingSizeRadius.setup( global_outerRingSize );
  uiControls.add( tOuterRingSizeRadius );
  tAdjustSizeOverlay.addControl( tOuterRingSizeRadius );

  tSize = 215;
  UIControl_Slider tInnerSizeSlider = new UIControl_Slider( 20, tSize * 2 + 20, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tInnerSizeSlider.setLabel( "Inner Ring Distance from Outer Ring" );
  uiControls.add( tInnerSizeSlider );
  tAdjustSizeOverlay.addControl( tInnerSizeSlider );
  tYPos += tOffset;

  TSW_UIControl_RadiusGizmo_InnerRing tInnerRingSizeRadius = new TSW_UIControl_RadiusGizmo_InnerRing( abilityTreeWidget.centerPos );
  tInnerRingSizeRadius.setup( global_innerRingSize, global_outerRingSize );
  uiControls.add( tInnerRingSizeRadius );
  tAdjustSizeOverlay.addControl( tInnerRingSizeRadius );

  tSize = 200;
  UIControl_Slider tArcThicknessSlider = new UIControl_Slider( 0, tSize/2, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tArcThicknessSlider.setLabel( "Branch Ring Thickness" );
  uiControls.add( tArcThicknessSlider );
  tAdjustSizeOverlay.addControl( tArcThicknessSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tAbilityArcThicknessSlider = new UIControl_Slider( 0, tSize/2, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tAbilityArcThicknessSlider.setLabel( "Ability Ring Thickness" );
  uiControls.add( tAbilityArcThicknessSlider );
  tAdjustSizeOverlay.addControl( tAbilityArcThicknessSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tGapSizeSlider = new UIControl_Slider( 0, 5, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tGapSizeSlider.setLabel( "Gap between Branches" );
  uiControls.add( tGapSizeSlider );
  tAdjustSizeOverlay.addControl( tGapSizeSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tAbilityGapSizeSlider = new UIControl_Slider( 0, 2, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tAbilityGapSizeSlider.setLabel( "Gap between Abilities" );
  uiControls.add( tAbilityGapSizeSlider );
  tAdjustSizeOverlay.addControl( tAbilityGapSizeSlider );
  tYPos += tOffset;

  tSize = 200;
  UIControl_Slider tSelectionSizeSlider = new UIControl_Slider( 0, 0.9999, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tSelectionSizeSlider.setLabel( "Selected Node Ratio (Size)" );
  uiControls.add( tSelectionSizeSlider );
  tAdjustSizeOverlay.addControl( tSelectionSizeSlider );
  tYPos += tOffset;


  tSizeSlider.setup( global_outerRingSize );
  tInnerSizeSlider.setup( global_innerRingSize );
  tArcThicknessSlider.setup( ringThickness );
  tAbilityArcThicknessSlider.setup( abilityRingThickness );
  tGapSizeSlider.setup( branchGapSize );
  tAbilityGapSizeSlider.setup( abilityGapSize );
//  tAngleOffsetSlider.setup( angleOffset );
  tSelectionSizeSlider.setup( selectedNodeRatio );

}


void draw()
{


  background( 0, 0, 0.15 );

  hoveredControl = null;
  for ( UIControl iUIControl : uiControls )
  {
    if( iUIControl.visible )
    {
      if ( iUIControl.isMouseIn() )
      {
        hoveredControl = iUIControl;
      }
    }
  }

  // UPDATE LOOP
  for ( UIControl iUIControl : uiControls )
  {
    iUIControl.update();
  }


  // SORT DRAW ORDER
  ArrayList<UIControl> tToMoveToFront = new ArrayList<UIControl>();
  
  tToMoveToFront.add( filterOverlay );
  for( UIControl iOverlayChild : filterOverlay.controls.keySet() ) { tToMoveToFront.add( iOverlayChild ); }
  
  // HACK bring forward abilities that pass the filter
  tToMoveToFront.addAll( abilityTreeWidget.getControlsThatPassFilters() );

  for( UIControl iUIControl : uiControls )
  {
    // Make sure overalays remain on top
    if( iUIControl instanceof UIOverlay )
    {
      UIOverlay tOverlay = (UIOverlay)iUIControl;
      if( tOverlay != filterOverlay )  // Except for the filter overlay
      {
        tToMoveToFront.add( tOverlay );
        for( UIControl iOverlayChild : tOverlay.controls.keySet() ) { tToMoveToFront.add( iOverlayChild ); }
      }
    }
  }
  
  for( UIControl iUIControl : tToMoveToFront )
  {
    uiControls.remove( iUIControl );
  }
  for( UIControl iUIControl : tToMoveToFront )
  {
    uiControls.add( iUIControl );
  }


  // DRAW LOOP
  for ( UIControl iUIControl : uiControls )
  {
    if( iUIControl.visible )
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

void keyPressed()
{
  switch( key )
  {
    case 32:
      global_adjustSizeMode.value = !global_adjustSizeMode.value;
      break;
    case 'f':
      global_editFilterMode.value = !global_editFilterMode.value;
      //firstFilter.active = !firstFilter.active;
      break;

    case '1':
    case '2':
    case '3':
    case '4':
      int tIndex = int( key ) - 49;
      if( tIndex < abilityTreeWidget.abilityFilters.size() )
        abilityTreeWidget.abilityFilters.get( tIndex ).active = !abilityTreeWidget.abilityFilters.get( tIndex ).active;
      break;
    default:
  }
}
