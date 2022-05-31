import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/ApiCalling.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/Chat/DirectChatScreen.dart';
import 'package:soloconneckt/Widgets/PostWidget.dart';
import 'package:http/http.dart' as http;
import 'package:soloconneckt/classes/post.dart';

import '../../Services/constants.dart';
import '../../Styles/ThemeHelper.dart';
import '../../classes/user.dart';

class ViewProfile extends StatefulWidget {
  String id;
  ViewProfile({required this.id, Key? key}) : super(key: key);

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  bool isloading = true;
  var JsonData;

  getProfile() async {
    var url = Uri.parse(base_url + ApiUrl.getUser(widget.id));
    print(url);
    var response = await http.get(url);
    JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    if (JsonData[0]["code"] != 0){
      setState(() {
        isloading = false;
      });}
  }

  List<Post_item> post = [];

  getPost() async {
    var url = Uri.parse(base_url + ApiUrl.getPostById(widget.id, true));
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        Post_item item = Post_item(
            d["post_id"],
            "",
            d["post_image"],
            d["datetime"],
            d["caption"],
            d["User_image"],
            "",
            d["user_name"],
            d["false"],
            d["isSaved"]);
        // ignore: invalid_use_of_protected_member
        post.add(item);
        // print(users[0].date);
      }

    print(post.length);
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    getProfile();
    getPost();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.id);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new_sharp)),
                  Text(
                    "Profile",
                    style: ThemeHelper()
                        .TextStyleMethod1(18, context, FontWeight.w600),
                  ),
                  Text(
                    "Profile",
                    style: ThemeHelper().TextStyleMethod2(18, context,
                        FontWeight.w600, Theme.of(context).backgroundColor),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              isloading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    )
                  : Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                        width: 2),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                    shape: BoxShape.circle),
                                child: Container(
                                  // margin: EdgeInsets.all(2),
                                  height: 96,
                                  width: 96,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          width: 2),
                                      image: JsonData[0]["image"] != null
                                          ? DecorationImage(
                                              image: NetworkImage(imageUrlUser +
                                                  JsonData[0]["image"]),
                                              fit: BoxFit.cover)
                                          : null,
                                      shape: BoxShape.circle),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                JsonData[0]["user_name"],
                                style: ThemeHelper().TextStyleMethod1(
                                    16, context, FontWeight.w600),
                              ),
                              Text(
                                "@Company B",
                                style: ThemeHelper().TextStyleMethod2(
                                    12, context, FontWeight.w600, Colors.blue),
                              ),
                              Text(
                                "Company is pineered in digital product",
                                style: ThemeHelper().TextStyleMethod2(12,
                                    context, FontWeight.w600, Palette.darkGrey),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DirectUserChat(
                                                  id: widget.id,
                                                  image: imageUrlUser +
                                                      JsonData[0]["image"],
                                                  name: JsonData[0]
                                                      ["user_name"],
                                                )),
                                      );
                                    },
                                    icon:
                                        Icon(Icons.chat_bubble_outline_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.favorite_border),
                                    color: Palette.secondaryColor,
                                  )
                                ],
                              ),
                              Divider(
                                height: 2,
                                color: Palette.darkGrey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.location_on_rounded,
                                        size: 40,
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          JsonData[0]["user_email"],
                                          style: ThemeHelper().TextStyleMethod1(
                                              12, context, FontWeight.w600),
                                        ),
                                        Text(
                                          "Plot c dictrict 112 ",
                                          style: ThemeHelper().TextStyleMethod1(
                                              12, context, FontWeight.w600),
                                        ),
                                        Text(
                                          JsonData[0]["phone"],
                                          style: ThemeHelper().TextStyleMethod1(
                                              12, context, FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 2,
                          color: Palette.darkGrey,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: ListView.builder(
                            itemCount: post.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext, index) => Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.all(2),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            image: post[index].User_image !=
                                                    null
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        imageUrlUser +
                                                            post[index]
                                                                .User_image),
                                                    fit: BoxFit.cover)
                                                : null,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .backgroundColor,
                                                width: 2),
                                            shape: BoxShape.circle),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewProfile(
                                                          id: post[index]
                                                              .user_id,
                                                        )),
                                              );
                                            },
                                            child: Text(
                                              post[index].user_name,
                                              style: ThemeHelper()
                                                  .TextStyleMethod1(14, context,
                                                      FontWeight.w500),
                                            ),
                                          ),
                                          Text(
                                            DateFormat.jm().format(
                                                DateTime.parse(
                                                    post[index].datetime)),
                                            style: ThemeHelper()
                                                .TextStyleMethod1(10, context,
                                                    FontWeight.w500),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    height: 260,
                                    decoration: BoxDecoration(
                                        image: post[index].post_image != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    imageUrlPost +
                                                        post[index].post_image),
                                                fit: BoxFit.cover)
                                            : null,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (post[index].isLiked == 0) {
                                            ApiCall().LikedPost(widget.id,
                                                post[index].post_id, context);
                                          } else {
                                            ApiCall().DeleteLikedPost(widget.id,
                                                post[index].post_id, context);
                                            setState(() {});
                                          }
                                        },
                                        icon: Icon(
                                          post[index].isLiked == 1
                                              ? Icons.favorite_rounded
                                              : Icons.favorite_border,
                                          color: post[index].isLiked == 1
                                              ? Colors.red
                                              : null,
                                        ),
                                        padding: EdgeInsets.all(0),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (post[index].isSaved == 0) {
                                            ApiCall().SavedPost(widget.id,
                                                post[index].post_id, context);
                                          } else {
                                            ApiCall().DeletePost(widget.id,
                                                post[index].post_id, context);
                                            setState(() {});
                                          }
                                        },
                                        icon: post[index].isSaved == 1
                                            ? Icon(
                                                Icons.bookmark,
                                                color: Colors.white,
                                              )
                                            : Icon(Icons.bookmark_border),
                                        padding: EdgeInsets.all(0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
