import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(startIndex: 0,endIndex: 0));

  void endIndexIncrement() => emit(state.copyWith(endIndex:state.endIndex+1));

  void endIndexDecrement() => emit(state.copyWith(endIndex:state.endIndex-1));

  void startIndexChange(index) => emit(state.copyWith(startIndex:index));
}

class CounterState{
  final int startIndex;
  final int endIndex;

  CounterState({required this.endIndex,required this.startIndex});

  CounterState copyWith({
    int ?startIndex,
    int ?endIndex,
}) {
    return CounterState(
        endIndex: endIndex ?? this.endIndex,
        startIndex: startIndex ?? this.startIndex,
    );
  }
  List<Object> get props => [
    startIndex,
    endIndex
  ];
  }