float[] features;

PowerSpectrum ps;

void setupMicrophone()
{
  UGen microphoneIn = ac.getAudioInput();
  // set up our usual master gain object
  Gain g = new Gain(ac, 1, 0.5);
  g.addInput(microphoneIn);
  ac.out.addInput(g);
}

void setupAnalysis() 
{
  // analysis chain
  ShortFrameSegmenter sfs = new ShortFrameSegmenter(ac);
  sfs.addInput(ac.out);
  FFT fft = new FFT();
  ps = new PowerSpectrum();
  sfs.addListener(fft);
  fft.addListener(ps);
  ac.out.addDependent(sfs);

}

void analysisStep()
{
   features = ps.getFeatures();
}
