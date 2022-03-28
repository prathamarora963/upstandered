// ignore_for_file: missing_return

import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:gallery_saver/files.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:upstanders/chat/pages/Messagemodel.dart';

// import 'package:upstanders/chat/pages/chatapi.dart';
import 'package:upstanders/chat/widgets/stream_socket.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// import 'package:upstanders/home/bloc/home_bloc.dart';
// import 'package:upstanders/home/data/model/alert_data_model.dart';
import 'package:upstanders/home/view/view.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:http/http.dart' as http;

// import 'package:upstanders/main.dart';
// import 'package:upstanders/videos/view/videos_streaming_screen.dart';

class Singlechatscreen extends StatefulWidget {
  final String titless;

  Singlechatscreen({Key key, @required this.titless}) : super(key: key);

  @override
  _SinglechatscreenState createState() => _SinglechatscreenState();
}

class _SinglechatscreenState extends State<Singlechatscreen> {
  // IO.Socket socket;
  // Socket socket;
  IO.Socket socket;
  TextEditingController message = TextEditingController();
  List messages = [];
  List<MessageModel> getmessage = [];
  String alertid;
  Map data;
  List fetch = [];
  int offset = 0;
  int limit = 10;
  bool maximumcount = true;
  bool loader;
  String alerttype;
  List datalist = [];
  int userid;
  ScrollController _scrollController = ScrollController();
  List sever = [];
  bool showloader = false;

  String username;
  List<MessageModel> chat = [];
  String userimage;
  String typee = "";
  var listData;

  bool leftside = false;
  DateTime now = DateTime.now();
  StreamSocket streamSocket = StreamSocket();

  // PubsubService pubsubService;

  @override
  void initState() {
    super.initState();

    // pubsubService = PubsubService();

    // connect();

    //  listenMessage();

    showloader = true;
    connect();
    getid();

    _scrollController.addListener(pagenation);
  }

  // listenMessage() async{
  //   print("listenMessageChatScreen");
  //   pubsubService.listenMessage();
  // }

  void getid() async {
    // print("getid run");
    var alert = await localDataHelper.getStringValue(key: ALERT_ID);
    alertid = alert;
    var type = await localDataHelper.getStringValue(key: ALERT_type);
    setState(() {
      typee = type;
      print(type);
    });
    // typee = type;
    print("typee  $typee");
    print("current id : $alertid");
    var user = await localDataHelper.getIntvalue(key: USERID);
    userid = user;
    print(userid);
    var image = await localDataHelper.getStringValue(key: USERIMAGE);
    userimage = image;
    print(userimage);

    var name = await localDataHelper.getStringValue(key: USERNAME);
    username = name;
    print(username);

    getchatdata(alertid, offset, limit).then((value) {
      for (var i in value) {
        setState(() {
          getmessage.add(i);
        });
        setState(() {});
      }
    });
    print("getmessage.length ${fetch.length}");
  }

  // void _sendmessage() {
  //   if (message.text.isNotEmpty) {
  //     channel.sink.add(message.text);
  //     print(channel);
  //   }
  // }
  @override
  void dispose() {
    socket.dispose();
    message.dispose();
    super.dispose();
    _scrollController.removeListener(pagenation);
  }

  void pagenation() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        showloader = false;
        // loader == true ? showloader = true : showloader = false;

