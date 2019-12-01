import 'package:flutter/material.dart';

class MyStyle {
  double h1 = 24.0, h2 = 18.0;
  Color mainColor   = Colors.blueGrey.shade700;
  Color textColor = Colors.blueGrey.shade500;
  Color bgColor = Colors.green.shade100;


  String fontName = 'Sarabun';

  // For server 

  String readAllProduct           = 'http://ptnpharma.com/app/json_product.php';
  String readProductWhereMode     = 'http://ptnpharma.com/app/json_product.php?product_mode=';
  String getUserWhereUserAndPass  = 'http://ptnpharma.com/app/json_login_get.php';
  String getProductWhereId        = 'http://ptnpharma.com/app/json_productdetail.php?id=';

  String loadMyCart               =  'http://ptnpharma.com/app/json_loadmycart.php?memberId=';

  /*
  String readAllProduct           = 'http://ptnpharma.com/app/json_product.php';
  String readProductWhereMode     = 'http://ptnpharma.com/app/json_product.php?product_mode=';
  String getUserWhereUserAndPass  = 'http://son.com/app/json_login_get.php';
  String getProductWhereId        = 'http://ptnpharma.com/app/json_productdetail.php?id=';
  */

  MyStyle();
}
