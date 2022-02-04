import 'dart:async';




// STEP1:  Stream setup
class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}



class StreamyController{
  final _response= StreamController<List<String>>();

  void Function(List<String> event) get addResponse => _response.sink.add;

  Stream<List<String>> get getResponse => _response.stream;

  void dispose(){
    _response.close();
  }
}

