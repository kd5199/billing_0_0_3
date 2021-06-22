import 'package:billing_0_0_3_/model/doctor/doctor_model.dart';
import 'package:billing_0_0_3_/providers/doctor_provider.dart';
import 'package:billing_0_0_3_/widgets/common/custom_list_item.dart';
import 'package:billing_0_0_3_/widgets/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
var docColntroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Doctor'),
          centerTitle: true,
        ),
        drawer: AppDrawerWidget(),
        body: FutureBuilder(
          initialData: Center(
            child: Center(
              child: Text('Loading...'),
            ),
          ),
          future: Provider.of<DoctorProvider>(context).fetchNSet(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<DoctorProvider>(
                  builder: (context, docprovider, _) => ListView.builder(
                    itemCount: docprovider.items.length,
                    itemBuilder: (context, index) =>
                        CustomListItem(title: docprovider.items[index].title),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: (context) => SimpleDialog(
              title: Text('Add Doctor'),
              children: [TextField(
                decoration: InputDecoration(hintText: "Doctor Name"),
                controller: docColntroller,
                keyboardType: TextInputType.text,
                
                onSubmitted: (value){
                  if(value.isEmpty)return;
                  Provider.of<DoctorProvider>(context).addDoc(DoctorModel(title: value));
                  Navigator.pop(context);
                },
              )],
            ),)
          },
          child: Icon(Icons.person_add),
        ));
  }
}
