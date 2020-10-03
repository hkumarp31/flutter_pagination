import 'dart:convert';
import 'dart:io';

import 'package:bs_assignment/ConstantDecorations/ConstantDecorations.dart';
import 'package:bs_assignment/ConstantDecorations/Constants.dart';
import 'package:bs_assignment/Model/RecommendGamesModel.dart';
import 'package:bs_assignment/Registration/UserSignIn.dart';
import 'package:bs_assignment/UserDetail/UserDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../AppLocalization.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  RecommendGames recommendGames = new RecommendGames();
  List<RecommendGamesModel> recommendedList = new List();
  ScrollController scrollController = new ScrollController();
  double profileImageHeight = 0;
  double elementBorderRadius = 20;
  UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    this.fetchUserDetails();
    this.fetchRecommendedGames("");
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        this.fetchRecommendedGames(recommendGames.cursorPosition);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileImageHeight = 80;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('BS_ASSIGNMENT'),
              decoration: BoxDecoration(
                color: Color(0xfff9f9f9),
              ),
            ),
            ListTile(
              title: Text("English"),
              onTap: () {
                changeLocaleOfApplication(0);
                Navigator.pop(context);
                showLanguageChangeNotifier();
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).translate("japanese")),
              onTap: () {
                changeLocaleOfApplication(1);
                Navigator.pop(context);
                showLanguageChangeNotifier();
              },
            ),
            ListTile(
              title: Text("Sign Out"),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isUserLoggedIn', false);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSignIn()),
                );
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Flyingwolf",
          style: TextStyle(
            color: Colors.black
          ),
        ),
