import 'package:billing_0_0_3_/providers/suppliers.dart';
import 'package:billing_0_0_3_/widgets/common/custom_list_item.dart';
import 'package:billing_0_0_3_/widgets/supplier/supplier_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierScreen extends StatefulWidget {
  static const routeName = '/SupplierScreen';
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  @override
  Widget build(BuildContext context) {
    //var supplier = Provider.of<SupplierProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Suppliers'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            initialData: Text('Loading...'),
            future: Provider.of<SupplierProvider>(context).fetchNset(),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<SupplierProvider>(
                        builder: (ctx, supplier, _) => ListView.builder(
                            itemCount: supplier.items.length,
                            itemBuilder: (ctx, index) {
                              return CustomListItem(
                                deleteFunction: () {
                                  supplier.delete(supplier.items[index].id);
                                },
                                editFunction: null,
                                id: supplier.items[index].id,
                                imageUrl: null,
                                title: supplier.items[index].title,
                                subtitle1: supplier.items[index].address,
                                subtitle2: supplier.items[index].gstin,
                              );
                            }))),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.store_outlined,
          ),
          onPressed: () {
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                //backgroundColor: Colors.black,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext ctx) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: SupplierEditAddForm(),
                  );
                });
          },
        ));
  }
}
