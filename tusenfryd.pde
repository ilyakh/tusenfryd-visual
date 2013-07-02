import au.com.bytecode.opencsv.*;


import processing.video.*;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;

import java.io.*;

// creates main camera stream
Movie mainCam;
// creates face camera stream
// Movie faceCam;

Metric screenSize;
List entries;






void setup() { 

  colorMode( HSB, 100 );
  imageMode( CENTER );
  background( 0 );

  screenSize = new Metric( 900, 820 );

  size(
  screenSize.x, 
  screenSize.y
    );

  // load movie
  mainCam = new Movie( this, "test.mov" );
  mainCam.loop();

  entries = getEntries();
  
  println( mainCam.duration() );


}

void draw() {
  image( mainCam, screenSize.x / 2, screenSize.y / 2 );
}





// Called every time a new frame is available to read
void movieEvent( Movie m ) {
  m.read();
  clear();
 
  // watermark current time and duration
  textSize( 40 ); 
  text( 
    ceil( m.time() ) + "/" + 
    ceil( mainCam.duration() ), 
    600, 
    100 
  );
  
  // draw a current position cursor
  line( 
    timeToPosition( mainCam, screenSize.x ),
    600, 
    100, 
    100 
  );
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
  return elapsed(m) * axis;
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

 
