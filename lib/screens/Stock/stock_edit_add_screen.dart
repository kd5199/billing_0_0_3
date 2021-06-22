import 'package:billing_0_0_3_/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import '../../model/stock/stock_model.dart';
import 'dart:io';
import '../../widgets/stocks/image_input.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class StockEditAddScreen extends StatefulWidget {
  static const routeName = '/StockEditAddScreen';
  //const StockEditAddScreen({ Key? key }) : super(key: key);
  @override
  _StockEditAddScreenState createState() => _StockEditAddScreenState();
}

class _StockEditAddScreenState extends State<StockEditAddScreen> {
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

  final stockForm = GlobalKey<FormState>();

  StockItemModel editedStockItem = StockItemModel(
    id: null,
    title: '',
    barcode: '',
    batch: '',
    company: '',
    exp: DateTime.parse("1969-07-20 20:18:04Z"),
    ptr: 0,
    gstPercentage: 0,
    hsn: '',
    imageUrl: null,
    mrp: 0,
    package: '',
    quantity: 0,
    rack: '',
    rate: 0,
  );
  StockItemModel initValues = StockItemModel(
    id: null,
    title: '',
    barcode: '',
    batch: '',
    company: '',
    exp: DateTime.parse("1969-07-20 20:18:04Z"),
    ptr: 0,
    gstPercentage: 0,
    hsn: '',
    imageUrl: null,
    mrp: 0,
    package: '',
    quantity: 0,
    rack: '',
    rate: 0,
  );

  var isInit = true;
  var isLoading = false;
  var exists = false;
  String productId = '';
  bool scanned = false;
  bool picked = false;

  var selectedDate;
  var barcode;
  File storedImagePath;
  File pickedImagePath;

  void initState() {
    productId = null;
    super.initState();
  }

  void didChangeDependencies() {
    if (isInit) {
      productId = ModalRoute.of(context).settings.arguments as String;
      print(productId);
      if (productId != null) {
        editedStockItem = Provider.of<StockProvider>(context, listen: false)
            .searchByid(productId);
        initValues = editedStockItem;

        barcodeController.text = editedStockItem.barcode;
        expController.text = DateFormat.yMMM()
            .format(DateTime.parse(editedStockItem.exp.toString()));
        mrpController.text = editedStockItem.mrp.toString();
        rateController.text = editedStockItem.rate.toString();
        ptrController.text = editedStockItem.ptr.toString();
        gstController.text = editedStockItem.gstPercentage.toString();
        qntyController.text = editedStockItem.quantity.toString();
        scanned = true;
        picked = true;
        pickedImagePath = editedStockItem.imageUrl;
        exists = true;
      }
    }
    isInit = false;

    super.didChangeDependencies();
  }

