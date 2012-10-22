package psvm;

import libsvm.*;

public class SVMProblem {
	public svm_problem problem;
	private int numFeatures;

	  public SVMProblem() {
	    problem = new svm_problem();
	    numFeatures = 1;
	  }

	  public void setNumFeatures(int _numFeatures) {
	    numFeatures = _numFeatures;
	  }
	  
	  public int getNumFeatures(){
		  return numFeatures;
	  }
	  
	  public void setSampleData(int[] labels, float[][] sampleVector){
		  problem.x = new svm_node[sampleVector.length][numFeatures];
		    problem.l = sampleVector.length;
		    problem.y = new double[problem.l];
		    for (int i = 0; i < sampleVector.length; i ++) {
		      for (int f = 0; f < numFeatures; f++) {
		        problem.x[i][f] = new svm_node();
		        problem.x[i][f].index = f+1;
		        problem.x[i][f].value = sampleVector[i][f];
		        problem.y[i] = labels[i];
		      }
		    }
		  
	  }

	  public void setSampleData(int[] labels, int[][] sampleVector) {
		  problem.x = new svm_node[sampleVector.length][numFeatures];
		    problem.l = sampleVector.length;
		    problem.y = new double[problem.l];
		    for (int i = 0; i < sampleVector.length; i ++) {
		      for (int f = 0; f < numFeatures; f++) {
		        problem.x[i][f] = new svm_node();
		        problem.x[i][f].index = f+1;
		        problem.x[i][f].value = sampleVector[i][f];
		        problem.y[i] = labels[i];
		      }
		    }
	  }
	  
	  public void setSampleData(Integer[] labels, int[][] sampleVector) {
		  int[] intLabels = new int[labels.length];
		  for(int i = 0; i < labels.length; i++){
			  intLabels[i] = (int)labels[i];
		  }
		  setSampleData(intLabels, sampleVector);
	   
	  }
}
