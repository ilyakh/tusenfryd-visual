import au.com.bytecode.opencsv.*;

import processing.video.*;
import java.util.List;

import java.io.*;

Movie primaryVideo;
Movie secondaryVideo;

Metric screenSize;
List<String[]> entries;

final float primaryOffset = 152;
final float secondaryOffset = 153;
final int dataOffset = 810;
final float aspectRatioFactor =  9 / 16.0;
final float secondaryVideoSizeFactor = 1 / 3.2;

int secondaryVideoWidth;
int secondaryVideoHeight;

Graph graph;

boolean playing = false;


void setupVideo() {
  
  primaryVideo = new Movie( this, "chest.mp4" );
  // primaryVideo.play();
  
  secondaryVideo = new Movie( this, "face.mp4" );
  // secondaryVideo.play();
  
}





void setup() { 

  // sketch options
  colorMode( HSB, 100 );
  imageMode( CENTER );
  textAlign( CENTER, CENTER );
  strokeJoin( ROUND );
  // smooth( 2 );
  background( 0 );
  // frameRate( 30 );
  
  
  // metrics
  screenSize = new Metric( 1280, 720 );
  
  secondaryVideoWidth = floor( screenSize.x * secondaryVideoSizeFactor );
  secondaryVideoHeight = floor( (secondaryVideoWidth * aspectRatioFactor) );

  size( screenSize.x, screenSize.y );
  
  setupVideo();
  setupData();

}



void draw() {
  
  if ( playing ) {
  
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
     
    graph.render( primaryVideo.time() );
    graph.drawHorizontalCenterline();
    graph.drawVerticalCenterline( cursorPosition );
    graph.drawHeartbeat();
    
    // saveFrame( "output/######.tif" );
  
  }
  
}

void setupData() {
  entries = getEntries();
  entries = entries.subList( dataOffset, entries.size() );
  
  graph = new Graph( primaryVideo, entries, screenSize.y - 100, 5 );
 
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


void keyPressed() {
  if ( key == 'r' ) {
      playing = true;
      
      primaryVideo.play();
      secondaryVideo.play();
      
      primaryVideo.jump( primaryOffset );
      secondaryVideo.jump( secondaryOffset ); 

  }
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

 
