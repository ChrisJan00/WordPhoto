import beads.*;

AudioContext ac;

void setup() {
  size(1200,800);

  ac = new AudioContext();
  setupMicrophone();
  setupAnalysis();
  ac.start();
}

void draw()
{
  analysisStep();
  drawVisuals();
}

