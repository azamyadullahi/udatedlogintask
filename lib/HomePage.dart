import 'package:flutter/material.dart';
import 'package:logintasktwo/login.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  Future<Fact> attemptLogIn(String recToken , String recId) async {
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
      print("successs");
      return Fact.fromJson(responseJson);
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
//    print(secToken);
  }

  getId() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String secId = preferences.getString('sid') ?? false ;
//    print(secId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Center(
        child: FlatButton(
            onPressed: () async {
              String recToken = await getTOken();
              String recId = await getId();
              print(recToken);
              print(recId);
//              var jwt = await attemptLogIn(recToken,recId);
//              if(jwt != null) {
//                displayDialog(context, "successfull", "account dedected");
//              } else {
//                displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
//              }
            },
            child: Text("TestAPi")
        ),
      ),);
  }
}