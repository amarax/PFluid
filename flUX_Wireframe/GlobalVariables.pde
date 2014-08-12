int blockSize = 80;
int internalMargin = 2;

float wireframeSelectionMargin = 5;

KeyBuffer keyBuffer;

World world;

Camera camera;

MouseCursor mouseCursor;

UIModeManager uiModeManager;


Grid styleGrid;

EditableElement editableElement;  // HACK

boolean showPins = true;

PVector debugPos;


float editableParentListEntryHeight = 50;
float editableParentListHeadingHeight = 21;


Global_Float marginSize = new Global_Float( 5.0 );
Global_Float parentListChildOffset = new Global_Float( 10.0 );

class Global_Float
{
  private float value;
  private float prevValue;

  public Global_Float( float aValue )
  {
    value = aValue;
    prevValue = aValue;
  }

  public float getValue()
  {
    return value;
  }

  public void setValue( float aFloat )
  {
    prevValue = value;
    value = aFloat;
  }

  public float getPrevValue()
  {
    return prevValue;
  }
}


