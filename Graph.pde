class Graph {
  private Movie video;
  private List<String[]> entries;
  private int minValue, maxValue;
  private int centerline;
  
  
  public Graph( Movie video, List entries, int centerline ) {
    this.video = video;
    this.entries = entries;
    this.minValue = -32768;
    this.maxValue = 32767;
     
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
  
  public void render( int offset ) {
     List<String[]> currentRange = this.entries.subList( offset, offset + 720 );
     
     int counter = 0;
     float barHeight = 0;
     float currentValue = 0;
     for ( String[] s: currentRange ) {
       
       currentValue = Float.valueOf( s[2] );
       
       barHeight = currentValue / this.maxValue * 50.0;
       
       
       stroke( 100, 100, 100 );
       point( counter++, screenSize.y + barHeight ); 
     }
  }
  
  public void drawBar( int barHeight, int barHue ) {
    
  }
  
}
