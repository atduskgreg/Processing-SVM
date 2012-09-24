import psvm.*;

SVM model;

void setup() {
  size(500, 500);
  model = new SVM(this);
  model.loadModel("model.txt",2);
}

void draw(){
  background(255);
  double[] p = new double[2];
  p[0] = (double)mouseX/width;
  p[1] = (double)mouseY/height;
  
  println(model.test(p));
  
  int result = (int)model.test(p);
  if(result == 0){
    fill(255,0,0);
  } else if(result == 1){
    fill(0,255,0);
  } else if(result == 2){
    fill(0,0,255);
  }
  
  ellipse(mouseX, mouseY, 10, 10);
}
