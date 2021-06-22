class PurchaseBriefModel {
  final String id;
  final String supplierId;
  final String supplierTitle;
  final String invoiceNo;
  final DateTime invoiceDate;
  final DateTime date;
  final double subTotal;
  final double taxable;
  final double grandTotal;
  final double discountOverall;
  final String mode;
  final double gstValue;
  final String gstType;
  final double sgst;
  final double cgst;
  final double igst;

  PurchaseBriefModel(
      {this.discountOverall,
      this.gstType,
      this.id,
      this.mode,
      this.sgst,
      this.cgst,
      this.igst,
      this.supplierId,
      this.supplierTitle,
      this.date,
      this.invoiceDate,
      this.gstValue,
      this.invoiceNo,
      this.taxable,
      this.subTotal,
      this.grandTotal});
}
