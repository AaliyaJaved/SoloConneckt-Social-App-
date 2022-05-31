import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Controllers/NewsFeedController.dart';
import 'package:soloconneckt/Services/ApiClient.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/NewsFeed/SearchNfc.dart';
import 'package:soloconneckt/Views/Profile/index.dart';
import 'package:soloconneckt/Views/ViewProfile/index.dart';
import 'package:soloconneckt/Widgets/ShowResponse.dart';
import 'package:http/http.dart' as http;
import 'package:soloconneckt/classes/post.dart';
import 'package:soloconneckt/classes/story.dart';
// import 'package:stories_for_flutter/stories_for_flutter.dart';

import '../../Services/ApiCalling.dart';
import '../../Services/constants.dart';
import '../../Widgets/Navbar.dart';
import 'AppBarNewsFeed.dart';
import 'Stories.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  bool isloading = true;

  String usename = "", email = "", image = "";
  String id = "0";
  bool islogin = false;
  int indexVal = 0;
  final todaysDate = DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("first_name"));
    usename = prefs.getString("user_name")!;
    email = prefs.getString("user_email")!;
    image = prefs.getString("image")!;
    id = prefs.getString("user_id")!;
    // String? islogin2 = prefs.getString("is_logged_in");
    setState(() {});
  }

  Future<List<story>> getStories() async {
    var url = Uri.parse(base_url + ApiUrl.getStory);
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    List<story> storyitem = [];
    int i = 0;
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        i++;
        story item =
            story(d["image"], d["user_name"], d["post_image"], d["user_id"], ""
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
    for (int i = 0; i < storyitem.length; i++) {
      if (storyitem[i].user_id == id) {
        indexVal = i;
      }
    }
    return storyitem;
  }

  Future<List<Post_item>> getPost() async {
    var url = Uri.parse(base_url + ApiUrl.getPostById(id, false));
    var response = await http.get(url);
    print(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    List<Post_item> post = [];
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        Post_item item = Post_item(
            d["post_id"],
            d["user_id"],
            d["post_image"],
            d["datetime"],
            d["caption"],
            d["User_image"],
            d["isreport"],
            d["user_name"],
            d["isLiked"],
            d["isSaved"]);
        // ignore: invalid_use_of_protected_member
        post.add(item);
      }
    return post;
  }

  @override
  void initState() {
    // getPost();
    addStringToSF();
    // getStories();
    // TODO: implement initState
    super.initState();
  }

  NewsFeedController newsFeedController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                newsFeedController.isDrawerOpen.value = false;
              },
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: AppBarNewsFeed(
                          newsFeedController: newsFeedController)),
                  Expanded(
                    flex: 10,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: 100,
                              child: FutureBuilder<List<story>>(
                                future: getStories(),
                                builder: ((BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.data == null) {
                                    return Container(
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.blue)),
                                    );
                                  } else if (snapshot.data.length == 0) {
                                    return Container(
                                      child: Center(
                                        child: Text(
                                          "Your Recent Story Will Show here...",
                                          style: ThemeHelper().TextStyleMethod1(
                                              16, context, FontWeight.w600),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        indexVal != 0
                                            ? StatusCircleWidget(
                                                user_name: snapshot
                                                    .data[indexVal].user_name,
                                                image: snapshot
                                                    .data[indexVal].image,
                                                index: indexVal,
                                                user_id: snapshot
                                                    .data[indexVal].user_id,
                                              )
                                            : Container(),
                                        ListView.builder(
                                            itemCount: snapshot.data.length,
                                            shrinkWrap: true,
                                            // physics: NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (BuildContext,
                                                    index) =>
                                                snapshot.data[index].user_id !=
                                                        id
                                                    ? StatusCircleWidget(
                                                        user_name: snapshot
                                                            .data[index]
                                                            .user_name,
                                                        image: snapshot
                                                            .data[index].image,
                                                        index: index,
                                                        user_id: snapshot
                                                            .data[index]
                                                            .user_id,
                                                      )
                                                    : Container()
                                            //     StoriesStatusWidget(
                                            //   userimage: snapshot.data[index].image,
                                            //   postimage:
                                            //       snapshot.data[index].post_image,
                                            //   username:
                                            //       snapshot.data[index].user_name,
                                            // ),
                                            ),
                                      ],
                                    );
                                  }
                                }),
                              )),
                          FutureBuilder<List<Post_item>>(
                            future: getPost(),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.data == null) {
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blue)),
                                );
                              } else if (snapshot.data.length == 0) {
                                return Container(
                                  child: Center(
                                    child: Text(
                                      "Your Recent Post Will Show here...",
                                      style: ThemeHelper().TextStyleMethod1(
                                          16, context, FontWeight.w600),
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: snapshot.data.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    // scrollDirection: Axis.horizontal,
                                    itemBuilder: (BuildContext, index) {
                                      var countTime;
                                      var date = DateTime.parse(
                                          snapshot.data[index].datetime);
                                      if (todaysDate
                                              .difference(date)
                                              .inSeconds <
                                          60) {
                                        countTime = "just now";
                                      } else if (todaysDate
                                              .difference(date)
                                              .inMinutes <
                                          60) {
                                        countTime = todaysDate
                                                .difference(date)
                                                .inMinutes
                                                .toString() +
                                            " mins ago";
                                      } else if (todaysDate
                                              .difference(date)
                                              .inHours <
                                          24) {
                                        countTime = todaysDate
                                                .difference(date)
                                                .inHours
                                                .toString() +
                                            " hours ago";
                                      } else {
                                        countTime = todaysDate
                                                .difference(date)
                                                .inDays
                                                .toString() +
                                            " days ago";
                                      }

                                      // print("saved "+snapshot.data[index].isSaved.toString()+" index "+index.toString());
                                      return snapshot.data[index].isreport ==
                                              "0"
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            // margin: EdgeInsets.all(2),
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(snapshot.data[index].User_image !=
                                                                            null
                                                                        ? imageUrlUser +
                                                                            snapshot
                                                                                .data[
                                                                                    index]
                                                                                .User_image
                                                                        : defaultUser),
                                                                    fit: BoxFit
                                                                        .cover),
                                                                border: Border.all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .backgroundColor,
                                                                    width: 2),
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  if (id !=
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .user_id) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              ViewProfile(
                                                                                id: snapshot.data[index].user_id,
                                                                              )),
                                                                    );
                                                                  } else {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              Profile()),
                                                                    );
                                                                  }
                                                                },
                                                                child: Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .user_name,
                                                                  style: ThemeHelper().TextStyleMethod1(
                                                                      14,
                                                                      context,
                                                                      FontWeight
                                                                          .w500),
                                                                ),
                                                              ),
                                                              Text(
                                                                countTime,
                                                                style: ThemeHelper()
                                                                    .TextStyleMethod1(
                                                                        10,
                                                                        context,
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      id ==
                                                              snapshot
                                                                  .data[index]
                                                                  .user_id
                                                          ? Container()
                                                          : InkWell(
                                                              onTap: () async {
                                                                await ApiCall()
                                                                    .ReportPost(
                                                                        snapshot
                                                                            .data[index]
                                                                            .post_id,
                                                                        context);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.all(4),
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(width: 1,color: Theme.of(context).colorScheme.background),
                                                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                                                ),
                                                                child: Text(
                                                                  "report",
                                                                  style: ThemeHelper().TextStyleMethod2(
                                                                      12,
                                                                      context,
                                                                      FontWeight
                                                                          .w600,
                                                                      Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .background),
                                                                ),
                                                              ),
                                                            )
                                                      //  IconButton(
                                                      //     onPressed: () async {
                                                      //      await ApiCall().ReportPost(
                                                      //           snapshot
                                                      //               .data[
                                                      //                   index]
                                                      //               .post_id,
                                                      //           context);
                                                      //       setState(() {});
                                                      //     },
                                                      //     icon: Icon(Icons
                                                      //         .report_gmailerrorred_rounded),
                                                      //     padding:
                                                      //         EdgeInsets
                                                      //             .all(0),
                                                      //   )
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    height: 260,
                                                    decoration: BoxDecoration(
                                                        image: snapshot
                                                                    .data[index]
                                                                    .post_image !=
                                                                null
                                                            ? DecorationImage(
                                                                image: NetworkImage(
                                                                    imageUrlPost +
                                                                        snapshot
                                                                            .data[
                                                                                index]
                                                                            .post_image),
                                                                fit: BoxFit
                                                                    .cover)
                                                            : null,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () async {
                                                          if (snapshot
                                                                  .data[index]
                                                                  .isLiked ==
                                                              0) {
                                                            ApiCall().LikedPost(
                                                                id,
                                                                snapshot
                                                                    .data[index]
                                                                    .post_id,
                                                                context);
                                                            setState(() {});
                                                          } else {
                                                            await ApiCall()
                                                                .DeleteLikedPost(
                                                                    id,
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .post_id,
                                                                    context);
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon: Icon(
                                                          snapshot.data[index]
                                                                      .isLiked ==
                                                                  1
                                                              ? Icons
                                                                  .favorite_rounded
                                                              : Icons
                                                                  .favorite_border,
                                                          color: snapshot
                                                                      .data[
                                                                          index]
                                                                      .isLiked ==
                                                                  1
                                                              ? Colors.red
                                                              : null,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          if (snapshot
                                                                  .data[index]
                                                                  .isSaved ==
                                                              0) {
                                                            ApiCall().SavedPost(
                                                                id,
                                                                snapshot
                                                                    .data[index]
                                                                    .post_id,
                                                                context);
                                                            setState(() {});
                                                          } else {
                                                            ApiCall().DeletePost(
                                                                id,
                                                                snapshot
                                                                    .data[index]
                                                                    .post_id,
                                                                context);
                                                            setState(() {});
                                                          }
                                                        },
                                                        icon: snapshot
                                                                    .data[index]
                                                                    .isSaved ==
                                                                1
                                                            ? Icon(
                                                                Icons.bookmark,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .background,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .bookmark_border,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .background,
                                                              ),
                                                        padding:
                                                            EdgeInsets.all(0),
                                                      ),
                                                      id ==
                                                              snapshot
                                                                  .data[index]
                                                                  .user_id
                                                          ? IconButton(
                                                              onPressed: () {
                                                                ApiCall().DeleteUserPost(
                                                                    id,
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .post_id,
                                                                    context);
                                                                setState(() {});
                                                              },
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .background,
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(0),
                                                            )
                                                          : Container(),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container();
                                    });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Obx(
              () => newsFeedController.isDrawerOpen.value
                  ? Positioned(
                      top: 0,
                      left: 0,
                      child: NavbarWidget(),
                    )
                  : Container(),
            )
          ],
        ),
      ),
    );
  }
}
