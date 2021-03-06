
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'HttpRepo.dart';

part 'httpState.dart';

class HttpBloc extends Bloc<HttpEvents,HttpState>{
  HttpBloc(this.httpRepo) : super(HttpNotPost());


 final HttpRepo httpRepo;


  @override
  Stream<HttpState> mapEventToState(HttpEvents event) async*{
      if(event is HttpPost) {
        try {
          yield HttpPostingState();
          int code= await httpRepo.postHttp(event._message,event._url);
          if(code==200)
            yield HttpPostSuccessState();

        } catch (_) {
              yield HttpError();
        }
      }
      if(event is MultipleHttpPost){
        try {
          yield HttpMultiplePosting();
          int code = await httpRepo.multiplePost(
              event._message, event._url, event._count, event._time);
          if (code == 200)
            yield HttpPostSuccessState();
        }catch(_){
          yield HttpError();
        }
      }
  }




}

// class HttpState extends Equatable{
//   String message;
//   String url;
//
//   HttpState({required this.message, required this.url});
//
//   // void post() async{
//   //   var client = http.Client();
//   //   try {
//   //     var uriResponse = await client.post(Uri.parse('http://$url'),
//   //         body:message);
//   //     print(uriResponse.statusCode);
//   //     this.code=uriResponse.statusCode;
//   //   } finally {
//   //     client.close();
//   //   }
//   // }
//
//   @override
//   // TODO: implement props
//   List<Object?> get props =>[
//     url,
//     message,
//   ];
//
// }