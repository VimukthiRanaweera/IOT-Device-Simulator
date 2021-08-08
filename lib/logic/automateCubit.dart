

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class AutomateCubit extends Cubit<AutomateState>{
  AutomateCubit() : super(AutomateState(false));

  void checkBox(bool check)=>emit(AutomateState( check));

}

class AutomateState {
  late bool isChecked;
  late int count;
  late int time;
  TextEditingController formTime = new TextEditingController();
  TextEditingController formCount = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();


  AutomateState( this.isChecked);

  bool setAutoDetails(){
    if(formKey.currentState!.validate()) {
      this.time = int.parse(this.formTime.text);
      this.count=int.parse(this.formCount.text);
      return true;
    }
    return false;

  }

}



