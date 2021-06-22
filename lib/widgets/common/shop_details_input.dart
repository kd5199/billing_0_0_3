import 'package:billing_0_0_3_/providers/shop_details.dart';
import 'package:provider/provider.dart';

import './skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopDetailsInputForm extends StatefulWidget {
  //const ShopDetailsInputForm({ Key? key }) : super(key: key);
  static const routeName = '/ShopDetailsInputForm';
  @override
  _ShopDetailsInputFormState createState() => _ShopDetailsInputFormState();
}

class _ShopDetailsInputFormState extends State<ShopDetailsInputForm> {
  final form = new GlobalKey<FormState>();
  bool isLoading = false;

  var contactFN = new FocusNode();
  var addressFN = new FocusNode();
  var emailFN = new FocusNode();
  var gstFN = new FocusNode();
  var dlFN = new FocusNode();
  var fYearFN = new FocusNode();

  void dispose() {
    contactFN.dispose();
    addressFN.dispose();
    emailFN.dispose();
    gstFN.dispose();
    dlFN.dispose();
    fYearFN.dispose();
    super.dispose();
  }

  Map<String, Object> shopDetail = {
    'title': '',
    'address': '',
    'contact': '',
    'email': '',
    'gstin': '',
    'logo': 'test.com',
    'website': 'test.com',
    'dlNo': '',
    'fYear': ''
  };

  Future<void> saveForm() async {
    final isValid = form.currentState.validate();
    if (!isValid) {
      return;
    }
    form.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<ShopDetailsProvider>(context, listen: false)
          .insertData(shopDetail);
      final isopened = await SharedPreferences.getInstance();
      isopened.setInt('isopened', 1);

      FocusScope.of(context).requestFocus(FocusNode());
      Navigator.of(context).pushNamed(Skeleton.routeName);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
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
                setState(() {
                  isLoading = false;
                });
              },
            )
          ],
        ),
      );
    }
    /* setState(() {
      isLoading = false;
      dispose();
      FocusScope.of(context).unfocus();
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Shop Name'),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(addressFN);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['title'] = value;
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: addressFN,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(contactFN);
            },
            decoration: InputDecoration(hintText: 'Address'),
            keyboardType: TextInputType.streetAddress,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['address'] = value;
            },
          ),
          TextFormField(
            textInputAction: TextInputAction.next,
            focusNode: contactFN,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(emailFN);
            },
            decoration: InputDecoration(hintText: 'Contact'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['contact'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Email'),
            textInputAction: TextInputAction.next,
            focusNode: emailFN,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(gstFN);
            },
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['email'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'GSTIN'),
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            focusNode: gstFN,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(dlFN);
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['gstin'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'D/L No.'),
            textInputAction: TextInputAction.next,
            focusNode: dlFN,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(fYearFN);
            },
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['dlNo'] = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Financial Year'),
            keyboardType: TextInputType.number,
            focusNode: fYearFN,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: ((_) {
              saveForm();
            }),
            validator: (value) {
              if (value.isEmpty) {
                return 'Mandatory';
              }
              return null;
            },
            onSaved: (value) {
              shopDetail['fYear'] = value;
            },
          ),
          isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    saveForm();
                  },
                  child: Text('Save and Proceed')),
        ],
      ),
    );
  }
}
