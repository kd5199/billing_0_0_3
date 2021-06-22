import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_brief.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_cart_model.dart';
import 'package:billing_0_0_3_/model/purchase/purchase_details_model.dart';
import 'package:billing_0_0_3_/model/supplier/supplier_model.dart';
import 'package:billing_0_0_3_/providers/purchase_brief_provider.dart';
import 'package:billing_0_0_3_/providers/purchase_cart_provider.dart';
import 'package:billing_0_0_3_/providers/purchase_details_provider.dart';
import 'package:billing_0_0_3_/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PurchaseConfirm extends StatefulWidget {
  static const routeName = '/PurchaseConfirm';
  //const PurchaseConfirm({ Key? key }) : super(key: key);

  @override
  _PurchaseConfirmState createState() => _PurchaseConfirmState();
}

class _PurchaseConfirmState extends State<PurchaseConfirm> {
  bool central = true;
  bool local = false;
  bool cash = true;
  bool credit = false;
  bool picked = false;

  String supplierId = '';
  var selectedDate;
  var supplierNameController = TextEditingController();
  var invoiceDateController = TextEditingController();
  var invoiceNoConttoller = TextEditingController();

  var supplierDetails = SupplierModel();
  var purchaseDetails = PurchaseDetailsModel();
  var purchaseBrief = PurchaseBriefModel();
  var purchaseConfirmForm = GlobalKey<FormState>();
  var cartProvider;

  List<PurchaseCartItemModel> cartItems = [];

  void invDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
        picked = true;
        print(selectedDate);
        invoiceDateController.text =
            DateFormat.yMMM().format(selectedDate).toString();
        FocusScope.of(context).requestFocus(FocusNode());
      });
    });
  }

  Future<List> search(String title) async {
    ////print('entered search');

    final dataList = await ShopDetailsDBHelper.search(
        table: 'supplier', cat: 'title', searchKey: title);
    List<SupplierModel> item;
    item = dataList
        .map((e) => SupplierModel(
            id: e['id'],
            title: e['title'],
            address: e['address'],
            gstin: e['gstin']))
        .toList();
    return List.generate(item.length, (index) {
      return {
        'title': item[index].title,
        'address': item[index].address,
        'gstin': item[index].gstin,
        'id': item[index].id,
      };
    });
  }

  void saveForm() {
    final isValid = purchaseConfirmForm.currentState.validate();
    if (!isValid) {
      return;
    }
    purchaseConfirmForm.currentState.save();
    DateTime now = DateTime.now();

    for (var i = 0;
        i <
            Provider.of<PurchaseCartProvider>(context, listen: false)
                .cartItems
                .length;
        i++) {
      purchaseDetails = PurchaseDetailsModel(
        barcode: cartItems[i].barcode,
        batch: cartItems[i].batch,
        //cgst: cartItems,
        //igst: ,
        //sgst: ,
        company: cartItems[i].company,
        date: now,
        discountOverall: 0,
        discountSolo: cartItems[i].discountSolo,
        exp: cartItems[i].exp,
        free: cartItems[i].free,
        gstPercentage: cartItems[i].gstPercentage,
        gstType: central
            ? 'Central'
            : local
                ? 'Local'
                : null,
        hsn: cartItems[i].hsn,
        imageUrl: cartItems[i].imageUrl,
        invoiceDate: selectedDate,
        invoiceNo: invoiceNoConttoller.text,
        gstValue: cartItems[i].gstValue,
        mode: cash
            ? 'Cash'
            : credit
                ? 'Credit'
                : null,
        mrp: cartItems[i].mrp,
        package: cartItems[i].package,
        productId: cartItems[i].productId,
        ptr: cartItems[i].ptr,
        quantity: cartItems[i].quantity,
        rate: cartItems[i].rate,
        supplierId: supplierId,
        supplierTitle: supplierNameController.text,
        taxable: cartItems[i].taxable,
        title: cartItems[i].title,

        total: cartItems[i].total,
      );

      Provider.of<PurchaseDetailsProvider>(context, listen: false)
          .addEntry(purchaseDetails);

      Provider.of<StockProvider>(context, listen: false).updateQuantity(
          id: cartItems[i].productId,
          quantity: cartItems[i].quantity,
          free: cartItems[i].free);
    }
    Provider.of<PurchaseDetailsProvider>(context, listen: false)
        .SgstCgstIgstTotal(now.toString());
    purchaseBrief = PurchaseBriefModel(
        supplierId: supplierId,
        date: now,
        grandTotal: cartProvider.grandTotal,
        gstType: central ? 'Central' : 'Local',
        id: now.toString(),
        gstValue: cartProvider.totalGstValue,
        invoiceDate: selectedDate,
        invoiceNo: invoiceNoConttoller.text,
        mode: cash ? 'Cash' : 'Credit',
        supplierTitle: supplierNameController.text,
        taxable: cartProvider.totalTaxable,
        cgst: Provider.of<PurchaseDetailsProvider>(context, listen: false)
            .cgstTotalG,
        sgst: Provider.of<PurchaseDetailsProvider>(context, listen: false)
            .sgstTotalG,
        igst: Provider.of<PurchaseDetailsProvider>(context, listen: false)
            .igstTotalG,
        subTotal: cartProvider.totalAmount,
        discountOverall: 0);

    Provider.of<PurchaseBriefProvider>(context, listen: false)
        .addEntry(purchaseBrief);

    setState(() {
      picked = false;
    });
    FocusScope.of(context).unfocus();
    Provider.of<PurchaseCartProvider>(context, listen: false).clearItems();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<PurchaseCartProvider>(context);
    cartItems = cartProvider.cartItems.values.toList();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: purchaseConfirmForm,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: supplierNameController,
                      //autofocus: true,
                      //style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          labelText: 'Supplier',
                          border: OutlineInputBorder(gapPadding: 5))),
                  suggestionsCallback: (pattern) async {
                    ////print(pattern);
                    return await search(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    ////print('itembuilder');
                    return ListTile(
                      title: Text(suggestion['title']),
                      subtitle: Text(suggestion['address']),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    supplierNameController.text = suggestion['title'];
                    supplierId = suggestion['id'];
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      //padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: invoiceNoConttoller,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                            labelText: 'Invoice No.',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      //padding: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: invoiceDateController,
                        readOnly: true,
                        onTap: () {
                          //OPEN Search ahead screen
                          invDatePicker();
                        },
                        decoration: InputDecoration(
                            labelText: 'Invoice Date',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: ToggleSwitch(
                  minWidth: 100,
                  initialLabelIndex: 0,
                  //minHeight: 30,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  icons: [Icons.account_balance, Icons.store_mall_directory],
                  activeBgColors: [Colors.blue, Colors.pink],
                  labels: ['Central', 'Local'],
                  onToggle: (index) {
                    if (index == 0) {
                      central = true;
                      local = false;
                    } else {
                      local = true;
                      central = false;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: ToggleSwitch(
                  minWidth: 100,
                  //minHeight: 30,
                  initialLabelIndex: 0,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  icons: [Icons.attach_money, Icons.money_off],
                  activeBgColors: [Colors.blue, Colors.pink],
                  labels: ['Cash', 'Credit'],
                  onToggle: (index) {
                    if (index == 0) {
                      cash = true;
                      credit = false;
                    } else {
                      credit = true;
                      cash = false;
                    }
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: () {
                        saveForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Purchase Saved Successfully!!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text('Save Purchase')))
            ],
          ),
        ),
      ),
    );
  }
}
