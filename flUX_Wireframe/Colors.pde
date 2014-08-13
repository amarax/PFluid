color color_debug;

color color_gridEmpty;
color color_gridEmpty_hover;

color color_gridCell;
color color_gridCell_hover;

color color_gridCellText;
color color_gridCellTextCaret;

color color_defaultEditableElementRect;
color color_selectedEditableElementRect;
color color_hoveredEditableElementRect;
color color_greyedEditableElementRect;

color color_selectedEditableElementRectParent;
color color_selectedEditableElementRectChild;

color color_sliderBackground_default;
color color_sliderBackground_hovered;
color color_sliderDefault;

color color_editedEdgeFill;
color color_hoveredEdgeStroke;
color color_pinSourceEdgeFill;

color color_buttonBg_default;
color color_buttonBg_inEffect;
color color_buttonBg_hover;
color color_buttonBg_pressed;
color color_buttonText;

void setupColors()
{
  colorMode( HSB, 1.0 );

  color_debug = color( 0 );

  color_gridEmpty = color( 0.94 );
  color_gridEmpty_hover = color( 0.93 );

  color_gridCell = color( 0.90 );
  color_gridCell_hover = color( 0.88 );

  color_gridCellText = color( 0.2 );
  color_gridCellTextCaret = color( 1, 0, 0, 0.3 );

  color_defaultEditableElementRect = color( 0.07, 1.0, 1.0, 0.7 );
  color_selectedEditableElementRect = color( 0.57, 1.0, 1.0, 0.7 );
  color_hoveredEditableElementRect = color( 0.05, 1.0, 1.0, 0.7 );
  color_greyedEditableElementRect = color( 0.07, 1.0, 1.0, 0.3 );

  color_selectedEditableElementRectParent = color( 0.02, 1.0, 1.0, 0.7 );
  color_selectedEditableElementRectChild = color( 0.57, 1.0, 0.5, 0.7 );

  color_editedEdgeFill = color( 1, 0, 0, 0.3 );
  color_hoveredEdgeStroke = color( 1, 0, 0.5 );
  color_pinSourceEdgeFill = color( 1, 0, 0, 0.1 );

  color_buttonBg_default = color( 1, 0, 0, 0.1);
  color_buttonBg_hover = color( 1, 0, 0, 0.2);
  color_buttonBg_pressed = color( 1, 0, 0, 0.3);
  color_buttonBg_inEffect = color( 1, 0, 0, 0.5 );
  color_buttonText = color( 1, 0, 0, 0.8);

  color_sliderBackground_default = color_buttonBg_default;
  color_sliderBackground_hovered = color_buttonBg_hover;
  color_sliderDefault = color_buttonText;
}

