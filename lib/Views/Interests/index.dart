import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:soloconneckt/Views/MainPage/index.dart';
import 'package:soloconneckt/Views/VerificationPage/index.dart';
import 'package:soloconneckt/Widgets/textFeildDecoration.dart';

import '../../Styles/ThemeHelper.dart';
import '../../Styles/palette.dart';
import '../../Widgets/ShowResponse.dart';

class Interests extends StatelessWidget {
  String email, password, name, number;
  File? imageFile;
  Interests(
      {this.email = "",
      this.name = "",
      this.password = "",
      this.number = "",
      this.imageFile,
      key})
      : super(key: key);




  String selectedValue = "Entertainment";
  final _chipKey = GlobalKey<ChipsInputState>();

  @override
  Widget build(BuildContext context) {
    const mockResults = <AppProfile>[
      AppProfile('Fashion'),
      AppProfile('Entertainment'),
      AppProfile('Fitness'),
      AppProfile('Writing'),
      AppProfile('Blogging'),
      AppProfile('Marketting'),
    ];
    var list=[];
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ))
                    ],
                  ),
                  Hero(
                      tag: "pic",
                      child: Image.asset(
                        "assets/images/whitelogo.png",
                        width: 250,
                        height: 250,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select your intrest*",
                        textAlign: TextAlign.start,
                        style: ThemeHelper().TextStyleMethod2(
                            12, context, FontWeight.w600, Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ChipsInput(
                    key: _chipKey,
                    initialValue: [
                      AppProfile('Fashion'),
                    ],
                    // autofocus: true,
                    // allowChipEditing: true,
                    // keyboardAppearance: Brightness.dark,
                    suggestionsBoxMaxHeight: 200,
                    textCapitalization: TextCapitalization.words,
                    // enabled: false,
                    // maxChips: 5,
                    textStyle: ThemeHelper().TextStyleMethod2(
                      16,
                      context,
                      FontWeight.bold,
                      Palette.Black,
                    ),
                    decoration: TextFormFeildDecoration(),
                    findSuggestions: (String query) {
                      // print("Query: '$query'");
                      if (query.isNotEmpty) {
                        var lowercaseQuery = query.toLowerCase();
                        return mockResults.where((profile) {
                          return profile.name
                              .toLowerCase()
                              .contains(query.toLowerCase());
                        }).toList(growable: false)
                          ..sort((a, b) => a.name
                              .toLowerCase()
                              .indexOf(lowercaseQuery)
                              .compareTo(b.name
                                  .toLowerCase()
                                  .indexOf(lowercaseQuery)));
                      }
                      // return <AppProfile>[];
                      return mockResults;
                    },
                    onChanged: (data) {
                      list=data;
                    },
                    chipBuilder: (context, state, dynamic profile) {
                      return InputChip(
                        key: ObjectKey(profile),
                        label: Text(profile.name),
                        // avatar: CircleAvatar(
                        //   backgroundImage: NetworkImage(profile.imageUrl),
                        // ),
                        onDeleted: () => state.deleteChip(profile),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    },
                    suggestionBuilder: (context, state, dynamic profile) {
                      return Container(
                        color: Colors.white,
                        child: ListTile(
                          textColor: Colors.black,
                          key: ObjectKey(profile),
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(profile.imageUrl),
                          // ),
                          title: Text(profile.name),
                          // subtitle: Text(profile.email),
                          onTap: () => state.selectSuggestion(profile),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      if (list != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerificationPage(
                              email: email,
                              name: name,
                              password: password,
                              number: number,
                              imageFile: imageFile,
                              interest: list,
                            )),
                  );
                } else {
                  ShowResponse("Please select an interest.", context);
                }
                    },
                    child: Container(
                      height: 58,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Palette.blue,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: ThemeHelper().TextStyleMethod2(
                              16, context, FontWeight.bold, Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class AppProfile {
  final String name;

  const AppProfile(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}
