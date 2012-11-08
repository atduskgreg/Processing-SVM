/*
HandGestureRecognizer by Greg Borenstein, October 2012
Distributed as part of PSVM: http://makematics.com/code/psvm

Depends on HoG Processing: http://hogprocessing.altervista.org/

Trains an SVM-based classifier to detect hand gestures based on Histogram
of Oriented Gradients of hand images.

Images come from the Sebastien Marcel Hand Pose Dataset:
http://www.idiap.ch/resource/gestures/
*/

// uses both HoG Processing and Processing-SVM
import hog.*;
import psvm.*;

PImage img;

SVM model;
int[] labels; // 1 = A, 2 = B, 3 = C, 4 = V, 5 = five, 6 = Point
String[] trainingFilenames, testFilenames;
float[][] trainingFeatures;

PImage testImage;
double testResult = 0.0;

void setup() {
  size(200, 100); 

  // get the names of all of the files in the "train" folder
  java.io.File folder = new java.io.File(dataPath("train"));
  trainingFilenames = folder.list();

  // setup labels array with space for labels for each
  // training file
  labels = new int[trainingFilenames.length];
  trainingFeatures = new float[trainingFilenames.length][324];

  // load in the labels based on the first part of 
  // the training images' filenames
  for (int i = 0; i < trainingFilenames.length; i++) {
    println(trainingFilenames[i]);
    // split the filename by "-" and look at the first part
    // to decide the label
    String gestureLabel = split(trainingFilenames[i], '-')[0];
    if (gestureLabel.equals("A")) {
      labels[i] = 1;
    }

    if (gestureLabel.equals("B")) {
      labels[i] = 2;
    }

    if (gestureLabel.equals("C")) {
      labels[i] = 3;
    }

    if (gestureLabel.equals("V")) {
      labels[i] = 4;
    }

    if (gestureLabel.equals("Five")) {
      labels[i] = 5;
    }

    if (gestureLabel.equals("Point")) {
      labels[i] = 6;
    }

    // calcualte the Histogram of Oriented Gradients for this image
    // use its results as a training vector in our SVM
    trainingFeatures[i] = gradientsForImage(loadImage("train/" + trainingFilenames[i]));
  }

  model = new SVM(this);
  SVMProblem problem = new SVMProblem();
  // HoG always gives us back 324 gradients
  // for a 50x50 image.
  problem.setNumFeatures(324);
  // load the problem with the labels and training data
  problem.setSampleData(labels, trainingFeatures);
  // train the model
  model.train(problem);
  
  // save our model file as a text file
  model.saveModel("hand_gesture_model.txt");

  // get a list of the names of the files in the "test" folder
  java.io.File testFolder = new java.io.File(dataPath("test"));
  testFilenames = testFolder.list();
  // test a new random image
  testResult = testNewImage();
}

// Function to test a new random image from the test folder
// it returns the result of the SVM classification
double testNewImage() {
  // pick a random number between 0 and the number of test images
  int imgNum = (int)random(0, testFilenames.length-1);
  // load a test image
  testImage = loadImage("test/" + testFilenames[imgNum]);
  return model.test(gradientsForImage(testImage));
}

void draw() {
  background(0);
  image(testImage, 0, 0);

  String result = "Gesture is: ";

  // display the name of the gesture
  // in a different color depending on
  // the result of our SVM test
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


  text(result, testImage.width + 10, 20);
}

void keyPressed() {
  testResult = testNewImage();
}

// Use HoG to calculate the gradients for an image.
// We'll use this as our feature vector for our SVM.
// HoG describes the shape of the object as transitions
// between bright and dark pixels.
// This function includes a lot of verbose and ugly
// code because of the HoG library.
float[] gradientsForImage(PImage img) {
  // resize the images to a consistent size:
  img.resize(50, 50);

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

