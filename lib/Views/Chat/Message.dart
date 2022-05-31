import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Views/Chat/index.dart';

import '../../Services/constants.dart';
import 'package:http/http.dart' as http;
import '../../classes/DirectChat.dart';

class Message extends StatefulWidget {
  String id;
   Message({required this.id, key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<DirectChat_item> Directchat = [];
  bool isloading = true;
  bool isloading2 = true;

  getDirectChat() async {
    isloading2 = true;
    var url = Uri.parse(base_url + ApiUrl.getDirectChat(widget.id));
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
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

    print(Directchat.length);
    isloading2 = false;
    setState(() {});
  }

@override
  void initState() {
    getDirectChat();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_sharp)),
                Text(
                  "Messages",
                  style: ThemeHelper()
                      .TextStyleMethod1(18, context, FontWeight.w600),
                ),
               Text(
                     "Profile",
                     style: ThemeHelper()
                         .TextStyleMethod2(18, context, FontWeight.w600,Theme.of(context).backgroundColor),
                   ),
              ],
            ),
          ),
            isloading2 == false
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Directchat.length,
                    itemBuilder: (BuildContext, index) => chatBubble(
                        currentUser: "",
                          image: Directchat[index].image,
                          id: Directchat[index].user_id,
                          name: Directchat[index].user_name,
                          message: Directchat[index].message_content,
                        ))
                : CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
          ],
        ),
      )),
    );
  }
}
