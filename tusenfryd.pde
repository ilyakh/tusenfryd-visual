import au.com.bytecode.opencsv.*;

import processing.video.*;
import java.util.List;

import java.io.*;

Movie primaryVideo;
Movie secondaryVideo;

Metric screenSize;
List<String[]> entries;

final float primaryOffset = 168; // +1 sekund
final float secondaryOffset = 167;

int secondaryVideoWidth;
int secondaryVideoHeight;

Graph graph;


void setupVideo() {
  
  primaryVideo = new Movie( this, "chest.mp4" );
  primaryVideo.frameRate( 24 );
  primaryVideo.play();
  
  secondaryVideo = new Movie( this, "face.mp4" );
  secondaryVideo.frameRate( 24 );
  secondaryVideo.play();
  
  // skip to the offset
  primaryVideo.jump( primaryOffset );
  secondaryVideo.jump( secondaryOffset );  
  
}


void setupData() {
  entries = getEntries();
  graph = new Graph( primaryVideo, entries, screenSize.y - 50 );
  
  println( graph.getStartTime()[1] );
  println( graph.getEndTime()[1] );
  
  
  
}


void setup() { 

  // sketch options
  colorMode( HSB, 100 );
  imageMode( CENTER );
  strokeJoin( ROUND );
  background( 0 );
  frameRate( 30 );
  
  
  // metrics
  screenSize = new Metric( 720, 480 );
  
  secondaryVideoWidth = floor( screenSize.x / 2 );
  secondaryVideoHeight = floor( (secondaryVideoWidth / 4.0 * 3.0) );

  size( screenSize.x, screenSize.y );
  
  setupVideo();
  setupData();

}



void draw() {
  if ( primaryVideo.available() ) {
    primaryVideo.read();
  }
  
  image( 
    primaryVideo, 
    screenSize.x / 2, 
    screenSize.y / 2 
  );
  
  if ( secondaryVideo.available() ) {
    secondaryVideo.read();    
  } 
  
  image( 
    secondaryVideo, 
    screenSize.x - ( secondaryVideoWidth / 2 ), 
    screenSize.y - ( secondaryVideoHeight / 2 ),
    secondaryVideoWidth, 
    secondaryVideoHeight
  );


  int cursorPosition = timeToPosition( primaryVideo, screenSize.x );


  // watermark current time and duration
  textSize( 40 ); 
  text( 
    ceil( primaryVideo.time() ) + "/" + 
    ceil( primaryVideo.duration() ), 
    cursorPosition, 
    screenSize.y - 100 + 40
  );
  
  // draw a current position cursor
  stroke( 100, 100, 100 );
  strokeWeight( 3 );
  line( 
    cursorPosition,
    screenSize.y - 100, 
    cursorPosition,
    screenSize.y
  );
  
  noStroke();
  rect( 
    0, 
    screenSize.y - 100, 
    screenSize.x, 
    screenSize.y 
  );
  noFill();
  
  graph.render();
  
}




/* // Alternative way of fetching frames

// Called every time a new frame is available to read
void movieEvent( Movie m ) {
  m.read();
  
  if ( m.equals( primaryVideo ) ) {  // allow only the primary video to flush screen
    clear();
  }
}

*/



List getEntries() {
  List result;
  
  try {
    CSVReader reader = new CSVReader( 
      emulateFileReader( dataPath( "test.txt" ) )
    );
    result = reader.readAll();
    return result;
  } 
  catch ( IOException e ) {
    return null;
  }
}

int timeToPosition( Movie m, int axis ) {
  return (int) round( elapsed(m) * axis );
}

float elapsed( Movie m ) {
   return m.time() / m.duration();
}



/**
 *
 *  Workaround
 *
 */
 
static public BufferedReader emulateFileReader( String filename ) {
  try {
    BufferedReader reader =
      new BufferedReader(new InputStreamReader( createInput( new File(filename) ), "UTF-8"));

    return reader;
  } 
  catch ( IOException e ) {
    e.printStackTrace();
  }
  return null;
}

 
