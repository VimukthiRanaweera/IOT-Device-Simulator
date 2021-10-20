import 'package:bloc/bloc.dart';
import 'package:iot_device_simulator/logic/COAP/coapApi.dart';
import 'package:iot_device_simulator/logic/COAP/coapEvents.dart';
import 'package:iot_device_simulator/logic/COAP/coapState.dart';

class CoapBloc extends Bloc<CoapEvents,CoapState>{
  CoapBloc( this.coapApi) : super(CoapNotConnectState());
  final CoapApi coapApi;
  @override
  Stream<CoapState> mapEventToState(CoapEvents event) async*{
    if(event is CoapGetEvent){
      try {
        yield CoapConnectingState();
        var response = await coapApi.get(event.host, event.port, event.uriPath);
        if(response!=null)
        yield CoapGetSuccessState(response);
        else{
          throw Exception("Error");
        }
      }catch(e){
        yield CoapErrorState();
      }

    }
    if(event is CoapPostEvent){
      try {
        yield CoapConnectingState();
        await coapApi.post(event.host,event.port,event.uriPath,event.uriTitle);
        yield CoapPostSuccessState();
      }catch(e){
        yield CoapErrorState();
      }
    }
  }
}
