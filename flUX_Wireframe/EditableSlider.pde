class EditableSlider extends EditableRect
{
  Global_Float linkedGlobalVariable;

  String globalVariableName;

  float minValue;
  float maxValue;

  EditableSlider( PVector aPosition, Global_Float aLinkedGlobalVariable, String aGlobalVariableName )
  {
    super( aPosition );

    linkedGlobalVariable = aLinkedGlobalVariable;
    globalVariableName = aGlobalVariableName;

    minValue = 0.0;
    maxValue = linkedGlobalVariable.getValue() * 5.0;  // HACK Random number

    float tWidth = 140;
    float tHeight = 30;

    pinArray.get( PINARRAY_RIGHT ).updateOffset( position.x + tWidth );
    pinArray.get( PINARRAY_BOTTOM ).updateOffset( position.y + tHeight );
  }

  void update()
  {
    super.update();

    maxValue = right - left;

    if ( mouseCursor.focusedEntity == this && uiModeManager.currentMode == UIMODE_ENTITYSPECIFIC )
    {
      float tTargetValue = ( mouseCursor.position.x - left ); // ( right - left );
      //tTargetValue = tTargetValue * ( maxValue - minValue ) + minValue;
      linkedGlobalVariable.setValue( tTargetValue );
    }

    linkedGlobalVariable.setValue( min( max( linkedGlobalVariable.getValue(), minValue ), maxValue ) );
  }

  void plot()
  {
    super.plot();

    float tSliderBackgroundThickness = 10;

    color tBackground = calcBackgroundColor();
    noStroke();
    fill( tBackground );
    rect( left, (top+bottom - tSliderBackgroundThickness) / 2.0, right-left, tSliderBackgroundThickness );

    float tSliderGlobalPosition = linkedGlobalVariable.getValue(); //( linkedGlobalVariable.getValue() - minValue ) / ( maxValue - minValue );
    tSliderGlobalPosition = tSliderGlobalPosition +left;//* (right-left) + left;

    float tSliderValueThickness = 1;
    float tSliderValueHeight = tSliderBackgroundThickness * 2.0;

    fill( color_sliderDefault );
    rect( tSliderGlobalPosition, (top+bottom - tSliderValueHeight) / 2.0, tSliderValueThickness, tSliderValueHeight );

    //    fill( color_buttonText );
    //    textAlign( CENTER, CENTER );
    //    textFont( font_default );
    //    text( globalVariableName, (left+right) / 2.0, (top+bottom) / 2.0 );
  }

  color calcBackgroundColor()
  {
    if ( this == mouseCursor.focusedEntity && uiModeManager.currentMode == UIMODE_ENTITYSPECIFIC )
      return color_sliderBackground_hovered;

    if ( isHoveringOverSlider() )
    {
      if ( mouseCursor.focusedEntity == null )
        return color_sliderBackground_hovered;

      if ( uiModeManager.currentMode == UIMODE_PINNING )
      {
        if ( mouseCursor.focusedEntity instanceof EditableRect )
        {
          EditableRect tFocusedRect = (EditableRect)( mouseCursor.focusedEntity );
          if ( tFocusedRect.canEditedPinBeGlobal() )
          {
            return color_sliderBackground_hovered;
          }
        }
      }
    }

    return color_buttonBg_default;
  }

  boolean isMouseInside()
  {
    if ( isHoveringOverSlider() )
      return true;

    return getHoveredEdge() != 0;
  }

  void plotDebug()
  {
    super.plotDebug();

    if ( debug_editableSlider )
    {
      textAlign( LEFT, TOP );
      PVector tWorldPosition = localToWorld( position );
      debugTextWorld( globalVariableName + "=" + linkedGlobalVariable.getValue(), tWorldPosition.x, tWorldPosition.y );
    }
  }

  void processMousePressed()
  {
    if ( isHoveringOverSlider() )
    {
      uiModeManager.setMode( UIMODE_ENTITYSPECIFIC );
      return;
    }

    super.processMousePressed();
  }

  void processMouseReleased()
  {
    if ( uiModeManager.currentMode == UIMODE_ENTITYSPECIFIC )
    {
      uiModeManager.revertMode();
      return;
    }

    super.processMouseReleased();
  }

  boolean isHoveringOverSlider()
  {
    return getHoveredEdge() == 5;
  }
}

