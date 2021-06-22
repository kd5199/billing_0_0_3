import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/stock/stock_model.dart';
import 'package:billing_0_0_3_/screens/Purchase/purchase_item_confirm.dart';
import 'package:billing_0_0_3_/widgets/common/custom_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class PurchaseSearchScreen extends StatefulWidget {
  static const routeName = '/PurchaseSearchScreen';
  //const PurchaseSearchScreen({ Key? key }) : super(key: key);

  @override
  _PurchaseSearchScreenState createState() => _PurchaseSearchScreenState();
}

class _PurchaseSearchScreenState extends State<PurchaseSearchScreen> {
  Future<List> Search(String title) async {
    ////print('entered search');
    if (title.length > 0) {
      final dataList =
          await ShopDetailsDBHelper.search(cat: 'title', searchKey: title);
      List<StockItemModel> item;
      item = dataList
          .map((e) => StockItemModel(
              id: e['id'],
              title: e['title'],
              imageUrl: File(e['imageUrl']),
              barcode: e['barcode'],
              batch: e['batch'],
              company: e['company'],
              exp: DateTime.parse(e['exp']),
              gstPercentage: e['gstPercentage'],
              ptr: e['ptr'],
              hsn: e['hsn'],
              mrp: e['mrp'],
              package: e['package'],
              quantity: e['quantity'],
              rack: e['rack'],
              rate: e['rate']))
          .toList();
      return List.generate(item.length, (index) {
        return {
          'title': item[index].title,
          'mrp': item[index].mrp,
          'company': item[index].company,
          'package': item[index].package,
          'quantity': item[index].quantity,
          'exp': item[index].exp,
          'rack': item[index].rack,
          'image': item[index].imageUrl,
          'rate': item[index].rate,
          'id': item[index].id,
          'ptr': item[index].ptr,
          'gstPercentage': item[index].gstPercentage,
          'hsn': item[index].hsn,
          'batch': item[index].batch,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5, left: 5, top: 30),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: true,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                      hintText: 'Search products',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)))),
              suggestionsCallback: (pattern) async {
                ////print(pattern);
                return await Search(pattern);
              },
              itemBuilder: (context, suggestion) {
                ////print('itembuilder');
                return CustomListItem(
                  deleteFunction: null,
                  editFunction: null,
                  id: suggestion['id'],
                  imageUrl: suggestion['imageUrl'],
                  title: suggestion['title'],
                  subtitle2: 'Package ${suggestion['package']}',
                  subtitle1: suggestion['company'],
                  subtitle3:
                      'Expiry Date:${DateFormat.yMMM().format(suggestion['exp']).toString()}',
                  subtitle4: 'Stock:${suggestion['quantity']}',
                  trailing1: 'MRP:₹${suggestion['mrp']}',
                  trailing2: 'Rate:₹${suggestion['rate']}',
                  trailing3: 'PTR:₹${suggestion['ptr']}',
                );
              },
              onSuggestionSelected: (suggestion) {
                Navigator.pop(context);
                Navigator.pushNamed(context, PurchaseItemConfirm.routeName,
                    arguments: suggestion['id']);
              },
            ),
          ),
        ],
      ),
    );
  }
}
