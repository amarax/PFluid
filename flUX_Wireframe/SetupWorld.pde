void setupWorld()
{
  setupWorld_wireframeLayout();
}

void setupWorld_editableElementTest()
{
  editableElement = new EditableElement();
  editableElement.position.set( 100, height * 0.333 );
  world.addEntity( editableElement );
  
  styleGrid = new Grid();
  world.addObject( styleGrid );
  styleGrid.addCell( 1, 0 ).cellText = "(initial)";
  
  EntityGrid tEntityGrid = new EntityGrid();
  world.addEntity( tEntityGrid );
  tEntityGrid.linkedGrid = styleGrid;
  
  tEntityGrid.position.set( width / 2.0, 90 );
}

void setupWorld_wireframeLayout()
{
  editableElement = new EditableElement();
  editableElement.position.set( width * 0.5, height * 0.5 );
  world.addEntity( editableElement );
  
  Button tButton;
  PVector tPosition = new PVector( 150, 20 );
  float tMargin = 10; 
  
  tButton = new UIModeButton( "+", 30, 30, UIMODE_ADDING );
  tButton.position.set( tPosition.x, tPosition.y );
  tPosition.x += tButton.size.x + tMargin;
  world.addEntity( tButton );
  
  tButton = new UIModeButton( "MOVE", 50, 30, UIMODE_MOVABLE );
  tButton.position.set( tPosition.x, tPosition.y );
  tPosition.x += tButton.size.x + tMargin;
  world.addEntity( tButton );
  
  tButton = new UIModeButton( "RESIZE", 50, 30, UIMODE_RESIZABLE );
  tButton.position.set( tPosition.x, tPosition.y );
  tPosition.x += tButton.size.x + tMargin;
  world.addEntity( tButton );
  
  tButton = new UIModeButton( "PIN", 50, 30, UIMODE_PINNABLE );
  tButton.position.set( tPosition.x, tPosition.y );
  tPosition.x += tButton.size.x + tMargin;
  world.addEntity( tButton );
  
  tPosition = new PVector( width - 140-20, 20 );
  
  tButton = new UIActionButton( "MIRROR CONTENTS", 140, 30, new Action_MirrorSelection() );
  tButton.position.set( tPosition.x, tPosition.y );
  tPosition.y += tButton.size.y + tMargin;
  world.addEntity( tButton );
  
  tButton = new UIActionButton( "TOGGLE PINS", 140, 30, new Action_ToggleShowPins() );
  tButton.position.set( tPosition.x, tPosition.y );
  tPosition.y += tButton.size.y + tMargin;
  world.addEntity( tButton );
  
  EditableParentList tParentList = new EditableParentList( new PVector( 20, 210 ) );
  world.addEntity( tParentList );
  
  EditableRect tSliderRect = new EditableRect( new PVector( 15, 95 ) );
  tSliderRect.getPin( PinEdge.PINEDGE_RIGHT ).updateOffset( 165 );
  tSliderRect.getPin( PinEdge.PINEDGE_BOTTOM ).updateOffset( 185 );
  world.addEntity( tSliderRect );
  
  EditableSlider tMarginSlider = new EditableSlider( new PVector( 20, 100 ), marginSize, "Margin Size" );
  tSliderRect.addChildEntity( tMarginSlider );

  tMarginSlider = new EditableSlider( new PVector( 20, 150 ), parentListChildOffset, "Child Offset" );
  tSliderRect.addChildEntity( tMarginSlider );
}
