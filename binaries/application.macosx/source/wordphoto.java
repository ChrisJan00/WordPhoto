import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import beads.*; 
import java.util.Arrays; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class wordphoto extends PApplet {




AudioContext ac;
ArrayList<float[]> memory = null;
int index;
int state;
int timeStart;

int mode = 1;

public void setup() {
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

public void draw()
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


float[] features;

FeatureExtractor<float[],float[]> featureExtractor;

public void setupMicrophone()
{
  UGen microphoneIn = ac.getAudioInput();
  // set up our usual master gain object
  Gain g = new Gain(ac, 1, 0.5f);
  g.addInput(microphoneIn);
  ac.out.addInput(g);
}

public void setupAnalysis() 
{
  // analysis chain
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  FFT fft = new FFT();
  PowerSpectrum ps = new PowerSpectrum();
  MelSpectrum mel = new MelSpectrum(8000f, 200);
  MFCC mfcc = new MFCC(200);
  featureExtractor = mfcc;
  sfs.addListener(fft);
  fft.addListener(ps);
  ps.addListener(mel);
  mel.addListener(mfcc);
  ac.out.addDependent(sfs);
  
  initFeatures();
}

public void initFeatures() {
  features = new float[200];
  float[] featuresNew = featureExtractor.getFeatures();
  for (int i = 0; i < featuresNew.length; i++)
    features[i] = featuresNew[i];
}

public void analysisStep()
{
  float alpha = 0.6f;
  float[] featuresNew = featureExtractor.getFeatures();
  for (int i = 0; i < featuresNew.length; i++)
    features[i] = alpha * features[i] + (1-alpha) * featuresNew[i];
}
int fore = color(255, 102, 204);
int back = color(0,0,0);

public void drawVisuals() {
  background(back);
  stroke(fore);
  
  
  if(features != null) {
    //scan across the pixels
    
  //  for(int i = 0; i < width; i++) {
  //    int featureIndex = i * features.length / width;
  //    int vOffset = height - 1 - Math.min((int)(features[featureIndex]*i/width * height*10), height - 1);
  //    line(i,height,i,vOffset);
  //  }
    randomSeed(10);
    
    int paramcount = 6;
    //int params[] = new int[paramcount];
    int circlecount = features.length / paramcount;
    float data[][] = new float[circlecount][paramcount];
    
    int ndx = 0;
    
    int visiblecircles = 20;
    if (visiblecircles > circlecount) visiblecircles = circlecount;
    
      for (int i = 0; i < visiblecircles; i++) {
        for (int j=0; j < paramcount; j++) {  
        data[i][j] = features[i*paramcount + j] * (ndx+1) / features.length;
        ndx++;
      }
    }
      
   
   for (int i = 0; i < visiblecircles; i++) {
      float r = data[i][0] * 15;
      float g = data[i][1] * 15;
      float b = data[i][2] * 15;
      float a = data[i][3] * 15;
      
      
      fill(r*255, g*255, b*255, a*255);
      //stroke(r*255, g*255, b*255, a*255);
      noStroke();

      float rad = width * 5 * data[i][4];
      float ang = i * PI * 2 / (visiblecircles - 1);
      int rr = PApplet.parseInt(width * (0.5f -  10 * data[i][5]));
      int x = PApplet.parseInt(rad * cos(ang) + width / 2 - rr/2);
      int y = PApplet.parseInt(rad * sin(ang) + height / 2 - rr/2);
      
      //ellipse(x,y, rr, rr);
      rect(x,y,rr,rr);
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "wordphoto" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
