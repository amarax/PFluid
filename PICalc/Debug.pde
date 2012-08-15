PFont fontDebugLabel;
PFont fontDebugValue;

int positionlessEntityCount;

class DebugOverlay
{
  boolean enabled;

  DebugOverlay()
  {
    fontDebugLabel = loadFont( "HelveticaNeue-Bold-8.vlw");
    fontDebugValue = loadFont( "HelveticaNeue-8.vlw");
    enabled = false;
  }

  void drawDebug()
  {
    positionlessEntityCount = 0;

    fill( 0, 1, 0, 0.3 );
    noStroke();
    rect( 0, 0, width, height );

    world.drawDebug();

    // Draw entity debugs
    Iterator iWorldEntity = world.entities.iterator();
    while ( iWorldEntity.hasNext () )
    {
      Entity tEntity = (Entity)iWorldEntity.next();
      tEntity.drawDebug();
    }

    // Draw flow debugs
    world.flowManager.drawDebug();


    if ( true )
    {
      textAlign( LEFT, BASELINE );
      textFont( fontDebugLabel );

      fill ( 0, 0, 1, 0.4 );
      text( "HOVERED", 10, height - 20 );

      fill ( 0, 0, 1, 0.7 );
      text( "SELECTED", 10, height - 10 );

      float tLongestMidpoint = 0;
      PVector tMidPoint = new PVector( 0, height - 13 );
      for ( int i = 0; i < selectedEntities.size(); i++ )
      {
        PVector tScreenPos = selectedEntities.get( i ).position.toScreen();

        stroke ( 0, 0, 1, 0.7 );
        strokeWeight( 1 );
        noFill();

        tMidPoint.x = max( 100, 100 + (tScreenPos.x - 100) * 0.5 );
        tLongestMidpoint = max( tLongestMidpoint, tMidPoint.x );
        line( tMidPoint.x, tMidPoint.y, tScreenPos.x, tScreenPos.y );
      }
      if ( selectedEntities.size() > 0 )
      {
        line( 55, tMidPoint.y, tLongestMidpoint - 1, tMidPoint.y );
      }

      if ( hoveredEntity != null )
      {
        PVector tScreenPos = hoveredEntity.position.toScreen();

        stroke ( 0, 0, 1, 0.4 );
        strokeWeight( 1 );
        noFill();

        tMidPoint = new PVector( 100 + (tScreenPos.x - 100) * 0.5, height - 23 );
        tMidPoint.x = max( 100, tMidPoint.x );
        line( tMidPoint.x, tMidPoint.y, tScreenPos.x, tScreenPos.y );
        line( 52, tMidPoint.y, tMidPoint.x - 1, tMidPoint.y );
      }

      if ( mousePressedPos != null )
      {
        stroke ( 0, 0, 1, 0.4 );
        strokeWeight( 1 );
        noFill();

        float tCrossSize = 10;
        line ( mousePressedPos.x - tCrossSize, mousePressedPos.y, mousePressedPos.x + tCrossSize, mousePressedPos.y );
        line ( mousePressedPos.x, mousePressedPos.y - tCrossSize, mousePressedPos.x, mousePressedPos.y + tCrossSize );
        line ( mousePressedPos.x, mousePressedPos.y, mouseX, mouseY );
      }

      String tUIContext = "CONTEXT";
      switch( currentUIContext )
      {
      case UI_CONTEXT_ENUMS.UI_CONTEXT_DEFAULT:
        tUIContext = "UI_CONTEXT_DEFAULT";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_PANNING:
        tUIContext = "UI_CONTEXT_PANNING";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_MOVINGENTITY:
        tUIContext = "UI_CONTEXT_MOVINGENTITY";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_DRAGGINGENTITY:
        tUIContext = "UI_CONTEXT_DRAGGINGENTITY";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_EXTRACTOR:
        tUIContext = "UI_CONTEXT_ADDING_EXTRACTOR";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_EXTRACTOR_YIELD:
        tUIContext = "UI_CONTEXT_EDITING_EXTRACTOR_YIELD";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_ADDING_FACTORY:
        tUIContext = "UI_CONTEXT_ADDING_FACTORY";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_EDITING_FACTORY_TIER:
        tUIContext = "UI_CONTEXT_EDITING_FACTORY_TIER";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_LINKING:
        tUIContext = "UI_CONTEXT_LINKING";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_CONSOLIDATING:
        tUIContext = "UI_CONTEXT_CONSOLIDATING";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_ADDING:
        tUIContext = "UI_CONTEXT_GRAPH_ADDING";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGEXTENTS:
        tUIContext = "UI_CONTEXT_GRAPH_SETTINGEXTENTS";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_START:
        tUIContext = "UI_CONTEXT_GRAPH_SETTINGVALUE_START";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SETTINGVALUE_END:
        tUIContext = "UI_CONTEXT_GRAPH_SETTINGVALUE_END";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_GRAPH_SHIFTINGVALUES:
        tUIContext = "UI_CONTEXT_GRAPH_SHIFTINGVALUES";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_ADDING:
        tUIContext = "UI_CONTEXT_TREEVIEW_ADDING";
        break;
      case UI_CONTEXT_ENUMS.UI_CONTEXT_TREEVIEW_SETEXTENTS:
        tUIContext = "UI_CONTEXT_TREEVIEW_SETEXTENTS";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_ADDING:
        tUIContext = "UI_CONTEXT_MARKETNODE_ADDING";
        break;

      case UI_CONTEXT_ENUMS.UI_CONTEXT_MARKETNODE_SETTINGEXTENTS:
        tUIContext = "UI_CONTEXT_MARKETNODE_SETTINGEXTENTS";
        break;


      default:
      }

      noStroke();
      fill( 0, 0, 1 );
      textFont( fontDebugLabel );
      textAlign( RIGHT, TOP );
      text( tUIContext, width - 10, 10 );
    }
  }
}


void debug_cross( PVector aScreenPos, float aCrossSize )
{
  line ( aScreenPos.x - aCrossSize, aScreenPos.y, aScreenPos.x + aCrossSize, aScreenPos.y );
  line ( aScreenPos.x, aScreenPos.y - aCrossSize, aScreenPos.x, aScreenPos.y + aCrossSize );
}

