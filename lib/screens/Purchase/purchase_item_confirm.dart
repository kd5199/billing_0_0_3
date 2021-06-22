import 'package:billing_0_0_3_/model/stock/stock_model.dart';
import 'package:billing_0_0_3_/providers/purchase_cart_provider.dart';
import 'package:billing_0_0_3_/providers/stock_provider.dart';
import 'package:billing_0_0_3_/widgets/common/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PurchaseItemConfirm extends StatefulWidget {
  static const routeName = '/PurchaseItemConfirm';

  @override
  _PurchaseItemConfirmState createState() => _PurchaseItemConfirmState();
}

class _PurchaseItemConfirmState extends State<PurchaseItemConfirm> {
  final titleFN = FocusNode();
  final packageFN = FocusNode();
  final batchFN = FocusNode();
  final mrpFN = FocusNode();
  final ptrFN = FocusNode();
  final rateFN = FocusNode();
  final gstFN = FocusNode();
  final quantityFN = FocusNode();
  final rackFN = FocusNode();
  final hsnFN = FocusNode();
  final barcodeController = TextEditingController();
  final expController = TextEditingController();
  final mrpController = TextEditingController();
  final ptrController = TextEditingController();
  final rateController = TextEditingController();
  final gstController = TextEditingController();
  final qntyController = TextEditingController();

  final cartConfirmForm = GlobalKey<FormState>();

  //var editedValues = new StockItemModel();
  var initValues = new StockItemModel();
  var newId = '';
  var isInit = true;
  bool picked = false;
  bool readOnly = true;
  String productId;
  var selectedDate;

  void didChangeDependencies() {
    if (isInit) {
      productId = ModalRoute.of(context).settings.arguments as String;
      print(productId);
      if (productId != null)
        initValues = Provider.of<StockProvider>(context).searchByid(productId);
      expController.text = DateFormat.yMMM().format(initValues.exp);
      mrpController.text = initValues.mrp.toStringAsFixed(2);
      ptrController.text = initValues.ptr.toStringAsFixed(2);
      rateController.text = initValues.rate.toStringAsFixed(2);
      qntyController.text = initValues.quantity.toStringAsFixed(2);
      gstController.text = initValues.gstPercentage.toString();
    }
    isInit = false;

    super.didChangeDependencies();
  }

  Future<void> saveForm() async {
    final isValid = cartConfirmForm.currentState.validate();
    if (!isValid) {
      return;
    }
    cartConfirmForm.currentState.save();
    if (!readOnly) {
      newId = DateTime.now().toString();
      Provider.of<StockProvider>(context, listen: false)
          .addToStock(item: initValues, id: newId);
      Provider.of<PurchaseCartProvider>(context, listen: false)
          .addToCart(newId);
    } else {
      FocusScope.of(context).unfocus();
      Provider.of<PurchaseCartProvider>(context, listen: false)
          .addToCart(productId);
    }
    Navigator.of(context).pop();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////
  ///  Exp Date picker Funtion  /////
  ///////////////////////////////////

  void expiryDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
        picked = true;
        print(selectedDate);
        expController.text = DateFormat.yMMM().format(selectedDate).toString();
        FocusScope.of(context).requestFocus(FocusNode());
        initValues.exp = selectedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Purchase Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: cartConfirmForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        readOnly: true,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        initialValue: initValues.company,
                        decoration: InputDecoration(
                            labelText: 'Company',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(titleFN);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        readOnly: true,
                        textCapitalization: TextCapitalization.words,
                        initialValue: initValues.title,
                        focusNode: titleFN,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Product Name',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(packageFN);
                        },
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
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        readOnly: true,
                        textCapitalization: TextCapitalization.characters,
                        initialValue: initValues.package,
                        focusNode: packageFN,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: 'Package',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(batchFN);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        readOnly: readOnly,
                        textCapitalization: TextCapitalization.characters,
                        initialValue: initValues.batch,
                        focusNode: batchFN,
                        decoration: InputDecoration(
                            labelText: 'Batch',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(mrpFN);
                          mrpController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: mrpController.text.length);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          initValues.batch = value;
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        readOnly: readOnly,
                        keyboardType: TextInputType.number,
                        //initialValue: initValues.mrp.toString(),
                        focusNode: mrpFN,
                        controller: mrpController,
                        decoration: InputDecoration(
                            labelText: 'MRP',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(ptrFN);
                          ptrController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: ptrController.text.length);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          initValues.mrp = double.parse(value);
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        readOnly: readOnly,
                        keyboardType: TextInputType.number,
                        //initialValue: initValues.ptr.toString(),
                        focusNode: ptrFN,
                        controller: ptrController,
                        decoration: InputDecoration(
                            labelText: 'PTR',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(rateFN);
                          rateController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: rateController.text.length);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          initValues.ptr = double.parse(value);
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        readOnly: readOnly,
                        keyboardType: TextInputType.number,
                        //initialValue: initValues.rate.toString(),
                        focusNode: rateFN,
                        controller: rateController,
                        decoration: InputDecoration(
                            labelText: 'Rate',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(quantityFN);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          initValues.rate = double.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: TextFormField(
                        readOnly: readOnly,
                        keyboardType: TextInputType.number,
                        //initialValue: initValues.gstPercentage.toString(),
                        focusNode: gstFN,
                        controller: gstController,
                        decoration: InputDecoration(
                            labelText: 'GST(%)',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(hsnFN);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          initValues.gstPercentage = double.parse(value);
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        readOnly: true,
                        textCapitalization: TextCapitalization.characters,
                        initialValue: initValues.hsn,
                        focusNode: hsnFN,
                        decoration: InputDecoration(
                            labelText: 'HSN',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(rackFN);
                        },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: TextFormField(
                        readOnly: readOnly,
                        textCapitalization: TextCapitalization.characters,
                        initialValue: initValues.rack,
                        focusNode: rackFN,
                        decoration: InputDecoration(
                            labelText: 'Rack No',
                            border: OutlineInputBorder(gapPadding: 5)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          initValues.rack = value;
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: expController,
                        readOnly: true,
                        onTap: () {
                          expiryDatePicker();
                        },
                        //initialValue: initValues.exp.toString(),
                        decoration: InputDecoration(
                            labelText: 'Expiry Date',
                            border: OutlineInputBorder(gapPadding: 5)),
                        /* onFieldSubmitted: (_) {
                          saveForm();
                        }, */
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (readOnly == true)
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Text(
                                        'You can modify Batch, MRP, Rate, PTR, GST(%) or Expiry Date only.'),
                                    title: Text('Are you sure?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              readOnly = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('Modify')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      /* TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              SkeletonState.selectedIndex = 1;
                                            });

                                            Navigator.pushNamed(context,
                                                StockEditAddScreen.routeName,
                                                arguments: productId);
                                          },
                                          child: Text('Add Similar Product')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              SkeletonState.selectedIndex = 1;
                                            });

                                            Navigator.pushNamed(context,
                                                StockEditAddScreen.routeName,
                                                arguments: productId);
                                          },
                                          child: Text('Add New Product')), */
                                    ],
                                  );
                                });
                          },
                          child: Text('Modify Values')),
                    ElevatedButton(
                        onPressed: () {
                          saveForm();
                          SkeletonState.selectedIndex = 1;
                          /* Navigator.pushNamed(
                                context, PurchaseCart.routeName); */
                        },
                        child: Text('Proceed')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
