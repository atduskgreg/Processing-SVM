import libsvm.*;

class SVMProblem{
  svm_problem problem;
  int numFeatures;
  
  SVMProblem(){
      problem = new svm_problem();
      numFeatures = 1;
  }
  
  void setNumFeatures(int _numFeatures){
    numFeatures = _numFeatures;
  }
  
  void setSampleData(int[] labels, int[][] sampleVector){

    problem.x = new svm_node[sampleVector.length][numFeatures];
    problem.l = sampleVector.length;
    problem.y = new double[problem.l];
    for(int i = 0; i < sampleVector.length; i ++){
      for(int f = numFeatures-1; f < numFeatures; f++){
        problem.x[i][f] = new svm_node();
        problem.x[i][f].index = f+1;
        problem.x[i][f].value = sampleVector[i][f];
        problem.y[i] = labels[i];
      }
    }   
  }
 
}

class SVM {
  svm_parameter params;
  svm_model model;
  SVMProblem svmProblem;
  
  SVM() {
    params = new svm_parameter();
    params.svm_type = svm_parameter.C_SVC;//NU_SVC;
    params.kernel_type = svm_parameter.LINEAR;//RBF;
    params.degree = 3;

    params.gamma = 0;
    params.C = 100;
    params.coef0 = 0;
    params.nu = 0.5;
    params.cache_size = 100;
    params.eps = 1e-3;
    params.p = 0.1;
    params.shrinking = 1;
    params.probability = 0;
    params.nr_weight = 0;
    params.weight_label = new int[0];
    params.weight = new double[0];
  }
  
  void train(SVMProblem problem){
    params.gamma = (float)1/problem.problem.l;
    println("gamma: " + params.gamma);
    model = svm.svm_train(problem.problem, params);   
    svmProblem = problem; 
  }
  
  double test(int[] testVector){
    svm_node[] result = new svm_node[svmProblem.numFeatures];
    for(int f = 0; f < svmProblem.numFeatures; f++){
      result[f] = new svm_node();
      result[f].index = f+1; 
      result[f].value = testVector[f];
    }
    return svm.svm_predict(model, result);
  }
}

