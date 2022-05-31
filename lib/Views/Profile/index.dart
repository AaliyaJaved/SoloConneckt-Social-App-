import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Services/constants.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/AddTopic/index.dart';
import 'package:soloconneckt/Views/CreatePost/index.dart';
import 'package:soloconneckt/Views/Profile/editProfile.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'package:http/http.dart' as http;
import 'package:soloconneckt/classes/post.dart';

import '../../Styles/ThemeHelper.dart';
import '../CreateStory/index.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String usename = "", email = "", image = "", id = "";
  String islogin = "No";
  bool setting = false;
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usename = prefs.getString("user_name")!;
    email = prefs.getString("user_email")!;
    image = prefs.getString("image")!;
    id = prefs.getString("user_id")!;
    String? islogin = prefs.getString("is_logged_in");
    setState(() {});
    getPost();
    getSavedPost();
  }

  initState() {
    addStringToSF();

    super.initState();
  }

  int tabindex = 0;
  List<Post_item> post = [];
  List<Post_item> post2 = [];
  bool isloading = true;
  bool isloading2 = true;
  getPost() async {
    bool isloading = true;
    var url = Uri.parse(base_url + ApiUrl.getPostById(id, true));
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
            d["false"]);
        // ignore: invalid_use_of_protected_member
        post.add(item);
        // print(users[0].date);
      }

    print(post.length);
    isloading = false;
    setState(() {});
  }

  getSavedPost() async {
    bool isloading2 = true;
    var url = Uri.parse(base_url + ApiUrl.getSavedPost(id));
    print(url);
    print("idd " + id);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(response.body);
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        Post_item item = Post_item(d["post_id"], "", d["post_image"],
            d["datetime"], d["caption"], "", "", "", d["isLiked"], d["true"]);
        // ignore: invalid_use_of_protected_member
        post2.add(item);
        // print(users[0].date);
      }

    print(post2.length);
    isloading2 = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Text(
                      "Profile",
                      style: ThemeHelper()
                          .TextStyleMethod1(18, context, FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()),
                            );
                          },
                          child: Text(
                            "Edit",
                            style: ThemeHelper().TextStyleMethod2(
                                14, context, FontWeight.normal, Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Container(
                  // color: Colors.amber,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(image != null
                                        ? imageUrlUser + image
                                        : defaultUser),
                                    fit: BoxFit.cover),
                              ),
                              height: 150,
                              // child: ,
                            ),
                            Container(
                              height: 200,
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(image != null
                                              ? imageUrlUser + image
                                              : defaultUser),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryVariant,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (setting)
                                      setting = false;
                                    else
                                      setting = true;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              usename,
                              style: ThemeHelper().TextStyleMethod1(
                                  18, context, FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Designer",
                                  style: ThemeHelper().TextStyleMethod1(
                                      12, context, FontWeight.normal),
                                ),
                                Text(
                                  "@Company E",
                                  style: ThemeHelper().TextStyleMethod2(12,
                                      context, FontWeight.normal, Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AddTopicWidget(id: id),
                      SizedBox(
                        height: 15,
                      ),
                      setting
                          ? SettingWidget()
                          : Container(
                              child: Column(children: [
                                Container(
                                  child: DefaultTabController(
                                    length: 2,
                                    child: TabBar(
                                      labelColor: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                      indicatorColor: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                      indicator: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryVariant,
                                      ),
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
                                            icon: Icon(
                                          Icons.dashboard,
                                          color: tabindex == 0
                                              ? Theme.of(context)
                                                  .backgroundColor
                                              : Colors.grey,
                                        )),
                                        Tab(
                                          icon: Icon(
                                            Icons.bookmark_border_outlined,
                                            color: tabindex == 1
                                                ? Theme.of(context)
                                                    .backgroundColor
                                                : Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                tabindex == 0
                                    ? GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 3,
                                        ),
                                        itemCount: post.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              image: post[index].post_image !=
                                                      null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          imageUrlPost +
                                                              post[index]
                                                                  .post_image),
                                                      fit: BoxFit.cover)
                                                  : null,
                                            ),
                                          );
                                        })
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 3,
                                        ),
                                        itemCount: post2.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              image: post2[index].post_image !=
                                                      null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          imageUrlPost +
                                                              post2[index]
                                                                  .post_image),
                                                      fit: BoxFit.cover)
                                                  : null,
                                            ),
                                          );
                                        }),
                              ]),
                            )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddTopicWidget extends StatelessWidget {
  const AddTopicWidget({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryVariant,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Text(
            "Hye its seem like you have'nt add any topic yet",
            style: ThemeHelper().TextStyleMethod2(16, context, FontWeight.w500,
                Theme.of(context).backgroundColor),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTopic(
                                id: id,
                              )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Theme.of(context).backgroundColor, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        Text(
                          "Add topic",
                          style: ThemeHelper().TextStyleMethod2(
                              12, context, FontWeight.w500, Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingWidget extends StatelessWidget {
  const SettingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreatePost()),
                );
              },
              child: Text(
                "Add Post",
                style: ThemeHelper().TextStyleMethod2(
                    14, context, FontWeight.normal, Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateStory()),
                );
              },
              child: Text(
                "Add Story",
                style: ThemeHelper().TextStyleMethod2(
                    14, context, FontWeight.normal, Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 4.0),
              child: Text(
                "Account settings",
                style: ThemeHelper()
                    .TextStyleMethod1(16, context, FontWeight.w600),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(
                  Icons.account_circle,
                  size: 45,
                  color: Palette.secondaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your profile",
                      style: ThemeHelper()
                          .TextStyleMethod1(14, context, FontWeight.w600),
                    ),
                    Text(
                      "Edit and view profile info",
                      style: ThemeHelper()
                          .TextStyleMethod1(12, context, FontWeight.normal),
                    ),
                  ],
                )
              ]),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.navigate_next_outlined,
                    size: 30,
                    color: Palette.secondaryColor,
                  ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: Palette.secondaryColor,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(
                  Icons.bookmark_border_rounded,
                  size: 45,
                  color: Palette.secondaryColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saved profile",
                      style: ThemeHelper()
                          .TextStyleMethod1(14, context, FontWeight.w600),
                    ),
                    Text(
                      "Your saved profiles are here",
                      style: ThemeHelper()
                          .TextStyleMethod1(12, context, FontWeight.normal),
                    ),
                  ],
                )
              ]),
              IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const SavedPost()),
                    // );
                  },
                  icon: Icon(
                    Icons.navigate_next_outlined,
                    size: 30,
                    color: Palette.secondaryColor,
                  ))
            ],
          ),
        )
      ],
    );
  }
}
