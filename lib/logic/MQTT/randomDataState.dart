part of 'randomDataCubit.dart';

 class RandomDataState extends Equatable{
  late String dataString;
  String message="";
  RandomDataState({required this.dataString});

  void setData(){

    checkDoublePattern();
    checkStringPattern();


  }

  void checkDoublePattern(){
    RegExp exp1 = RegExp(r'\$[d]\$\d{1,}\$\d{1,}(\.\d{1,})?\$\d{1,}(\.\d{1,})?\$');
    var matches = exp1.allMatches(this.dataString);
    List patternsList=matches.map((e) => e.group(0)).toList();

    if(patternsList.isNotEmpty) {
      for (String pattern in patternsList) {
        separatePattern(pattern);
      }
    }
  }

  void separatePattern(String pattern){
    List characters=pattern.split('\$');
    double maxNumber = double.parse(characters[4]);
    double minNumber = double.parse(characters[3]);
    int decimals = int.parse(characters[2]);

    String finalNumber=GenerateRandomNumber(maxNumber,minNumber,decimals);
    createMessage(pattern,finalNumber);
  }

  String GenerateRandomNumber( maxNumber,minNumber,decimals){
    Random random = new Random();
    double randNumber= random.nextDouble()*(maxNumber-minNumber)+minNumber;
    return randNumber.toStringAsFixed(decimals);
  }

  void createMessage(String pattern,String finalNumber){

    this.dataString=this.dataString.replaceFirst(pattern, finalNumber);
  }


  void checkStringPattern(){
    RegExp exp = RegExp(r'\$[s]\$\{[\w\,]+\}\$');
    var matches = exp.allMatches(this.dataString);
    List patternsList=matches.map((e) => e.group(0)).toList();

    if(patternsList.isNotEmpty){
      for(var pattern in patternsList){
           separateStringPattern(pattern);

      }
    }

  }

  void separateStringPattern(String pattern){
    List words=pattern.split('\$');
    String valuesPattern=words[2];
    String values=valuesPattern.substring(1,valuesPattern.length-1);
    List valueList=values.split(',');
    String randomValue=generateRandomString(valueList);
    createStringMessage(randomValue,pattern);

  }

  String generateRandomString(valueList){
    Random random = Random();
    int index = random.nextInt(valueList.length);
    return valueList[index];
  }
  void createStringMessage(randomValue,pattern){
    this.dataString=this.dataString.replaceFirst(pattern,randomValue);
  }

  @override
  List<Object> get props => [
    dataString,

  ];

}

