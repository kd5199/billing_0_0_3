import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/customer/customer_model.dart';
import 'package:flutter/cupertino.dart';

class CustomerProvider extends ChangeNotifier {
  List<CustomerModel> _items = [];
  List<CustomerModel> get items {
    return [..._items];
  }

  Future<void> fetchNSet() async {
    var dataList = await ShopDetailsDBHelper.getData('customer');
    _items.clear();
    _items = dataList
        .map((e) => CustomerModel(
            address: e['address'],
            contact: e['contact'],
            dlNo: e['dlno'],
            email: e['email'],
            gstin: e['gstin'],
            id: e['id'],
            title: e['title']))
        .toList();
    notifyListeners();
  }

  Future<void> addCustomer(CustomerModel item) {
    ShopDetailsDBHelper.insertData(table: 'customer', data: {
      'address': item.address,
      'contact': item.contact,
      'dlno': item.dlNo,
      'email': item.email,
      'id': DateTime.now().toString(),
      'title': item.title,
      'gstin': item.gstin
    });
    notifyListeners();
  }
}
