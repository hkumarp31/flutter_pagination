import 'package:bs_assignment/AppLocalization.dart';
import 'package:bs_assignment/ConstantDecorations/ConstantDecorations.dart';
import 'package:bs_assignment/ConstantDecorations/Constants.dart';
import 'package:bs_assignment/Dashboard/DashBoardScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSignIn extends StatefulWidget {
  UserSignIn({Key key}) : super(key: key);

  @override
  _UserSignInState createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {

  final GlobalKey<FormState> formKey = new GlobalKey();
  bool _autoValidate = false;

  String userName="", password="";
  Map<String, String> userNameVSPasswordMapping = {
    "9898989898" : "password123",
    "9876543210" : "password123"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfff9f9f9),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(Constants.margin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(Constants.margin*2, 0, Constants.margin*2, 0),
//                      color: Color(0xfff9f9f9),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [Colors.black12, Colors.grey]
                          )
                      ),
                      child: Image.asset(
                          "lib/AssetImages/gameTV.png"
                      )
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Constants.margin*2, 0, Constants.margin*2, 0),
                    child: TextFormField(
                      maxLength: 10,
                      maxLengthEnforced: true,
                      decoration: ConstantDecorations.inputFieldDecoration(AppLocalizations.of(context).translate("username")),
                      onChanged: (value) {
                        this.userName = value;
                      },
                      validator: (userName){
                        if(userName.trim().length == 0) {
                          return AppLocalizations.of(context).translate("please_enter_username");
                        } else if(userName.trim().length <= 3){
                          return AppLocalizations.of(context).translate("username_should_be_more_than_3_characters");
                        } else if (userName.trim().length > 10){
                          return AppLocalizations.of(context).translate("username_should_not_be_more_than_10_characters");
                        } else {
                            return null;
                        }
                      },
                      autovalidate: _autoValidate,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(Constants.margin*2, 0, Constants.margin*2, 0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: ConstantDecorations.inputFieldDecoration(AppLocalizations.of(context).translate("password")),
                      onChanged: (value) {
                        this.password = value;
                      },
                      validator: (passWord) {
                        if (passWord.trim().length == 0) {
                          return AppLocalizations.of(context).translate("please_enter_password");
                        } else if(passWord.trim().length <= 3) {
                          return AppLocalizations.of(context).translate("password_should_be_more_than_3_characters");
                        } else if (passWord.trim().length > 11) {
                          return AppLocalizations.of(context).translate("password_should_not_be_more_than_11_characters");
                        } else {
                          return null;
                        }
                      },
                      autovalidate: _autoValidate,
                    ),
                  ),
                  SizedBox(
                    height: Constants.margin * 5,
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width - Constants.margin*6,
                    height: 60,
                    child: RaisedButton(
                      child: Text(
                        AppLocalizations.of(context).translate("sign_in"),
                        style: ConstantDecorations.tournamentStatic(),
                      ),
                      onPressed: verifyAndLoginToDashboard,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> verifyAndLoginToDashboard() async {
    if(formKey.currentState.validate()){
      if(this.userNameVSPasswordMapping.containsKey(userName)) {
        if(this.userNameVSPasswordMapping[userName] == password) {
          //Move To DashBoard Screen
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isUserLoggedIn', true);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashBoardScreen()),
          );
        } else {
          // password is incorrect
          print("${this.userNameVSPasswordMapping[userName]} : ${this.password}");
          returnErrorDialog(AppLocalizations.of(context).translate("please_enter_correct_password"));
        }
      } else {
        // username is incorrect
        returnErrorDialog(AppLocalizations.of(context).translate("please_enter_correct_username"));
      }
    }
  }
  
  void returnErrorDialog(String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: new Text(AppLocalizations.of(context).translate("okay")),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
       }
    );
  }
}