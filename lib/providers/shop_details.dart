import 'package:billing_0_0_3_/model/shop_details/shop_details.dart';
import 'package:flutter/cupertino.dart';
import '../helper/main_db_helper.dart';

class ShopDetailsProvider extends ChangeNotifier {
  List<ShopDetailsModel> _items = [];
  List<ShopDetailsModel> get items {
    return [..._items];
  }

  Future<void> getData() async {
    var dataList = await ShopDetailsDBHelper.getData('shopdetails');
    _items = dataList
        .map((e) => ShopDetailsModel(
            address: e['address'],
            contact: e['contact'],
            dlNo: e['dlNo'],
            email: e['email'],
            fYear: e['fYear'],
            gstin: e['gstin'],
            title: e['title']))
        .toList();
    notifyListeners();
  }

  Future<void> insertData(Map<String, Object> data) async {
    await ShopDetailsDBHelper.insertShop(data: data);
    notifyListeners();
  }
}
