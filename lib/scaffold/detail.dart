import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottptn/models/product_all_model.dart';
import 'package:nottptn/models/unit_size_model.dart';
import 'package:nottptn/models/user_model.dart';
import 'package:nottptn/scaffold/detail_cart.dart';
import 'package:nottptn/utility/my_style.dart';
import 'package:nottptn/utility/normal_dialog.dart';

class Detail extends StatefulWidget {
  final ProductAllModel productAllModel;
  final UserModel userModel;

  Detail({Key key, this.productAllModel, this.userModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // Explicit
  ProductAllModel currentProductAllModel;
  ProductAllModel productAllModel;
  List<UnitSizeModel> unitSizeModels = List();
  List<int> amounts = [
    0,
    0,
    0
  ]; // amount[0] -> s,amount[1] -> m,amount[2] -> l;
  int amontCart = 0;
  UserModel myUserModel;

  // Method
  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    myUserModel = widget.userModel;
    setState(() {
      getProductWhereID();
      readCart();
    });
  }

  Future<void> getProductWhereID() async {
    if (currentProductAllModel != null) {
      String id = currentProductAllModel.id;
      String url = '${MyStyle().getProductWhereId}$id';
      Response response = await get(url);
      var result = json.decode(response.body);
      print('result = $result');

      var itemProducts = result['itemsProduct'];
      for (var map in itemProducts) {
        print('map = $map');

        setState(() {
          productAllModel = ProductAllModel.fromJson(map);

          Map<String, dynamic> priceListMap = map['price_list'];
          // print('priceListMap = $priceListMap');

          Map<String, dynamic> sizeSmap = priceListMap['s'];
          if (sizeSmap != null) {
            UnitSizeModel unitSizeModel = UnitSizeModel.fromJson(sizeSmap);
            unitSizeModels.add(unitSizeModel);
          }
          Map<String, dynamic> sizeMmap = priceListMap['m'];
          if (sizeMmap != null) {
            UnitSizeModel unitSizeModel = UnitSizeModel.fromJson(sizeMmap);
            unitSizeModels.add(unitSizeModel);
          }
          Map<String, dynamic> sizeLmap = priceListMap['l'];
          if (sizeLmap != null) {
            UnitSizeModel unitSizeModel = UnitSizeModel.fromJson(sizeLmap);
            unitSizeModels.add(unitSizeModel);
          }
          // print('sizeSmap = $sizeSmap');
          // print('sizeMmap = $sizeMmap');
          // print('sizeLmap = $sizeLmap');
          print('unitSizeModel = ${unitSizeModels[0].lable}');
        });
      } // for
    }
  }

  Widget showImage() {
    return Container(
      height: 180.0,
      child: Image.network(productAllModel.photo),
    );
  }

  Widget showTitle() {
    return Text(productAllModel.title);
  }

  Widget showDetail() {
    return Text(productAllModel.detail);
  }

  Widget showPackage(int index) {
    return Text(unitSizeModels[index].lable);
  }

  Widget showPricePackage(int index) {
    return Text('${unitSizeModels[index].price} บาท/ ');
  }

  Widget showChoosePricePackage(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        showDetailPrice(index),
        incDecValue(index),
      ],
    );
  }

  Widget showDetailPrice(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showPricePackage(index),
        showPackage(index),
      ],
    );
  }

  Widget decButton(int index) {
    int value = amounts[index];
    return IconButton(
      icon: Icon(Icons.remove_circle_outline),
      onPressed: () {
        print('dec index $index');
        if (value == 0) {
          normalDialog(context, 'Cannot decrese', 'Because empty cart');
        } else {
          setState(() {
            value--;
            amounts[index] = value;
          });
        }
      },
    );
  }

  Widget incButton(int index) {
    int value = amounts[index];

    return IconButton(
      icon: Icon(Icons.add_circle_outline),
      onPressed: () {
        setState(() {
          print('inc index $index');
          value++;
          amounts[index] = value;
        });
      },
    );
  }

  Widget showValue(int value) {
    return Text('$value');
  }

  Widget incDecValue(int index) {
    int value = amounts[index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        decButton(index),
        showValue(value),
        incButton(index),
      ],
    );
  }

  Widget showPrice() {
    return Container(
      height: 150.0,
      // color: Colors.grey,
      child: ListView.builder(
        itemCount: unitSizeModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return showChoosePricePackage(index); // showDetailPrice(index);
        },
      ),
    );
  }

  Future<void> readCart() async {
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
        title: Text('Detail'),
      ),
      body: productAllModel == null ? showProgress() : showDetailList(),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget addButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: MyStyle().textColor,
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showDetailList() {
    return Stack(
      children: <Widget>[
        showController(),
        addButton(),
      ],
    );
  }

  ListView showController() {
    return ListView(
      padding: EdgeInsets.all(30.0),
      children: <Widget>[
        showImage(),
        showTitle(),
        showDetail(),
        showPrice(),
      ],
    );
  }
}
