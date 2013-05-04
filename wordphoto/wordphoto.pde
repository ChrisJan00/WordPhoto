import beads.*;

AudioContext ac;

void setup() {
  size(800,800);

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

