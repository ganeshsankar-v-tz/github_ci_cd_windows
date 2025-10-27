class ProcessInwardProductNameModel {
  String? processType;
  int? productId;
  String? productName;
  String? designNo;
  int? workNo;
  int? pieces;
  int? rate;
  int? amount;
  int? quantity;

  ProcessInwardProductNameModel({
    this.processType,
    this.productId,
    this.productName,
    this.designNo,
    this.workNo,
    this.pieces,
    this.rate,
    this.amount,
    this.quantity,
  });

  ProcessInwardProductNameModel.fromJson(Map<String, dynamic> json) {
    processType = json['process_type'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    rate = json['rate'];
    amount = json['amount'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['process_type'] = processType;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['rate'] = rate;
    data['amount'] = amount;
    data['quantity'] = quantity;
    return data;
  }

  @override
  String toString() {
    return "$productName";
  }
}
