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
  editableElement.position.set( 100, height * 0.333 );
  world.addEntity( editableElement );
  
  Button tButton;
  
  tButton = new UIModeButton( "Resize", 50, 30, UIMODE_RESIZABLE );
  tButton.position.set( 300, 20 );
  world.addEntity( tButton );
  
  tButton = new UIModeButton( "Pin", 50, 30, UIMODE_PINNABLE );
  tButton.position.set( 360, 20 );
  world.addEntity( tButton );
  
  tButton = new UIActionButton( "Mirror Contents", 100, 30, new Action_MirrorSelection() );
  tButton.position.set( width - 100 -20, 20 );
  world.addEntity( tButton );
  
  tButton = new UIActionButton( "Toggle Pins", 100, 30, new Action_ToggleShowPins() );
  tButton.position.set( width - 100 -20, 20 + 30 + 10 );
  world.addEntity( tButton );
  
}
