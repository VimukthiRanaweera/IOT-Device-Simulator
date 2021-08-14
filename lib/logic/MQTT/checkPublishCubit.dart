import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CheckPublishCubit extends Cubit<CheckPublishState>{
  CheckPublishCubit() : super(CheckPublishState(isPublished:false));

  void CheckPublish(publish)=>emit(CheckPublishState(isPublished:publish));

}

class CheckPublishState extends Equatable{
  final bool isPublished;

  CheckPublishState({required this.isPublished});

  @override
  // TODO: implement props
  List<Object?> get props => [
    isPublished,
  ];
}