import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'randomDataState.dart';

class RandomDataCubit extends Cubit<RandomDataState>{
  RandomDataCubit() : super(RandomDataState(dataString: ''));

  void setRandomValue(dataString)=>emit(RandomDataState(dataString: dataString));

}