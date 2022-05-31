import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Controllers/NewsFeedController.dart';
import 'package:soloconneckt/Services/constants.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Styles/palette.dart';
import 'package:soloconneckt/Views/Chat/index.dart';
import 'package:soloconneckt/Views/ProfileSetting/index.dart';
import 'package:soloconneckt/Views/SignUp/index.dart';

import '../Views/Chat/Message.dart';
import '../Views/Nfc.dart';

class NavbarWidget extends StatefulWidget {
  const NavbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  NewsFeedController _newsFeedController = Get.find();

  // String theme = "light";
  String usename = "", email = "", image = "";
  String id = "";
  bool islogin = false;

  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("first_name"));
    usename = prefs.getString("user_name")!;
    email = prefs.getString("user_email")!;
    image = prefs.getString("image")!;
    id =prefs.getString("user_id")!;
    // String? islogin2 = prefs.getString("is_logged_in");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState\
    addStringToSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    print(image);
    //  gettheme();
    var whichMode = mode.brightness;
    if (whichMode == Brightness.light) {
      _newsFeedController.theme.value = "Light";
      _newsFeedController.isSwitched.value = true;
    } else {
      _newsFeedController.theme.value = "Dark";
      _newsFeedController.isSwitched.value = false;
    }
    print(whichMode);
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 550,
      width: 220,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            width: 2),
                        image: image != null
                            ? DecorationImage(
                                image: NetworkImage(imageUrlUser + image),
                                fit: BoxFit.cover)
                            : null,
                        shape: BoxShape.circle),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0, bottom: 15),
                    child: Text(
                      usename,
                      style: ThemeHelper()
                          .TextStyleMethod1(12, context, FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.invert_colors),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Theme",
                      style: ThemeHelper()
                          .TextStyleMethod1(16, context, FontWeight.w600),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Obx(
                          () => Text(
                            _newsFeedController.theme.value,
                            style: ThemeHelper().TextStyleMethod1(
                                10, context, FontWeight.normal),
                          ),
                        ),
                        Obx(
                          () => FlutterSwitch(
                            width: 48,
                            height: 25,
                            showOnOff: false,
                            activeColor: Colors.black,
                            inactiveColor: Colors.white,
                            activeToggleColor: Colors.white,
                            toggleColor: Colors.black,
                            value: _newsFeedController.isSwitched.value,
                            onToggle: (val) {
                              if (Get.isDarkMode) {
                                _newsFeedController.theme.value = "Light";
                                Get.changeThemeMode(ThemeMode.light);
                              } else {
                                _newsFeedController.theme.value = "Dark";
                                Get.changeThemeMode(ThemeMode.dark);
                              }
                              _newsFeedController.isSwitched.value = val;
                              // setState(() {
                              //   isSwitched = val;
                              // });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: Palette.secondaryColor,
                  height: 3,
                )
              ],
            ),
          ),
          // RowWidget(
          //   text: "Notification",
          //   icon: Icon(Icons.notifications_active),
          //   ontap: () {
              
          //   },
          // ),
          RowWidget(
            text: "Message",
            icon: Icon(Icons.chat),
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Message(id: id,)),
              );
            },
          ),
          RowWidget(
            text: "NFC",
            icon: Icon(Icons.nfc_rounded),
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MyAppNFc()),
              );
            },
          ),
          // RowWidget(
          //   text: "NFC Dashboard",
          //   icon: Icon(Icons.dashboard),
          //   ontap: () {},
          // ),
          // RowWidget(
          //   text: "Shop now",
          //   icon: Icon(Icons.shopping_bag_rounded),
          //   ontap: () {},
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                ProgressDialog dialog = new ProgressDialog(context);
                dialog.style(message: 'Please wait...');
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                await dialog.hide();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => SignUp()),
                    (route) => false);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Sign out",
                    style: ThemeHelper().TextStyleMethod2(
                        16, context, FontWeight.w600, Colors.red),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  String text;
  Icon icon;
  Function ontap;
  RowWidget({
    required this.text,
    required this.icon,
    required this.ontap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              ontap();
            },
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 15,
                ),
                Text(
                  text,
                  style: ThemeHelper()
                      .TextStyleMethod1(16, context, FontWeight.w600),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Palette.secondaryColor,
            height: 3,
          )
        ],
      ),
    );
  }
}
