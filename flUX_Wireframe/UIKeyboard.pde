
import java.awt.event.KeyEvent;

class KeyBuffer
{
  ArrayList<KeyBufferCommand> commandStack1;
  ArrayList<KeyBufferCommand> commandStack2;

  ArrayList<KeyBufferCommand> previousFrameCommandStack;
  ArrayList<KeyBufferCommand> currentFrameCommandStack;

  KeyBuffer()
  {
    commandStack1 = new ArrayList<KeyBufferCommand>();
    commandStack2 = new ArrayList<KeyBufferCommand>();

    previousFrameCommandStack = commandStack1;
    currentFrameCommandStack = commandStack2;
  }

  void onKeyPressed()
  {
    currentFrameCommandStack.add( new KeyBufferCommand( key, keyCode ) );
  }

  void swapCommandStacks()
  {
    ArrayList<KeyBufferCommand> tCommandStack = currentFrameCommandStack;
    currentFrameCommandStack = previousFrameCommandStack;
    previousFrameCommandStack = tCommandStack;

    currentFrameCommandStack.clear();
  }

  boolean contains( char aChar )
  {
    for ( KeyBufferCommand iCommand : previousFrameCommandStack )
    {
      if ( iCommand.key != CODED )
      {
        if( iCommand.key == aChar )
        {
          return true;
        }
      }
    }
    
    return false;
  }
}

class KeyBufferCommand
{
  char key;
  int keyCode;

  KeyBufferCommand( char aKey, int aKeyCode )
  {
    key = aKey;
    keyCode = aKeyCode;
  }
}

class InputText
{
  String textString;

  InputText()
  {
    textString = "";
  }

  void processKeyBuffer( KeyBuffer aKeyBuffer )
  {

    for ( KeyBufferCommand iCommand : aKeyBuffer.previousFrameCommandStack )
    {
      if ( iCommand.key == CODED )
      {
        switch( iCommand.keyCode )
        {
        }
      }
      else
      {
        switch( iCommand.key )
        {
        case KeyEvent.VK_BACK_SPACE:
          {
            if ( textString.length() > 0 )
              textString = textString.substring( 0, textString.length() - 1 );
          }
          break;
        default:
          textString += iCommand.key;
        }
      }
    }
  }
}

void keyPressed()
{
  keyBuffer.onKeyPressed();
}


