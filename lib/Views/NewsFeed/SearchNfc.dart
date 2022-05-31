
import 'package:flutter/material.dart';
import 'package:soloconneckt/Styles/ThemeHelper.dart';

class NfcSearch extends StatelessWidget {
  const NfcSearch({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    "Search NFC",
                    style: ThemeHelper()
                        .TextStyleMethod1(18, context, FontWeight.w600),
                  ),
                  Text(
                    " NFC",
                    style: ThemeHelper()
                        .TextStyleMethod2(18, context, FontWeight.w600,Theme.of(context).backgroundColor),
                  ),
                ],
              ),
            ),
              Text("No NFC to search",
                      style: ThemeHelper()
                          .TextStyleMethod1(14, context, FontWeight.w600),
                    ),
          ],
        ),
      ),
      
    );
  }
}