import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:soloconneckt/Controllers/NewsFeedController.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Styles/palette.dart';

class ProfileSetting extends StatelessWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final ThemeData mode = Theme.of(context);
    var whichMode = mode.brightness;
    NewsFeedController _newsFeedController = Get.find();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_sharp)),
                Text(
                  "Profile Setting",
                  style: ThemeHelper()
                      .TextStyleMethod1(18, context, FontWeight.w600),
                ),
               Text(
                     "Profile",
                     style: ThemeHelper()
                         .TextStyleMethod2(18, context, FontWeight.w600,Theme.of(context).backgroundColor),
                   ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          whichMode==Brightness.light?Image.asset("assets/images/blacklogo.png",width: 150,height: 150,):Image.asset("assets/images/whitelogo.png",width: 150,height: 150,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              color: Palette.secondaryColor,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Obx(
                    () => FlutterSwitch(
                      width: 48,
                      height: 25,
                      showOnOff: false,
                      activeColor: Theme.of(context).colorScheme.primaryVariant,
                      inactiveColor: Theme.of(context).colorScheme.primaryVariant,
                      activeToggleColor: Theme.of(context).backgroundColor,
                      toggleColor: Theme.of(context).backgroundColor,
                      value: _newsFeedController.realEstateProfile.value,
                      onToggle: (val) {
                        _newsFeedController.realEstateProfile.value = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => FlutterSwitch(
                      width: 48,
                      height: 25,
                      showOnOff: false,
                     activeColor: Theme.of(context).colorScheme.primaryVariant,
                      inactiveColor: Theme.of(context).colorScheme.primaryVariant,
                      activeToggleColor: Theme.of(context).backgroundColor,
                      toggleColor: Theme.of(context).backgroundColor,
                      value: _newsFeedController.forexProfile.value,
                      onToggle: (val) {
                        _newsFeedController.forexProfile.value = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => FlutterSwitch(
                      width: 48,
                      height: 25,
                      showOnOff: false,
                     activeColor: Theme.of(context).colorScheme.primaryVariant,
                      inactiveColor: Theme.of(context).colorScheme.primaryVariant,
                      activeToggleColor: Theme.of(context).backgroundColor,
                      toggleColor: Theme.of(context).backgroundColor,
                      value: _newsFeedController.personalProfile.value,
                      onToggle: (val) {
                        _newsFeedController.personalProfile.value = val;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Real Estate Profile",
                    style: ThemeHelper()
                        .TextStyleMethod1(16, context, FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Forex Profile",
                    style: ThemeHelper()
                        .TextStyleMethod1(16, context, FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Personal Profile",
                    style: ThemeHelper()
                        .TextStyleMethod1(16, context, FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),SizedBox(
                    height: 20,
                  ),
          whichMode==Brightness.light?Image.asset("assets/images/Group-4.png",width: 150,height: 150,):Image.asset("assets/images/Group-5.png",width: 150,height: 150,),
        ],
      )),
    );
  }
}
