//TODO: Update text prompt (e.g. "loading whatsapp", "enter correct number", etc)
//TODO: Test app on iOS device

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = 'Mobile_id';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'WhatsTap',
      home: MyHomePage(title: 'WhatsTap - WhatsApp new numbers!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Whatsapp', 'messaging', 'communication'],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
//        adUnitId: 'ca-app-pub-9722580295670170/9801938137',
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
//        appId: 'ca-app-pub-9722580295670170~5459653859');
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show(
        anchorType: AnchorType.top,
        anchorOffset: 100.0
      );
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }

  String result = "";

  _launchURL() async {
    String url = result;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String arabicToEnglishDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }

    return input;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
      ),
      body: new Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(
                hintText: "example: 0505XXXXXX",
                labelText: "Enter phone number",
              ),
              keyboardType: TextInputType.number,
              onChanged: (String str) {
                setState(() {
                  str = arabicToEnglishDigits(str);
                  result = "https://wa.me/966" "$str";
                });
              },
              style: TextStyle(
                  fontSize: 28.0
              ),
            ),
//            Text(
//              '$result',
//              style: Theme.of(context).textTheme.headline6,
//            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _launchURL,
        tooltip: 'Increment',
        child:
        Icon(Icons.message),
        backgroundColor: Colors.green,
      ),//new Row(
//        mainAxisAlignment: MainAxisAlignment.end,
//        children: <Widget>[
//          new Padding(
//              padding: new EdgeInsets.symmetric(
//                vertical: 80.0,
//              ),
//          ),

//        ],
//      ),
    );
  }
}