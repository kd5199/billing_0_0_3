import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_brief.dart';
import 'package:flutter/cupertino.dart';

class PurchaseBriefProvider extends ChangeNotifier {
  List<PurchaseBriefModel> _items = [];
  List<PurchaseBriefModel> get items {
    return [..._items];
  }

  void addEntry(PurchaseBriefModel details) {
    DBHelper.insertData(table: 'purchasebrief', data: {
      'id': details.id,
      'subtotal': details.subTotal,
      'supplierId': details.supplierId,
      'supplierTitle': details.supplierTitle,
      'discountOverall': details.discountOverall,
      'grandtotal': details.grandTotal,
      'gstValue': details.gstValue,
      'mode': details.mode,
      'invoiceNo': details.invoiceNo,
      'invoiceDate': details.invoiceDate.toString(),
      'date': details.date.toString(),
      'gstType': details.gstType,
      'cgst': details.gstType == 'central' ? 0 : details.gstValue / 2,
      'sgst': details.gstType == 'central' ? 0 : details.gstValue / 2,
      'igst': details.gstType == 'central' ? details.gstValue : 0,
      'taxable': details.taxable
    });
    notifyListeners();
  }

  Future<void> fetchAndSet() async {
    final dataList =
        await DBHelper.getData(table: 'purchasebrief', key: '', col: '');
    _items.clear();
    _items = dataList
        .map((e) => PurchaseBriefModel(
            id: e['id'],
            supplierId: e['supplierId'],
            supplierTitle: e['supplierTitle'],
            invoiceNo: e['invoiceNo'],
            invoiceDate: DateTime.parse(e['invoiceDate']),
            date: DateTime.parse(e['date']),
            subTotal: e['subtotal'],
            taxable: e['taxable'],
            grandTotal: e['grandtotal'],
            discountOverall: e['discountOverall'],
            mode: e['mode'],
            gstValue: e['gstValue'],
            gstType: e['gstType'],
            sgst: e['sgst'],
            cgst: e['cgst'],
            igst: e['igst']))
        .toList();

    notifyListeners();
  }

  Future<void> advancedSearch(
      {DateTime from, DateTime to, String mode, String supplier}) async {
    final dataList = await DBHelper.advanceSearch(
        table: 'purchasebrief',
        to: to.toString(),
        from: from.toString(),
        mode: mode,
        supplier: supplier);
    _items.clear();
    _items = dataList
        .map((e) => PurchaseBriefModel(
            id: e['id'],
            supplierId: e['supplierId'],
            supplierTitle: e['supplierTitle'],
            invoiceNo: e['invoiceNo'],
            invoiceDate: DateTime.parse(e['invoiceDate']),
            date: DateTime.parse(e['date']),
            subTotal: e['subtotal'],
            taxable: e['taxable'],
            grandTotal: e['grandtotal'],
            discountOverall: e['discountOverall'],
            mode: e['mode'],
            gstValue: e['gstValue'],
            gstType: e['gstType'],
            sgst: e['sgst'],
            cgst: e['cgst'],
            igst: e['igst']))
        .toList();

    notifyListeners();
  }
}
