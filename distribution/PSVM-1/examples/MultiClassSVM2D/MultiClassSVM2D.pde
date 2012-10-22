import psvm.*;

SVM model;
float[][] trainingPoints;
int[] labels;

Table data;

PGraphics modelDisplay;
boolean showModel = false;

void setup(){
  size(500,500);
  
  // displaying the model is very slow, so we'll
  // do it in a PGraphics so we only have to do it once
  modelDisplay = createGraphics(500,500);
  
  // load the data from the csv
  data = new Table(this, "points.csv");
  
  // we'll have one training point for each line in our csv
  // each training point will have two entries (x and y)
  trainingPoints = new float[data.getRowCount()][2];
  // we need one label for each training point incdicating
  // what set the point is in (1, 2, or 3)
  labels = new int[data.getRowCount()];
  
  // loop through the CSV rows
  // to create the trainingPoints and labels
  int i = 0;
  for (TableRow row : data) {
    float[] p = new float[2];
    // scale the data from 0-1 based on the
    // range of the data
    p[0] = row.getFloat(0)/500; 
    p[1] = row.getFloat(1)/500;
    trainingPoints[i] = p;
    labels[i] = row.getInt(2);    
    i++;
  }
  
  // initialize our model and problem objects
  model = new SVM(this);
  SVMProblem problem = new SVMProblem();
  // we need one feature for each axis of the data
  // so in this case x and y means 2 features
  problem.setNumFeatures(2);
  // load the problem with the labels and training data
  problem.setSampleData(labels, trainingPoints);
  // train the model
  model.train(problem);
  
  drawModel();
}

// this function colors in each pixel of the sketch
// based on what result the model predicts for that x-y value
// it saves the results in a PGraphics object
// so that it can be displayed everytime beneath the data
void drawModel(){
  // start drawing into the PGraphics instead of the sketch
  modelDisplay.beginDraw();
  // for each row
  for(int x = 0; x < width; x++){
    // and each column
    for(int y = 0; y < height; y++){
      
      // make a 2-element array with the x and y values
      double[] testPoint = new double[2];
      testPoint[0] = (double)x/width;
      testPoint[1] = (double)y/height;
      
      // pass it to the model for testing
      double d = model.test(testPoint);
      
      // based on the result, draw a red, green, or blue dot
      if((int)d == 1){
        modelDisplay.stroke(255,0,0);
      } else if ((int)d == 2){
        modelDisplay.stroke(0, 255 ,0);
      } else if ((int)d == 3){
        modelDisplay.stroke(0, 0, 255);
      }
      
      // which will fill up the entire area of the sketch
      modelDisplay.point(x,y);
  
    }
  }
  // we're done with the PGraphics
  modelDisplay.endDraw();
}

void draw(){
  // show our model background if we want
  if(showModel){
    image(modelDisplay, 0, 0);
  } else {
    background(255);
  }
  
  stroke(255);
  
  // show all of the training points
  // in the right color based on their labels
  for(int i = 0; i < trainingPoints.length; i++){
    if(labels[i] == 1){
      fill(255,0,0);
    } else if(labels[i] == 2){
      fill(0,255,0);
    } else if(labels[i] == 3){
      fill(0,0,255);
    }
    
    ellipse(trainingPoints[i][0] * 500, trainingPoints[i][1]* 500, 5, 5);
  }
}

void keyPressed(){
  if(key == ' '){
    showModel = !showModel;
  }
  
  if(key == 's'){
      model.saveModel("model.txt");
  }
}

// on mouse click, for any given point
// test it against the model and print the result set
void mousePressed(){
  double[] p = new double[2];
  p[0] = (double)mouseX/width;
  p[1] = (double)mouseY/height;
  println((int)model.test(p));
}
