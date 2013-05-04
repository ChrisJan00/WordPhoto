import beads.*;
import java.util.Arrays;

AudioContext ac;
PowerSpectrum ps;

void setup() {
  size(800,800);
 
  PFont f;
  f = createFont("Arial",16,true);
  textFont(f,36);
  fill(255);

  ac = new AudioContext();
  UGen microphoneIn = ac.getAudioInput();
  // set up our usual master gain object
  Gain g = new Gain(ac, 1, 0.5);
  g.addInput(microphoneIn);
  ac.out.addInput(g);
  
  /*
   * To analyse a signal, build an analysis chain.
   */
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  FFT fft = new FFT();
  ps = new PowerSpectrum();
  sfs.addListener(fft);
  fft.addListener(ps);
  ac.out.addDependent(sfs);
  //and begin
  ac.start();
  
  index = 0;
  memory = new ArrayList<float[]>();
}


/*
 * Here's the code to draw a scatterplot waveform.
 * The code draws the current buffer of audio across the
 * width of the window. To find out what a buffer of audio
 * is, read on.
 * 
 * Start with some spunky colors.
 */
color fore = color(255, 102, 204);
color back = color(0,0,0);
float[] features = null;
ArrayList<float[]> memory = null;
int index;

void draw()
{
  background(back);
  stroke(fore);
  
  if(millis()<3000)
    text("get ready", 200, 200);
  else if(millis()<6000)
  {
    text("talk", 200,200);
    features = ps.getFeatures();
    println(features[0]);    
    float[] tmp = Arrays.copyOf(features, features.length);
    memory.add(tmp);
  }
  else
  {
    if(memory.size()!=0) {
      //scan across the pixels
      features = memory.get(index);
      index++;
      if(index==memory.size())
        index=0;
      for(int i = 0; i < width; i++) {
        int featureIndex = i * features.length / width;
        int vOffset = height - 1 - Math.min((int)(features[featureIndex]* height), height - 1);
        line(i,height,i,vOffset);
      }
    } 
  }
}

