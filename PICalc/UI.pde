import java.awt.Rectangle;


int currentUIContext = UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT;

boolean shiftPressed = false;

//Entity selectedEntity;
Entity hoveredEntity;

ArrayList<Entity> selectedEntities = new ArrayList<Entity>();

static class UI_CONTEXT_ENUMS
{
  final static int UI_CONTEXT_DEFAULT = 0;
  final static int UI_CONTEXT_PANNING = 1;
  final static int UI_CONTEXT_MOVINGENTITY = 5;
  final static int UI_CONTEXT_DRAGGINGENTITY = 7;

  final static int UI_CONTEXT_ADDING_EXTRACTOR = 10;
  final static int UI_CONTEXT_EDITING_EXTRACTOR_YIELD = 11;

  final static int UI_CONTEXT_ADDING_FACTORY = 20;
  final static int UI_CONTEXT_EDITING_FACTORY_TIER = 21;

  final static int UI_CONTEXT_LINKING = 30;
  final static int UI_CONTEXT_CONSOLIDATING = 31;

  final static int UI_CONTEXT_GRAPH_ADDING = 100;
  final static int UI_CONTEXT_GRAPH_SETTINGEXTENTS = 101;
  final static int UI_CONTEXT_GRAPH_SETTINGVALUE_START = 111;
  final static int UI_CONTEXT_GRAPH_SETTINGVALUE_END = 112;
  final static int UI_CONTEXT_GRAPH_SHIFTINGVALUES = 113;

  final static int UI_CONTEXT_TREEVIEW_ADDING = 200;
  final static int UI_CONTEXT_TREEVIEW_SETEXTENTS = 201;
  
  final static int UI_CONTEXT_MARKETNODE_ADDING = 300;
  final static int UI_CONTEXT_MARKETNODE_SETTINGEXTENTS = 301;
}

void select( Entity aEntity )
{
  if( !selectedEntities.contains( aEntity ) )
  {
    selectedEntities.add( aEntity );
  }
}

boolean isSelected( Entity aEntity )
{
  Iterator<Entity> iEntities = selectedEntities.iterator();
  while ( iEntities.hasNext () )
  {
    if ( iEntities.next() == aEntity )
    {
      return true;
    }
  }
  return false;
}

class UICamera
{
  PVector screenOffset;
  float screenScale;

  DampingHelper_PVector screenOffsetDamping;
  DampingHelper_Float screenScaleDamping;

  UICamera()
  {
    screenOffset = new PVector( 0, 0 );
    screenScale = 1;

    float tDampingFactor = 0.3;
    screenOffsetDamping = new DampingHelper_PVector( tDampingFactor, screenOffset );
    screenScaleDamping = new DampingHelper_Float( tDampingFactor, screenScale );
  }

  void update()
  {
    screenOffsetDamping.update( screenOffset );
    screenScaleDamping.update( screenScale );
  }

  PVector getOffset()
  {
    PVector tOffset = screenOffsetDamping.getValue();
    return new PVector( tOffset.x, tOffset.y );
  }

  float getScale()
  {
    return screenScaleDamping.getValue();
  }
}


class UICursor
{
  FlowPI cursorFlow;
  PINode cursorNode;

  HashMap< Entity, PVector > cursorOffsets;

  UICursor()
  {
    cursorOffsets = new HashMap< Entity, PVector >();
  }

  void plot()
  {
    PVector tPos;
    switch( currentUIContext )
    {
    case UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_EXTRACTOR:
      noStroke();
      fill( 180, 1, 0.8 );

      tPos = new PVector( mouseX, mouseY );
      if ( mousePressedPos != null )
      {
        tPos = mousePressedPos;
      }
      rect( tPos.x, tPos.y, 120 * uiCam.getScale(), 1 );
      break;
    case UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_FACTORY:
      noStroke();
      fill( 40, 1, 0.8 );

      tPos = new PVector( mouseX, mouseY );
      if ( mousePressedPos != null )
      {
        tPos = mousePressedPos;
      }
      rect( tPos.x, tPos.y, 120 * uiCam.getScale(), 1 );
      break;
    case UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING:
      if ( selectedEntities.size() == 1 )
      {
        if ( selectedEntities.get( 0 ) instanceof FlowNodePI )
        {
          FlowNodePI tSourceFlowNode = (FlowNodePI)( selectedEntities.get( 0 ) );

          cursorFlow.targetNode = null;

          PVector tTarget = new PVector( mouseX, mouseY );
          if ( hoveredEntity != null )
          {
            if ( hoveredEntity instanceof FlowNodePI && hoveredEntity != tSourceFlowNode )
            {
              FlowNodePI tTargetFlowNode = (FlowNodePI)hoveredEntity;

              cursorFlow.targetNode = tTargetFlowNode;
            }
          }
        }
      }
      break;
    case UI_CONTEXT_ENUMS.UI_CONTEXT_CONSOLIDATING:
      if ( cursorNode != null )
      {
        cursorNode.position = worldPosFromScreen( new PVector( mouseX, mouseY ) );
      }
      break;
    case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_ADDING:
    case UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_ADDING:
    case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_ADDING:
    case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGEXTENTS:
    case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_SETTINGEXTENTS:
      PVector tMousePos = new PVector( mouseX, mouseY );
      stroke ( 0, 0, 1 );
      strokeWeight( 1 );
      noFill();

      float tCrossSize = 5;
      line ( tMousePos.x - tCrossSize, tMousePos.y, tMousePos.x + tCrossSize, tMousePos.y );
      line ( tMousePos.x, tMousePos.y - tCrossSize, tMousePos.x, tMousePos.y + tCrossSize );

      break;

    case UI_CONTEXT_ENUMS.UI_CONTEXT_MOVINGENTITY:
      WorldPosition tEntityPosition;
      for ( int iSelectedEntity = 0; iSelectedEntity < selectedEntities.size(); iSelectedEntity++ )
      {
        Entity tEntity = selectedEntities.get( iSelectedEntity );
        if ( cursorOffsets.containsKey( tEntity ) )
        {
          tEntityPosition = worldPosFromScreen( new PVector( mouseX, mouseY ) );
          tEntityPosition.sub( cursorOffsets.get( tEntity ) );
          tEntity.moveTo( tEntityPosition );
        }
      }
      break;

    default:
    }
  }
}

boolean saveCanvas( String aFilename )
{
  // Somehow it's not easy to clear the XMLElement of all its children
  int tTotalChildren = canvasXML.getChildCount(); 
  for ( int i = 0; i < tTotalChildren; i++ )
  {
    canvasXML.removeChild( 0 );
  }
  canvasXML.setName( "Canvas" );

  XMLElement tSnapshot;

  tSnapshot = new XMLElement();
  tSnapshot.setName( "Snapshot" );
  canvasXML.addChild( tSnapshot );

  tSnapshot.addChild( world.toXML() );

  try
  {
    canvasXML.save( aFilename );
  }
  catch( Exception e )
  {
    println( e );
  }

  println( "CANVAS> saved." );
  return true;
}

