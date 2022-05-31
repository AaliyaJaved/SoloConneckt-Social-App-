import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:soloconneckt/Services/Apis.dart';
import 'package:soloconneckt/Services/constants.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Widgets/ShowResponse.dart';
import 'package:http/http.dart' as http;
import 'package:soloconneckt/classes/post.dart';

class ArtGallery extends StatefulWidget {
  const ArtGallery({Key? key}) : super(key: key);

  @override
  State<ArtGallery> createState() => _ArtGalleryState();
}

class _ArtGalleryState extends State<ArtGallery> {
  List<Post_item> post = [];
  bool isloading = true;

  getPost() async {
    var url = Uri.parse(base_url + ApiUrl.getPost);
    print(url);
    var response = await http.get(url);
    var JsonData = json.decode(response.body);
    print(JsonData[0]["code"]);
    if (JsonData[0]["code"] != 0)
      // ignore: curly_braces_in_flow_control_structures
      for (var d in JsonData) {
        Post_item item = Post_item("","",d["post_image"],d["datetime"],d["caption"],d["User_image"],"",d["user_name"],d["false"],d["false"]);
        // ignore: invalid_use_of_protected_member
        post.add(item);
        // print(users[0].date);
      }

    print(post.length); 
       isloading = false;  
    setState(() {
    });
  }

  @override
  void initState() {
    getPost();
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
                    "Art Gallery",
                    style: ThemeHelper()
                        .TextStyleMethod1(18, context, FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Explore",
                    style: ThemeHelper()
                        .TextStyleMethod1(16, context, FontWeight.w600),
                  ),
                ],
              ),
            ),
            isloading==false? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: post.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) => Container(
                        decoration: BoxDecoration(
                            image: post[index].post_image != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        imageUrlPost + post[index].post_image),
                                    fit: BoxFit.cover)
                                : null,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      )),
            ):CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primaryVariant,
            )
          ],
        ),
      ),
    );
  }
}
