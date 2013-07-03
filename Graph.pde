class Graph {
  private Movie video;
  private List<String[]> entries;
  private float minValue, maxValue;
  private int horizontalCenterline;
  private int maxPixelAmplitude;
  private int pixelStep;
  private int focusMin, focusMax;
  private float outOfFocusFactor = 0.25;
  private int graphStrokeWeight = 2;
  private int heartbeatCounter = 0;
  
  public Graph( Movie video, List entries, int horizontalCenterline, int pixelStep ) {
    this.video = video;
    this.entries = entries;
    this.maxPixelAmplitude = screenSize.y - horizontalCenterline;
    this.pixelStep = pixelStep;
    
    // pixelStep as a percentage of the horizontal screenSize
    this.pixelStep = (int) ceil( screenSize.x * 0.002 );
    
    // scale y-axis dynamically
    float[] valueRange = this.getValueRange();
    // this.minValue = -32768;
    // this.maxValue = 32767;
    this.minValue = valueRange[0];
    this.maxValue = valueRange[1]; 
    
    
    //
    this.focusMin = round(screenSize.x / 3.0);
    this.focusMax = round(screenSize.x * (3/4.0));
    
    
    this.horizontalCenterline = horizontalCenterline;
  }
  
  protected float[] getValueRange() {
    float lineMax = 0;
    float lineMin = 0;
    float datasetMax = 0;
    float datasetMin = 0;
    float[] result = { datasetMin, datasetMax };
    
    for ( String[] e: this.entries ) {
      lineMax = max(
        Float.valueOf(e[2]), Float.valueOf(e[3]), Float.valueOf(e[4])
      );
      lineMin = min(
        Float.valueOf(e[2]), Float.valueOf(e[3]), Float.valueOf(e[4])
      );
      
      datasetMax = ( lineMax > datasetMax ) ? lineMax : datasetMax;
      datasetMin = ( lineMin < datasetMin ) ? lineMin : datasetMin;
    }
    
    result[0] = datasetMin;
    result[1] = datasetMax;
    return result;
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
       
       
       // apply focus to the central portion of the graph
       float focusFactor = 1.0;
       if ( counter <= focusMin || counter > focusMax ) {
         focusFactor = this.outOfFocusFactor;
       }  
       
       this.drawLine( counter-this.pixelStep, counter, px, x, 99, 100 * focusFactor, 85 * focusFactor );
       this.drawLine( counter-this.pixelStep, counter, py, y, 66, 100 * focusFactor, 85 * focusFactor );
       this.drawLine( counter-this.pixelStep, counter, pz, z, 33, 100 * focusFactor, 85 * focusFactor );
       
       counter += this.pixelStep;
     }
  }
  
  public void drawBar( int x, float value, int barHue ) {
       float barHeight = value / this.maxValue * this.maxPixelAmplitude;
       stroke( barHue, 100, 85 );
       point( x, this.horizontalCenterline + barHeight ); 
  }
  
  public void drawLine( int previousX, int currentX, float previousValue, float currentValue, float barHue, float barSaturation, float barBrightness ) {
     float previousLineHeight = previousValue / this.maxValue * this.maxPixelAmplitude;
     float currentLineHeight = currentValue / this.maxValue * this.maxPixelAmplitude;
     strokeWeight( this.graphStrokeWeight );
     
     stroke( barHue, barSaturation, barBrightness );
     
     line(
      previousX, 
      this.horizontalCenterline + previousLineHeight,
      currentX, 
      this.horizontalCenterline + currentLineHeight 
     );
     
     
     /*
     // shadow
     stroke( barHue, barSaturation, barBrightness * 0.5  );
     
     line(
      previousX, 
      this.horizontalCenterline + previousLineHeight -this.graphStrokeWeight,
      currentX, 
      this.horizontalCenterline + currentLineHeight -this.graphStrokeWeight
     ); 
     
     line(
      previousX, 
      this.horizontalCenterline + previousLineHeight +this.graphStrokeWeight,
      currentX, 
      this.horizontalCenterline + currentLineHeight +this.graphStrokeWeight
     );
    */ 
     
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
    
    fill( 0, 0, 50 );
    textSize( 22 ); 
    text( 
      ceil( primaryVideo.time() / 60 ) + ":" + ceil( primaryVideo.time() % 60 ) + " " + 
      ceil( primaryVideo.duration() / 60 ) + ":" + ceil( primaryVideo.duration() % 60 ) , 
      cursorPosition, 
      screenSize.y - 100 + 40
    );
    
  }
  
  public void drawHeartbeat() {
    this.heartbeatCounter++;
    
    if ( this.heartbeatCounter % 20 <= random( 3, 6 ) ) {
      
     fill( 100, 100, 80 );
     textSize( 110 );
     text( "♥", 100, 100 );
      
    } else {
     
      fill( 100, 100, 60 );
      textSize( 100 );
      text( "♥", 100, 100 );
      noFill();
      
    }
    
    
  }
  
  
  public int toEntryOffset( float timeOffset ) {
    return ceil( timeOffset / this.video.duration() * this.entries.size() ); 
  }
  
}
