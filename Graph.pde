class Graph {
  private Movie video;
  private List<String[]> entries;
  private int minValue, maxValue;
  private int horizontalCenterline;
  private int maxPixelAmplitude;
  private int pixelStep;
  
  
  public Graph( Movie video, List entries, int horizontalCenterline, int pixelStep ) {
    this.video = video;
    this.entries = entries;
    this.minValue = -32768;
    this.maxValue = 32767;
    this.maxPixelAmplitude = screenSize.y - horizontalCenterline;
    this.pixelStep = pixelStep;
    
    // pixelStep as a percentage of the horizontal screenSize
    this.pixelStep = (int) ceil( screenSize.x * 0.002 );
     
    this.horizontalCenterline = horizontalCenterline;
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
     
     int entryOffset = toEntryOffset( timeOffset );
     
     List<String[]> currentRange;
     
     try { 
       currentRange = this.entries.subList( entryOffset, entryOffset + screenSize.x );
     } catch( IndexOutOfBoundsException e ) {
       currentRange = this.entries.subList( entryOffset, this.entries.size() );
     }
     
     float x, px, y, py, z, pz;
     
     int counter = 0;
     
     String[] c, p;
     
     for ( int i = 1; i < currentRange.size(); i ++ ) {
       
       c = currentRange.get( i );
       p = currentRange.get( i -1 );
       
       x = Float.valueOf( c[2] );
       y = Float.valueOf( c[3] );
       z = Float.valueOf( c[4] ) * -1;
       
       px = Float.valueOf( p[2] );
       py = Float.valueOf( p[3] );
       pz = Float.valueOf( p[4] ) * -1;
       
       
       this.drawLine( counter-this.pixelStep, counter, px, x, 99 );
       this.drawLine( counter-this.pixelStep, counter, py, y, 66 );
       this.drawLine( counter-this.pixelStep, counter, pz, z, 33 );
       
       counter += this.pixelStep;
     }
  }
  
  public void drawBar( int x, float value, int barHue ) {
       float barHeight = value / this.maxValue * this.maxPixelAmplitude;
       stroke( barHue, 100, 85 );
       point( x, this.horizontalCenterline + barHeight ); 
  }
  
  public void drawLine( int previousX, int currentX, float previousValue, float currentValue, int barHue ) {
     float previousLineHeight = previousValue / this.maxValue * this.maxPixelAmplitude;
     float currentLineHeight = currentValue / this.maxValue * this.maxPixelAmplitude;
     strokeWeight( 1 );
     
     stroke( barHue, 100, 85 * 0.5 );
     
     line(
      previousX, 
      this.horizontalCenterline + previousLineHeight,
      currentX, 
      this.horizontalCenterline + currentLineHeight 
     );
     
     // shadow
     stroke( barHue, 100, 85 );
     
     line(
      previousX, 
      this.horizontalCenterline + previousLineHeight -1,
      currentX, 
      this.horizontalCenterline + currentLineHeight -1
     ); 
  } 
  
  public void drawHorizontalCenterline() {
     strokeWeight( 2 );
     stroke( 0, 0, 50 );
     
     line( 0, horizontalCenterline, screenSize.x, horizontalCenterline );
  }
  
  public void drawVerticalCenterline( int cursorPosition ) {
    stroke( 0, 0, 50 );
    strokeWeight( 2 );
    line( 
      cursorPosition,
      screenSize.y - ( 2 * this.maxPixelAmplitude ), 
      cursorPosition,
      screenSize.y
    ); 
  }
  
  public int toEntryOffset( float timeOffset ) {
    return ceil( timeOffset / this.video.duration() * this.entries.size() ); 
  }
  
}
