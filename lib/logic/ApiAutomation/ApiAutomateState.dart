import 'package:equatable/equatable.dart';

class ApiAutomateState extends Equatable{
  @override
  List<Object?> get props => [];

}
class ExportButtonNotClickedState extends ApiAutomateState{}

class ApiCallingState extends ApiAutomateState{}

class ApiCallSuccessState extends ApiAutomateState{}

class NotConnectedState extends ApiAutomateState{}

class IncorrectXSecret extends ApiAutomateState{}

class InvalidCredential extends ApiAutomateState{}

