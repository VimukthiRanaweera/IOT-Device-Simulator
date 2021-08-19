
part of 'httpBloc.dart';

class HttpEvents extends Equatable{
  @override
  List<Object?> get props =>[];
}

class HttpPost extends HttpEvents{
  final String _message;
  final String _url;

  HttpPost(this._message, this._url);

  @override
  List<Object?> get props =>[
    _message,
    _url,
  ];

}class MultipleHttpPost extends HttpEvents{
  final String _message;
  final String _url;
  final int _count;
  final int _time;

  MultipleHttpPost(this._message, this._url, this._count, this._time);

  @override
  List<Object?> get props =>[
    _message,
    _url,
    _count,
    _time,
  ];

}

class HttpState extends Equatable{
  @override
  List<Object?> get props =>[];
}
class HttpNotPost extends HttpState{}

class HttpPostingState extends HttpState{

  List<Object?> get props =>[];
}
class HttpMultiplePosting extends HttpState{

  List<Object?> get props =>[];
}

class HttpPostSuccessState extends HttpState{}

class HttpError extends HttpState{}