import 'package:bloc/bloc.dart';

class CheckPublishCubit extends Cubit<CheckPublishState>{
  CheckPublishCubit() : super(CheckPublishState(isPublished:false));

  void CheckPublish(publish)=>emit(CheckPublishState(isPublished:publish));

}

class CheckPublishState{
  late bool isPublished;

  CheckPublishState({required this.isPublished});
}