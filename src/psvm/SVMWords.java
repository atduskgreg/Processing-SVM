package psvm;

import java.util.ArrayList;

import processing.core.*;
import libsvm.*;

public class SVMWords {
	private SVM model;
	private SVMProblem problem;
	private ArrayList<String> trainingDocuments;
	private int[][] trainingVectors;
	
	private ArrayList<Integer> labels;
	private ArrayList<String> globalDictionary;
	PApplet parent;
	
	private int numCategories;
	
	public SVMWords(PApplet parent){
		this.parent = parent;
		model = new SVM(parent);
		problem = new SVMProblem();
		trainingDocuments = new ArrayList<String>();
		labels = new ArrayList<Integer>();
		globalDictionary = new ArrayList<String>();
		numCategories = 2;
	}
	
	// shared
	public void setNumCategories(int n){
		numCategories = n;
	}
	
	// shared
	public int getNumCategories(){
		return numCategories;
	}
	
	// shared
	public void addTrainingData(Object input, int label){
		trainingDocuments.add((String)input);
		labels.add(label);
	}
	
	private void buildGlobalDictionary() {
		  globalDictionary = new ArrayList<String>();
		  for(String doc : trainingDocuments){
		    String words[] = parent.split(doc, ' ');
		    for (int w = 0; w < words.length; w++) {
		      String word = words[w].toLowerCase();
		      word = word.replaceAll("\\W", "");
		      if (!globalDictionary.contains(word)) {
		        globalDictionary.add(word);
		      }
		    }
		  }

		 /* for(String doc : testDocuments){
		    String words[] = parent.split(doc, ' ');
		    for (int w = 0; w < words.length; w++) {
		      String word = words[w].toLowerCase();
		      word = word.replaceAll("\\W", "");
		      if (!globalDictionary.contains(word)) {
		        globalDictionary.add(word);
		      }
		    }
		  } */

		  //parent.println(globalDictionary);
		}
	
	// shared
	private void convertDataItemToVector(Object input){
		
	}
	
	// in base-class
	private void convertDataToVectors(ArrayList input){
		for (Object i : input){
			convertDataItemToVector(i);
		}		
	}
	
	
	
	// shared
	public void train(){
		trainingVectors = new int[trainingDocuments.size()][numCategories-1];
		
		convertDataToVectors(trainingDocuments);
		
		problem.setNumFeatures(numCategories-1);

		
		problem.setSampleData(labels.toArray(new Integer[labels.size()]), trainingVectors);
	}
	
	//shared
	public double test(){
		return 0.0;
	}
}
