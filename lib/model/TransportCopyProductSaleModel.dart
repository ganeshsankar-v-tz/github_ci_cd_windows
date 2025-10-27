class TransportCopyProductSaleModel {
  String? salesDate;
  String? salesNo;
  int? boxes;
  int? totalQty;
  dynamic totalNetAmount;
  bool isChecked = false;

  TransportCopyProductSaleModel(
      {this.salesDate,
      this.salesNo,
      this.boxes,
      this.totalQty,
      this.totalNetAmount,
      this.isChecked = false});

  TransportCopyProductSaleModel.fromJson(Map<String, dynamic> json) {
    salesDate = json['sales_date'];
    salesNo = json['sales_no'];
    boxes = json['boxes'];
    totalQty = json['total_qty'];
    totalNetAmount = json['total_net_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sales_date'] = this.salesDate;
    data['sales_no'] = this.salesNo;
    data['boxes'] = this.boxes;
    data['total_qty'] = this.totalQty;
    data['total_net_amount'] = this.totalNetAmount;
    return data;
  }
}