        offset = offset + limit;
      });

      if (getmessage.length < limit) {
        print("offset $offset");
      } else {
        print("message");
        getchatdata(alertid, offset, limit).then((value) {
          for (var i in value) {
            setState(() {
              getmessage.add(i);
            });
          }
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent + 150,
              duration: Duration(milliseconds: 5),
              curve: Curves.easeOut);
        });
      }
    }
  }

  void connect() {
    socket = IO.io("http://52.14.21.106:3000/quiz", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) async {
      print("connected");

      socket.on('send_message', (data) async {
        setmessage(data['message'], data['user_id'], data['user_image'],
            data['user_name']);
      });
    });

    print(socket.connected);

    // IO.Socket socket = IO.io('http://52.14.21.106:3000/quiz',
    //     OptionBuilder().setTransports(['websocket']).build());

    // socket.onConnect((data) {
    //   print(socket.connected);
    //   print('connected');
    //   print(data);
    // });
    // //When an event recieved from server, data is added to the stream
    // socket.on('event', (data) => streamSocket.addResponse);

    // // socket.on('user_connected', (data) => print('connect: $data'));

    // socket.onDisconnect((data) => print(data));
    //Connect standard in to the socket
  }

  void sendmessage(String message, int userid, String alertid, String username,
      String userimage, String createat) async {
    setmessage(message, userid, userimage, username);
    socket.emit("send_message",
        // ignore: equal_keys_in_map
        {
          "message": message,
          "user_id": userid,
          "alert_id": alertid,
          // ignore: equal_keys_in_map
          "user_name": username,
          "user_image": userimage,
          "create_at": createat
        });
    var alert = await localDataHelper.getStringValue(key: ALERT_ID);

    // getchatdata(alert).then((value) {
    //   for (var i in value) {
    //     setState(() {
    //       chat.add(i);
    //     });
    //   }
    // });
  }

  void setmessage(String message, int userid, String image, String name) {
    MessageModel messageModel = MessageModel(
        message: message, userid: userid, image: image, name: name);
    if (mounted) {
      setState(() {
        getmessage.add(messageModel);
        // showloader =
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 150,
            duration: Duration(milliseconds: 5),
            curve: Curves.easeOut);

        // _scrollController.animateTo(
        //   _scrollController.position.maxScrollExtent + 0,
        // );
      });
    }
  }

  void dataHandler(data) {
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            leading: IconButton(
              onPressed: () async {
                await localDataHelper.saveValue(key: BOOLVAL, value: false);
                Navigator.pop(context);
              },
              icon: Image.asset(
                BACK_BUTTON,
                height: 20,
                width: 20,
              ),
            ),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "${getmessage.length > 0 ? getmessage[0].alerttype == null ? "" : getmessage[0].alerttype.toUpperCase() : ""} ALERT",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "${getmessage.length > 0 ? getmessage[0].totalnumber == null ? "" : getmessage[0].totalnumber : ""} Helpers",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
            backgroundColor: Color(0xffFFC845),
          ),
          preferredSize: Size.fromHeight(70.0),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: getmessage.length,
                        itemBuilder: (context, index) {
                          print(
                              "getmessage alertid ${getmessage[index].alertid}");
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 20, top: 20),
                              //   child: Container(
                              //     width: 50,
                              //     height: 20,
                              //     decoration: BoxDecoration(
                              //         color: Colors.transparent,
                              //         // color: Color(0xffFFC938),
                              //         borderRadius: BorderRadius.circular(30)),
                              //     child: Column(
                              //       children: [],
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                              // SizedBox(
                              //   height: 4,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  children: [
                                    // CircleAvatar(
                                    //   backgroundImage: AssetImage(AVTAR),
                                    //   backgroundColor: Colors.transparent,
                                    //   radius: 30.0,
                                    // ),
                                    // SizedBox(
                                    //   width: 11,
                                    // ),
                                    // Material(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   elevation: 5,
                                    //   child: Container(
                                    //     decoration: BoxDecoration(
                                    //         borderRadius: BorderRadius.circular(10),
                                    //         color: Color(0xffFFC938)),
                                    //     child: Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       mainAxisAlignment: MainAxisAlignment.center,
                                    //       children: [
                                    //         Text(
                                    //           messages[index],
                                    //           style: TextStyle(
                                    //               fontSize: 18,
                                    //               fontWeight: FontWeight.bold),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 3,
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 25),
                                    //   child: Container(
                                    //     child: Text(
                                    //         "${now.hour.toString()}:${now.minute.toString()}"),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    getmessage[index].userid == userid
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.0015,
                                  ),
                                  getmessage[index].userid != userid
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Color(0xffFFC938)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                      "${getmessage[index].name}"),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  "${getmessage[index].image}"),
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 20.0,
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 5,
                                      child: Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xffFFC938)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Container(
                                                    constraints: new BoxConstraints(
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            90),
                                                    child: ExpandableText(
                                                      getmessage[index].message,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      expandText: 'show more',
                                                      collapseText: "show less",
                                                      maxLines: 3,
                                                      linkColor: Colors.blue,
                                                    )
                                                    //  Text(
                                                    //   getmessage[index].message,
                                                    //   maxLines: 1,
                                                    //   overflow: TextOverflow.ellipsis,
                                                    //   softWrap: false,
                                                    //   style: TextStyle(
                                                    //       fontSize: 18,
                                                    //       fontWeight:
                                                    //           FontWeight.bold),
                                                    // ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 11,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }),
                  ),
                  // StreamBuilder(
                  //   builder: (context, snapshot) {
                  //     return Padding(
                  //       padding: EdgeInsets.all(20),
                  //       child: Text(snapshot.hasData ? '${snapshot.data}' : ""),
                  //     );
                  //   },
                  //   stream: channel.stream,
                  // ),

                  Row(
                    children: [
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Form(
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: message,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Image.asset(SEND_BUTTON),
                                onPressed: () async {
                                  if (message.text.isNotEmpty) {
                                    loader = false;
                                    _scrollController.animateTo(
                                        _scrollController
                                                .position.maxScrollExtent +
                                            150,
                                        duration: Duration(milliseconds: 5),
                                        curve: Curves.easeOut);
                                    sendmessage(message.text, userid, alertid,
                                        username, userimage, now.toString());
                                    this.setState(
                                        () => messages.add(message.text));
                                    showloader = false;
                                    message.clear();
                                  }
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              // focusColor: Colors.black,
                              hintText: "Type a message here...",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  )
                ],
              ),
              Visibility(
                  visible: showloader,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Color(0xffFFC938),
                  )))
            ],
          ),
        ),
      ),
    );
  }

  Future<List<MessageModel>> getchatdata(
      String alertid, int offset, int limit) async {
    var token = await localDataHelper.getStringValue(key: TOKEN);
    print(alertid);
    print("token  $token");
    final response = await http.get(
        Uri.parse(
            "http://52.14.21.106:3000/api/v1/get-chat-list/$alertid/$limit/$offset"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "$token"
        });

    if (response.statusCode == 200) {
      setState(() {
        showloader = false;
      });
      data = jsonDecode(response.body);

      print(data);
      fetch = data['data'];
      print(fetch);

      return fetch
          .map<MessageModel>((json) => MessageModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  void scroll() {
    showloader = false;
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 150,
        duration: Duration(milliseconds: 5),
        curve: Curves.easeOut);
  }

// ignore: unused_element

}

class Datafromserver {
  final String message;
  final int alertid;
  final int userid;

  Datafromserver({this.alertid, this.message, this.userid});

  factory Datafromserver.fromJson(Map<String, dynamic> json) {
    return Datafromserver(
      message: json['message'] as String,
      alertid: json['alert_id'] as int,
      userid: json['user_id'] as int,
    );
  }
}
