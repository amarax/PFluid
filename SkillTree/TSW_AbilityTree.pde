

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
