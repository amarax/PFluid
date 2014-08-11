import java.awt.*;

void setup()
{
  font_default = loadFont( "HelveticaNeue-Medium-12.vlw" );
  font_defaultBold = loadFont( "HelveticaNeue-Bold-12.vlw" );
  font_title = loadFont( "LeagueGothic-48.vlw" );
  font_debug = loadFont( "HelveticaCY-Plain-10-NoSmooth.vlw" );
  textFont( font_default );
  
  keyBuffer = new KeyBuffer();
  mouseCursor = new MouseCursor();
  
  world = new World();
  
  uiModeManager = new UIModeManager();
  
  size( 1280, 720 );
  frameRate( 60 );

  setupColors();
  colorMode( HSB, 1.0 );

  camera = new Camera();
  
  setupWorld();
  
  debugPos = new PVector();
}


void draw()
{
  background( 0.95 );
  
  keyBuffer.swapCommandStacks();
  mouseCursor.swapBuffers();

  update();
  
  plot();
}


void update()
{
  camera.update();
  mouseCursor.update();
  world.update();
  uiModeManager.update();
}

void plot()
{
  debugPos.set( 1, 1 );
  
  world.plot();
  
  resetMatrix();

  camera.plotDebug();
  mouseCursor.plotDebug();
  world.plotDebug();
  uiModeManager.plotDebug();
}


