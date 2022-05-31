import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/classes/messages.dart';
import 'package:http/http.dart' as http;

import '../../Services/constants.dart';
import '../../Widgets/ChatWidget.dart';

class SingleUserChat extends StatefulWidget {
  SingleUserChat(
      {required this.id, required this.image, required this.name, key})
      : super(key: key);
  String id;
  String image, name;

  @override
  State<SingleUserChat> createState() => _SingleUserChatState();
}

class _SingleUserChatState extends State<SingleUserChat> {
  TextEditingController msgcontrl = TextEditingController();

  bool isloading = true;
  String id = "";
  final todaysDate = DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("is_logged_in"));
    // usename = prefs.getString("user_name")!;
    // email = prefs.getString("user_email")!;
    // // image = prefs.getString("image")!;
    // // id = int.parse(prefs.getString("id")!);
    id = prefs.getString("user_id") == null ? "" : prefs.getString("user_id")!;
    setState(() {});
  }

  initState() {
    super.initState();
    addStringToSF();
    // getMessages();
  }

  Future<List<message_item>> getMessages() async {
    var url = Uri.parse(base_url + ApiUrl.getMessages(widget.id));
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print("code");
    print(JsonData[0]["code"]);
    final List<message_item> message = [];
    if (JsonData[0]["code"] != 0) {
      for (var d in JsonData) {
        message_item item = message_item(d["message_id"], d["message"],
            d["user_id"], d["datetime"], d["user_name"], d["code"]);
        // ignore: invalid_use_of_protected_member
        message.add(item);
        // print(users[0].date);
      }
    } else {
      print("hhh");
    }

    print(message.length);
    isloading = false;
    return message;
  }

  sendmsg() async {
    // ProgressDialog dialog = new ProgressDialog(context);
    // dialog.style(message: 'Please wait...');
    // await dialog.show();
    try {
      var url = Uri.parse(base_url + ApiUrl.SendMessages);
      // print("done");
      var response;
      response = await http.post(url, body: {
        "message": msgcontrl.text,
        "user_id": id,
        "datetime": DateTime.now().toString(),
        "groupChat": widget.id,
        "auth_key": auth_key,
      });

      var data = json.decode(response.body);
      var code = data[0]['code'];

      if (code == 0) {
        // await dialog.hide();
        // ShowResponse("Hospital Not Added");
      } else if (code == 1) {
        setState(() {});
      } else {
        // await dialog.hide();
        // ShowResponse("Some Error Occured. Contact Support");
      }
    } catch (e) {
      print("error " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar:
          AppBar(backgroundColor: Theme.of(context).backgroundColor, actions: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.08,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: Theme.of(context).colorScheme.background,
                  )),
              Container(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: widget.image == "" ? defaultUser : widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.name,
                style: ThemeHelper().TextStyleMethod2(
                    16,
                    context,
                    FontWeight.w600,
                    Theme.of(context).colorScheme.primaryVariant),
              ),
            ],
          ),
        ),
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            //header(),
            Container(
              height: MediaQuery.of(context).size.height * 0.77,
              child: FutureBuilder<List<message_item>>(
                  future: getMessages(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.blue)),
                      );
                    } else if (snapshot.data.length == 0) {
                      return Container(
                        child: Center(
                          child: Text(
                            "Your Recent Chat Will Show here...",
                            style: ThemeHelper()
                                .TextStyleMethod1(16, context, FontWeight.w600),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          var countTime;
                          var date =
                              DateTime.parse(snapshot.data[index].datetime);
                          if (todaysDate.difference(date).inSeconds < 60) {
                            countTime = "just now";
                          } else if (todaysDate.difference(date).inMinutes <
                              60) {
                            countTime = todaysDate
                                    .difference(date)
                                    .inMinutes
                                    .toString() +
                                " mins ago";
                          } else if (todaysDate.difference(date).inHours < 24) {
                            countTime =
                                todaysDate.difference(date).inHours.toString() +
                                    " hours ago";
                          } else {
                            countTime =
                                todaysDate.difference(date).inDays.toString() +
                                    " days ago";
                          }
                          return Container(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: snapshot.data[index].user_id == id
                                    ? RightchatMsg(
                                        msg: snapshot.data[index].message,
                                        time: countTime,
                                      )
                                    : leftChatMsg(
                                        isdirect: false,
                                        username:
                                            snapshot.data[index].user_name,
                                        msg: snapshot.data[index].message,
                                        time: countTime,
                                      )),
                          );
                        },
                      );
                    }
                  }),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              // color: Theme.of(context).backgroundColor,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(5),
              width: size.width * 0.95,
              child: TextFormField(
                controller: msgcontrl,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: null,
                maxLines: null, //
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        sendmsg();
                        msgcontrl.clear();
                      },
                    ),
                    fillColor: Colors.grey.withOpacity(0.6),
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    // focusedBorder: InputBorder.none,
                    hintText: 'Message....',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.6), width: 2.0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.6), width: 2.0)),
                    labelStyle: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ]),
        ),
      ),
      // bottomSheet: Container(

      //   color: Theme.of(context).backgroundColor,
      //   margin: EdgeInsets.only(top: 10),
      //   padding: EdgeInsets.all(5),
      //   width: size.width * 0.95,
      //   child: TextFormField(
      //     controller: msgcontrl,
      //     textInputAction: TextInputAction.newline,
      //     keyboardType: TextInputType.multiline,
      //     minLines: null,
      //     maxLines: null, //
      //     cursorColor: Colors.black,
      //     style: TextStyle(color: Colors.black, fontSize: 18),
      //     decoration: InputDecoration(
      //         suffixIcon: IconButton(
      //           icon: Icon(
      //             Icons.send,
      //             color: Colors.black,
      //           ),
      //           onPressed: () {
      //             sendmsg();
      //             msgcontrl.clear();
      //           },
      //         ),
      //         fillColor: Colors.grey.withOpacity(0.6),
      //         filled: true,
      //         contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      //         // floatingLabelBehavior: FloatingLabelBehavior.never,
      //         border: InputBorder.none,
      //         // focusedBorder: InputBorder.none,
      //         hintText: 'Message....',
      //         focusedBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(15.0),
      //             borderSide: BorderSide(
      //                 color: Colors.grey.withOpacity(0.6), width: 2.0)),
      //         enabledBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(20.0),
      //             borderSide: BorderSide(
      //                 color: Colors.grey.withOpacity(0.6), width: 2.0)),
      //         labelStyle: TextStyle(color: Colors.black, fontSize: 18)),
      //   ),
      // ),
    );
  }
}

class Items {
  final String message_status;
  final String message_type;
  final String date;
  final String time;
  final String message_content;
  final String code;
  Items(this.message_status, this.message_type, this.date, this.message_content,
      this.time, this.code);
}
