class Grid extends WorldObject
{
  ArrayList<GridCell> cells;
  HashMap<Integer, GridCellCollection> columns;
  //HashMap<Integer, GridCellCollection> rows;

  Grid()
  {
    super();

    cells = new ArrayList<GridCell>();
    columns = new HashMap<Integer, GridCellCollection>();
    //rows = new HashMap<Integer, GridCellCollection>();
  }

  void update()
  {
    for ( GridCell iCell : cells )
    {
      iCell.update();
    }

    for ( GridCellCollection iCellCollection : columns.values() )
    {
      iCellCollection.update();
    }

    // TODO add warnings if columns and rows are not synchronised
  }

  GridCell addCell( int aColumn, int aRow )
  {
    GridCell tCell = new GridCell();
    tCell.requestedSize.set( blockSize, blockSize );
    cells.add( tCell );

    GridCellCollection tColumn = columns.get( aColumn );
    if ( tColumn == null )
    {
      tColumn = new GridCellCollection();
      columns.put( aColumn, tColumn );
    }
    if ( tColumn.cells.get( aRow ) != null )
    {
      // TODO warning!
    }
    else
    {
      tColumn.cells.put( aRow, tCell );
    }

    //tCell.requestedSize.x = tColumn.cExpectedDisplaySize;
    tCell.requestedSize.x = 100;

    return tCell;
  }

  GridCell getCell( int aColumn, int aRow )
  {
    GridCellCollection tColumn = columns.get( aColumn );
    if ( tColumn == null )
    {
      return null;
    }

    return tColumn.cells.get( aRow );
  }

  int getRowCount()
  {
    int tLargestRow = 0;

    for ( GridCellCollection iColumn : columns.values() )
    {
      for ( Integer iRowIndex : iColumn.cells.keySet() )
      { 
        if ( tLargestRow < iRowIndex )
          tLargestRow = iRowIndex;
      }
    }

    return tLargestRow + 1;
  }

  int getColumnCount()
  {
    int tLargestColumn = 0;

    for ( Integer iColumnIndex : columns.keySet() )
    {
      if ( tLargestColumn < iColumnIndex )
        tLargestColumn = iColumnIndex;
    }

    return tLargestColumn + 1;
  }
}


class GridCellCollection
{
  HashMap<Integer, GridCell> cells;
  float cExpectedDisplaySize;  // TODO move this out of WorldObject into Entity

  GridCellCollection()
  {
    cells = new HashMap<Integer, GridCell>();
    cExpectedDisplaySize = 0;
  }

  void update()
  {
    cExpectedDisplaySize = 0;
    for ( GridCell iCell : cells.values() )
    {
      cExpectedDisplaySize = max( iCell.requestedSize.x, cExpectedDisplaySize );
    }
  }
}

class GridCell
{
  boolean editing;

  String cellText;
  PVector requestedSize;

  PFont cellTextFont;

  GridCell()
  {
    editing = false;

    cellText = "";

    requestedSize = new PVector();

    cellTextFont = font_default;
  }

  void update()
  {
    textFont( cellTextFont );
    if ( editing )
    {
      requestedSize.x = max(requestedSize.x, blockSize + textWidth( cellText ) );
    }
    else
    {
      requestedSize.x = blockSize + textWidth( cellText );
    }
  }
}






class EntityGrid extends Entity
{
  Grid linkedGrid;
  ArrayList<EntityGridCell> cells;

  EntityGrid()
  {
    super();

    cells = new ArrayList<EntityGridCell>();
  }

  void update()
  {
    if ( linkedGrid == null )
    {
    }
    else
    {
      if ( childEntities.contains( mouseCursor.hoveredEntity ) )
        mouseCursor.hoveredEntity = null;

      cells.clear();
      childEntities.clear();

      float tXPos = position.x;

      for ( int iColumnIndex = 0; iColumnIndex < linkedGrid.getColumnCount(); ++iColumnIndex )
      {
        GridCellCollection tColumn = linkedGrid.columns.get( iColumnIndex );

        if ( tColumn != null )
        {
          for ( Integer iRowIndex : tColumn.cells.keySet() )
          {
            EntityGridCell tCellEntity = new EntityGridCellText( linkedGrid.getCell( iColumnIndex, iRowIndex ) );
            tCellEntity.position.set( tXPos, iRowIndex * ( blockSize + internalMargin ) + position.y );
            tCellEntity.cSize.set( tColumn.cExpectedDisplaySize, blockSize );

            addCell( tCellEntity );
          }

          tXPos += tColumn.cExpectedDisplaySize + internalMargin;
        }
        else
        {
          tXPos += blockSize + internalMargin;
        }
      }
    }

    super.update();
  }

