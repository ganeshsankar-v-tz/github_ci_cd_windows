class JobWorkInwardProductDetailsModel {
  int? orderWorkId;
  String? orderWorkName;
  int? productId;
  String? productName;
  String? designNo;
  int? workNo;
  int? pieces;
  int? qty;
  int? rate;
  int? amount;

  JobWorkInwardProductDetailsModel(
      {this.orderWorkId,
      this.orderWorkName,
      this.productId,
      this.productName,
      this.designNo,
      this.workNo,
      this.pieces,
      this.qty,
      this.rate,
      this.amount});

  JobWorkInwardProductDetailsModel.fromJson(Map<String, dynamic> json) {
    orderWorkId = json['order_work_id'];
    orderWorkName = json['order_work_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    qty = json['qty'];
    rate = json['rate'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_work_id'] = orderWorkId;
    data['order_work_name'] = orderWorkName;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['qty'] = qty;
    data['rate'] = rate;
    data['amount'] = amount;
    return data;
  }

  @override
  String toString() {
    return "$productName";
  }
}
