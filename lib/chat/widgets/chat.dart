import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:upstanders/chat/widgets/stream_socket.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';

class Chat extends StatefulWidget {
  final String user;

  const Chat({Key key, this.user}) : super(key: key);

  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {
  TextEditingController _messageController;
  ScrollController _controller;
  final List<dynamic> messages = [];
  IO.Socket socket;
  StreamSocket streamSocket = StreamSocket();
  StreamyController streamyController = StreamyController();
  List<String> m = [];
  String portUrl = 'http://52.14.21.106:3000/quiz';
  String portUrl1 = 'https://fierce-woodland-54750.herokuapp.com/';
  String portUrl2 = 'http://52.14.21.106:3000/chat-page';

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    print(messageText);

    if (messageText != '') {
      var messagePost = {
        'username': 'abc',
        'text': messageText,
        'sender': 'username',
        'image': 'url',
        'alert_id': '1234'
      };
      socket.on('send_message', (res) {
        print("ON SEND MESSAGE:$res");
        socket.emit('send_message', messagePost);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    connectSocket();
    // connectAndListen();
    _messageController = TextEditingController();
    _controller = ScrollController();

    // initSocket();
    // connectAndListen();
    // WidgetsBinding.instance.addPostFrameCallback((_) => {
    //       _controller.animateTo(
    //         0.0,
    //         duration: Duration(milliseconds: 200),
    //         curve: Curves.easeIn,
    //       )
    //     });
  }

  addData() {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    m.add(messageText);
    streamyController.addResponse(m);
  }

  //STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen() {
    socket =
        IO.io(portUrl, IO.OptionBuilder().setTransports(['websocket']).build());

    print('Connecting to chat servicee');
    socket.connect();

    socket.onConnect((data) {
      print('connect:$data');
      // socket.emit('connection', 'connection');
    });
    socket.onConnectError((data) {
      print('IS CONNECT ERROR:$data');
    });

    //When an event recieved from server, data is added to the stream
    // socket.on('user_connected', (data) {
    //   print("DATTATTATATTATTATATTAT:$data");
    //   streamSocket.addResponse(data);
    // });
    // socket.onDisconnect((_) => print('disconnect'));
  }

  //https://fierce-woodland-54750.herokuapp.com/

  void connectSocket() async {
    print('Connecting to chat service');
    socket = IO.io(portUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'timestampRequests': true
    });

    socket.connect();
    socket.onConnect((data) {
      print(
          'IS CONNECTED:${socket.connected}, ID :${socket.id} Data:${socket.ids}');
    });
    socket.onConnectError((data) {
      print('IS CONNECT ERROR:$data');
    });

    // socket.on('connection', (data) {
    //    print('IS CONNECTED:${socket.connect().connected}, ID :${socket.connect().id}');
    //   print('connect:$data');

    //   socket.on('user_connected', (data) {
    //     print('user_connected:$data');
    //   });

    //   // socket.on('onlineUsers', (data) {
    //   //   print("onlineUsers:$data");
    //   // });

    //   // socket.on('writingListener', (data) {
    //   //   print(data);
    //   // });
    // });
  }

  // void initSocket() {
  //   print('Connecting to chat service');
  //   socket = IO.io('http://52.14.21.106:3000', <String, dynamic>{
  //     'transports': ['websocket'],
  //     'autoConnect': false,
  //   });
  //   socket.connect();

  //   socket.onConnect((_) {
  //     socket.emit('connection');
  //     print('connected to websocket');
  //   });
  //   socket.on('user_connected', (message) {
  //     print("user_connected: $message");
  //     setState(() {
  //       messages.add(message);
  //     });
  //   });
  //   socket.on('allChats', (messages) {
  //     print(messages);
  //     setState(() {
  //       this.messages.addAll(messages);
  //     });
  //   });
  // }

  @override
  void dispose() {
    _messageController.dispose();

    socket.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width * 0.60,
              child: Container(
                child: Text(
                  'Chat',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          getData(),
          // getListData(),
          Positioned(
            bottom: 0,
            child: Container(
              height: 60,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width * 0.80,
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Message",
                        labelStyle:
                            TextStyle(fontSize: 15, color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        counterText: '',
                      ),
                      style: TextStyle(fontSize: 15),
                      keyboardType: TextInputType.text,
                      maxLength: 500,
                    ),
                  ),
                  Container(
                    width: size.width * 0.20,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.redAccent),
                      onPressed: () {
                        _sendMessage();
                        // addData();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getData() {
    return Center(
      child: Container(
        child: StreamBuilder(
          stream: streamSocket.getResponse,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Container(
              child: Text("${snapshot.data}"),
            );
          },
        ),
      ),
    );
  }

  getListData() {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        child: StreamBuilder(
          stream: streamyController.getResponse,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: ProcessingIndicator(
                size: size.height * 0.0015,
              ));
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error));
            }
            List<String> datas = snapshot.data;
            return Positioned(
                top: 0,
                bottom: 60,
                width: size.width,
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  reverse: false,
                  cacheExtent: 1000,
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      backGroundColor: Colors.yellow[100],
                      child: Container(
                        constraints: BoxConstraints(maxWidth: size.width * 0.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${datas[index]}",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10)),
                            // Text('${message['message']}',
                            //     style: TextStyle(color: Colors.black, fontSize: 16))
                          ],
                        ),
                      ),
                    );
                  },
                ));
          },
        ),
      ),
    );
  }

  _messageList(Size size) {
    return Positioned(
      top: 0,
      bottom: 60,
      width: size.width,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        reverse: true,
        cacheExtent: 1000,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          var message = messages[messages.length - index - 1];
          return (message['sender'] == widget.user)
              ? ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  backGroundColor: Colors.yellow[100],
                  child: Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('@${message['time']}',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('${message['message']}',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    ),
                  ),
                )
              : ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  backGroundColor: Colors.grey[100],
                  child: Container(
                    constraints: BoxConstraints(maxWidth: size.width * 0.7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${message['sender']} @${message['time']}',
                            style: TextStyle(color: Colors.grey, fontSize: 10)),
                        Text('${message['message']}',
                            style: TextStyle(color: Colors.black, fontSize: 16))
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
