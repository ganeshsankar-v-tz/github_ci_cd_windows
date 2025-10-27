class ProcessorDcNoIdByDetailsModel {
  int? id;
  int? processDeliveryId;
  String? processType;
  int? productId;
  int? workNo;
  int? pieces;
  int? quantity;
  int? grpNo;
  num? wages;
  num? amount;
  int? bags;
  String? productName;
  String? designNo;

  ProcessorDcNoIdByDetailsModel(
      {this.id,
      this.processDeliveryId,
      this.processType,
      this.productId,
      this.workNo,
      this.pieces,
      this.quantity,
      this.grpNo,
      this.wages,
      this.amount,
      this.bags,
      this.productName,
      this.designNo});

  ProcessorDcNoIdByDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processDeliveryId = json['process_delivery_id'];
    processType = json['process_type'];
    productId = json['product_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    quantity = json['quantity'];
    grpNo = json['grp_no'];
    wages = json['wages'];
    amount = json['amount'];
    bags = json['bags'];
    productName = json['product_name'];
    designNo = json['design_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['process_delivery_id'] = processDeliveryId;
    data['process_type'] = processType;
    data['product_id'] = productId;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['quantity'] = quantity;
    data['grp_no'] = grpNo;
    data['wages'] = wages;
    data['amount'] = amount;
    data['bags'] = bags;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    return data;
  }
}
