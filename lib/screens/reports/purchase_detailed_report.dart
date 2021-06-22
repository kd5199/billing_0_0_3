import 'package:billing_0_0_3_/helper/create_excelFile.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_brief.dart';
import 'package:billing_0_0_3_/providers/purchase_brief_provider.dart';
import 'package:billing_0_0_3_/widgets/reports/filter_purchase_report.dart';
import 'package:billing_0_0_3_/widgets/reports/purchase_datatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path/path.dart';

class PurchaseDetailedReport extends StatefulWidget {
  static const routeName = '/PurchaseDetailedReport';
  static bool filtered = false;
  @override
  _PurchaseDetailedReportState createState() => _PurchaseDetailedReportState();
}

class _PurchaseDetailedReportState extends State<PurchaseDetailedReport> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Details'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      /* return StatefulBuilder(builder: (context, setState) {
                        return WillPopScope(
                            onWillPop: () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cant go back!!'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return false;
                            },
                            child: FilterPurchaseReport());
                      }); */
                      return FilterPurchaseReport();
                    });
              },
              icon: Icon(Icons.filter_list_alt)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
          IconButton(
              onPressed: () {
                ExcelOperations.CreateExcelFile(
                    Provider.of<PurchaseBriefProvider>(context, listen: false)
                        .items);
              },
              icon: Icon(Icons.save_alt_outlined))
        ],
      ),
      /* PurchaseDataTable(
        dataList:
            Provider.of<PurchaseBriefProvider>(context, listen: false).items,
      ), */
      //Provider.of<PurchaseBriefProvider>(context, listen: false).fetchAndSet();

      body: FutureBuilder(
        future: Provider.of<PurchaseBriefProvider>(context, listen: false)
            .fetchAndSet(),
        initialData: Text('Loading...'),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<PurchaseBriefProvider>(
                  builder: (context, brief, _) => PurchaseDataTable(
                    dataList: brief.items,
                  ),
                );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            Provider.of<PurchaseBriefProvider>(context, listen: false)
                .fetchAndSet();
          });
        },
        label: Text('Refresh'),
        icon: Icon(Icons.refresh),
      ),
    );
  }
}
