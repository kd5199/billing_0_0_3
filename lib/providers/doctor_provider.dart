import 'package:billing_0_0_3_/helper/main_db_helper.dart';
import 'package:billing_0_0_3_/model/doctor/doctor_model.dart';
import 'package:flutter/cupertino.dart';

class DoctorProvider extends ChangeNotifier {
  List<DoctorModel> _items = [];
  List<DoctorModel> get items {
    return [..._items];
  }

  Future<void> fetchNSet() async {
    var dataList = await ShopDetailsDBHelper.getData('doctor');
    _items.clear();
    _items = dataList
        .map((e) => DoctorModel(id: e['id'], title: e['title']))
        .toList();
    notifyListeners();
  }

  Future<void> addDoc(DoctorModel item) {
    ShopDetailsDBHelper.insertData(table: 'doctor', data: {
      'id': DateTime.now().toString(),
      'title': item.title,
    });
    notifyListeners();
  }
}
