import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Views/NewsFeed/ViewAllStories.dart';
import 'package:soloconneckt/classes/story.dart';
import 'package:story_view/story_view.dart';

import '../../Services/ApiCalling.dart';
import '../../Services/Apis.dart';

import 'package:http/http.dart' as http;
import '../../Services/constants.dart';
import '../../Styles/ThemeHelper.dart';

class StoryPageView extends StatefulWidget {
  final String user_id;
  StoryPageView({required this.user_id});
  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();
  bool isloading = true;
  int i = 0;
  final List<StoryItem> storyItems = [];
  String id = "0";

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("first_name"));
    id = prefs.getString("user_id")!;
    // String? islogin2 = prefs.getString("is_logged_in");
    setState(() {});
  }

  List<story> storyitem = [];
  getStories() async {
    var url = Uri.parse(base_url + ApiUrl.getStoryByID(widget.user_id, true));
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);

    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        story item = story(
          d["image"],
          d["user_name"],
          d["post_image"],
          d["user_id"],
          ""
          // d["post_image"],
          // d["datetime"],
          // d["caption"],
          // d["User_image"],
          // d["isreport"],
          // d["user_name"],
          // d["isLiked"],
          // d["isSaved"]
        );
        // ignore: invalid_use_of_protected_member
        storyitem.add(item);
      }

    for (i = 0; i < storyitem.length; i++) {
      storyItems.add(StoryItem.pageImage(
          url: imageUrlPost + storyitem[i].post_image, controller: controller));
    }
    setState(() {
      isloading = false;
    });
    // return storyitem;
  }

  @override
  void initState() {
    getStories();
    addStringToSF();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final List<StoryItem> storyItems = [
    //   StoryItem.text(
    //       title: '''“When you talk, you are only repeating something you know.
    //    But if you listen, you may learn something new.”
    //    – Dalai Lama''', backgroundColor: Colors.blueGrey),
    //   StoryItem.pageImage(
    //       url:
    //           "https://images.unsplash.com/photo-1553531384-cc64ac80f931?ixid=MnwxMjA3fDF8MHxzZWFyY2h8MXx8bW91bnRhaW58ZW58MHx8MHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    //       controller: controller),
    //   StoryItem.pageImage(
    //       url: "https://wp-modula.com/wp-content/uploads/2018/12/gifgif.gif",
    //       controller: controller,
    //       imageFit: BoxFit.contain),
    // ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.background),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: !isloading
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.all(2),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(storyitem[0].image != ""
                                    ? imageUrlUser + storyitem[0].image
                                    : defaultUser),
                                fit: BoxFit.cover),
                            border: Border.all(
                                color: Theme.of(context).backgroundColor,
                                width: 2),
                            shape: BoxShape.circle),
                      ),
                      Text(
                        storyitem[0].user_name,
                        style: ThemeHelper().TextStyleMethod2(
                            10,
                            context,
                            FontWeight.w500,
                            Theme.of(context).colorScheme.background),
                      ),
                    ],
                  ),
                  widget.user_id == id
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllStoryPageView(
                                        user_id: widget.user_id,
                                      )),
                            );
                          },
                          child: Text(
                            "View All",
                            style: ThemeHelper().TextStyleMethod2(
                                10,
                                context,
                                FontWeight.w500,
                                Theme.of(context).colorScheme.background),
                          ),
                        )
                      : Container(),
                  // IconButton(
                  //     onPressed: () async {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => StoryPageView(
                  //                   user_id: widget.user_id,
                  //                 )),
                  //       );
                  //       // print(StoryItem.);
                  //       // await ApiCall().DeleteLikedPost(
                  //       //     id, context);
                  //       // ApiCall().DeleteLikedPost(
                  //       //     id, context);
                  //       setState(() {});
                  //     },
                  //     icon: Icon(
                  //       Icons.delete,
                  //       color: Theme.of(context).colorScheme.background,
                  //     ))
                  // : Container()
                ],
              )
            : null,
      ),
      body: !isloading
          ? StoryView(
              onStoryShow: (value) => {},
              onComplete: () {
                Navigator.pop(context);
              },
              storyItems: storyItems,
              controller: controller,
              inline: false,
              repeat: false,
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
    );
  }
}

class StatusCircleWidget extends StatelessWidget {
  int index;
  String image, user_id, user_name;
  StatusCircleWidget({
    required this.index,
    required this.image,
    required this.user_name,
    required this.user_id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoryPageView(
                    user_id: user_id,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              height: 69,
              width: 69,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      width: 2),
                  color: Theme.of(context).colorScheme.primaryVariant,
                  shape: BoxShape.circle),
              child: Container(
                // margin: EdgeInsets.all(2),
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            image != "" ? imageUrlUser + image : defaultUser),
                        fit: BoxFit.cover),
                    border: Border.all(
                        color: Theme.of(context).backgroundColor, width: 2),
                    shape: BoxShape.circle),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              user_name,
              style:
                  ThemeHelper().TextStyleMethod1(10, context, FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
