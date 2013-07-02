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
  primaryVideo = new Movie( this, "chest.MP4" );
  primaryVideo.loop();
  
  //secondaryVideo = new Movie( this, "face.MP4" );
  //secondaryVideo.loop();

  entries = getEntries();
  
  println( primaryVideo.duration() );


}

void draw() {
  image( primaryVideo, screenSize.x/2, screenSize.y/2 );
  
  image( 
    secondaryVideo, 
    screenSize.x - 250, 
    screenSize.y - 250, 
    250, 
    250
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
}





// Called every time a new frame is available to read
void movieEvent( Movie m ) {
  m.read();
  
  if ( m.equals( primaryVideo ) ) {  // allow only the primary video to flush screen
    clear();
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

 
