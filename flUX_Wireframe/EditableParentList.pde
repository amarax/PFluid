class EditableParentList extends EditableRect
{
  ArrayList<EditableElement> cWorldEditableElementsSorted;
  HashMap<EditableElement, EditableElementListEntry> editableElementsListMap;

  EditableParentList( PVector aPosition )
  {
    super( aPosition );

    pinArray.get( PINARRAY_RIGHT ).updateOffset( position.x + 100 );
    pinArray.get( PINARRAY_BOTTOM ).updateOffset( position.y + 200 );

    cWorldEditableElementsSorted = new ArrayList<EditableElement>();

    editableElementsListMap = new HashMap<EditableElement, EditableElementListEntry>();
  }

  void update()
  {
    ArrayList<EditableElement> tNewWorldEditableElements = new ArrayList<EditableElement>();
    for ( Entity iEntity : world.entities )
    {
      if ( iEntity instanceof EditableElement && !(iEntity instanceof EditableParentList) )
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

      println( cWorldEditableElementsSorted.indexOf( iElement ) );

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
      if( tIndexAfter < cWorldEditableElementsSorted.size() )
      {
        updateListEntryPins_TopBottom( cWorldEditableElementsSorted.get( tIndexAfter ), iElement );
      }
    }

    super.update();
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
    float tMargin = 5;
    float tChildIndentOffset = 10;

    EditableElementListEntry tEntry = new EditableElementListEntry( aEditableElement, this.position ); 
    addEditableChild( tEntry );
    editableElementsListMap.put( aEditableElement, tEntry );

    // Setup pinning information
    tEntry.pinArray.set( PINARRAY_RIGHT, new EditableRectPinOffset( this, PINARRAY_RIGHT, right - tMargin ) );

    EditableRect tParentListEntry = editableElementsListMap.get( aEditableElement.getParent() );
    float tLeftPinValue = tMargin;
    if ( tParentListEntry != null )
    {
      tLeftPinValue = tParentListEntry.getPinnedSideValue( PINARRAY_LEFT ) + tChildIndentOffset;
    }
    else
    {
      tParentListEntry = this;
    }

    tEntry.pinArray.set( PINARRAY_LEFT, new EditableRectPinOffset( tParentListEntry, PINARRAY_LEFT, tLeftPinValue ) );

    float tChildSize = 15;

    EditableRect tPinTarget = this;
    int tPinnedSide = PINARRAY_TOP;
    float tPinValue = tMargin;
    if ( aPreviousEditableElement != null )
    {
      tPinTarget = editableElementsListMap.get( aPreviousEditableElement );
      tPinnedSide = PINARRAY_BOTTOM;
      tPinValue = tPinTarget.getPinnedSideValue( tPinnedSide ) + tMargin;
      tChildSize = 30; 
    }

    tEntry.pinArray.set( PINARRAY_TOP, new EditableRectPinOffset( tPinTarget, tPinnedSide, tPinValue ) );
    tEntry.pinArray.set( PINARRAY_BOTTOM, new EditableRectPinOffset( tPinTarget, tPinnedSide, tPinValue + tChildSize ) );

    return tEntry;
  }

  void updateListEntryPins_TopBottom( EditableElement aEditableElement, EditableElement aPreviousEditableElement )
  {
    float tMargin = 5;
    float tChildSize = 30;

    EditableElementListEntry tEntry = editableElementsListMap.get( aEditableElement );
    if ( tEntry == null ) { 
      return;
    }

    int tPinnedEdge = PINARRAY_BOTTOM;
    EditableElementListEntry tPreviousEntry = editableElementsListMap.get( aPreviousEditableElement );
    if( tPreviousEntry == null )
    {
      tPinnedEdge = PINARRAY_TOP;
    }
    
    tEntry.pinArray.get( PINARRAY_TOP ).pinnedSource = tPreviousEntry;
    tEntry.pinArray.get( PINARRAY_TOP ).pinnedSourceEdge = tPinnedEdge;
    tEntry.pinArray.get( PINARRAY_BOTTOM ).pinnedSource = tPreviousEntry;
    tEntry.pinArray.get( PINARRAY_BOTTOM ).pinnedSourceEdge = tPinnedEdge;
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
    String[] tClassStrings = split( linkedEditableElement.getClass().getCanonicalName(), "." );
    String tDisplayString = tClassStrings[tClassStrings.length - 1];

    rectMode( CORNERS );
    fill( color_buttonText );
    textAlign( CENTER, CENTER );
    text( tDisplayString, left, top, right, bottom );
    rectMode( CORNER );

    super.plot();
  }
}

