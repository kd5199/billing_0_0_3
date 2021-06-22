import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_details_model.dart';
import 'package:flutter/cupertino.dart';

class PurchaseDetailsProvider extends ChangeNotifier {
  List<PurchaseDetailsModel> _items = [];
  List<PurchaseDetailsModel> get items {
    return [..._items];
  }

  double sgstTotal = 0;
  double subTotal = 0;
  double cgstTotal = 0;
  double igstTotal = 0;

  void addEntry(PurchaseDetailsModel details) {
    DBHelper.insertData(table: 'purchasedetails', data: {
      'supplierId': details.supplierId,
      'supplierTitle': details.supplierTitle,
      'discountOverall': details.discountOverall,
      'mode': details.mode,
      'invoiceNo': details.mode,
      'invoiceDate': details.invoiceDate.toString(),
      'date': details.date.toString(),
      'productId': details.productId,
      'package': details.package,
      'title': details.title,
      'quantity': details.quantity,
      'mrp': details.mrp,
      'ptr': details.ptr,
      'rate': details.rate,
      'free': details.free,
      'batch': details.batch,
      'exp': details.exp.toString(),
      'gstPercentage': details.gstPercentage,
      'gstType': details.gstType,
      'cgst': details.gstType == 'central' ? 0 : details.gstValue / 2,
      'sgst': details.gstType == 'central' ? 0 : details.gstValue / 2,
      'igst': details.gstType == 'central' ? details.gstValue : 0,
      'gstValue': details.gstPercentage,
      'taxable': details.taxable,
      'total': details.total,
      'discountSolo': details.discountSolo,
      'company': details.company,
      'barcode': details.barcode,
      'hsn': details.hsn,
      'imageUrl': details.imageUrl
    });
    notifyListeners();
  }

  Future<void> SgstCgstIgstTotal(String dateId) async {
    _items.clear();
    var dataList = await DBHelper.getData(
      col: 'date',
      table: 'purchasedetails',
      key: dateId,
    );
    dataList.map((e) => _items.add(PurchaseDetailsModel(
        barcode: e['barcode'],
        batch: e['batch'],
        cgst: e['cgst'],
        igst: e['igst'],
        sgst: e['sgst'],
        company: e['company'],
        date: DateTime.parse(e['date']),
        discountOverall: e['discountOverall'],
        discountSolo: e['discountSolo'],
        exp: DateTime.parse(e['exp']),
        free: e['free'],
        gstPercentage: e['gstPercentage'],
        gstType: e['gstType'],
        hsn: e['hsn'],
        imageUrl: e['imageUrl'],
        invoiceDate: e['invoiceDate'],
        invoiceNo: e['invoiceNo'],
        gstValue: e['gstValue'],
        mode: e['mode'],
        mrp: e['mrp'],
        package: e['package'],
        productId: e['productId'],
        ptr: e['ptr'],
        quantity: e['quanity'],
        rate: e['rate'],
        supplierId: e['supplierId'],
        supplierTitle: e['supplierTitle'],
        taxable: e['taxable'],
        title: e['title'],
        total: e['total'])));

    notifyListeners();
  }

  double get sgstTotalG {
    for (var i = 0; i < items.length; i++) {
      sgstTotal += (items[i].sgst);
    }
    return sgstTotal;
  }

  double get cgstTotalG {
    for (var i = 0; i < items.length; i++) {
      cgstTotal += (items[i].cgst);
    }
    return cgstTotal;
  }

  double get igstTotalG {
    for (var i = 0; i < items.length; i++) {
      igstTotal += (items[i].igst);
    }
    return igstTotal;
  }

  double get subTotalG {
    for (var i = 0; i < items.length; i++) {
      subTotal += (items[i].total);
    }
    return subTotal;
  }
}
