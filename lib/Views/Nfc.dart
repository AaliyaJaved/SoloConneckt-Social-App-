import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../Styles/ThemeHelper.dart';
import 'package:lottie/lottie.dart';

class MyAppNFc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppNFcState();
}

class MyAppNFcState extends State<MyAppNFc>
    with SingleTickerProviderStateMixin {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // actions: [
        //   Text(
        //     "NFC Scanning",
        //     style: ThemeHelper()
        //         .TextStyleMethod2(18, context, FontWeight.w600, Colors.black),
        //   ),
        //   Spacer()
        // ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              "NFC Scanning",
              style: ThemeHelper()
                  .TextStyleMethod2(18, context, FontWeight.w600, Colors.black),
            ),
            Text(
              "Profile",
              style: ThemeHelper().TextStyleMethod2(
                  18, context, FontWeight.w600, Theme.of(context).colorScheme.background),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.vertical,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(border: Border.all()),
                        child: SingleChildScrollView(
                          child: ValueListenableBuilder<dynamic>(
                            valueListenable: result,
                            builder: (context, value, _) => Text(
                                '${value ?? ''}',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _tagRead();
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 60,
                              width: 350,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  "Scan NFC",
                                  style: ThemeHelper().TextStyleMethod2(16,
                                      context, FontWeight.bold, Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: 250,
                            // height: 250,
                            child: Lottie.asset(
                              'assets/images/nfcCard.json',
                              fit: BoxFit.cover,
                              repeat: true,
                              reverse: true,
                              controller: _controller,
                              onLoaded: (composition) {
                                // Configure the AnimationController with the duration of the
                                // Lottie file and start the animation.
                                _controller
                                  ..duration = composition.duration
                                  ..repeat();
                              },
                            ),
                          )
                        ],
                      ),
                      // GridView.count(
                      //   padding: EdgeInsets.all(4),
                      //   crossAxisCount: 2,
                      //   childAspectRatio: 4,
                      //   crossAxisSpacing: 4,
                      //   mainAxisSpacing: 4,
                      //   children: [
                      //     ElevatedButton(
                      //         child: Text('Tag Read'), onPressed: _tagRead),
                      //     ElevatedButton(
                      //         child: Text('Ndef Write'),
                      //         onPressed: _ndefWrite),
                      //     ElevatedButton(
                      //         child: Text('Ndef Write Lock'),
                      //         onPressed: _ndefWriteLock),
                      //   ],
                      // ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('Hello World!'),
        NdefRecord.createUri(Uri.parse('https://flutter.dev')),
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        NdefRecord.createExternal(
            'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not ndef';
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }

      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:nfc_manager/nfc_manager.dart';

// import 'package:lottie/lottie.dart';
// import '../Styles/ThemeHelper.dart';

// class MyAppNFc extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => MyAppNFcState();
// }

// class MyAppNFcState extends State<MyAppNFc>
//     with SingleTickerProviderStateMixin {
//   ValueNotifier<dynamic> result = ValueNotifier(null);
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller =
//         AnimationController(duration: Duration(milliseconds: 700), vsync: this);
//     _controller.repeat(reverse: true);
//   }

//   bool isScan = false, showAnnimation = false;
//   Future<void> _showChoiceDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(
//               "Press Allow to scan NFC.",
//               style: TextStyle(color: Colors.blue),
//             ),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: [
//                   Divider(
//                     height: 1,
//                     color: Colors.blue,
//                   ),
//                   ListTile(
//                     onTap: () {
                      
//                       setState(() {
//                         showAnnimation = true;
//                       });
//                       Navigator.pop(context);
                      
//                       _tagRead();
//                       // _getFromGallery();
//                     },
//                     title: Text("Allow"),
//                     leading: Icon(
//                       Icons.account_box,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   Divider(
//                     height: 1,
//                     color: Colors.blue,
//                   ),
//                   ListTile(
//                     onTap: () {
//                       Navigator.pop(context);
//                       // _getFromCamera();
//                     },
//                     title: Text("Does not alolow."),
//                     leading: Icon(
//                       Icons.camera,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

// // @override
// //   void initState() {
// //     _showChoiceDialog(context);
// //     // TODO: implement initState
// //     super.initState();

// //   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Center(
//           child: Text(
//             "NFC Scanning",
//             style: ThemeHelper()
//                 .TextStyleMethod2(18, context, FontWeight.w600, Colors.black),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: FutureBuilder<bool>(
//             future: NfcManager.instance.isAvailable(),
//             builder: (context, ss) {
//               if (ss.data != true) {
//                 return Center(child: Text('Nfc is not available'));
//               } else if (!isScan) {
//                 if (showAnnimation) {
//                   return SizedBox(
//                     // width: 250,
//                     // height: 250,
//                     child: Lottie.asset(
//                       'assets/images/nfcCard.json',
//                       fit: BoxFit.cover,
//                       repeat: true,
//                       reverse: true,
//                       controller: _controller,
//                       onLoaded: (composition) {
//                         // Configure the AnimationController with the duration of the
//                         // Lottie file and start the animation.
//                         _controller
//                           ..duration = composition.duration
//                           ..forward();
//                       },
//                     ),
//                   );
//                 } else {
//                   return Center(
//                     child: InkWell(
//                       onTap: () {
//                         _showChoiceDialog(context);
//                       },
//                       child: Container(
//                         height: 60,
//                         width: 350,
//                         decoration: BoxDecoration(
//                             color: Colors.black,
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(15))),
//                         child: Center(
//                           child: Text(
//                             "Scan NFC",
//                             style: ThemeHelper().TextStyleMethod2(
//                                 16, context, FontWeight.bold, Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               } else {
//                 return Flex(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   direction: Axis.vertical,
//                   children: [
//                     Flexible(
//                       flex: 2,
//                       child: Container(
//                         margin: EdgeInsets.all(4),
//                         constraints: BoxConstraints.expand(),
//                         decoration: BoxDecoration(border: Border.all()),
//                         child: SingleChildScrollView(
//                           child: ValueListenableBuilder<dynamic>(
//                             valueListenable: result,
//                             builder: (context, value, _) {
//                               print("result ki value ${value}");
//                                return Text('${value ?? ''}',style: TextStyle(color: Colors.black),);}
//                           ),
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       child: InkWell(
//                         onTap: () {
//                           // if (_formKey.currentState!.validate()) {
//                           //   ApiCall().LoginUser(emailController.text, passwordController.text,context);

//                           // }
//                           _tagRead();
//                         },
//                         child: Container(
//                           height: 60,
//                           width: 350,
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15))),
//                           child: Center(
//                             child: Text(
//                               "Scan NFC",
//                               style: ThemeHelper().TextStyleMethod2(
//                                   16, context, FontWeight.bold, Colors.white),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Flexible(
//                     //   flex: 3,
//                     //   child: GridView.count(
//                     //     padding: EdgeInsets.all(4),
//                     //     crossAxisCount: 2,
//                     //     childAspectRatio: 4,
//                     //     crossAxisSpacing: 4,
//                     //     mainAxisSpacing: 4,
//                     //     children: [

