/**
 * ##library.name##
 * ##library.sentence##
 * ##library.url##
 *
 * Copyright ##copyright## ##author##
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author      ##author##
 * @modified    ##date##
 * @version     ##library.prettyVersion## (##library.version##)
 */

package psvm;

import java.io.IOException;
import processing.core.*;
import libsvm.*;


/**
 * PSVM is a Processing library for machine learning using Support Vector Machines. It is based on LibSVM.
 * 
 * @example TextSpamExample 
 * 
 *
 */


public class SVM {
	public final static String VERSION = "##library.prettyVersion##";
	
	  public final static int LINEAR_KERNEL = svm_parameter.LINEAR;
	  public final static int RBF_KERNEL = svm_parameter.RBF;
	  public final static int POLY_KERNEL = svm_parameter.POLY;
	  public final static int SIGMOID_KERNEL = svm_parameter.SIGMOID;
	  
	  public final static int C_SVC = svm_parameter.C_SVC;
	  public final static int NU_SVC = svm_parameter.NU_SVC;
	
	  public SVMProblem svmProblem;
	  
	  public svm_parameter params;
	  public svm_model model;
	  PApplet parent;


	  public SVM(PApplet parent) {
		this.parent = parent;
	    
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

	  public void setKernelParameters(int svmType, int kernelType, int degree, float gamma, int c){
		  params.svm_type = svmType;
		  params.kernel_type = kernelType;
		  params.degree = degree;
		  params.gamma = gamma;
		  params.C = c;
	  }
	  
	  // NOTE: The model file 
	  public void loadModel(String filename, int numFeatures) {
	    try {
	      model = svm.svm_load_model(parent.dataPath(filename));
	      svmProblem = new SVMProblem();
	      svmProblem.setNumFeatures(numFeatures);
	    } 
	    catch(IOException e) {
	      parent.println("[P-SVM] ERROR loading model. Is the model file in the data folder? " + e);
	    }
	  }

	  // Note: the sketch has to have a data folder
	  //       for this to work.
	  public void saveModel(String filename) {
	    try {
	      svm.svm_save_model(parent.dataPath(filename), model);
	    } 
	    catch(IOException e) {
	      parent.println("[P-SVM] ERROR saving model. Does your sketch have a data folder? " + e);
	    }
	  }

	  public void train(SVMProblem problem) {
	    params.gamma = (float)1/problem.problem.l;
	    params.probability = 1;

	   // parent.println("gamma: " + params.gamma);
		  //parent.
	    model = svm.svm_train(problem.problem, params);   
	    svmProblem = problem;
	  }

	  public double test(double[] testVector) {
		    svm_node[] result = new svm_node[svmProblem.getNumFeatures()];
		    for (int f = 0; f < svmProblem.getNumFeatures(); f++) {
		      result[f] = new svm_node();
		      result[f].index = f+1; 
		      result[f].value = testVector[f];
		    }
		    return svm.svm_predict(model, result);
	  }
	  
	  public double test(float[] testVector) {
		    svm_node[] result = new svm_node[svmProblem.getNumFeatures()];
		    for (int f = 0; f < svmProblem.getNumFeatures(); f++) {
		      result[f] = new svm_node();
		      result[f].index = f+1; 
		      result[f].value = testVector[f];
		    }
		    return svm.svm_predict(model, result);
	  }
	  
	  public double test(float[] testVector, double[] estimates) {
		    svm_node[] result = new svm_node[svmProblem.getNumFeatures()];
		    for (int f = 0; f < svmProblem.getNumFeatures(); f++) {
		      result[f] = new svm_node();
		      result[f].index = f+1; 
		      result[f].value = testVector[f];
		    }
		    
		    return svm.svm_predict_probability(model, result, estimates);
	  }	  
	  
	  public double test(int[] testVector) {
	    svm_node[] result = new svm_node[svmProblem.getNumFeatures()];
	    for (int f = 0; f < svmProblem.getNumFeatures(); f++) {
	      result[f] = new svm_node();
	      result[f].index = f+1; 
	      result[f].value = testVector[f];
	    }
	    return svm.svm_predict(model, result);
	  }
	}
