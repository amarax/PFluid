import java.awt.event.*;

DebugOverlay debugOverlay;

World world;

PIData piData;
MarketData marketData;
EVECharacter currentCharacter;

PIUI piUI;
MarketUI marketUI;

UICamera uiCam;
UICursor uiCursor;

PFont fontLabel;
PFont fontValue;

PFont fontNodePITier;
PFont fontNodePIMaterial;

XMLElement piDataXML;
XMLElement marketDataXML;

XMLElement canvasXML;

void setup()
{
  piDataXML = new XMLElement( this, "PIData.xml" );
  marketDataXML = new XMLElement( this, "MarketData.xml" );

  currentCharacter = new EVECharacter(); // Should load from XML
  currentCharacter.taxRate = 0.0075;
  currentCharacter.brokerRate = 0.00959528230295;

  canvasXML = new XMLElement( this, "CanvasHistory.xml" );

  // APPLICATION STATE

  world = new World();

  piData = new PIData();
  piData.loadData( piDataXML );

  marketData = new MarketData();
  marketData.loadData( marketDataXML );

  // END APPLICATION STATE

  piUI = new PIUI( 2 );
  marketUI = new MarketUI( 1000000 / 1000 );

  uiCam = new UICamera();
  uiCursor = new UICursor();

  fontLabel = loadFont( "HelveticaNeue-Bold-8.vlw");
  fontValue = loadFont( "HelveticaNeue-8.vlw");

  fontNodePITier = loadFont( "Helvetica-Bold-28.vlw");
  fontNodePIMaterial = loadFont( "Helvetica-12.vlw");

  size( 1280, 720 );

  smooth();

  colorMode( HSB, 360.0, 1.0, 1.0, 1.0 );


  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
    }
  }
  );



  debugOverlay = new DebugOverlay();
}

void draw()
{
  world.update();

  hoveredEntity = null;
  for ( int i = world.entities.size() - 1; i >= 0; i-- )
  {
    Entity tEntity = (Entity)world.entities.get( i );
    if ( tEntity.contains( new PVector( mouseX, mouseY ) ) )
    {
      hoveredEntity = tEntity;
      break;
    }
  }

  uiCam.update();


  background( 0, 0, 0.2 );

  world.plot();

  uiCursor.plot();

  if ( debugOverlay.enabled ) { 
    debugOverlay.drawDebug();
  }
}

PApplet getPApplet()
{
  return this;
}

