import psvm.*;

SVM model;
String[] globalDictionary;

String testDocuments[] = {
  "FREE cash for gold!!!", 
  "I love this show", 
  "This is the funniest episode ever.", 
  "Free Drugs TV SPAM SPAM SPAM",
  "Stewie is the best."
};


void loadGlobalDictionary() {
  globalDictionary = loadStrings(dataPath("dictionary.txt"));
}

int[] buildVector(String s) {
  int[] result = new int[globalDictionary.length];

  String words[] = split(s, ' ');

  // normalize the words in the test string
  for (int i = 0; i < words.length; i++) {
    String word = words[i].toLowerCase();
    words[i] = word.replaceAll("\\W", "");
  }

  for (int i = 0; i < globalDictionary.length; i++) {
    if (Arrays.asList(words).contains(globalDictionary[i])) {
      result[i] = 1;
    } 
    else {
      result[i] = 0;
    }
  }
  return result;
}

void setup() {
  size(500, 500);
  background(0);
  loadGlobalDictionary();
  model = new SVM(this);
  model.loadModel("model.txt");
  for (int i =0; i < testDocuments.length; i++) {
    double score = model.test(buildVector(testDocuments[i]));
    if(score == 0){
      fill(0,255,0);
    } else {
      fill(255,0,0);
    }
    text(testDocuments[i] + " [score: "+score+"]", 10, 20*i + 20);
  }
}
