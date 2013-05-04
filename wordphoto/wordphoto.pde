import beads.*;

AudioContext ac;
PowerSpectrum ps;

void setup() {
  size(800,800);
  ac = new AudioContext();

  UGen microphoneIn = ac.getAudioInput();
// set up our usual master gain object
  Gain g = new Gain(ac, 1, 0.5);
g.addInput(microphoneIn);
ac.out.addInput(g);
//ac.start();

//  String audioFile = "/tmp/test.mp3";
//  SampleManager.setBufferingRegime(Sample.Regime.newStreamingRegime(1000));
//  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFile));
  //Gain g = new Gain(ac, 2, 0.2);
//  g.addInput(player);
//  ac.out.addInput(g);
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

void draw()
{
  background(back);
  stroke(fore);
  
  float[] features = ps.getFeatures();
  if(features != null) {
    //scan across the pixels
    for(int i = 0; i < width; i++) {
      int featureIndex = i * features.length / width;
      int vOffset = height - 1 - Math.min((int)(Math.log(features[featureIndex])/Math.log(0.00001) * height), height - 1);
      line(i,height,i,vOffset);
    }
  }
}