//        leading: Icon(Icons.favorite),
        backgroundColor: Color(0xfff9f9f9),
        iconTheme: new IconThemeData(color: Colors.black),
          elevation: 0,
      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Constants.margin),
            child: createBody(),
          )
      ),
    );
  }

  Widget createBody(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //UserDetails
          Container(
            margin: EdgeInsets.all(Constants.margin),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(profileImageHeight/2),
                  child: Container(
                    child: imageWidget(),
                  ),
                ),
                SizedBox(
                  width: Constants.margin*2
                ),
                //userInformation
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          userDetails == null ? "" : userDetails.username,
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(elementBorderRadius),
                        child: Container(
//                        color: Colors.white,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue
                            ),
                            borderRadius: BorderRadius.circular(elementBorderRadius),
                            color: Colors.white
                          ),
                          width: 170,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                userDetails == null ? "" : "${userDetails.rating}",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20
                                ),
                              ),
                              Text(
                                "Elo "+AppLocalizations.of(context).translate("rating")
                              )
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // TournamentInformation
          Container(
            margin: EdgeInsets.all(Constants.margin),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(elementBorderRadius),
              child: Container(
                height: 100,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: ConstantDecorations.setGradient(0xffe47d37, 0xffeba23e),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                                  userDetails == null ? "" : "${userDetails.tournamentsPlayed}",
                                    textAlign: TextAlign.center,
                                  style: ConstantDecorations.tournamentStatic(),
                                )
                            ),
                            Container(
                                child: Text(AppLocalizations.of(context).translate("tournaments_played"),
                                  textAlign: TextAlign.center,
                                  style: ConstantDecorations.tournamentStaticText(),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                    ),
                    Expanded(
                      child: Container(
                        decoration: ConstantDecorations.setGradient(0xff402995, 0xffa656bd),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                                  userDetails == null ? "" : "${userDetails.tournamentsWon}",
                                    textAlign: TextAlign.center,
                                  style: ConstantDecorations.tournamentStatic(),
                                )
                            ),
                            Container(
                                child: Text(AppLocalizations.of(context).translate("tournaments_won"),
                                    textAlign: TextAlign.center,
                                  style: ConstantDecorations.tournamentStaticText(),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: 2,
                    ),
                    Expanded(
                      child: Container(
                        decoration: ConstantDecorations.setGradient(0xffec5545, 0xffef7f50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                                  userDetails == null ? "" : "${userDetails.winPercentage}%",
                                    textAlign: TextAlign.center,
                                  style: ConstantDecorations.tournamentStatic(),
                                )
                            ),
                            Container(
                                child: Text(AppLocalizations.of(context).translate("winning_percentage"),
                                    textAlign: TextAlign.center,
                                  style: ConstantDecorations.tournamentStaticText(),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(Constants.margin),
            child: Text(
              AppLocalizations.of(context).translate("recommended_for_you"),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 25
            ),
            )
          ),
//          // ListRecommendedItems
          Container(
            child: Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: recommendedList.length,
                  itemBuilder: (context, index){
                  if(recommendedList == null){
                    return CircularProgressIndicator();
                  }
                  return recommendedItemWidget(recommendedList, index);
                  }
              ),
            ),
          ),
          SizedBox(
            height: Constants.sizedBoxHeight,
          ),
        ]
      )
    );
  }

  Widget recommendedItemWidget(List<RecommendGamesModel> recommendedList, int index){
    if(recommendedList != null){
      return Container(
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(elementBorderRadius)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                offset: Offset(0, 1),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ]),
        margin: EdgeInsets.all(Constants.margin),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(elementBorderRadius),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Image.network(recommendedList[index].gameCoverUrl,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(Constants.margin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Text(
//                                      reduceLargeString(
                                          recommendedList[index].tournamentName,
//                                      ),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black
                                      ),
                                    )
                                ),
                                Container(
                                    child: Text(
                                      recommendedList[index].gameName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff878fa8)
                                    ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              child: Icon(
                                Icons.navigate_next,
                                color: Colors.black,
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget imageWidget(){
    if(userDetails == null) {
      return Image.asset("lib/AssetImages/profileImage.png",
        height: profileImageHeight,
        width: profileImageHeight,
        fit: BoxFit.fill,
      );
    } else {
      return Image.network(userDetails.userProfileImageUrl,
        height: profileImageHeight,
        width: profileImageHeight,
        fit: BoxFit.fill,
      );
    }
  }

  void fetchRecommendedGames(String cursorPosition) async {
    http.Response jsonResponse;
    if(cursorPosition.isEmpty){
      jsonResponse = await http.get("http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all");
      print("Empty cursorPosition");
    } else {
      jsonResponse = await http.get("http://tournaments-dot-game-tv-prod.uc.r.appspot.com/tournament/api/tournaments_list_v2?limit=10&status=all&cursor=$cursorPosition");
      print("valued cursorPosition");
    }
    if(jsonResponse.statusCode == 200){
      recommendGames = new RecommendGames.fromJson(jsonDecode(jsonResponse.body));
      setState(() {
        this.recommendedList.addAll(recommendGames.recommendGamesList);
        print("RecommendedList: ${this.recommendedList.length}");
      });
    } else {
      setState(() {
        recommendedList = [];
      });
    }
  }
  void fetchUserDetails() async {
    http.Response jsonResponse = await http.get("https://next.json-generator.com/api/json/get/EkUcZdWIt");
    if(jsonResponse.statusCode == 200) {
      if(jsonResponse.body != null){
        setState(() {
          userDetails = new UserDetails.fromJson(jsonDecode(jsonResponse.body));
        });
      }
    }
  }

  String reduceLargeString(String name){
    if(name.length <= 29){
      return name;
    } else {
      return name.substring(0,29) + "...";
    }
  }

  Future<void> changeLocaleOfApplication(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(index){
      case 0 : prefs.setString("languageCode", "en");
                prefs.setString("countryCode", "US"); break;
      case 1 : prefs.setString("languageCode", "ja");
                prefs.setString("countryCode", "JP"); break;
      default : prefs.setString("languageCode", "en");
                prefs.setString("countryCode", "US");
    }
  }

  void showLanguageChangeNotifier(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Application Language Changed'),
        content: Text('Please restart the application to see the changes'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('CANCEL'),
          ),
          FlatButton(
            onPressed: () => exit(0),
            child: Text('EXIT'),
          ),
        ],
      ),
    );
  }

}
