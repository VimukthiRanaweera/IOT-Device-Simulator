part of 'randomDataCubit.dart';

 class RandomDataState extends Equatable{
  late String dataString;
  String message="";
  RandomDataState({required this.dataString});

  void setData(){

    RegExp exp = RegExp(r'\$.[d]\.\d{1,}\.\d{1,}\.\d{1,}\.\d{1,}.\$');
    var matches = exp.allMatches(this.dataString);
    List patternsList=matches.map((e) => e.group(0)).toList();

    for(String pattern in patternsList){
      separatePattern(pattern);
    }

  }
  void separatePattern(String pattern){
    List characters=pattern.split('.');
    int maxNumber = int.parse(characters[5]);
    int minNumber = int.parse(characters[4]);
    int decimals = int.parse(characters[3]);

    String finalNumber=GenerateRandomNumber(maxNumber,minNumber,decimals);
    createMessage(pattern,finalNumber);
  }

  String GenerateRandomNumber(int maxNumber, int minNumber,int decimals){
    Random random = new Random();
    double randNumber= random.nextDouble()*(maxNumber-minNumber)+minNumber;
    return randNumber.toStringAsFixed(decimals);
  }

  void createMessage(String pattern,String finalNumber){

    this.dataString=this.dataString.replaceFirst(pattern, finalNumber);
  }

  @override
  List<Object> get props => [
    dataString,

  ];

}

