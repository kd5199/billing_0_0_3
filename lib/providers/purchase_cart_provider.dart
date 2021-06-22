import 'dart:io';

import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_cart_model.dart';
import 'package:billing_0_0_3_/model/stock/stock_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PurchaseCartProvider extends ChangeNotifier {
  Map<String, PurchaseCartItemModel> _cartItems = {};
  Map<String, PurchaseCartItemModel> get cartItems {
    return {..._cartItems};
  }

  Future<void> addToCart(String id) async {
    final dataList = await ShopDetailsDBHelper.search(cat: 'id', searchKey: id);
    //StockItemModel details = new StockItemModel();
    StockItemModel details = dataList
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
        .toList()[0];

    if (!_cartItems.containsKey(details.id)) {
      _cartItems.putIfAbsent(
          details.id,
          () => PurchaseCartItemModel(
                barcode: details.barcode,
                batch: details.batch,
                //cgst: (details.rate*(details.gstPercentage/100))/2,
                company: details.company,
                discountSolo: 0,
                exp: details.exp,
                free: 0,
                gstPercentage: details.gstPercentage,
                //gstType: details.gstType,
                gstValue: details.rate * (details.gstPercentage / 100),
                hsn: details.hsn,
                //igst: details.igst,
                imageUrl: details.imageUrl.path,
                //invoiceDate: details.invoiceDate,
                //invoiceNo: details.invoiceNo,
                mrp: details.mrp,
                package: details.package,
                productId: details.id,
                ptr: details.ptr,
                quantity: 1,
                rate: details.rate,
                //sgst: details.sgst,
                taxable: details.rate,
                title: details.title,
                total: details.rate +
                    (details.rate * (details.gstPercentage / 100)),
              ));
    }
    notifyListeners();
  }

  void updateQuantity(String id, int purchaseQuantity) {
    _cartItems.update(
        id,
        (details) => PurchaseCartItemModel(
            barcode: details.barcode,
            batch: details.batch,
            //cgst: (details.rate*(details.gstPercentage/100))/2,
            company: details.company,
            discountSolo: details.discountSolo,
            exp: details.exp,
            free: details.free,
            gstPercentage: details.gstPercentage,
            //gstType: details.gstType,
            gstValue: (details.rate * purchaseQuantity) *
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
            quantity: purchaseQuantity,
            rate: details.rate,
            //sgst: details.sgst,
            taxable: (details.rate * purchaseQuantity) *
                (1 - (details.discountSolo / 100)),
            title: details.title,
            total: (details.rate * purchaseQuantity) *
                    (1 - (details.discountSolo / 100)) +
                ((details.rate * purchaseQuantity) *
                    (1 - (details.discountSolo / 100)) *
                    (details.gstPercentage / 100))));
    notifyListeners();
  }

  void updateFreeQuantity(String id, int free) {
    _cartItems.update(
        id,
        (details) => PurchaseCartItemModel(
            barcode: details.barcode,
            batch: details.batch,
            //cgst: (details.rate*(details.gstPercentage/100))/2,
            company: details.company,
            discountSolo: details.discountSolo,
            exp: details.exp,
            free: free,
            gstPercentage: details.gstPercentage,
            //gstType: details.gstType,
            gstValue: (details.rate * details.quantity) *
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
            quantity: details.quantity,
            rate: details.rate,
            //sgst: details.sgst,
            taxable: (details.rate * details.quantity) *
                (1 - (details.discountSolo / 100)),
            title: details.title,
            total: (details.rate * details.quantity) *
                    (1 - (details.discountSolo / 100)) +
                ((details.rate * details.quantity) *
                    (1 - (details.discountSolo / 100)) *
                    (details.gstPercentage / 100))));
    notifyListeners();
  }

  void updateDiscount(String id, double discount) {
    _cartItems.update(
        id,
        (details) => PurchaseCartItemModel(
            barcode: details.barcode,
            batch: details.batch,
            //cgst: (details.rate*(details.gstPercentage/100))/2,
            company: details.company,
            discountSolo: discount,
            exp: details.exp,
            free: details.free,
            gstPercentage: details.gstPercentage,
            //gstType: details.gstType,
            gstValue: (details.rate * details.quantity) *
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
            quantity: details.quantity,
            rate: details.rate,
            //sgst: details.sgst,
            taxable: (details.rate * details.quantity) * (1 - (discount / 100)),
            title: details.title,
            total: (details.rate * details.quantity) * (1 - (discount / 100)) +
                ((details.rate * details.quantity) *
                    (1 - (discount / 100)) *
                    (details.gstPercentage / 100))));
    notifyListeners();
  }

  void deleteFromcart(String id) {
    _cartItems.removeWhere((key, value) => key == id);
    notifyListeners();
  }

  List<dynamic> get amountList {
    List amounts = [];
    for (var i = 0; i < cartItems.length; i++) {
      amounts.add(cartItems.values.toList()[i].quantity *
          cartItems.values.toList()[i].rate);
    }
    if (cartItems.length != 0) return amounts;
    return null;
  }

  List<dynamic> get discountList {
    List amounts = [];
    for (var i = 0; i < cartItems.length; i++) {
      amounts.add(cartItems.values.toList()[i].quantity *
          cartItems.values.toList()[i].rate *
          (cartItems.values.toList()[i].discountSolo / 100));
    }
    if (cartItems.length != 0) return amounts;
    return null;
  }

  double get totalAmount {
    double amount = 0;
    for (var i = 0; i < cartItems.length; i++) {
      amount += (cartItems.values.toList()[i].quantity *
          cartItems.values.toList()[i].rate);
    }
    if (cartItems.length != 0) return amount;
    return 0;
  }

  double get totalDiscount {
    double amount = 0;
    for (var i = 0; i < cartItems.length; i++) {
      amount += (cartItems.values.toList()[i].quantity *
          cartItems.values.toList()[i].rate *
          (cartItems.values.toList()[i].discountSolo / 100));
    }
    if (cartItems.length != 0) return amount;
    return 0;
  }

  double get totalTaxable {
    double amount = 0;
    for (var i = 0; i < cartItems.length; i++) {
      amount += (cartItems.values.toList()[i].taxable);
    }
    if (cartItems.length != 0) return amount;
    return 0;
  }

  double get totalGstValue {
    double amount = 0;
    for (var i = 0; i < cartItems.length; i++) {
      amount += (cartItems.values.toList()[i].gstValue);
    }
    if (cartItems.length != 0) return amount;
    return 0;
  }

  double get grandTotal {
    double amount = 0;
    for (var i = 0; i < cartItems.length; i++) {
      amount += (cartItems.values.toList()[i].total);
    }
    if (cartItems.length != 0) return amount;
    return 0;
  }

  void clearItems() {
    _cartItems.clear();
    notifyListeners();
  }
}
