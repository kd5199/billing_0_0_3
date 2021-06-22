import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:flutter/cupertino.dart';
//import 'package:path/path.dart' as path;
import 'dart:io';
import '../model/stock/stock_model.dart';

class StockProvider extends ChangeNotifier {
  List<StockItemModel> _items = [];
  List<StockItemModel> get items {
    return [..._items];
  }

  Future<void> fetchAndSet() async {
    final dataList = await ShopDetailsDBHelper.getData('stock');
    _items.clear();
    _items = dataList
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

    notifyListeners();
  }

  void addToStock({StockItemModel item, String id}) {
    if (id == null) id = DateTime.now().toString();

    final newItem = StockItemModel(
        title: item.title,
        barcode: item.barcode,
        batch: item.batch,
        company: item.company,
        exp: item.exp,
        gstPercentage: item.gstPercentage,
        ptr: item.ptr,
        hsn: item.hsn,
        id: id,
        imageUrl: item.imageUrl,
        mrp: item.mrp,
        package: item.package,
        quantity: item.quantity,
        rack: item.rack,
        rate: item.rate);
    _items.add(newItem);

    ShopDetailsDBHelper.insertData(table: 'stock', data: {
      'id': id,
      'title': item.title,
      'package': item.package,
      'company': item.company,
      'batch': item.batch,
      'mrp': item.mrp,
      'rate': item.rate,
      'ptr': item.ptr,
      'quantity': item.quantity,
      'gstPercentage': item.gstPercentage,
      'hsn': item.hsn,
      'barcode': item.barcode,
      'exp': item.exp.toString(),
      'imageUrl': item.imageUrl == null ? "" : item.imageUrl.path,
      'rack': item.rack
    });

    notifyListeners();
  }

  void deleteFromStock(String productId) {
    _items.removeWhere((element) => element.id == productId);
    ShopDetailsDBHelper.deleteData(productId, 'stock');
    notifyListeners();
  }

  void editStock({String productId, StockItemModel item}) {
    //print('EditStock');
    int index =
        _items.indexOf(_items.firstWhere((element) => element.id == productId));
    final newItem = StockItemModel(
        title: item.title,
        barcode: item.barcode,
        batch: item.batch,
        company: item.company,
        exp: item.exp,
        gstPercentage: item.gstPercentage,
        ptr: item.ptr,
        hsn: item.hsn,
        id: productId,
        imageUrl: item.imageUrl,
        mrp: item.mrp,
        package: item.package,
        quantity: item.quantity,
        rack: item.rack,
        rate: item.rate);
    _items[index] = newItem;
    Map<String, Object> existing = {
      'id': productId,
      'title': item.title,
      'package': item.package,
      'company': item.company,
      'batch': item.batch,
      'mrp': item.mrp,
      'rate': item.rate,
      'ptr': item.ptr,
      'quantity': item.quantity,
      'gstPercentage': item.gstPercentage,
      'hsn': item.hsn,
      'barcode': item.barcode,
      'exp': item.exp.toString(),
      'imageUrl': item.imageUrl == null ? "" : item.imageUrl.path,
      'rack': item.rack
    };
    ShopDetailsDBHelper.updateData(
        table: 'stock', id: productId, data: existing);
    notifyListeners();
  }

  Future<void> search({String cat = 'title', String searchKey}) async {
    final dataList =
        await ShopDetailsDBHelper.search(cat: cat, searchKey: searchKey);
    _items.clear();
    _items = dataList
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

    notifyListeners();
  }

  StockItemModel searchByid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateQuantity(
      {String id, int quantity, int free, String event}) async {
    ShopDetailsDBHelper.updateQuantity(
        id: id, quantity: (quantity + free), event: 'purchase');

    notifyListeners();
  }
}
