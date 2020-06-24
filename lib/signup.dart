import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logintasktwo/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logintasktwo/HomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login.dart';


class signup extends StatefulWidget{
  signup({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _signup createState() => _signup();
}

class _signup extends State<signup>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  Future attemptSignUp( ) async {

    // Getting value from Controller
    String email = _emailController.text;
    String password = _passwordController.text;
    String phone = _phoneController.text;
    String name = _nameController.text;


    var res = await http.post(
        "http://owlbridge.in/quiz/apis/register",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "email": email,
          "password": password,
          "phone": phone,
          "name": name,
        }
    );

    if(res.statusCode == 200){
      final responseJson = json.decode(res.body);
      print(responseJson);
      return (responseJson);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign Up"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password'
                ),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: 'Phone'
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name'
                ),
              ),
              FlatButton(
                  onPressed: attemptSignUp,
                  child: Text("SignUP")
              ),
              FlatButton(
                  onPressed: ()  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginUser(),
                        )
                    );
                  },
                  child: Text("Login")
              ),

            ],
          ),
        )
    );

  }


}