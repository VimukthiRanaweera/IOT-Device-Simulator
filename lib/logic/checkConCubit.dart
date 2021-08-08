

import 'package:bloc/bloc.dart';

class CheckConCubit extends Cubit<CheckConState>{
  CheckConCubit() : super(CheckConState(isconnected:false));

  void CheckConnection(check) =>emit(CheckConState(isconnected:check));

}

class CheckConState {

  late bool isconnected;
  CheckConState({required this.isconnected});
}