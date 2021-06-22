import 'dart:io';
import 'package:billing_0_0_3_/model/purchase/purchase_brief.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ExcelOperations {
  static Future<void> CreateExcelFile(
      List<PurchaseBriefModel> ListofModel) async {
    var excel =
        Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1

    /*
      * excel.link(String 'sheetName', Sheet sheetObject);
      * 
      * Any operations performed on (object of 'sheetName') or sheetObject then the operation is performed on both.
      * if 'sheetName' does not exist then it will be automatically created and linked with the sheetObject's operation.
      *
      */
    Sheet sheetObject = excel['Sheet1'];
    //excel.link('Sheet1', sheetObject);
    /* 
      * sheetObject.insertRowIterables(list-iterables, rowIndex, iterable-options?);
      * sheetObject created by calling - // Sheet sheetObject = excel['SheetName'];
      * list-iterables === list of iterables which has to be put in specific row
      * rowIndex === the row in which the iterables has to be put
      * Iterable options are optional
      */

    /// It will put the list-iterables in the 8th index row
    ///
    List header = [
      'Invoice No.',
      'Invoice Date',
      'Supplier',
      'Mode',
      'Amount',
      'CGST',
      'SGST',
      'IGST',
      'GST value'
    ];
    sheetObject.insertRowIterables(header, 0);

    List dataList = []..length = 10;
    for (var i = 0; i < ListofModel.length; i++) {
      dataList[0] = ListofModel[i].invoiceNo;
      dataList[1] = DateFormat.yMMMEd().format(ListofModel[i].invoiceDate);
      dataList[2] = ListofModel[i].supplierTitle;
      dataList[3] = ListofModel[i].mode;
      dataList[4] = ListofModel[i].grandTotal;
      dataList[5] = ListofModel[i].cgst;
      dataList[6] = ListofModel[i].sgst;
      dataList[7] = ListofModel[i].igst;
      dataList[8] = ListofModel[i].gstValue;

      sheetObject.insertRowIterables(dataList, i + 1);
    }

    // Save the Changes in file
    final Epath = getExternalStorageDirectory();
    final appDocDirectory = await getExternalStorageDirectory();

    excel.encode().then((onValue) {
      print("${appDocDirectory.path}/excel.xlsx");
      File(join("${appDocDirectory.path}/excel1.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });
  }
}
