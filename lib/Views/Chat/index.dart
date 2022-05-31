import 'dart:convert';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/Chat/DirectChatScreen.dart';
import 'package:soloconneckt/Widgets/ShowResponse.dart';
import 'package:http/http.dart' as http;
import 'package:soloconneckt/classes/DirectChat.dart';

import '../../Services/ApiCalling.dart';
import '../../Services/constants.dart';
import '../../classes/ChatGroup.dart';
import 'ChatScreen.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  int tag = 0;

  int tabindex = 0;
  List<String> options = [
    'Featured Topics',
    'Most Recent',
    'Related Topics',
    'Related Topics',
  ];

  String id = "";

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("user_id")!;
    // String? islogin2 = prefs.getString("is_logged_in");
    setState(() {});
    // getChat();
    // getDirectChat();
  }

  Future<List<DirectChat_item>> getDirectChat() async {
    var url = Uri.parse(base_url + ApiUrl.getDirectChat(id));
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);

    List<DirectChat_item> Directchat = [];
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        DirectChat_item item = DirectChat_item(
          d["id"],
          d["image"],
          d["message_content"],
          d["user_name"],
          d["user_id"],
        );
        // ignore: invalid_use_of_protected_member
        Directchat.add(item);
        // print(users[0].date);
      }

    return Directchat;
  }

  Future<List<Chat_item>> getChat() async {
    var url = Uri.parse(base_url + ApiUrl.getChat);
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    List<Chat_item> chat = [];
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        Chat_item item = Chat_item(
          d["id"],
          d["image"],
          d["ispublic"],
          d["name"],
          d["user_id"],
        );
        // ignore: invalid_use_of_protected_member
        chat.add(item);
        // print(users[0].date);
      }
    return chat;
  }

  @override
  void initState() {
    addStringToSF();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forum",
                    style: ThemeHelper()
                        .TextStyleMethod1(18, context, FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ChipsChoice<int>.single(
              value: tag,
              onChanged: (val) => setState(() => tag = val),
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
                tooltip: (i, v) => v,
              ),
              choiceBuilder: (item) {
                return InkWell(
                  onTap: () {
                    item.select(!item.selected);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: item.selected
                            ? Theme.of(context).colorScheme.primaryVariant
                            : Theme.of(context).backgroundColor,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5),
                      child: Text(
                        item.label,
                        style: TextStyle(
                            fontSize: 14,
                            color: item.selected
                                ? Theme.of(context).backgroundColor
                                : Theme.of(context).colorScheme.primaryVariant,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                  labelColor: Theme.of(context).colorScheme.primaryVariant,
                  indicatorColor: Theme.of(context).colorScheme.primaryVariant,
                  onTap: (value) {
                    setState(() {
                      tabindex = value;
                    });
                  },
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Montserrat"),
                  tabs: [
                    Tab(
                      text: 'Public',
                    ),
                    Tab(
                      text: 'Private',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Column(
            //   children: [
            //     Center(
            //       child: Text(
            //           "Your recent chat will appear here..",
            //           style: ThemeHelper().TextStyleMethod1(
            //               14, context, FontWeight.bold),
            //         ),
            //     )
            //   ],
            // )
            if (tabindex == 0)
              FutureBuilder<List<Chat_item>>(
                  future: getChat(),
                  builder:
                      ((BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                            "Your Recent Story Will Show here...",
                            style: ThemeHelper()
                                .TextStyleMethod1(16, context, FontWeight.w600),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext, index) => chatBubble(
                                currentUser: id,
                                image: snapshot.data[index].image,
                                id: snapshot.data[index].user_id,
                                name: snapshot.data[index].name,
                              ));
                    }
                  }))
            else
              FutureBuilder<List<DirectChat_item>>(
                  future: getDirectChat(),
                  builder:
                      ((BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                            "Your Recent Story Will Show here...",
                            style: ThemeHelper()
                                .TextStyleMethod1(16, context, FontWeight.w600),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext, index) => chatBubble(
                                currentUser: id,
                                image: snapshot.data[index].image,
                                id: snapshot.data[index].user_id,
                                name: snapshot.data[index].user_name,
                                message: snapshot.data[index].message_content,
                              ));
                    }
                  }))
          ],
        ),
      ),
    );
  }
}

class chatBubble extends StatefulWidget {
  String image, id, name, message, currentUser;
  chatBubble({
    required this.currentUser,
    required this.image,
    required this.id,
    required this.name,
    this.message = "",
    Key? key,
  }) : super(key: key);

  @override
  State<chatBubble> createState() => _chatBubbleState();
}

class _chatBubbleState extends State<chatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.message == ""
                        ? NetworkImage(widget.image != ""
                            ? imageUrlGroupChat + widget.image
                            : defaultUser)
                        : NetworkImage(widget.image != ""
                            ? imageUrlUser + widget.image
                            : defaultUser),
                    fit: BoxFit.cover),
                shape: BoxShape.circle),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              if (widget.message == "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleUserChat(
                            id: widget.id,
                            image: imageUrlGroupChat + widget.image,
                            name: widget.name,
                          )),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DirectUserChat(
                            id: widget.id,
                            image: widget.image == ""
                                ? defaultUser
                                : imageUrlUser + widget.image,
                            name: widget.name,
                          )),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: ThemeHelper()
                      .TextStyleMethod1(14, context, FontWeight.bold),
                ),
                widget.message == ""
                    ? Text(
                        "Company c",
                        style: ThemeHelper()
                            .TextStyleMethod1(10, context, FontWeight.normal),
                      )
                    : Text(
                        widget.message,
                        style: ThemeHelper().TextStyleMethod2(
                            14, context, FontWeight.normal, Colors.grey),
                      ),
                widget.message == ""
                    ? Container(
                        margin: EdgeInsets.only(top: 4),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Text(
                          "Company",
                          style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).backgroundColor,
                              fontFamily: "Montserrat"),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Spacer(),
          widget.message == ""
              ? Row(
                  children: [
                    widget.currentUser == widget.id
                        ? IconButton(
                            onPressed: () {
                              ApiCall()
                                  .DeleteGroupChat(widget.currentUser, context);
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                          )
                        : Container(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_rounded),
                      color: Palette.secondaryColor,
                      // index % 2 == 0
                      //     ? Colors.red
                      //     : Palette.secondaryColor,
                    )
                  ],
                )
              : IconButton(onPressed: () {}, icon: Icon(Icons.reply_rounded)),
        ],
      ),
    );
  }
}
