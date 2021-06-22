import 'dart:io';

import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/sale/sale_model.dart';
import 'package:billing_0_0_3_/model/stock/stock_model.dart';
import 'package:flutter/cupertino.dart';

class SaleCartProvider extends ChangeNotifier {
  Map<String, SaleCartItemModel> _saleCartItems = {};
  Map<String, SaleCartItemModel> get saleCartItems {
    return {..._saleCartItems};
  }

  Future<String> addToCart(String id) async {
    final dataList = await ShopDetailsDBHelper.search(cat: 'id', searchKey: id);
    //StockItemModel details = new StockItemModel();
    SaleCartItemModel details = dataList
        .map((e) => SaleCartItemModel(
            total: e['ptr'] + (e['ptr'] * (e['gstPercentage'] / 100)),
            productId: e['id'],
            amount: e['ptr'],
            discountSolo: 0,
            free: 0,
            gstValue: e['ptr'] * (e['gstPercentage'] / 100),
            taxable: e['ptr'],
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
            saleQuantity: e['quantity'],
            rack: e['rack'],
            rate: e['rate']))
        .toList()[0];
    if (saleCartItems.containsKey(id)) {
      return "Item exists in cart!!";
    } else {
      _saleCartItems.putIfAbsent(id, () => details);
      notifyListeners();
      return "Success!!";
    }
  }

  void updateQuantity(String id, int saleQuantity) {
    _saleCartItems.update(
        id,
        (details) => SaleCartItemModel(
            barcode: details.barcode,
            batch: details.batch,
            rack: details.rack,
            /* cgst: details.cgst,
            igst: details.igst,
            
            sgst: details.sgst, */
            //cgst: (details.rate*(details.gstPercentage/100))/2,
            company: details.company,
            discountSolo: details.discountSolo,
            exp: details.exp,
            free: details.free,
            gstPercentage: details.gstPercentage,
            amount: details.ptr * saleQuantity,
            //gstType: details.gstType,
            gstValue: (details.rate * saleQuantity) *
                (1 - (details.discountSolo / 100)) *
                (details.gstPercentage / 100),
            hsn: details.hsn,
            //igst: details.igst,
            imageUrl: details.imageUrl,
            //invoiceDate: details.invoiceDate,
            //invoiceNo: details.invoiceNo,
            mrp: details.mrp,
            package: details.package,
            productId: id,
            ptr: details.ptr,
            saleQuantity: saleQuantity,
            rate: details.rate,
            //sgst: details.sgst,

            taxable: (details.rate * saleQuantity) *
                (1 - (details.discountSolo / 100)),
            title: details.title,
            total: (details.rate * saleQuantity) *
                    (1 - (details.discountSolo / 100)) +
                ((details.rate * saleQuantity) *
                    (1 - (details.discountSolo / 100)) *
                    (details.gstPercentage / 100))));
    notifyListeners();
  }

  void updateFreeQuantity(String id, int free) {
    _saleCartItems.update(
        id,
        (details) => SaleCartItemModel(
            barcode: details.barcode,
            batch: details.batch,
            rack: details.rack,
            /* cgst: details.cgst,
            igst: details.igst,
            
            sgst: details.sgst, */
            //cgst: (details.rate*(details.gstPercentage/100))/2,
            company: details.company,
            discountSolo: details.discountSolo,
            exp: details.exp,
            free: free,
            gstPercentage: details.gstPercentage,
            amount: details.ptr * details.saleQuantity,
            //gstType: details.gstType,
            gstValue: (details.rate * details.saleQuantity) *
                (1 - (details.discountSolo / 100)) *
                (details.gstPercentage / 100),
            hsn: details.hsn,
            //igst: details.igst,
            imageUrl: details.imageUrl,
            //invoiceDate: details.invoiceDate,
            //invoiceNo: details.invoiceNo,
            mrp: details.mrp,
            package: details.package,
            productId: id,
            ptr: details.ptr,
            saleQuantity: details.saleQuantity,
            rate: details.rate,
            //sgst: details.sgst,

            taxable: (details.rate * details.saleQuantity) *
                (1 - (details.discountSolo / 100)),
            title: details.title,
            total: (details.rate * details.saleQuantity) *
                    (1 - (details.discountSolo / 100)) +
                ((details.rate * details.saleQuantity) *
                    (1 - (details.discountSolo / 100)) *
                    (details.gstPercentage / 100))));
    notifyListeners();
  }

