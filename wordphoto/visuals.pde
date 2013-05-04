color fore = color(255, 102, 204);
color back = color(0,0,0);

void drawVisuals() {
  background(back);
  stroke(fore);
  
  
  if(features != null) {
    //scan across the pixels
    for(int i = 0; i < width; i++) {
      int featureIndex = i * features.length / width;
      int vOffset = height - 1 - Math.min((int)(features[featureIndex] * height), height - 1);
      line(i,height,i,vOffset);
    }
  }
}
