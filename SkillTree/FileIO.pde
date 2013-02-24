
class CSVReader
{
  final char CSV_DELIMITER = ',';
  final char CSV_QUOTE = '"';

  BufferedReader bufferedReader;

  public CSVReader( String aFilename )
  {
    bufferedReader = createReader( aFilename );

    // TODO file validation goes here
  } 

  public ArrayList<String> readCSVLine( boolean aInQuotedEntry )
  {
    String tLine = "";

    try
    {
      tLine = bufferedReader.readLine();
    }
    catch( IOException e )
    {
    }

    int tEntryCount = 1;
    for ( int iIndex = 0; iIndex < tLine.length(); ++iIndex ) 
    { 
      if ( tLine.charAt( iIndex ) == CSV_DELIMITER ) 
        ++tEntryCount;
    }

    String[] tLineEntries = new String[tEntryCount];
    tLineEntries = split( tLine, CSV_DELIMITER );

    //for( int i = 0; i < tLineEntries.length; ++i ) { println( tLineEntries[i] ); }

    ArrayList<String> tReturnEntries = new ArrayList<String>();
    for ( int i = 0; i < tLineEntries.length; ++i )
      tReturnEntries.add( tLineEntries[i] );

    int iIndex = 0;
    while ( iIndex < tReturnEntries.size () )
    {
      String tEntry = tReturnEntries.get( iIndex );

      if ( tEntry.length() > 0 )
      {
        if ( ( iIndex == 0 && aInQuotedEntry ) || ( tEntry.charAt( 0 ) == CSV_QUOTE ) )
        {
          boolean tEndQuoteFound = false;

          // First check if current entry has an end quote
          tEndQuoteFound = checkLastCharacterForEndQuote( tEntry ) && ( tEntry.length() > 1 || iIndex == 0 );

          // Merge next entry, and if there is none read next line
          while ( iIndex + 1 < tReturnEntries.size () && !tEndQuoteFound )
          {
            tEntry = tEntry + CSV_DELIMITER + tReturnEntries.get( iIndex + 1 );
            tReturnEntries.remove( iIndex + 1 );
            tReturnEntries.remove( iIndex );
            tReturnEntries.add( iIndex, tEntry );

            tEntry = tReturnEntries.get( iIndex );
            tEndQuoteFound = checkLastCharacterForEndQuote( tEntry );
          }

          if ( !tEndQuoteFound )
          {
            ArrayList<String> tContinuedEntries = readCSVLine( true );
            tEntry = tEntry + "\n" + tContinuedEntries.get( 0 );
            tContinuedEntries.remove( 0 );

            tReturnEntries.remove( tReturnEntries.size() - 1 );
            tReturnEntries.add( tEntry );
            tReturnEntries.addAll( tContinuedEntries );
            break;
          }
        }
      }

      ++iIndex;
    }

    iIndex = 0;
    while ( iIndex < tReturnEntries.size () )
    {
      String tEntry = removeStartEndQuotes( tReturnEntries.get( iIndex ) );
      tReturnEntries.remove( iIndex );
      tReturnEntries.add( iIndex, tEntry );

      ++iIndex;
    }

    iIndex = 0;
    while ( iIndex < tReturnEntries.size () )
    {
      String tEntry = replaceDoubleQuotes( tReturnEntries.get( iIndex ) );
      tReturnEntries.remove( iIndex );
      tReturnEntries.add( iIndex, tEntry );

      ++iIndex;
    }

    return tReturnEntries;
  }

  private boolean checkLastCharacterForEndQuote( String aEntry )
  {
    if ( aEntry.length() >= 1 )
    {
      if ( aEntry.charAt( aEntry.length() - 1 ) == CSV_QUOTE )
      {
        if ( aEntry.length() >=2 )
        {
          if ( aEntry.charAt( aEntry.length() - 2 ) == CSV_QUOTE )
          {
            return false;
          }
        }

        return true;
      }
    }

    return false;
  }

  private String removeStartEndQuotes( String aEntry )
  {
    if ( aEntry.length() >= 2 )
    {
      if ( aEntry.charAt( 0 ) == CSV_QUOTE && aEntry.charAt( aEntry.length() - 1 ) == CSV_QUOTE )
      {
        aEntry = aEntry.substring( 1, aEntry.length() - 1 );
      }
    }

    return aEntry;
  }

  private String replaceDoubleQuotes( String aEntry )
  {
    String tDelimiter = "";
    tDelimiter += CSV_QUOTE;
    tDelimiter += CSV_QUOTE;
    
    String[] tSplitEntry = split( aEntry, tDelimiter );

    String tReturnString = tSplitEntry[0];

    int iIndex = 1;
    while ( iIndex < tSplitEntry.length )
    {
      tReturnString += CSV_QUOTE + tSplitEntry[iIndex];
      
      ++iIndex;
    }
    
    return tReturnString;
  }
}