//                     //       ElevatedButton(
//                     //           child: Text('Tag Read'), onPressed: _tagRead),
//                     //       ElevatedButton(
//                     //           child: Text('Ndef Write'),
//                     //           onPressed: _ndefWrite),
//                     //       ElevatedButton(
//                     //           child: Text('Ndef Write Lock'),
//                     //           onPressed: _ndefWriteLock),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 );
//               }
//             }),
//       ),
//     );
//   }

//   void _tagRead() {
//     print("nfc 00");
//     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//       result.value = tag.data;
//       print("nfc result agya ${result.value}");
//       NfcManager.instance.stopSession();
//     });
//     setState(() {
//       isScan = true;
//     });
//   }

//   void _ndefWrite() {
//     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//       var ndef = Ndef.from(tag);
//       if (ndef == null || !ndef.isWritable) {
//         result.value = 'Tag is not ndef writable';
//         NfcManager.instance.stopSession(errorMessage: result.value);
//         return;
//       }

//       NdefMessage message = NdefMessage([
//         NdefRecord.createText('Hello World!'),
//         NdefRecord.createUri(Uri.parse('https://flutter.dev')),
//         NdefRecord.createMime(
//             'text/plain', Uint8List.fromList('Hello'.codeUnits)),
//         NdefRecord.createExternal(
//             'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits)),
//       ]);

//       try {
//         await ndef.write(message);
//         result.value = 'Success to "Ndef Write"';
//         NfcManager.instance.stopSession();
//       } catch (e) {
//         result.value = e;
//         NfcManager.instance.stopSession(errorMessage: result.value.toString());
//         return;
//       }
//     });
//   }

//   void _ndefWriteLock() {
//     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
//       var ndef = Ndef.from(tag);
//       if (ndef == null) {
//         result.value = 'Tag is not ndef';
//         NfcManager.instance.stopSession(errorMessage: result.value.toString());
//         return;
//       }

//       try {
//         await ndef.writeLock();
//         result.value = 'Success to "Ndef Write Lock"';
//         NfcManager.instance.stopSession();
//       } catch (e) {
//         result.value = e;
//         NfcManager.instance.stopSession(errorMessage: result.value.toString());
//         return;
//       }
//     });
//   }
// }