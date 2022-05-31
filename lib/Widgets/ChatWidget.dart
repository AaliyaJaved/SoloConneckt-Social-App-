


import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/palette.dart';

class leftChatMsg extends StatelessWidget {
  leftChatMsg({
    required this.msg,
    required this.time,
    required this.username,
    required this.isdirect,
    Key? key,
  }) : super(key: key);
  String msg, time,username;
  bool isdirect;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isdirect?Container() :Container(
            padding: EdgeInsets.all(2),
            alignment: Alignment.centerLeft,
            child: Text(
              username,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            )),
        Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              msg,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            )),
        Container(
            padding: EdgeInsets.all(2),
            alignment: Alignment.centerLeft,
            child: Text(
              time,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ))
      ],
    );
  }
}

class RightchatMsg extends StatelessWidget {
  RightchatMsg({
    required this.msg,
    required this.time,
    Key? key,
  }) : super(key: key);
  String msg, time;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        
        Container(
            // width: MediaQuery.of(context).size.width*0.90,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Palette.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              msg,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            )),
        Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerRight,
            child: Text(
              time,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ))
      ],
    );
  }
}
