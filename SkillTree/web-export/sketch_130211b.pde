import java.awt.*;


PFont font_label;
PFont font_value;

PFont font_TSW_Title;
PFont font_TSW_Subtitle;
PFont font_TSW_AbilityTree;


TSW_UIControl_AbilityTree abilityTree;


ArrayList<UIControl> uiControls = new ArrayList();
UIControl hoveredControl = null;
UIControl activeControl = null;

Global_Float outerRingSize = new Global_Float( 400 );
Global_Float innerRingSize = new Global_Float( 180 );
Global_Float ringThickness = new Global_Float( 15 );
Global_Float abilityRingThickness = new Global_Float( 30 );
Global_Float gapSize = new Global_Float( 1 );
Global_Float abilityGapSize = new Global_Float( 0.3 );
Global_Float angleOffset = new Global_Float( 0 );
Global_Float selectedNodeRatio = new Global_Float( 0.8 );
Global_Boolean showAuxWheel = new Global_Boolean( true );
Global_Boolean sizeByPoints = new Global_Boolean( false );

void setup()
{





  size( 1600, 900 );
  smooth();
  colorMode( HSB, 360.0, 1.0, 1.0, 1.0 );

  font_label = loadFont( "HelveticaNeue-Bold-8.vlw" );
  font_value = loadFont( "HelveticaNeue-8.vlw" );

  font_TSW_Title = loadFont( "Futura-CondensedExtraBold-18.vlw" );
  font_TSW_Subtitle = loadFont( "Futura-Medium-18.vlw" );
  font_TSW_AbilityTree = loadFont( "Futura-Medium-12.vlw" );

  int tSize = 200;
  abilityTree = new TSW_UIControl_AbilityTree( new Rectangle( height / 2 - tSize + 100, height / 2 - tSize, tSize * 2, tSize * 2 ) );
  uiControls.add( abilityTree );


  int tYPos = 50;
  int tOffset = 50;

  tSize = 215;
  UIControl_Slider tSizeSlider = new UIControl_Slider( 20, tSize * 2 + 20, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tSizeSlider.setLabel( "Outer Ring Size" );
  uiControls.add( tSizeSlider );
  tYPos += tOffset;

  tSize = 215;
  UIControl_Slider tInnerSizeSlider = new UIControl_Slider( 20, tSize * 2 + 20, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tInnerSizeSlider.setLabel( "Inner Ring Size" );
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

  tSize = 400;
  UIControl_Slider tAngleOffsetSlider = new UIControl_Slider( -PI, PI, new Rectangle( width - tSize - 50, tYPos, tSize, 12 ) );
  tAngleOffsetSlider.setLabel( "Angle Offset" );
  uiControls.add( tAngleOffsetSlider );
  tYPos += tOffset;

  tSize = 40;
  UIControl_Switch tShowAuxWheel = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tShowAuxWheel.setLabel( "Aux Wheel" );
  uiControls.add( tShowAuxWheel );
  tYPos += tOffset;

  tSize = 40;
  UIControl_Switch tSizeByPoints = new UIControl_Switch( new Rectangle( width - tSize - 50, tYPos, tSize, 20 ) );
  tSizeByPoints.setLabel( "By AP" );
  uiControls.add( tSizeByPoints );
  tYPos += tOffset;

  tSizeSlider.setup( outerRingSize );
  tInnerSizeSlider.setup( innerRingSize );
  tArcThicknessSlider.setup( ringThickness );
  tAbilityArcThicknessSlider.setup( abilityRingThickness );
  tGapSizeSlider.setup( gapSize );
  tAbilityGapSizeSlider.setup( abilityGapSize );
  tSelectionSizeSlider.setup( selectedNodeRatio );
  tAngleOffsetSlider.setup( angleOffset );
  tShowAuxWheel.setup( showAuxWheel );
  tSizeByPoints.setup( sizeByPoints );

  abilityTree.setup();
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
}

void mouseReleased()
{
  if ( activeControl == hoveredControl && activeControl != null )
  {
    activeControl.onMouseReleased();
  }

  activeControl = null;
}

class DampingHelper_Float
{
  float currentValue;
  float dampingFactor;
  
  DampingHelper_Float( float aDampingFactor, float aStartValue )
  {
    dampingFactor = aDampingFactor;
    currentValue = aStartValue;
  }
  
  void update( float aActualValue )
  {
    currentValue += ( aActualValue - currentValue ) * dampingFactor;
  }
  
  float getValue()
  {
    return currentValue;
  }
}

class Global_Float
{
  float value;
  
  public Global_Float( float aValue )
  {
    value = aValue;
  }
}



class Global_Boolean
{
  boolean value;
  
  public Global_Boolean( boolean aValue )
  {
    value = aValue;
  }
}


class Vector2
{
  float x;
  float y;
  
  public Vector2( float aX, float aY )
  {
    x = aX;
    y = aY;
  }
  
  public float distanceTo( float aX, float aY )
  {
    float tSquaredX = x - aX;
    tSquaredX *= tSquaredX;
    float tSquaredY = y - aY;
    tSquaredY *= tSquaredY;
    
    return sqrt( tSquaredX + tSquaredY );
  }
  
}


class Angle
{
}


class TSW_AbilityTree
{
  final color WHEEL_BRANCH_COLOR = color( 0, 0.0, 0.3, 0.5 );

  final color MELEE_BRANCH_COLOR = color( 30, 0.6, 0.6, 0.5 );
  final color MELEE_ABILITY_LOCKED_COLOR = color( 30, 0.7, 0.4, 0.5 );
  final color MELEE_ABILITY_UNLOCKED_COLOR = color( 30, 0.7, 0.8, 0.5 );
  
  final color MAGIC_BRANCH_COLOR = color( 210, 0.5, 0.75, 0.5 );
  final color MAGIC_ABILITY_LOCKED_COLOR = color( 210, 0.6, 0.5, 0.5 );
  final color MAGIC_ABILITY_UNLOCKED_COLOR = color( 210, 0.6, 0.8, 0.5 );
  
  final color RANGED_BRANCH_COLOR = color( 5, 0.45, 0.7, 0.5 );
  final color RANGED_ABILITY_LOCKED_COLOR = color( 5, 0.55, 0.5, 0.5 );
  final color RANGED_ABILITY_UNLOCKED_COLOR = color( 5, 0.55, 0.8, 0.5 );
  
  final color MISC_BRANCH_COLOR = color( 120, 0.35, 0.5, 0.5 );
  final color MISC_ABILITY_COLOR_LOCKED = color( 120, 0.35, 0.5, 0.5 );
  final color MISC_ABILITY_COLOR_UNLOCKED = color( 120, 0.35, 0.8, 0.5 );
  
  final color AUX_BRANCH_COLOR = color( 180, 0.3, 0.6, 0.5 );
  final color AUX_ABILITY_COLOR_LOCKED = color( 180, 0.3, 0.33, 0.5 );
  final color AUX_ABILITY_COLOR_UNLOCKED = color( 180, 0.3, 0.8, 0.5 );
  


  TSW_AbilityNode rootNode;
  ArrayList<TSW_Ability> abilities;
  
  int cLevels;
  
  public TSW_AbilityTree()
  {
    rootNode = new TSW_AbilityNode();
    abilities = new ArrayList<TSW_Ability>();
    
    cLevels = 0;
  }
  
  public void attachBranch( TSW_AbilityBranch aBranch, TSW_AbilityBranch aParentBranch )
  {
    TSW_AbilityNode tParent = rootNode;
    if( aParentBranch != null ) { tParent = aParentBranch; }
    
    aBranch.setParentNode( tParent );
    tParent.addChildNode( aBranch );
  }
  
  public void attachAbility( TSW_Ability aAbility, TSW_AbilityBranch aParentBranch )
  {
    abilities.add( aAbility );
    
    aAbility.setParentNode( aParentBranch );
    aParentBranch.addChildNode( aAbility );
  }
}

class TSW_AbilityNode
{
  protected TSW_AbilityNode parentNode;
  protected ArrayList<TSW_AbilityNode> childNodes;
  
  String name;
  public color nodeColor;

  public TSW_UIControl_AbilityNode linkedControl;
  
  public TSW_AbilityNode()
  {
    childNodes = new ArrayList<TSW_AbilityNode>();
  }
  
  public void setParentNode( TSW_AbilityNode aParent )
  {
    parentNode = aParent;
  }
  
  public void addChildNode( TSW_AbilityNode aChild )
  {
    childNodes.add( aChild );
  }
  
  public ArrayList<TSW_AbilityNode> getChildNodes()
  {
    return new ArrayList<TSW_AbilityNode>( childNodes );
  }
  
  
  protected TSW_UIControl_AbilityNode createAssociatedUIControl()
  {
    return null;
  }
  
  public int getRelativeSize()
  {
    return 1;
  }
}


class TSW_AbilityBranch extends TSW_AbilityNode
{
  ArrayList<TSW_Ability> abilities;

  public TSW_AbilityBranch( String aName )
  {
    super();
    
    name = new String( aName );
  }
  
  
  public TSW_UIControl_AbilityNode createAssociatedUIControl()
  {
    TSW_UIControl_AbilityBranch tControl = new TSW_UIControl_AbilityBranch( this );
    linkedControl = tControl;
    
    return tControl;
  }
}


class TSW_Ability extends TSW_AbilityNode
{
  int points;
  
  private boolean unlocked;
  
  public color nodeLockedColor;
  public color nodeUnlockedColor;

  public TSW_Ability( String aName, int aPoints )
  {
    // Don't do super(), because this node cannot have children
    
    name = aName;
    points = aPoints;
    
    unlocked = false;
  }

  public TSW_UIControl_AbilityNode createAssociatedUIControl()
  {
    TSW_UIControl_Ability tControl = new TSW_UIControl_Ability( this );
    linkedControl = tControl;
    
    return tControl;
  }

  public int getRelativeSize()
  {
    if( sizeByPoints.value )
    {
      return points;
    }
    //else
    return 1;
  }
  
  public void setUnlocked( boolean aUnlocked )
  {
    unlocked = aUnlocked;
    
    if( unlocked )
    {
      this.nodeColor = nodeUnlockedColor;
    }
    else
    {
      this.nodeColor = nodeLockedColor;
    }
  }
  
  public boolean getUnlocked()
  {
    return unlocked;
  }
}
class TSW_AbilityTree_Generated extends TSW_AbilityTree
{
  public TSW_AbilityTree_Generated()
  {
    super();
    
    
  }
  
  public void populate()
  {
    cLevels = 4;
    
    TSW_AbilityBranch tSuperBranch = null;
    TSW_AbilityBranch tMainBranch = null;
    TSW_AbilityBranch tWeaponBranch = null;
    TSW_AbilityBranch tMinorBranch = null;
    TSW_Ability tAbility = null;
    
    tSuperBranch = addNewBranch( "Main", WHEEL_BRANCH_COLOR, null );
    {
      tMainBranch = addNewBranch( "Melee", MELEE_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "Blades", MELEE_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Method", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "Delicate Strike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Delicate Precision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Balanced Blade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Expose Weakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Dancing Blade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Sharp Blades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Stunning Swirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Technique", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "Immortal Spirit", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Blade Torrent", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Perfect Storm", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Martial Discipline", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Regeneration", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Surging Blades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Fluid Defence", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Wind through Grass", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "Grass Cutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Twist the Knife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Chop Shop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Seven and a Half Samurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny Fulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Four Seasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Tearing of Sky", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Crossing River's Edge", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Running of the Jagged", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sharpening the Senses", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Cutting Artist", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Hammers", MELEE_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Brawn", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Grit", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          
          tMinorBranch = addNewBranch( "Industrial Action", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Brute Force", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Excessive Damage", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sledge Factory", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Battering Works", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Hammer Pit", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Fists", MELEE_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Feral", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Primal", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "The Wilderness", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Outback", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Streets", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Warming Up", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Heat of Battle", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Play with Fire", MELEE_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MELEE_ABILITY_LOCKED_COLOR, MELEE_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }
      }
      
      tMainBranch = addNewBranch( "Turbulence", MISC_BRANCH_COLOR, tSuperBranch );
      {
        tAbility = addNewAbility( "SleightofHand", 9, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "UnfairAdvantage", 12, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "TurntheTables", 16, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Cannonball", 21, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "SpeedFreak", 27, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Tenacity", 34, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "LastResort", 50, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
      }

      tMainBranch = addNewBranch( "Magic", MAGIC_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "Blood Magic", MAGIC_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Profane", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sacred", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Malediction", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Transmission", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Possession", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Wetwork", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chirurgia", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Venamancy", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Chaos", MAGIC_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Theory", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chance", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Teorema", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Value of x", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Collapse", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Building Blocks", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Shell Game", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "The Fourth Wall", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Elementalism", MAGIC_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Spark", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "React", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharpBlades", 4, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Zero Crossing", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Altered States", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Mortality Curve", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Resonance", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Disturbance", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Tempest", MAGIC_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenandaalfSamurai", 21, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, MAGIC_ABILITY_LOCKED_COLOR, MAGIC_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }
      }
      
      tMainBranch = addNewBranch( "Subversion", MISC_BRANCH_COLOR, tSuperBranch );
      {
        tAbility = addNewAbility( "SleightofHand", 9, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "UnfairAdvantage", 12, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "TurntheTables", 16, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Cannonball", 21, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "SpeedFreak", 27, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Tenacity", 34, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "LastResort", 50, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
      }

      tMainBranch = addNewBranch( "Ranged", RANGED_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "Shotgun", RANGED_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Enforce", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Control", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Crackdown", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Restricted Access", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Close Encounters", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Securing the Perimeter", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Hunkering Down", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Tactical Surprise", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Pistols", RANGED_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Profane", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sacred", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Malediction", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Transmission", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Possession", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Wetwork", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chirurgia", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Venamancy", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }

        tWeaponBranch = addNewBranch( "Assault Rifles", RANGED_BRANCH_COLOR, tMainBranch );
        {
          tMinorBranch = addNewBranch( "Profane", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Sacred", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "DelicateStrike", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DelicatePrecision", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "BalancedBlade", 1, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ExposeWeakness", 2, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DancingBlade", 3, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SharBlades", 4, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "StunningSwirl", 7, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }

          tMinorBranch = addNewBranch( "Malediction", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Transmission", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Possession", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Wetwork", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Chirurgia", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
          tMinorBranch = addNewBranch( "Venamancy", RANGED_BRANCH_COLOR, tWeaponBranch );
          {
            tAbility = addNewAbility( "GrassCutter", 9, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "TwisttheKnife", 12, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "ChopShop", 16, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "SevenanHalfSamurai", 21, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "Destiny", 27, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "DestinyFulfilled", 34, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
            tAbility = addNewAbility( "FourSeasons", 50, RANGED_ABILITY_LOCKED_COLOR, RANGED_ABILITY_UNLOCKED_COLOR, tMinorBranch );
          }
        }
      }

      tMainBranch = addNewBranch( "Survivalism", MISC_BRANCH_COLOR, tSuperBranch );
      {
        tAbility = addNewAbility( "Sleight of Hand", 9, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Unfair Advantage", 12, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Turn the Tables", 16, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Cannonball", 21, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Speed Freak", 27, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Tenacity", 34, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
        tAbility = addNewAbility( "Last Resort", 50, MISC_ABILITY_COLOR_LOCKED, MISC_ABILITY_COLOR_UNLOCKED, tMainBranch );
      }
    }
    
    
    tSuperBranch = addNewBranch( "Auxiliary", WHEEL_BRANCH_COLOR, null );
    {
      tMainBranch = addNewBranch( "Melee", AUX_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
        tWeaponBranch = addNewBranch( "Chainsaw", AUX_BRANCH_COLOR, tMainBranch );
        {
          tAbility = addNewAbility( "PopShot", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rangefinder", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Clusterstruck", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "RocketScience", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "DeathFromAbove", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Warhead", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Biged Button", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
        }
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
      }

      tMainBranch = addNewBranch( "Magic", AUX_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
        tWeaponBranch = addNewBranch( "Quantum", AUX_BRANCH_COLOR, tMainBranch );
        {
          tAbility = addNewAbility( "PopShot", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rangefinder", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Clusterstruck", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "RocketScience", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "DeathFromAbove", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Warhead", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "BigRedButton", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
        }
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
      }

      tMainBranch = addNewBranch( "Ranged", AUX_BRANCH_COLOR, tSuperBranch );
      {
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
        tWeaponBranch = addNewBranch( "Rocket Launcher", AUX_BRANCH_COLOR, tMainBranch );
        {
          tAbility = addNewAbility( "Pop Shot", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rangefinder", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Clusterstruck", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Rocket Science", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Death From Above", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Warhead", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
          tAbility = addNewAbility( "Big Red Button", 50, AUX_ABILITY_COLOR_LOCKED, AUX_ABILITY_COLOR_UNLOCKED, tWeaponBranch );
        }
        tWeaponBranch = addNewBranch( "(Locked)", AUX_BRANCH_COLOR, tMainBranch );
      }
    }
  }
  
  protected TSW_AbilityBranch addNewBranch( String aName, color aColor, TSW_AbilityBranch aParentBranch )
  {
    TSW_AbilityBranch tNewBranch = new TSW_AbilityBranch( aName );
    tNewBranch.nodeColor = aColor;
    this.attachBranch( tNewBranch, aParentBranch );
    
    return tNewBranch;
  }
  
  protected TSW_Ability addNewAbility( String aName, int aPoints, color aLockedColor, color aUnlockedColor, TSW_AbilityBranch aParentBranch )
  {
    TSW_Ability tNewAbility = new TSW_Ability( aName, aPoints );
    tNewAbility.nodeLockedColor = aLockedColor;
    tNewAbility.nodeUnlockedColor = aUnlockedColor;
    tNewAbility.nodeColor = aLockedColor;
    this.attachAbility( tNewAbility, aParentBranch );
    
    return tNewAbility;
  }
}


class TSW_UIControl_AbilityTree extends UIControl
{
  TSW_AbilityTree abilityTree;
  
  TSW_AbilityNode selectedAbilityNode = null;
  
  float size;
  
  public TSW_UIControl_AbilityTree( Rectangle aRect )
  {
    super( aRect );
    
    loadAbilityTree();

    size = 100;
  }
  
  public void setup()
  {
    super.setup();
    
    createControlsForChildAbilityNodes( abilityTree.rootNode ); 
  }
  
  public void update()
  {
    super.update();
    
    if( outerRingSize != null )
    {
      size = outerRingSize.value;
    }
    else
    {
      size = 100;
    }
    
    float tCenterX = rect.x + rect.width / 2.0;
    float tCenterY = rect.y + rect.height / 2.0;  

    rect.setRect( tCenterX - size, tCenterY - size, size * 2, size * 2 );
    
    float tAngleOffset = angleOffset.value;
    updateChildNodeDimensions( abilityTree.rootNode, 0, 0 + tAngleOffset, TWO_PI + tAngleOffset );
  }
  
  public void draw()
  {
    super.draw();
    
    float tCenterX = rect.x + rect.width / 2.0;
    float tCenterY = rect.y + rect.height / 2.0;  

    fill( 0, 0, 0.7 );
    noStroke();
    
    textAlign( CENTER, BOTTOM );
    textFont( font_TSW_Title );
    text( "THE SECRET WORLD", tCenterX, tCenterY - 30 );

    textFont( font_TSW_Subtitle );
    text( "ABILITY WHEEL", tCenterX, tCenterY - 5 );

    fill( 0, 0, 0.3 );
    textAlign( CENTER, TOP );
    textFont( font_TSW_Subtitle );
    text( "Visualisation Test", tCenterX, tCenterY + 5 );

    if( false ) // For debugging
    {
      noFill();
      stroke( 0, 0, 0.3 );
      strokeCap( SQUARE );
      strokeWeight( 1 );
      
      float tCrossSize = 10;
      line( tCenterX, tCenterY - tCrossSize, tCenterX, tCenterY + tCrossSize ); 
      line( tCenterX - tCrossSize, tCenterY, tCenterX + tCrossSize, tCenterY ); 
      
      //if( this == hoveredControl ) { stroke( 0, 0, 0.4 ); }
      
      ellipseMode( RADIUS );
      ellipse( tCenterX, tCenterY, rect.width / 2.0, rect.height / 2.0 );    
    }

    if( selectedAbilityNode != null )
    {
//      float tGlowRadius = outerRingSize.value - ringThickness.value * 6;
//      strokeWeight( ringThickness.value * 15 );
//      stroke( hue( selectedAbilityNode.nodeColor ), 0.1, 0.3, 0.1 );
//      arc( tCenterX, tCenterY, tGlowRadius, tGlowRadius, PI + HALF_PI + selectedAbilityNode.linkedControl.damper_startAngle.getValue(), PI + HALF_PI + selectedAbilityNode.linkedControl.damper_endAngle.getValue(), OPEN );     
    }
  }
  
  
  
  public boolean isMouseIn()
  {
    float tXDiff = mouseX - ( rect.x + rect.width / 2.0 );
    float tYDiff = mouseY - ( rect.y + rect.height / 2.0 );
    float tSquaredLength = ( tXDiff * tXDiff ) + ( tYDiff * tYDiff );
    float tRectRadius = ( rect.width / 2.0 ) * ( rect.width / 2.0 );
    
    if( tSquaredLength <= tRectRadius ) { return true; }
    return false;
  }
  
  public void onMouseReleased()
  {
    selectedAbilityNode = null;
  }
  
  
  
  private void loadAbilityTree()
  {
    // HACK Create an ability tree
    // HACK should load from XML
    TSW_AbilityTree_Generated tGeneratedTree = new TSW_AbilityTree_Generated(); 
    tGeneratedTree.populate();
    abilityTree = tGeneratedTree;
  }
  
  
  private void createControlsForChildAbilityNodes( TSW_AbilityNode aNode )
  {
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.createAssociatedUIControl();
      uiControls.add( tControl );
      
      tControl.setup( this );
      
      if( iNode.getChildNodes().size() > 0 )
      {
          createControlsForChildAbilityNodes( iNode );
      }
    }
  }
  
  int tGrandTotalSize = 1;
  private void updateChildNodeDimensions( TSW_AbilityNode aNode, int aLevel, float aStartAngle, float aEndAngle )
  {
    HashMap<TSW_AbilityNode, Integer> tNodeToRelativeSize = new HashMap<TSW_AbilityNode, Integer>(); 
    int tTotalSize = 0;
    
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      int tRelativeSize = getNodeRelativeSize( iNode );
      tNodeToRelativeSize.put( iNode, tRelativeSize );
      tTotalSize += tRelativeSize;
    }

    float tCurrentAngle = aStartAngle; 
    for( TSW_AbilityNode iNode : aNode.getChildNodes() )
    {
      TSW_UIControl_AbilityNode tControl = iNode.linkedControl;
      
      tControl.cDistanceFromCenter = ( aLevel * 1.0 / abilityTree.cLevels ) * ( outerRingSize.value - ringThickness.value - innerRingSize.value ) + innerRingSize.value;

      if( tControl instanceof TSW_UIControl_Ability ) { tControl.cDistanceFromCenter -= ( outerRingSize.value - ringThickness.value - innerRingSize.value ) / abilityTree.cLevels - ringThickness.value - gapSize.value * 2; }

      float tGapSize = gapSize.value;
      if( tControl instanceof TSW_UIControl_Ability ) { tGapSize = abilityGapSize.value; }
      else if( !showAuxWheel.value && iNode.name.equals( "Main" ) ) { tGapSize = 0; }

      tControl.cStartAngle = tCurrentAngle + tGapSize / tControl.cDistanceFromCenter;
      tCurrentAngle = tCurrentAngle + ( aEndAngle - aStartAngle ) * tNodeToRelativeSize.get( iNode ) / tTotalSize;
      tControl.cEndAngle = tCurrentAngle - tGapSize / tControl.cDistanceFromCenter;
      
      if( iNode.getChildNodes().size() > 0 )
      {
          updateChildNodeDimensions( iNode, aLevel + 1, tControl.cStartAngle, tControl.cEndAngle );
      }
    }
  }
  
  private int getNodeRelativeSize( TSW_AbilityNode aNode )
  {
    int tRelativeSize = 0;

    if( aNode.getChildNodes().size() > 0 )
    {
      for( TSW_AbilityNode iNode : aNode.getChildNodes() )
      {
        tRelativeSize += getNodeRelativeSize( iNode );
      }
    }
    else
    {
      tRelativeSize = aNode.getRelativeSize();
    }
    
    if( selectedAbilityNode == aNode )
    {
      tRelativeSize = sizeByPoints.value ? round( 11025 / ( 1 - selectedNodeRatio.value ) ) : round( ( 525 + 6 ) / ( 1 - selectedNodeRatio.value ) );
    }
    
    if( aNode.name.equals( "Auxiliary" ) && !showAuxWheel.value )
    {
      tRelativeSize = 0;
    }

    return tRelativeSize;
  }
}


class TSW_UIControl_AbilityNode extends UIControl
{
  TSW_UIControl_AbilityTree parentTreeControl;
  TSW_AbilityNode linkedNode;
  
  public float cThickness;
  public float cStartAngle, cEndAngle, cDistanceFromCenter;
  DampingHelper_Float damper_startAngle, damper_endAngle;
  
  public TSW_UIControl_AbilityNode( TSW_AbilityNode aNode )
  {
    super( new Rectangle() );
    
    linkedNode = aNode;
  }
  
  public void setup( TSW_UIControl_AbilityTree aParentTreeControl )
  {
    super.setup();
    
    parentTreeControl = aParentTreeControl;
    
    damper_startAngle = new DampingHelper_Float( 0.05, 0 );
    damper_endAngle = new DampingHelper_Float( 0.05, 0 );
  }
  
  public void update()
  {
    super.update();

    damper_startAngle.update( cStartAngle );
    damper_endAngle.update( cEndAngle );
  }
  
  public void draw()
  {
    super.draw();

    float tCenterX = parentTreeControl.rect.x + parentTreeControl.rect.width / 2.0;
    float tCenterY = parentTreeControl.rect.y + parentTreeControl.rect.height / 2.0;  
 
    float tRadius = 0;
    float tArcThickness = 0;
    
    float tStartAngle = damper_startAngle.getValue();
    float tEndAngle = damper_endAngle.getValue();
    float tDistanceFromCenter = cDistanceFromCenter;
    
    // Cull if too thin
    if( tEndAngle - tStartAngle >= 1 / tDistanceFromCenter )
    {
    
      noFill();
      strokeCap( SQUARE );
      ellipseMode( RADIUS );
  
      tArcThickness = cThickness;
      tRadius = tDistanceFromCenter + tArcThickness / 2;
  
      if( parentTreeControl.selectedAbilityNode != null )
      {
        if( this == parentTreeControl.selectedAbilityNode.linkedControl )
        {
          stroke( hue( linkedNode.nodeColor ), saturation( linkedNode.nodeColor ) * 0.2, 1.0, alpha( linkedNode.nodeColor ) * 0.15 );
    
          float tOutline = -2;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     
    
          tOutline = 2;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );     
    
          tOutline += 2;
          strokeWeight( tArcThickness - tOutline );
          arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle - tOutline / tDistanceFromCenter, PI + HALF_PI + tEndAngle + tOutline / tDistanceFromCenter, OPEN );
        }     
      }
  
      strokeWeight( tArcThickness );
      stroke( linkedNode.nodeColor );
  
      arc( tCenterX, tCenterY, tRadius, tRadius, PI + HALF_PI + tStartAngle, PI + HALF_PI + tEndAngle, OPEN );
  
      
      if( this == hoveredControl )
      {
        noStroke();
        fill( 0, 0, 1 );
        textFont( font_TSW_AbilityTree );
        textAlign( RIGHT, BOTTOM );
        
        text( linkedNode.name, mouseX, mouseY );
      }
    }
  }
  
  
  
  public boolean isMouseIn()
  {
    // Cull if too thin
    if( damper_endAngle.getValue() - damper_startAngle.getValue() >= 1 / cDistanceFromCenter )
    {
      Vector2 tCenter = new Vector2( parentTreeControl.rect.x + parentTreeControl.rect.width / 2.0, parentTreeControl.rect.y + parentTreeControl.rect.height / 2.0 );  
  
      float tDist = tCenter.distanceTo( mouseX, mouseY );
  
      if( tDist >= cDistanceFromCenter && tDist <= cDistanceFromCenter + cThickness )
      {
        float tRelativeAngle = atan2( mouseY - tCenter.y, mouseX - tCenter.x ) + HALF_PI;
        float tOffsetAngle = angleOffset.value;
        if( tRelativeAngle < 0 + tOffsetAngle ) { tRelativeAngle += TWO_PI; }
  
        if( tRelativeAngle >= cStartAngle && tRelativeAngle <= cEndAngle )
        {
          return true;
        }
      }
    }

    return false;
  }
  
  public void onMouseReleased()
  {
    parentTreeControl.selectedAbilityNode = this.linkedNode;
  }
}


class TSW_UIControl_AbilityBranch extends TSW_UIControl_AbilityNode
{
  public TSW_UIControl_AbilityBranch( TSW_AbilityBranch aBranch )
  {
    super( aBranch );
  }
  

  public void update()
  {
    super.update();
    
    cThickness = ringThickness.value;
  }
  
  public void draw()
  {
    super.draw();
  }
}

class TSW_UIControl_Ability extends TSW_UIControl_AbilityNode
{
  public TSW_UIControl_Ability( TSW_Ability aAbility )
  {
    super( aAbility );
  }

  public void update()
  {
    super.update();
    
    cThickness = abilityRingThickness.value;
  }
  
  public void draw()
  {
    super.draw();
  }

  public void onMouseReleased()
  {
    TSW_Ability tLinkedAbilityNode = ( (TSW_Ability)linkedNode ); 
    tLinkedAbilityNode.setUnlocked( !tLinkedAbilityNode.getUnlocked() );
  }
}
class UIControl
{
  protected Rectangle rect;
  
  protected UIControl( Rectangle aRect )
  {
    rect = new Rectangle( aRect );
  }
  
  public void setup() {};
  public void update() {};
  public void draw() {};
  
  public boolean isMouseIn()
  {
    return false;
  }
  
  public void onMouseReleased()
  {
  }
}





class UIControl_Slider extends UIControl
{
  protected String label;
  protected float min, max;
  protected float value;
  
  public Global_Float linkedValue;

  Rectangle valueExtents;
  
  public UIControl_Slider( float aMin, float aMax, Rectangle aRect )
  {
    super( aRect );
    
    min = aMin;
    max = aMax;
    value = min;
    
    valueExtents = new Rectangle( rect.x + rect.height - 1, rect.y - 2, rect.width - 2 * ( rect.height - 1 ), rect.height + 2 * 2 );  
  }
  
  
  
  public void setup( Global_Float aLinkedValue )
  {
    super.setup();
    
    linkedValue = aLinkedValue;
    value = linkedValue.value;
  }
  
  public void update()
  {
    super.update();
    
    if( this == activeControl )
    {
      value = min + ( max - min ) * ( mouseX - valueExtents.x ) / ( valueExtents.width );
      
      if( value < min ) { value = min; }
      if( value > max ) { value = max; }
      
      linkedValue.value = value;
    }
  }

  public void draw()
  {
    super.draw();
    
    noStroke();
    fill( 0, 0, 1, 0.15 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1, 0.3 ); } 
    
    rect( rect.x, rect.y, rect.width, rect.height, rect.height / 2.0 );
    
    fill( 0, 0, 1 );
    textFont( font_label );
    textAlign( LEFT, BOTTOM );
    text( label, rect.x, rect.y - 2 );
    
    

    float tValueX =  valueExtents.x + valueExtents.width * ( linkedValue.value - min ) / ( max - min );

    fill( 0, 0, 0.6 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1 ); }
    
    rect( tValueX - 1, valueExtents.y, 2, valueExtents.height );
    

    textFont( font_value );
    textAlign( LEFT, TOP );
    text( linkedValue.value, tValueX, rect.y + rect.height + 2 );
  }
  
  
  public boolean isMouseIn()
  {
    return rect.contains( mouseX, mouseY );
  }
  
  
  public void setLabel( String aLabel )
  {
    label = aLabel;
  }
}




class UIControl_Switch extends UIControl
{
  protected String label;
  protected float value;
  
  final float switchWidth = 0.55;
  
  public Global_Boolean linkedValue;
  DampingHelper_Float valueDamper;

  Rectangle valueExtents;
  
  public UIControl_Switch( Rectangle aRect )
  {
    super( aRect );
    
    value = 0.0;
    
    int tBorder = 3;
    valueExtents = new Rectangle( rect.x + tBorder, rect.y + tBorder, rect.width - tBorder*2 - round( rect.width * switchWidth ), rect.height - tBorder*2 );  
  }
  
  
  
  public void setup( Global_Boolean aLinkedValue )
  {
    super.setup();
    
    linkedValue = aLinkedValue;
    value = linkedValue.value ? 1.0 : 0.0;
    
    valueDamper = new DampingHelper_Float( 0.3, value );
  }
  
  public void update()
  {
    super.update();
    
    if( this == activeControl )
    {
      value = ( mouseX - rect.width * switchWidth * 0.5 - valueExtents.x ) * 1.0 / valueExtents.width;
      if( value < 0.0 ) { value = 0.0; }
      if( value > 1.0 ) { value = 1.0; }
      
      valueDamper.currentValue = value;
    }
    else
    {
      value = linkedValue.value ? 1.0 : 0.0;
      
    }
    valueDamper.update( value );

    linkedValue.value = valueDamper.getValue() >= 0.5;
  }

  public void draw()
  {
    super.draw();
    
    noStroke();
    fill( 0, 0, 1, 0.15 );
    if( this == hoveredControl || this == activeControl ) { fill( 0, 0, 1, 0.3 ); } 
    
    rect( rect.x, rect.y, rect.width, rect.height, rect.height / 2.0 );
    
    fill( 0, 0, 1 );
    textFont( font_label );
    textAlign( LEFT, BOTTOM );
    text( label, rect.x, rect.y - 2 );
    
    
    float tBrightness = 0.6;
    if( this == hoveredControl || this == activeControl ) { tBrightness = 1; }
    if( !linkedValue.value ) { tBrightness *= 0.5; }
    fill( 0, 0, 1, tBrightness );

    rect( valueExtents.x + valueDamper.getValue() * valueExtents.width, valueExtents.y, rect.width * switchWidth, valueExtents.height, valueExtents.height / 2.0 );
    

    textFont( font_value );
    textAlign( LEFT, TOP );
    //text( linkedValue.value, tValueX, rect.y + rect.height + 2 );
  }
  
  
  public boolean isMouseIn()
  {
    return rect.contains( mouseX, mouseY );
  }
  
  
  public void setLabel( String aLabel )
  {
    label = aLabel;
  }
}

