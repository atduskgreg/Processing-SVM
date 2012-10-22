/*

This sketch uses image color and Support Vector Machines
to distinguish pictures of birds from pictures of squirrels.
It calculates a color histogram for each picture and uses
that as the feature vector for training an SVM.

The SVM is trained using the images in the folders named
"birds" and "squirrels" and then tested on the images
in the folder named "test" to establish a success percentage.

The test images are then displayed with their histograms
and their classification result.

*/

import psvm.*;

SVM model;

// declare Histogram object
Histogram histogram;
// "bin" the histogram into 32 separate
// color groups
int numBins = 32;

PImage testImage;
double testResult;

int[] labels; // 1 = squirrel, 2 = bird
float[][] trainingData;
String[] testFilenames;

void setup() {
  size(600, 600);
  textSize(32);
  
  // get the names of all of the image files in the "squirrel" folder
  java.io.File squirrelFolder = new java.io.File(dataPath("squirrels"));
  String[] squirrelFilenames = squirrelFolder.list();

  // get the names of all of the image files in the "birds" folder
  java.io.File birdFolder = new java.io.File(dataPath("birds"));
  String[] birdFilenames = birdFolder.list();

  // initialize labels and trainingData arrays
  // one label for each training image
  labels = new int[squirrelFilenames.length + birdFilenames.length];
  // one vector for each training image
  // each vector has 3 entries for each bin
  // one each for R, G, and B
  trainingData = new float[labels.length][numBins*3];
  
  // create the histogram object and tell it how many
  // bins we want
  histogram  = new Histogram();
  histogram.setNumBins(numBins);

  // build vectors for each squirrel image
  // and add the appropriate label
  for (int i = 0; i < squirrelFilenames.length; i++) {
    println("loading squirrel " + i);
    trainingData[i] = buildVector(loadImage("squirrels/" + squirrelFilenames[i]));
    labels[i] = 1;
  }

  // build vectors for each bird image
  // and add the appropriate label
  for (int i = 0; i < birdFilenames.length; i++) {
    println("loading bird " + i);
    trainingData[i + squirrelFilenames.length] = buildVector(loadImage("birds/" + birdFilenames[i]));
    labels[i+ squirrelFilenames.length] = 2;
  } 

  // setup our SVM model
  model = new SVM(this);
  SVMProblem problem = new SVMProblem();
  // each vector will have three features for each bin
  // in our histogram: one each for red, green, and blue
  // components
  problem.setNumFeatures(numBins*3);
  // set the data and train the SVM
  problem.setSampleData(labels, trainingData);
  model.train(problem);
  
  // load in the test images
  java.io.File testFolder = new java.io.File(dataPath("test"));
  testFilenames = testFolder.list();
  
  // run the evaluation (see function for more)
  evaluateResults();
  // loads and tests a new image from the test folder
  loadNewTestImage();
}

// This function calculates the histogram for a PImage
// and scales it so that the sum of each RGB entry is 1
// the results are used as the feature vector for SVM
float[] buildVector(PImage img) {
  histogram.setImage(img);
  histogram.calculateHistogram();
  histogram.scale(0, 0.33);
  return histogram.getRGB();
}

void draw() {
  background(0);
  
  pushMatrix();
  scale(0.5);
  image(testImage, 0, 60);
  popMatrix();
  
  // testResult is set in loadNewTestImage()
  String message = "";
  if((int)testResult == 1){
    message = "Squirrel";
  } 
  else if((int)testResult == 2){
    message = "Bird";
  }
  
  fill(255);
  text(message, 10, 25);
  text("Percent classified correctly: " + nf(correctPercentage * 100,2,2), 20, height -40);
  stroke(255);
  histogram.drawRGB(0, height/2, width, height/2);
}

// Loads up a new random image.
// Runs in through the SVM for classification.
// Stores the results in the testResult variable.
void loadNewTestImage(){
  int imgNum = (int)random(0, testFilenames.length-1);
  testImage = loadImage("test/" + testFilenames[imgNum]); 
  testResult = model.test(buildVector(testImage));
}

void keyPressed(){
  loadNewTestImage();
}

float correctPercentage = 0.0;

void evaluateResults(){
  int numCorrect = 0;
  PImage img;
  
  for (int i = 0; i < testFilenames.length; i++) {
    img = loadImage("test/" + testFilenames[i]); 
    double r = model.test(buildVector(img));
    if(r == 1.0 && split(testFilenames[i], "-")[0].equals("Squirrel")){
      numCorrect++;
    }
    
    if(r == 2.0 && split(testFilenames[i], "-")[0].equals("Bird")){
      numCorrect++;
    }
  }
  
  correctPercentage = (float)numCorrect/testFilenames.length;
  
  println("Num Bins: " + numBins + " Percent Correct: " + correctPercentage);
}
