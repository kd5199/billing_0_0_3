import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/supplier/supplier_model.dart';
import 'package:flutter/cupertino.dart';

class SupplierProvider extends ChangeNotifier {
  List<SupplierModel> _items = [];
  List<SupplierModel> get items {
    return [..._items];
  }

  Future<void> fetchNset() async {
    var dataList = await ShopDetailsDBHelper.getData('supplier');
    _items.clear();
    _items = dataList
        .map((e) => SupplierModel(
            id: e['id'],
            address: e['address'],
            gstin: e['gstin'],
            title: e['title']))
        .toList();
    //notifyListeners();
  }

  Future<void> addSupplier(SupplierModel details) async {
    _items.clear();
    await ShopDetailsDBHelper.insertData(table: 'supplier', data: {
      'id': DateTime.now().toString(),
      'address': details.address,
      'gstin': details.gstin,
      'title': details.title
    });

    notifyListeners();
  }

  void delete(String id) {
    ShopDetailsDBHelper.deleteData(id, 'supplier');
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  SupplierModel searchById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void editSupplier({String productId, SupplierModel item}) {
    //print('EditStock');
    int index =
        _items.indexOf(_items.firstWhere((element) => element.id == productId));
    final newItem = SupplierModel(
      title: item.title,
      address: item.address,
      gstin: item.gstin,
    );
    _items[index] = newItem;
    Map<String, Object> existing = {
      'id': productId,
      'title': item.title,
      'address': item.address,
      'gstin': item.gstin,
    };
    ShopDetailsDBHelper.updateData(
        table: 'supplier', id: productId, data: existing);
    notifyListeners();
  }
}
