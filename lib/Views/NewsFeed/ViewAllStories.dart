import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Views/Chat/index.dart';
import 'package:soloconneckt/Views/NewsFeed/Stories.dart';
import 'package:soloconneckt/Views/NewsFeed/index.dart';
import 'package:soloconneckt/classes/story.dart';

import '../../Services/ApiCalling.dart';
import '../../Services/Apis.dart';

import 'package:http/http.dart' as http;
import '../../Services/constants.dart';
import '../../Styles/ThemeHelper.dart';
import '../MainPage/index.dart';

class AllStoryPageView extends StatefulWidget {
  final String user_id;
  AllStoryPageView({required this.user_id});
  @override
  _AllStoryPageViewState createState() => _AllStoryPageViewState();
}

class _AllStoryPageViewState extends State<AllStoryPageView> {
  bool isloading2 = true;

  Future<List<story>> getStories() async {
    var url = Uri.parse(base_url + ApiUrl.getStoryByID(widget.user_id, true));
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    List<story> storyitem = [];
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        story item = story(d["image"], d["user_name"], d["post_image"],
            d["user_id"], d["story_id"]
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
    return storyitem;
  }

  @override
  void initState() {
    getStories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                        Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                      },
                      icon: Icon(Icons.arrow_back_ios_new_sharp)),
                  Text(
                    "All Stories",
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
            ),
            Container(
                // width: MediaQuery.of(context).size.width * 1,
                // height: 100,
                child: FutureBuilder<List<story>>(
              future: getStories(),
              builder:
                  ((BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.blue)),
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
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 69,
                                width: 69,
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
                                  height: 65,
                                  width: 65,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data[index].post_image !=
                                                      ""
                                                  ? imageUrlPost +
                                                      snapshot.data[index]
                                                          .post_image
                                                  : defaultUser),
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          width: 2),
                                      shape: BoxShape.circle),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await ApiCall().DeleteStory(widget.user_id,
                                        snapshot.data[index].story_id, context);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                  ))
                            ],
                          )
                      //     StoriesStatusWidget(
                      //   userimage: snapshot.data[index].image,
                      //   postimage:
                      //       snapshot.data[index].post_image,
                      //   username:
                      //       snapshot.data[index].user_name,
                      // ),
                      );
                }
              }),
            )),
          ],
        ),
      )),
    );
  }
}
