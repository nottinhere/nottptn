import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottptn/models/product_all_model.dart';
import 'package:nottptn/models/unit_size_model.dart';
import 'package:nottptn/utility/my_style.dart';

class Detail extends StatefulWidget {
  final ProductAllModel productAllModel;
  Detail({Key key, this.productAllModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // Explicit
  ProductAllModel currentProductAllModel;
  ProductAllModel productAllModel;
  List<UnitSizeModel> unitSizeModels = List();
  List<int> amounts = [1,2,3]; // amount[0] -> s,amount[1] -> m,amount[2] -> l;

  // Method
  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    getProductWhereID();
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
    return IconButton(
      icon: Icon(Icons.remove_circle_outline),
      onPressed: () {
        print('dec index $index');
      },
    );
  }

  Widget incButton(int index) {
    return IconButton(
      icon: Icon(Icons.add_circle_outline),
      onPressed: () {
        print('inc index $index');
      },
    );
  }

  Widget showValue(int index) {
    return Text('${amounts[index]}');
  }

  Widget incDecValue(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        decButton(index),
        showValue(index),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

  Widget showDetailList() {
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
