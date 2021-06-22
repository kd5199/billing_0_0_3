import 'package:billing_0_0_3_/widgets/common/drawer.dart';
import 'package:billing_0_0_3_/widgets/reports/button_grid_report.dart';
import 'package:billing_0_0_3_/widgets/reports/button_with_container.dart';
import 'package:billing_0_0_3_/widgets/reports/purchase_summary.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  static const routeName = '/ReportsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repors'),
        centerTitle: true,
      ),
      drawer: AppDrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ReportButtonGrid(),
            Divider(
              color: Colors.amber,
            ),
            Text(
              'Charts',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonWithHiddedContainer(
                  icon: Icon(Icons.table_chart_outlined),
                  label: Text('Purchase Summary Chart'),
                  chart1: PurchaseSummaryChart()),
            )
          ],
        ),
      ),
    );
  }
}
