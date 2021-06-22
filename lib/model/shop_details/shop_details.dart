class ShopDetailsModel {
  final String title;
  final String address;
  final String contact;
  final String email;
  final String gstin;
  final String dlNo;

  String fYear;

  ShopDetailsModel(
      {this.address,
      this.contact,
      this.dlNo,
      this.email,
      this.fYear,
      this.gstin,
      this.title});
}
