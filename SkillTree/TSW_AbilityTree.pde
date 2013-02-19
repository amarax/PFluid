

class TSW_AbilityTree
{
  


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

  public TSW_AbilityBranch addNewBranch( String aName, color aColor, TSW_AbilityBranch aParentBranch )
  {
    TSW_AbilityBranch tNewBranch = new TSW_AbilityBranch( aName );
    tNewBranch.nodeColor = aColor;
    this.attachBranch( tNewBranch, aParentBranch );
    
    return tNewBranch;
  }
  
  public TSW_Ability addNewAbility( String aName, int aPoints, color aLockedColor, color aUnlockedColor, TSW_AbilityBranch aParentBranch )
  {
    TSW_Ability tNewAbility = new TSW_Ability( aName, aPoints );
    tNewAbility.nodeLockedColor = aLockedColor;
    tNewAbility.nodeUnlockedColor = aUnlockedColor;
    tNewAbility.nodeColor = aLockedColor;
    this.attachAbility( tNewAbility, aParentBranch );
    
    return tNewAbility;
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
  
  
  public color getNodeColor()
  {
    return nodeColor;
  }
  
  
  protected TSW_UIControl_AbilityNode createAssociatedUIControl()
  {
    return null;
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
  String description;
  
  public color nodeLockedColor;
  public color nodeUnlockedColor;

  public TSW_Ability( String aName, int aPoints )
  {
    // Don't do super(), because this node cannot have children
    
    name = aName;
    points = aPoints;
  }

  public TSW_UIControl_AbilityNode createAssociatedUIControl()
  {
    TSW_UIControl_Ability tControl = new TSW_UIControl_Ability( this );
    linkedControl = tControl;
    
    return tControl;
  }

  public color getNodeColor() 
  {
    if( linkedControl != null )
    {
      TSW_UIControl_Ability tControl = (TSW_UIControl_Ability)linkedControl;
      nodeColor = tControl.unlocked ? nodeUnlockedColor : nodeLockedColor; 
    }
    
    return nodeColor;
  }
}
