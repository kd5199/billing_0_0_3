import 'package:billing_0_0_3_/providers/stock_provider.dart';
import 'package:billing_0_0_3_/screens/Stock/stock_edit_add_screen.dart';
import 'package:billing_0_0_3_/widgets/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/custom_list_item.dart';

class Stock extends StatelessWidget {
  //const Stock({ Key? key }) : super(key: key);
  DateTime now = DateTime.now();
  //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawerWidget(),
      appBar: AppBar(
        title: Text('Stock'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: Text('Loading....'),
          future:
              Provider.of<StockProvider>(context, listen: false).fetchAndSet(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<StockProvider>(
                  builder: (ctx, stockProvider, _) =>
                      stockProvider.items.length == 0
                          ? Center(child: Text('noting to show'))
                          : ListView.builder(
                              itemCount: stockProvider.items.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: ((ctx, index) {
                                return CustomListItem(
                                  deleteFunction: () {
                                    stockProvider.deleteFromStock(
                                        stockProvider.items[index].id);
                                  },
                                  editFunction: () {
                                    print('edit');
                                    print(stockProvider.items[index].id);
                                    Navigator.of(context).pushNamed(
                                        StockEditAddScreen.routeName,
                                        arguments:
                                            stockProvider.items[index].id);
                                  },
                                  id: stockProvider.items[index].id,
                                  imageUrl: stockProvider.items[index].imageUrl,
                                  subtitle1: stockProvider.items[index].company,
                                  subtitle2:
                                      'Expiry Date : ${DateFormat.yMMM().format(DateTime.parse(stockProvider.items[index].exp.toString()))}',
                                  subtitle3:
                                      'Stock Quantity : ${stockProvider.items[index].quantity}',
                                  title: stockProvider.items[index].title,
                                  trailing1:
                                      '₹ ${stockProvider.items[index].mrp.toStringAsFixed(2)}',
                                );
                              }),
                            ))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, StockEditAddScreen.routeName);
        },
      ),
    );
  }
}