  void updateDiscount(String id, double discount) {
    _saleCartItems.update(
        id,
        (details) => SaleCartItemModel(
            barcode: details.barcode,
            batch: details.batch,
            rack: details.rack,
            /* cgst: details.cgst,
            igst: details.igst,
            
            sgst: details.sgst, */
            //cgst: (details.rate*(details.gstPercentage/100))/2,
            company: details.company,
            discountSolo: discount,
            exp: details.exp,
            free: details.free,
            gstPercentage: details.gstPercentage,
            amount: details.ptr * details.saleQuantity,
            //gstType: details.gstType,
            gstValue: (details.rate * details.saleQuantity) *
                (1 - (discount / 100)) *
                (details.gstPercentage / 100),
            hsn: details.hsn,
            //igst: details.igst,
            imageUrl: details.imageUrl,
            //invoiceDate: details.invoiceDate,
            //invoiceNo: details.invoiceNo,
            mrp: details.mrp,
            package: details.package,
            productId: id,
            ptr: details.ptr,
            saleQuantity: details.saleQuantity,
            rate: details.rate,
            //sgst: details.sgst,

            taxable:
                (details.rate * details.saleQuantity) * (1 - (discount / 100)),
            title: details.title,
            total: (details.rate * details.saleQuantity) *
                    (1 - (details.discountSolo / 100)) +
                ((details.rate * details.saleQuantity) *
                    (1 - (discount / 100)) *
                    (details.gstPercentage / 100))));
    notifyListeners();
  }

  void deleteFromcart(String id) {
    _saleCartItems.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  /* List<dynamic> get amountList {
    List amounts = [];
    for (var i = 0; i < saleCartItems.length; i++) {
      amounts.add(saleCartItems.values.toList()[i].saleQuantity *
          saleCartItems.values.toList()[i].ptr);
    }
    if (saleCartItems.length != 0) return amounts;
    return null;
  } */
  double get totalAmount {
    double amount = 0;
    for (var i = 0; i < saleCartItems.length; i++) {
      amount += (saleCartItems.values.toList()[i].saleQuantity *
          saleCartItems.values.toList()[i].rate);
    }
    if (saleCartItems.length != 0) return amount;
    return 0;
  }

  double get totalDiscount {
    double discount = 0;
    for (var i = 0; i < saleCartItems.length; i++) {
      discount += (saleCartItems.values.toList()[i].saleQuantity *
          saleCartItems.values.toList()[i].ptr *
          (saleCartItems.values.toList()[i].discountSolo / 100));
    }
    if (saleCartItems.length != 0) return discount;
    return 0;
  }

  double get totalTaxable {
    double taxable = 0;
    for (var i = 0; i < saleCartItems.length; i++) {
      taxable += (saleCartItems.values.toList()[i].taxable);
    }
    if (saleCartItems.length != 0) return taxable;
    return 0;
  }

  double get totalGstValue {
    double gstValue = 0;
    for (var i = 0; i < saleCartItems.length; i++) {
      gstValue += (saleCartItems.values.toList()[i].gstValue);
    }
    if (saleCartItems.length != 0) return gstValue;
    return 0;
  }

  double get grandTotal {
    double amount = 0;
    for (var i = 0; i < saleCartItems.length; i++) {
      amount += (saleCartItems.values.toList()[i].total);
    }
    if (saleCartItems.length != 0) return amount;
    return 0;
  }

  void clearItems() {
    _saleCartItems.clear();
    notifyListeners();
  }

  List<dynamic> get amountList {
    List amounts = [];
    for (var i = 0; i < saleCartItems.length; i++) {
      amounts.add(saleCartItems.values.toList()[i].saleQuantity *
          saleCartItems.values.toList()[i].ptr);
    }
    if (saleCartItems.length != 0) return amounts;
    return null;
  }

  List<dynamic> get discountList {
    List amounts = [];
    for (var i = 0; i < saleCartItems.length; i++) {
      amounts.add(saleCartItems.values.toList()[i].saleQuantity *
          saleCartItems.values.toList()[i].ptr *
          (saleCartItems.values.toList()[i].discountSolo / 100));
    }
    if (saleCartItems.length != 0) return amounts;
    return null;
  }
}
