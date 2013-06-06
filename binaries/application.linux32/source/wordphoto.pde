import beads.*;
import java.util.Arrays;

AudioContext ac;
ArrayList<float[]> memory = null;
int index;
int state;
int timeStart;

int mode = 1;

void setup() {
  size(displayWidth,displayHeight,P2D);
  
  // setup font
  fill(255);
  textFont(createFont("Arial",16,true),36);
  index = 0;
  memory = new ArrayList<float[]>();
  state = 0;

  // setup audio
  ac = new AudioContext();
  setupMicrophone();
  setupAnalysis();
  ac.start();
  
  ellipseMode(CENTER);
}

void draw()
{
  background(back);
  fill(255);
  
  if (mode == 0) {
  if (state == 0) {
      timeStart = millis();
      state = 1;
      memory.clear();
      index = 0;
  } else if (state == 1) {
    int timediff = timeStart + 3000 - millis();
    if (timediff > 0)
      text("recording in "+String.valueOf(timediff/1000 + 1), 200, 200);
    else state = 2;
  } else if (state == 2) {
    int timediff = timeStart + 8000 - millis();
    if(timediff > 0)  {
      analysisStep();
      drawVisuals();
      memory.add(Arrays.copyOf(features, features.length));
    } else state = 3;
  } else if (state == 3) {
    int timediff = timeStart + 10000 - millis();
    if (timediff > 0) {
      text("replaying in "+String.valueOf(timediff/1000 + 1), 200, 200);
    } else state = 4;
  } else if (state == 4) {
    int timediff = timeStart + 25000 - millis();
    if (timediff > 0) {
       if(memory.size()!=0) {
          features = memory.get(index);
          index++;
          if(index==memory.size())
            index=0;
          drawVisuals();
       }
     } else state = 0;
    
  }
  } else { // mode = 1
      if (state == 0 ) {
        analysisStep();
        drawVisuals();
      }
  }
}


