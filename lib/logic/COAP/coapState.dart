import 'package:equatable/equatable.dart';

class CoapState extends Equatable{
  @override
  List<Object?> get props => [];

}

class CoapNotConnectState extends CoapState{}

class CoapConnectingState extends CoapState{}

class CoapGetSuccessState extends CoapState{
  late final String response;

  CoapGetSuccessState(this.response);

  List<Object?> get props => [
    response,
  ];
}
class CoapPostSuccessState extends CoapState{}


class CoapErrorState extends CoapState{}

