/*

A helper class for calculating color histograms of images.
Calculates RGB as well as HSV histograms.

Should probably be its own library.

*/

class Histogram {
  int numBins;
  int[] pixels;
  boolean calculated;
  int min, max;

  Histogram() {
    this.numBins = 256;
    this.calculated = false;
    this.min = 0;
    this.max = 255;
  }

  void setNumBins(int numBins) {
    this.numBins = numBins;
  }

  void setImage(PImage img) {
    img.loadPixels();
    this.pixels = img.pixels;
    calculated = false;
  }

  void setPixels(int[] pix) {
    this.pixels = pix;
    calculated = false;
  }

  float[] rHist;
  float[] bHist;
  float[] gHist;

  float[] hHist;
  float[] sHist;
  float[] vHist;

  int binIndexForValue(int value) {
    return value/binSize();
  }

  void calculateHistogram() {
    rHist = new float[numBins];
    gHist = new float[numBins];
    bHist = new float[numBins];
    hHist = new float[numBins];
    sHist = new float[numBins];
    vHist = new float[numBins];

    for (int i = 0; i < this.pixels.length; i++) {
      int rBright = int(red(this.pixels[i]));
      int gBright = int(green(this.pixels[i]));
      int bBright = int(blue(this.pixels[i]));

      int hBright = int(hue(this.pixels[i]));
      int sBright = int(saturation(this.pixels[i]));
      int vBright = int(brightness(this.pixels[i]));

      rHist[binIndexForValue(rBright)]++;
      gHist[binIndexForValue(gBright)]++;
      bHist[binIndexForValue(bBright)]++;

      hHist[binIndexForValue(hBright)]++;
      sHist[binIndexForValue(sBright)]++;
      vHist[binIndexForValue(vBright)]++;
    }
  }

  void scale(float min, float max) {
    for (int i = 0; i < numBins; i++) {
      rHist[i] = map(rHist[i], 0, this.pixels.length, min, max);
      gHist[i] = map(gHist[i], 0, this.pixels.length, min, max);      
      bHist[i] = map(bHist[i], 0, this.pixels.length, min, max);
      hHist[i] = map(hHist[i], 0, this.pixels.length, min, max);
      sHist[i] = map(sHist[i], 0, this.pixels.length, min, max);
      vHist[i] = map(vHist[i], 0, this.pixels.length, min, max);
    }
  }


  void setRange(int min, int max) {
    this.min = min;
    this.max = max;
  }

  int binSize() {
    return ceil((float)(max - min) / numBins);
  }

  float[] getHSV() {
    float[] result = new float[numBins * 3];
    for (int i = 0; i < numBins; i++) {
      result[i] = hHist[i];
      result[i+numBins] = sHist[i];
      result[i+(2*numBins)] = vHist[i];
    }
    return result;
  }

  float[] getRGB() {
    float[] result = new float[numBins * 3];
    for (int i = 0; i < numBins; i++) {
      result[i] = rHist[i];
      result[i+numBins] = gHist[i];
      result[i+(2*numBins)] = bHist[i];
    }
    return result;
  }

  void drawRGB(int x, int y, int w, int h) {
    // int histMax = max(histData);

    fill(255, 0, 0);
    drawChannel(rHist, x, y, w, h/3);
    fill(0, 255, 0);
    drawChannel(gHist, x, y+h/3, w, h/3);
    fill(0, 0, 255);
    drawChannel(bHist, x, y+(2*h)/3, w, h/3);
  }

  void drawChannel(float[] data, int x, int y, int w, int h) {
    int binWidth = w/numBins;

    for (int i = 0; i < numBins; i++) {
      float mappedH = map(data[i], 0, 0.33, 0, h);
      rect((i*binWidth), y, w / numBins, -mappedH);
    }
  }
}

