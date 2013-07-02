class Graph {
  private Movie video;
  private List<String[]> entries;
  private int minValue, maxValue;
  private int centerline;
  private int maxPixelAmplitude;
  
  
  public Graph( Movie video, List entries, int centerline ) {
    this.video = video;
    this.entries = entries;
    this.minValue = -32768;
    this.maxValue = 32767;
    this.maxPixelAmplitude = screenSize.y - centerline;
     
    this.centerline = centerline;
  }
  
  public String[] getEndTime() {
    return this.entries.get( this.entries.size() -1); 
  }
  
  public String[] getStartTime() {
    return this.entries.get(0);
  }
  
  public void render() {
     render( 0 ); 
  }
  
  public void render( float timeOffset ) {
     this.drawCenterline();
     
     int entryOffset = toEntryOffset( timeOffset );
     
     List<String[]> currentRange;
     
     try { 
       currentRange = this.entries.subList( entryOffset, entryOffset + screenSize.x );
     } catch( IndexOutOfBoundsException e ) {
       currentRange = this.entries.subList( entryOffset, this.entries.size() );
     }
     
     float x, y, z;
     
     int counter = 0;
     String[] s;
     
     for ( int i = 0; i < this.entries.size(); i++ ) {
       
       s = this.entries.get(i);       
       
       x = Float.valueOf( s[2] );
       y = Float.valueOf( s[3] );
       z = Float.valueOf( s[4] );
       
       this.drawBar( counter++, x, 50 );
       this.drawBar( counter++, y, 75 );
       this.drawBar( counter++, z, 100 );
     }
  }
  
  public void drawBar( int x, float value, int barHue ) {
       float barHeight = value / this.maxValue * this.maxPixelAmplitude;
       stroke( barHue, 100, 100 );
       point( x, this.centerline + barHeight ); 
  }
  
  public void drawCenterline() {
     stroke( 0, 0, 50 );
     strokeWeight( 2 );
     line( 0, centerline, screenSize.x, centerline );
  }
  
  public int toEntryOffset( float timeOffset ) {
    return ceil( timeOffset / this.video.duration() * this.entries.size() ); 
  }
  
}
