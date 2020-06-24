import 'package:flutter/material.dart';
import 'package:logintasktwo/login.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class FactTwo {
  String stotalExamGiven;
  String suserTotalAbsent;
  String sbestScore;
  String sbestScoreDate;
  String saveragePercent;


  FactTwo({this.stotalExamGiven, this.suserTotalAbsent, this.sbestScore, this.sbestScoreDate, this.saveragePercent});

  factory FactTwo.fromJson(Map<String,dynamic> json) {
    return FactTwo(
      stotalExamGiven: json['totalExamGiven'],
      suserTotalAbsent: json['userTotalAbsent'],
      sbestScore: json['bestScore'],
      sbestScoreDate: json['bestScoreDate'],
      saveragePercent: json['averagePercent'],
    );
  }
  Future<FactTwo> testAPiTwo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('stotalExamGiven', stotalExamGiven);
    print(stotalExamGiven);
    prefs.setString('suserTotalAbsent', suserTotalAbsent);
    print(suserTotalAbsent);
    prefs.setString('sbestScore', sbestScore);
    print(sbestScore);
    prefs.setString('sbestScoreDate', sbestScoreDate);
    print(sbestScoreDate);
    prefs.setString('saveragePercent', saveragePercent);
    print(saveragePercent);
  }

}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePage createState() => _HomePage();
}



class _HomePage extends State<HomePage> {
  String recTotalExamgiven;
  String recuserTotalAbsent;
  String recbestScore;
  String recbestScoreDate;
  String recaveragePercent;


  Future<FactTwo> attemptLogIn(String recToken , String recId) async {
    var res = await http.post(
        "http://owlbridge.in/quiz/apis/test",
        headers: {
          "Authorizations": recToken,
          "id": recId,
        },
        body: {
          "id": recId,
        }
    );

    if(res.statusCode == 200){
      final responseJson = json.decode(res.body);
      print(responseJson);
      return FactTwo.fromJson(responseJson);
    }else{
      print("you got error");
    }
    return null;
  }

  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  getTOken() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secToken = preferences.getString('stoken') ?? false;
    secToken = "gh " + secToken ;
//    print(secToken);
    return(secToken);
  }

  getId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secId = preferences.getString('sid') ?? false ;
//    print(secId);
    return(secId);
  }

  getTotalExamgiven() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secTotalExamgiven = preferences.getString('stotalExamGiven') ?? false ;
    print(secTotalExamgiven);
    return(secTotalExamgiven);
  }

  getuserTotalAbsent() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secuserTotalAbsent = preferences.getString('suserTotalAbsent') ?? false ;
    print(secuserTotalAbsent);
    return(secuserTotalAbsent);
  }

  getbestScore() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secbestScore = preferences.getString('sbestScore') ?? false ;
    print(secbestScore);
    return(secbestScore);
  }

  getbestScoreDate() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secbestScoreDate = preferences.getString('sbestScoreDate') ?? false ;
    print(secbestScoreDate);
    return(secbestScoreDate);
  }

  getaveragePercent() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secaveragePercent = preferences.getString('saveragePercent') ?? false ;
    print(secaveragePercent);
    return(secaveragePercent);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
          child: SingleChildScrollView(
          child: Center(
          child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Testing APi click Test api',
                    style: TextStyle(fontSize: 21))),
            FlatButton(
            onPressed: () async {
              String recToken = await getTOken();
              String recId = await getId();
              recTotalExamgiven = await getId();
              recuserTotalAbsent = await getId();
              recbestScore = await getId();
              recbestScoreDate = await getId();
              recaveragePercent = await getId();
              print(recToken);
              print(recId);
              print(recTotalExamgiven);
              print(recuserTotalAbsent);
              print(recbestScore);
              print(recbestScoreDate);
              print(recaveragePercent);
              var jwt = await attemptLogIn(recToken,recId);
              if(jwt != null) {
                displayDialog(context, "success", "account dedected");
              } else {
                displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
              }
            },
            child: Text("TestAPi")
        ),
//          Divider(),Text (recTotalExamgiven),
//            Divider(),
//            Text (recuserTotalAbsent),
//            Divider(),
//            Text (recbestScore),
//            Divider(),
//            Text (recbestScoreDate),
//            Divider(),
//            Text (recaveragePercent),

          ],
          ),
          )),
      ));

  }
}
