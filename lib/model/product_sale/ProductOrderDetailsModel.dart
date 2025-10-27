class ProductOrderDetailsModel {
  String? orderNo;
  int? balanceQty;

  ProductOrderDetailsModel({
    this.orderNo,
    this.balanceQty,
  });

  ProductOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    balanceQty = json['balance_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_no'] = orderNo;
    data['balance_qty'] = balanceQty;
    return data;
  }

  @override
  String toString() {
    return "$orderNo";
  }
}
