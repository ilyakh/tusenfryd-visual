import au.com.bytecode.opencsv.*;


import processing.video.*;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;

import java.io.*;

// creates main camera stream
Movie primaryVideo;
// creates face camera stream
Movie secondaryVideo;

Metric screenSize;
List entries;






void setup() { 

  colorMode( HSB, 100 );
  imageMode( CENTER );
  background( 0 );

  screenSize = new Metric( 1080, 920 );

  size(
  screenSize.x, 
  screenSize.y
    );

  // load movie
  primaryVideo = new Movie( this, "face.MP4" );
  primaryVideo.loop();
  
  secondaryVideo = new Movie( this, "chest.MP4" );
  secondaryVideo.loop();

  entries = getEntries();
  
  println( primaryVideo.duration() );


}

void draw() {
  image( primaryVideo, 250, 250, width/2, height/2 );
  image( secondaryVideo, 500, 500, width/2, height/2 );
}





// Called every time a new frame is available to read
void movieEvent( Movie m ) {
  m.read();
  
  int cursorPosition = timeToPosition( primaryVideo, screenSize.x );
  
  if ( m.equals( primaryVideo ) ) {  // allow only the primary video to flush screen
    
    clear();
    
    // watermark current time and duration
    textSize( 40 ); 
    text( 
      ceil( m.time() ) + "/" + 
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
  }
}




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

 
