import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottptn/models/user_model.dart';
import 'package:nottptn/scaffold/my_service.dart';
import 'package:nottptn/utility/my_style.dart';
import 'package:nottptn/utility/normal_dialog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Explicit
  String user, password; // default value is null
  final formKey = GlobalKey<FormState>();
  UserModel userModel;

  // Method
  Widget loginButton() {
    return Container(
      width: 250.0,
      child: OutlineButton(
        child: Text(
          'Login',
          style: TextStyle(color: MyStyle().textColor),
        ),
        onPressed: () {
          formKey.currentState.save();
          print(
            'user = $user,password = $password',
          );
          checkAuthen();
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    if (user.isEmpty || password.isEmpty) {
      // Have space
      normalDialog(context, 'Have space', 'Please fill all input');
    } else {
      // No space
      String url =
          'http://ptnpharma.com/app/json_login_get.php?username=$user&password=$password';
      Response response = await get(
          url); // await จะต้องทำงานใน await จะเสร็จจึงจะไปทำ process ต่อไป
      var result = json.decode(response.body);

      int statusInt = result['status'];
      print('statusInt = $statusInt');

      if (statusInt == 0) {
        String message = result['message'];
        normalDialog(context, 'Login fail', message);
      } else {
        Map<String, dynamic> map = result['data'];
        print('map = $map');
        userModel = UserModel.fromJson(map);

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return MyService(userModel: userModel,);
        });
        Navigator.of(context).pushAndRemoveUntil(materialPageRoute,   // pushAndRemoveUntil  clear หน้าก่อนหน้า route with out airrow back
            (Route<dynamic> route) {
          return false;
        });
      }
    }
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextFormField( 
        initialValue: 'nott',// set default value
        onSaved: (String string) {
          user = string.trim();
        },
        decoration: InputDecoration(
          labelText: 'User :',
          labelStyle: TextStyle(color: MyStyle().textColor),
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: TextFormField(
        initialValue: '123456789',   // set default value
        onSaved: (String string) {
          password = string.trim();
        },
        obscureText: true, // hide text key replace with
        decoration: InputDecoration(
          labelText: 'Pass :',
          labelStyle: TextStyle(color: MyStyle().textColor),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Nott PTN',
      style: TextStyle(
        fontSize: MyStyle().h1,
        color: MyStyle().mainColor,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: MyStyle().fontName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, MyStyle().bgColor],
              radius: 0.8,
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, //
                children: <Widget>[
                  showLogo(),
                  showAppName(),
                  userForm(),
                  passwordForm(),
                  loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