  Future<void> saveForm() async {
    final isValid = stockForm.currentState.validate();
    if (!isValid) {
      return;
    }
    stockForm.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (productId == null) {
      Provider.of<StockProvider>(context, listen: false)
          .addToStock(item: editedStockItem, id: null);
    } else {
      try {
        Provider.of<StockProvider>(context, listen: false)
            .editStock(productId: productId, item: editedStockItem);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
      scanned = false;
      picked = false;
      exists = false;
    });
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void onSelectImage(File selectedImage) {
    {
      pickedImagePath = selectedImage;
      editedStockItem = StockItemModel(
        title: editedStockItem.title,
        barcode: editedStockItem.barcode,
        batch: editedStockItem.batch,
        company: editedStockItem.company,
        exp: editedStockItem.exp,
        gstPercentage: editedStockItem.gstPercentage,
        ptr: editedStockItem.ptr,
        hsn: editedStockItem.hsn,
        imageUrl: selectedImage,
        mrp: editedStockItem.mrp,
        package: editedStockItem.package,
        quantity: editedStockItem.quantity,
        rack: editedStockItem.rack,
        rate: editedStockItem.rate,
      );
    }
  }

  Future<void> takePicture() async {
    final imageFile =
        await ImagePicker().getImage(source: ImageSource.camera, maxWidth: 600);

    setState(() {
      if (imageFile != null) {
        storedImagePath = File(imageFile.path);
      } else {
        return;
      }
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(imageFile.path);
    final savedImage = await storedImagePath.copy('${appDir.path}/$filename');
    pickedImagePath = savedImage;

    setState(() {
      initValues = StockItemModel(
        title: editedStockItem.title,
        barcode: editedStockItem.barcode,
        batch: editedStockItem.batch,
        company: editedStockItem.company,
        exp: editedStockItem.exp,
        gstPercentage: editedStockItem.gstPercentage,
        ptr: editedStockItem.ptr,
        hsn: editedStockItem.hsn,
        imageUrl: pickedImagePath,
        mrp: editedStockItem.mrp,
        package: editedStockItem.package,
        quantity: editedStockItem.quantity,
        rack: editedStockItem.rack,
        rate: editedStockItem.rate,
      );
      editedStockItem = StockItemModel(
        title: editedStockItem.title,
        barcode: editedStockItem.barcode,
        batch: editedStockItem.batch,
        company: editedStockItem.company,
        exp: editedStockItem.exp,
        gstPercentage: editedStockItem.gstPercentage,
        ptr: editedStockItem.ptr,
        hsn: editedStockItem.hsn,
        imageUrl: pickedImagePath,
        mrp: editedStockItem.mrp,
        package: editedStockItem.package,
        quantity: editedStockItem.quantity,
        rack: editedStockItem.rack,
        rate: editedStockItem.rate,
      );
    });
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
        editedStockItem = StockItemModel(
          title: editedStockItem.title,
          barcode: editedStockItem.barcode,
          batch: editedStockItem.batch,
          company: editedStockItem.company,
          exp: selectedDate,
          gstPercentage: editedStockItem.gstPercentage,
          ptr: editedStockItem.ptr,
          hsn: editedStockItem.hsn,
          imageUrl: editedStockItem.imageUrl,
          mrp: editedStockItem.mrp,
          package: editedStockItem.package,
          quantity: editedStockItem.quantity,
          rack: editedStockItem.rack,
          rate: editedStockItem.rate,
        );
      });
    });
  }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////
  ///     BarCode scan Funtion  /////
  ///////////////////////////////////

  Future barcodeScanning() async {
    try {
      barcode = await BarcodeScanner.scan();
      setState(() {
        scanned = true;
        this.barcode = barcode;
        barcodeController.text = barcode.rawContent;
        editedStockItem = StockItemModel(
          title: editedStockItem.title,
          barcode: barcode.rawContent,
          batch: editedStockItem.batch,
          company: editedStockItem.company,
          exp: editedStockItem.exp,
          gstPercentage: editedStockItem.gstPercentage,
          ptr: editedStockItem.ptr,
          hsn: editedStockItem.hsn,
          imageUrl: editedStockItem.imageUrl,
          mrp: editedStockItem.mrp,
          package: editedStockItem.package,
          quantity: editedStockItem.quantity,
          rack: editedStockItem.rack,
          rate: editedStockItem.rate,
        );
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'No camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Stock Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: stockForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
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
                        onSaved: (value) {
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: value,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
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
                        onSaved: (value) {
                          editedStockItem = StockItemModel(
                            title: value,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
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
                        onSaved: (value) {
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: value,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
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
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: value,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
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
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: double.parse(value),
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
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
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: double.parse(value),
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
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
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: double.parse(value),
                          );
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
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.words,
                        //initialValue: initValues.quantity.toString(),
                        controller: qntyController,
                        focusNode: quantityFN,
                        decoration: InputDecoration(
                            labelText: 'Qnty(Opening)',
                            border: OutlineInputBorder(gapPadding: 5)),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(gstFN);
                          gstController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: gstController.text.length);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: int.parse(value),
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
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
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: double.parse(value),
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
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
                        onSaved: (value) {
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: value,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: editedStockItem.rack,
                            rate: editedStockItem.rate,
                          );
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
                        textCapitalization: TextCapitalization.characters,
                        initialValue: initValues.rack,
                        focusNode: rackFN,
                        decoration: InputDecoration(
                            labelText: 'Rack No',
                            border: OutlineInputBorder(gapPadding: 5)),
                        //textInputAction: TextInputAction.next,
                        /* onFieldSubmitted: (_) {
                          /* FocusScope.of(context)
                                                  .requestFocus(titleFN); */
                        }, */
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          editedStockItem = StockItemModel(
                            title: editedStockItem.title,
                            barcode: editedStockItem.barcode,
                            batch: editedStockItem.batch,
                            company: editedStockItem.company,
                            exp: editedStockItem.exp,
                            gstPercentage: editedStockItem.gstPercentage,
                            ptr: editedStockItem.ptr,
                            hsn: editedStockItem.hsn,
                            imageUrl: editedStockItem.imageUrl,
                            mrp: editedStockItem.mrp,
                            package: editedStockItem.package,
                            quantity: editedStockItem.quantity,
                            rack: value,
                            rate: editedStockItem.rate,
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: barcodeController,
                        readOnly: true,
                        onTap: () {
                          barcodeScanning();
                        },
                        decoration: InputDecoration(
                            labelText: 'Barcode',
                            border: OutlineInputBorder(gapPadding: 5)),
                        /* onFieldSubmitted: (_) {
                          /* FocusScope.of(context)
                                                  .requestFocus(titleFN); */
                        }, */
                        /* validator: (value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          return null;
                        }, */
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
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      //borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade200),
                  child: initValues.imageUrl != null
                      ? Stack(children: [
                          Image.file(
                            initValues.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Center(
                            child: Column(
                              children: [
                                Center(
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    color: Colors.white,
                                    onPressed: () {
                                      takePicture();
                                    },
                                  ),
                                ),
                                Text('Add Product Image')
                              ],
                            ),
                          )
                        ])
                      : ImageInput(onSelectImage),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveForm();
                  },
                  child: Text('Save Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
