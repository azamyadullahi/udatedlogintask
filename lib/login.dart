import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logintasktwo/main.dart';
import 'package:logintasktwo/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logintasktwo/HomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class Fact {
  String sid;
  String stoken;
  String smessage;

  Fact({this.sid, this.stoken, this.smessage});

  factory Fact.fromJson(Map<String,dynamic> json) {
    return Fact(
      sid: json['Id'],
      stoken: json['Token'],
      smessage: json['Message'],
    );
  }
  Future<Fact> testAPi() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('sid', sid);
    print(sid);
    prefs.setString('stoken', stoken);
    print(stoken);
    prefs.setString('smessage', smessage);
    print(smessage);
  }



}



class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser>{
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final   url = 'http://owlbridge.in/quiz/apis';
  final storage = FlutterSecureStorage();
  String sid;
  String stoken;
  String smessage;


  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );



  Future<Fact> attemptLogIn(String username, String password) async {
    var res = await http.post(
        "http://owlbridge.in/quiz/apis/login",
        body: {
          "email": username,
          "password": password
        }
    );

    if(res.statusCode == 200){
      final responseJson = json.decode(res.body);
      print(responseJson);
      return Fact.fromJson(responseJson);
      }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Log In"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    if(jwt != null) {
                      jwt.testAPi();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(),
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Log In")
              ),
              FlatButton(
                  onPressed: ()  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signup(),
                        )
                    );
                  },
                  child: Text("Sign up")
              ),

            ],
          ),
        )
    );
  }
}