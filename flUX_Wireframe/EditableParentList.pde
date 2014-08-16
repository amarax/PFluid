class EditableParentList extends EditableRect
{
  ArrayList<EditableElement> cWorldEditableElementsSorted;
  HashMap<EditableElement, EditableElementListEntry> editableElementsListMap;

  EditableParentList( PVector aPosition )
  {
    super( aPosition );

    getPin( PinEdge.PINEDGE_RIGHT ).updateOffset( position.x + 200 );
    getPin( PinEdge.PINEDGE_BOTTOM ).updateOffset( position.y + editableParentListHeadingHeight );

    cWorldEditableElementsSorted = new ArrayList<EditableElement>();

    editableElementsListMap = new HashMap<EditableElement, EditableElementListEntry>();
  }

  void update()
  {
    int tPrevElementCount = cWorldEditableElementsSorted.size();
    EditableElementListEntry tPrevLastElement = null;
    if ( tPrevElementCount > 0 ) { 
      tPrevLastElement = editableElementsListMap.get( cWorldEditableElementsSorted.get( cWorldEditableElementsSorted.size() - 1 ) );
    }

    ArrayList<EditableElement> tNewWorldEditableElements = new ArrayList<EditableElement>();
    for ( Entity iEntity : editableElement.childEntities )
    {
      if ( iEntity instanceof EditableElement )
      {
        tNewWorldEditableElements.addAll( getEditableElements( (EditableElement)iEntity ) );
      }
    }

    ArrayList<EditableElement> tEditableElementsToRemove = new ArrayList<EditableElement>();
    for ( EditableElement iEditableElement : editableElementsListMap.keySet() )
    {
      if ( !tNewWorldEditableElements.contains( iEditableElement ) )
      {
        tEditableElementsToRemove.add( iEditableElement );
      }
    }

    for ( EditableElement iElement : tEditableElementsToRemove )
    {
      EditableElementListEntry tListEntryToRemove = editableElementsListMap.get( iElement );

      // If there is a next entry, relink its pins to the previous element
      int tIndexAfter = cWorldEditableElementsSorted.indexOf( iElement ) + 1;
      if ( tIndexAfter < cWorldEditableElementsSorted.size() ) { 
        EditableElement tPreviousElement = null;
        int tIndexBefore = cWorldEditableElementsSorted.indexOf( iElement ) - 1;
        if ( tIndexBefore >= 0 ) {
          tPreviousElement = cWorldEditableElementsSorted.get( tIndexBefore );
        }
        updateListEntryPins_TopBottom( cWorldEditableElementsSorted.get( tIndexAfter ), tPreviousElement );
      }

      editableElementsListMap.remove( iElement );
      tListEntryToRemove.setParent( null );
    }

    cWorldEditableElementsSorted = tNewWorldEditableElements;

    ArrayList<EditableElement> tEditableElementsToAdd = new ArrayList<EditableElement>();  // Map for entry to add and previous entry (where to insert)
    for ( EditableElement iEditableElement : cWorldEditableElementsSorted )
    {
      if ( editableElementsListMap.get( iEditableElement ) == null )
      {
        tEditableElementsToAdd.add( iEditableElement );
      }
    }

    for ( EditableElement iElement : tEditableElementsToAdd )
    {
      EditableElement tPreviousElement = null;
      int tIndexBefore = cWorldEditableElementsSorted.indexOf( iElement ) - 1;
      if ( tIndexBefore >= 0 ) { 
        tPreviousElement = cWorldEditableElementsSorted.get( tIndexBefore );
      }
      EditableElementListEntry tNewEntry = addListEntryChild( iElement, tPreviousElement );
      tPreviousElement = iElement;

      int tIndexAfter = cWorldEditableElementsSorted.indexOf( iElement ) + 1;
      if ( tIndexAfter < cWorldEditableElementsSorted.size() )
      {
        updateListEntryPins_TopBottom( cWorldEditableElementsSorted.get( tIndexAfter ), iElement );
      }
    }

    int tElementCount = cWorldEditableElementsSorted.size();
    EditableElementListEntry tLastElement = null;
    if ( tElementCount > 0 ) { 
      tLastElement = editableElementsListMap.get( cWorldEditableElementsSorted.get( cWorldEditableElementsSorted.size() - 1 ) );
    }

    if ( tElementCount != tPrevElementCount )
    {
      if ( cWorldEditableElementsSorted.size() == 0 )
      {
        // Switch back to local pin
        setPin( PinEdge.PINEDGE_BOTTOM, new EditableRectPinLocalAbsolute( this, PinEdge.PINEDGE_BOTTOM, position.y + editableParentListHeadingHeight ) );
      }
      else if ( tPrevElementCount == 0 )
      {
        setPin( PinEdge.PINEDGE_BOTTOM, new EditableRectPinGlobalOffset( this, PinEdge.PINEDGE_BOTTOM, tLastElement, PinEdge.PINEDGE_BOTTOM, tLastElement.bottom + marginSize.getValue(), marginSize ) );
      }
    }

    if ( tLastElement != null && tLastElement != tPrevLastElement )
    {
      getPin( PinEdge.PINEDGE_BOTTOM ).pinnedSource = tLastElement;
    }

    super.update();
  }

  void plot()
  {
    PVector tWorldTopLeft = new PVector( left, top );
    //    tWorldTopLeft.add( position );
    //    tWorldTopLeft.set( localToWorld( tWorldTopLeft ) );

    float tMargin = 5;

    fill( color_buttonText );
    textFont( font_default );
    textAlign( LEFT, TOP );
    text( "ENTITY LIST", tWorldTopLeft.x + tMargin, tWorldTopLeft.y + tMargin );

    super.plot();
  }

  ArrayList<EditableElement> getEditableElements( EditableElement aEditableElement )
  {
    ArrayList<EditableElement> tElements = new ArrayList<EditableElement>();
    tElements.add( aEditableElement );

    for ( Entity iEntity : aEditableElement.childEntities )
    {
      if ( iEntity instanceof EditableElement )
      {
        tElements.addAll( getEditableElements( (EditableElement)iEntity ) );
      }
    }

    return tElements;
  }

  EditableElementListEntry addListEntryChild( EditableElement aEditableElement, EditableElement aPreviousEditableElement /*not list entry*/ )
  {
    float tChildIndentOffset = 10;

    EditableElementListEntry tEntry = new EditableElementListEntry( aEditableElement, position ); 
    addEditableChild( tEntry );
    editableElementsListMap.put( aEditableElement, tEntry );

    // Setup pinning information
    tEntry.setPin( PinEdge.PINEDGE_RIGHT, new EditableRectPinGlobalOffset( tEntry, PinEdge.PINEDGE_RIGHT, this, PinEdge.PINEDGE_RIGHT, right - marginSize.getValue(), marginSize ) );

    EditableRect tParentListEntry = editableElementsListMap.get( aEditableElement.getParent() );
    float tLeftPinValue = 0;
    Global_Float tGlobalVariable = null;
    if ( tParentListEntry != null )
    {
      tGlobalVariable = parentListChildOffset;
    }
    else
    {
      tParentListEntry = this;
      tGlobalVariable = marginSize;
    }

    tLeftPinValue = tParentListEntry.getPinnedSideValue( PinEdge.PINEDGE_LEFT ) + tGlobalVariable.getValue();
    tEntry.setPin( PinEdge.PINEDGE_LEFT, new EditableRectPinGlobalOffset( tEntry, PinEdge.PINEDGE_LEFT, tParentListEntry, PinEdge.PINEDGE_LEFT, tLeftPinValue, tGlobalVariable ) );

    float tChildSize = editableParentListEntryHeight;

    EditableRect tPinTarget = this;
    PinEdge tPinnedSide = PinEdge.PINEDGE_TOP;
    float tPinValue = getPinnedSideValue( PinEdge.PINEDGE_TOP ) + editableParentListHeadingHeight;
    EditableRectPinOffset tPin = null;
    if ( aPreviousEditableElement != null )
    {
      tPinTarget = editableElementsListMap.get( aPreviousEditableElement );
      tPinnedSide = PinEdge.PINEDGE_BOTTOM;
      tPinValue = tPinTarget.getPinnedSideValue( tPinnedSide ) + marginSize.getValue();
      tPin = new EditableRectPinGlobalOffset( tEntry, PinEdge.PINEDGE_TOP, tPinTarget, tPinnedSide, tPinValue, marginSize );
    }
    else
    {
      tPin = new EditableRectPinOffset( tEntry, PinEdge.PINEDGE_TOP, tPinTarget, tPinnedSide, tPinValue );
    }

    tEntry.setPin( PinEdge.PINEDGE_TOP, tPin );
    tEntry.setPin( PinEdge.PINEDGE_BOTTOM, new EditableRectPinOffset( tEntry, PinEdge.PINEDGE_BOTTOM, tEntry, PinEdge.PINEDGE_TOP, tChildSize ) );

    return tEntry;
  }

  void updateListEntryPins_TopBottom( EditableElement aEditableElement, EditableElement aPreviousEditableElement )
  {
    EditableElementListEntry tEntry = editableElementsListMap.get( aEditableElement );
    if ( tEntry == null ) { 
      return;
    }

    PinEdge tPinnedEdge = PinEdge.PINEDGE_BOTTOM;
    EditableElementListEntry tPreviousEntry = editableElementsListMap.get( aPreviousEditableElement );
    if ( tPreviousEntry == null )
    {
      tPinnedEdge = PinEdge.PINEDGE_TOP;
    }

    EditableRectPin tTopPin = tEntry.getPin( PinEdge.PINEDGE_TOP ); 
    tTopPin.pinnedSource = tPreviousEntry;
    tTopPin.sourcePinEdge = tPinnedEdge;
  }
}

class EditableElementListEntry extends EditableRect
{
  EditableElement linkedEditableElement;

  EditableElementListEntry( EditableElement aLinkedElement, PVector aPosition )
  {
    super( aPosition );

    linkedEditableElement = aLinkedElement;
  }

  void onSetParent( Entity aPreviousParent )
  {
    // Let's see if we need to do the pinning setup here or in parent (currently done in parent)
    super.onSetParent( aPreviousParent );
  }

  void plot()
  {
    String tDisplayString = linkedEditableElement.getClass().getSimpleName();

    PVector tWorldTopLeft = new PVector( left, top );
    //    tWorldTopLeft.add( position );
    //    tWorldTopLeft.set( localToWorld( tWorldTopLeft ) );

    fill( color_buttonText );
    textFont( font_default );
    textAlign( CENTER, CENTER );
    text( tDisplayString, tWorldTopLeft.x, tWorldTopLeft.y, right-left, bottom-top );

    super.plot();
  }
}

