float[] features;

FeatureExtractor<float[],float[]> featureExtractor;

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
  PowerSpectrum ps = new PowerSpectrum();
  MelSpectrum mel = new MelSpectrum(8000f, 200);
  MFCC mfcc = new MFCC(200);
  featureExtractor = mfcc;
  sfs.addListener(fft);
  fft.addListener(ps);
  ps.addListener(mel);
  mel.addListener(mfcc);
  ac.out.addDependent(sfs);

}

void analysisStep()
{
  features = featureExtractor.getFeatures();
}