  void plot()
  {
    if ( linkedGrid != null )
    {

      float tXPos = position.x;
      for ( int iColumnIndex = 0; iColumnIndex <= linkedGrid.getColumnCount(); ++iColumnIndex )
      {
        GridCellCollection tColumn = linkedGrid.columns.get( iColumnIndex );

        float tColumnWidth = blockSize;
        if ( tColumn != null )
        {
          tColumnWidth = tColumn.cExpectedDisplaySize;
        }

        for ( int iRowIndex = 0; iRowIndex <= linkedGrid.getRowCount(); ++iRowIndex )
        {
          if ( linkedGrid.getCell( iColumnIndex, iRowIndex ) != null )
          {
            continue;
          }

          if ( iColumnIndex == linkedGrid.getColumnCount() && iRowIndex != 0 )
          {
            continue;
          }
          if ( iRowIndex == linkedGrid.getRowCount() && iColumnIndex != 0 )
          {
            continue;
          }

          PVector tBlockIndex = new PVector( iColumnIndex, iRowIndex );
          PVector tBlockTopLeft = tBlockIndex.get();
          tBlockTopLeft.mult( blockSize + internalMargin );
          tBlockTopLeft.x = tXPos;
          tBlockTopLeft.y += position.y;

          fill( color_gridEmpty );
          noStroke();

          Rectangle tBounds = new Rectangle( floor( tBlockTopLeft.x ), floor( tBlockTopLeft.y ), ceil( tColumnWidth ), ceil( blockSize ) );
          if ( tBounds.contains( mouseCursor.position.x, mouseCursor.position.y ) && mouseCursor.focusedEntity == null )
          {
            fill( color_gridEmpty_hover );
            if ( mousePressed )
            {
              linkedGrid.addCell( iColumnIndex, iRowIndex );
            }
          }


          rect( tBounds.x, tBounds.y, tBounds.width, tBounds.height );
        }

        tXPos += tColumnWidth + internalMargin;
      }
    }

    super.plot();
  }

  void plotDebug()
  {
    if ( debug_entityGrid )
    {
      PVector tScreenPos = camera.worldToScreen( position );
      tScreenPos.x += 2;
      float tLineSpacingFactor = 1.1;

      fill( color_debug );
      textAlign( LEFT, TOP );
      textFont( font_debug );

      String tDebugText = "columnCount = " + nf( linkedGrid.getColumnCount(), 1 );
      text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );

      tScreenPos.y += ceil( ( textAscent() + textDescent() ) * tLineSpacingFactor );

      tDebugText = "rowCount = " + nf( linkedGrid.getRowCount(), 1 );
      text( tDebugText, tScreenPos.x, tScreenPos.y + 1 );
    }

    super.plotDebug();
  }

  boolean isMouseInside()
  {
    return false;
  }

  void addCell( EntityGridCell aCellEntity )
  {
    childEntities.add( aCellEntity );
    cells.add( aCellEntity );
  }
}


class EntityGridCell extends Entity
{
  GridCell linkedCell;

  PVector cSize;

  EntityGridCell( GridCell aLinkedCell )
  {
    super();

    linkedCell = aLinkedCell;
    cSize = new PVector();
  }

  void update()
  {
    super.update();

    if ( linkedCell == null )
      return;
  }

  void plot()
  {
    super.plot();

    if ( linkedCell == null )
      return;
  }

  void plotDebug()
  {
    super.plotDebug();
    if ( debug_entityGrid )
    {
      PVector tScreenPos = camera.worldToScreen( position );
      String tDebugDisplayString = "cSize.x = " + nf( cSize.x, 1, 1 );

      fill( color_debug );
      textAlign( LEFT, TOP );
      textFont( font_debug );
      text( tDebugDisplayString, tScreenPos.x + 2, tScreenPos.y + 1 );
    }
  }


  boolean isMouseInside()
  {
    Rectangle tBounds = new Rectangle( floor( position.x ), floor( position.y ), ceil( cSize.x ), ceil( cSize.y ) );
    return tBounds.contains( mouseCursor.position.x, mouseCursor.position.y );
  }
}

class EntityGridCellText extends EntityGridCell
{
  InputText inputText;

  EntityGridCellText( GridCell aLinkedCell )
  {
    super( aLinkedCell );
    inputText = new InputText();

    if ( linkedCell != null )
    {
      inputText.textString = linkedCell.cellText;
    }
  }

  void plot()
  {
    super.plot();

    if ( linkedCell == null )
      return;

    fill( color_gridCell );
    noStroke();

    if ( mouseCursor.hoveredEntity == this && mouseCursor.focusedEntity == null )
    {
      fill( color_gridCell_hover );

      if ( mousePressed )
      {
        //fill( 0.4 );
      }
    }


    rect( position.x, position.y, cSize.x, cSize.y );

    textFont( linkedCell.cellTextFont );

    PVector tTextPosition = new PVector( position.x + cSize.x * 0.5, position.y + cSize.y * 0.5 + textAscent() * 0.5 );

    fill( color_gridCellText );
    textAlign( CENTER, BASELINE );
    text( linkedCell.cellText, tTextPosition.x, tTextPosition.y );

    if ( mouseCursor.hoveredEntity == this && mouseCursor.focusedEntity == null )
    {
      //Draw caret
      PVector tCaretPosition = new PVector( tTextPosition.x, tTextPosition.y );
      tCaretPosition.x += textWidth( linkedCell.cellText ) / 2.0;

      float tCaretScale = 1.2;
      float tCaretAscent = textAscent() * tCaretScale;
      float tCaretDescent = textDescent() * tCaretScale;

      stroke( color_gridCellTextCaret );
      line( tCaretPosition.x, tCaretPosition.y - tCaretAscent, tCaretPosition.x, tCaretPosition.y + tCaretDescent );
    }


    // TODO needs to be shifted to some UI processing stack
    if ( mouseCursor.hoveredEntity == this && mouseCursor.focusedEntity == null )
    {
      linkedCell.editing = true;

      inputText.processKeyBuffer( keyBuffer );
      linkedCell.cellText = inputText.textString;
    }
    else
    {
      linkedCell.editing = false;
    }
  }
}

