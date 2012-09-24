import psvm.*;

SVM model;

void setup() {
  size(500, 500);  
  model = new SVM(this);
  // load the model from a model file
  // the second argument is how many features the problem has 
  model.loadModel("model.txt",2);
}

void draw(){
  background(255);

  // scale the mouse point to 0-1
  float[] p = new float[2];
  p[0] = (float)mouseX/width;
  p[1] = (float)mouseY/height;
  
  // test the point,
  // convert the result to an int
  // and set the fill color based on the result
  int result = (int)model.test(p);
  if(result == 1){
    fill(255,0,0);
  } else if(result == 2){
    fill(0,255,0);
  } else if(result == 3){
    fill(0,0,255);
  }
  
  ellipse(mouseX, mouseY, 10, 10);
}
