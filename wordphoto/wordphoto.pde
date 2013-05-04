import beads.*;
import java.util.Arrays;

AudioContext ac;
ArrayList<float[]> memory = null;
int index;
int state;
int timeStart;

void setup() {
  size(1200,800);
  
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
}

void draw()
{
  background(back);

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
    int timediff = timeStart + 20000 - millis();
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
  
}


