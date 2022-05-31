

import 'package:flutter/material.dart';

import '../Styles/ThemeHelper.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                // margin: EdgeInsets.all(2),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).backgroundColor,
                        width: 2),
                        image: DecorationImage(image: AssetImage("assets/images/profile.png",),fit: BoxFit.cover),
                    shape: BoxShape.circle),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Company A",
                    style: ThemeHelper().TextStyleMethod1(
                        14, context, FontWeight.w500),
                  ),
                  Text(
                    "10 min",
                    style: ThemeHelper().TextStyleMethod1(
                        10, context, FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 260,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/post.png",),fit: BoxFit.cover),
                borderRadius:
                    BorderRadius.all(Radius.circular(15))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                padding: EdgeInsets.all(0),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.bookmark,
                  color: Theme.of(context)
                      .colorScheme
                      .primaryVariant,
                ),
                padding: EdgeInsets.all(0),
              )
            ],
          )
        ],
      ),
    );
  }
}
