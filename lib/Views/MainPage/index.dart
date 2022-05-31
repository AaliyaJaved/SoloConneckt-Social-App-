import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/ArtGallery/index.dart';
import 'package:soloconneckt/Views/Chat/index.dart';
import 'package:soloconneckt/Views/NewsFeed/index.dart';
import 'package:soloconneckt/Views/Profile/index.dart';
import 'package:soloconneckt/Views/QrCode/index.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static List<Widget> bottomBarPages = <Widget>[
    NewsFeed(),
    Chat(),
    Profile(),
    ArtGallery(),
    QRCode()
  ];
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: bottomBarPages.elementAt(currentIndex),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 8),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          // borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .005),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(
                () {
                  currentIndex = index;
                },
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : size.width * .029,
                    right: size.width * .032,
                    left: size.width * .032,
                  ),
                  width: size.width * .128,
                  height: index == currentIndex ? size.width * .012 : 0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                Icon(
                  index == currentIndex
                      ? listOfIcons[index]
                      : unselectedlistOfIcons[index],
                  size: 28,
                  color: index == currentIndex
                      ? Theme.of(context).colorScheme.primaryVariant
                      : Palette.secondaryColor,
                ),
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.chat_rounded,
    Icons.account_circle,
    Icons.collections_rounded,
    Icons.qr_code_scanner
  ];
  List<IconData> unselectedlistOfIcons = [
    Icons.home_rounded,
    Icons.chat_outlined,
    Icons.account_circle_outlined,
    Icons.collections_outlined,
    Icons.qr_code_scanner,
  ];
}
