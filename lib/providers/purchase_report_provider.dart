import 'dart:io';

import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_cart_model.dart';
import 'package:billing_0_0_3_/model/reports/report_model.dart';
import 'package:billing_0_0_3_/model/stock/stock_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseReportProvider extends ChangeNotifier {
  double grandTotalSumm = 0;
  Map<String, double> buffer = {};

  List<ReportModel> _purchaseReportItems = [];
  List<ReportModel> get purchaseReportItems {
    return [..._purchaseReportItems];
  }

  Future<void> calculateTotal() async {
    _purchaseReportItems.clear();
    var dataList =
        await DBHelper.getData(table: 'purchasebrief', col: '', key: '');
    dataList
        .map((e) => _purchaseReportItems.add(ReportModel(
              xAxis: DateFormat.MMMd().format(DateTime.parse(e['date'])),
              yAxis: e['grandtotal'],
              //color: MonthColor(DateTime.parse(e['date']).month),
            )))
        .toList();
    for (var i = 0; i < purchaseReportItems.length; i++) {
      buffer.containsKey(purchaseReportItems[i].xAxis)
          ? buffer.update(purchaseReportItems[i].xAxis,
              (value) => value + purchaseReportItems[i].yAxis)
          : buffer.putIfAbsent(
              purchaseReportItems[i].xAxis, () => purchaseReportItems[i].yAxis);
    }
    _purchaseReportItems.clear();
    buffer.forEach((key, value) {
      _purchaseReportItems
          .add(ReportModel(xAxis: key, yAxis: value, color: MonthColor(key)));
    });
    buffer.clear();
    notifyListeners();
  }

  /* Future<void> fetchnSet() async {
    var dataList =
        await DBHelper.getData(table: 'purchasebrief', col: '', key: '');
    _purchaseReportItems.clear();
    _purchaseReportItems = dataList
        .map((e) => ReportModel(
              xAxis:
                  DateFormat.MMMd().add_Hm().format(DateTime.parse(e['date'])),
              yAxis: e['grandtotal'],
              color: MonthColor(DateTime.parse(e['date']).month),
            ))
        .toList();
    notifyListeners();
  } */
}

Color MonthColor(String month) {
  switch (month.substring(month.length - 3, month.length)) {
    case 'Jan':
      return Colors.purple;
    case 'Feb':
      return Colors.purpleAccent.shade100;
    case 'Mar':
      return Colors.blue;
    case 'Apr':
      return Colors.blueAccent.shade100;
    case 'May':
      return Colors.indigo;
    case 'Jun':
      return Colors.indigoAccent.shade100;
    case 'Jul':
      return Colors.green;
    case 'Aug':
      return Colors.greenAccent.shade100;
    case 'Sept':
      return Colors.yellow;
    case 'Oct':
      return Colors.yellowAccent.shade100;
    case 'Nov':
      return Colors.orange;
    case 'Dec':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
