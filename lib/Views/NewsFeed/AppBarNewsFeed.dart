
import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';

import '../../Controllers/NewsFeedController.dart';
import 'SearchNfc.dart';

class AppBarNewsFeed extends StatelessWidget {
  const AppBarNewsFeed({
    Key? key,
    required this.newsFeedController,
  }) : super(key: key);

  final NewsFeedController newsFeedController;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              newsFeedController.isDrawerOpen.value = true;
            },
            icon: const Icon(
              Icons.menu_rounded,
            ),
          ),
          Text(
            "SOLO CONNECKT",
            style: ThemeHelper().TextStyleMethod1(20, context, FontWeight.w600),
          ),
          IconButton(
            onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NfcSearch()),
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
    );
  }
}
