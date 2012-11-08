/*
HandGestureRecognizerInteractive by Greg Borenstein, October 2012
Distributed as part of PSVM: http://makematics.com/code/psvm

Depends on HoG Processing: http://hogprocessing.altervista.org/

Uses a trained Support Vector Machine to detect hand gestures in live video.
SVM is trained based on Histogram of Oriented Gradients on the 
Sebastien Marcel Hand Pose Dataset: http://www.idiap.ch/resource/gestures/
*/

import hog.*;
import psvm.*;
import processing.video.*;

// Capture object for accessing video feed
Capture video;
// size of the box we'll be looking in for hand gestures
int rectW = 150;
int rectH = 150;

SVM model;
PImage testImage;

void setup() {
  size(640/2 + 60, 480/2); 
  // capture video at half size for speed
  video = new Capture(this, 640/2, 480/2);
  video.start();   
  // declare our SVM object
  model = new SVM(this);
  // load the trained svm model from the file
  // our data has 324 dimensions because
  // that's what we get from doing Histogram of Oriented
  // Gradients on a 50x50 pixel image
  model.loadModel("hand_gesture_model.txt", 324);
  // initialize our PImage at 50x50
  // we'll use this to display the part
  // of the video feed we're searching
  testImage = createImage(50, 50, RGB);
}

// video event, necessary for getting live camera
void captureEvent(Capture c) {
  c.read();
}

void draw() {
  background(0);

  // copy the pixels in the incoming video
  // into our testImage. Only use the pixels
  // inside the 150x150 square at the center
  // also resize down to 50x50 (last two arguments)
  // (the subtractions are to make sure we get the pixels
  // in our red box)
  testImage.copy(video, video.width - rectW - (video.width - rectW)/2, video.height - rectH - (video.height - rectH)/2, rectW, rectH, 0, 0, 50, 50);

  // run Histogram of Oriented Gradients on the testImage
  // and pass the results to our model for testing
  double testResult = model.test(gradientsForImage(testImage)); 

  // display the video, the test image, and the red box
  image(video, 0, 0);
  image(testImage, width - testImage.width, 0);
  noFill();
  stroke(255, 0, 0);
  strokeWeight(5);
  rect(video.width - rectW - (video.width - rectW)/2, video.height - rectH - (video.height - rectH)/2, rectW, rectH);

  // use the result of our SVM test
  // to decide what text to put on the screen
  // based on what gesture is showing
  String result = "Gesture is: ";
  switch((int)testResult) {
  case 1:
    fill(255, 125, 125);
    result = result + "A";
    break;
  case 2:
    fill(125, 255, 125);
    result = result + "B";
    break;
  case 3:
    fill(125, 125, 255);
    result = result + "C";
    break;
  case 4:
    fill(125, 255, 255);
    result = result + "V";
    break;
  case 5:
    fill(255, 255, 125);
    result = result + "Five";
    break;
  case 6:
    fill(255);
    result = result + "Point";
    break;
  }
  text(result, 100, 20);
}

// Helper function that calculates the 
// Histogram of Oriented Gradients for
// a PImage, filled with a lot of HoG magic
float[] gradientsForImage(PImage img) {
  // settings for Histogram of Oriented Gradients
  // (probably don't change these)
  int window_width=64;
  int window_height=128;
  int bins = 9;
  int cell_size = 8;
  int block_size = 2;
  boolean signed = false;
  int overlap = 0;
  int stride=16;
  int number_of_resizes=5;

  // a bunch of unecessarily verbose HOG code
  HOG_Factory hog = HOG.createInstance();
  GradientsComputation gc=hog.createGradientsComputation();
  Voter voter=MagnitudeItselfVoter.createMagnitudeItselfVoter();
  HistogramsComputation hc=hog.createHistogramsComputation( bins, cell_size, cell_size, signed, voter);
  Norm norm=L2_Norm.createL2_Norm(0.1);
  BlocksComputation bc=hog.createBlocksComputation(block_size, block_size, overlap, norm);
  PixelGradientVector[][] pixelGradients = gc.computeGradients(img, this);
  Histogram[][] histograms = hc.computeHistograms(pixelGradients);
  Block[][] blocks = bc.computeBlocks(histograms);
  Block[][] normalizedBlocks = bc.normalizeBlocks(blocks);
  DescriptorComputation dc=hog.createDescriptorComputation();    

  return dc.computeDescriptor(normalizedBlocks);
}

