import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';
import 'package:soloconneckt/Views/CreateAccount/index.dart';
import 'package:soloconneckt/Views/MainPage/index.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late VideoPlayerController _Vediocontroller;
  late Animation<double> _animation;
  String usename = "", email = "", image = "";
  int id = 0;
  String islogin = "No";
  addStringToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("is_logged_in"));
    usename = prefs.getString("user_name")!;
    email = prefs.getString("user_email") != null
        ? prefs.getString("user_email")!
        : "";
    // image = prefs.getString("image")!;
    id = int.parse(prefs.getString("user_id")!);
    islogin = prefs.getString("is_logged_in")!;
    setState(() {});
  }

  initState() {
    super.initState();
    addStringToSF();
    // _Vediocontroller = VideoPlayerController.asset('assets/Main.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              child: Stack(
                children: [
                  Hero(
                    tag: "pic",
                    child: ScaleTransition(
                      scale: _animation,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/whitelogo.png",
                        fit: BoxFit.fitHeight,
                        height: MediaQuery.of(context).size.height * 0.80,
                        // height: 400,
                        width: MediaQuery.of(context).size.height * 15,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 160,
                    left: 35,
                    child: Image.asset(
                      "assets/images/Group-3.png",
                      height: 160,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 110,
                    right: 130,
                    child: Image.asset(
                      "assets/images/Group-2.png",
                      height: 160,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 45,
                    child: Image.asset(
                      "assets/images/Group.png",
                      height: 140,
                      width: 130,
                      // fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: Text(
                            "Your card\n your identity".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: ThemeHelper().TextStyleMethod2(
                                28, context, FontWeight.w900, Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "An income generating Eco-system built with networking and profit sharing for all in mind.",
                textAlign: TextAlign.center,
                style: ThemeHelper().TextStyleMethod2(
                    13, context, FontWeight.w500, Colors.black87),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                if (islogin == "yes") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainPage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccount()),
                  );
                }
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Center(
                    child: Text(
                  "Let's Start",
                  style: ThemeHelper().TextStyleMethod2(
                      16, context, FontWeight.bold, Colors.white),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
