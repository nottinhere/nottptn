import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottptn/models/user_model.dart';
import 'package:nottptn/scaffold/result_code.dart';
import 'package:nottptn/utility/my_style.dart';
import 'package:nottptn/widget/contact.dart';
import 'package:nottptn/widget/home.dart';

import 'detail_cart.dart';

class MyService extends StatefulWidget {
  final UserModel userModel;
  MyService({Key key, this.userModel}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  //Explicit
  UserModel myUserModel;
  Widget currentWidget;
  String qrString;
  int amontCart = 0;

  // Method
  @override
  void initState() {
    super.initState(); // จะทำงานก่อน build
    setState(() {
      myUserModel = widget.userModel;
      currentWidget = Home(
        userModel: myUserModel,
      );
    });
    readCart();
  }

  Widget menuHome() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36.0,
      ),
      title: Text('Home'),
      subtitle: Text('Description Home'),
      onTap: () {
        setState(() {
          readCart();
          currentWidget = Home(
            userModel: myUserModel,
          );
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuContact() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36.0,
      ),
      title: Text('Contact'),
      subtitle: Text('Contact pattana'),
      onTap: () {
        setState(() {
          currentWidget = Contact();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuReadQRcode() {
    return ListTile(
      leading: Icon(
        Icons.photo_camera,
        size: 36.0,
      ),
      title: Text('Read QR code'),
      subtitle: Text('Read QR code or barcode'),
      onTap: () {
        readQRcode();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> readQRcode() async {
    try {
      qrString = await BarcodeScanner.scan();
      print('QR code = $qrString');
      if (qrString != null) {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return ResultCode(
            result: qrString,
          );
        }); // Link to  screen
        Navigator.of(context).push(materialPageRoute);
      }
    } catch (e) {
      print('e = $e');
    }
  }

  Widget showAppName() {
    return Text('Nott PTN');
  }

  Widget showLogin() {
    String login = myUserModel.name;
    if (login == null) {
      login = '...';
    }
    return Text('Login by $login');
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget headDrawer() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[showLogo(), showAppName(), showLogin()],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          menuHome(),
          menuContact(),
          menuReadQRcode(),
        ],
      ),
    );
  }

  Future<void> readCart() async {
    amontCart = 0;
    String memberId = myUserModel.id;
    String url =
        'http://ptnpharma.com/app/json_loadmycart.php?memberId=$memberId';

    Response response = await get(url);
    var result = json.decode(response.body);
    var cartList = result['cart'];

    for (var map in cartList) {
      setState(() {
        amontCart++;
      });
    }
  }

  Widget showCart() {
    return GestureDetector(
      onTap: () {
        routeToDetailCart();
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.0, right: 5.0),
        width: 32.0,
        height: 32.0,
        child: Stack(
          children: <Widget>[
            Image.asset('images/shopping_cart.png'),
            Text(
              '$amontCart',
              style: TextStyle(
                backgroundColor: Colors.blue.shade600,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void routeToDetailCart() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return DetailCart(
        userModel: myUserModel,
      );
    });
    Navigator.of(context).push(materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          showCart(),
        ],
        backgroundColor: MyStyle().textColor,
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
