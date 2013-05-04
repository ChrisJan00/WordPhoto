color fore = color(255, 102, 204);
color back = color(0,0,0);

void drawVisuals() {
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
    for (int i = 0; i < circlecount; i++) {
      for (int j=0; j < paramcount; j++) {
        data[i][j] = features[i*paramcount + j] * ndx / features.length;
        ndx++;
      }
    }
      
      
   for (int i = 0; i < circlecount; i++) {
      float r = data[i][0] * 15;
      float g = data[i][1] * 15;
      float b = data[i][2] * 15;
      float a = data[i][3] * 15;
      
      
      fill(r*255, g*255, b*255, a*255);
      stroke(r*255, g*255, b*255, a*255);

      float rad = width * 5 * data[i][4];
      float ang = i * PI * 2 / circlecount;
      int x = int(rad * cos(ang) + width / 2);
      int y = int(rad * sin(ang) + height / 2);
      int rr = int(width * (0.5 -  10 * data[i][5]));
      ellipse(x,y, rr, rr);
    }
  }
}
